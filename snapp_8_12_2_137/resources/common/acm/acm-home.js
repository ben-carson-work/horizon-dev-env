$(document).ready(function() {
  "use strict";
  
  window.ACM = {
    "setActiveView": _setActiveView,
    "activateDefaultView": _activateDefaultView,
    "showInputDialog": _showInputDialog,
    "showOptionDialog": _showOptionDialog,
    "bindData": _bindData,
    "addClickHandler": _addClickHandler,
    "useSpecialProduct": _useSpecialProduct,
    "addAccessPoint": _addAccessPoint
  };

  const BCST_SRV_CONN = "SRV-CONN";
  const BCST_WKS_CONN = "WKS-CONN";
  const BCST_STATUS_APT = "APT-STATUS";
  
  const COOKIE_MoniteredAccessPointIDs = "MoniteredAccessPointIDs";

  const HANDLERS = {};
  HANDLERS[BCST_SRV_CONN] = _onServerConnection;
  HANDLERS[BCST_WKS_CONN] = _onWorkstationConnection;
  HANDLERS[BCST_STATUS_APT] = _onAccessPointStatus;
  
  var initialized = false;
  var snpWebSocket = new SnpWebSocket({
    "onHandShake": _onHandShake,
    "onMessage": HANDLERS
  });

  _initMenu();
  _loadAccessPoints();
  
  function _initMenu() {
    var innerHTML = $("#acm-templates .menu-item").html();
    $("#acm-menu .menu-item").each(function(index, elem) {
      var $item = $(elem); 
      $item.html(innerHTML);
      $item.find(".menu-item-icon").addClass("fa-" + $item.attr("data-iconalias"));
    });
    
    ACM.addClickHandler($("#acm-menu .menu-item-add"), _onMenuClick_Add);
    ACM.addClickHandler($("#acm-menu .menu-item-remove"), _onMenuClick_Remove);
    ACM.addClickHandler($("#acm-menu .menu-item-select-all"), _onMenuClick_SelectAll);
    ACM.addClickHandler($("#acm-menu .menu-item-supervisor"), _onMenuClick_Supervisor);
    ACM.addClickHandler($("#acm-menu .menu-item-logout"), _onMenuClick_Logout);
  }
  
  function _loadAccessPoints() {
    var accessPointIDs = null;
    if (monitorWorkstationId == null) 
      accessPointIDs = getNull(getCookie(COOKIE_MoniteredAccessPointIDs));
    
    $("#apt-list").empty();
    if ((monitorWorkstationId == null) && (accessPointIDs == null)) 
      $("body").removeClass("loading");
    else {
      var reqDO = {
        Command: "SearchApt",
        SearchApt: {}
      };
      
      if (monitorWorkstationId)
        reqDO.SearchApt.MonitorWorkstationId = monitorWorkstationId;
      else
        reqDO.SearchApt.WorkstationId = accessPointIDs;
      
      vgsService("Workstation", reqDO, true, function(ansDO) {
        var error = getVgsServiceError(ansDO);
        if (error) 
          alert(error); // TODO: Handle Errors
        else {
          var list = ((ansDO.Answer || {}).SearchApt || {}).AccessPointList || [];
          for (var i=0; i<list.length; i++) 
            _renderAccessPoint(list[i]);

          if (snpWebSocket.isConnected() && initialized) {
            _handShake();
            for (var i=0; i<list.length; i++) 
              _activateStatusDispatch(list[i].ControllerWorkstationId, list[i].AccessPointId, true);
          }
        }
        
        $("body").removeClass("loading");
      });
    }
  }
  
  /**
   * Add an access point to the UI. 
   * Params: "apt" = DOAccessPointRef
   * Returns: "$apt" jquery instance of the access point UI
   */
  function _renderAccessPoint(apt) {
    var $apt = $("#acm-templates .apt").clone().appendTo("#apt-list");
    
    $apt.data("apt", apt);
    $apt.attr("data-status", "offline");
    $apt.attr("data-accesspointid", apt.AccessPointId);
    $apt.attr("data-workstationid", apt.ControllerWorkstationId);
    $apt.find(".apt-header-title").text(apt.AccessPointCode);

    $apt.find(".apt-view").trigger("view-create");
    _activateDefaultView($apt);
    
    $apt.find(".apt-tool").each(function(index, elem) {
      var $tool = $(elem);
      var iconAlias = $tool.attr("data-iconalias");
      $("<div class='acm-iconvert'/>").appendTo($tool);
      $("<i class='apt-tool-icon fas fa-" + iconAlias + "'></i>").appendTo($tool);
      
      var caption = $tool.attr("data-caption");
      if (caption) 
        $("<span class='apt-tool-caption'/>").appendTo($tool).text(itl(caption));
    });
    
    $apt.find("[data-itl]").each(function(index, elem) {
      var $elem = $(elem);
      var text = itl($elem.attr("data-itl"));
      
      var transform = $elem.attr("data-transform");
      if (transform == "uppercase")
        text = text.toUpperCase();
      else if (transform == "lowercase")
        text = text.toLowerCase();
      
      $elem.text(text);
    }); 
    
    $apt.find(".apt-header").click(function() {
      $(this).closest(".apt").toggleClass("selected");
      _refreshSelectAll();
    });
    
    return $apt;
  }
  
  function _refreshSelectAll() {
    var $apts = $("#apt-list .apt");
    var all = ($apts.length > 0) && ($apts.filter(".selected").length == $apts.length);
    $("#acm-menu .menu-item-select-all").setClass("selected", all);
  }
  
  function _updateCookies() {
    var accessPointIDs = [];
    $("#apt-list .apt").each(function(index, elem) {
      accessPointIDs.push($(elem).attr("data-accesspointid"));
    });
    setCookie(COOKIE_MoniteredAccessPointIDs, accessPointIDs.join(","), 365);
  }
  
  function _handShake() {
    console.log("_handShake()")
    var handShake = {
      StatusList: []
    };
    
    $("#apt-list .apt").each(function(index, elem) {
      handShake.StatusList.push({
        SrcWorkstationId: $(elem).attr("data-workstationid"),
        BroadcastNames: [BCST_SRV_CONN, BCST_WKS_CONN, BCST_STATUS_APT]
      });
    });
    
    snpWebSocket.sendHandShake(handShake);
  }

  function _aptKeepAliveLoop(immediateStatus) {
    console.log("_aptKeepAliveLoop - " + immediateStatus);
    if (snpWebSocket.isConnected()) {
      $("#apt-list .apt").each(function(index, elem) {
        var workstationId = $(elem).attr("data-workstationid");
        var accessPointId = $(elem).attr("data-accesspointid");
        if (workstationId)
          _activateStatusDispatch(workstationId, accessPointId, immediateStatus);
      });
    }

    setTimeout(function() {
      _aptKeepAliveLoop(false);
    }, 60000);
  }
  
  var workstationRetryMap = {};
  const dispatchRetryDelay = 1000;
  const dispatchRetryMax = 15000;
  
  function _scheduleActivateStatusDispatchRetry(workstationId, accessPointIDs) {
    console.log("_scheduleActivateStatusDispatchRetry - " + workstationId + " - " + accessPointIDs);
    setTimeout(function() {
      var retryUntil = strToIntDef(workstationRetryMap[workstationId], 0);
      if (retryUntil > nowMillis()) {
        _doActivateStatusDispatch(workstationId, accessPointIDs, true);
        _scheduleActivateStatusDispatchRetry(workstationId, accessPointIDs);
      }
    }, dispatchRetryDelay);
  }

  function _activateStatusDispatch(workstationId, accessPointIDs, immediateStatus) {
    _doActivateStatusDispatch(workstationId, accessPointIDs, immediateStatus);

    if (immediateStatus === true) {
      workstationRetryMap[workstationId] = nowMillis() + dispatchRetryMax;
      _scheduleActivateStatusDispatchRetry(workstationId, accessPointIDs);
    }
  }
  
  function _doActivateStatusDispatch(workstationId, accessPointIDs, immediateStatus) {
    console.log("_doActivateStatusDispatch - " + workstationId + " " + accessPointIDs + " - " + immediateStatus);
    vgsBroadcastCommand(false, workstationId, "AccessPoint", {
      Command: "ActivateStatusDispatch",
      ActivateStatusDispatch: {
        AccessPointIDs: accessPointIDs,
        ValidityMin: 2,
        ImmediateStatus: immediateStatus
      }
    });
  }
  
  function _onHandShake() {
    console.log("_onHandShake");
    if (!initialized) {
      initialized = true;
      _aptKeepAliveLoop(true);
      _handShake();
    }
  }
  
  function _onServerConnection(event, header, message) {
    console.log("_onServerConnection - " + JSON.stringify(header));
  }
  
  function _onWorkstationConnection(event, header, message) {
    console.log("_onWorkstationConnection - " + JSON.stringify(header) + " " + JSON.stringify(message));
    console.log(message);
    
    var $apts = $(".apt[data-workstationid='" + header.WorkstationId + "']");
    if (message.Open != true)
      $apts.attr("data-status", "offline"); 
    else {
      var accessPointIDs = [];
      $apts.each(function(index, elem) {
        accessPointIDs.push($(elem).attr("data-accesspointid"));
      });
      _activateStatusDispatch(header.WorkstationId, accessPointIDs, true);
    }
  }
  
  function _onAccessPointStatus(event, header, message) {
    console.log("_onAccessPointStatus - " + JSON.stringify(header) + " " + JSON.stringify(message));
    console.log(message);
    
    workstationRetryMap[header.WorkstationId] = null;
    
    var $apt = $(".apt[data-accesspointid='" + message.AccessPointId + "']");
    $apt.data("status", message);
    $apt.attr("data-status", _decodeAptStatus(message.Status));
    ACM.bindData($apt.find(".apt-header-rot"), {"status":message});
    
    var oldDefaultViewName = $apt.attr("data-defaultviewname");
    var newDefaultViewName = _calcDefaultViewName($apt);
    if (oldDefaultViewName != newDefaultViewName)
      _activateDefaultView($apt);

    $apt.find(".apt-view").trigger("view-refresh");
  }
  
  function _decodeAptStatus(status) {
    var map = {
      10: "active",
      20: "warning",
      30: "error",
      40: "active",
      50: "active"
    };
    
    let msg = map[status];
    
    if (!msg)
      msg = "active";
    
    return msg;
  }

  function _setActiveView($apt, viewName) {
    var $view = $apt.find(".apt-view[data-view='" + viewName + "']");
    
    $apt.attr("data-view", viewName);
    $apt.find(".apt-view").addClass("hidden");
    
    if ($view.length <= 0)
      throw "Unable to find view \"" + viewName + "\"";
    $view.removeClass("hidden").trigger("view-activate");
  }
  
  function _activateDefaultView($apt) {
    let name = _calcDefaultViewName($apt);
    _setActiveView($apt, name);
    $apt.attr("data-defaultviewname", name);
  }
  
  function _calcDefaultViewName($apt) {
    const statusClosed = 0;
    const statusFree = 2;

    var status = $apt.data("status");
    if (status.EntryControl == statusClosed) {
      if (status.ExitControl == statusClosed)
        return "closed";
      else if (status.ExitControl == statusFree)
        return "exit";
    } else if (status.EntryControl == statusFree)
      return "free";
    return "main";
  } 

  function _showInputDialog(title, message, callback) {
    inputDialog(title, message, null, null, false, callback);
  }

  /**
   * Shows a dialog with a list option to be selected.
   * 
   * Parameters:
   * - "title" (string): title of the dialog
   * - "option" (array of objects): list of option to display
   *                                [{"Title":"", "iconAlias":""}]
   * - "callback" function(index, option): parameters are the "index" and the relative "option" object selected  
   */
  function _showOptionDialog(title, options, callback) {
    var $dlg = $("<div class='dlg-option'/>").appendTo("body");
    
    var $itemTemplate = $("#acm-templates .dlg-option-item");
    var options = (options) ? options : [];
    for (var i=0; i<options.length; i++) {
      var option = options[i];
      var $item = $itemTemplate.clone().appendTo($dlg);
      var $icon = $item.find(".dlg-option-item-icon");
      
      $item.attr("data-index", i);
      $item.data(option);
      $item.find(".dlg-option-item-title").text(option.title);
      $item.click(__itemClick);
      
      if (option.iconAlias)
        $icon.find(".fa").addClass("fa-" + option.iconAlias);
      else
        $icon.remove();
    }    
    
    $dlg.dialog({
      "title": title || itl("@Common.Options"),
      "width": "auto",
      "modal": true,
      "close": function() {
        $dlg.remove();
      }
    });
    
    function __itemClick() {
      if (callback) {
        var $item = $(this);
        callback(parseInt($item.attr("data-index")), $item.data());
      }
      $dlg.dialog("close");
    }
  }

  function _bindData($container, data) {
    $container.find("[data-bind]").each(function(index, elem) {
      var $elem = $(elem);
      var bind = $elem.attr("data-bind");
      if (bind) {
        var splits = bind.split(".");
        var field = data;
        for (var i=0; i<splits.length; i++) 
          field = field[splits[i]];
        
        field = __applyFormat($elem, field);
        field = __applyNullValue($elem, field);
        
        $elem.text(field);
      }
    });
    
    function __applyFormat($elem, value) {
      if (value) {
        var format = $elem.attr("data-format");
        if (format) {
          if (format == "ShortDate")
            value = formatDate(value);
          else if (format == "ShortTime")
            value = formatTime(value);
          else if (format == "ShortDateTime")
            value = formatDate(value) + " " + formatTime(value);
          else
            console.error("Invalid data binding format: " + value);
        }
      }
      
      return value;
    }
    
    function __applyNullValue($elem, value) {
      return (value) ? value : $elem.attr("data-nullvalue");
    }   
  }

  /**
   * When "selector" gets clicked, is "selector" is not disabled it calls "handler" callback
   * 
   * selector: button selector
   * handler: callback function(event, ui)
   *          ui = {
   *            $apt: jQuery object, handler to the access point container  
   *            $btn: jQuery object, handler to the clicked button  
   *          }
   */
  function _addClickHandler(selector, handler) {
    $(selector).click(function(event) {
      var $btn = $(this);
      if (!$btn.is(".disabled")) {
        var $apt = $btn.closest(".apt");
        handler(event, {
          "$btn": $btn,
          "$apt": $apt,
          "apt": $apt.data("apt")
        });
      }
    });
  }
  
  function _useSpecialProduct($apt, product, callback_OK) {
    product = product || {};
    var productDesc = "[" + product.ProductCode + "] " + product.ProductName;
    
    confirmDialog(itl("@AccessPoint.ComfirmSpecialProductUsage", productDesc), function() {
      var apt = $apt.data("apt");
      vgsBroadcastCommand(true, apt.ControllerWorkstationId, "AccessPoint", {
        Command: "UseSpecialProduct",
        UseSpecialProduct: {
          AccessPointId: apt.AccessPointId,
          ProductId: product.ProductId
        }
      }, function() {
        if (callback_OK)
          callback_OK();
      });
    });
  }
  
  function _addAccessPoint(accessPointId) {
    var reqDO = {
      Command: "SearchApt",
      SearchApt: {
        WorkstationId: accessPointId
      }
    };
    
    vgsService("Workstation", reqDO, true, function(ansDO) {
      var error = getVgsServiceError(ansDO);
      if (error) {
        alert(error); // TODO: Handle Errors
      }
      else {
        var list = ((ansDO.Answer || {}).SearchApt || {}).AccessPointList || [];
        if (list.length == 0)
          alert("Unable to find access point \"" + accessPoint + "\""); // TODO: Handle Errors
        else {
          var apt = list[0];

          _renderAccessPoint(apt);
          if (snpWebSocket.isConnected() && initialized) {
            _handShake();
            _activateStatusDispatch(apt.ControllerWorkstationId, apt.AccessPointId, true);
          }

          _updateCookies();
        }
      }
    });
  }
  
  function _supervisorLogin(uid, pwd) {
    var reqDO = {
      Command: "Login",
      Login: {
        WorkstationId: loggedWorkstationId,
        UserName: uid,
        Password: pwd,
        ActualUserAccountId: loggedUserAccountId,
        TemporaryLogin: true,
        ReturnDetails: true,
        ReturnRights: true,
        ReleaseLocks: false
      }
    };
    
    showWaitGlass();
    vgsService("Login", reqDO, false, function(ansDO) {
      $("#acm-menu .menu-item-supervisor").addClass("selected");
      supAccountId = ansDO.Answer.Login.User.AccountId;
      rights = ansDO.Answer.Login.Rights; 
      _resetOverrideAllowedTimers(true);
      hideWaitGlass();
      $(".apt-view").trigger("view-refresh");
    });
  }

  function _onMenuClick_Add() {
    asyncDialogEasy("../common/acm/acm-select-apt-dialog");
  }
  
  function _onMenuClick_Remove() {
    $("#apt-list .apt.selected").remove();
    _updateCookies();
    _handShake();
  }
  
  function _onMenuClick_SelectAll(p1, p2, p3) {
    $("#apt-list .apt").setClass("selected", !$("#acm-menu .menu-item-select-all").is(".selected"));
    _refreshSelectAll();
  }
  
  function _onMenuClick_Supervisor() {
    let $supervisor = $("#acm-menu .menu-item-supervisor");
    let selected = $supervisor.is(".selected");
    
    if (!selected) {    
      let $dlg = $("#dlg-apt-supervisor");
      var $username = $dlg.find("#Username").val("");
      var $password = $dlg.find("#Password").val("");
      
      $dlg.dialog({
        title: itl("@Common.Login"),
        width: 500,
        buttons: [
          {
            text: itl("@Common.Ok"),
            click: function() {
              _supervisorLogin($username.val(), $password.val());              
              $dlg.dialog("close");
            }
          },
          {
            text: itl("@Common.Cancel"),
            click: doCloseDialog
          }
        ]
      });
    }
    else {
      $supervisor.removeClass("selected");
      supAccountId = null;
      rights = rightsBackup;
      _resetOverrideAllowedTimers(false);
      $(".apt-view").trigger("view-refresh");
    }  
  }
  
  function _onMenuClick_Logout() {
    doLogout();
  }
  
  function _resetOverrideAllowedTimers(restart) {
    let $apts = $("#apt-list .apt");
    $apts.each(function(index, elem) { 
      let workstationId = $(elem).attr("data-workstationid");
      let accessPointId = $(elem).attr("data-accesspointid");
      if (workstationId) {
        vgsBroadcastCommand(true, workstationId, "AccessPoint", {
          Command: "ResetOverrideAllowedTimer",
          ResetOverrideAllowedTimer: {
            Restart: restart,
            AccessPointId: accessPointId
          }
        });
      }
    });
  }
  
});

