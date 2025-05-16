<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageEngineStats" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="license" class="com.vgs.snapp.dataobject.DOLicenseDef" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<v:tab-group name="tab" main="true">
  <% if (rights.VGSSupport.getBoolean() || SnpLicense.ModSDK.isModuleActive(license)) { %>
    <v:tab-item caption="System dashboard" tab="systemstatus" fa="gauge" jsp="engstats_tab_systemstatus.jsp" default="true"/>
    <v:tab-item caption="@Stats.LoginStats" tab="login" fa="sign-in" jsp="engstats_tab_login.jsp"/>
    <v:tab-item caption="@Common.ProcessQueue" tab="upload" fa="upload" jsp="engstats_tab_upload.jsp"/>
    <v:tab-item caption="APIs" tab="cmd" fa="cloud" jsp="engstats_tab_apis.jsp" />
    <% String hrefAsyncTab = "/admin?page=engstats_tab_queuestatus&QueueStatType=" + LkSNQueueStatType.AsyncFinalize.getCode(); %>
    <v:tab-item caption="@Stats.PostProcesses" tab="asyncfin" fa="cogs" jsp="<%=hrefAsyncTab%>" />
    <% String hrefOutboundTab = "/admin?page=engstats_tab_queuestatus&QueueStatType=" + LkSNQueueStatType.Outbound.getCode(); %>
    <v:tab-item caption="@Outbound.OutboundQueue" tab="outbound" fa="paper-plane" jsp="<%=hrefOutboundTab%>" />
    <v:tab-item caption="DB Info" tab="dbstats" fa="database" jsp="engstats_tab_dbstats.jsp"/>
    <v:tab-item caption="DB pools" tab="pool" fa="database" jsp="engstats_tab_pool.jsp" />
    <v:tab-item caption="Services" tab="service" fa="cog" jsp="engstats_tab_service.jsp" />
    <v:tab-item caption="JVM" tab="mem" fa="memory" jsp="engstats_tab_mem.jsp" />
    <v:tab-item caption="Tomcat logs" tab="log" fa="terminal" jsp="engstats_tab_log.jsp" />
  <% } else { %>
    <v:tab-item caption="@Stats.LoginStats" tab="login" fa="sign-in" jsp="engstats_tab_login.jsp" default="true"/>
  <% } %>
</v:tab-group>

&nbsp;
 
<jsp:include page="/resources/common/footer.jsp"/>