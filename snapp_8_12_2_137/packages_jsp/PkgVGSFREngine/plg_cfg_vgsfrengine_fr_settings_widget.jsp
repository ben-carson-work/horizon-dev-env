<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>

<v:widget caption="VGSFREngine settings">
  <v:widget-block>
    <v:form-field caption="@PluginSettings.VGSFREngine.BaseURL" hint="@PluginSettings.VGSFREngine.BaseURLHint" mandatory="true">
      <v:input-text field="settings.BaseURL"/>
    </v:form-field>
    <v:form-field caption="@PluginSettings.VGSFREngine.ConnectionTimeout" hint="@PluginSettings.VGSFREngine.ConnectionTimeoutHint">
      <v:input-text field="settings.ConnectionTimeout" placeholder="3000" type="number" step="500" min="0"/>
    </v:form-field>
    <v:form-field caption="@PluginSettings.VGSFREngine.ReadTimeout" hint="@PluginSettings.VGSFREngine.ReadTimeoutHint">
      <v:input-text field="settings.ReadTimeout" placeholder="10000" type="number" step="500" min="0"/>
    </v:form-field>    
    <v:form-field caption="@PluginSettings.VGSFREngine.ClientId" hint="@PluginSettings.VGSFREngine.ClientIdHint" mandatory="true">
      <v:input-text field="settings.ClientId"/>
    </v:form-field>    
    <v:form-field caption="@PluginSettings.VGSFREngine.ApiKey" hint = "@PluginSettings.VGSFREngine.ApiKeyHint" mandatory="true">
      <v:input-text field="settings.ApiKey"/>
    </v:form-field>
    <v:form-field caption="@PluginSettings.VGSFREngine.CollectionName" hint = "@PluginSettings.VGSFREngine.CollectionNameHint" mandatory="true">
      <v:input-text field="settings.CollectionName"/>
    </v:form-field>
    <v:form-field caption="@PluginSettings.VGSFREngine.MaxScore" hint="@PluginSettings.VGSFREngine.MaxScoreHint">
      <v:input-text field="settings.MaxScore" placeholder="100000" type="number" step="10000" min="0"/>
    </v:form-field>
    <v:form-field caption="@PluginSettings.VGSFREngine.ConfidenceDelta" hint="@PluginSettings.VGSFREngine.ConfidenceDeltaHint">
      <v:input-text field="settings.DeltaConfidenceValue" placeholder="10000" type="number" step="1000" min="0"/>
    </v:form-field>    
    <v:form-field caption="@PluginSettings.VGSFREngine.MaxResults" hint="@PluginSettings.VGSFREngine.MaxResultsHint">
      <v:input-text field="settings.MaxResults" placeholder="2" type="number" step="1" min="1"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
function getPluginSettings() {
  return {
	  BaseURL  	: $("#settings\\.BaseURL").val(),
	  ConnectionTimeout : $("#settings\\.ConnectionTimeout").val(),
	  ReadTimeout: $("#settings\\.ReadTimeout").val(),
	  ClientId : $("#settings\\.ClientId").val(),
	  ApiKey  : $("#settings\\.ApiKey").val(),
	  CollectionName  : $("#settings\\.CollectionName").val(),
	  MaxScore : $("#settings\\.MaxScore").val(),
	  DeltaConfidenceValue : $("#settings\\.DeltaConfidenceValue").val(),
	  MaxResults : $("#settings\\.MaxResults").val()
  };
}
</script>