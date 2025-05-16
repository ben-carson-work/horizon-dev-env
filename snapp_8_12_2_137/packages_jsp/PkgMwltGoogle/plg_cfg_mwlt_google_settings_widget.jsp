<%@page import="com.vgs.web.library.BLBO_Resource"%>
<%@page import="com.vgs.web.library.BLBO_Repository"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>

<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>

<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>

<v:widget caption="Mobile wallet Google Settings">
	<v:widget-block>
	  <v:db-checkbox caption="Default Configuration" hint="When enabled uses VGS embedded settings.Unflag it to use custom provider settings." field="settings.UseDefaultConfiguration" enabled="true" value="true"/>
	  <div id="cfg-parameters-body">
			<v:form-field caption="Application name" hint = "Google application name implementing Pass API">
			  <v:input-text field="settings.ApplicationName"/>
			</v:form-field>
			<v:form-field caption="Service Account Email" hint = "Service account email address">
			  <v:input-text field="settings.ServiceAccountEmailAddress"/>
			</v:form-field>
		    <v:form-field caption="Service Credentials file" hint = "Drag & drop or select the Google .json file containing service access credentials.">
		      <v:input-upload-item field="settings.ServiceCredentialsFileBase64"/>
		    </v:form-field>            
			<v:form-field caption="Issuer Id" hint = "Issuer Id">
			  <v:input-text field="settings.IssuerId"/>
			</v:form-field>
		    <v:form-field caption="SmartTap Public Key" hint = "Drag & drop or select the .pem file containing NFC public key in EC not compressed format.">
		      <v:input-upload-item field="settings.SmartTapPublicKeyFileBase64"/>
		    </v:form-field>      						
	  </div>
  </v:widget-block>
</v:widget>

<script>

$(document).ready(function() {
   
  function refreshVisibility() {   
    var isChecked = $("#settings\\.UseDefaultConfiguration").isChecked();
    $("#cfg-parameters-body").setClass("v-hidden", isChecked);
    if (isChecked) {
      $("#cfg-parameters-body .form-field" ).attr("data-required", false);
      $("#cfg-parameters-body  .form-field-caption" ).removeClass("mandatory-field");
    }
    else {
      $("#cfg-parameters-body .form-field" ).attr("data-required", true);
      $("#cfg-parameters-body .form-field-caption" ).addClass("mandatory-field");
    }
  }
  
  refreshVisibility();
  clearCustomFieldsIfNeeded();
  
  $("#settings\\.UseDefaultConfiguration").click(refreshVisibility);
  
  function clearCustomFieldsIfNeeded() {
    //Avoid to show VGS default parameter
    var isChecked = $("#settings\\.UseDefaultConfiguration").isChecked();
    if (isChecked) {
      $("#settings\\.ApplicationName").val(null);
      $("#settings\\.ServiceAccountEmailAddress").val(null);
      $("#settings\\.ServiceCredentialsFileBase64").val(null);
      $("#settings\\.IssuerId").val(null);
      $("#settings\\.SmartTapPublicKeyFileBase64").valObject(null);
    }
  }
});


function getPluginSettings() {
  var ret;
  if ($("#settings\\.UseDefaultConfiguration").isChecked()) {
    ret = {
      UseDefaultConfiguration :  $("#settings\\.UseDefaultConfiguration").isChecked()
      } 
  } else {
    ret = {
	    UseDefaultConfiguration :  $("#settings\\.UseDefaultConfiguration").isChecked(),
	    ApplicationName : $("#settings\\.ApplicationName").val(),
	    ServiceAccountEmailAddress : $("#settings\\.ServiceAccountEmailAddress").val(),
	    IssuerId : $("#settings\\.IssuerId").val(),
	    ServiceCredentialsFileBase64 : $("#settings\\.ServiceCredentialsFileBase64").valObject(),
	    SmartTapPublicKeyFileBase64 : $("#settings\\.SmartTapPublicKeyFileBase64").valObject()
	    };
  }
  return ret;
}
</script>