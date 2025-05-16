<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@page import="com.vgs.cl.JvDataSet"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>

<%@page import="com.vgs.snapp.query.QryBO_OutboundMessage.*"%>

<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>

<v:widget id="video_capture-settings" caption="Settings">
  <v:widget-block>
    <v:form-field caption="Network camera" hint="@PluginSettings.VideoCapture.UseNetworkCameraHint" mandatory="true">
      <v:db-checkbox caption="" field="UseNetworkConfiguration" enabled="true" value="true"/>
    </v:form-field> 
    <div id="network_camera_section">  
	    <v:form-field caption="@PluginSettings.VideoCapture.RtspURL" hint="@PluginSettings.VideoCapture.RtspURLHint" mandatory="true">
	      <v:input-text field="URL"/>
	    </v:form-field>   
		</v:widget-block>
	</div> 
</v:widget>
<script>

$(document).ready(function() {

  function refreshVisibility() {	
    var isChecked = $("#UseNetworkConfiguration").isChecked();
    if (isChecked)
    	$("#network_camera_section").removeClass("v-hidden");
    else
    	$("#network_camera_section").addClass("v-hidden");
    
    _setMandatory($("#URL"), isChecked);
  }
  
  function _setMandatory(selector, mandatory) {
		$formFieldSel = selector.closest(".form-field")
		$formFieldCaptionSel = $formFieldSel.find(".form-field-caption")
  	if (mandatory) {
  		$formFieldSel.attr("data-required", true);
  		$formFieldCaptionSel.addClass("mandatory-field");  		
  	} else {
  		$formFieldSel.attr("data-required", false);
  		$formFieldCaptionSel.removeClass("mandatory-field");
  	}
  }
	  
  var $cfg = $("#video_capture-settings");
  
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.find("#UseNetworkConfiguration").prop('checked', (params.settings.UseNetworkConfiguration));
    $cfg.find("#URL").val(params.settings.URL);
    refreshVisibility();
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
    		UseNetworkConfiguration :$("#UseNetworkConfiguration").isChecked(),
      	URL: $("#URL").val()
    };
  });

  $("#UseNetworkConfiguration").click(refreshVisibility);
  refreshVisibility();

});


</script>