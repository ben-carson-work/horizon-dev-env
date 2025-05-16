<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Grid.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_Grid.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.GridId);
qdef.addSelect(Sel.GridCode);
qdef.addSelect(Sel.GridName);
qdef.addSelect(Sel.EntityType);
// Sort
qdef.addSort(Sel.EntityType);
qdef.addSort(Sel.GridName);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Grid%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
      <td width="100%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Code"/>
      </td>
    </tr>
  </thead>
  <tbody>
  <% int lastEntityCode = -1; %>
  <% LookupItem entityType = null; %>
  <v:ds-loop dataset="<%=ds%>">
    <%
      if (ds.getField(Sel.EntityType).getInt() != lastEntityCode) {
        lastEntityCode = ds.getField(Sel.EntityType).getInt();
        entityType = LkSN.EntityType.getItemByCode(lastEntityCode);
        %><tr class="group"><td colspan="100%"><%=entityType.getHtmlDescription()%></td></tr><%
      } 
    %>
    <tr class="grid-row">
      <td><v:grid-checkbox name="cbGridId" dataset="ds" fieldname="GridId"/></td>
      <td><v:grid-icon name="<%=ds.getField(QryBO_Grid.Sel.IconName).getString()%>"/></td>
      <td>
        <snp:entity-link entityId="<%=ds.getField(Sel.GridId).getString()%>" entityType="<%=LkSNEntityType.Grid.getCode()%>" clazz="list-title">
          <%=ds.getField(Sel.GridName).getHtmlString()%>
        </snp:entity-link><br />
        <span class="list-subtitle"><%=ds.getField(Sel.GridCode).getHtmlString()%></span>
      </td>
    </tr>
  </v:ds-loop>
  </tbody>
</v:grid>
