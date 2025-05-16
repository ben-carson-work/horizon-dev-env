<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.niecom.library.*"%>
<%@page import="com.vgs.snapp.niecom.plugin.*"%>
<%@page import="com.vgs.snapp.niecom.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>


<%
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");

boolean testMode = JvString.isSameString(pageBase.getParameter("TestMode"), "true");
String systemURL = pageBase.getParameter("SystemURL");
String requestParameter = pageBase.getParameter("RequestParameter");

String iFrameHeight = testMode ? "94%" : "99%";
%>

<style>
  #niecom_iframe {
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
</style>

<% if (testMode) { %>
  <div class="test-warn-box">*** TEST ENVIRONMENT ***</div>
<% } %>

<div id="ie-warn-box" class="test-warn-box v-hidden">If you are using an older version of Internet Explorer, please ensure that your cookies are enabled before proceeding with your payment</div>

<iframe id="niecom_iframe" name="niecom_iframe"></iframe>

<form id="niecom_form" method="post" target="niecom_iframe" action="<%=systemURL%>">
<input type="hidden" name="requestParameter" value="<%=requestParameter%>"/>
</form>

<script>
$(document).ready(function() {
  var ie = detectIE();
  if ((ie == 10) || (ie == 11))
    $("#ie-warn-box").removeClass("v-hidden");
});

setTimeout(function() {
	$("#niecom_iframe").contents().find("html").html("<body><div style='height:100px; background-repeat:no-repeat; background-position:center center; background-image:url(<v:config key="resources_url"/>/admin/images/new-spinner32.gif)'></div></body>");
  var dlg = $("#niecom_iframe").closest(".ui-dialog-content");
  dlg.dialog("option", "width", Math.min(1100, $(window).width()));
  dlg.dialog("option", "height", Math.min(850, $(window).height()-75));
  $("#niecom_form").submit();
}, 100);
</script>
