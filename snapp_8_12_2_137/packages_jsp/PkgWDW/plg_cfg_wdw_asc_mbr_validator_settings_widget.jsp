<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>

<v:widget caption="AuthZ settings">
  <v:widget-block>
    <v:form-field caption="AuthZ service URL" mandatory="true">
      <v:input-text field="settings.AuthZ_URL"/>
    </v:form-field>
    <v:form-field caption="Client Id" mandatory="true">
      <v:input-text field="settings.AuthZ_ClientId"/>
    </v:form-field>
    <v:form-field caption="Client secret" mandatory="true">
      <v:input-text field="settings.AuthZ_ClientSecret" type="password"/>
    </v:form-field>
    <v:form-field caption="Scope" mandatory="true">
      <v:input-text field="settings.AuthZ_Scope"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="DVC URL">
  <v:widget-block>
    <v:form-field caption="DVC Connection" >
      <v:input-text field="settings.DVC_URL"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="Metafields mapping">
  <v:widget-block>
    <v:form-field caption="DVC Membership number" >
      <v:input-text field="settings.DVCMembershipNumber" placeholder="Metafield code"/>
    </v:form-field>
    <v:form-field caption="DVC Member ID" >
      <v:input-text field="settings.DVCMemberId" placeholder="Metafield code"/>
    </v:form-field>
    <v:form-field caption="FirstName">
      <v:input-text field="settings.FirstName" placeholder="Metafield code"/>
    </v:form-field>
    <v:form-field caption="Last name">
      <v:input-text field="settings.LastName" placeholder="Metafield code"/>
    </v:form-field>
  </v:widget-block>
</v:widget>
<script>

function getPluginSettings() {
  return {
	  AuthZ_URL           : $("#settings\\.AuthZ_URL").val(),
	  AuthZ_ClientId      : $("#settings\\.AuthZ_ClientId").val(),
	  AuthZ_ClientSecret  : $("#settings\\.AuthZ_ClientSecret").val(),
	  AuthZ_Scope         : $("#settings\\.AuthZ_Scope").val(),
	  DVC_URL             : $("#settings\\.DVC_URL").val(),  
      DVCMembershipNumber : $("#settings\\.DVCMembershipNumber").val(),
      DVCMemberId         : $("#settings\\.DVCMemberId").val(),          
      FirstName           : $("#settings\\.FirstName").val(),         
      LastName            : $("#settings\\.LastName").val(),          
  };
}
</script>