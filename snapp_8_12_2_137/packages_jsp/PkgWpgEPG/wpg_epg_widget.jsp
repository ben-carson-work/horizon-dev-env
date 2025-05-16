<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.PageBO_Base"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<%
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");

String callbackURL = pageBase.getEmptyParameter("CallbackURL");
String requestURL = pageBase.getEmptyParameter("RequestURL");
String transactionId = pageBase.getEmptyParameter("TransactionId");
boolean error = JvString.isSameString(pageBase.getEmptyParameter("PluginError"), "true");
String errorDescription = pageBase.getEmptyParameter("PluginErrorDescription");
boolean testMode = JvString.isSameString(pageBase.getEmptyParameter("TestMode"), "true");

String iFrameHeight = "99%";
%>

<style>
  #epg_iframe {
    border: none;
    width: 100%;
    height: <%=iFrameHeight%>;
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
    font-size: 16px;
    font-weight: bold;
    color: black;
  }
</style>

<% if (testMode) { %>
  <div class="test-warn-box">*** TEST ENVIRONMENT ***</div>
<% } %>
<div id="ie-warn-box" class="test-warn-box v-hidden">If you are using an older version of Internet Explorer, please ensure that your cookies are enabled before proceeding with your payment</div>
<div id="epg_waiting">
  <div class="redirect-box">Redirecting to Etisalat Payment Gateway......</div><br/>
  <div id="epg_spinner" style='height:100px; background-repeat:no-repeat; background-position:center center; background-image:url(<v:config key="resources_url"/>/admin/images/new-spinner32.gif)'></div>
</div>
<iframe id="epg_iframe" name="epg_iframe"></iframe>
<form id="epg_form" method="post" target="epg_iframe" action="<%=requestURL%>">
  <input type='Hidden' name='TransactionID' value="<%=transactionId%>"/> 
</form>
<form id="epg_error_form" method="post" target="epg_iframe" action="<%=callbackURL%>">
  <input type='Hidden' name='ErrorDescription' value='<%=errorDescription%>'/> 
</form>

<script>
$(document).ready(function() {
	var ie = detectIE();
	  if ((ie == 10) || (ie == 11))
	    $("#ie-warn-box").removeClass("v-hidden");
});

setTimeout(function() {
	var $iframe = $("#epg_iframe");
  var $dlg = $iframe.closest(".ui-dialog-content");
  $dlg.dialog("option", "width", Math.min(1100, $(window).width()));
  $dlg.dialog("option", "height", Math.min(850, $(window).height()-75));
  
  $iframe.bind('load', function() {
	  $("#epg_waiting").remove();
  });
  if (<%=!error%>)
    $("#epg_form").submit();
  else
	  $("#epg_error_form").submit();
}, 100);

</script>
