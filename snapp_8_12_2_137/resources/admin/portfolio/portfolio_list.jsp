<%@page import="com.vgs.vcl.JvImageCache"%>
<%@page import="com.vgs.snapp.web.search.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.servlet.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PagePortfolioList" scope="request"/>

<%
QueryDef qdef = pageBase.getBL(BLBO_QueryRef_Ticket.class).prepareQuery();
qdef.addFilter(QryBO_Ticket.Fil.AccountId, pageBase.getId());
qdef.addFilter(QryBO_Ticket.Fil.PrivilegeCard, "true");
qdef.addSort(QryBO_Ticket.Sel.SmartPriorityOrder);
List<DOTicketRef> listPrivilegeCard = pageBase.getBL(BLBO_QueryRef_Ticket.class).getList(qdef);

@SuppressWarnings("unchecked")
List<DOPortfolioRef> portfolioList = (List<DOPortfolioRef>)request.getAttribute("portfolioList");
DOPortfolioRef portfolioRef = portfolioList.stream().filter(portfolio -> portfolio.PortfolioId.isSameString(portfolio.MainPortfolioId.getString())).findFirst().orElse(null);
request.setAttribute("portfolio", portfolioRef);
%>

<style>
.portfolio-block {
  display: inline-block;
  width: 32%;
  vertical-align: top;
  margin-right: 5px;
}

.tab-content.hide-inactive .item-status-inactive {
  display: none;
}
  
.portfolio-block .widget-block.group  {
  padding: 4px 10px 4px 10px;
  font-weight: bold;
  background-color: #F2F2F2;
}

.portfolio-block .pane-container {
  display: flex;
  justify-content: space-between;
  padding: 5px;
}

.portfolio-block .pane-container .pane-item {
  margin: 5px;
}

.portfolio-block .pane-container .pane-detail {
  flex-grow: 1;
}

.portfolio-block .pane-icon {
  width: 32px;
  height: 32px;
}

.portfolio-block .pane-handle {
  font-size: 2em;
  color: rgba(0,0,0,0.25);
  width: 32px;
  text-align: center;
  cursor: grab;
}

.tab-content.hide-prioritize-handle .pane-handle {
  display: none;
}

.portfolio-block .pane-container.ui-sortable-helper {
  background: white;
  border: 1px var(--border-color) solid;
}


</style>

<div class="tab-toolbar">
  <v:button id="btn-prioritize" clazz="hide-prioritize-handle" caption="@Ticket.Prioritize" fa="sort-numeric-up"/>
  <v:button id="btn-hide-inactive" clazz="active" caption="@Ticket.HideInactiveTickets" fa="eye-slash"/>
</div>

<div id="portfolio-tab-content" class="tab-content hide-inactive hide-prioritize-handle">

  <v:widget caption="@Common.General" clazz="portfolio-block">
    <%
    request.setAttribute("show-account-name", "false");
    %>
    <jsp:include page="portfolio_accountwallet_widget.jsp"/>

    <% if (!listPrivilegeCard.isEmpty()) { %>
      <v:widget-block clazz="group">Privilege cards</v:widget-block>
    <% } %>
    <% for (DOTicketRef privilegeCard : listPrivilegeCard) { %>
      <% String blockClass = "pane-container " + (privilegeCard.TicketStatus.isLookup(LkSNTicketStatus.Active) ? "item-status-active" : "item-status-inactive"); %>
      <v:widget-block clazz="<%=blockClass%>">
        <img class="pane-item pane-icon" src="<v:image-link name="<%=privilegeCard.IconName.getString()%>" size="32"/>"/>
        <div class="pane-item pane-detail">
          <% if (privilegeCard.TicketId.isSameString(pageBase.getParameter("TicketId"))) { %>
          <strong><%=privilegeCard.TicketCode.getHtmlString()%></strong>
          <% } else { %>
          <snp:entity-link entityId="<%=privilegeCard.TicketId%>" entityType="<%=LkSNEntityType.Ticket%>" clazz="list-title">
            <%=privilegeCard.TicketCode.getHtmlString()%>
          </snp:entity-link>
          <% } %>
          <span class="recap-value">
          <%=pageBase.formatCurrHtml(privilegeCard.UnitAmount)%>
          </span><br/>
          
          <% if (!privilegeCard.ProductId.isNull()) { %>
            <snp:entity-link entityId="<%=privilegeCard.ProductId%>" entityType="<%=LkSNEntityType.ProductType%>">
              <%=privilegeCard.ProductName.getHtmlString()%>
            </snp:entity-link>
            <br/>  
            <% if (privilegeCard.PerformanceList.getSize() > 1) { %>
              <v:itl key="@Performance.MultiplePerformance"/>
            <% } else if (privilegeCard.PerformanceList.getSize() == 1) { %>
              <% DOPerformanceRef perf = privilegeCard.PerformanceList.getItem(0).Performance; %>
              <snp:entity-link entityId="<%=perf.EventId%>" entityType="<%=LkSNEntityType.Event%>">
                <%=perf.EventName.getHtmlString()%>
              </snp:entity-link>
              &raquo;
              <snp:entity-link entityId="<%=perf.PerformanceId%>" entityType="<%=LkSNEntityType.Performance%>">
                <snp:datetime timestamp="<%=perf.DateTimeFrom%>" format="shortdatetime" timezone="location" convert="false"/>
              </snp:entity-link>
            <% } %>
          <% } %>
        </div>
      </v:widget-block>
    <% } %>
  </v:widget>

  <% for (DOPortfolioRef portfolio : portfolioList) { %>
    <v:widget caption="@Common.Portfolio" icon="<%=portfolio.IconName.getString()%>" clazz="portfolio-block">
      <% String id = portfolio.PortfolioId.getEmptyString(); %>
      <div id="portfolio-widget-<%=id%>"></div>
      <script>asyncLoad("#portfolio-widget-<%=id%>", "<%=pageBase.getContextURL()%>?page=portfolio_widget&id=<%=id%>");</script>
    </v:widget>
  <% } %>
</div>

<script>
$(document).ready(function() {
  var $btnPrioritize = $("#btn-prioritize");
  $btnPrioritize.click(function() {
    $btnPrioritize.toggleClass("active");
    $("#portfolio-tab-content").setClass("hide-prioritize-handle", !$btnPrioritize.hasClass("active"));
    initializeSortable();
  });

  $btnHide = $("#btn-hide-inactive");
  $btnHide.click(function() {
    $btnHide.toggleClass("active");
    $("#portfolio-tab-content").setClass("hide-inactive", $btnHide.hasClass("active"));
  });
  
  function initializeSortable() {
    var $items = $(".portfolio-block .ticket-list:not(.sort-initialized)");
    $items.sortable({
      handle: ".pane-handle",
      helper: fixHelper,
      stop: function(event, ui) {
        var $ticketCont = $(ui.item).closest(".ticket-list");
        var ticketIDs = [];
        $ticketCont.find(".pane-container").each(function(index, elem) {
          ticketIDs.push($(elem).attr("id"));
        }); 
        
        doTicketChangePriority($ticketCont.attr("data-portfolioid"), ticketIDs);
      }
    });
    $items.addClass("sort-initialized");
  }
});
</script>