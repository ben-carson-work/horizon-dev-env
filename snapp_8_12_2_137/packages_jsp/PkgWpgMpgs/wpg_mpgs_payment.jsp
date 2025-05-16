<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:include page="/resources/common/header-head.jsp"/>

<%
boolean testMode = JvString.isSameString(request.getParameter("testmode"), "true");
String checkoutConfig = request.getParameter("config");
String checkoutURL = request.getParameter("checkouturl");
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
<div id="mpgs_waiting">
  <div id="mpgs_spinner" style='height:100px; background-repeat:no-repeat; background-position:center center; background-image:url(<v:config key="resources_url"/>/admin/images/new-spinner32.gif)'></div>
</div>

<script src="<%=checkoutURL%>checkout.js"></script>

<script>
$(document).ready(function() {
  function waitForCheckout(callback) {
    if (window.Checkout) {
        callback();
	}
    else {
      setTimeout(function() {
        waitForCheckout(callback);
      }, 100);
    }
  }
  
  waitForCheckout(function() {
    Checkout.configure(<%=checkoutConfig%>);
    Checkout.showPaymentPage();
  });
  
});
</script>
 