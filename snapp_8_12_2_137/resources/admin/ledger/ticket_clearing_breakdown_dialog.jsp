<%@page import="com.vgs.snapp.dataobject.DOTicket"%>
<%@page import="com.vgs.snapp.dataobject.ticket.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% DOTicket ticket = pageBase.getBL(BLBO_Portfolio.class).getPortfolioTicket(pageBase.getId()); %>

<v:dialog id="ticket_clearing_breakdown_dialog" title="@Ledger.TicketClearingBreakdown" width="1024" height="768" autofocus="false">

<v:grid>
  <thead>
    <tr>
      <td width="45%"><v:itl key="@Ledger.LedgerAccount"/></td>
      <td width="35%"><v:itl key="@Account.Account"/></td>
      <td align="right" width="10%"><v:itl key="@Ledger.LedgerDebit"/></td>
      <td align="right" width="10%"><v:itl key="@Ledger.LedgerCredit"/></td>
    </tr>
  </thead>
  <tbody>
  <% int lastLedgerAccountType = -1; %>
  <% for (DOTicketClearingBreakdown.DOTicketClearingBreakdownItem item : ticket.ClearingBreakdown.BreakdownList) { %>
    <% if (lastLedgerAccountType != item.LedgerAccountType.getInt()) { %>
      <% lastLedgerAccountType = item.LedgerAccountType.getInt(); %>
      <tr class="group" data-entitytype="" data-entityid="">
      <td colspan="100%">
        <%=item.LedgerAccountType.getLookupDesc()%>  
      </td>
    <% } %>
	  <tr class="grid-row">
	    <td> 
	      &nbsp;&nbsp;&nbsp;[<%=item.LedgerAccountCode.getHtmlString()%>] <%=item.LedgerAccountName.getHtmlString()%>
	    </td>
	    <td> 
        <%=item.AccountName.getHtmlString()%>
      </td>
	    <td align="right">
	      <%=pageBase.formatCurrHtml(item.DebitAmount.getMoney())%>
	    </td>
	    <td align="right">
	      <%=pageBase.formatCurrHtml(item.CreditAmount.getMoney())%>
	    </td>
	  </tr>
  <% } %>
	  <tr class="group">
	    <td><v:itl key="@Common.Total"/></td>
	    <td/>
	    <td align="right"><%=pageBase.formatCurrHtml(ticket.ClearingBreakdown.TotalDebitAmount.getMoney())%></td>
      <td align="right"><%=pageBase.formatCurrHtml(ticket.ClearingBreakdown.TotalCreditAmount.getMoney())%></td>
	  </tr>
  </tbody>
</v:grid>

<script>

$(document).ready(function() {
  var $dlg = $("#ticket_clearing_breakdown_dialog");
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      dialogButton("@Common.Close", doCloseDialog)
    ];
  });
});

</script>

</v:dialog>


