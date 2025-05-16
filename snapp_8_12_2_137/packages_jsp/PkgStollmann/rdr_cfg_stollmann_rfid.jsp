<%@page import="com.vgs.snapp.lookup.LkSN"%>
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
  <v:widget-block id="interface-type-combo">
    <v:form-field caption="@PluginSettings.Stollmann.ReaderType">
      <v:input-text field="settings.ReaderType"/>
    </v:form-field>
    <v:form-field caption="@Common.Type">
      <select id="settings.InterfaceType" class="form-control">
        <option value="SERIAL">Serial</option>
      </select>        
    </v:form-field>
    <v:form-field caption="@Common.PortName">
      <select id="settings.PortName" class="form-control">
      <% for (LookupItem comPort : LkSN.ComPort.getItems()) { %>
        <% String com = comPort.getDescription(); %>
        <% String sel = JvString.isSameText(com, settings.getChildField("PortName").getString()) ? "selected" : ""; %>
        <option value="<%=com%>" <%=sel%>><%=com%></option>
      <% } %>
      </select>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="@PluginSettings.FeigRfid.ReadData">
      <v:db-checkbox field="settings.ReadData" caption="@Common.Enabled" value="true"/>
    </v:form-field>
    <v:form-field id="data-read-first-db" caption="@PluginSettings.FeigRfid.FirstDataBlock">
      <v:input-text field="settings.FirstDataBlock"/>
    </v:form-field>
    <v:form-field id="data-read-num-of-bytes" caption="@PluginSettings.FeigRfid.NumberOfBytes">
      <v:input-text field="settings.NumberOfBytes"/>
    </v:form-field>
  </v:widget-block>
</v:widget>
<script>

$(document).ready(function() {
  enableDisableDataRead();
});

$("#settings\\.ReadData").change(enableDisableDataRead);

function getPluginSettings() {
  return {
    InterfaceType: $("#settings\\.InterfaceType").val(),
    PortName: $("#settings\\.PortName").val(),
    ReadData: $("#settings\\.ReadData").isChecked(),
    ReaderType: $("#settings\\.ReaderType").val(),
    FirstDataBlock: $("#settings\\.FirstDataBlock").val(),
    NumberOfBytes: $("#settings\\.NumberOfBytes").val()
  };
}

function enableDisableDataRead() {
  var enabled = $("#settings\\.ReadData").isChecked();
    $("#data-read-first-db").setClass("v-hidden", !enabled); 
    $("#data-read-num-of-bytes").setClass("v-hidden", !enabled); 
}

</script>
