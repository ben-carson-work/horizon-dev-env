<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>


<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>

<v:widget id="hrz-face-comparator-settings" caption="Settings">
  <v:widget-block>
    <v:form-field caption="@PluginSettings.VGSFREngine.BaseURL" hint="@PluginSettings.VGSFREngine.BaseURLHint" mandatory="true">
      <v:input-text field="SericeURL"/>
    </v:form-field>
    <v:form-field caption="@PluginSettings.VGSFREngine.ConnectionTimeout" hint="@PluginSettings.VGSFREngine.ConnectionTimeoutHint">
      <v:input-text field="ConnectionTimeout" placeholder="3000" type="number" step="500" min="0"/>
    </v:form-field>
    <v:form-field caption="@PluginSettings.VGSFREngine.ReadTimeout" hint="@PluginSettings.VGSFREngine.ReadTimeoutHint">
      <v:input-text field="ReadTimeout" placeholder="10000" type="number" step="500" min="0"/>
    </v:form-field>    
    <v:form-field caption="@PluginSettings.VGSFREngine.ClientId" hint="@PluginSettings.VGSFREngine.ClientIdHint" mandatory="true">
      <v:input-text field="ClientId"/>
    </v:form-field>    
    <v:form-field caption="@PluginSettings.VGSFREngine.ApiKey" hint = "@PluginSettings.VGSFREngine.ApiKeyHint" mandatory="true">
      <v:input-text field="ApiKey" type="password"/>
    </v:form-field>    
    <v:form-field caption="Threshold High" hint="@PluginSettings.HrzFaceComparator.ThresholdHighHint">
      <v:input-text field="ThresholdHigh" type="number" min ="0" max="10000" step="100" placeholder="7000" />
    </v:form-field>
    <v:form-field caption="Threshold Medium" hint="@PluginSettings.HrzFaceComparator.ThresholdMediumHint">
      <v:input-text field="ThresholdMedium" type="number" min ="0" max="10000" step="100" placeholder="9000" />
    </v:form-field>
    <v:form-field caption="Threshold Low" hint="@PluginSettings.HrzFaceComparator.ThresholdLowHint">
      <v:input-text field="ThresholdLow" type="number" min ="0" max="10000" step="100" placeholder="10000" />
    </v:form-field>   
	</v:widget-block> 
</v:widget>
<script>
var $cfg = $("#hrz-face-comparator-settings");

$(document).von($cfg, "plugin-settings-load", function(event, params) {
  $cfg.find("#SericeURL").val(params.settings.SericeURL);
  $cfg.find("#ConnectionTimeout").val(params.settings.ConnectionTimeout);
  $cfg.find("#ReadTimeout").val(params.settings.ReadTimeout);
  $cfg.find("#ClientId").val(params.settings.ClientId);
  $cfg.find("#ApiKey").val(params.settings.ApiKey);  
  $cfg.find("#ThresholdHigh").val(params.settings.ThresholdHigh);
  $cfg.find("#ThresholdMedium").val(params.settings.ThresholdMedium);  
  $cfg.find("#ThresholdLow").val(params.settings.ThresholdLow);
});

$(document).von($cfg, "plugin-settings-save", function(event, params) {
  params.settings = {
  		SericeURL:	$("#SericeURL").val(),
  		ConnectionTimeout: $("#ConnectionTimeout").val(), 
  		ReadTimeout: $("#ReadTimeout").val(),
  		ClientId: $("#ClientId").val(), 
  		ApiKey: $("#ApiKey").val(), 
  		ThresholdHigh: $("#ThresholdHigh").val(),
  		ThresholdMedium: $("#ThresholdMedium").val(),
  		ThresholdLow: $("#ThresholdLow").val()
  };
});
</script>