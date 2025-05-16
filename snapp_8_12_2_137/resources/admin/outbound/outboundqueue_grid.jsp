<%@page import="com.vgs.snapp.web.queue.outbound.WsOutbound"%>
<%@page import="com.vgs.snapp.web.queue.outbound.BLBO_Outbound"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.search.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_OutboundQueue.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
DOOutboundQueueSearchRequest reqDO = new DOOutboundQueueSearchRequest();

reqDO.SearchRecapRequest.PagePos.setInt(pageBase.getQP());
reqDO.SearchRecapRequest.RecordPerPage.setInt(QueryDef.recordPerPageDefault);

if (pageBase.getNullParameter("FromDateTime") != null)
  reqDO.FromDateTime.setDateTime(pageBase.convertFromBrowserToServerTimeZone(pageBase.getParameter("FromDateTime")));
if (pageBase.getNullParameter("ToDateTime") != null)
  reqDO.ToDateTime.setDateTime(pageBase.convertFromBrowserToServerTimeZone(pageBase.getParameter("ToDateTime")));
if (pageBase.getNullParameter("AnswerCommonStatus") != null)
  reqDO.AnswerCommonStatus.setArray(JvArray.stringToIntArray(pageBase.getParameter("AnswerCommonStatus"), ","));
if (pageBase.getNullParameter("AnswerCommonPriority") != null)
  reqDO.AnswerCommonPriority.setArray(JvArray.stringToIntArray(pageBase.getParameter("AnswerCommonPriority"), ","));
if (pageBase.getNullParameter("OutboundMessageCode") != null)
  reqDO.OutboundMessageCode.setString(pageBase.getNullParameter("OutboundMessageCode"));

DOOutboundQueueSearchAnswer ansDO = pageBase.getBL(BLBO_Outbound.class).searchOutboundQueue(reqDO); 

boolean externalQueue = pageBase.getRights().ExternalQueue.getBoolean();
String contextURL = pageBase.getBL(BLBO_Outbound.class).calcExternalContextURL();
%>


<% if (ansDO == null) { %>
<div class="tab-content">
  <v:alert-box type="warning">
    <% String href = ConfigTag.getValue("site_url") + "/admin?page=log"; %>
    <v:itl key="@Common.InfoNotFoundError"/>&nbsp;
    <a href="<%=href%>" target="_blank">Logs</a>
  </v:alert-box>
</div>
<% } else { %>

<v:grid id="outqueue-grid-table" search="<%=ansDO%>" clazz="log-grid-table">
  <tr class="header">
    <td>
      <v:grid-checkbox header="true" multipage="true"/>
    </td>
    <td>
    </td>
    <td width="20%" nowrap>
      <v:itl key="@Outbound.OutboundCreateDateTime"/><br/>
      <v:itl key="@Common.Status"/>
    </td>
    <td width="40%">
      <v:itl key="@Outbound.OutboundMessage"/><br>
      <v:itl key="@Common.Entity"/>
    </td>
    <td width="40%" nowrap>
      <v:itl key="@Outbound.OutboundScheduleDateTime"/><br/>
      <v:itl key="@Outbound.OutboundPriority"/>
    </td>
  </tr>
  
  <v:grid-row search="<%=ansDO%>" dateGroupFieldName="<%=Sel.CreateDateTime.name()%>">
    <% DOOutboundQueueRef record = ansDO.getRecord(); %>
    <td style="<v:common-status-style status="<%=record.CommonStatus%>"/>">
      <v:grid-checkbox value="<%=record.OutboundQueueId.getString()%>" fieldname="<%=record.OutboundQueueId.getNodeName()%>" name="OutboundQueueId"/>
    </td>
    <td>
      <v:grid-icon name="<%=record.IconAlias.getString()%>"/>
    </td>
    <td nowrap>
      <snp:entity-link entityId="<%=record.OutboundQueueId%>" entityType="<%=LkSNEntityType.OutboundQueue%>" contextURL="<%=contextURL%>" openOnNewTab="<%=externalQueue%>">
        <snp:datetime timestamp="<%=record.CreateDateTime%>" format="shortdatelongtime" timezone="local" clazz="list-title"/>
      </snp:entity-link>
      <div class="list-subtitle">
        <%=record.OutboundQueueStatus.getLookupDesc(pageBase.getLang())%>
        <% if (!record.RecoveryJobId.isNull()) { %>
          &mdash; <snp:entity-link entityId="<%=record.RecoveryJobId%>" entityType="<%=LkSNEntityType.Job%>"><v:itl key="@Outbound.Recovery"/></snp:entity-link>
        <% } %>
      </div>
    </td>
    <td>
      <snp:entity-link entityId="<%=record.OutboundMessageId%>" entityType="<%=LkSNEntityType.OutboundMessage%>" contextURL="<%=contextURL%>" openOnNewTab="<%=externalQueue%>">
        <%=record.OutboundMessageName.getHtmlString()%>
      </snp:entity-link>  
      <% if (record.Itemized.getBoolean()) { %>
        (<%=record.OutboundQueueItemCount.getInt()%> <v:itl key="@Common.Items" transform="lowercase"/>)
      <% } %>
      <br/>
      <% if (!record.RefEntityType.isNull()) { %>
        <% BLBO_PagePath.EntityRecap recap = BLBO_PagePath.findEntityRecap(pageBase.getConnector(), record.RefEntityType.getLkValue(), record.EntityId.getString()); %>
        <% if (recap != null) { %>
          <snp:entity-link entityId="<%=recap.id%>" entityType="<%=recap.type%>"><%=JvString.escapeHtml(recap.name)%></snp:entity-link><br/>
        <% } %>
      <% } %>
    </td>
    <td>
      <% if (record.ScheduleDateTime.isNull()) {%>
        &mdash;
      <% } else { %>
        <snp:datetime timestamp="<%=record.ScheduleDateTime%>" format="shortdatelongtime" timezone="local" clazz="list-title"/>
      <% } %><br />
      <span class="list-subtitle">
        <%=LkSN.OutboundMessagePriority.getItemDescription(record.OutboundMessagePriority.getString())%>
      </span> 
    </td>
  </v:grid-row>
</v:grid>
<% } %>