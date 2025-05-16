<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>


<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>

<v:widget id="neoface-comparator-settings" caption="Settings">
  <v:widget-block>
    <v:form-field caption="Threshold High" hint="@PluginSettings.NeofaceComparator.ThresholdHighHint">
      <v:input-text field="ThresholdHigh" type="number" min ="0" max="100000" step="1000" placeholder="90000" />
    </v:form-field>
    <v:form-field caption="Threshold Medium" hint="@PluginSettings.NeofaceComparator.ThresholdMediumHint">
      <v:input-text field="ThresholdMedium" min ="0" max="100000" step="1000" placeholder="80000" />
    </v:form-field>
    <v:form-field caption="Threshold Low" hint="@PluginSettings.NeofaceComparator.ThresholdLowHint">
      <v:input-text field="ThresholdLow" type="number" min ="0" max="100000" step="1000" placeholder="65000" />
    </v:form-field> 
    <v:form-field caption="Eyes Roll" hint="@PluginSettings.NeofaceComparator.EyesRollHint">
      <v:input-text field="EyesRoll" type="number" min ="0" max="45" step="1" placeholder="15" />
    </v:form-field>
    <v:form-field caption="Eyes Max Width" hint="@PluginSettings.NeofaceComparator.EyesMaxWidthHint">
      <v:input-text field="EyesMaxWidth" type="number" min ="0" max="500" step="1" placeholder="240" />
    </v:form-field>    
    <v:form-field caption="Eyes Min Width" hint="@PluginSettings.NeofaceComparator.EyesMinWidthHint">
      <v:input-text field="EyesMinWidth" type="number" min ="0" max="500" step="1" placeholder="30" />
    </v:form-field> 
	</v:widget-block>
	<v:widget-block>
		<v:db-checkbox field="EnableImageLogging" caption="Image logging" hint="Flag it to enable extra debug log generation. When flagged plugin logs comparison score result of all comparition and the two compared images if comparition process failed" value="true"/>
	</v:widget-block>
</v:widget>
<script>

$(document).ready(function() {
    
	var $cfg = $("#neoface-comparator-settings");

	$(document).von($cfg, "plugin-settings-load", function(event, params) {
	  $cfg.find("#ThresholdHigh").val(params.settings.ThresholdHigh);
	  $cfg.find("#ThresholdMedium").val(params.settings.ThresholdMedium);  
	  $cfg.find("#ThresholdLow").val(params.settings.ThresholdLow);
	  $cfg.find("#EyesRoll").val(params.settings.EyesRoll);
	  $cfg.find("#EyesMaxWidth").val(params.settings.EyesMaxWidth);
	  $cfg.find("#EyesMinWidth").val(params.settings.EyesMinWidth);
	  $cfg.find("#EnableImageLogging").prop('checked', (params.settings.EnableImageLogging));
	});

	$(document).von($cfg, "plugin-settings-save", function(event, params) {
	  params.settings = {
	  		ThresholdHigh: $("#ThresholdHigh").val(),
	  		ThresholdMedium: $("#ThresholdMedium").val(),
	  		ThresholdLow: $("#ThresholdLow").val(),
	  		EyesRoll: $("#EyesRoll").val(),
	  		EyesMaxWidth: $("#EyesMaxWidth").val(),
	  		EyesMinWidth: $("#EyesMinWidth").val(),
	  		EnableImageLogging: $("#EnableImageLogging").isChecked()
	  };
	});
});


</script>