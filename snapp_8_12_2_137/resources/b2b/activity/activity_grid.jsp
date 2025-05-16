<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_AccountDepositLog.class);
// Select
qdef.addSelect(QryBO_AccountDepositLog.Sel.SaleId);
qdef.addSelect(QryBO_AccountDepositLog.Sel.SaleCode);
qdef.addSelect(QryBO_AccountDepositLog.Sel.TransactionId);
qdef.addSelect(QryBO_AccountDepositLog.Sel.TransactionCode);
qdef.addSelect(QryBO_AccountDepositLog.Sel.TransactionDateTime);
qdef.addSelect(QryBO_AccountDepositLog.Sel.TransactionType);
qdef.addSelect(QryBO_AccountDepositLog.Sel.TransactionFlags);
qdef.addSelect(QryBO_AccountDepositLog.Sel.LocationId);
qdef.addSelect(QryBO_AccountDepositLog.Sel.LocationName);
qdef.addSelect(QryBO_AccountDepositLog.Sel.UserAccountName);
qdef.addSelect(QryBO_AccountDepositLog.Sel.LogAmount);
qdef.addSelect(QryBO_AccountDepositLog.Sel.DepositBalance);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Where
qdef.addFilter(QryBO_AccountDepositLog.Fil.AccountId, pageBase.getSession().getOrgAccountId());

if (pageBase.getNullParameter("FromDate") != null) 
  qdef.addFilter(QryBO_AccountDepositLog.Fil.FiscalDateFrom, pageBase.getNullParameter("FromDate"));

if (pageBase.getNullParameter("ToDate") != null) 
  qdef.addFilter(QryBO_AccountDepositLog.Fil.FiscalDateTo, pageBase.getNullParameter("ToDate"));

if (pageBase.getNullParameter("SaleCode") != null) 
  qdef.addFilter(QryBO_AccountDepositLog.Fil.SaleCode, pageBase.getNullParameter("SaleCode"));

// Sort
qdef.addSort(QryBO_AccountDepositLog.Sel.LogFiscalDate, false);
qdef.addSort(QryBO_AccountDepositLog.Sel.LogSerial, false);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid id="depositlog-grid" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Account_LocOrg%>">
  <thead>
    <tr>
      <td></td>
      <td width="120px" nowrap>
        <v:itl key="@Common.Transaction"/><br/>
        <v:itl key="@Common.DateTime"/>
      </td>
      <td width="80px" nowrap>
        <v:itl key="@Sale.PNR"/>
      </td>
	    <td width="120px" nowrap>
	      <v:itl key="@Reservation.Flags"/><br/>
	      <v:itl key="@Common.Type"/>
	    </td>
      <td width="100%">
        <v:itl key="@Account.Location"/> / <v:itl key="@Common.User"/>
      </td>
      <td width="120px" align="right" nowrap>
        <v:itl key="@Common.Amount"/><br/>
        <v:itl key="@Common.Balance"/>
      </td>
    </tr>
  </thead>
  
  <tbody>
    <v:grid-row dataset="ds">
      <% LookupItem transactionType = LkSN.TransactionType.getItemByCode(ds.getField(QryBO_AccountDepositLog.Sel.TransactionType)); %>
      <td><v:grid-icon name="transaction.png"/></td>
      <td nowrap>
        <%=ds.getField(QryBO_AccountDepositLog.Sel.TransactionCode).getHtmlString()%>
        <br/>
        <snp:datetime timestamp="<%=ds.getField(QryBO_AccountDepositLog.Sel.TransactionDateTime)%>" format="shortdatetime" timezone="local" clazz="list-subtitle"/>
      </td>
      <td nowrap>
        <%=ds.getField(QryBO_AccountDepositLog.Sel.SaleCode).getHtmlString()%>
      </td>
      <td nowrap>
        <%=ds.getField(QryBO_AccountDepositLog.Sel.TransactionFlags).getHtmlString()%><br/>
        <span class="list-subtitle"><%=transactionType.getHtmlDescription(pageBase.getLang())%></span>
      </td>
      <td>
        <%=ds.getField(QryBO_AccountDepositLog.Sel.LocationName).getHtmlString()%>
      </td>
      <td align="right" nowrap>
        <%
          long amount = ds.getField(QryBO_AccountDepositLog.Sel.LogAmount).getMoney();
          String color = (amount >= 0) ? "" : "color:#ff0000";
        %>
        <span style="<%=color%>"><%=pageBase.formatCurrHtml(amount)%></span><br/>
        <span class="list-subtitle"><%=pageBase.formatCurrHtml(ds.getField(QryBO_AccountDepositLog.Sel.DepositBalance))%></span>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>
