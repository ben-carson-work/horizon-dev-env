<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.web.search.*"%>
<%@page import="com.vgs.snapp.web.queue.outbound.*"%>
<%@page import="com.vgs.snapp.search.dataobject.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.dataobject.transaction.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTransaction" scope="request"/>
<jsp:useBean id="transaction" class="com.vgs.snapp.dataobject.transaction.DOTransaction" scope="request"/>

<v:grid>
  <thead>
    <v:grid-title caption="@Common.Changes"/>
    <tr>
      <td><v:itl key="@Ledger.LedgerAccount"/></td>
      <td><v:itl key="@Account.Account"/></td>
      <td align="right"><v:itl key="@Ledger.LedgerDebit"/></td>
      <td align="right"><v:itl key="@Ledger.LedgerCredit"/></td>
    </tr>
  </thead>
  <tbody>
    <% JvDateTime date = null; %>
    <% for (DOTransactionLedgerBalance item : transaction.LedgerBalanceList) { %>
      <% if ((date == null) || !date.isSameDay(item.LedgerFiscalDate.getDateTime())) { %>
        <% date = item.LedgerFiscalDate.getDateTime(); %>
        <v:grid-group><i class="fa fa-calendar-alt"></i> <%=date.format(pageBase.getShortDateFormat())%></v:grid-group>
      <% } %>
      <tr class="grid-row">
        <td>
          <div><%=item.LedgerAccountName.getHtmlString()%></div>
          <div class="list-subtitle"><%=item.LedgerAccountCode.getHtmlString()%></div>
        </td>
        <td>
          <div><%=item.AccountName.getHtmlString()%></div>
          <div class="list-subtitle"><%=item.AccountCode.getHtmlString()%></div>
        </td>
        <td align="right">
          <%=(item.BalanceDelta.getMoney() < 0) ? pageBase.formatCurr(-item.BalanceDelta.getMoney()) : "&nbsp;"%>
        </td>
        <td align="right">
          <%=(item.BalanceDelta.getMoney() >= 0) ? pageBase.formatCurr(item.BalanceDelta) : "&nbsp;"%>
        </td>
      </tr>
    <% } %>
  </tbody>
</v:grid>