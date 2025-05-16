<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Task.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%

QueryDef qdef = new QueryDef(QryBO_Task.class);
// Select
qdef.addSelect(
    Sel.TaskId,
    Sel.CommonStatus,
    Sel.DataExport_IconAlias,
    Sel.DataExport_Option,
    Sel.DataExport_RecipientRecap,
    Sel.ScheduleDesc,
    Sel.LastFire,
    Sel.UncheckedCount,
    Sel.DataExport_DataSourceId,
    Sel.DataExport_DataSourceName);

qdef.addSelect(Sel.TaskName);
// Where
qdef.addFilter(Fil.DataExport_DocTemplateId, pageBase.getNullParameter("DocTemplateId"));
// Sort
qdef.addSort(Sel.TaskName);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Task%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
      <td width="20%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Recap"/>
      </td>
      <td width="40%">
        <v:itl key="@Task.Scheduling"/><br/>
        <v:itl key="@Task.NextFire"/>
      </td>
      <td width="40%">
        <v:itl key="@Common.DataSource"/>
      </td>
    </tr>
  </thead>
  <tbody>
  <v:grid-row dataset="ds">
    <% LookupItem dataExportOption = LkSN.DataExportOption.getItemByCode(ds.getField(Sel.DataExport_Option)); %>
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="TaskId" dataset="ds" fieldname="TaskId"/></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.DataExport_IconAlias).getHtmlString()%>"/></td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.TaskId)%>" entityType="<%=LkSNEntityType.TaskDataExport%>" clazz="list-title">
        <%=ds.getField(Sel.TaskName).getHtmlString()%>
      </snp:entity-link>
      <br/>
      <span class="list-subtitle"><%=ds.getField(Sel.DataExport_RecipientRecap).getHtmlString()%></span>
    </td>
    <td>
      <%=ds.getField(Sel.ScheduleDesc).getHtmlString()%><br/>
      <span class="list-subtitle">
        <% if (ds.getField(Sel.LastFire).isNull()) { %>
          <v:itl key="@Task.NeverExecuted"/>
        <% } else { %>
          <snp:datetime timestamp="<%=ds.getField(Sel.LastFire)%>" format="shortdatetime" timezone="local"/>
        <% } %>
      </span>
    </td>
    <td>
      <% if (ds.getField(Sel.DataExport_DataSourceId).isNull()) { %>
        <span class="list-subtitle"><v:itl key="@Common.Default"/></span>
      <% } else { %>
	      <snp:entity-link entityId="<%=ds.getField(Sel.DataExport_DataSourceId)%>" entityType="<%=LkSNEntityType.DataSource%>">
	        <%=ds.getField(Sel.DataExport_DataSourceName).getHtmlString()%>
	      </snp:entity-link>
      <% } %>
    </td>
  </v:grid-row>
  </tbody>
</v:grid>
