<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_NotifyLog.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
QueryDef qdef = new QueryDef(QryBO_NotifyLog.class);
// Select
qdef.addSelect(
    Sel.NotifyLogId,
    Sel.NotifyRuleId,
    Sel.NotifyRuleName,
    Sel.NotifyDateTime,
    Sel.ServerDateTime,
    Sel.WorkstationId,
    Sel.UserAccountId,
    Sel.EmailSent,
    Sel.SmsSent,
    Sel.UserAccountName,
    Sel.WorkstationName,
    Sel.OpAreaId,
    Sel.OpAreaName,
    Sel.LocationId,
    Sel.LocationName,
    Sel.UserAccountEntityType);

if (pageBase.getNullParameter("FromDateTime") != null)
  qdef.addFilter(Fil.StartNotifyDateTime, pageBase.convertFromBrowserToServerTimeZone(pageBase.getParameter("FromDateTime")));

if (pageBase.getNullParameter("ToDateTime") != null)
  qdef.addFilter(Fil.EndNotifyDateTime, pageBase.convertFromBrowserToServerTimeZone(pageBase.getParameter("ToDateTime")));

String[] locationIDs = pageBase.getBL(BLBO_EntitySearch.class).getAuditLocationFilter(pageBase.getNullParameter("LocationId"));
if (locationIDs != null) 
  qdef.addFilter(Fil.LocationId, locationIDs);

if (pageBase.getNullParameter("OpAreaId") != null)
  qdef.addFilter(Fil.OpAreaId, pageBase.getParameter("OpAreaId"));

if (pageBase.getNullParameter("WorkstationId") != null)
  qdef.addFilter(Fil.WorkstationId, pageBase.getParameter("WorkstationId"));


// Paging
if (!pageBase.isParameter("paging", "false")) {
  qdef.pagePos = pageBase.getQP();
  qdef.recordPerPage = QueryDef.recordPerPageDefault;
}
// Sort
qdef.addSort(Sel.NotifyDateTime, false);
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
    <td width="25%" nowrap>
      <v:itl key="@Notify.NotifyDateTime"/><br/>
      <v:itl key="@Common.ServerDateTime"/>
    </td>
    <td width="25%">
      <v:itl key="@Notify.NotifyRule"/><br>
      <v:itl key="@Common.Notifications"/>
    </td>
    <td width="25%">
      <v:itl key="@Account.Location"/> &raquo; <v:itl key="@Account.OpArea"/> &raquo; <v:itl key="@Common.Workstation"/><br/>
      <v:itl key="@Common.User"/>
    </td>
    <td width="25%">
      <v:itl key="@Notify.References"/>
    </td>
  </tr>
  
  <v:grid-row dataset="ds" dateGroupFieldName="<%=Sel.NotifyDateTime.toString()%>">
    <td nowrap>
     <span class="list-title">
      <snp:datetime timestamp="<%=ds.getField(Sel.NotifyDateTime)%>" format="shortdatelongtime" timezone="local" clazz="list-title"/>
     </span><br>
     <span class="list-title">
         <snp:datetime timestamp="<%=ds.getField(Sel.ServerDateTime)%>" format="shortdatelongtime" timezone="local" clazz="list-subtitle"/>
     </span>
    </td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.NotifyRuleId).getHtmlString()%>" entityType="<%=LkSNEntityType.NotifyRule%>"><%=ds.getField(Sel.NotifyRuleName).getHtmlString()%></snp:entity-link><br>
      <%
        String[] notifications = new String[0];
        if (ds.getField(Sel.EmailSent).getBoolean())
          notifications = JvArray.add("<i class='fa fa-envelope'/></i>", notifications);
        if (ds.getField(Sel.SmsSent).getBoolean())
          notifications = JvArray.add("<i class='fa fa-comment'/></i>", notifications);
      %>
      <span class="list-subtitle"><%=(notifications.length == 0) ? "&mdash;" : JvArray.arrayToString(notifications, ", ") %></span>
    </td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.LocationId)%>" entityType="<%=LkSNEntityType.Location%>"><%=ds.getField(Sel.LocationName).getHtmlString()%></snp:entity-link> &raquo;
      <snp:entity-link entityId="<%=ds.getField(Sel.OpAreaId)%>" entityType="<%=LkSNEntityType.OperatingArea%>"><%=ds.getField(Sel.OpAreaName).getHtmlString()%></snp:entity-link> &raquo;
      <snp:entity-link entityId="<%=ds.getField(Sel.WorkstationId)%>" entityType="<%=LkSNEntityType.Workstation%>"><%=ds.getField(Sel.WorkstationName).getHtmlString()%></snp:entity-link>
      <br/>
      <% if (ds.getField(Sel.UserAccountId).isNull()) { %>
        &nbsp;
      <% } else { %>
        <% LookupItem userAccountEntityType = LkSN.EntityType.getItemByCode(ds.getField(Sel.UserAccountEntityType)); %>
        <snp:entity-link entityId="<%=ds.getField(Sel.UserAccountId).getString()%>" entityType="<%=userAccountEntityType%>"><%=ds.getField(Sel.UserAccountName).getHtmlString()%></snp:entity-link>
      <% }%>
    </td>
    <td>
    
    <% JvDataSet dsRef = pageBase.getDB().executeQuery("Select * from tbNotifyLogRef where NotifyLogId=" + ds.getField(Sel.NotifyLogId).getSqlString()); %>
    <v:ds-loop dataset="<%=dsRef%>">
      <% BLBO_PagePath.EntityRecap recap = BLBO_PagePath.findEntityRecap(pageBase.getConnector(), LkSN.EntityType.getItemByCode(dsRef.getField("EntityType")), dsRef.getField("EntityId").getString()); %>
      <% if (recap != null) { %>
        <snp:entity-link entityId="<%=recap.id%>" entityType="<%=recap.type%>"><%=JvString.escapeHtml(recap.name)%></snp:entity-link><br/>
      <% } %>
    </v:ds-loop>
    </td>
  </v:grid-row>
</v:grid>