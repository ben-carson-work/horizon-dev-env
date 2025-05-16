<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="view-medialookup-tickets">
  <div class="tab-header">
    <div class="toolbar-button btn-toolbar-back"></div>
    <div class="toolbar-button btn-float-right"></div>
    <div class="tab-header-title"><div class="snp-itl" data-key="@Ticket.Tickets"/></div>
  </div>
  <div class="tab-body">
    <div class="scroll-content">
      <div class="search-list"/>
    </div>
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

/**
 * params = {
 *   PortfolioId: string,
 *   onItemClick: function($view, ticketRef)
 * }
 */
UIMob.init("medialookup-tickets", function($view, params) {
  var $tabBody = $view.find(".tab-body");

  UIMob.initSearch({
    "Body": $tabBody,
    "Cmd": "Ticket",
    "Command": "Search",
    "ListNodeName": "TicketList",
    "renderItem": renderTicket,
    "CommandDO": {
      "PortfolioId": params.PortfolioId,
      "Sorting": ["SmartPriorityOrder"]
    }
  });
  
  function renderTicket(ticket) {
    var price = formatCurr(ticket.UnitAmount);
    if (ticket.GroupQuantity != 1)
      price = ticket.GroupQuantity + " x " + price;
    
    var $ticket = $view.find(".templates .list-item").clone().appendTo($tabBody.find(".search-list"));
    $ticket.data("ticket", ticket);
    $ticket.addClass(COMMON_STATUS[ticket.CommonStatus]);
    $ticket.find(".pticket-tdssn .list-item-text").text(ticket.TicketCode);
    $ticket.find(".pticket-status .list-item-text").text(ticket.TicketStatusDesc);
    $ticket.find(".pticket-product-name .list-item-text").text(ticket.ProductName);
    $ticket.find(".pticket-product-code .list-item-text").text(ticket.ProductCode);
    $ticket.find(".pticket-price .list-item-text").html(price);
    
    var perf = null
    if ((ticket.PerformanceList) && (ticket.PerformanceList.length > 0)) 
      perf = ticket.PerformanceList[0].Performance;
    
    if (perf == null) {
      $ticket.find(".pticket-event").remove();
      $ticket.find(".pticket-perf").remove();
    }
    else {
      $ticket.find(".pticket-event .list-item-text").text(perf.EventName);
      $ticket.find(".pticket-perf .list-item-text").text(formatShortDateTimeFromXML(perf.DateTimeFrom));
    }
    
    if (params.onItemClick) {
      $ticket.click(function() {
        params.onItemClick($view, $(this).data("ticket"));
      });
    }
  }

});

</script>
