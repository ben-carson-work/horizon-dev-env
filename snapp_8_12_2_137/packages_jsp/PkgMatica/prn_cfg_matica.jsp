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
    <v:form-field caption="@Common.Name">
      <v:input-text field="settings.PrinterName"/>
    </v:form-field>
    <v:form-field caption="@Common.DPI">
      <v:input-text field="settings.PrinterDPI"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="@Common.RFID">
      <v:db-checkbox field="settings.RFIDEnabled" caption="@Common.Enabled" value="true" />
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>

function getPluginSettings() {
  return {
    PrinterDPI: $("#settings\\.PrinterDPI").val(),
    PrinterName: $("#settings\\.PrinterName").val(),
    RFIDEnabled: $("#settings\\.RFIDEnabled").isChecked()
  };
}

</script>
