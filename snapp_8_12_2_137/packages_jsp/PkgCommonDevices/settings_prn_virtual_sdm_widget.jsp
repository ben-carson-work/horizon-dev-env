<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>
<jsp:useBean id="settings" class="com.vgs.entity.dataobject.DOPlgSettings_VirtualPrinter" scope="request"/>


<v:widget id="prn_sdm_virtual_settings" caption="@Common.Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
    <v:form-field caption="@Plugin.FailureRatio" hint="Emulates print failure based on a scale frequency: 0=never, 10=always">
      <v:input-text field="FailureRatio" type="number"/>
    </v:form-field>
    <v:form-field caption="@Plugin.SimulateMediaRead" hint="Emulates a printer with an rfid reader onboard">
      <v:db-checkbox field="SimulateMediaRead" caption="" value="true" />
    </v:form-field>
  </v:widget-block>
</v:widget>
 
<script>

$(document).ready(function() {
	  var $cfg = $("#prn_sdm_virtual_settings");
	  $(document).von($cfg, "plugin-settings-load", function(event, params) {
		$cfg.find("#FailureRatio").val(params.settings.FailureRatio);
	    $cfg.find("#SimulateMediaRead").prop('checked', (params.settings.SimulateMediaRead));
	  });
	  
	  $(document).von($cfg, "plugin-settings-save", function(event, params) {
	    params.settings = {
	    	FailureRatio :   $cfg.find("#FailureRatio").val(),
	    	SimulateMediaRead :   $cfg.find("#SimulateMediaRead").isChecked()
	    };
	  });
});

</script>
