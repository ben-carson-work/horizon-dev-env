<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageApi" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_ApiLog.class)
    .addFilter(QryBO_ApiLog.Fil.ApiLogId, pageBase.getNullParameter("id"))
    .addSelect(
        QryBO_ApiLog.Sel.ApiLogId,
        QryBO_ApiLog.Sel.StartDateTime,
        QryBO_ApiLog.Sel.EndDateTime,
        QryBO_ApiLog.Sel.RequestCode,
        QryBO_ApiLog.Sel.RequestCommand,
        QryBO_ApiLog.Sel.ClientIPAddress,
        QryBO_ApiLog.Sel.WorkstationId,
        QryBO_ApiLog.Sel.WorkstationName,
        QryBO_ApiLog.Sel.LocationId,
        QryBO_ApiLog.Sel.LocationName,
        QryBO_ApiLog.Sel.OpAreaId,
        QryBO_ApiLog.Sel.OpAreaName,
        QryBO_ApiLog.Sel.RequestHttpMethod,
        QryBO_ApiLog.Sel.RequestURL,
        QryBO_ApiLog.Sel.AnswerHttpStatus,
        QryBO_ApiLog.Sel.AnswerStatusCode,
        QryBO_ApiLog.Sel.ServerId,
        QryBO_ApiLog.Sel.ServerName,
        QryBO_ApiLog.Sel.Duration,
        QryBO_ApiLog.Sel.MsgRequestSize,
        QryBO_ApiLog.Sel.MsgAnswerSize);

JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

JvDataSet dsLNK = pageBase.getDB().executeQuery("select EntityId, EntityType from tbApiLogLink where ApiLogId=" + JvString.sqlStr(pageBase.getId()));
%>

<div class="tab-content">
  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:form-field caption="@Common.Start">
	     <snp:datetime timestamp="<%=ds.getField(QryBO_ApiLog.Sel.StartDateTime)%>" format="longdatetime" timezone="local" clazz="list-title"/>
         <strong>.<%=ds.getField(QryBO_ApiLog.Sel.StartDateTime).getDateTime().getMSec()%></strong>
      </v:form-field>
      <v:form-field caption="@Common.End">
	     <snp:datetime timestamp="<%=ds.getField(QryBO_ApiLog.Sel.EndDateTime)%>" format="longdatetime" timezone="local" clazz="list-title"/>
         <strong>.<%=ds.getField(QryBO_ApiLog.Sel.EndDateTime).getDateTime().getMSec()%></strong>
      </v:form-field>
      <v:form-field caption="Duration">
        <input type="text" readonly="readonly" class="form-control" value="<%=JvDateUtils.getSmoothTime(ds.getField(QryBO_ApiLog.Sel.Duration).getInt())%>">
      </v:form-field>
      <% if (!dsLNK.isEmpty()) { %>
        <v:form-field caption="@Common.Reference">
        <v:ds-loop dataset="<%=dsLNK%>">
          <% BLBO_PagePath.EntityRecap entityRecap = BLBO_PagePath.findEntityRecap(pageBase.getConnector(), dsLNK.getField("EntityType").getInt(), dsLNK.getField("EntityId").getString()); %>
          <% if (entityRecap != null) { %>
          <div><a href="<%=entityRecap.url%>"><%=JvString.escapeHtml(entityRecap.name)%></a></div>
          <% } %>
        </v:ds-loop>
        </v:form-field>
      <% } %>
      <v:form-field caption="API">
        <input type="text" readonly="readonly" class="form-control" value="<%=ds.getField(QryBO_ApiLog.Sel.RequestCode).getHtmlString()%>">
      </v:form-field>
      <v:form-field caption="Command">
        <input type="text" readonly="readonly" class="form-control" value="<%=ds.getField(QryBO_ApiLog.Sel.RequestCommand).getHtmlString()%>">
      </v:form-field>
      <v:form-field caption="Http Method">
        <input type="text" readonly="readonly" class="form-control" value="<%=ds.getField(QryBO_ApiLog.Sel.RequestHttpMethod).getHtmlString()%>">
      </v:form-field>
      <v:form-field caption="URL">
        <input type="text" readonly="readonly" class="form-control" value="<%=ds.getField(QryBO_ApiLog.Sel.RequestURL).getHtmlString()%>">
      </v:form-field>
      <v:form-field caption="Http Status Code">
        <input type="text" readonly="readonly" class="form-control" value="<%=ds.getField(QryBO_ApiLog.Sel.AnswerHttpStatus).getHtmlString()%>">
      </v:form-field>
      <v:form-field caption="API Status Code">
        <input type="text" readonly="readonly" class="form-control" value="<%=ds.getField(QryBO_ApiLog.Sel.AnswerStatusCode).getHtmlString()%>">
      </v:form-field>
      <v:form-field caption="Request Size">
        <input type="text" readonly="readonly" class="form-control" value="<%=JvString.getSmoothSize(ds.getField(QryBO_ApiLog.Sel.MsgRequestSize).getLong())%>">
      </v:form-field>
      <v:form-field caption="Response Size">
        <input type="text" readonly="readonly" class="form-control" value="<%=JvString.getSmoothSize(ds.getField(QryBO_ApiLog.Sel.MsgAnswerSize).getLong())%>">
      </v:form-field>
      <v:form-field caption="Server">
        <snp:entity-link entityId="<%=ds.getField(QryBO_ApiLog.Sel.ServerId).getHtmlString()%>" entityType="<%=LkSNEntityType.Server%>">
          <%=ds.getField(QryBO_ApiLog.Sel.ServerName).getHtmlString()%>
        </snp:entity-link>
      </v:form-field>
      <v:form-field caption="Workstation">
        <snp:entity-link entityId="<%=ds.getField(QryBO_ApiLog.Sel.LocationId)%>" entityType="<%=LkSNEntityType.Location%>">
          <%=ds.getField(QryBO_ApiLog.Sel.LocationName).getHtmlString()%>
        </snp:entity-link>
        &raquo;
        <snp:entity-link entityId="<%=ds.getField(QryBO_ApiLog.Sel.OpAreaId)%>" entityType="<%=LkSNEntityType.OperatingArea%>">
          <%=ds.getField(QryBO_ApiLog.Sel.OpAreaName).getHtmlString()%>
        </snp:entity-link>
        &raquo;
        <snp:entity-link entityId="<%=ds.getField(QryBO_ApiLog.Sel.WorkstationId)%>" entityType="<%=LkSNEntityType.Workstation%>">
          <%=ds.getField(QryBO_ApiLog.Sel.WorkstationName).getHtmlString()%>
        </snp:entity-link>
      </v:form-field>
      <v:form-field caption="Client IP Address">
          <%=ds.getField(QryBO_ApiLog.Sel.ClientIPAddress).getHtmlString()%>
      </v:form-field>      
    </v:widget-block>
  </v:widget>
</div>