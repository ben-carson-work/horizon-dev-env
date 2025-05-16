<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_OutboundQueueItem.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_OutboundQueueItem.class);
// Select
qdef.addSelect(
    Sel.OutboundQueueItemId,
    Sel.OutboundQueueId,
    Sel.OutboundQueueItemStatus,
    Sel.ItemEntityId,
    Sel.ItemEntityType,
    Sel.IconAlias,
    Sel.CommonStatus,
    Sel.DocDataSize,
    Sel.ExecutionTimeDesc);

// Filter
if (pageBase.getNullParameter("OutboundQueueId") != null)
  qdef.addFilter(Fil.OutboundQueueId, pageBase.getParameter("OutboundQueueId"));

// Paging
if (!pageBase.isParameter("paging", "false")) {
  qdef.pagePos = pageBase.getQP();
  qdef.recordPerPage = QueryDef.recordPerPageDefault;
}
// Sort
//qdef.addSort(Sel.CreateDateTime, false);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>">
  <tr class="header">
    <td>
      <v:grid-checkbox header="true"/>
    </td>
    <td width="20%" nowrap>
      <v:itl key="@Common.Item"/><br/>
      <v:itl key="@Common.Status"/>
    </td>
    <td width="60%" nowrap>
      <v:itl key="@Common.Reference"/>
    </td>
    <td width="20%" nowrap align="right">
      <v:itl key="Execution time"/><br/>
      <v:itl key="@Common.Size"/>
    </td>
    <td></td>
  </tr>
  
  <v:grid-row dataset="ds">
    <% LookupItem status = LkSN.OutboundQueueItemStatus.getItemByCode(ds.getField(Sel.OutboundQueueItemStatus)); %>
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>">
      <v:grid-checkbox dataset="ds" fieldname="<%=Sel.OutboundQueueItemId.name()%>" name="OutboundQueueId"/>
    </td>
    <td nowrap>
      <div class="list-title"><a href="javascript:asyncDialogEasy('outbound/outboundqueueitem_dialog','id=<%=ds.getField(Sel.OutboundQueueItemId).getString()%>')"><v:itl key="@Common.Message"/></a></div>
      <div class="list-subtitle"><%=status.getDescription()%></div>
    </td>
    <td>
      <div>
        <% BLBO_PagePath.EntityRecap recap = BLBO_PagePath.findEntityRecap(pageBase.getConnector(), LkSN.EntityType.getItemByCode(ds.getField(Sel.ItemEntityType)), ds.getField(Sel.ItemEntityId).getString()); %>
        <% if (recap != null) { %>
          <snp:entity-link entityId="<%=recap.id%>" entityType="<%=recap.type%>"><%=JvString.escapeHtml(recap.name)%></snp:entity-link>
        <% } %>
      </div>
    </td>
    <td align="right">
      <%=ds.getField(Sel.ExecutionTimeDesc).getHtmlString()%><br/>
      <%=JvString.escapeHtml(JvString.getSmoothSize(ds.getField(Sel.DocDataSize).getLong()))%>
    </td>
    <td>
      <a target="_new" href="<%=pageBase.getContextURL()%>?page=outboundqueue&action=download-item&OutboundQueueItemId=<%=ds.getField(Sel.OutboundQueueItemId).getString()%>" class="row-hover-visible"><i class="fa fa-2x fa-download"></i></a>
    </td>
  </v:grid-row>
</v:grid>