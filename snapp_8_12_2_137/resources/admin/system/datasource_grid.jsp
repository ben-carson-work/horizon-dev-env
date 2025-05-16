<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_DataSource.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_DataSource.class);
// Select
qdef.addSelect(
    Sel.IconName,
    Sel.DataSourceId,
    Sel.DataSourceCode,
    Sel.DataSourceName,
    Sel.DataSourceType,
    Sel.DBHostName,
    Sel.DBDatabaseName,
    Sel.DBReadOnlyIntent);
// Where
//if ((pageBase.getNullParameter("RoleType") != null))
//  qdef.addFilter(Fil.RoleType, JvArray.stringToArray(pageBase.getNullParameter("RoleType"), ","));

if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(Fil.FullText, pageBase.getNullParameter("FullText"));

if ((pageBase.getNullParameter("DataSourceType") != null))
  qdef.addFilter(Fil.DataSourceType, JvArray.stringToArray(pageBase.getNullParameter("DataSourceType"), ","));

// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Sort
qdef.addSort(Sel.DataSourceType);
qdef.addSort(Sel.DataSourceName);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid id="datasource-grid" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.DataSource%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="20%">
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.Code"/>
    </td>
    <td width="20%">
      <v:itl key="@Common.Type"/>
    </td>
    <td width="60%">
      <v:itl key="@Common.HostName"/><br/>
      <v:itl key="@Common.DatabaseName"/>
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <% LookupItem type = LkSN.DataSourceType.getItemByCode(ds.getField(Sel.DataSourceType)); %>
    <td><v:grid-checkbox name="DataSourceId" dataset="ds" fieldname="DataSourceId"/></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.DataSourceId).getString()%>" entityType="<%=LkSNEntityType.DataSource%>" clazz="list-title">
        <%=ds.getField(Sel.DataSourceName).getHtmlString()%>
      </snp:entity-link>
      <br/>
      <span class="list-subtitle"><%=ds.getField(Sel.DataSourceCode).getHtmlString()%></span> 
    </td>
    <td>
      <div><%=type.getHtmlDescription(pageBase.getLang())%></div>
      <div class="list-subtitle"><%=ds.getField(Sel.DBReadOnlyIntent).getBoolean() ? "Read Only Intent" : "&nbsp;" %></div>
    </td>
    <td>
      <%=ds.getField(Sel.DBHostName).getHtmlString()%>
      <br/>
      <span class="list-subtitle"><%=ds.getField(Sel.DBDatabaseName).getHtmlString()%></span> 
    </td>
  </v:grid-row>
</v:grid>