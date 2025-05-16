<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Font.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_Font.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.FontId);
qdef.addSelect(Sel.FontName);
qdef.addSelect(Sel.FileName);
qdef.addSelect(Sel.FileSize);
qdef.addSelect(Sel.FontEncoding);
// Where
//if ((pageBase.getNullParameter("RoleType") != null))
//  qdef.addFilter(Fil.RoleType, JvArray.stringToArray(pageBase.getNullParameter("RoleType"), ","));
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Sort
qdef.addSort(Sel.PriorityOrder);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Font%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="60%">
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.FileName"/>
    </td>
    <td width="40%" align="right">
      <v:itl key="@Common.Size"/><br/>
      <v:itl key="@Common.Type"/>
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <% LookupItem encoding = LkSN.FontEncoding.getItemByCode(ds.getField(Sel.FontEncoding)); %>
    <td><v:grid-checkbox name="FontId" dataset="ds" fieldname="FontId"/></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
    <td>
      <%-- <snp:entity-link entityId="<%=ds.getField(Sel.FontId).getString()%>" entityType="<%=LkSNEntityType.Font%>" clazz="list-title"> --%>
        <strong><%=ds.getField(Sel.FontName).getHtmlString()%></strong>
      <%-- </snp:entity-link> --%>
      <br/>
      <span class="list-subtitle"><%=ds.getField(Sel.FileName).getHtmlString()%></span> 
    </td>
    <td align="right">
      <%=JvString.escapeHtml(JvString.getSmoothSize(ds.getField(Sel.FileSize).getLong()))%>
      <br/>
      <span class="list-subtitle"><%=encoding.getHtmlDescription(pageBase.getLang())%></span> 
    </td>
  </v:grid-row>
</v:grid>
