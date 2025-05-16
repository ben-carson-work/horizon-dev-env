<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
JvDocument settings = (JvDocument)request.getAttribute("settings");

%>
<v:widget caption="GAM">
  <v:widget-block>
    <v:form-field caption="GAM service URL" >
      <v:input-text field="settings.GAM_URL"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

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
    <v:form-field caption="Scope">
      <v:input-text field="settings.AuthZ_Scope"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
function getPluginSettings() {
  return {
	  GAM_URL: $("#settings\\.GAM_URL").val(),
	  AuthZ_URL: $("#settings\\.AuthZ_URL").val(),
    AuthZ_ClientId: $("#settings\\.AuthZ_ClientId").val(),
    AuthZ_ClientSecret: $("#settings\\.AuthZ_ClientSecret").val(),
    AuthZ_Scope: $("#settings\\.AuthZ_Scope").val()
	};
}
</script>