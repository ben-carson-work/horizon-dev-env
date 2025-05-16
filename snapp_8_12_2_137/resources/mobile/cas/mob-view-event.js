UIMob.init("event", function($view, params) {

  var $itemTemplate = $view.find(".templates .perf-item");
  var $groupTemplate = $view.find(".templates .perf-group");
  var $body = $view.find(".tab-body");
  var $scroll = $body.find(".scroll-content");
  var $list = $scroll.find(".perf-list");
  var $btnRefresh = $view.find(".btn-toolbar-refresh");
  var searching = false;
  var endReached = false;
  var pagePos = 1;
  var recordPerPage = 50;
  
  BLCart.initCartDisplay($view.find(".cartdisplay-container"));
  $btnRefresh.click(onRefreshClick);
  $body.scroll(onScroll);
  startSearch(true);
  
  function onRefreshClick() {
    if (!$btnRefresh.hasClass("disabled"))
      startSearch(true);
  }
  
  function onScroll(e) {
    var perc = ($body.scrollTop() + $body.innerHeight()) / $scroll.outerHeight();
    if (perc > 0.75)
      startSearch(false);
  }
  
  function startSearch(reset) {
    if (!searching && !endReached) {
      searching = true;
      if (reset == true) {
        $list.empty();
        $body.scrollTop(0);
        pagePos = 1;
      }
      else
        pagePos++;

      var $spinner = UIMob.createSpinnerClone().appendTo($list);
      $btnRefresh.addClass("disabled");
      snpAPI("Performance", "Search", {
        "EventId": params.EventId,
        "CatalogId": params.EventCatalogId,
        "SellableOnly": true,
        "PagePos": pagePos,
        "RecordPerPage": recordPerPage
      })
      .finally(function() {
        $spinner.remove();
        $btnRefresh.removeClass("disabled");
        searching = false;
      })
      .then(function(ansDO) {
        var list = (ansDO.PerformanceList || []);
        endReached = list.length < recordPerPage;
        renderPerfList(list);
      });
    }
  }
  
  function renderPerfList(list) {
    for (var i=0; i<list.length; i++) {
      var perf = list[i];
      var date = perf.DateTimeFrom.substr(0, 10);
      var $group = $list.find(".perf-group[data-date='" + date + "']");
      
      if (date != $group.attr("data-date")) {
        $group = $groupTemplate.clone().appendTo($list);
        $group.attr("data-date", date);
        $group.find(".perf-group-title").text(formatDate(perf.DateTimeFrom, BLMob.Rights.LongDateFormat));
      }
      
      $group.find(".perf-group-body").append(renderPerf(list[i]));
    }
  }
  
  function renderPerf(perf) {
    var $item = $itemTemplate.clone();
    $item.setClass("seat-allocation", perf.SeatAllocation === true);
    $item.attr("data-eventid", perf.EventId);
    $item.attr("data-performanceid", perf.PerformanceId);
    $item.attr("data-datetimefrom", perf.DateTimeFrom);
    $item.find(".perf-item-timefrom").text(formatTime(perf.DateTimeFrom));
    $item.click(onPerformanceClick);
    
    var $avail = $item.find(".perf-item-avail");
    if (perf.QuantityFree == 0) 
      $avail.text(itl("@Seat.SoldOut")).css("color", "var(--base-red-color)");
    else {
      $avail.text(perf.QuantityFree);
      if (perf.QuantityFree < perf.SoldOutWarnLimit) 
        $avail.css("color", "var(--base-orange-color)");
    } 
    
    
    return $item;
  }

  function onPerformanceClick() {
    var $item = $(this);
    UIMob.tabSlideView({
      container: $view.closest(".tab-content"),
      packageName: PKG_CAS, 
      viewName: "performance",
      params: {
        "PerformanceId": $item.attr("data-performanceid"),
        "PerfDateTime": $item.attr("data-datetimefrom"),
        "EventId": params.EventId,
        "RootCatalogId": params.RootCatalogId,
        "EventCatalogId": params.EventCatalogId
      }
    });
  }
});
