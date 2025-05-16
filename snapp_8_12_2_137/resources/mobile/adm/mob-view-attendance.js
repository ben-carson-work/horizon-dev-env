UIMob.init("attendance", function($view, params) {
  $(document).von($view, "tabchange", onTabChange);
  
  function onTabChange(event, data) {
    if (data.NewTabCode == $view.closest(".tab-content").attr("data-tabcode")) {
      var $tabBody = $view.find(".tab-body").addClass("waiting");
      
      var dtFrom = new Date();
      var dtTo = new Date();
      dtFrom.setMinutes(dtFrom.getMinutes() - 30);
      dtTo.setHours(dtTo.getHours() + 10);
      
      snpAPI("Performance", "Search", {
        AccessPointId: BLMob.AccessPoint.AccessPointId,
        PerformingFromDateTime: dateToXML(dtFrom),
        PerformingToDateTime: dateToXML(dtTo),
        PagePos: 1,
        RecordPerPage: 10
      })
      .finally(function() {
        $tabBody.removeClass("waiting").empty();
      })
      .then(function(ansDO) {
        var list = [];
        if (ansDO.PerformanceList)
          list = ansDO.PerformanceList;
        
        for (var i=0; i<list.length; i++) {
          var perf = list[i];
          var $item = $view.find(".templates .attendance-item").clone().appendTo($tabBody);
          $item.find(".attendance-item-pic").css("background-image", "url(" + calcRepositoryURL(perf.EventProfilePictureId, "small") + ")");
          $item.find(".attendance-item-event").text(perf.EventName);
          $item.find(".attendance-item-time").text(perf.DateTimeFrom.substring(11, 16));

          var qty = perf.QuantityRedeemed;
          if (perf.QuantityMax == 0) 
            $item.find(".attendance-item-pbout").addClass("hidden");
          else {
            var perc = (perf.QuantityRedeemed / perf.QuantityMax) * 100;
            $item.find(".attendance-item-pbin").css("width", perc+"%");
            qty += " / " + perf.QuantityMax;
          }
          $item.find(".attendance-item-quantity").text(qty);
          
          var now = new Date();
          if ((now >= xmlToDate(perf.AdmDateTimeFrom)) && (now <= xmlToDate(perf.AdmDateTimeTo)))
            $item.addClass("status-open");
          else if ((now >= xmlToDate(perf.DateTimeFrom)) && (now <= xmlToDate(perf.DateTimeTo)))
            $item.addClass("status-busy");
        }
      })
      .catch(function(error) {
        $tabBody.text(error.message);
      });
    }
  }
});
