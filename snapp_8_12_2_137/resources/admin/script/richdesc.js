$.fn.richdesc_init = function(params) {
  var $widget = $(this);
  if (!$widget.is(".rich-desc-widget"))
    throw "Unable to intialize rich desc, because 'this' element is not '.rich-desc-widget'";
    
  if (!$widget.is(".initialized")) {
    $widget.addClass("initialized");
    params = params || {};
    params.TransList = params.TransList || [];
    params.ReadOnly = params.ReadOnly || false;
    params.Height = params.Height || "500px";
    
    var $divTab = $widget.find("#lang-tabs-container");
    var $ulTab = $widget.find("#lang-tabs");
    var defaultLangISO = $widget.attr("data-defaultlangiso");
    var defaultLangIcon = $widget.attr("data-defaultlangicon");
    var defaultLangName = $widget.attr("data-defaultlangname");
  
    if (params.TransList.length == 0) {
      addLangTab(defaultLangISO, defaultLangName, defaultLangIcon);
    }
    else {
      for (var i=0; i<params.TransList.length; i++) {
        var item = params.TransList[i];
        addLangTab(item.LangISO, item.LangName, item.IconName, item.Translation);
      }
    }
    
    $widget.find(".menu-lang-item").click(function() {
      var $menu = $(this);
      var langISO = $menu.attr("data-langiso");
      var langName = $menu.attr("data-langname");
      var iconName = $menu.attr("data-iconname");
      
      var $tabContent = $divTab.find("#lang_" + langISO);
      
      if ($tabContent.length != 0) 
        showMessage(itl("@RichDesc.LanguageAlreadySelectedError"));
      else 
        addLangTab(langISO, langName, iconName);
    });
  
    setActiveTab($ulTab.find(".tab-item").first());
    
    function setActiveTab(tab) {
      var $tab = $(tab);
      var id = $tab.find("a").first().attr("href");
      $tab.removeClass("ui-state-default").addClass("ui-state-active ui-tabs-active").siblings(".tab-item").addClass("ui-state-default").removeClass("ui-state-active ui-tabs-active");
      $divTab.find(id).css("display", "block").siblings(".lang-tab-content").css("display", "none");
    }
  
    function addLangTab(langISO, langName, iconName, body) {
      body = (body) ? body : langName;
      
      var $plusTab = $ulTab.find("#plus_tab");
      var li = $("<li class='tab-item ui-corner-top'><a class='ui-tabs-anchor no-ajax' href='#lang_" + langISO + "'></a></li>");
      $plusTab.before(li);
      
      $a = $ulTab.find("li.tab-item a[href='#lang_" + langISO + "']");
      
      $a.text(langName);
      if (iconName) 
        $a.prepend("<span class='ab-icon' style='background-image:url(" + calcIconName(iconName, 16) + "'></span>&nbsp;");  
      
      if (langISO != defaultLangISO) 
        $a.append("<span class='btn-close-tab fa fa-times'></span>").find("span.btn-close-tab").click(function(event) {
              confirmDialog(null, function() {
                removeLanguage(langISO);
              });
            });
  
      var divContent = $("<div id='lang_" + langISO + "' class='lang-tab-content ui-tabs-panel ui-corner-bottom ui-widget-content'><textarea/></div>");
      divContent.attr("data-LangISO", langISO);
      divContent.attr("data-LangName", langName);
      divContent.attr("data-IconName", iconName);
      divContent.find("textarea").html(body);
      $divTab.append(divContent);
      
      setActiveTab($a.closest('li'));
  
      var instance = CKEDITOR.replace(divContent.find("textarea")[0], {
        height: params.Height,
        readOnly: params.ReadOnly
      });
      divContent.attr("data-InstanceName", instance.name);
  
      li.click(function() {
        setActiveTab(this);
      });
    }
    
    function removeLanguage(langISO) {
      var $local_a = $widget.find("#lang-tabs").find("li.tab-item a[href='#lang_" + langISO + "']");
      var $tab =  $local_a.find("span").closest("li");
      var id = $tab.find("a").first().attr("href");
      var $active = $tab.prev();
      if ($active.length == 0)
        $active = $tab.next();
      $tab.remove();
      var $divLang = $divTab.find(id);
      $divLang.remove();
      setActiveTab($active);
    }
  }  

};

$.fn.richdesc_getTransList = function getRichDescWidgetList() {
  var $widget = $(this);
  var $divTab = $widget.find("#lang-tabs-container");
  var result = [];
  
  $divTab.find(".lang-tab-content").each(function(index, elem) {
     var $tab = $(elem);
     var desc = $tab.find("iframe").contents().find("body").html();
     if (desc != "") {
       var langISO = $tab.attr("data-LangISO");
       result.push({
         LangISO: langISO,
         LangName: $tab.attr("data-LangName"),
         IconName: $tab.attr("data-IconName"),
         Translation: desc
       });
     }
  });
  
  return result;
}
