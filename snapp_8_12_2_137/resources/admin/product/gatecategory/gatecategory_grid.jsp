<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_GateCategory.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
QueryDef qdef = new QueryDef(QryBO_GateCategory.class);
// Select
qdef.addSelect(Sel.GateCategoryId);
qdef.addSelect(Sel.GateCategoryCode);
qdef.addSelect(Sel.GateCategoryName);
qdef.addSelect(Sel.IconName);
// Filter
if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(Fil.FullText, pageBase.getParameter("FullText"));
if (pageBase.getNullParameter("GateCategoryId") != null)
  qdef.addFilter(Fil.GateCategoryId, pageBase.getNullParameter("GateCategoryId"));

// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid id="gatecategory-grid-table" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.GateCategory%>">
  <tr class="header">
    <td>
      <v:grid-checkbox header="true"/>
    </td>
    <td>&nbsp;</td>
    <td width="100%">
      <v:itl key="@Common.Name"/><br />
      <v:itl key="@Common.Code"/>         
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <td>
      <v:grid-checkbox dataset="ds" fieldname="GateCategoryId" name="GateCategoryId"/>
    </td>
    <td>
      <v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/>
    </td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(QryBO_GateCategory.Sel.GateCategoryId)%>" entityType="<%=LkSNEntityType.GateCategory%>" clazz="list-title">
        <%=ds.getField(QryBO_GateCategory.Sel.GateCategoryName).getHtmlString()%>
      </snp:entity-link><br />
      <span class="list-subtitle"><%=ds.getField(QryBO_GateCategory.Sel.GateCategoryCode).getHtmlString()%></span>
    </td>
  </v:grid-row>
</v:grid>