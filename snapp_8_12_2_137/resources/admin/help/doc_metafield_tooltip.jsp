<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_MetaField.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTooltip" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_MetaField.class);
qdef.addSelect(Sel.MetaFieldCode, Sel.MetaFieldName);
qdef.addSort(Sel.MetaFieldName);
JvDataSet ds = pageBase.execQuery(qdef);
%>

<table style="width:100%">
  <v:ds-loop dataset="<%=ds%>">
    <tr>
      <td><%=ds.getField(Sel.MetaFieldCode).getHtmlString()%></td>
      <td>&nbsp;</td>
      <td><%=ds.getField(Sel.MetaFieldName).getHtmlString()%></td>
    </tr>
  </v:ds-loop>
</table>

