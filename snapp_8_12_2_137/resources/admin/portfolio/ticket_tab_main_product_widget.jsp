<%@page import="java.util.stream.Collectors"%>
<%@page import="com.vgs.snapp.web.search.*"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.web.servlet.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTicket" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="ticket" class="com.vgs.snapp.dataobject.DOTicket" scope="request"/>


<style>
  ul.perf-list {margin: 0px; padding: 0px 0px 0px 20px;}
  ul.perf-list>li {margin-bottom: 4px;}
</style>


<script>

function showLedgerDialog() {
  asyncDialogEasy("ledger/ledgerref_dialog", "RefEntityId=<%=ticket.TicketId.getHtmlString()%>");
}

function showLedgerAllocatedDialog(gateCategoryId) {
  var params = "id=<%=ticket.TicketId.getHtmlString()%>";
  if (gateCategoryId)
    params = params + "&GateCategoryId=" + gateCategoryId;
  asyncDialogEasy("ledger/ledger_allocated_dialog", params);
}

function showTicketClearingBreakdown() {
	var params = "id=<%=ticket.TicketId.getHtmlString()%>";
	asyncDialogEasy("ledger/ticket_clearing_breakdown_dialog", params);
}

</script>


<v:widget caption="@Product.ProductType">
  <v:widget-block>
    <v:recap-item caption="@Common.Name">
      <snp:entity-link entityId="<%=ticket.ProductId%>" entityType="<%=LkSNEntityType.ProductType%>"><%=ticket.ProductName.getHtmlString()%></snp:entity-link>
      <% if (!ticket.GiftCardNumber.isNull()) { %>
        &mdash; <%=ticket.GiftCardNumber.getHtmlString()%>
      <% } %>
    </v:recap-item>

    <v:recap-item caption="@Common.Code"><%=ticket.ProductCode.getHtmlString()%></v:recap-item>
    <v:recap-item caption="@Common.Description" include="<%=!ticket.SaleItemDetailDescription.isNull()%>"><%=ticket.SaleItemDetailDescription.getHtmlString()%></v:recap-item>
    <v:recap-item caption="@Product.Price"><%=pageBase.formatCurrHtml(ticket.UnitAmount)%></v:recap-item>
    <v:recap-item caption="@Product.Tax"><%=pageBase.formatCurrHtml(ticket.UnitTax)%></v:recap-item>
  </v:widget-block>

  <v:widget-block include="<%=!ticket.UnitFaceAmount.isNull() && (ticket.UnitFaceAmount.getMoney() != ticket.UnitAmount.getMoney())%>">
    <v:recap-item caption="@Product.FacePrice"><%=pageBase.formatCurrHtml(ticket.UnitFaceAmount)%></v:recap-item>
    <v:recap-item caption="@Product.Tax"><%=pageBase.formatCurrHtml(ticket.UnitFaceTax)%></v:recap-item>
  </v:widget-block>
  
  <v:widget-block include="<%=!ticket.GroupTicketOption.isLookup(LkSNGroupTicketOption.NoGroup)%>">
    <v:recap-item caption="@Product.GroupTicketOption"><%=ticket.GroupTicketOption.getHtmlLookupDesc(pageBase.getLang())%></v:recap-item>
    <v:recap-item caption="@Common.Quantity"><%=ticket.GroupQuantity.getHtmlString()%></v:recap-item>
  </v:widget-block>

  <v:widget-block>
    <v:recap-item caption="@Ledger.ClearingAllocatedLimit">
      <div>
        <a href="javascript:showLedgerAllocatedDialog(null)"><%=pageBase.formatCurrHtml(ticket.ClearingUsedAmount)%></a> / <%=pageBase.formatCurrHtml(ticket.ClearingLimitAmount)%>     
        <a href="javascript:showTicketClearingBreakdown()"><i class="fa-solid fa-circle-c"></i></a>
      </div>
      <% if ((ticket.LedgerCount.getInt() > 0) && pageBase.getRights().AuditLedger.getBoolean()) { %>
        <v:recap-item><a href="javascript:showLedgerDialog()"><v:itl key="@Ledger.Ledger"/></a></v:recap-item>
      <% } %>
    </v:recap-item>
  </v:widget-block>
  
  <v:widget-block include="<%=!ticket.InstallmentContractId.isNull()%>">
    <v:recap-item caption="@Installment.InstallmentContract"><snp:entity-link entityId="<%=ticket.InstallmentContractId%>" entityType="<%=LkSNEntityType.InstallmentContract%>"><%=ticket.InstallmentContractCode.getHtmlString()%></snp:entity-link></v:recap-item>
  </v:widget-block>

  <% List<DOTicketRef.DOTicketPerformanceRef> performances = ticket.TicketPerformanceList.filter(x -> x.ValidForAdmission.getBoolean()); %>
  <v:widget-block include="<%=!performances.isEmpty() || ticket.PerformanceBeforeUsage.getBoolean()%>">
    <v:recap-item caption="@Performance.Performance">
      <% if ((performances.size() > 1) || ticket.PerformanceBeforeUsage.getBoolean()) { %>
        <a href="<%=pageBase.getContextURL()%>?page=ticket&tab=performance&id=<%=ticket.TicketId.getString()%>"><%=ticket.PerformanceDesc.getHtmlString()%></a>
      <% } else { %>
        <% DOTicketRef.DOTicketPerformanceRef perf = performances.get(0); %>
        <snp:entity-link entityType="<%=LkSNEntityType.Event%>" entityId="<%=perf.Performance.EventId%>"><%=perf.Performance.EventName.getHtmlString()%></snp:entity-link>
        &raquo;
        <% String jspPerfTooltip = "portfolio/ticket_performance_tooltip&TicketId=" + ticket.TicketId.getHtmlString() + "&PerformanceId=" + perf.Performance.PerformanceId.getHtmlString(); %>
        <span class="v-tooltip" data-jsp="<%=jspPerfTooltip%>"><snp:entity-link entityType="<%=LkSNEntityType.Performance%>" entityId="<%=perf.Performance.PerformanceId.getString()%>"><%=JvString.escapeHtml(pageBase.format(perf.Performance.DateTimeFrom, pageBase.getShortDateTimeFormat()))%></snp:entity-link></span>
        
        <% if (!perf.Exception.isEmpty()) { %>
          <i class="fa fa-exclamation-circle"></i>
        <% } %>
      <% } %>
    </v:recap-item>
  </v:widget-block>

</v:widget>
