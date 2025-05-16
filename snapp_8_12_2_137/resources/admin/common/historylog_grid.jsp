<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_HistoryLog.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
QueryDef qdef = new QueryDef(QryBO_HistoryLog.class);
// Select
qdef.addSelect(
    Sel.IconName,
    Sel.CommonStatus,
    Sel.LogDateTime,
    Sel.UserAccountId,
    Sel.UserAccountNameMasked,
    Sel.UserAccountProfilePictureId,
    Sel.EntityType,
    Sel.EntityId,
    Sel.EntityProfilePictureId,
    Sel.HistoryLogType,
    Sel.LocationId,
    Sel.OpAreaId,
    Sel.WorkstationId,
    Sel.LocationName,
    Sel.OpAreaName,
    Sel.WorkstationName,
    Sel.Notes,
    Sel.HistoryDetailCount);

// Where
if (pageBase.getNullParameter("FromDateTime") != null)
  qdef.addFilter(Fil.FromDateTime, pageBase.convertFromBrowserToServerTimeZone(pageBase.getParameter("FromDateTime")));

if (pageBase.getNullParameter("ToDateTime") != null)
  qdef.addFilter(Fil.ToDateTime, pageBase.convertFromBrowserToServerTimeZone(pageBase.getParameter("ToDateTime")));

if (pageBase.getNullParameter("EntityType") != null)
  qdef.addFilter(Fil.EntityType, pageBase.getParameter("EntityType"));
  
if (pageBase.getNullParameter("UserAccountId") != null) 
  qdef.addFilter(Fil.UserAccountId, pageBase.getParameter("UserAccountId"));


if (pageBase.getNullParameter("LocationId") != null)
  qdef.addFilter(Fil.LocationId, pageBase.getNullParameter("LocationId"));

if (pageBase.getNullParameter("OpAreaId") != null)
  qdef.addFilter(Fil.OpAreaId, pageBase.getNullParameter("OpAreaId"));

if (pageBase.getNullParameter("WorkstationId") != null)
  qdef.addFilter(Fil.WorkstationId, pageBase.getNullParameter("WorkstationId"));

if (pageBase.getNullParameter("HistoryLogType") != null) 
  qdef.addFilter(Fil.HistoryLogType, JvArray.stringToArray(pageBase.getNullParameter("HistoryLogType"), ","));

// Paging
if (!pageBase.isParameter("paging", "false")) {
  qdef.pagePos = pageBase.getQP();
  qdef.recordPerPage = QueryDef.recordPerPageDefault;
}
// Sort
qdef.addSort(Sel.LogDateTime, false);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<style>

.log-data-cell img {
  opacity: 0;
}

tr:hover .log-data-cell img {
  opacity: 0.5;
}

</style>
    
<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" clazz="historylog-grid-table">
  <tr class="header">
    <td nowrap>
      <v:itl key="@Common.DateTime"/><br/>
      <v:itl key="@Common.LogType"/>
    </td>
    
    <td>&nbsp;</td>
    <td width="50%">
      <v:itl key="@Common.Entity"/>
    </td>
    
    <td width="30%">
      <v:itl key="@Common.User"/><br/>
      <v:itl key="@Common.Workstation"/>
    </td>
    <td width="20%" align="right">
      <v:itl key="@Common.Changes"/><br/>
    </td>
    
  </tr>
  <v:grid-row dataset="ds" dateGroupFieldName="<%=Sel.LogDateTime.name()%>">
    <%
      LookupItem entityType = LkSN.EntityType.findItemByCode(ds.getField(Sel.EntityType));
        LookupItem historyLogType = LkSN.HistoryLogType.findItemByCode(ds.getField(Sel.HistoryLogType));
        BLBO_PagePath.EntityRecap entityRecap = BLBO_PagePath.findEntityRecap(pageBase.getConnector(), entityType, ds.getField(Sel.EntityId).getString());
        int detailCount = ds.getField(Sel.HistoryDetailCount).getInt();
    %>
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>">
      <%
        if (detailCount != 0) {
      %>
        <a class="list-title" 
          href="javascript:showHistoryLogDialog('<%=ds.getField(Sel.EntityId).getHtmlString()%>','<%=ds.getField(Sel.LogDateTime).getDateTime()%>')">
      <%
        }
      %>
      <span class="list-title" title="<snp:datetime timestamp="<%=ds.getField(Sel.LogDateTime)%>" format="shortdatetime" timezone="local" clazz="list-title" textOnly="true"/>:<%=JvString.leadZero(ds.getField(Sel.LogDateTime).getDateTime().getSec(), 2)%> .<%=JvString.leadZero(ds.getField(Sel.LogDateTime).getDateTime().getMSec(), 3)%>">
        <snp:datetime timestamp="<%=ds.getField(Sel.LogDateTime)%>" format="shortdatetime" timezone="local" clazz="list-title"/>
      </span> <br/>
        <span class="list-subtitle"><%=historyLogType.getHtmlDescription(pageBase.getLang())%>&nbsp;</span>
      <br/> 
    </td>
    
    <td><v:grid-icon name="<%=(entityRecap == null) ? null : entityRecap.icon %>" repositoryId="<%=ds.getField(Sel.EntityProfilePictureId).getString()%>"/> </td>
    <td>
      <% if (entityRecap != null) { %>
        <a href="<%=entityRecap.url%>"><%=JvString.escapeHtml(JvMultiLang.translate(request, entityRecap.name))%></a> 
      <% } else if (!ds.getField(Sel.Notes).isNull()) { %>
        <%=ds.getField(Sel.Notes).getHtmlString()%>        
      <% } %>        
      <br/>
      <% if (entityType != null) { %>
        <span class="list-subtitle"><%=entityType.getHtmlDescription(pageBase.getLang())%>&nbsp;</span>
      <% } else { %>
        &mdash;
      <% } %>
    </td>
    
    <td nowrap>
      <% if (ds.getField(Sel.UserAccountId).isNull()) { %>
       &mdash;
      <% } else { %>
        <snp:entity-link entityId="<%=ds.getField(Sel.UserAccountId).getString()%>" entityType="<%=LkSNEntityType.Person%>">
          <%=ds.getField(Sel.UserAccountNameMasked).getHtmlString()%>
        </snp:entity-link>
      <% } %> 
      <% if (ds.getField(Sel.WorkstationId).isNull()) { %>
        &mdash;
      <% } else { %>
        <br/><snp:entity-link entityId="<%=ds.getField(Sel.LocationId).getString()%>" entityType="<%=LkSNEntityType.Location%>"><%=ds.getField(Sel.LocationName).getHtmlString()%></snp:entity-link>
        &raquo;
        <snp:entity-link entityId="<%=ds.getField(Sel.OpAreaId).getString()%>" entityType="<%=LkSNEntityType.OperatingArea%>"><%=ds.getField(Sel.OpAreaName).getHtmlString()%></snp:entity-link>
        &raquo;
        <snp:entity-link entityId="<%=ds.getField(Sel.WorkstationId).getString()%>" entityType="<%=LkSNEntityType.Workstation%>"><%=ds.getField(Sel.WorkstationName).getHtmlString()%></snp:entity-link>
      <% } %>
    </td>
    <td align="right">
      <%if (detailCount == 0) {%>
        &mdash;
      <%} else {%>
        <span class="list-subtitle"><%=detailCount%>&nbsp;</span> 
      <%}%>   
    </td>
  </v:grid-row>
</v:grid>


<script>

function showHistoryLogDialog(entityId, logDateTime) {
  asyncDialogEasy('common/historylog_dialog', 'id=' + entityId + '&LogDateTime=' + logDateTime);
}

</script>