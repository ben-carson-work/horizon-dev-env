<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_LedgerAccount.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% boolean canEdit = rights.SettingsLedgerAccounts.canRead(); %>

<%
JvDateTime dateFrom = null;
if (pageBase.getNullParameter("DateFrom") != null)
  dateFrom = JvDateTime.createByXML(pageBase.getParameter("DateFrom"));
JvDateTime dateTo = null;
if (pageBase.getNullParameter("DateTo") != null)
  dateTo = JvDateTime.createByXML(pageBase.getParameter("DateTo"));

QueryDef qdef = new QueryDef(QryBO_LedgerAccount.class)
    .addSort(Sel.LedgerAccountCode)
    .addSelect(
    Sel.IconName,
    Sel.LedgerAccountId,   
    Sel.LedgerAccountCode, 
    Sel.LedgerAccountName, 
    Sel.LedgerAccountLevel,
    Sel.LedgerAccountLevelDesc, 
    Sel.LedgerAccountType, 
    Sel.LedgerAccountTypeDesc, 
    Sel.LedgerAccountTotal, 
    Sel.LedgerAccountTotalDebit, 
    Sel.LedgerAccountTotalCredit,
    Sel.AffectClearing)
    .setPaging(1, 1000);

// Filter

if (pageBase.getNullParameter("FromDate") != null)
  qdef.addFilter(Fil.FiscalDateFrom, pageBase.getParameter("FromDate"));

if (pageBase.getNullParameter("ToDate") != null)
  qdef.addFilter(Fil.FiscalDateTo, pageBase.getParameter("ToDate"));

if (pageBase.getNullParameter("LedgerAccountStatus") != null)
  qdef.addFilter(Fil.LedgerAccountStatus, JvArray.stringToArray(pageBase.getNullParameter("LedgerAccountStatus"), ","));

//Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<style>
.ledger-subtotal {
  text-decoration: underline;
  font-style: italic;
}
.ledger-negative {
  color: var(--base-red-color);
}
</style>

<script>
function loadLedgerAccountDialog(ledgerAccountId) {
  var fromDate = "<%=pageBase.getEmptyParameter("FromDate")%>";
  var toDate = "<%=pageBase.getEmptyParameter("ToDate")%>";
  asyncDialogEasy("ledger/ledgeraccount_dialog", "id=" + ledgerAccountId + "&FromDate=" + fromDate + "&ToDate=" + toDate);
}
</script>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.LedgerAccount%>">
  <thead>
    <tr>
      <% if (canEdit) { %>
        <td><v:grid-checkbox header="true"/></td>
      <% } %>
      <td width="40%"><v:itl key="@Ledger.LedgerAccount"/></td>
      <td width="15%"><v:itl key="@Common.Level"/></td>
      <td width="15%"><v:itl key="@Common.Type"/></td>
      <td width="15%" align="right"><v:itl key="@Ledger.LedgerDebit"/></td>
      <td width="15%" align="right"><v:itl key="@Ledger.LedgerCredit"/></td>
      <td></td>
    </tr>
  </thead>
  <tbody>
    <% long totDebit = 0; %>
    <% long totCredit = 0; %>
    <% LookupItem prevType = null; %>
    <v:grid-row dataset="ds">
      <% 
      LookupItem ledgerAccountType = LkSN.LedgerAccountType.getItemByCode(ds.getField(Sel.LedgerAccountType)); 
      LookupItem ledgerAccountLevel = LkSN.LedgerAccountLevel.getItemByCode(ds.getField(Sel.LedgerAccountLevel)); 
      long balance = BLBO_Ledger.ledgerValue(ledgerAccountType, ds.getField(Sel.LedgerAccountTotal));
      
      String balanceClass = ledgerAccountLevel.isLookup(LkSNLedgerAccountLevel.SubAccount) ? "" : "ledger-subtotal";
      if (balance < 0)
        balanceClass += " ledger-negative";
      
      if (ledgerAccountLevel.isLookup(LkSNLedgerAccountLevel.SubAccount)) {
        totDebit += ds.getMoney(Sel.LedgerAccountTotalDebit);
        totCredit += ds.getMoney(Sel.LedgerAccountTotalCredit);
      }
      %>
      
      <% if (canEdit) { %>
        <td><v:grid-checkbox name="LedgerAccountId" dataset="ds" fieldname="LedgerAccountId"/></td>
      <% } %>
      <td>
        <%=BLBO_Ledger.getHtmlIndent(ds.getField(Sel.LedgerAccountCode).getString())%>
        <a class="list-title" href="javascript:loadLedgerAccountDialog('<%=ds.getField(Sel.LedgerAccountId).getHtmlString()%>')"><%=ds.getField(Sel.LedgerAccountCode).getHtmlString()%></a>
        &nbsp;
        <%=ds.getField(Sel.LedgerAccountName).getHtmlString()%>
      </td>
      <td>
        <span class="list-subtitle"><%=ledgerAccountLevel.getHtmlDescription(pageBase.getLang())%></span>
      </td>
      <td>
        <% if ((prevType == null) || (!prevType.isLookup(ledgerAccountType))) { %>
          <% prevType = ledgerAccountType; %>
          <span class="list-subtitle"><%=ledgerAccountType.getHtmlDescription(pageBase.getLang())%></span>
        <% } %>
      </td>
      <td align="right">
        <% if (!ds.getField(Sel.LedgerAccountTotalDebit).isNull()) { %>
          <span class="<%=balanceClass%>"><%=pageBase.formatCurrHtml(ds.getMoney(Sel.LedgerAccountTotalDebit))%></span>
        <% } %>
      </td>
      <td align="right">
        <% if (!ds.getField(Sel.LedgerAccountTotalCredit).isNull()) { %>
          <span class="<%=balanceClass%>"><%=pageBase.formatCurrHtml(ds.getMoney(Sel.LedgerAccountTotalCredit))%></span>
        <% } %>
      </td>
      <td align="center">
        <% if (ds.getBoolean(Sel.AffectClearing)) { %>
          <i class="fa-solid fa-circle-c"></i>
        <% } %>
      </td>
    </v:grid-row>
    <tr class="group">
      <% if (canEdit) { %>
        <td></td>
      <% } %>
      <td colspan="3"><v:itl key="@Common.Total"/></td>
      <td align="right"><%=pageBase.formatCurrHtml(totDebit)%></td>
      <td align="right"><%=pageBase.formatCurrHtml(totCredit)%></td>
    </tr>
  </tbody>
</v:grid>
    