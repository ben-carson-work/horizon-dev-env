<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
	QueryDef qdef = new QueryDef(QryBO_UserActivity.class);
	// Select
	qdef.addSelect(QryBO_UserActivity.Sel.LoginDateTime);
	qdef.addSelect(QryBO_UserActivity.Sel.LogoutDateTime);
	qdef.addSelect(QryBO_UserActivity.Sel.WorkstationName);
	qdef.addSelect(QryBO_UserActivity.Sel.ProductCount);
  qdef.addSelect(QryBO_UserActivity.Sel.TransactionCount);
  qdef.addSelect(QryBO_UserActivity.Sel.ExtPluginName);
	// Paging
	qdef.pagePos = pageBase.getQP();
	qdef.recordPerPage = 14;
	// Filter
	qdef.addFilter(QryBO_UserActivity.Fil.UserAccountId, pageBase.getId());
	// Sort
	qdef.addSort(QryBO_UserActivity.Sel.FiscalDate, false);
	qdef.addSort(QryBO_UserActivity.Sel.UserActivitySerial, false);
	// Exec
	JvDataSet ds = pageBase.execQuery(qdef);
	request.setAttribute("ds", ds);
%>


<v:grid id="useractivity-grid" dataset="<%=ds%>" qdef="<%=qdef%>">
  <thead>
    <tr>
      <td width="25%"><v:itl key="@Account.Login"/></td>
      <td width="25%"><v:itl key="@Account.Logout"/></td>
      <td width="25%"><v:itl key="@Lookup.EntityType.Workstation"/></td>
      <td width="25%"><v:itl key="@Plugin.Plugin"/></td>
    </tr>
  </thead>
  <tbody>
    <v:ds-loop dataset="<%=ds%>">
      <tr>
      	<td><%=pageBase.format(ds.getField(QryBO_UserActivity.Sel.LoginDateTime), pageBase.getShortDateTimeFormat())%></td>
        <td><%=pageBase.format(ds.getField(QryBO_UserActivity.Sel.LogoutDateTime), pageBase.getShortDateTimeFormat())%></td>
        <td><%=ds.getField(QryBO_UserActivity.Sel.WorkstationName).getHtmlString()%></td>
        <td><%=ds.getField(QryBO_UserActivity.Sel.ExtPluginName).getHtmlString()%></td>
      </tr>
    </v:ds-loop>
  </tbody>
</v:grid>
    