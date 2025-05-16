<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<%
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");

String paymentLink = pageBase.getParameter("paymentLink");

%>

<style>
  #mit_iframe {
    border: none;
    width: 100%;
    height: 99%;
  }
  
  .test-warn-box {
    padding: 10px;
    text-align: center;
    font-size: 16px;
    font-weight: bold;
    color: <%=JvCLDef.Colors.clrRed%>
  }
</style>

<div id="ie-warn-box" class="test-warn-box v-hidden">If you are using an older version of Internet Explorer, please ensure that your cookies are enabled before proceeding with your payment</div>

<iframe id="mit_iframe" name="mit_iframe" src="<%=paymentLink%>"></iframe>

<script>
$(document).ready(function() {
  var ie = detectIE();
  if ((ie == 10) || (ie == 11))
    $("#ie-warn-box").removeClass("v-hidden");
});

</script>
