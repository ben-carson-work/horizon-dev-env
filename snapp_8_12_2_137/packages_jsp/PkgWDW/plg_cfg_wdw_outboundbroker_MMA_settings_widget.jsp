<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.JvDataSet"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget caption="MMA Settings">
  <v:widget-block>
    <v:form-field caption="Service URL">
      <v:input-text field="settings.MMA_URL"/>
    </v:form-field>
    <v:form-field caption="Destination name">
      <v:input-text field="settings.MMA_DestinationName"/>
    </v:form-field>
    <v:form-field caption="Source type">
      <v:input-text field="settings.MMA_SourceType"/>
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
    MMA_URL: $("#settings\\.MMA_URL").val(),
    MMA_DestinationName: $("#settings\\.MMA_DestinationName").val(),
    MMA_SourceType: $("#settings\\.MMA_SourceType").val(),
    AuthZ_URL: $("#settings\\.AuthZ_URL").val(),
    AuthZ_ClientId: $("#settings\\.AuthZ_ClientId").val(),
    AuthZ_ClientSecret: $("#settings\\.AuthZ_ClientSecret").val(),
    AuthZ_Scope: $("#settings\\.AuthZ_Scope").val()
	};
}
</script>