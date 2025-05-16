<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>
 
<v:tab-group name="tab" main="true">
  <% boolean first = true; %>
  <% if (rights.SettingsITSettings.getBoolean()) { %>
    <v:tab-item caption="@Outbound.OutboundConfiguration" icon="<%=JvImageCache.ICON_SETTINGS%>" tab="config" jsp="outboundcfg_tab_config.jsp" default="<%=first%>"/>
    <% first = false; %>
  <% } %>
  <% if (rights.SettingsITSettings.getBoolean()) { %>
    <v:tab-item caption="@Outbound.OutboundMessages" icon="<%=LkSNEntityType.OutboundMessage.getIconName()%>" tab="message" jsp="outboundcfg_tab_message.jsp" default="<%=first%>"/>
    <% first = false; %>
  <% } %>
  <% if (rights.SettingsITSettings.getBoolean()) { %>
    <% if (!rights.QueueInstance.getBoolean() && rights.ExternalQueue.getBoolean()) { %>
      <v:tab-item caption="@Outbound.OutboundBrokers" icon="outboundbroker.png" tab="broker" jsp="outboundcfg_tab_broker_remote.jsp" default="<%=first%>"/>
    <% } else { %>
      <% String hrefPluginTab = "/admin?page=webplugin_tab_widget&DriverType=" + LkSNDriverType.OutboundBroker.getCode(); %>
      <v:tab-item caption="@Outbound.OutboundBrokers" icon="outboundbroker.png" tab="broker" jsp="<%=hrefPluginTab%>" default="<%=first%>"/>
    <% } %>
    <% first = false; %>
  <% } %>
  <% if (rights.MonitorIT.getBoolean()) { %>
    <v:tab-item caption="@Outbound.OutboundQueue" fa="envelope" tab="outboundqueue" jsp="outbound_tab_queue.jsp" default="<%=first%>"/>
    <% first = false; %>
  <% } %>
  <% if (rights.MonitorIT.getBoolean() && (!rights.QueueInstance.getBoolean() && rights.ExternalQueue.getBoolean())) { %>
    <v:tab-item caption="@Outbound.OutboundOffline" fa="clock" tab="outboundoffline" jsp="outbound_tab_offline.jsp" default="<%=first%>"/>
    <% first = false; %>
  <% } %>
</v:tab-group>
 
<jsp:include page="/resources/common/footer.jsp"/>
