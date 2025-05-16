<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Log.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
boolean showEntityColumn = true;

QueryDef qdef = new QueryDef(QryBO_Log.class)
    .addSort(Sel.LogDateTime, false)
    .addSelect(
        Sel.IconName,
        Sel.BackgroundColor,
        Sel.LogId,
        Sel.LogDateTime,
        Sel.LogType,
        Sel.LogLevel,
        Sel.LogTextRecap,
        Sel.WorkstationId,
        Sel.WorkstationName,
        Sel.OpAreaId,
        Sel.OpAreaName,
        Sel.LocationId,
        Sel.LocationName,
        Sel.UserAccountId,
        Sel.UserAccountName,
        Sel.DurationMS,
        Sel.EntityType,
        Sel.EntityId,
        Sel.HasData,
        Sel.ServerId,
        Sel.ServerName);

if (pageBase.getNullParameter("FromDateTime") != null)
  qdef.addFilter(Fil.FromDateTime, pageBase.convertFromBrowserToServerTimeZone(pageBase.getParameter("FromDateTime")));

if (pageBase.getNullParameter("ToDateTime") != null)
  qdef.addFilter(Fil.ToDateTime, pageBase.convertFromBrowserToServerTimeZone(pageBase.getParameter("ToDateTime")));

if (pageBase.getNullParameter("LogLevel") != null)
  qdef.addFilter(Fil.LogLevel, JvArray.stringToIntArray(pageBase.getParameter("LogLevel"), ","));

if (pageBase.getNullParameter("EntityType") != null)
  qdef.addFilter(Fil.EntityType, pageBase.getParameter("EntityType"));

if (pageBase.getNullParameter("EntityId") != null) {
  qdef.addFilter(Fil.EntityId, pageBase.getParameter("EntityId"));
  showEntityColumn = false;
}

if (pageBase.getNullParameter("AltEntityId") != null) {
  qdef.addFilter(Fil.AltEntityId, pageBase.getParameter("AltEntityId"));
}

String[] locationIDs = pageBase.getBL(BLBO_EntitySearch.class).getAuditLocationFilter(pageBase.getNullParameter("LocationId"));
if (locationIDs != null) 
  qdef.addFilter(Fil.LocationId, locationIDs);

if (pageBase.getNullParameter("OpAreaId") != null)
  qdef.addFilter(Fil.OpAreaId, pageBase.getNullParameter("OpAreaId"));

if (pageBase.getNullParameter("WorkstationId") != null)
  qdef.addFilter(Fil.WorkstationId, pageBase.getNullParameter("WorkstationId"));

// Paging
if (!pageBase.isParameter("paging", "false")) {
  qdef.pagePos = pageBase.getQP();
  qdef.recordPerPage = QueryDef.recordPerPageDefault;
}

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

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" clazz="log-grid-table">
  <tr class="header">
    <td width="120px" nowrap>
      <v:itl key="@Common.DateTime"/><br/>
      <v:itl key="@Common.LogLevel"/> / <v:itl key="@Common.Type"/>
    </td>
    <% if (showEntityColumn) { %>
      <td width="15%">
        <v:itl key="@Common.Entity"/>
      </td>
    <% } %>
    <td width="<%=showEntityColumn?20:25%>%">
      <v:itl key="@Common.Workstation"/><br/>
      <v:itl key="@Common.User"/>
    </td>
    <td>
      <v:itl key="@Common.Server"/>
    </td>
    <td width="<%=showEntityColumn?65:75%>%">
      <v:itl key="@Common.Text"/>
    </td>
    <td></td>
  </tr>
  <v:grid-row dataset="ds" dateGroupFieldName="<%=Sel.LogDateTime.name()%>">
    <input type="hidden" name="LogId" value="<%=ds.getField(Sel.LogId).getHtmlString()%>" data-HasData="<%=ds.getField(Sel.HasData).getBoolean()%>"/>
    <%
    LookupItem logType = LkSN.LogType.getItemByCode(ds.getField(Sel.LogType));
    LookupItem logLevel = LkSN.LogLevel.getItemByCode(ds.getField(Sel.LogLevel));
    LookupItem entityType = LkSN.EntityType.findItemByCode(ds.getField(Sel.EntityType));
    %>
    <td style="border-left:4px <%=ds.getField(Sel.BackgroundColor).getHtmlString()%> solid" nowrap>
      <% if (ds.getField(Sel.HasData).getBoolean()) { %>
        <a class="list-title" href="javascript:showLogDialog('<%=ds.getField(Sel.LogId).getHtmlString()%>')">
      <% } %>
      <span class="list-title">
        <snp:datetime timestamp="<%=ds.getField(Sel.LogDateTime)%>" format="shortdatetime" timezone="local" clazz="list-title" showMillisHint="true" />
      </span>
      <% if (ds.getField(Sel.HasData).getBoolean()) { %>
        </a>
      <% } %>
      <br/>
      <span class="list-subtitle">
        <%=logLevel.getHtmlDescription(pageBase.getLang())%> /
        <%=logType.getHtmlDescription(pageBase.getLang())%>
      </span>
    </td>
    <% if (showEntityColumn) { %>
      <td>
        <% BLBO_PagePath.EntityRecap entityRecap = BLBO_PagePath.findEntityRecap(pageBase.getConnector(), entityType, ds.getField(Sel.EntityId).getString()); %>
        <% if (entityType == null) { %>
         &mdash;
        <% } else { %>
          <%=entityType.getHtmlDescription(pageBase.getLang())%>
          <% if (entityRecap != null) { %>
            <br/><a href="<%=entityRecap.url%>"><%=JvString.escapeHtml(JvMultiLang.translate(request, entityRecap.name))%></a>
          <% } %>
        <% } %>
      </td>
    <% } %>
    <td nowrap>
      <% if (ds.getField(Sel.WorkstationId).isNull()) { %>
        &mdash;
      <% } else { %>
        <snp:entity-link entityId="<%=ds.getField(Sel.LocationId).getString()%>" entityType="<%=LkSNEntityType.Location%>"><%=ds.getField(Sel.LocationName).getHtmlString()%></snp:entity-link>
        &raquo;
        <snp:entity-link entityId="<%=ds.getField(Sel.OpAreaId).getString()%>" entityType="<%=LkSNEntityType.OperatingArea%>"><%=ds.getField(Sel.OpAreaName).getHtmlString()%></snp:entity-link>
        &raquo;
        <snp:entity-link entityId="<%=ds.getField(Sel.WorkstationId).getString()%>" entityType="<%=LkSNEntityType.Workstation%>"><%=ds.getField(Sel.WorkstationName).getHtmlString()%></snp:entity-link>
      <% } %>
      <br/>
      <% if (ds.getField(Sel.UserAccountId).isNull()) { %>
        &mdash;
      <% } else { %>
        <snp:entity-link entityId="<%=ds.getField(Sel.UserAccountId).getString()%>" entityType="<%=LkSNEntityType.Person%>">
          <%=ds.getField(Sel.UserAccountName).getHtmlString()%>
        </snp:entity-link>
      <% } %>
    </td>
    <td>
      <% if (!ds.getField(Sel.ServerId).isNull()) { %>
        <snp:entity-link entityId="<%=ds.getField(Sel.ServerId).getString()%>" entityType="<%=LkSNEntityType.Server%>">
          <v:label field="<%=ds.getField(Sel.ServerName)%>"/>
        </snp:entity-link>
      <% } %>
    </td>
    <td style="word-wrap:break-word">
      <span class="list-subtitle"><%=ds.getField(Sel.LogTextRecap).getHtmlString()%></span>
    </td>
    <td align="right">
      <% if (ds.getField(Sel.DurationMS).getInt() > 0) { %>
        <%=JvDateUtils.getSmoothTime(ds.getField(Sel.DurationMS).getInt())%>
      <% } %>
    </td>
  </v:grid-row>
</v:grid>


<script>

function showLogDialog(logId) {
  asyncDialog({url:"<v:config key="site_url"/>/admin?page=log_data_dialog&id=" + logId});
}
/*
$(".log-grid-table tr").click(function() {
  var log = $(this).find("[name='LogId']");
  var hasData = (log.attr("data-HasData") == "true");
  if (hasData) {
    asyncDialog({url:"<v:config key="site_url"/>/admin?page=log_data_dialog&id=" + log.val()});
  }
});
*/

</script>