<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>

<v:widget caption="Amazon AWS settings">
  <v:widget-block>
    <v:form-field caption="@PluginSettings.AmazonFR.ConnectionTimeout" hint="@PluginSettings.AmazonFR.ConnectionTimeoutHint">
      <v:input-text field="settings.ConnectionTimeout" placeholder="3000" type="number" step="500" min="0"/>
    </v:form-field>
    <v:form-field caption="@PluginSettings.AmazonFR.ReadTimeout" hint="@PluginSettings.AmazonFR.ReadTimeoutHint">
      <v:input-text field="settings.ReadTimeout" placeholder="10000" type="number" step="500" min="0"/>
    </v:form-field> 
    <v:form-field caption="@PluginSettings.AmazonFR.ClientId" hint = "@PluginSettings.AmazonFR.ClientIdHint" mandatory="true">
      <v:input-text field="settings.ClientId"/>
    </v:form-field>
    <v:form-field caption="@PluginSettings.AmazonFR.ClientSecret" hint = "@PluginSettings.AmazonFR.ClientSecretHint" mandatory="true">
      <v:input-text field="settings.ClientSecret" type="password"/>
    </v:form-field>
    <v:form-field caption="@PluginSettings.AmazonFR.CollectionName" hint = "@PluginSettings.AmazonFR.CollectionNameHint" mandatory="true">
      <v:input-text field="settings.CollectionName"/>
    </v:form-field>
    <v:form-field caption="@PluginSettings.AmazonFR.MinConfidenceValue" hint = "@PluginSettings.AmazonFR.MinConfidenceValueHint" >
      <v:input-text field="settings.MinConfidenceValue" placeholder="0.8" type="number" step="0.1" min="0" max ="1"/>
    </v:form-field>
    <v:form-field caption="@PluginSettings.AmazonFR.ConfidenceDelta" hint="@PluginSettings.AmazonFR.ConfidenceDeltaHint">
      <v:input-text field="settings.DeltaConfidenceValue" placeholder="0.2" type="number" step="0.1" min="0" max ="1"/>
    </v:form-field>  
  </v:widget-block>
</v:widget>

<script>
function getPluginSettings() {
  return {
	  ConnectionTimeout : $("#settings\\.ConnectionTimeout").val(),
	  ReadTimeout: $("#settings\\.ReadTimeout").val(),
	  ClientId      : $("#settings\\.ClientId").val(),
	  ClientSecret  : $("#settings\\.ClientSecret").val() ,
	  CollectionName : $("#settings\\.CollectionName").val(),
	  MinConfidenceValue : $("#settings\\.MinConfidenceValue").val(),
	  DeltaConfidenceValue : $("#settings\\.DeltaConfidenceValue").val()
  };
}
</script>