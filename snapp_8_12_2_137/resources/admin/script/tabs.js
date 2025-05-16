$(document).ready(function() {
  
  snpObserver.registerListener("v-tabs-active", "dynpage-initialized", _loadDynPageIfNeeded);

  $(document).on("ajax-content-load", _recalcTabSizes);
  $(window).resize(_recalcTabSizes);
  _recalcTabSizes();

  function _recalcTabSizes() {
    $(".v-tabs-item").css({"max-width":""}).removeAttr("title");
    $(".v-tabs-nav").each(function(index, nav) {
      var $nav = $(nav);
      var $tabs = $nav.find(".v-tabs-item"); 
      var containerWidth = $nav.width() - 30; // keeping some margin for potential scrollbar apearing
      if ($tabs.length > 0) {
        var out = -containerWidth;
        for (var i=0; i<$tabs.length; i++)
          out += $($tabs[i]).outerWidth();
        
        if (out > 0) {
          var wTab = containerWidth / $tabs.length;
  
          // Sorting from wider to shorter
          $tabs.sort(function(a, b) {
            return $(b).outerWidth() - $(a).outerWidth();
          });
          
          function getSecondSize() {
            var max = $($tabs[0]).outerWidth();
            for (var i=1; i<$tabs.length; i++) {
              var w = $($tabs[i]).outerWidth();
              if (w < max)
                return w; 
            } 
            return wTab;
          }
          
          var cnt = 0;
          while (out > 0) {
            cnt++;
            if (cnt > 1000) {
              console.warn("Tabs recalc sizes: possible infinitive loop");
              break;
            }
              
            var w = Math.max(wTab, getSecondSize());
            for (var i=0; i<$tabs.length; i++) {
              var $tab = $($tabs[i]);
              if ($tab.outerWidth() <= w) 
                break;
              else {
                out -= $tab.outerWidth() - w;
                $tab.css({"max-width": w + "px"});
                $tab.attr("title", $tab.find(".v-tabs-anchor").text());
              }
            }
          }
        }
      }
    });
  }

  var origActivateTab = jQuery.fn.activateTab;
  jQuery.fn.activateTab = function(p1, p2, p3, p4, p5) {
    var $item = $(this);
    if (!$item.is(".v-tabs-item"))
      return origActivateTab(p1, p2, p3, p4, p5);
      
    var $a = $item.find(".v-tabs-anchor");
    var href = $a.attr("href");
    if ((href) && (href.length > 0) && (href.charAt(0) == "#")) {
      var tab = $a.attr("data-tabcode");
      var $container = $item.closest(".v-tabs-container");
      $container.find("> .v-tabs-nav-container > .v-tabs-nav > .v-tabs-item").removeClass("v-tabs-active");
      $container.find("> .v-tabs-panel").addClass("hidden");
      $container.find("> .v-tabs-panel[id='" + tab + "']").removeClass("hidden");
      $item.addClass("v-tabs-active");
      
      _loadDynPageIfNeeded($item);
      
      if (event)
        event.preventDefault();
    }
  };
  
  function _loadDynPageIfNeeded($items) {
    for (const item of $items) {
      let $item = $(item);
      let dynpage = $item.attr("data-dynpage");
      if (dynpage && !$item.is(".dynpage-initialized")) {
        let tab = $item.attr("data-tabcode");
        asyncLoad($("#" + tab), addTrailingSlash(BASE_URL) + dynpage);
        $item.addClass("dynpage-initialized");
      }
    }
  }
  
  $(document).on("click", ".v-tabs-anchor", function(e) {
    $(this).closest(".v-tabs-item").activateTab();
  });
  
});
