<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_PaymentCredit.*"%>
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
QueryDef qdef = new QueryDef(QryBO_PaymentCredit.class);
// Select
qdef.addSelect(Sel.TransactionDesc);
qdef.addSelect(Sel.TransactionSaleCode);
qdef.addSelect(Sel.PaymentType);
qdef.addSelect(Sel.PaymentAmount);
qdef.addSelect(Sel.DueDate);
// Filter
qdef.addFilter(Fil.AccountId, pageBase.getSession().getOrgAccountId());
qdef.addFilter(Fil.CreditStatus, LkSNCreditStatus.Opened.getCode());
// Sort
qdef.addSort(Sel.DueDate, true);
qdef.addSort(Sel.CreateDateTime, true);
// Paging
qdef.pagePos = 1;
qdef.recordPerPage = 5;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
%>

<v:grid>
  <v:grid-title caption="@Account.Credit.B2B_LastCredits"/>
  <v:grid-row dataset="<%=ds%>">
    <td width="50%">
      <%=ds.getField(Sel.TransactionSaleCode).getHtmlString()%><br/>
      <span class="list-subtitle"><%=ds.getField(Sel.TransactionDesc).getHtmlString()%></span>
    </td>
    <td width="50%" align="right">
      <%
        JvDateTime dueDate = ds.getField(Sel.DueDate).getDateTime();
      %>
      <span class="<%=dueDate.isBefore(JvDateTime.date())?"dashboard-red-value":""%>"><%=pageBase.formatCurrHtml(ds.getField(Sel.PaymentAmount))%></span><br/>
      <span class="list-subtitle"><%=pageBase.format(dueDate, pageBase.getShortDateFormat())%></span>
    </td>
  </v:grid-row>
  <tr class="grid-row">
    <td colspan="100%" align="center"><a href="<v:config key="site_url"/>/b2b?page=credit_list" class="list-title"><v:itl key="@Common.ViewAll"/></a></td>
  </tr>
</v:grid>
