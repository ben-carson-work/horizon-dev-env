<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="view-portfolio-list">
  <div class="tab-header">
    <div class="toolbar-button btn-toolbar-back"></div>
    <div class="toolbar-button btn-float-right"></div>
    <div class="tab-header-title"><div class="snp-itl" data-key="@Common.Portfolios"/></div>
  </div>
  <div class="tab-body">
    <div class="scroll-content">
      <div class="search-list"/>
    </div>
  </div>
</div>


<script>
//# sourceURL=mob-view-portfolio-list.jsp

/**
 * params = {
 *   AccountId: string,
 *   ActivePrivilegeCardOnly: boolean,
 *   onItemClick: function($view, portfolioRef)
 * }
 */
UIMob.init("portfolio-list", function($view, params) {
  var $tabBody = $view.find(".tab-body");
  
  UIMob.initSearch({
    "Body": $tabBody,
    "Cmd": "Portfolio",
    "Command": "Search",
    "ListNodeName": "PortfolioList",
    "afterSearch": afterSearch,
    "renderItem": renderPortfolio,
    "CommandDO": {
      "Sorting": "CreateDateTime",
      "AccountId": params.AccountId,
      "ActivePrivilegeCardOnly": params.ActivePrivilegeCardOnly
    }
  });
  
  function pickPortfolio(portfolio) {
    if (params.onItemClick) 
      params.onItemClick($view, portfolio);
  }
  
  function afterSearch(ansDO) {
    if (ansDO.TotalRecordCount == 1) 
      pickPortfolio(ansDO.PortfolioList[0]);
  }
  
  function renderPortfolio(portfolio) {
    var $item = $("<div class='list-item'/>").appendTo($view.find(".search-list"));
    $item.data("portfolio", portfolio);
    
    var ticketDesc = null;
    if (portfolio.TicketCount > 0) {
      ticketDesc = portfolio.MainTicketProductName;
      if (portfolio.TicketCount > 1)
        ticketDesc = portfolio.TicketCount + " " + itl("@Ticket.Tickets") + " (" + ticketDesc + ")";
    }
    
    var mediaDesc = null;
    if (portfolio.MediaCount > 0) {
      mediaDesc = portfolio.MainMediaCalcCode;
      if (portfolio.MediaCount > 1)
        mediaDesc = portfolio.MediaCount + " " + itl("@Common.Medias") + " (" + mediaDesc + ")";
    }
    
    $item.addClass(COMMON_STATUS[portfolio.MainPortfolio ? LkSN.CommonStatus.Completed.code : LkSN.CommonStatus.Active.code]);
    UIMob.addListItemProperty($item, formatShortDateTimeFromXML(portfolio.CreateDateTime), "", "list-item-title");
    UIMob.addListItemProperty($item, ticketDesc, "tag");
    UIMob.addListItemProperty($item, mediaDesc, "credit-card");
    UIMob.addListItemProperty($item, (portfolio.PrivilegeCardCount == 0) ? null : portfolio.PrivilegeCardCount + " " + itl("@Common.Memberships"), "award");
    
    $item.click(function() {
      pickPortfolio($(this).data("portfolio"));
    });
  }
});

</script>
