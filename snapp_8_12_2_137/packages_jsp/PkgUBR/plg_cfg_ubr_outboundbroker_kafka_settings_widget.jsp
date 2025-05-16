<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.JvDataSet"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget caption="Settings" icon="settings.png">
  <v:widget-block>
    <v:form-field caption="Service URL" hint="bootstrap.servers">
      <v:input-text field="settings.URL"/>
    </v:form-field>
    <v:form-field caption="Transaction Id">
      <v:input-text field="settings.TransactionId"/>
    </v:form-field>
    <v:form-field caption="Keystore location">
      <v:input-text field="settings.KeystoreLocation"/>
    </v:form-field>
    <v:form-field caption="Keystore password">
      <v:input-text field="settings.KeystorePassword" type="password"/>
    </v:form-field>
    <v:form-field caption="Truststore location">
      <v:input-text field="settings.TruststoreLocation"/>
    </v:form-field>
    <v:form-field caption="Truststore password">
      <v:input-text field="settings.TruststorePassword" type="password"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>

function getPluginSettings() {
  return {
    URL: $("#settings\\.URL").val(),
    TransactionId: $("#settings\\.TransactionId").val(),
    KeystoreLocation: $("#settings\\.KeystoreLocation").val(),
    KeystorePassword: $("#settings\\.KeystorePassword").val(),
    TruststoreLocation: $("#settings\\.TruststoreLocation").val(),
    TruststorePassword: $("#settings\\.TruststorePassword").val()
  };
}
</script>