<%@page import="com.vgs.snapp.query.QryBO_SiaeTax.Sel"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>
<%
QueryDef qdef = new QueryDef(QryBO_SiaeTax.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.SiaeTaxId);
qdef.addSelect(Sel.TaxName);
qdef.addSelect(Sel.CurrentTaxValue);
//Sort
qdef.addSort(Sel.TaxName);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.SiaeTax%>">
  <tr class="header">
    <td width="1%"><v:grid-checkbox header="true"/></td>
    <td width="1%">&nbsp;</td>
    <td>Nome</td>
    <td>Valore corrente</td>
  </tr>
  <v:grid-row dataset="ds">
    <td><v:grid-checkbox dataset="ds" name="SiaeTaxId" fieldname="SiaeTaxId" /></td>
    <td><v:grid-icon name="<%=ds.getString(Sel.IconName)%>"/></td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.SiaeTaxId).getString()%>" entityType="<%=LkSNEntityType.SiaeTax%>" clazz="list-title">
        <%=ds.getField(Sel.TaxName)%>
      </snp:entity-link><br />
    </td>
    <td>
      <% if (!ds.getField(Sel.CurrentTaxValue).isNull()) { %>
        <%=ds.getField(Sel.CurrentTaxValue).getHtmlString() %> % 
      <% } %>
    </td>
  </v:grid-row>
</v:grid>
