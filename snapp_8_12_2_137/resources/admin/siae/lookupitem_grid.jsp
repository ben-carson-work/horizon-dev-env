<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeLookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_SiaeLookup.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.LookupItemCode);
qdef.addSelect(Sel.LookupItemName);
qdef.addSelect(Sel.Note);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Filter
qdef.addFilter(Fil.LookupTableId, pageBase.getNullParameter("LookupTableId"));
// Sort
qdef.addSort(Sel.LookupItemCode);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>">
  <tr class="header">
    <td width="5%">Codice</td>
    <td width="40%">Descrizione</td>
    <td width="55%">Nota</td>
  </tr>
  <v:grid-row dataset="ds">
    <td>
      <%=ds.getField(Sel.LookupItemCode).getHtmlString() %>
    </td>
    <td>
      <span><%=ds.getField(Sel.LookupItemName).getHtmlString()%></span>
    </td>
    <td>
      <span><%=ds.getField(Sel.Note).getHtmlString()%></span>
    </td>
    
  </v:grid-row>
</v:grid>
