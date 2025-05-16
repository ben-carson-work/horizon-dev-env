var APT_CONTROL_COLORS = {};
APT_CONTROL_COLORS[LkSN.AccessPointControl.Closed.code] = "red";
APT_CONTROL_COLORS[LkSN.AccessPointControl.Controlled.code] = "blue";
APT_CONTROL_COLORS[LkSN.AccessPointControl.Free.code] = "green";
APT_CONTROL_COLORS[LkSN.AccessPointControl.SimRotation.code] = "orange";
  
UIMob.init("apt-monitor", function($view, params) {
  var locationList = [];
  var connected = false;
  var webSocket = null;
  
  var APT_STATUS = {};
  APT_STATUS[LkSN.AccessPointStatus.Active.code] = "active";
  APT_STATUS[LkSN.AccessPointStatus.Warning.code] = "warn";
  APT_STATUS[LkSN.AccessPointStatus.Error.code] = "error";

  $view.find(".btn-back").click(onBtnBackClick);
  
  $(document).von($view, "tabchange", onTabChange);
  $(document).von($view, EVENT_WebSocketMessage, onWebSocketMessage);
  $(document).von($view, EVENT_WebSocketConnectionChange, initWebSocket);
  
  initWorkstationTree();
  
  
  function initWorkstationTree() {
    var $spinner = UIMob.createSpinnerClone().appendTo($view.find(".data-box"));
    snpAPI("Login", "GetWorkstationTree", {
      "WorkstationType": LkSN.WorkstationType.APT.code
    })
    .finally(function() {
      $spinner.remove();
    })
    .then(function(ansDO) {
      locationList = ansDO.LocationList || [];
      
      var opAreaId = getLocalStorage("AptMonitorOpAreaId");
      var found = false;
      if (opAreaId) {
        for (var i=0; i<locationList.length; i++) {
          var loc = locationList[i];
          if (loc.OperatingAreaList) {
            for (var k=0; k<loc.OperatingAreaList.length; k++) {
              var opa = loc.OperatingAreaList[k];
              if (opa.OperatingAreaId == opAreaId) {
                found = true;
                renderOpArea(loc, opa);
              }
            }
          }
        }
      }
      
      if (found == false)
        renderRoot();
    });
  }
  
  function initWebSocket() {
    if (BLWebSocket.isConnected()) {
      var reqDO = {"StatusList": []};
      $(".apt-item").each(function(index, elem) {
        reqDO.StatusList.push({
          "SrcWorkstationId": $(elem).attr("data-workstationId"),
          "BroadcastNames": [BcstStatus_WksConnection, BcstStatus_AccessPoint]
        });
      });

      BLWebSocket.sendCommand("HandShake", null, reqDO);
      aptKeepAliveLoop(true);
    }
  }
  
  function onTabChange(e, data) {
    if (UIMob.isActiveTab($view)) 
      initWebSocket();
  }
  
  function onWebSocketMessage(e, status) {
    if (status.Header.RequestCode == BcstStatus_AccessPoint)
      renderAccessPointStatus(status.Message);
    else if (status.Header.RequestCode == BcstStatus_WksConnection) 
      handleWorkstationConnection(status.Header.WorkstationId, status.Message.Open);
  }

  function aptKeepAliveLoop(immediateStatus) {
    if (BLWebSocket.isConnected() && UIMob.isActiveTab($view)) {
      $(".apt-item").each(function(index, elem) {
        var $apt = $(elem);
        doActivateStatusDispatch($apt.attr("data-workstationid"), $apt.attr("data-accesspointid"), (immediateStatus === true));
      });

      setTimeout(aptKeepAliveLoop, 60000);
    }
  }

  function doActivateStatusDispatch(workstationId, accessPointId, immediateStatus) {
    BLWebSocket.broadcastCommand(workstationId, "AccessPoint", {
      "Command": "ActivateStatusDispatch",
      "ActivateStatusDispatch": {
        "AccessPointIDs": accessPointId,
        "ValidityMin": 2,
        "ImmediateStatus": immediateStatus
      }
    });
  }

  function handleWorkstationConnection(workstationId, open) {
    $(".apt-item[data-workstationid='" + workstationId + "']").each(function(index, elem) {
      var $apt = $(elem);
      if (open)
        doActivateStatusDispatch($apt.attr("data-workstationid"), $apt.attr("data-accesspointid"), true);
      else 
        $apt.attr("data-status", "");      
    });
  }

  function renderAccessPointStatus(msg) {
    var $apt = $view.find(".apt-item[data-accesspointid='" + msg.AccessPointId + "']");
    $apt.data("status", msg);
    $apt.attr("data-status", APT_STATUS[msg.Status]);
    $apt.attr("data-lastusage", msg.LastUsageDateTime);

    var entryColor = (msg.ReentryControl == LkSN.AccessPointReentryControl.ReentryOnly.code) ? "red" : (APT_CONTROL_COLORS[msg.EntryControl] || "gray");
    var reentryColor = (msg.ReentryControl == LkSN.AccessPointReentryControl.FirstEntryOnly.code) ? "red" : (APT_CONTROL_COLORS[msg.EntryControl] || "gray");
    var exitColor = APT_CONTROL_COLORS[msg.ExitControl] || "gray";

    $apt.find(".apt-status-entry").css("color", "var(--base-" + entryColor + "-color)");
    $apt.find(".apt-status-reentry").css("color", "var(--base-" + reentryColor + "-color)");
    $apt.find(".apt-status-exit").css("color", "var(--base-" + exitColor + "-color)");
    
    var lastvr = msg.LastValidateResult || {};
    $apt.attr("data-lastusage", lastvr.UsageDateTime);
    $apt.attr("data-lastvr", lastvr.ValidateResult);
    
    refreshAptIdle($apt);
  }

  function refreshAllAptIdle() {
    if ($.contains(document.body, $view[0])) {
      if (UIMob.isActiveContent($view)) {
        $view.find(".apt-item").each(function(index, elem) {
          refreshAptIdle($(elem));
        });
      }
      setTimeout(refreshAllAptIdle, 1000);
    }
  }
  
  function refreshAptIdle($apt) {
    var status = "idle";
    var text = "IDLE";
    var lastUsage = $apt.attr("data-lastusage");
    
    if (lastUsage) {
      var last = xmlToDate($apt.attr("data-lastusage")).getTime();
      var now = (new Date()).getTime();
      if ((now - last) < 30000) {
        var valres = strToIntDef($apt.attr("data-lastvr"), -1);
        if (valres > 0) {
          status = (valres < LkSN.ValidateResult.GoodTicketLimit.code) ? "good" : "bad";
          text = getLookupDesc(LkSN.ValidateResult, valres);
        }
      }
    }
    
    var $valres = $apt.find(".apt-val-res");
    var bg = (status == "idle") ? "white" : "var(--base-" + ((status == "good") ? "green" : "red") + "-color)";
    var fg = (status == "idle") ? "black" : "white";
    $valres.css({
      "background-color": bg,
      "color": fg
    });
    $valres.text(text);
  }

  function onBtnBackClick() {
    var $bcs = $view.find(".breadcrumb-item");
    if ($bcs.length <= 1)
      renderRoot();
    else {
      var $bc = $($bcs[$bcs.length - 2]);
      $bc.trigger("click");
    }
  }

  function renderRoot() {
    $view.find(".tab-header-title").text(itl("@Account.Locations"));
    $view.find(".btn-back").addClass("disabled");
    
    var $bcList = $view.find(".breadcrumb-container").empty();
    addBreadcrumbRoot($bcList);

    var $tabBody = $view.find(".data-box").html("<div class='pref-section-spacer'/>");
    var $prefSection = $("<div class='pref-section'/>").appendTo($tabBody);
    var $prefList = $("<div class='pref-item-list'/>").appendTo($prefSection);
    
    for (var i=0; i<locationList.length; i++) {
      var loc = locationList[i];
      var $loc = $("#common-templates .pref-item").clone().appendTo($prefList);
      $loc.data("location", loc);
      $loc.addClass("pref-item-arrow");
      $loc.find(".pref-item-caption").text(loc.LocationName);
      
      $loc.click(function() {
        renderLocation($(this).data("location"));
      });
    }
  }
  
  function renderLocation(location) {
    $view.find(".tab-header-title").text(location.LocationName);
    $view.find(".btn-back").removeClass("disabled");
    
    var $bcList = $view.find(".breadcrumb-container").empty();
    addBreadcrumbRoot($bcList);
    addBreadcrumbLocation($bcList, location);

    var $tabBody = $view.find(".data-box").html("<div class='pref-section-spacer'/>");
    var $prefSection = $("<div class='pref-section'/>").appendTo($tabBody);
    var $prefList = $("<div class='pref-item-list'/>").appendTo($prefSection);
    
    var list = location.OperatingAreaList || [];
    for (var i=0; i<list.length; i++) {
      var opa = list[i];
      var $opa = $("#common-templates .pref-item").clone().appendTo($prefList);
      $opa.data("oparea", opa);
      $opa.addClass("pref-item-arrow");
      $opa.find(".pref-item-caption").text(opa.OperatingAreaName);
      
      $opa.click(function() {
        renderOpArea(location, $(this).data("oparea"));
      });
    }
  }
  
  function renderOpArea(location, opArea) {
    $view.find(".tab-header-title").text(opArea.OperatingAreaName);
    $view.find(".btn-back").removeClass("disabled");
    
    var $bcList = $view.find(".breadcrumb-container").empty();
    addBreadcrumbRoot($bcList);
    addBreadcrumbLocation($bcList, location);
    addBreadcrumbOpArea($bcList, location, opArea);
    
    var $tabBody = $view.find(".data-box").empty();
    var list = opArea.WorkstationList || [];
    
    for (var i=0; i<list.length; i++) {
      var apt = list[i]; 
      var $apt = $view.find(".templates .apt-item").clone().appendTo($tabBody);
      $apt.data("apt", apt);
      $apt.attr("data-status", "offline");
      $apt.attr("data-accesspointid", apt.WorkstationId);
      $apt.attr("data-workstationid", apt.AptControllerWorkstationId);
      $apt.find(".mob-widget-header").text(apt.WorkstationCode);
      
      $apt.click(function() {
        var $apt = $(this);
        var apt = $apt.data("apt");
        UIMob.tabSlideView({
          "container": $view.closest(".tab-content"),
          "packageName": PKG_CAS,
          "viewName": "apt-monitor-detail",
          "params": {
            "AccessPointId": apt.WorkstationId,
            "AccessPointCode": apt.WorkstationCode,
            "AccessPointName": apt.WorkstationName,
            "ControllerWorkstationId": apt.AptControllerWorkstationId,
            "Status": $apt.data("status")
          }
        });
      });
    }
    
    setLocalStorage("AptMonitorOpAreaId", opArea.OperatingAreaId);
    initWebSocket();
  }

  function addBreadcrumbRoot(container) {
    var $list = $(container);
    var $bc = UIMob.createBreadcrumbItem(itl("@Account.Locations")).appendTo($list);
    
    $bc.click(function() {
      renderRoot();
    });
  }

  function addBreadcrumbLocation(container, location) {
    var $list = $(container);
    var $bc = UIMob.createBreadcrumbItem(location.LocationName).appendTo($list);
    
    $bc.click(function() {
      renderLocation(location);
    });
  }

  function addBreadcrumbOpArea(container, location, opArea) {
    var $list = $(container);
    var $bc = UIMob.createBreadcrumbItem(opArea.OperatingAreaName).appendTo($list);
    
    $bc.click(function() {
      renderOpArea(location, opArea);
    });
  }

});
