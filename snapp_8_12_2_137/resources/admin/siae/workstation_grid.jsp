<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeWorkstation.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>
<%
QueryDef qdef = new QueryDef(QryBO_SiaeWorkstation.class)
    .setPaging(pageBase.getQP(), QueryDef.recordPerPageDefault)
    .addSelect(
        Sel.WorkstationId,
        Sel.WorkstationCode,
        Sel.WorkstationName,
        Sel.CodiceRichiedente);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.SiaeWorkstation%>">
  <tr class="header">
    <td>&nbsp;</td>
    <td width="15%">
      <v:itl key="Postazione"/><br/>
    </td>
    <td width="85%">
      <v:itl key="Codice richiedente emissione sigillo"/><br/>
    </td>
  </tr>    
  <v:grid-row dataset="ds">
    <td><v:grid-icon name="station.png"/></td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.WorkstationId).getString()%>" entityType="<%=LkSNEntityType.Workstation%>" clazz="list-title"><%=ds.getField(Sel.WorkstationName).getHtmlString()%></snp:entity-link><br/>
      <span class="list-subtitle"><%=ds.getField(Sel.WorkstationCode).getHtmlString()%></span>
    </td>
    <td>
      <%=ds.getField(Sel.CodiceRichiedente).getHtmlString()%><br/>
    </td>
  </v:grid-row>
</v:grid>

<script>
