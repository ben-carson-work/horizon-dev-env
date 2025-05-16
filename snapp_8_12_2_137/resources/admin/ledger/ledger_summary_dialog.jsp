<%@page import="com.vgs.snapp.dataobject.ledger.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% 
String groupEntityId = pageBase.getNullParameter("GroupEntityId");
List<DOLedgerSummaryRef> list = pageBase.getBL(BLBO_Ledger.class).loadPortfolioSummaryRef(groupEntityId);
%>

<v:dialog id="ledger_summary_dialog" title="@Ledger.SummarizedLedger" width="800" height="600">

  <v:grid>
    <thead>
      <tr>
        <td width="60%">
          <v:itl key="@Account.Account"/>
        </td>
        <td width="20%" align="right">
          <v:itl key="@Ledger.LedgerDebit"/>
        </td>
        <td width="20%" align="right">
          <v:itl key="@Ledger.LedgerCredit"/>
        </td>
      </tr>
    </thead>
    
    <tbody>
    <% for (DOLedgerSummaryRef summary : list) { %>
      <tr class="grid-row">
        <td>[<%=summary.LedgerAccountCode.getHtmlString()%>] <%=summary.LedgerAccountName.getHtmlString()%></td>
        <td align="right"><%=(summary.DebitAmount.getMoney() == 0)  ? "" : pageBase.formatCurrHtml(summary.DebitAmount)%></td>
        <td align="right"><%=(summary.CreditAmount.getMoney() == 0) ? "" : pageBase.formatCurrHtml(summary.CreditAmount)%></td>
      </tr>
    <% } %>
    </tbody>
  </v:grid>

</v:dialog>


<%-- 
  String groupEntityId = pageBase.getNullParameter("GroupEntityId");
  String groupEntityType = pageBase.getNullParameter("GroupEntityType");
  JvDataSet ds = pageBase.getDB().executeQuery(
      "select" + JvString.CRLF + 
      "  LDGA.LedgerAccountName," + JvString.CRLF +
      "  LDGA.LedgerAccountCode," + JvString.CRLF +
      "  sum(LedgerAmount) as LedgerAmount" + JvString.CRLF +
      "from" + JvString.CRLF +
      "  tbLedger LDG left join" + JvString.CRLF +
      "  tbLedgerAccount LDGA on LDGA.LedgerAccountId=LDG.LedgerAccountId" + JvString.CRLF +
      "where" + JvString.CRLF +
      "  LDG.GroupEntityId=" + JvString.sqlStr(groupEntityId) + JvString.CRLF +
      "group by  LDG.LedgerAccountId, LDGA.LedgerAccountName, LDGA.LedgerAccountCode" + JvString.CRLF +
      "having(sum(LedgerAmount)!=convert(money,0))" + JvString.CRLF +
      "order by LedgerAmount");



<div id="ledger_summary_dialog">
  <v:grid dataset="<%=ds%>" clazz="ledger_summary_table">
    <tr class="header">
      <td width="60%">
        <v:itl key="@Account.Account"/>
      </td>
      <td width="20%" align="right">
        <v:itl key="@Ledger.LedgerDebit"/>
      </td>
      <td width="20%" align="right">
        <v:itl key="@Ledger.LedgerCredit"/>
      </td>
    </tr>
    
    <v:grid-row dataset="<%=ds%>">
      <%float ledgerAmount = Float.parseFloat(ds.getField("LedgerAmount").getHtmlString());%>
      <td>[<%=ds.getField("LedgerAccountCode").getHtmlString()%>] <%=ds.getField("LedgerAccountName").getHtmlString()%></td>
      <td align="right"><%=ledgerAmount < 0 ? pageBase.formatCurrHtml(Math.abs(ledgerAmount)) : ""%></td>
      <td align="right"><%=ledgerAmount > 0 ? pageBase.formatCurrHtml(Math.abs(ledgerAmount)) : ""%></td>
    </v:grid-row>
  </v:grid>

<script>
$(document).ready(function() {
  
  var dlg = $("#ledger_summary_dialog");
  dlg.dialog({
    title: "<v:itl key="@Ledger.SummarizedLedger"/>",
    modal: true,
    width: 800,
    height: 600,
    close: function() {
      dlg.remove();
    },
    buttons: {
      <v:itl key="@Common.Ok" encode="JS"/>: function() {
        dlg.dialog("close");
      }
    }
  });
});
</script>

</div>
--%>

