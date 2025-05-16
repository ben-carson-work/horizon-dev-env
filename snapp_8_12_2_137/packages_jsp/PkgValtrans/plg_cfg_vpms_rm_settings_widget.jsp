<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>

<v:widget caption="Connection settings">
  <v:widget-block>
    <v:form-field caption="Base URL" mandatory="true">
      <v:input-text field="settings.BaseURL"/>
    </v:form-field>
    <v:form-field caption="API Key" hint="Private API key provided by Valtrans" mandatory="true">
      <v:input-text field="settings.APIKey"/>
    </v:form-field>
    <v:form-field caption="API Secret" hint="Private API secret provided by Valtrans" mandatory="true">
      <v:input-text field="settings.APISecret" type="password"/>
    </v:form-field>
    <v:form-field caption="Connection timeout" hint="Connection timeout (milliseconds)">
      <v:input-text field="settings.ConnectionTimeout" placeholder="30000" />
    </v:form-field>
    <v:form-field caption="Read timeout" hint="Read timeout (milliseconds)">
      <v:input-text field="settings.ReadTimeout" placeholder="60000"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="Other settings">
  <v:widget-block>
    <v:form-field caption="Cache (seconds)" hint="Timeout (in seconds) between availability calls. If the same date is queried twice within this time frame, the plugin will use the cached value instead of calling the 3rd party API.">
      <v:input-text field="settings.CacheSecs" placeholder="30"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
function getPluginSettings() {
  return {
    BaseURL                : $("#settings\\.BaseURL").val(),
    APIKey                 : $("#settings\\.APIKey").val(),
    APISecret              : $("#settings\\.APISecret").val(),
    ConnectionTimeout      : $("#settings\\.ConnectionTimeout").val(),
    ReadTimeout            : $("#settings\\.ReadTimeout").val(),
    CacheSecs              : $("#settings\\.CacheSecs").val()
  };
}
</script>