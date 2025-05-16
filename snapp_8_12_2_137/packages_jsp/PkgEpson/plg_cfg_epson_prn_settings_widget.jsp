<%@page import="com.vgs.vcl.JvImageCache"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget id="prn-epson-opos-settings" caption="Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
		<v:form-field caption="@Common.Name" mandatory="true">
      <v:input-text field="DeviceName"/>
    </v:form-field>
    <v:form-field caption="@Common.Chinese" mandatory="true">
			<v:db-checkbox field="Chinese" caption="" value="true"/>
    </v:form-field>
    <v:form-field caption="Private" mandatory="true">
			<v:db-checkbox field="Private" caption="" hint="This flag will prevent the printer to be shared and used on the network like generally done with kitchen printer" value="true"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
  var $cfg = $("#prn-epson-opos-settings");
  
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.find("#DeviceName").val(params.settings.DeviceName);
    $cfg.find("#Chinese").prop('checked',params.settings.Chinese);
    $cfg.find("#Private").prop('checked',params.settings.Private);
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
        DeviceName : 		$cfg.find("#DeviceName").val(),
        Chinese : 			$cfg.find("#Chinese").isChecked(),
        Private : 			$cfg.find("#Private").isChecked()
      };
    });
  });
</script>