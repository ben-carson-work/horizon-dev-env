<%@page import="com.vgs.vcl.JvImageCache"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.LkSN"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget id="print-toshiba-ba410tt-settings" caption="Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
  	<v:form-field caption="USB" hint="Select to use USB connection"  mandatory="true">
    	<v:db-checkbox field="UseUSB" caption="" value="true"/>
    </v:form-field>  
    <div id="network-parameters-body">
	  	<v:form-field caption="IP address" hint="This property is used to set printer remote IP address" mandatory="true">
	      <v:input-text field="IPAddress" placeholder="10.1.0.191:9100" />
	    </v:form-field>
    </div>
    <v:form-field caption="Language" hint="This property is used to specify and obtain a display language."  mandatory="true">
      <select id="Language" class="form-control">
				<option value=0>Japanese</option>
				<option value=1>English</option>
			</select>
    </v:form-field>
		<v:form-field caption="Code Page" hint="This property is used to specify and obtain a code page to use when outputting data to the printer."  mandatory="true">
      <select id="CodePage" class="form-control">
				<option value=0>Default</option>
				<option value=1>UTF-8</option>
			  <option value=2>PC-1252</option>
			</select>      
    </v:form-field>
		<v:form-field caption="Encoding" hint="This property is used to specify and obtain the encoding used to read character strings from a data file."  mandatory="true">
      <select id="Encoding" class="form-control">
				<option value=0>Default</option>
				<option value=1>UTF-8</option>
			  <option value=2>Windows-1252</option>
			</select>      
    </v:form-field>    
  </v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
  var $cfg = $("#print-toshiba-ba410tt-settings");
  $("#UseUSB").click(refreshVisibility);
  
  function refreshVisibility() {	
    var isChecked = $("#UseUSB").isChecked();
    if (isChecked)
    	$("#network-parameters-body").addClass("v-hidden");
    else
    	$("#network-parameters-body").removeClass("v-hidden");
    
    _setMandatory($("#IPAddress"), !isChecked);
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
  
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.find("#UseUSB").prop('checked', (params.settings.UseUSB));
    $cfg.find("#IPAddress").val(params.settings.IPAddress);
    $cfg.find("#Language").val(params.settings.Language);
    $cfg.find("#CodePage").val(params.settings.CodePage);
    $cfg.find("#Encoding").val(params.settings.Encoding);
    refreshVisibility();
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
    		UseUSB 		:				$("#UseUSB").isChecked(),
    		IPAddress :     	$cfg.find("#IPAddress").val(),
    		Language : 			  $cfg.find("#Language").val(),
    		CodePage : 			  $cfg.find("#CodePage").val(),
    		Encoding:    			$cfg.find("#Encoding").val()
      };
    });
  
  refreshVisibility();
});
</script>