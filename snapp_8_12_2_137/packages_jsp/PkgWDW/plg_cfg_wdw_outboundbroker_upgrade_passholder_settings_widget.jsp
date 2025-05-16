<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.JvDataSet"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget caption="Service endpoint config">
  <v:widget-block>
    <v:form-field caption="Upgrade passholder service URL" >
      <v:input-text field="settings.UpgradePassholder_URL"/>
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
      <v:input-text type="password" field="settings.AuthZ_ClientSecret"/>
    </v:form-field>
    <v:form-field caption="AuthZ scope">
      <v:input-text field="settings.AuthZ_Scope"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>

function getPluginSettings() {
 
  return {
    UpgradePassholder_URL: $("#settings\\.UpgradePassholder_URL").val(),
    APMPPrivateKey: $("#settings\\.APMPPrivateKey").val(),
    AuthZ_URL: $("#settings\\.AuthZ_URL").val(),
    AuthZ_ClientId: $("#settings\\.AuthZ_ClientId").val(),
    AuthZ_ClientSecret: $("#settings\\.AuthZ_ClientSecret").val(),
    AuthZ_Scope: $("#settings\\.AuthZ_Scope").val()
	};
}
</script>