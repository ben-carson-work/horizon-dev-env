<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<%
  PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");

  boolean testMode = JvString.isSameString(pageBase.getEmptyParameter("testmode"), "true");
  String checkoutConfig = pageBase.getNullParameter("config");
  String checkoutURL = pageBase.getNullParameter("checkouturl");
  String resourcesURL = pageBase.getNullParameter("resources_url");

  String paymentTabJsp = pageBase.getContextURL() + "?page=wpg_mpgs_payment";
%>


<form id="mpgs_payment_form" action="<%=paymentTabJsp%>" method="post" target="" name="mpgs_payment_form_name">
  <input type="hidden" name="testmode" value="<%= testMode ? "true" : "false" %>">
  <input type="hidden" name="config" value='<%=pageBase.getNullParameter("config")%>'>
  <input type="hidden" name="checkouturl" value='<%=pageBase.getNullParameter("checkouturl")%>'>
  <input type="hidden" name="resources_url" value="<%=pageBase.getNullParameter("resources_url")%>">
</form>


<script>
  $(document).ready(function() {
    if ($("#webpayment_dialog").length) {
      let paymentWindow = window.open('', 'mpgs_payment_form_name'); 
      document.mpgs_payment_form_name.target = 'mpgs_payment_form_name'; 
      document.mpgs_payment_form_name.submit();

      paymentWindow.onload = function() {
        $("#webpayment_dialog").dialog("close");
      };

      paymentWindow.onunload = function() {
        $("#webpayment_dialog").dialog("close");
      };
    } 
    else {
      document.mpgs_payment_form_name.submit();
    }
  });
</script>
