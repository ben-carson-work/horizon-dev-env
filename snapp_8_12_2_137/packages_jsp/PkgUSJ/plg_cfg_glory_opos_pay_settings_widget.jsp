<%@page import="com.vgs.vcl.JvImageCache"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget id="pay-glory-opos-settings" caption="Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
		<v:form-field caption="@Common.Name" mandatory="true">
      <v:input-text field="DeviceName"/>
    </v:form-field>
    <v:form-field caption="Timeout" hint="Timeout for Glory machine operations(payment/returns) expressed in seconds, default values is 60 sec.">
			<v:input-text field="TransactionTimeout" type="number"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
  var $cfg = $("#pay-glory-opos-settings");
  
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.find("#DeviceName").val(params.settings.DeviceName);
    $cfg.find("#TransactionTimeout").val(params.settings.TransactionTimeout);
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
        DeviceName : 						$cfg.find("#DeviceName").val(),
        TransactionTimeout : 		$cfg.find("#TransactionTimeout").val()
      };
    });
  });
</script>