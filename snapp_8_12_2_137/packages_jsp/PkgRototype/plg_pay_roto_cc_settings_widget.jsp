<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget id="pay-roto-cc-settings" caption="@Common.Settings">
  <v:widget-block>
    <v:db-checkbox field="TestMode" caption="@Common.TestMode" hint="The credit card will be charged by a fix amount of 0.01" value="true"/>
  </v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
  var $cfg = $("#pay-roto-cc-settings");
	
	$(document).von($cfg, "plugin-settings-load", function(event, params) {
		  $cfg.find("#TestMode").prop('checked',params.settings.TestMode);
		});

		$(document).von($cfg, "plugin-settings-save", function(event, params) {
		  params.settings = {
				TestMode: $cfg.find("#TestMode").isChecked()
		  };
		});
});
</script>