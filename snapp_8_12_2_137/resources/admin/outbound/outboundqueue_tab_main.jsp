<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="com.vgs.snapp.query.QryBO_OutboundQueue.*"%>
<%@page import="com.vgs.web.library.BLBO_PagePath"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageOutboundQueue" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_OutboundQueue.class);
// Select
qdef.addSelect(
    QryBO_OutboundQueue.Sel.OutboundQueueId,
    QryBO_OutboundQueue.Sel.OutboundMessageId,
    QryBO_OutboundQueue.Sel.OutboundQueueStatus,
    QryBO_OutboundQueue.Sel.CreateDateTime,
    QryBO_OutboundQueue.Sel.EntityId,
    QryBO_OutboundQueue.Sel.EntityType,
    QryBO_OutboundQueue.Sel.FailedAttemptCount,
    QryBO_OutboundQueue.Sel.DocData,
    QryBO_OutboundQueue.Sel.OutboundMessageName,
    QryBO_OutboundQueue.Sel.OutboundMessagePriority,
    QryBO_OutboundQueue.Sel.CommonStatus,
    QryBO_OutboundQueue.Sel.IconName,
    QryBO_OutboundQueue.Sel.CorrelationId,
    QryBO_OutboundQueue.Sel.SuppressEvent);

// Where
qdef.addFilter(QryBO_OutboundQueue.Fil.OutboundQueueId, pageBase.getId());

JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);


QueryDef qdefHistory = new QueryDef(QryBO_OutboundQueueHistory.class);
//Select
qdefHistory.addSelect(
    QryBO_OutboundQueueHistory.Sel.OutboundQueueHistoryId,
    QryBO_OutboundQueueHistory.Sel.OutboundQueueId,
    QryBO_OutboundQueueHistory.Sel.OutboundQueueHistoryStatus,
    QryBO_OutboundQueueHistory.Sel.OutboundMessagePriority,
    QryBO_OutboundQueueHistory.Sel.OutboundQueueAction,
    QryBO_OutboundQueueHistory.Sel.CreateDateTime,
    QryBO_OutboundQueueHistory.Sel.ScheduleDateTime,
    QryBO_OutboundQueueHistory.Sel.StartDateTime,
    QryBO_OutboundQueueHistory.Sel.EndDateTime,
    QryBO_OutboundQueueHistory.Sel.ServerId,
    QryBO_OutboundQueueHistory.Sel.RequestData,
    QryBO_OutboundQueueHistory.Sel.ResponseData,
    QryBO_OutboundQueueHistory.Sel.Notes,
    QryBO_OutboundQueueHistory.Sel.ServerName,
    QryBO_OutboundQueueHistory.Sel.ProcessTime,
    QryBO_OutboundQueueHistory.Sel.QueueTime,
    QryBO_OutboundQueueHistory.Sel.MsgRequestSize,
    QryBO_OutboundQueueHistory.Sel.UserAccountName,
    QryBO_OutboundQueueHistory.Sel.CommonStatus);

qdefHistory.addFilter(QryBO_OutboundQueueHistory.Fil.OutboundQueueId, pageBase.getId()); 

//Sort
qdefHistory.addSort(Sel.CreateDateTime, true);
//Exec
JvDataSet dsHistory = pageBase.execQuery(qdefHistory);
request.setAttribute("dsHistory", dsHistory);
%>

<div class="tab-toolbar">
  <div class="btn-group">
    <v:button id="status-btn" caption="@Common.Status" fa="flag" dropdown="true"/>
    <v:popup-menu bootstrap="true">
        <% 
          String outboundQueueId = "&OutboundQueueId=" + pageBase.getId();
          String hrefResolved = "javascript:asyncDialogEasy('log/markasresolvedmessage_dialog', '" + outboundQueueId + "')"; 
          String hrefRetry = "javascript:asyncDialogEasy('log/retrymessage_dialog', '" + outboundQueueId + "')";
        %>
        <v:popup-item caption="@Outbound.MarkAsResolved" href="<%=hrefResolved%>"/>
        <v:popup-item caption="@Common.Retry" href="<%=hrefRetry%>"/>
    </v:popup-menu>
  </div>
</div>

<style>
  .queue-recap-container {
    display: flex;
    justify-content: space-between;
  }
  
  #general-widget {
    margin-right: 10px; 
    width: 40%;
    min-width: 300px;
  }
  
</style>

<div class="tab-content">
  
  <div class="queue-recap-container">

      <v:widget id="general-widget" caption="@Common.General" >
        <v:widget-block>
          <v:itl key="@Outbound.OutboundMessageName"/>
          <span class="recap-value">
            <snp:entity-link entityId="<%=ds.getField(Sel.OutboundMessageId)%>" entityType="<%=LkSNEntityType.OutboundMessage%>">
              <%=ds.getField(QryBO_OutboundQueue.Sel.OutboundMessageName).getHtmlString()%>
            </snp:entity-link>          
          </span><br /> 
          <% BLBO_PagePath.EntityRecap entityRecap = BLBO_PagePath.findEntityRecap(pageBase.getConnector(), ds.getField(QryBO_OutboundQueue.Sel.EntityType).getInt(), ds.getField(QryBO_OutboundQueue.Sel.EntityId).getString());%>
          <% if (entityRecap != null) { %>
          <v:itl key="@Common.Reference"/>
          <span class="recap-value">
            <snp:entity-link entityId="<%=entityRecap.id%>" entityType="<%=entityRecap.type%>"><%=JvString.escapeHtml(entityRecap.name)%></snp:entity-link><br/>
          </span>
          <% } %> <br />
          <v:itl key="@Outbound.OutboundCreateDateTime"/>
          <span class="recap-value">
            <snp:datetime timestamp="<%=dsHistory.getField(QryBO_OutboundQueueHistory.Sel.CreateDateTime)%>" format="shortdatelongtime" timezone="local" clazz="list-title"/>
          </span><br />
          <v:itl key="@Common.Status"/>
          <span class="recap-value">
            <%=LkSN.OutboundQueueStatus.getItemDescription(ds.getField(QryBO_OutboundQueue.Sel.OutboundQueueStatus).getString())%>
          </span><br />            
          <v:itl key="@Outbound.OutboundPriority"/>
          <span class="recap-value">
            <%=LkSN.OutboundMessagePriority.getItemDescription(ds.getField(QryBO_OutboundQueue.Sel.OutboundMessagePriority).getString())%>   
          </span><br /> 
        </v:widget-block>
        <v:widget-block>
          Correlation ID
          <span class="recap-value">
            <%=JvString.escapeHtml(ds.getField(QryBO_OutboundQueue.Sel.CorrelationId).isNull("-"))%>
          </span><br />            
          Suppress event
          <span class="recap-value">
            <%=ds.getField(QryBO_OutboundQueue.Sel.SuppressEvent).getBoolean()%>   
          </span><br /> 
        </v:widget-block>
        <v:widget-block>
          <v:itl key="@Outbound.OutboundQueueMessageSize"/>
          <span class="recap-value">
            <%=JvString.getSmoothSize(dsHistory.getField(QryBO_OutboundQueueHistory.Sel.MsgRequestSize).getLong())%>
          </span>
        </v:widget-block>
      </v:widget>


      <v:grid dataset="<%=dsHistory%>" qdef="<%=qdefHistory%>" clazz="log-grid-table">
        <thead>
          <v:grid-title caption="@Outbound.OutboundQueueMessageHistory"/>
          <tr class="header">
            <td></td>
            <td width="20%" nowrap>
              <v:itl key="@Outbound.OutboundCreateDateTime"/><br/>
              <v:itl key="@Common.Status"/>
            </td>
            <td width="15%">
              <v:itl key="@Outbound.OutboundAction"/>
            </td>
            <td width="20%">
              <v:itl key="@Outbound.OutboundStartDateTime"/><br>
              <v:itl key="@Outbound.OutboundEndDateTime"/>
            </td>
            <td width="20%">
              <v:itl key="@Common.User"/><br>
              <v:itl key="@Common.Notes"/>
            </td>
            <td width="25%" align="right">
              Server &mdash; Processing Time<br/>
              Queue Time
            </td>
          </tr>
        </thead>
        <tbody>
          <v:grid-row dataset="dsHistory">
            <td style="<v:common-status-style status="<%=dsHistory.getField(QryBO_OutboundQueueHistory.Sel.CommonStatus)%>"/>">
            </td>
            <td nowrap>
              <snp:datetime timestamp="<%=dsHistory.getField(QryBO_OutboundQueueHistory.Sel.CreateDateTime)%>" format="shortdatelongtime" timezone="local" clazz="list-title"/> <br />
              <span class="list-subtitle">
                <%=LkSN.OutboundQueueHistoryStatus.getItemByCode(dsHistory.getField(QryBO_OutboundQueueHistory.Sel.OutboundQueueHistoryStatus).getInt()).getDescription()%>
              </span>
            </td>
            <td>
              <span class="list-subtitle">
                <%=LkSN.OutboundQueueAction.getItemByCode(dsHistory.getField(QryBO_OutboundQueueHistory.Sel.OutboundQueueAction).getInt()).getDescription()%>
              </span>
            </td>
            <td>
              <% if (!(dsHistory.getField(QryBO_OutboundQueueHistory.Sel.StartDateTime).isNull() && dsHistory.getField(QryBO_OutboundQueueHistory.Sel.ScheduleDateTime).isNull())) { %>
              
                <% if (dsHistory.getField(QryBO_OutboundQueueHistory.Sel.StartDateTime).isNull()) { %>
                  <snp:datetime timestamp="<%=dsHistory.getField(QryBO_OutboundQueueHistory.Sel.ScheduleDateTime)%>" format="shortdatelongtime" timezone="local" clazz="list-title"/>
                <% } else { %>
                  <snp:datetime timestamp="<%=dsHistory.getField(QryBO_OutboundQueueHistory.Sel.StartDateTime)%>" format="shortdatelongtime" timezone="local" clazz="list-title"/>
                <% } %> <br />
                <% if (dsHistory.getField(QryBO_OutboundQueueHistory.Sel.EndDateTime).isNull()) { %>
                  &mdash;
                <% } else { %>
                  <snp:datetime timestamp="<%=dsHistory.getField(QryBO_OutboundQueueHistory.Sel.EndDateTime)%>" format="shortdatelongtime" timezone="local" clazz="list-title"/>
                <% } %>
              <% } %>
            </td>
            <td>
              <% String separator = (!dsHistory.getField(QryBO_OutboundQueueHistory.Sel.UserAccountName).isNull()) ? "&mdash;" : ""; %> 
              <% if (dsHistory.getField(QryBO_OutboundQueueHistory.Sel.UserAccountName).isNull()) { %>
                <%=separator %>
              <% } else { %>
                <%=dsHistory.getField(QryBO_OutboundQueueHistory.Sel.UserAccountName).getHtmlString()%>
              <% } %> <br />
              <% if (dsHistory.getField(QryBO_OutboundQueueHistory.Sel.Notes).isNull()) { %>
                <span class="list-subtitle">
                  <%=separator %>
                </span>
              <% } else { %>
                <span class="list-subtitle">
                  <%=dsHistory.getField(QryBO_OutboundQueueHistory.Sel.Notes).getHtmlString()%>
                </span>
              <% } %> 
            </td>
            <td align="right">
              <% if (!LkSNOutboundQueueHistoryStatus.Info.isLookup(LkSN.OutboundQueueStatus.getItemByCode(dsHistory.getField(QryBO_OutboundQueueHistory.Sel.OutboundQueueHistoryStatus).getInt()))) { %>
                <div>
                  <% if (!dsHistory.getField(QryBO_OutboundQueueHistory.Sel.ServerId).isNull()) { %>
                    <snp:entity-link entityId="<%=dsHistory.getField(QryBO_OutboundQueueHistory.Sel.ServerId)%>" entityType="<%=LkSNEntityType.Server%>">
                      <%=dsHistory.getField(QryBO_OutboundQueueHistory.Sel.ServerName).getHtmlString()%>
                    </snp:entity-link>
                    &mdash;
                  <% } %>
                  <%=JvDateUtils.getSmoothTime(dsHistory.getField(QryBO_OutboundQueueHistory.Sel.ProcessTime).getInt())%>
                </div>
                
                <div class="list-subtitle">
                  <%=JvDateUtils.getSmoothTime(dsHistory.getField(QryBO_OutboundQueueHistory.Sel.QueueTime).getInt())%>
                </div>
              <% } %>
            </td>
          </v:grid-row>
        </tbody>
      </v:grid>

  </div>
</div>