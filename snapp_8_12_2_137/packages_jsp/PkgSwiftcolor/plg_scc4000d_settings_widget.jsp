<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<%
  JvDocument settings = (JvDocument)request.getAttribute("settings");
%>

<v:widget caption="Settings" icon="settings.png">
  <v:widget-block>
    <v:form-field caption="Printer name" mandatory="true">
      <v:input-text field="settings.PrinterName"/>
    </v:form-field>
    <v:form-field caption="Port name" mandatory="true">
      <v:input-text field="settings.PortName"/>
    </v:form-field>
    <v:form-field caption="@Common.DPI" hint="300 is the dafault value if parameter below is not setted">
      <v:input-text field="settings.PrinterDPI" placeholder="300"/>
    </v:form-field>
  </v:widget-block>
</v:widget>
<script>

function getPluginSettings() {
  return {
		PrinterName: $("#settings\\.PrinterName").val(),
    PortName: $("#settings\\.PortName").val(),
    PrinterDPI: $("#settings\\.PrinterDPI").val()
  };
}

</script>