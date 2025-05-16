<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Relation.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_Relation.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.RelationId);
qdef.addSelect(Sel.RelationName);
qdef.addSelect(Sel.ReverseRelationName);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Filter
// Sort
qdef.addSort(Sel.RelationName);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Relation%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
      <td width="100%">
        <v:itl key="@Common.Name"/>
      </td>
    </tr>
  </thead>
  <tbody>
    <v:grid-row dataset="ds">
      <td><v:grid-checkbox name="RelationId" dataset="ds" fieldname="RelationId"/></td>
      <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
      <td>
        <snp:entity-link entityId="<%=ds.getField(Sel.RelationId).getString()%>" entityType="<%=LkSNEntityType.Relation%>" clazz="list-title"><%=ds.getField(Sel.RelationName).getHtmlString()%></snp:entity-link>
        <br/>
        <span class="list-subtitle"><%=ds.getField(Sel.ReverseRelationName).getHtmlString()%></span>&nbsp;
      </td>
    </v:grid-row>
  </tbody>
</v:grid>
    