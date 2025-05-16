<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Driver.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
QueryDef qdef = new QueryDef(QryBO_Driver.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.DriverId);
qdef.addSelect(Sel.DriverName);
qdef.addSelect(Sel.DriverType);
qdef.addSelect(Sel.LibraryName);
qdef.addSelect(Sel.ExtensionPackageName);
// Sort
qdef.addSort(Sel.DriverType);
qdef.addSort(Sel.DriverName);

// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Driver%>">
  <tr class="header">
    <td>&nbsp;</td>
    <td width="30%">
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.Type"/>
    </td>
    <td width="70%">
      <v:itl key="@Plugin.ExtensionPackageName"/><br/>
      <v:itl key="@Common.LibraryName"/>
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <% LookupItem driverType = LkSN.DriverType.getItemByCode(ds.getField(Sel.DriverType)); %>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.DriverId).getString()%>" entityType="<%=LkSNEntityType.Driver%>" clazz="list-title">
        <%=ds.getField(Sel.DriverName).getHtmlString()%>
      </snp:entity-link>
      <br/>
      <span class="list-subtitle"><%=driverType.getHtmlDescription(pageBase.getLang())%></span>
    </td>
    <td>
      <span class="title"><%=ds.getField(Sel.ExtensionPackageName).getHtmlString()%></span>
      <br/>
      <span class="list-subtitle"><%=ds.getField(Sel.LibraryName).getHtmlString()%></span>
    </td>
  </v:grid-row>
</v:grid>
