<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>

<div id="gantner-rest-server-reader-settings">

  <v:widget caption="@PluginSettings.Gantner.ServerSettings">

    <v:widget-block>
      <jsp:include page="doc-openapi.jspf"></jsp:include>
    </v:widget-block>

    <v:widget-block>
      <v:form-field caption="@PluginSettings.Gantner.ServerPort"
        hint="@PluginSettings.Gantner.ServerPortInHint" mandatory="true">
        <v:input-text field="settings.TcpIpPort" clazz="" type="number"/>
      </v:form-field>
      <v:form-field caption="Client ID"
        hint="@PluginSettings.Gantner.ClientIdHint" mandatory="true">
        <v:input-text field="settings.ClientId" />
      </v:form-field>
      <v:form-field caption="Client Key"
        hint="@PluginSettings.Gantner.ClientJwtKeyHint" mandatory="true">
        <v:input-text field="settings.ClientKey" type="password" />
      </v:form-field>
    </v:widget-block>
    
    <v:widget-block>
      <v:form-field caption="Gantner API key"
        hint="@PluginSettings.Gantner.GantnerApiKeyHint" mandatory="true">
        <v:input-text field="settings.GantnerApiKey" type="password" />
      </v:form-field>
      <v:form-field caption="Gantner endpoint URL"
        hint="@PluginSettings.Gantner.GantnerEndpointUrlHint" mandatory="true">
        <v:input-text field="settings.GantnerUrl" />
      </v:form-field>
    </v:widget-block>
  </v:widget>

</div>


<script>
$(document).ready(function() {
  var $cfg = $("#gantner-access-reader-settings");
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.find("#settings\\.ClientId").val(params.settings.ClientId);
    $cfg.find("#settings\\.ClientKey").val(params.settings.ClientKey);
    $cfg.find("#settings\\.TcpIpPort").val(params.settings.ReaderCode);
    $cfg.find("#settings\\.GantnerApiKey").val(params.settings.GantnerApiKey);
    $cfg.find("#settings\\.GantnerUrl").val(params.settings.GantnerUrl);
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
      ClientId: $("#settings\\.ClientId").val(),
      ClientKey: $("#settings\\.ClientKey").val(),
      TcpIpPort: $("#settings\\.TcpIpPort").val(),
      GantnerApiKey: $("#settings\\.GantnerApiKey").val(),
      GantnerUrl: $("#settings\\.GantnerUrl").val(),
    };
  });
});
</script>