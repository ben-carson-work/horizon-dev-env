<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>

<v:widget id="clamav_settings" caption="Plugin settings">
  <v:widget-block>
    <v:form-field caption="Antivirus Server URL">
      <v:input-text field="AntivirusServerURL" placeholder="ie: tcp://localhost:3310" />
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
  var $cfg = $("#clamav_settings");
  
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.find("#AntivirusServerURL").val(params.settings.AntivirusServerURL);
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
    	AntivirusServerURL: $cfg.find("#AntivirusServerURL").val()
    };
  });

});
</script>