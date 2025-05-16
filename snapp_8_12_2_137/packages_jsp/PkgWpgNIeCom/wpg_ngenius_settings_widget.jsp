<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
JvDocument settings = (JvDocument)request.getAttribute("settings"); 
boolean allowMultiCurrency = settings.getChildField("AllowMultiCurrency").getBoolean();
boolean submitBillingInfo = settings.getChildField("SubmitBillingInfo").getBoolean();
boolean allowSkip3DS = settings.getChildField("AllowSkip3DS").getBoolean();
boolean simulateNoResponse = settings.getChildField("SimulateNoResponse").getBoolean();
boolean oneAEDTokenPaymentAmount = settings.getChildField("OneAEDTokenPaymentAmount").getBoolean();

String hintDetails = "When flagged, SnApp will pass organization first name (FT1), last name (FT3) and email address (FT21) to Network International at payment time.";

String simulateNoResponseHint = 
"When checked, SnApp will set to NI a fake callback response</br>" +  
"page. Therefore NI callback, after payment, will fail causing</br>" +  
"order to remain open and SnApp believing no response was received.</br>" +
"WARN: The option is available for VgsSupport only and is effective</br>" +
"only when the system URL contains \"sanbox\"";  
%>

<v:widget caption="@Common.Settings">
  <v:widget-block>
    <v:form-field caption="System URL" mandatory="true">
      <v:input-text type="text" field="settings.SystemURL" placeholder="https://api-gateway.sandbox.ngenius-payments.com"/>
    </v:form-field>
    <v:form-field caption="API Key" mandatory="true">
      <v:input-text field="settings.APIKey" type="password"/>
    </v:form-field>
    <v:form-field caption="Outlet ID" mandatory="true">
      <v:input-text field="settings.OutletId"/>
    </v:form-field>
    <v:form-field caption="Realm name" mandatory="true">
      <v:input-text field="settings.RealmName"/>
    </v:form-field>
    <v:form-field caption="SnApp callback URL" hint="SnApp callback URL, usually the URL to use is the same as BKO (without /admin)" mandatory="true">
      <v:input-text type="text" field="settings.SnAppURL"/>
    </v:form-field>
    <v:form-field caption="Allow multi currency">
      <v:db-checkbox field="settings.AllowMultiCurrency" caption="" value="true" checked="<%=allowMultiCurrency%>" /><br/>
    </v:form-field>  
    <v:form-field caption="Submit payer's details" hint="<%=hintDetails%>">
      <v:db-checkbox field="settings.SubmitBillingInfo" caption="" value="true" checked="<%=submitBillingInfo%>" /><br/>
    </v:form-field>  
    <v:form-field caption="Allow skip 3DS on \"Pay by token\"">
      <v:db-checkbox field="settings.AllowSkip3DS" caption="" value="true" checked="<%=allowSkip3DS%>" /><br/>
    </v:form-field>
    <v:form-field caption="Payment token request of 1.00 AED" hint="When flagged a request of 1.00 AED will be submitted when asking for a card token, otherwise the request is for 0.00 AED">
      <v:db-checkbox field="settings.OneAEDTokenPaymentAmount" caption="" value="true" checked="<%=oneAEDTokenPaymentAmount%>" /><br/>
    </v:form-field>
    <% if (pageBase.getRights().VGSSupport.getBoolean()) { %>
    <v:form-field caption="Simulate no response">
      <v:db-checkbox field="settings.SimulateNoResponse" caption="" value="true" hint="<%=simulateNoResponseHint%>" checked="<%=simulateNoResponse%>" /><br/>
    </v:form-field>   
    <% } %>
  </v:widget-block>
</v:widget>

<script>

function getPluginSettings() {
  return {
  	SystemURL: $("#settings\\.SystemURL").val(),
    APIKey: $("#settings\\.APIKey").val(),
    OutletId: $("#settings\\.OutletId").val(),
    RealmName: $("#settings\\.RealmName").val(),
    SnAppURL: $("#settings\\.SnAppURL").val(),
    AllowMultiCurrency: $("#settings\\.AllowMultiCurrency").isChecked(),
    SubmitBillingInfo: $("#settings\\.SubmitBillingInfo").isChecked(),
    AllowSkip3DS: $("#settings\\.AllowSkip3DS").isChecked(),
    OneAEDTokenPaymentAmount: $("#settings\\.OneAEDTokenPaymentAmount").isChecked(),
    SimulateNoResponse: $("#settings\\.SimulateNoResponse").isChecked()
  };
}

</script>
