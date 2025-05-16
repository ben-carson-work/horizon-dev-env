<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="java.util.Map.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<%
  JvDocument settings = (JvDocument)request.getAttribute("settings");
%>

  <v:widget caption="Settings" icon="settings.png">
    <v:widget-block>
      <v:form-field caption="@Common.URL" mandatory="true">
        <v:input-text field="settings.URL"/>
      </v:form-field>
      <v:form-field caption="Device Name" mandatory="true">
        <v:input-text field="settings.DeviceName"/>
      </v:form-field>
      <v:form-field caption="Enable authentication">
        <v:db-checkbox field="settings.AuthRequired" caption="@Common.Enabled" value="true"/>
      </v:form-field>
      <div  id="authentication" class="v-hidden">
        <v:form-field caption="Authentication URL">
          <v:input-text field="settings.AuthenticationUrl"/>
        </v:form-field>
        <v:form-field caption="Client id" >
          <v:input-text field="settings.ClientId"/>
        </v:form-field>
        <v:form-field caption="Client Secret">
          <v:input-text field="settings.ClientSecret"/>
        </v:form-field>
      </div>
    </v:widget-block>
  </v:widget>
  
 
<script>
$(document).ready(function() {
  enableDisbaleAuthorization();
});

$("#settings\\.AuthRequired").change(enableDisbaleAuthorization);

function enableDisbaleAuthorization() {
  var enabled = $("#settings\\.AuthRequired").isChecked();
  $("#authentication").setClass("v-hidden", !enabled); 
}
  function getPluginSettings() {
    return {
        URL: $("#settings\\.URL").val(),
        DeviceName: $("#settings\\.DeviceName").val(),
        AuthRequired: $("#settings\\.AuthRequired").isChecked(),
        ClientId: $("#settings\\.ClientId").val(),
        ClientSecret: $("#settings\\.ClientSecret").val(),
        AuthenticationUrl: $("#settings\\.AuthenticationUrl").val()  
    };
  }
</script>