<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="view-ticketpickup">
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
//# sourceURL=mob-view-ticketpickup.jsp

/**
 * params = {
 *   AccountId: string,
 *   PorfolioId: string,
 *   ActivePrivilegeCardOnly: boolean
 * }
 */

UIMob.init("ticketpickup", function($view, params) {
  var $tabBody = $view.find(".tab-body");
  
  UIMob.initSearch({
    "Body": $tabBody,
    "Cmd": "Ticket",
    "Command": "Search",
    "ListNodeName": "TicketList",
    "afterSearch": afterSearch,
    "renderItem": renderTicket,
    "CommandDO": {
      "Sorting": ["SmartPriorityOrder"],
      "AccountId": params.AccountId,
      "PortfolioId": params.PortfolioId,
      "PrivilegeCardOnly": params.PrivilegeCardOnly,
      "ActiveOnly": params.ActiveOnly
    }
  });
  
  function pickTicket(ticket) {
    UIMob.tabNavBack("#page-main");
    if (params.callback)
      params.callback(ticket);
  }
  
  function afterSearch(ansDO) {
    if (ansDO.TotalRecordCount == 1) 
      pickTicket(ansDO.TicketList[0]);
  }

  function renderTicket(ticket) {
    var $item = $("<div class='list-item'/>").appendTo($view.find(".search-list"));
    $item.data("ticket", ticket);
    $item.addClass(COMMON_STATUS[ticket.CommonStatus]);

    var price = formatCurr(ticket.UnitAmount);
    if (ticket.GroupQuantity != 1)
      price = ticket.GroupQuantity + " x " + price;

    UIMob.addListItemProperty($item, ticket.ProductName, "", "list-item-title");
    UIMob.addListItemProperty($item, ticket.TicketCode, "code");
    
    if ((ticket.PerformanceList) && (ticket.PerformanceList.length > 0)) {
      var perf = ticket.PerformanceList[0].Performance;
      UIMob.addListItemProperty($item, perf.EventName, "calendar-alt");
      UIMob.addListItemProperty($item, formatShortDateTimeFromXML(perf.DateTimeFrom), "masks-theater");
    } 

    UIMob.addListItemProperty($item, ticket.ProductCode, "tag");
    UIMob.addListItemProperty($item, ticket.TicketCode, "code");
    UIMob.addListItemProperty($item, ticket.TicketStatusDesc, "flag");
    UIMob.addListItemProperty($item, price, "money-bill");
    
    $item.click(function() {
      pickTicket($(this).data("ticket"));
    });
  }

});

</script>
