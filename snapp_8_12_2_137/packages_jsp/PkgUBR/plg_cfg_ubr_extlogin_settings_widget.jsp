<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>

<%
JvDocument settings = (JvDocument)request.getAttribute("settings");
%>

<v:widget caption="SSO Id login configuration">
  <v:widget-block>
    <v:form-field caption="SSO URL" mandatory="true">
      <v:input-text field="settings.SSO_URL" placeholder="Ex. http://127.0.0.1:8080"/>
    </v:form-field>
    <v:form-field caption="Client Id" mandatory="true">
      <v:input-text field="settings.ClientId_SSO"/>
    </v:form-field>
    <v:form-field caption="Client Secret" mandatory="true">
      <v:input-text field="settings.ClientSecret_SSO"/>
    </v:form-field>  
  </v:widget-block>
</v:widget>
<v:widget caption="Badge Id login configuration">
  <v:widget-block>
    <v:form-field caption="Badge URL" mandatory="true">
      <v:input-text field="settings.Badge_URL" placeholder="Ex. http://127.0.0.1:8080"/>
    </v:form-field>
    <v:form-field caption="Client Id" mandatory="true">
      <v:input-text field="settings.ClientId_Badge"/>
    </v:form-field>
    <v:form-field caption="Client Secret" mandatory="true">
      <v:input-text field="settings.ClientSecret_Badge"/>
    </v:form-field>  
  </v:widget-block>
</v:widget>

<script>


function getPluginSettings() {
  return {
    SSO_URL: $("#settings\\.SSO_URL").val(),
    ClientId_SSO: $("#settings\\.ClientId_SSO").val(),
    ClientSecret_SSO: $("#settings\\.ClientSecret_SSO").val(),
    Badge_URL: $("#settings\\.Badge_URL").val(),
    ClientId_Badge: $("#settings\\.ClientId_Badge").val(),
    ClientSecret_Badge: $("#settings\\.ClientSecret_Badge").val()
  };
}


</script>