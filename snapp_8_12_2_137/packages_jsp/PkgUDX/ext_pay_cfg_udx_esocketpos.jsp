<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>
<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>

<v:widget caption="@Common.Settings" icon="settings.png">
  <v:widget-block>
    <v:form-field caption="@Common.TerminalId">
    <v:input-text field="settings.TerminalId"/>
    </v:form-field>
    <v:form-field caption="@PluginSettings.Gantner.ServerIP">
      <v:input-text field="settings.ServerURL"/>
    </v:form-field>
    <v:form-field caption="@Common.ServerPort">
      <v:input-text field="settings.ServerPort"/>
    </v:form-field>
    <v:form-field caption="@Auth.RequestTimeoutSec">
      <v:input-text field="settings.ReqTimeout" placeholder="90"/>
    </v:form-field>
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
    TerminalId: $("#settings\\.TerminalId").val(),
    ServerURL: $("#settings\\.ServerURL").val(),
    ServerPort: $("#settings\\.ServerPort").val(),
    ReqTimeout: $("#settings\\.ReqTimeout").val(),
    ReceiptWidth: $("#settings\\.ReceiptWidth").val()
  };
}

</script>

