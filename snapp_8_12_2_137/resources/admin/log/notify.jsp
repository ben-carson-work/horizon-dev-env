<%@page import="com.vgs.web.library.PageBase"%>
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
    <v:tab-item caption="@Common.Notifications" icon="<%=LkSNEntityType.Notify.getIconName()%>" tab="notifylog" jsp="notify_tab_notify.jsp" default="<%=first%>"/>
    <% first = false; %>
  <% } %>
  <% if (rights.SettingsITSettings.getBoolean()) { %>
    <v:tab-item caption="@Notify.NotifyRules" icon="<%=LkSNEntityType.NotifyConfig.getIconName()%>" tab="notifyrule" jsp="notify_tab_rulelist.jsp" default="<%=first%>"/>
    <% first = false; %>
  <% } %>
  <% if (rights.SettingsITSettings.getBoolean()) { %>
    <v:tab-item caption="@SmtpSettings.EmailSettings" fa="envelope" tab="email" jsp="notify_tab_emailconfig.jsp" default="<%=first%>"/>
    <% first = false; %>
  <% } %>
</v:tab-group>

<jsp:include page="/resources/common/footer.jsp"/>
