<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>

<v:widget id="ext_pay_sdm_virtual_settings" caption="@Common.Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
    <v:form-field caption="Failure threshold amount" hint="An amount less than this value will be authorized.<br>Equal to this value will throw an exception.<br>Greater than this value will be denied.">
      <v:input-text field="FailureThresholdAmount" type="number" step="any" placeholder="200"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
	  var $cfg = $("#ext_pay_sdm_virtual_settings");
	  $(document).von($cfg, "plugin-settings-load", function(event, params) {
	    $cfg.find("#FailureThresholdAmount").val(params.settings.FailureThresholdAmount);
	  });
	  
	  $(document).von($cfg, "plugin-settings-save", function(event, params) {
	    params.settings = {
	    	FailureThresholdAmount :   $cfg.find("#FailureThresholdAmount").val()
	    };
	  });
});
</script>
