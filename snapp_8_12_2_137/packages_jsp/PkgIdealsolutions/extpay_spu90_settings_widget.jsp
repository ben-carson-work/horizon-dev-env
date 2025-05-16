<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>
<% 
JvDocument settings = (JvDocument)request.getAttribute("settings");
boolean avoidPrint = settings.getChildField("AvoidReceiptPrint").getBoolean();
%>

<v:widget caption="@Common.Settings" icon="settings.png">
  <v:widget-block>
    <v:form-field caption="@Common.Host">
    <v:input-text field="settings.Host"/>
    </v:form-field>
    <v:form-field caption="@Common.Port">
      <v:input-text field="settings.Port"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>    
    <v:db-checkbox field="settings.AvoidReceiptPrint" caption="@PluginSettings.AvoidReceiptPrint" value="true" checked="<%=avoidPrint%>" />
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="@Receipt.ReceiptWidth">
      <v:input-text field="settings.ReceiptWidth" placeholder="42"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>

function getPluginSettings() {
  return {
    Host: $("#settings\\.Host").val(),
    Port: $("#settings\\.Port").val(),
    AvoidReceiptPrint: $("#settings\\.AvoidReceiptPrint").isChecked(),
    ReceiptWidth: $("#settings\\.ReceiptWidth").val()
  };
}

</script> 