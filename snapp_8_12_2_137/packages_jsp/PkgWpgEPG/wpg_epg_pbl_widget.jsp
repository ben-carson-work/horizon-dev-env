<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.PageBO_Base"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<%
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");

String requestURL = pageBase.getEmptyParameter("RequestURL");
boolean testMode = JvString.isSameString(pageBase.getEmptyParameter("TestMode"), "true");
boolean error = JvString.isSameString(pageBase.getEmptyParameter("PluginError"), "true");
String errorDescription = pageBase.getEmptyParameter("PluginErrorDescription");
%>

<style>
  
  .test-warn-box {
    padding: 10px;
    text-align: center;
    font-size: 16px;
    font-weight: bold;
    color: <%=JvCLDef.Colors.clrRed%>
  }
  
  .redirect-box {
    padding: 10px;
    text-align: center;
    font-size: 16px;
    font-weight: bold;
    color: black;
  }
</style>

<% if (testMode) { %>
  <div class="test-warn-box">*** TEST ENVIRONMENT ***</div>
<% } %>
<% if (error) { %>
  <div class="test-warn-box"><%=errorDescription%>*</div>
<% } %>
<div id="mpgs_waiting">
  <div class="redirect-box">Redirecting to Etisalat Payment Gateway Services......</div><br/>
  <div id="mpgs_spinner" style='height:100px; background-repeat:no-repeat; background-position:center center; background-image:url(<v:config key="resources_url"/>/admin/images/new-spinner32.gif)'></div>
</div>

<script>
	$(document).ready(function() {
		if ($("#webpayment_dialog").length) {
			let paymentWindow = window.open('<%=requestURL%>', '_blank');
			paymentWindow.onload = function() {
				$("#webpayment_dialog").dialog("close");
			};
			
			paymentWindow.onunload = function() {
				$("#webpayment_dialog").dialog("close");
			};
		} else {
			window.location.href = '<%=requestURL%>';
		}	
	});
</script>
