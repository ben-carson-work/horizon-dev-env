<%@page import="com.vgs.snapp.dataobject.ticket.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="vgs-tags" prefix="v" %>
<%@taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
List<DOTicketTransactionHistoryRef> tickets = pageBase.getBL(BLBO_Ticket.class).getTicketTrasactionHistory(pageBase.getId());
%>

<v:dialog id="ticket_upgrade_history_dialog" title="Upgrade History" width="800" height="600" autofocus="false">


<v:grid>
  <tbody>
  <% for (DOTicketTransactionHistoryRef ticket : tickets) { %>
    <tr class="group">
      <td colspan="2" style="<v:common-status-style status="<%=ticket.CommonStatus%>"/>">
        <snp:entity-link entityId="<%=ticket.TicketId%>" entityType="<%=LkSNEntityType.Ticket%>" clazz="list-title"><%=ticket.TicketCode.getHtmlString()%></snp:entity-link>
      </td>
      <td>
        <snp:entity-link entityId="<%=ticket.ProductId%>" entityType="<%=LkSNEntityType.ProductType%>"><%=ticket.ProductName.getHtmlString()%></snp:entity-link>
        <% if (ticket.PerformanceCount.getInt() > 0) { %>
          &nbsp;&mdash;&nbsp;
          <div class="list-subtitle">
          <% if (ticket.PerformanceCount.getInt() > 1) { %>
            <v:itl key="@Performance.MultiplePerformance"/>
          <% } else { %>
            <snp:entity-link entityId="<%=ticket.FirstPerformance.EventId%>" entityType="<%=LkSNEntityType.Event%>"><%=ticket.FirstPerformance.EventName.getHtmlString()%></snp:entity-link>
            &raquo;
            <snp:entity-link entityId="<%=ticket.FirstPerformance.PerformanceId%>" entityType="<%=LkSNEntityType.Performance%>"><%=ticket.FirstPerformance.DateTimeFrom.formatHtml(pageBase.getShortDateTimeFormat())%></snp:entity-link>
          <% } %>
          </div>
        <% } %>
      </td>
      <td align="right" nowrap>
        <%if (ticket.GroupQuantity.getInt() > 1) { %> 
          <%=ticket.GroupQuantity.getInt()%> x 
        <% } %>
        <%=pageBase.formatCurrHtml(ticket.UnitAmount)%></td>
    </tr>
  
    <% for (DOTicketTransactionHistoryRef.DOTTH_Transaction transaction : ticket.TransactionList) { %>
      <tr class="grid-row">
        <td style="<v:common-status-style status="<%=ticket.CommonStatus%>"/>"></td>
        <td nowrap>
          <snp:entity-link entityId="<%=transaction.TransactionId%>" entityType="<%=LkSNEntityType.Transaction%>"><%=transaction.TransactionCode.getHtmlString()%></snp:entity-link>
          &nbsp;&mdash;&nbsp;
          <snp:entity-link entityId="<%=transaction.SaleId%>" entityType="<%=LkSNEntityType.Sale%>"><%=transaction.SaleCode.getHtmlString()%></snp:entity-link>
        </td>
        <td nowrap><span class="list-subtitle"><%=transaction.TransactionType.getHtmlLookupDesc(pageBase.getLang())%></span></td>
        <td align="right" nowrap><snp:datetime clazz="list-subtitle" timestamp="<%=transaction.TransactionDateTime%>" location="<%=transaction.LocationId%>" timezone="local" format="shortdatetime"/></td>
      </tr>
    <% } %>
    
    <tr><td colspan="100%">&nbsp;</td></tr>
  <% } %>
  </tbody>
</v:grid>

</v:dialog>


