<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_AccountDepositLog.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.b2b.page.PageB2B_Dashboard" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_AccountDepositLog.class);
// Select
qdef.addSelect(Sel.SaleId);
qdef.addSelect(Sel.SaleCode);
qdef.addSelect(Sel.TransactionDateTime);
qdef.addSelect(Sel.LogAmount);
qdef.addSelect(Sel.DepositBalance);
// Filter
qdef.addFilter(Fil.AccountId, pageBase.getSession().getOrgAccountId());
// Sort
qdef.addSort(Sel.LogFiscalDate, false);
qdef.addSort(Sel.LogSerial, false);
// Paging
qdef.pagePos = 1;
qdef.recordPerPage = 5;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
%>

<v:grid>
  <v:grid-title caption="@Account.Credit.B2B_LastActivity"/>
  <v:grid-row dataset="<%=ds%>">
    <td width="50%">
      <%=ds.getField(Sel.SaleCode).getHtmlString()%><br/>
      <snp:datetime timestamp="<%=ds.getField(Sel.TransactionDateTime)%>" format="shortdatetime" timezone="local" clazz="list-subtitle"/>
    </td>
    <td width="50%" align="right">
      <% long logAmount = ds.getField(Sel.LogAmount).getMoney(); %>
      <span class="<%=(logAmount>=0)?"":"dashboard-red-value"%>"><%=pageBase.formatCurrHtml(logAmount)%></span><br/>
      <span class="list-subtitle"><%=pageBase.formatCurrHtml(ds.getField(Sel.DepositBalance))%></span>
    </td>
  </v:grid-row>
  <tr class="grid-row">
    <td colspan="100%" align="center"><a href="<v:config key="site_url"/>/b2b?page=activity_list" class="list-title"><v:itl key="@Common.ViewAll"/></a></td>
  </tr>
</v:grid>
