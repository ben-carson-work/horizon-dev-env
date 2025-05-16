<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.snapp.lookup.LkSNDriverType"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>

<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>

<v:widget caption="@Common.Settings">
  <v:widget-block>
    <v:form-field caption="Carpark service URL" mandatory="true">
      <v:input-text field="settings.CarparkURL"/>
    </v:form-field>
    <v:form-field caption="@Common.UserName" mandatory="true">
      <v:input-text field="settings.Username"/>
    </v:form-field>
    <v:form-field caption="@Common.Password" mandatory="true">
      <v:input-text field="settings.Password" type="password"/>
    </v:form-field>
    <v:form-field caption="@Common.TerminalId" mandatory="true">
      <v:input-text field="settings.TerminalId"/>
    </v:form-field>
  </v:widget-block>
</v:widget>


<script>

function getPluginSettings() {
  return {
	  CarparkURL: $("#settings\\.CarparkURL").val(),
	  Username: $("#settings\\.Username").val(),
	  Password: $("#settings\\.Password").val(),
	  TerminalId: $("#settings\\.TerminalId").val()
  };
}

</script>

