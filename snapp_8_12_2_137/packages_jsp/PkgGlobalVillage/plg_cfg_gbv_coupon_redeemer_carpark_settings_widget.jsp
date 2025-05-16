<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.snapp.lookup.LkSNDriverType"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% 
JvDocument settings = (JvDocument)request.getAttribute("settings");
%>

<v:widget caption="@Common.Settings">
  <v:widget-block>
    <v:form-field caption="Operation URL" hint="URL used for method \"setQrCodeCouponExternalBlacklistStatus\" " mandatory="true">
      <v:input-text field="settings.OperationURL"/>
    </v:form-field>
    <v:form-field caption="@Common.UserName" mandatory="true">
      <v:input-text field="settings.Username"/>
    </v:form-field>
    <v:form-field caption="@Common.Password" mandatory="true">
      <v:input-text field="settings.Password" type="password"/>
    </v:form-field>
  </v:widget-block>
</v:widget>


<script>

function getPluginSettings() {
  return {
	  OperationURL: $("#settings\\.OperationURL").val(),
	  Username: $("#settings\\.Username").val(),
	  Password: $("#settings\\.Password").val()
  };
}

</script>

