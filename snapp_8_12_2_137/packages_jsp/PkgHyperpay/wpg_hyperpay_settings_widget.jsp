<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
	JvDocument settings = (JvDocument)request.getAttribute("settings"); 
%>

<v:widget caption="@Common.Settings">
  <v:widget-block>
    <v:form-field caption="System URL" mandatory="true">
      <v:input-text type="text" field="settings.SystemURL" placeholder="https://oppwa.com"/>
    </v:form-field>
    <v:form-field caption="SnApp callback URL" hint="SnApp callback URL, usually the URL to use is the same as BKO (without /admin)" mandatory="true">
      <v:input-text type="text" field="settings.CallBackURL"/>
    </v:form-field>
    <v:form-field caption="Entity ID" mandatory="true">
      <v:input-text field="settings.EntityId" type="text"/>
    </v:form-field>
    <v:form-field caption="API Secret Key" mandatory="true">
      <v:input-text field="settings.APISecretKey" type="password"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
  	<v:form-field caption="Test env">
  		<v:db-checkbox field="settings.TestEnvironment"  caption="" value="true" hint="Flag only if configuration is pointing to Hyperpay test environment"/>
    </v:form-field>
  	<v:form-field caption="Empty card holder name">
	  	<v:db-checkbox field="settings.EmptyCardHolderName" caption="" value="true" hint="Determines whether the CardHolder field can be empty"/>
	  </v:form-field>
  	<%--<v:form-field caption="Display bic">
  		<v:db-checkbox field="settings.DisplayBic" caption="" value="true" hint="displayBic"/>
  	</v:form-field> --%>
  	<v:form-field caption="Card holder surname">
	  	<v:db-checkbox field="settings.BillingName" caption="" value="true" hint=" If this option is set to true then the form displays a field for the given name and a separate field for the surname."/>
		</v:form-field>
  	<v:form-field caption="Show billing address">
  		<v:db-checkbox field="settings.BillingAddress"  caption="" value="true" hint="Option to display the billing address fields."/>
  	</v:form-field>
  	<v:form-field caption="Show OneClick">
  		<v:db-checkbox field="settings.OneClick" caption="" value="true" hint="This parameter is used when we need to show OneClick widget. OneClick checkout widget will be shown if the flag is valued."/>
  	</v:form-field>
  	<v:form-field caption="Other payment">
  		<v:db-checkbox field="settings.HidePaymentButton" caption="" value="true" hint="This parameter is used when we need to hide \"show other payment methods\" button on OneClick checkout widget. This button on OneClick checkout widget will be hidden if the value of the parameter will be true"/>
  	</v:form-field>
  	<v:form-field caption="Mask cvv">
	  	<v:db-checkbox field="settings.MaskCvv" caption="" value="true" hint="Enable masking of cvv field"/>
	  </v:form-field>
  	<v:form-field caption="Show cvv hint">
	  	<v:db-checkbox field="settings.CvvHint" caption="" value="true" hint="When selected the credit card form will display a hint on where the CVV is located when the mouse is hovering over the CVV field."/>
	  </v:form-field>
  </v:widget-block>
</v:widget>

<script>

function getPluginSettings() {
  return {
	  SystemURL: $("#settings\\.SystemURL").val(),
	  CallBackURL: $("#settings\\.CallBackURL").val(),
	  EntityId: $("#settings\\.EntityId").val(),
	  APISecretKey: $("#settings\\.APISecretKey").val(),
	  TestEnvironment: $("#settings\\.TestEnvironment").isChecked(),
	  EmptyCardHolderName: $("#settings\\.EmptyCardHolderName").isChecked(),
	  DisplayBic: $("#settings\\.DisplayBic").isChecked(),
	  BillingName: $("#settings\\.BillingName").isChecked(),
	  BillingAddress: $("#settings\\.BillingAddress").isChecked(),
	  OneClick: $("#settings\\.OneClick").isChecked(),
	  HidePaymentButton: $("#settings\\.HidePaymentButton").isChecked(),
	  MaskCvv: $("#settings\\.MaskCvv").isChecked(),
	  CvvHint: $("#settings\\.CvvHint").isChecked()
	  
  };
}

</script>
