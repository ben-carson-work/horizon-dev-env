<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<v:tab-group name="tab" main="true">
  <% boolean first = true; %>
  <% if (rights.MonitorIT.getBoolean()) { %>
    <v:tab-item caption="@Common.Logs" icon="<%=LkSNEntityType.Log.getIconName()%>" tab="log" jsp="log_tab_log.jsp" default="<%=first%>"/>
    <% first = false; %>
  <% } %>
  <% if (rights.MonitorIT.getBoolean()) { %>
  	<v:tab-item caption="@System.ApiTracing" icon="<%=LkSNEntityType.ApiLog.getIconName()%>" tab="tracing" jsp="log_tab_api.jsp" default="<%=first%>"/>
  	<% first = false; %>
  <% } %>
  <% if (rights.MonitorIT.getBoolean()) { %>
    <v:tab-item caption="@Outbound.OutboundQueue" icon="<%=LkSNEntityType.OutboundQueue.getIconName()%>" tab="outboundqueue" jsp="../outbound/outbound_tab_queue.jsp" default="<%=first%>"/>
    <% first = false; %>
  <% } %>
  <% if (rights.MonitorIT.getBoolean() && !rights.QueueInstance.getBoolean() && rights.ExternalQueue.getBoolean()) { %>
    <v:tab-item caption="@Outbound.OutboundOffline" fa="history" tab="outboundoffline" jsp="../outbound/outbound_tab_offline.jsp" default="<%=first%>"/>
    <% first = false; %>
  <% } %>
</v:tab-group>

<jsp:include page="/resources/common/footer.jsp"/>
