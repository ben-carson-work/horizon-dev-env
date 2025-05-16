<%@page import="com.vgs.web.dataobject.DODocLogSql"%>
<%@page import="com.vgs.snapp.dataobject.DOLogDataBase"%>
<%@page import="com.vgs.cl.database.*"%>
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

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageLogDataDialog" scope="request"/>
<jsp:useBean id="logInfo" class="com.vgs.snapp.dataobject.DOLogInfo" scope="request"/>

<% String title = "[" + logInfo.LogLevel.getLookupDesc(pageBase.getLang()).toUpperCase() + "] " + pageBase.format(logInfo.LogDateTime.getDateTime(), pageBase.getShortDateTimeFormat(), true); %>

<v:dialog id="log-data-dialog" title="<%=title%>" icon="<%=LkSNEntityType.Log.getIconName()%>" width="1024" height="768" autofocus="false">

  <v:profile-recap>
    <v:widget icon="profile.png" caption="@Common.Recap">
      <v:widget-block>
        <v:recap-item caption="@Common.Type"><v:label field="<%=logInfo.LogType%>"/></v:recap-item>
        <v:recap-item caption="@Common.LogLevel"><v:label field="<%=logInfo.LogLevel%>"/></v:recap-item>
        <v:recap-item caption="@Common.DateTime"><snp:datetime timestamp="<%=logInfo.LogDateTime%>" format="shortdatetime" timezone="local"/></v:recap-item>
        <v:recap-item caption="LogDataType"><v:label field="<%=logInfo.LogDataType%>"/></v:recap-item>
      </v:widget-block>
      
      <v:widget-block>
        <v:recap-item caption="@Account.Location"><snp:entity-link entityId="<%=logInfo.LocationId%>" entityType="<%=LkSNEntityType.Location%>"><%=logInfo.LocationName.getHtmlString()%></snp:entity-link></v:recap-item>
        <v:recap-item caption="@Account.OpArea"><snp:entity-link entityId="<%=logInfo.OpAreaId%>" entityType="<%=LkSNEntityType.OperatingArea%>"><%=logInfo.OpAreaName.getHtmlString()%></snp:entity-link></v:recap-item>
        <v:recap-item caption="@Common.Workstation"><snp:entity-link entityId="<%=logInfo.WorkstationId%>" entityType="<%=LkSNEntityType.Workstation%>"><%=logInfo.WorkstationName.getHtmlString()%></snp:entity-link></v:recap-item>
        <v:recap-item caption="Version"><v:label field="<%=logInfo.Version%>"/></v:recap-item>
        <v:recap-item caption="@Common.Server"><snp:entity-link entityId="<%=logInfo.ServerId%>" entityType="<%=LkSNEntityType.Server%>"><v:label field="<%=logInfo.ServerName%>"/></snp:entity-link></v:recap-item>
      </v:widget-block>
      
      <% BLBO_PagePath.EntityRecap entityRecap = BLBO_PagePath.findEntityRecap(pageBase.getConnector(), logInfo.EntityType.getLkValue(), logInfo.EntityId.getString()); %>
      <v:widget-block include="<%=(entityRecap != null)%>">
        <v:recap-item caption="Entity"><a href="<%=entityRecap.url%>"><%=JvString.escapeHtml(JvMultiLang.translate(request, entityRecap.name))%></a></v:recap-item>
      </v:widget-block>
    </v:widget>
  </v:profile-recap>
  
  
  <v:profile-main>
    <% if (logInfo.LogDataType.isLookup(LkSNLogDataType.PlainText)) { %>
      <v:widget icon="xml.png" caption="Text">
        <v:widget-block>
          <%=logInfo.LogText.getHtmlString()%>
        </v:widget-block>
      </v:widget>
    <% } else if (logInfo.LogDataType.isLookup(LkSNLogDataType.Sql)) { %>
      <jsp:include page="log_sql_dialog.jsp" />
    <% } else if (logInfo.LogDataType.isLookup(LkSNLogDataType.Cmd)) { %>
      <jsp:include page="log_cmd_dialog.jsp" />
    <% } else if (logInfo.LogDataType.isLookup(LkSNLogDataType.Client)) { %>
      <jsp:include page="log_client_dialog.jsp" />
    <% } else { %>
      Unhandled LogDataType: <%=logInfo.LogDataType.getLookupDesc()%> 
    <% } %>
  </v:profile-main>

</v:dialog>