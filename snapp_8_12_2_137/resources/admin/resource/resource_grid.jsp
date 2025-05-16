<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Account.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_Account.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.AccountId);
qdef.addSelect(Sel.DisplayName);
qdef.addSelect(Sel.ProfilePictureId);
qdef.addSelect(Sel.ResourceQuantity);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Filter
qdef.addFilter(Fil.ResourceTypeId, pageBase.getParameter("ResourceTypeId"));
// Sort
qdef.addSort(Sel.DisplayName);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
      <td width="20%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Quantity"/>
      </td>
      <td width="80%">
        <v:itl key="@Resource.Skills"/>
      </td>
    </tr>
  </thead>
  <tbody>
    <v:grid-row dataset="ds">
      <td><v:grid-checkbox name="AccountId" dataset="ds" fieldname="AccountId"/></td>
      <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>" repositoryId="<%=ds.getField(Sel.ProfilePictureId).getString()%>"/></td>
      <td>
        <a class="list-title" href="<v:config key="site_url"/>/admin?page=account&id=<%=ds.getField(Sel.AccountId).getHtmlString()%>"><%=ds.getField(Sel.DisplayName).getHtmlString()%></a><br/>
        <span class="list-subtitle"><%=ds.getField(Sel.ResourceQuantity).getHtmlString()%></span>&nbsp;
      </td>
      <td></td>
    </v:grid-row>
  </tbody>
</v:grid>
    