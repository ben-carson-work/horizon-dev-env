<%@page import="com.vgs.cl.document.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
JvDocument settings = (JvDocument)request.getAttribute("settings");
%>

<v:widget caption="@Common.Settings">
  <v:widget-block>
    <v:form-field caption="WSDL URL" mandatory="true">
      <v:input-text field="settings.WSDLUrl" type="text"/>
    </v:form-field>
    <v:form-field caption="SnApp callback URL" hint="SnApp callback URL, usually the URL to use is the same as BKO (without /admin)" mandatory="true">
      <v:input-text field="settings.SnAppURL" type="text"/>
    </v:form-field>
    <v:form-field caption="TID" mandatory="true">
      <v:input-text field="settings.TID"/>
    </v:form-field>
    <v:form-field caption="kSig" mandatory="true">
      <v:input-text field="settings.KSig" type="password"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
function getPluginSettings() {
  let aa =  {
	  WSDLUrl: $("#settings\\.WSDLUrl").val(),
    SnAppURL: $("#settings\\.SnAppURL").val(),
    TID: $("#settings\\.TID").val(),
    KSig: $("#settings\\.KSig").val()
  };
  console.log(aa);
  return aa;
}
</script>
