<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% 
  JvDocument settings = (JvDocument)request.getAttribute("settings"); 
%>

<v:widget caption="Google Settings">
  <v:widget-block>
    <v:form-field caption="Client id" mandatory="true">
      <v:input-text field="settings.ClientId"/>
    </v:form-field>
    <v:form-field caption="Client secret" mandatory="true">
      <v:input-text field="settings.ClientSecret" type="password"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>

function getPluginSettings() {
	  return {
	      ClientId: $("#settings\\.ClientId").val(),
	      ClientSecret: $("#settings\\.ClientSecret").val()
	  };
	}

</script>
