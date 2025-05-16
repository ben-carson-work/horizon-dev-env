class PerformanceController {

  constructor($container, $scrollContainer, entityId, catalogId) {
    this.$container = $($container);
    this.$scrollContainer = $($scrollContainer);
    this.entityId = entityId;
    this.performanceSearchReqDO = this._buildPerfSearchRequest(entityId, catalogId);
  }
  
  _buildPerfSearchRequest(entityId, catalogId) {
    return {
      "SearchRecap": { 
        "RecordPerPage": 100,
        "PagePos": 0
      },
      "EventId": entityId,
      "EventCatalogId": catalogId,
      "SellableOnly": true,
      "ReturnAvailability": true,
      "ReturnProducts": true
    };
  }

  loadNextPerformancesIfNeeded(onClick) {
    if (this.$container.find(".kiosk-spinner").length <= 0) {
      let remaining = this.$container.height() - this.$scrollContainer.height() - this.$scrollContainer.scrollTop();
      if ((remaining < 100) && this.hasMore) {
        this.performanceSearchReqDO.SearchRecap.PagePos += 1;
        this.startPerformanceSearch(onClick);
      }
    }
  }

  startPerformanceSearch(onClick, pagePos) {
    let $spinner = $("#kiosk-templates .kiosk-spinner").clone().removeClass("show-loading").appendTo(this.$container);
    let reqDO = this.performanceSearchReqDO;
    if (pagePos)
      reqDO.SearchRecap.PagePos = pagePos;

    snappAPI().cmd("PERFORMANCE", "Search", reqDO)
      .then((ansDO) => {
        $spinner.remove();

        this.hasMore = reqDO.SearchRecap.PagePos * ansDO.SearchRecap.RecordPerPage < ansDO.SearchRecap.TotalRecordCount;

        let lastDate = this.$container.find(".performance-date").last().attr("data-date");
        for (const perf of (ansDO.PerformanceList || [])) {
          let thisDate = perf.DateTimeFrom.substr(0, 10);
          if (thisDate != lastDate) {
            lastDate = thisDate;
            this._createPerformanceDateUI(perf).appendTo(this.$container);
          }

          this._createPerformanceUI(perf, onClick).appendTo(this.$container);
        }

        this.loadNextPerformancesIfNeeded(onClick);
      })
      .catch((error) => {
        $spinner.remove();
        // TODO: $event.removeClass("loading").addClass("load-error");
        SNP_LOGGER.error(null, null, error);
      });
  }

  _createPerformanceUI(perf, onClick) {
    let $perf = $("#performance-templates .performance").clone();
    $perf.find(".performance-timeslot").text(formatTime(perf.DateTimeFrom));

    if (perf.SeatAllocation && perf.QuantityFree === 0)
      $perf.addClass("performance-status-soldout");
    else
      $perf.click(() => onClick(perf));

    return $perf;
  }

  _createPerformanceDateUI(perf) {
    let $date = $("#performance-templates .performance-date").clone();
    $date.attr("data-date", perf.DateTimeFrom.substr(0, 10));
    $date.text(formatDate(perf.DateTimeFrom));
    return $date;
  }
}