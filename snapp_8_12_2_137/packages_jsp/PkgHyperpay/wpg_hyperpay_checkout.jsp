<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="authResponse" class="com.vgs.snapp.dataobject.DOWpgResponse" scope="request"/>

<%
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");

String checkoutId = pageBase.getParameter("checkoutId");
String shopperResultUrl = pageBase.getParameter("shopperResultUrl");
String paymentURL = pageBase.getParameter("paymentURL");

String iFrameHeight = "94%";

String site_url = ConfigTag.getValue("site_url"); 
String wpwlOptions = pageBase.getParameter("wpwlOptions");

%>

<style>
  #hyperpay_iframe {
    display: none;
  }
  
  #hyperpay_div {
  	padding: 30px;
  }
  
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
    font-size: 24px;
    font-weight: bold;
    color: black;
  }
</style>

<div id="ie-warn-box" class="test-warn-box v-hidden">If you are using an older version of Internet Explorer, please ensure that your cookies are enabled before proceeding with your payment</div>

<iframe id="hyperpay_iframe" name="hyperpay_frame_name">
</iframe>
<div id='hyperpay_div'>
	<script>
	    var wpwlOptions = {
	        style: 'plain',
	        brandDetection: true,
	        paymentTarget: 'hyperpay_frame_name',
	        shopperResultTarget: 'hyperpay_frame_name',
	        <%=wpwlOptions%>
	    }
	</script>
  <script src="<%=JvString.addTrailingSlash(paymentURL)%>v1/paymentWidgets.js?checkoutId=<%=checkoutId%>" crossorigin="anonymous"></script>

	<form id="hyperpay_form" method="get" action="<%=shopperResultUrl%>" class="paymentWidgets" data-brands="MADA VISA MASTER"></form>
</div>
<script>
$(document).ready(function() {
  var ie = detectIE();
  if ((ie == 10) || (ie == 11))
    $("#ie-warn-box").removeClass("v-hidden");
});
</script>

