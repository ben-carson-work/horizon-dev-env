<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_OutboundOffline.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_OutboundOffline.class);
// Select
qdef.addSelect(
    Sel.OutboundOfflineId,
    Sel.OutboundOfflineStatus,
    Sel.CreateDateTime,
    Sel.EntityId,
    Sel.EntityType,
    Sel.IconName,
    Sel.CommonStatus,
    Sel.CorrelationId,
    Sel.SuppressEvent);


if (pageBase.getNullParameter("OutboundOfflineId") != null)
  qdef.addFilter(Fil.OutboundOfflineId, pageBase.getParameter("OutboundQueueId"));

 if (pageBase.getNullParameter("FromDateTime") != null)
  qdef.addFilter(Fil.CreateDateTimeFrom, pageBase.convertFromBrowserToServerTimeZone(pageBase.getParameter("FromDateTime")));

if (pageBase.getNullParameter("ToDateTime") != null)
  qdef.addFilter(Fil.CreateDateTimeTo, pageBase.convertFromBrowserToServerTimeZone(pageBase.getParameter("ToDateTime")));

if (pageBase.getNullParameter("AnswerCommonStatus") != null)
  qdef.addFilter(Fil.OutboundOfflineStatus, JvArray.stringToIntArray(pageBase.getParameter("AnswerCommonStatus"), ","));

// Paging
if (!pageBase.isParameter("paging", "false")) {
  qdef.pagePos = pageBase.getQP();
  qdef.recordPerPage = QueryDef.recordPerPageDefault;
}
// Sort
qdef.addSort(Sel.CreateDateTime, false);
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
    <td>
      <v:grid-checkbox header="true"/>
    </td>
    <td>
    </td>
    <td width="30%" nowrap>
      <v:itl key="@Outbound.OutboundCreateDateTime"/><br/>
      <v:itl key="@Common.Status"/>
    </td>
    <td width="50%">
      <v:itl key="@Common.Entity"/>
    </td>
    <td width="20%" align="right">
      <div>Correlation ID</div>
      <div>Suppress Event</div>
    </td>
  </tr>
  
  <v:grid-row dataset="ds" dateGroupFieldName="<%=Sel.CreateDateTime.name()%>">
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>">
      <v:grid-checkbox dataset="ds" fieldname="<%=Sel.OutboundOfflineId.name()%>" name="OutboundOfflineId"/>
    </td>
    <td>
      <v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/>
    </td>
    <td nowrap>    
      <snp:datetime timestamp="<%=ds.getField(Sel.CreateDateTime)%>" format="shortdatelongtime" timezone="local" clazz="list-title"/>
      <br>
      <span class="list-subtitle">
        <%=LkSN.OutboundOfflineStatus.getItemByCode(ds.getField(Sel.OutboundOfflineStatus).getInt()).getDescription()%>
      </span>
    </td>
    <td>   
      <% LookupItem entityType = LkSN.EntityType.findItemByCode(ds.getField(Sel.EntityType)); %>
      <% if (entityType == null) { %>
         &mdash;
      <% } else { %>
        <% BLBO_PagePath.EntityRecap entityRecap = BLBO_PagePath.findEntityRecap(pageBase.getConnector(), entityType, ds.getField(Sel.EntityId).getString()); %>
        <%=entityType.getHtmlDescription(pageBase.getLang())%>
        <% if (entityRecap != null) { %>
          <br/><a href="<%=entityRecap.url%>"><%=JvString.escapeHtml(JvMultiLang.translate(request, entityRecap.name))%></a>
        <% } %>
      <% } %>     
    </td>
    <td align="right">
      <div class="list-subtitle"><%=JvString.escapeHtml(ds.getField(Sel.CorrelationId).isNull("-"))%></div>
      <div class="list-subtitle"><%=ds.getField(Sel.SuppressEvent).getBoolean()%></div>
    </td>
  </v:grid-row>
</v:grid>