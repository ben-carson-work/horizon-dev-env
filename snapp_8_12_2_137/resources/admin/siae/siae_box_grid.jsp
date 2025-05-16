<%@page import="com.vgs.snapp.query.QryBO_SiaeBox.Sel"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>
<%
QueryDef qdef = new QueryDef(QryBO_SiaeBox.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.SiaeBoxId);
qdef.addSelect(Sel.SiaeBoxName);
qdef.addSelect(Sel.SiaeBoxUrl);
//Sort
qdef.addSort(Sel.SiaeBoxName);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.SiaeBox%>">
  <tr class="header">
    <td width="1%"><v:grid-checkbox header="true"/></td>
    <td width="1%">&nbsp;</td>
    <td width="49%">Denominazione</td>
    <td width="49%">URL</td>
  </tr>
  <v:grid-row dataset="ds">
    <td><v:grid-checkbox dataset="ds" name="SiaeBoxId" fieldname="SiaeBoxId" /></td>
    <td><v:grid-icon name="<%=ds.getString(Sel.IconName)%>"/></td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.SiaeBoxId).getString()%>" entityType="<%=LkSNEntityType.SiaeBox%>" clazz="list-title">
        <%=ds.getField(Sel.SiaeBoxName)%>
      </snp:entity-link>
    </td>
    <td>
      <%=ds.getField(Sel.SiaeBoxUrl).getHtmlString() %>
    </td>
  </v:grid-row>
</v:grid>
