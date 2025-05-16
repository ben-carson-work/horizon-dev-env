<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.bko.page.PageBO_EngstatsTabQueueStatus" scope="request"/>

<%
LookupItem queueStatType = LkSN.QueueStatType.getItemByCode(pageBase.getParameter("QueueStatType"));
JvDataSet ds = pageBase.getDB().executeQuery("select distinct GroupCode, GroupName from tbQueueStat where TimeSlot>DateAdd(day,-1,GetDate()) and QueueStatType=" + queueStatType.getCode());
%>

<style>
</style>
 
<script src="<v:config key="site_url"/>/libraries/amcharts/amcharts.js"></script>
<script src="<v:config key="site_url"/>/libraries/amcharts/serial.js"></script>

<div class="tab-toolbar">
</div>

<div class="tab-content" style="overflow:hidden">
  <jsp:include page="chart_queue_widget.jsp">
    <jsp:param name="QueueStatType" value="<%=queueStatType.getCode()%>"/>
  </jsp:include>

  <v:ds-loop dataset="<%=ds%>">
    <%
    String groupCode = ds.getField("GroupCode").getString();
    String groupName = ds.getField("GroupName").getString();
    %>
    <jsp:include page="chart_queue_widget.jsp">
      <jsp:param name="QueueStatType" value="<%=queueStatType.getCode()%>"/>
      <jsp:param name="GroupCode" value="<%=groupCode%>"/>
      <jsp:param name="GroupName" value="<%=groupName%>"/>
    </jsp:include>
  </v:ds-loop>
</div>

