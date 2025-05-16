<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="view-medialookup-tickets">
  <div class="tab-header">
    <div class="toolbar-button btn-toolbar-back"></div>
    <div class="toolbar-button btn-float-right"></div>
    <div class="tab-header-title"><div class="snp-itl" data-key="@Ticket.Tickets"/></div>
  </div>
  <div class="tab-body waiting">
  </div>
  
  
  <div class="templates">
    <div class="list-item">
      <div class="pticket-product-name mobile-ellipsis list-item-title"><span class="list-item-text"></span></div>
      <div class="pticket-event mobile-ellipsis"><i class="list-item-texticon fa fa-masks-theater"></i><span class="list-item-text"></span></div>
      <div class="pticket-perf mobile-ellipsis"><i class="list-item-texticon fa fa-calendar-alt"></i><span class="list-item-text"></span></div>
      <div class="pticket-product-code mobile-ellipsis"><i class="list-item-texticon fa fa-tag"></i><span class="list-item-text"></span></div>
      <div class="pticket-tdssn mobile-ellipsis"><i class="list-item-texticon fa fa-code"></i><span class="list-item-text"></span></div>
      <div class="pticket-status mobile-ellipsis"><i class="list-item-texticon fa fa-flag"></i><span class="list-item-text"></span></div>
      <div class="pticket-price mobile-ellipsis"><i class="list-item-texticon fa fa-money-bill"></i><span class="list-item-text"></span></div>
    </div>
  </div>
</div>


<script>

UIMob.init("medialookup-tickets", function($view, params) {
  var media = params.MediaRef;
  var $tabBody = $view.find(".tab-body");
  
  snpAPI("Ticket", "Search", {
    "PortfolioId": media.PortfolioId,
    "Sorting": ["SmartPriorityOrder"]
  })
  .finally(function() {
    $tabBody.removeClass("waiting");
  })
  .then(function(ansDO) {
    renderTickets(ansDO.TicketList || []);
  });
  
  function renderTickets(list) {
    for (var i=0; i<list.length; i++) {
      var ticket = list[i];
      
      var price = formatCurr(ticket.UnitAmount);
      if (ticket.GroupQuantity != 1)
        price = ticket.GroupQuantity + " x " + price;
      
      var $rec = $view.find(".templates .list-item").clone().appendTo($tabBody);      
      $rec.addClass(COMMON_STATUS[ticket.CommonStatus]);
      $rec.find(".pticket-tdssn .list-item-text").text(ticket.TicketCode);
      $rec.find(".pticket-status .list-item-text").text(ticket.TicketStatusDesc);
      $rec.find(".pticket-product-name .list-item-text").text(ticket.ProductName);
      $rec.find(".pticket-product-code .list-item-text").text(ticket.ProductCode);
      $rec.find(".pticket-price .list-item-text").html(price);
      
      var perf = null
      if ((ticket.PerformanceList) && (ticket.PerformanceList.length > 0)) 
        perf = ticket.PerformanceList[0].Performance;
      
      if (perf == null) {
        $rec.find(".pticket-event").remove();
        $rec.find(".pticket-perf").remove();
      }
      else {
        $rec.find(".pticket-event .list-item-text").text(perf.EventName);
        $rec.find(".pticket-perf .list-item-text").text(formatShortDateTimeFromXML(perf.DateTimeFrom));
      }
    }
  }

});

</script>
