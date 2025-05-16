<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageEngineStats" scope="request"/>

<script src="<v:config key="site_url"/>/libraries/amcharts/amcharts.js"></script>
<script src="<v:config key="site_url"/>/libraries/amcharts/serial.js"></script>
<script src="<v:config key="site_url"/>/libraries/amcharts/gauge.js"></script>

<style>

.row {
  margin: 0 -5px;
}

.row>* {
  padding: 0 5px;
} 

.stat-widget .spinner-icon {
  margin: 5px;
}

.stat-widget:not(.loading) .spinner-icon {
  display: none;
}

</style>

<script>
$(document).ready(function() {
  $(".stat-widget .widget-title-caption").after("<span class='spinner-icon fa fa-circle-notch fa-spin'></span>");
});
</script>

<div class="tab-content">
  <jsp:include page="chart_database_widget.jsp"/>
  
  <div class="row">
    <div class="col-lg-12">
      <jsp:include page="chart_appserver_widget.jsp"></jsp:include>
    </div>
  </div>
  
  <div class="row">
    <div class="col-lg-6">
      <jsp:include page="chart_queue_widget.jsp"><jsp:param name="QueueStatType" value="<%=LkSNQueueStatType.AsyncFinalize.getCode()%>"/></jsp:include>
    </div>
    <div class="col-lg-6">
      <jsp:include page="chart_queue_widget.jsp"><jsp:param name="QueueStatType" value="<%=LkSNQueueStatType.Outbound.getCode()%>"/></jsp:include>
    </div>
  </div>
  
  <div class="row">
    <div class="col-lg-6">
      <jsp:include page="chart_api_widget.jsp"></jsp:include>
    </div>
    <div class="col-lg-6">
      <jsp:include page="chart_api_widget.jsp"><jsp:param name="Service" value="PostTransaction"/></jsp:include>
    </div>
  </div>
</div>
