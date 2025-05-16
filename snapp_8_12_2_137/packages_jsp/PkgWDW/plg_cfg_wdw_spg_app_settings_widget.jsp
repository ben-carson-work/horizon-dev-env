<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>

<v:widget caption="AuthZ settings">
  <v:widget-block>
    <v:form-field caption="AuthZ service URL" >
      <v:input-text field="settings.AuthZ_URL"/>
    </v:form-field>
    <v:form-field caption="Client Id">
      <v:input-text field="settings.AuthZ_ClientId"/>
    </v:form-field>
    <v:form-field caption="Client secret">
      <v:input-text field="settings.AuthZ_ClientSecret" type="password"/>
    </v:form-field>
    <v:form-field caption="AuthZ scope">
      <v:input-text field="settings.AuthZ_Scope"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="APP">
  <v:widget-block>
    <v:form-field caption="URL" >
      <v:input-text field="settings.APP_URL"/>
    </v:form-field>
    <v:form-field caption="Client Id">
      <v:input-text field="settings.APP_ClientId"/>
    </v:form-field>
    <v:form-field caption="Client Cert Alias">
      <v:input-text field="settings.APP_ClientCertAlias"/>
    </v:form-field>
    <v:form-field caption="Private key" >
      <v:input-txtarea field="settings.APP_PrivateKey" rows="10"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
function getPluginSettings() {
  return {
    AuthZ_URL: $("#settings\\.AuthZ_URL").val(),
    AuthZ_ClientId: $("#settings\\.AuthZ_ClientId").val(),
    AuthZ_ClientSecret: $("#settings\\.AuthZ_ClientSecret").val(),
    AuthZ_Scope: $("#settings\\.AuthZ_Scope").val(),
    APP_URL: $("#settings\\.APP_URL").val(),
    APP_ClientId: $("#settings\\.APP_ClientId").val(),
    APP_ClientCertAlias: $("#settings\\.APP_ClientCertAlias").val(),
    APP_PrivateKey: $("#settings\\.APP_PrivateKey").val()
  };
}
</script>