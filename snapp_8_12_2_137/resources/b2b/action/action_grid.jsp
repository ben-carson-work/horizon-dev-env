<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Action.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
String linkEntityId = pageBase.getNullParameter("LinkEntityId");
LookupItem linkEntityType = LkSN.EntityType.findItemByCode(pageBase.getParameter("LinkEntityType"));

QueryDef qdef = new QueryDef(QryBO_Action.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.ActionId);
qdef.addSelect(Sel.ActionName);
qdef.addSelect(Sel.EntityType);
qdef.addSelect(Sel.CreateDateTime);
qdef.addSelect(Sel.CloseDateTime);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Sort
qdef.addSort(Sel.CreateDateTime, false);
// Where
qdef.addFilter(Fil.LinkEntityId, linkEntityId);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Email%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="60%">
      <v:itl key="@Action.Subject"/><br/>
      <v:itl key="@Common.Status"/>
    </td>
    <td width="40%" align="right">
      <v:itl key="@Action.CreateDateTime"/><br/>
      <v:itl key="@Action.CloseDateTime"/>
    </td>
  </tr>
  <v:grid-row dataset="ds" dateGroupFieldName="<%=Sel.CreateDateTime.name()%>">
    <% LookupItem entityType = LkSN.EntityType.getItemByCode(ds.getField(Sel.EntityType)); %>
    <% LookupItem actionStatus = LkSN.ActionStatus.getItemByCode(ds.getField(Sel.ActionStatus)); %>
    <td><v:grid-checkbox name="ActionId" dataset="ds" fieldname="ActionId"/></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
    <td>
      <% 
      String params = null;
      if ((linkEntityType != null) && linkEntityType.isLookup(LkSNEntityType.Sale))
        params = "SaleId=" + linkEntityId;
      %>
      <snp:entity-link entityId="<%=ds.getField(Sel.ActionId).getString()%>" entityType="<%=entityType%>" clazz="list-title" params="<%=params%>">
        <%=ds.getField(QryBO_Action.Sel.ActionName).getHtmlString()%>
      </snp:entity-link>
      <br/>
      <span class="list-subtitle"><%=actionStatus.getHtmlDescription(pageBase.getLang())%></span>
    </td>
    <td align="right">
      <snp:datetime timestamp="<%=ds.getField(Sel.CreateDateTime)%>" format="shortdatetime" timezone="local"/><br/>
      <snp:datetime timestamp="<%=ds.getField(Sel.CloseDateTime)%>" format="shortdatetime" timezone="local" clazz="list-subtitle"/>
    </td>
  </v:grid-row>
</v:grid>
