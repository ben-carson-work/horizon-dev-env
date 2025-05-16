<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.snapp.lookup.LkSNDriverType"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>

<%
JvDocument settings = (JvDocument)request.getAttribute("settings"); 
%>

<v:widget caption="@Common.Settings">
  <v:widget-block>
    <v:db-checkbox field="settings.debugMode" caption="Debug Mode" hint="This option will allow the user to login using the SnApp login also if MyID fails. It allows to validate the above settings avoiding the risk to let the system become inaccessible" value="true"/>   
    <v:form-field caption="MyID Server URL" mandatory="true">
      <v:input-text field="settings.serverURL"/>
    </v:form-field>
    <v:form-field caption="Logout URL">
      <v:input-text field="settings.logoutURL"/>
    </v:form-field>
    <v:form-field caption="Check health URL" mandatory="true">
      <v:input-text field="settings.checkHealthURL"/>
    </v:form-field>
    <v:form-field caption="Client ID" mandatory="true">
      <v:input-text field="settings.clientId"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
function getPluginSettings() {
  return {
    serverURL: $("#settings\\.serverURL").val(),
    logoutURL: $("#settings\\.logoutURL").val(),
    checkHealthURL: $("#settings\\.checkHealthURL").val(),
    clientId: $("#settings\\.clientId").val(),
    debugMode: $("#settings\\.debugMode").isChecked()
  };
}

</script>

