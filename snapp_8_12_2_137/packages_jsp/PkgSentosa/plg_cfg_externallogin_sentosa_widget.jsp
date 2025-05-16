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
    <v:form-field caption="URL" mandatory="true">
      <v:input-text field="settings.serverURL"/>
    </v:form-field>
    <v:form-field caption="@Common.UserName" mandatory="true">
      <v:input-text field="settings.userName"/>
    </v:form-field>
    <v:form-field caption="@Common.Password" mandatory="true">
      <v:input-text type="password" field="settings.password"/>
    </v:form-field>
  </v:widget-block>
</v:widget>
  
<script>
function getPluginSettings() {
  return {
    serverURL: $("#settings\\.serverURL").val(),
    userName: $("#settings\\.userName").val(),
    password: $("#settings\\.password").val(),
  };
}

</script>
