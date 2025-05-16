//# sourceURL=mob-ui.js

var EVENT_PrefChange = "PrefChange";

var PKG_COMMON = "COMMON";
var PKG_ADM = "AppMOB_Admission";
var PKG_PAY = "AppMOB_Payment";
var PKG_CAS = "AppMOB_SalesOperator";
var PKG_GST = "AppMOB_SalesGuest";

var APP_HOMES = {};
APP_HOMES[PKG_ADM] = "adm-home";
APP_HOMES[PKG_PAY] = "pay-home";
APP_HOMES[PKG_CAS] = "cas-home";
APP_HOMES[PKG_GST] = "gst-home";

$(document).ready(function() {
  var packages = {};
  var mainPackageName = null; 
  var mainViewName = null;
  var viewInitFunctions = {};
  var waitGlassCounter = 0;

  window.UIMob = {
    // Methods
    "init": init, // register a function to be called upon view initialization
    "showWaitGlass": showWaitGlass,
    "hideWaitGlass": hideWaitGlass,
    "loadView": loadView, 
    "showView": showView,
    "initView": initView,
    "initTabsContent": initTabsContent,
    "showApp": showApp,
    "applyITL": applyITL,
    "setActiveTabMain": setActiveTabMain,
    "showDialog": showDialog,
    "hideDialog": hideDialog,
    "showMessage": showMessage, 
    "showError": showError, 
    "popupMenu": popupMenu,
    "tabSlide": tabSlide,
    "tabSlideView": tabSlideView,
    "tabNavBack": tabNavBack,
    "showPrefList": showPrefList,
    "prefItemChanged": prefItemChanged,
    "isPrefChanged": isPrefChanged,
    "createSpinnerClone": createSpinnerClone,
    "getScreenInfo": getScreenInfo,
    "initSearch": initSearch,
    "addListItemProperty": addListItemProperty,
    "addCardData": addCardData,
    "isActiveTab": isActiveTab,
    "isActiveContent": isActiveContent,
    "createBreadcrumbItem": createBreadcrumbItem,
    "showDateTimePicker": null // mob-dlg-datetime.js
  };

  $(document).on("login", onLogin);
  $(document).on("click", ".tab-button-list .tab-button", onTabButtonClick);
  $(document).on("keydown", ".pref-edit-container .pref-item input", onPrefInputKeyDown);
  $(window).resize(onWindowResize);
  onWindowResize();
  
  function onLogin(event, bean) {
    UIMob.showView(mainPackageName, mainViewName);
  }
  
  function onTabButtonClick() {
    setActiveTabMain($(this).attr("data-tabcode"));
  }
  
  function onWindowResize() {
    initTabs($(".mob-view"));
    $("body").attr("data-screentype", getScreenInfo().Type);
  }
  
  function init(viewName, fnc) {
    viewInitFunctions[viewName] = fnc;
  }

  function showWaitGlass() {
    waitGlassCounter++;
    if (waitGlassCounter == 1)
      $("<div id='wait-glass' class='mobile-dialog-layover'><i class='fa fa-circle-notch fa-spin fa-fw'></i></div>").appendTo("body");
  }

  function hideWaitGlass() {
    waitGlassCounter--;
    if (waitGlassCounter == 0)
      $("#wait-glass").remove();
  }

  function loadPackage(packageName, callback) {
    var pkg = packages[packageName];
    if (pkg) {
      if (callback)
        callback(pkg);
    }
    else {
      UIMob.showWaitGlass();
      var urlo = BASE_URL + "/mobile?page=app-pkg&id=" + workstationId + "&app=" + packageName;
      $.ajax({
        url: urlo,
        dataType:'html',
        cache: false,
        success: function(data, textStatus, xhr) {
          UIMob.hideWaitGlass();
          pkg = $("<div>" + data + "</div>");
          packages[packageName] = pkg;
          if (callback)
            callback(pkg);
        },
        error: function(xhr, textStatus, errorThrown) {
          UIMob.hideWaitGlass();
          console.log("ERROR - TODO")
          /*
          if ((xhr) && (xhr.status == 401)) 
            window.location.reload();
          else {
            tsPageClick = null;
            showIconMessage("warning", errorThrown);
          }
          */
        }
      });
    }
  }

  function loadView(packageName, viewName, callback) {
    loadPackage(packageName, function(pkg) {
      var $view = pkg.find(".mob-view[data-viewname='" + viewName + "']").clone();
      
      if ($view.length == 0)
        throw new Error("Unable to find view: " + packageName + "." + viewName);
      
      var $scripts = $view.find("script");
      $scripts.each(function(index, elem) {
        var fileName = "view[" + viewName + "]";
        if ($scripts.length > 1)
          fileName += "(" + index + ")";
        var $elem = $(elem);
        if ($elem.text().indexOf("//# sourceURL") < 0)
          $elem.prepend("\n" + "//# sourceURL=" + fileName + "\n");
      });
      
      applyITL($view);
      if (callback)
        callback($view);
    });
  }

  function showView(packageName, viewName) {
    loadView(packageName, viewName, function($view) {
      $("#mobile-main").empty().append($view);
      initView($view);
    });
  }
  
  function initView($view, params) {
    if ($view.hasClass("mob-view")) {
      $(document).ready(function() {
        initTabs($view);
        var fnc = viewInitFunctions[$view.attr("data-viewname")];
        if (fnc)
          fnc($view, params);
      });
    }
  }

  function showApp(appName) {
    var viewName = APP_HOMES[appName];
    if (!(viewName))
      throw "Unable to find app home view name for app '" + appName + "''";
    
    mainPackageName = appName;
    mainViewName = viewName;
    
    showView(PKG_COMMON, "login");
  }

  function initTabs($view) {
    var $list = $view.find(".tab-button-list");
    if ($list.length > 0) {
      var $buttons = $list.find(".tab-button").not(".hidden").addClass("noselect");
      var btnWidth = $list.innerWidth() / $buttons.length;
      $buttons.css("width", btnWidth + "px");
    }
  }

  function initTabsContent($view) {
    $view.find(".tab-button-list .tab-button:not(.tab-button-initialized)").each(function(index, elem) {
      var $btn = $(elem);
      var tabPackageName = $btn.attr("data-packagename");
      var tabViewName = $btn.attr("data-viewname");
      if (tabPackageName && tabViewName) {
        loadView(tabPackageName, tabViewName, function($tabView) {
          var $btnList = $btn.closest(".tab-button-list");
          var $contentList = $btnList.siblings(".main-tab-body-list").first();
          if ($contentList.length == 0)
            $contentList = $("<div class='main-tab-body-list'/>").insertBefore($btnList);
          
          var tabCode = tabPackageName + "." + tabViewName;
          var $content = $("<div class='tab-content'/>").appendTo($contentList);
          $content.attr("data-tabcode", tabCode);
          $btn.attr("data-tabcode", tabCode);
          
          $content.append($tabView);
          initView($tabView);

          var code = $btn.filter(".tab-button-default").attr("data-tabcode");
          if (code)
            setActiveTabMain(code);
        });
      }
      else
        throw new Error("Unable to inzialize tab");
    });
    
    initTabs($view);
  }

  function applyITL(selector) {
    $(selector).find(".snp-itl").each(function(index, elem) {
      var $elem = $(elem);
      $elem.text(itl($elem.attr("data-key")));
    });
  }

  function setActiveTabMain(tabCode) {
    var $oldBtn = $(".tab-button.active-tab");
    var oldTabCode = $oldBtn.attr("data-tabcode");
    $(".active-tab").removeClass("active-tab");
    $("[data-tabcode='" + tabCode + "']").filter(".tab-button, .tab-content").addClass("active-tab");
    $(document).trigger("tabchange", {"NewTabCode":tabCode, "OldTabCode":oldTabCode});
  }
  
  /** 
   * Supposed to return an object: 
   * {
   *   "Width": screen width in pixels,
   *   "Height": screen height in pixels,
   *   "Type": "phone" | "tablet" | "desktop",
   *   "Orientation": "portrait" | "landscape"
   * }
   */
  function getScreenInfo() {
    var w = $(document).width();
    var h = $(document).height();
    return {
      "Width": w,
      "Height": h,
      "Type": (w < 768) ? "phone" : (w <= 1024) ? "tablet" : "desktop",
      "Orientation": (w < h) ? "portrait" : "landscape"
    };
  }
  
  function showDialog($dlg) {
    var $layover = $("<div class='mobile-dialog-layover'/>").appendTo("body");
    $layover.append($dlg);
    applyITL($dlg);

    var screenInfo = getScreenInfo();
    var maxInline = (screenInfo.Type == "phone") ? 2 : (screenInfo.Type == "tablet") ? 3 : 6;
    
    var $buttons = $dlg.find(".mobile-dialog-footer .mobile-dialog-button");
    $buttons.addClass("noselect");
    
    if (($buttons.length > 1) && ($buttons.length <= maxInline)) {
      $buttons.css({
        "float": "left",
        "width": (100 / $buttons.length) + "%"
      });
    }
    
    var top = (screenInfo.Height - $dlg.height()) / 2;
    $dlg.css("top", top+"px");
  }
  
  function hideDialog($dlg) {
    $dlg.closest(".mobile-dialog-layover").remove();
  }

  function showMessage(title, content, buttons, callback) {
    var $dlg = $("#common-templates .dlg-message").clone();
    
    $dlg.find(".mobile-dialog-title").text(title);
    if ((typeof content) == "string")
      $dlg.find(".mobile-dialog-body").text(content);
    else
      $dlg.find(".mobile-dialog-body").append(content);
    
    $dlg.find("input:text:visible:first").focus();
    
    buttons = (buttons || []);
    if (buttons.length <= 0)
      buttons.push(itl("@Common.Ok"));
    
    var $footer = $dlg.find(".mobile-dialog-footer");
    for (var i=0; i<buttons.length; i++) {
      var $btn = $("<div class='mobile-dialog-button'/>").appendTo($footer);
      $btn.attr("data-index", i);
      $btn.text(buttons[i]);

      $btn.click(function() {
        var idx = parseInt($(this).attr("data-index"));
        hideDialog($dlg);
        if (callback)
          callback(idx);
      });
    }
    
    showDialog($dlg);
  }

  function showError(message) {
    UIMob.showMessage(itl("@Common.Warning"), message, [itl("@Common.Ok")]);
  }
  
  /**
   * {
   *   Target: selector | jQuery, // Element related to the popup 
   *   Items: [{
   *     IconAlias:     string,
   *     Caption:       string,
   *     Hint:          string,
   *     Enabled:       boolean,  // Default = true
   *     Visible:       boolean,  // Default = true
   *     enableDisable: function, // Not mandatory, will be called on menu show in order to refresh action properties
   *     execute:       function
   *   }]
   * }
   */
  function popupMenu(params) {
    params = params || {};
    params.Items = params.Items || []; 
    
    var $layover = $("<div class='mobile-dialog-layover'/>").appendTo("body");
    var $menu = $("#common-templates .mobile-popup").clone().appendTo($layover);
    var $itemTemplate = $menu.find(".mobile-popup-item").remove();
    var $target = $(params.Target);
    
    for (var i=0; i<params.Items.length; i++) {
      var item = params.Items[i];
      if (item.Visible !== false) { 
        if (item.enableDisable)
          item.enableDisable();
        
        if (item.Enabled != false)
          item.Enabled = true;
          
        if (item.Visible != false)
          item.Visible = true;
        
        var $item = $itemTemplate.clone().appendTo($menu.find(".mobile-popup-inner"));
        $item.data("item", item);
        $item.setClass("disabled", item.Enabled === false);
        $item.find(".mobile-popup-item-caption").text(item.Caption);
        $item.find(".mobile-popup-item-hint").text(item.Hint);
        if (item.IconAlias)
          $item.find(".mobile-popup-item-icon").html("<i class='fa fa-" + item.IconAlias + "'></i>");
        
        $item.click(function(e) {
          var item = $(this).data("item");
          if (item.Enabled === true) {
            $layover.remove();
            if (item.execute)
              item.execute(item);
          }
          else
            e.stopPropagation();
        });
      }
    }
    
    $layover.click(function() {
      $layover.remove();
    });
    
    $menu.position({
      my: "left top",
      at: "left bottom",
      of: params.Target
    });
  }

  /**
  o = {
    container:string|jquery -mandatory-
    content:string|jquery   -mandatory-
    dir:string (L2R | RTL) default if R2L
    saveHistory:boolean   
  }
  */
  function tabSlide(o) {
    o = (o || {});
    
    if (o.dir) {
      if ((o.dir !== "R2L") && (o.dir !== "L2R"))
        throw new Error("Invalid DIR property value: " + o.dir);
    }
    
    if (o.saveHistory === undefined)
      o.saveHistory = true;
    
    if (!(o.container)) 
      throw "Missing 'container' option";
    
    if (!(o.content)) 
      throw "Missing 'content' option";
    
    var $container = $(o.container);
    var $old = $container.contents().not(".hidden-nav-content");
    var l = $container.width();

    var $c = $(o.content).removeClass("hidden-nav-content").attr("data-history", "");
    if (!$.contains($container[0], $c[0]))
      $container.append($c);
    
    if (o.dir == null) 
      _onAnimateFinish();
    else {
      $c.css({
        "position": "absolute",
        "top": "0",
        "bottom": "0",
        "left": ((o.dir == "L2R") ? -l : l) + "px",
        "width": l + "px"
      });

      $c.animate({"left":"0"}, 100, _onAnimateFinish);
    }
    
    function _onAnimateFinish() {
      if (o.dir) {
        $c.css({
          "position": "",
          "top": "",
          "bottom": "",
          "left": "",
          "width": ""
        });
      }

      if (o.saveHistory) {
        var historyCnt = strToIntDef($container.attr("data-historycount"), -1) + 1;
        $old.addClass("hidden-nav-content").attr("data-history", historyCnt);
        $container.attr("data-historycount", historyCnt);
        $c.attr("data-animation-dir", o.dir);
        $c.find(".tab-header .btn-toolbar-back:not(.custom-click)").click(function() {
          tabNavBack($container);
        });
        
        if ($c.hasClass("mob-view")) 
          initView($c, o.params);
      }
      else 
        $old.remove();
    }
  }

  /**
  o = {
    container:string|jquery -mandatory-
    packageName:string      -mandatory-
    viewName:string         -mandatory-
    dir:string (L2R | RTL) default if R2L
    saveHistory:boolean   
  }
  */
  function tabSlideView(o) {
    o = (o || {});
    if (!(o.container)) throw "Missing 'container' param";
    if (!(o.packageName)) throw "Missing 'packageName' param";
    if (!(o.viewName)) throw "Missing 'viewName' param";
    
    var $container = $(o.container);
    UIMob.loadView(o.packageName, o.viewName, function($view) {
      o.content = $view; 
      tabSlide(o);
    });
  }

  function tabNavBack(container) {
    var $container = $(container);
    var historyCnt = strToIntDef($container.attr("data-historycount"), 0);
    $container.attr("data-historycount", historyCnt - 1);
    var $old = $container.find(">.hidden-nav-content[data-history='" + historyCnt + "']");
    
    var currdir = $container.contents().not(".hidden-nav-content").attr("data-animation-dir");
    var dir = (currdir === "R2L") ? "L2R" : (currdir === "L2R") ? "R2L" : null;
    
    tabSlide({
      "container": $container,
      "content": $old,
      "dir": dir,
      "saveHistory": false
    });
  }
  
  function onPrefInputKeyDown() {
    prefItemChanged(this);
  }
  
  function prefItemChanged(elem) {
    var $prefEditContainer = $(elem).closest(".pref-edit-container");
    $prefEditContainer.attr("data-prefchanged", "true");
    $prefEditContainer.trigger(EVENT_PrefChange);
  }
  
  function isPrefChanged(elem) {
    var $elem = $(elem);
    if (!$elem.is(".pref-edit-container"))
      $elem = $elem.closest(".pref-edit-container");
    return ($elem.attr("data-prefchanged") == "true");
  }

  /**
   * params = {
   *   PrefItem: selector | jQuery, 
   *   MultipleChoice: boolean, // default if FALSE
   *   OptionList: [{
   *     ItemId: string,
   *     ItemName: string,
   *   }],
   *   onItemClick: function($optionItem, callback),
   *   onClose: function()
   * }
   */
  function showPrefList(params) {
    params = params || {};
    var $prefItem = $(params.PrefItem);
    var options = (params.OptionList || []);
    var $activeContent = $prefItem.closest(".mob-view");
    
    var $newContent = $("<div class='mob-view'/>").appendTo($activeContent.parent());
    var $header = $("<div class='tab-header'/>").appendTo($newContent);
    var $btnBack = $("<div class='toolbar-button btn-toolbar-back custom-click'/>").appendTo($header);
    var $title = $("<div class='tab-header-title' style='margin-right:20vw'/>").appendTo($header);
    var $body = $("<div class='tab-body'><div class='pref-section-spacer'/><div class='pref-section'/></div>").appendTo($newContent);
    var $prefList = $("<div class='pref-item-list'/>").appendTo($body.find(".pref-section"));
    
    $btnBack.click(_navBack);
    $title.text($prefItem.find(".pref-item-caption").text());
    
    function _clickCallback($item) {
      if (params.MultipleChoice === true)
        $item.toggleClass("selected");
      else {
        $item.closest(".pref-item-list").find(".pref-item").removeClass("selected");
        $item.addClass("selected");
      }
      
      var codes = [];
      var names = [];
      $item.closest(".pref-item-list").find(".pref-item.selected").each(function(index, elem) {
        var $selItem = $(elem);
        codes.push($selItem.attr("data-itemid"));
        names.push($selItem.find(".pref-item-caption").text());
      });
      
      $prefItem.attr("data-itemid", codes.join(","));
      $prefItem.find(".pref-item-value").text(names.join(", "));
      
      prefItemChanged($prefItem);
      
      if (params.MultipleChoice !== true) 
        _navBack();
    }
    
    function _navBack() {
      tabNavBack($activeContent);
      if (params.onClose)
        params.onClose();
    }

    var selIDs = ($prefItem.attr("data-itemid") || "").split(",");

    for (var i=0; i<options.length; i++) {
      var option = options[i];
      var $item = $("<div class='pref-item pref-item-check'/>").appendTo($prefList);
      var $caption = $("<div class='pref-item-caption'/>").appendTo($item);
      $caption.text(option.ItemName);
      if (option.ItemName == "")
        $caption.html("&nbsp;");
      $item.attr("data-itemid", option.ItemId);
      $item.setClass("selected", selIDs.indexOf(option.ItemId) >= 0);
      
      $item.click(function() {
        var $this = $(this);
        if (params.onItemClick) 
          params.onItemClick($this, _clickCallback);
        else
          _clickCallback($this);
      });
    }
    
    tabSlide({
      "container": $activeContent, 
      "content": $newContent
    });
  }

  function createSpinnerClone() {
    return $("#common-templates .main-spinner").clone();
  }
  
  /**
   * o = {
   *   Body: selector | jQuery,      // The element is supposed to have a child like >.scroll-content>.search-list
   *   Cmd: string,                  // API name
   *   Command: string,              // API-Command 
   *   ListNodeName: string,         // API response list node name
   *   CommandDO: string,            // Request command data-object
   *   afterSearch: function(ansDO), // Called every time after API search is done
   *   renderItem: function(item)    // Callback with single item information to be rendered
   * }
   */
  function initSearch(o) {
    o = o || {};
    if (o.Body == null)         throw "Missing parameter: 'Body'";
    if (o.Cmd == null)          throw "Missing parameter: 'Cmd'";
    if (o.Command == null)      throw "Missing parameter: 'Command'";
    if (o.ListNodeName == null) throw "Missing parameter: 'ListNodeName'";
    
    var $body = $(o.Body);
    var commandDO = o.CommandDO || {};

    var scrollHandler = $body.data("scrollHandler");
    if (scrollHandler) 
      $body.off("scroll", scrollHandler);
    $body.scroll(onScroll);
    $body.data("scrollHandler", onScroll);

    var $scroll = $body.find(".scroll-content");
    var $list = $scroll.find(".search-list");
    var searching = false;
    var endReached = false;
    var pagePos = 1;
    var recordPerPage = 30;
    
    function onScroll(e) {
      var perc = ($body.scrollTop() + $body.innerHeight()) / $scroll.outerHeight();
      if (perc > 0.75)
        _startSearch(false);
    };
    
    _startSearch(true);

    function _startSearch(reset) {
      if (!searching && !endReached) {
        searching = true;
        if (reset == true) {
          $list.empty();
          $body.scrollTop(0);
          pagePos = 1;
        }
        else
          pagePos++;
        
        commandDO.PagePos = pagePos;
        commandDO.RecordPerPage = recordPerPage;

        var $spinner = UIMob.createSpinnerClone().appendTo($list);
        snpAPI(o.Cmd, o.Command, commandDO)
        .finally(function() {
          $spinner.remove();
          searching = false;
        })
        .then(function(ansDO) {
          var list = ansDO[o.ListNodeName] || [];
          endReached = list.length < recordPerPage;
          
          if (o.afterSearch)
            o.afterSearch(ansDO);
          
          if (o.renderItem)
            for (var i=0; i<list.length; i++)
              o.renderItem(list[i]);
        });
      }
    }
  }
  
  /**
   * Adds the required Value/IconAlias property to the container only if Value is not null.
   * Returns true if the property have been added
   */
  function addListItemProperty(container, value, iconAlias, clazz) {
    if (value != null) {
      var $prop = $("<div class='mobile-ellipsis'><span class='list-item-text'/></div>").appendTo(container);
      $prop.find(".list-item-text").text(value);
      
      if (iconAlias)
        $prop.prepend("<i class='list-item-texticon fa fa-" + iconAlias + "'></i>");
      
      if (clazz)
        $prop.addClass(clazz);
      return true;
    }
    
    return false;
  }
  
  function addCardData(container, value, icon) {
    var $item = $("<div class='mob-card-data mobile-ellipsis'><span class='mob-card-data-icon fa'/> <span class='mob-card-data-text'/></div>");
    $item.find(".mob-card-data-icon").addClass("fa-" + icon);
    $item.find(".mob-card-data-text").text(value);

    if (value) 
      $(container).append($item);

    return $item;
  }

  /**
   * Check if provided content (selector | jQuery) is part of an active tab
   */
  function isActiveTab(content) {
    return $(content).closest(".tab-content").is(".active-tab");
  }

  /**
   * Check if provided content (selector | jQuery) is part of an active tab, and it is not hidden from other views
   */
  function isActiveContent(content) {
    return isActiveTab(content) && ($(content).closest(".hidden-nav-content").length <= 0);
  }

  function createBreadcrumbItem(caption) {
    var $bc = $("<div class='breadcrumb-item'><div class='breadcrumb-caption'/><div class='breadcrumb-icon'><i class='fa fa-chevron-right'></i></div></div>");
    $bc.find(".breadcrumb-caption").text(caption);
    return $bc;
  }
});

