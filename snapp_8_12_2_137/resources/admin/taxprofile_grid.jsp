<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_TaxProfile.class);
// Select
qdef.addSelect(QryBO_TaxProfile.Sel.IconName);
qdef.addSelect(QryBO_TaxProfile.Sel.TaxProfileId);
qdef.addSelect(QryBO_TaxProfile.Sel.TaxProfileCode);
qdef.addSelect(QryBO_TaxProfile.Sel.TaxProfileName);
qdef.addSelect(QryBO_TaxProfile.Sel.TaxNames);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Sort
qdef.addSort(QryBO_TaxProfile.Sel.TaxProfileName);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid id="taxprofile-grid-table" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.TaxProfile%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
      <td width="20%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Code"/>
      </td>
      <td width="80%">
        <v:itl key="@Product.Taxes"/>
      </td>
    </tr>
  </thead>
  <tbody>
    <v:grid-row dataset="ds">
      <td><v:grid-checkbox name="TaxProfileId" dataset="ds" fieldname="TaxProfileId"/></td>
      <td><v:grid-icon name="<%=ds.getField(QryBO_TaxProfile.Sel.IconName).getString()%>"/></td>
      <td>
        <% String hrefNew = "javascript:asyncDialogEasy('taxprofile_dialog', 'id=" + ds.getField(QryBO_TaxProfile.Sel.TaxProfileId).getEmptyString() + "')";%>
        <a href="<%=hrefNew%>" class="list-title"><%=ds.getField(QryBO_TaxProfile.Sel.TaxProfileName).getHtmlString()%></a><br/>
        <span class="list-subtitle"><%=ds.getField(QryBO_TaxProfile.Sel.TaxProfileCode).getHtmlString()%>&nbsp;</span>
      </td>
      <td>
        <%=ds.getField(QryBO_TaxProfile.Sel.TaxNames).getHtmlString()%>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>
    