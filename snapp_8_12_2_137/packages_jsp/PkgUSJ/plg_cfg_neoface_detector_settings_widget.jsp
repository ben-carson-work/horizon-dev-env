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
    <v:form-field caption="Face detection Min Score" hint="@PluginSettings.NeofaceComparator.FaceDetectionMinScoreHint">
      <v:input-text field="FaceDetectionMinScore" type="number" min ="0" max="100000" step="1000" placeholder="97500" />
    </v:form-field>
    <v:form-field caption="Face detection timeout" hint="@PluginSettings.NeofaceComparator.FaceDetectionTimeoutHint">
      <v:input-text field="FaceDetectionTimeout" type="number" min ="0" max="10000" step="1000" placeholder="4000" />
    </v:form-field>
    <v:form-field caption="Eyes Roll" hint="@PluginSettings.NeofaceComparator.EyesRollHint">
      <v:input-text field="EyesRoll" type="number" min ="0" max="90" step="1" placeholder="15" />
    </v:form-field>
    <v:form-field caption="Eyes Max Width" hint="@PluginSettings.NeofaceComparator.EyesMaxWidthHint">
      <v:input-text field="EyesMaxWidth" type="number" min ="0" max="500" step="1" placeholder="240" />
    </v:form-field>    
    <v:form-field caption="Eyes Min Width" hint="@PluginSettings.NeofaceComparator.EyesMinWidthHint">
      <v:input-text field="EyesMinWidth" type="number" min ="0" max="500" step="1" placeholder="30" />    
    </v:form-field>         
	</v:widget-block> 
</v:widget>
<script>

$(document).ready(function() {
    
	var $cfg = $("#neoface-comparator-settings");

	$(document).von($cfg, "plugin-settings-load", function(event, params) {
	  $cfg.find("#FaceDetectionMinScore").val(params.settings.FaceDetectionMinScore);
	  $cfg.find("#FaceDetectionTimeout").val(params.settings.FaceDetectionTimeout);
	  $cfg.find("#EyesRoll").val(params.settings.EyesRoll);
	  $cfg.find("#EyesMaxWidth").val(params.settings.EyesMaxWidth);
	  $cfg.find("#EyesMinWidth").val(params.settings.EyesMinWidth);
	  
	});

	$(document).von($cfg, "plugin-settings-save", function(event, params) {
	  params.settings = {
	  		FaceDetectionMinScore: $("#FaceDetectionMinScore").val(),
	  		FaceDetectionTimeout: $("#FaceDetectionTimeout").val(),
	  		EyesRoll: $("#EyesRoll").val(),
	  		EyesMaxWidth: $("#EyesMaxWidth").val(),
	  		EyesMinWidth: $("#EyesMinWidth").val()
	  };
	});  
});


</script>