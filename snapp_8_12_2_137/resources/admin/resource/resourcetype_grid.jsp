<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_ResourceType.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_ResourceType.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.CommonStatus);
qdef.addSelect(Sel.ResourceTypeId);
qdef.addSelect(Sel.ResourceTypeCode);
qdef.addSelect(Sel.ResourceTypeName);
qdef.addSelect(Sel.PriorityOrder);
qdef.addSelect(Sel.ResourceQuantity);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Filter
//qdef.addFilter(QryBO_Tag.Fil.EntityType, pageBase.getParameter("EntityType"));
// Sort
qdef.addSort(Sel.PriorityOrder);
qdef.addSort(Sel.ResourceTypeName);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.ResourceType%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
      <td width="20%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Code"/>
      </td>
      <td width="10%" align="right">
        <v:itl key="@Common.Quantity"/>
      </td>
      <td width="70%" align="right">
        <v:itl key="@Common.PriorityOrder"/>
      </td>
    </tr>
  </thead>
  <tbody>
    <v:grid-row dataset="ds">
      <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="ResourceTypeId" dataset="ds" fieldname="ResourceTypeId"/></td>
      <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
      <td>
        <a class="list-title" href="<v:config key="site_url"/>/admin?page=resourcetype&id=<%=ds.getField(Sel.ResourceTypeId).getHtmlString()%>"><%=ds.getField(Sel.ResourceTypeName).getHtmlString()%></a><br/>
        <span class="list-subtitle"><%=ds.getField(Sel.ResourceTypeCode).getHtmlString()%></span>&nbsp;
      </td>
      <td align="right"><%=ds.getField(Sel.ResourceQuantity).getHtmlString()%></td>
      <td align="right"><span class="list-subtitle"><%=ds.getField(Sel.PriorityOrder).getHtmlString()%></span></td>
    </v:grid-row>
  </tbody>
</v:grid>
    