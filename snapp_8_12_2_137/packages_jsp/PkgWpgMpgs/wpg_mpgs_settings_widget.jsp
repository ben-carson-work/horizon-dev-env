<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget caption="@Common.Settings">
  <v:widget-block>
    <v:form-field caption="MPGS Base URL">
      <v:input-text field="settings.BaseURL" placeholder="https://ap-gateway.mastercard.com/api/rest/version/60/merchant/"/>
    </v:form-field>
    <v:form-field caption="MPGS Checkout URL">
      <v:input-text field="settings.CheckoutURL" placeholder="https://ap-gateway.mastercard.com/checkout/version/60/"/>
    </v:form-field>
    <v:form-field caption="SnApp callback URL" hint="SnApp callback URL, usually the URL to use is the same as BKO (without /admin)" mandatory="true">
      <v:input-text type="text" field="settings.SnAppURL"/>
    </v:form-field>
    <v:form-field caption="Merchant Id" mandatory="true">
      <v:input-text field="settings.MerchantId"/>
    </v:form-field>
    <v:form-field caption="Merchant secret" mandatory="true">
      <v:input-text field="settings.MerchantSecret" type="password"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
function getPluginSettings() {
  return {
	  BaseURL: $("#settings\\.BaseURL").val(),
	  CheckoutURL: $("#settings\\.CheckoutURL").val(),
	  SnAppURL: $("#settings\\.SnAppURL").val(),
	  MerchantId: $("#settings\\.MerchantId").val(),
	  MerchantSecret: $("#settings\\.MerchantSecret").val()
  };
}
</script>
