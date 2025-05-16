<%@page import="com.vgs.cl.document.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
JvDocument settings = (JvDocument)request.getAttribute("settings"); 
boolean submitBillingInfo = settings.getChildField("SubmitBillingInfo").getBoolean();
boolean allowSkip3DS = settings.getChildField("AllowSkip3DS").getBoolean();

String hintDetails = "When flagged, SnApp will pass organization first name (FT1), last name (FT3) and email address (FT21) to Checkout.com at payment time.";

%>

<v:widget caption="@Common.Settings">
  <v:widget-block>
    <v:form-field caption="System URL" mandatory="true">
      <v:input-text type="text" field="settings.SystemURL" placeholder="https://api.sandbox.checkout.com"/>
    </v:form-field>
    <v:form-field caption="SnApp callback URL" hint="SnApp callback URL, usually the URL to use is the same as BKO (without /admin)" mandatory="true">
      <v:input-text type="text" field="settings.SnAppURL"/>
    </v:form-field>
    <v:form-field caption="API Secret Key" mandatory="true">
      <v:input-text field="settings.APISecretKey" type="password"/>
    </v:form-field>
    <v:form-field caption="Submit payer's details" hint="<%=hintDetails%>">
      <v:db-checkbox field="settings.SubmitBillingInfo" caption="" value="true" checked="<%=submitBillingInfo%>" /><br/>
    </v:form-field>  
    <v:form-field caption="Allow skip 3DS">
      <v:db-checkbox field="settings.AllowSkip3DS" caption="" value="true" checked="<%=allowSkip3DS%>" /><br/>
    </v:form-field>
    
  </v:widget-block>
</v:widget>

<script>

function getPluginSettings() {
  return {
	  SystemURL: $("#settings\\.SystemURL").val(),
	  SnAppURL: $("#settings\\.SnAppURL").val(),
	  APISecretKey: $("#settings\\.APISecretKey").val(),
    SubmitBillingInfo: $("#settings\\.SubmitBillingInfo").isChecked(),
    AllowSkip3DS: $("#settings\\.AllowSkip3DS").isChecked()
  };
}

</script>
