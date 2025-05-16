<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Upload.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
QueryDef qdef = new QueryDef(QryBO_Upload.class);
// Select
qdef.addSelect(
    Sel.IconName,
    Sel.CommonStatus,
    Sel.UploadId,
    Sel.QueuePriority,
    Sel.WorkstationId,
    Sel.WorkstationName,
    Sel.OpAreaId,
    Sel.OpAreaName,
    Sel.LocationId,
    Sel.LocationName,
    Sel.RequestDateTime,
    Sel.ProcessMS,
    Sel.QueueMS,
    Sel.UploadStatusDesc,
    Sel.LastLogMessage,
    Sel.MsgRequestSize,
    Sel.ServerId,
    Sel.ServerName);

// Where

if (pageBase.getNullParameter("FromDateTime") != null)
  qdef.addFilter(Fil.FromDateTime, pageBase.convertFromBrowserToServerTimeZone(pageBase.getNullParameter("FromDateTime")));

if (pageBase.getNullParameter("ToDateTime") != null)
  qdef.addFilter(Fil.ToDateTime, pageBase.convertFromBrowserToServerTimeZone(pageBase.getNullParameter("ToDateTime")));

if (pageBase.getNullParameter("UploadStatus") != null)
  qdef.addFilter(Fil.UploadStatus, JvArray.stringToArray(pageBase.getNullParameter("UploadStatus"), ","));

if (pageBase.getNullParameter("UploadType") != null)
  qdef.addFilter(Fil.UploadType, JvArray.stringToArray(pageBase.getNullParameter("UploadType"), ","));

if (pageBase.getNullParameter("WorkstationId") != null)
  qdef.addFilter(Fil.WorkstationId, pageBase.getNullParameter("WorkstationId"));

// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Sort
qdef.addSort(Sel.RequestDateTime, false);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="15%">
      <v:itl key="@Common.DateTime"/><br/>
      <v:itl key="@Common.Status"/>
    </td>
    <td width="30%">
      <v:itl key="@Common.Workstation"/><br/>
      <v:itl key="@Common.QueuePriority"/>
    </td>
    <td width="35%" valign="top">
      Last Log Message
    </td>
    <td width="20%" align="right">
      Server &mdash; Processing Time<br/>
      Size &mdash; Queue Time
    </td>
  </tr>
  <v:grid-row dataset="ds" dateGroupFieldName="<%=Sel.RequestDateTime.name()%>">
    <% LookupItem queuePriority = LkSN.QueuePriority.getItemByCode(ds.getField(Sel.QueuePriority)); %>
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="UploadId" dataset="ds" fieldname="UploadId"/></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
    <td>
      <a href="admin?page=upload&id=<%=ds.getField(Sel.UploadId).getEmptyString()%>" class="list-title"><snp:datetime timestamp="<%=ds.getField(Sel.RequestDateTime)%>" format="shortdatetime" timezone="local"/></a><br/>
      <span class="list-subtitle"><%=ds.getField(Sel.UploadStatusDesc).getHtmlString()%></span>
    </td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.LocationId)%>" entityType="<%=LkSNEntityType.Location%>">
        <%=ds.getField(Sel.LocationName).getHtmlString()%>
      </snp:entity-link>
      &raquo;
      <snp:entity-link entityId="<%=ds.getField(Sel.OpAreaId)%>" entityType="<%=LkSNEntityType.OperatingArea%>">
        <%=ds.getField(Sel.OpAreaName).getHtmlString()%>
      </snp:entity-link>
      &raquo;
      <snp:entity-link entityId="<%=ds.getField(Sel.WorkstationId)%>" entityType="<%=LkSNEntityType.Workstation%>">
        <%=ds.getField(Sel.WorkstationName).getHtmlString()%>
      </snp:entity-link>

      <br/>

      <span class="list-subtitle"><%=queuePriority.getHtmlDescription(pageBase.getLang())%></span>
    </td>
    <td valign="top">
      <%
        if (ds.getField(Sel.UploadStatus).getInt() == LkSNUploadStatus.Failed.getCode()) {
      %>
        <%=ds.getField(Sel.LastLogMessage).getHtmlString()%>
      <% } %>
    </td>
    <td align="right">
      <% if (!ds.getField(Sel.ServerId).isNull()) { %>
        <snp:entity-link entityId="<%=ds.getField(Sel.ServerId)%>" entityType="<%=LkSNEntityType.Server%>">
          <%=ds.getField(Sel.ServerName).getHtmlString()%>
        </snp:entity-link>
        &mdash;
      <% } %>
      <%=JvDateUtils.getSmoothTime(ds.getField(Sel.ProcessMS).getInt())%>
      <br/>
      <span class="list-subtitle"><%=JvString.getSmoothSize(ds.getField(Sel.MsgRequestSize).getLong())%> &mdash; <%=JvDateUtils.getSmoothTime(ds.getField(Sel.QueueMS).getInt())%></span>
    </td>
  </v:grid-row>
</v:grid>
