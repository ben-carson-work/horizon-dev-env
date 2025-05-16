<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget caption="Salesforce settings">
  <v:widget-block>
    <v:form-field caption="Authorization URL" hint="Salesforce's URL to call in order to obtain the access token" mandatory="true">
      <v:input-text field="settings.AuthURL"/>
    </v:form-field>
    <v:form-field caption="Client Id" mandatory="true">
      <v:input-text field="settings.AuthClientId"/>
    </v:form-field>
    <v:form-field caption="Client secret" mandatory="true">
      <v:input-text field="settings.AuthClientSecret" type="password"/>
    </v:form-field>
    <v:form-field caption="Username" mandatory="true">
      <v:input-text field="settings.AuthUsername"/>
    </v:form-field>
    <v:form-field caption="Password" mandatory="true">
      <v:input-text field="settings.AuthPassword" type="password"/>
    </v:form-field>
    <v:form-field caption="Event URL suffix" hint="Suffix for the Salesforce's URL to which the message will be sent" mandatory="true">
      <v:input-text field="settings.EventURLSuffix"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="Broker settings">
  <v:widget-block>
    <v:form-field caption="Message timeout" 
        hint="Maximum minutes from the scan time during which the outbound message can be sent" >
      <v:input-text field="settings.MessageTimeout" type="number" step="1" placeholder="Never expires"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>

function getPluginSettings() {
 
  return {
    AuthURL: $("#settings\\.AuthURL").val(),
    AuthClientId: $("#settings\\.AuthClientId").val(),
    AuthClientSecret: $("#settings\\.AuthClientSecret").val(),
    AuthUsername: $("#settings\\.AuthUsername").val(),
    AuthPassword: $("#settings\\.AuthPassword").val(),
    EventURLSuffix: $("#settings\\.EventURLSuffix").val(),
    MessageTimeout: $("#settings\\.MessageTimeout").val(),
  };
}
</script>