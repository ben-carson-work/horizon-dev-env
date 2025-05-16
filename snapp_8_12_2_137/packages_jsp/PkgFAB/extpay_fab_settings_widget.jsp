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
<%
boolean checkedVoid = settings.getChildField("PrintReceiptForVoid").isUndefined() || settings.getChildField("PrintReceiptForVoid").isNull() || settings.getChildField("PrintReceiptForVoid").getBoolean();
boolean avoidPrint = settings.getChildField("AvoidReceiptPrint").getBoolean();

%>

<v:widget caption="@Common.Settings" icon="settings.png">
  <v:widget-block>
    <v:form-field caption="@Common.TerminalId">
    <v:input-text field="settings.TerminalId"/>
    </v:form-field>
    <v:form-field caption="@Common.MerchantId">
      <v:input-text field="settings.MerchantId"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="@Receipt.ReceiptWidth">
      <v:input-text field="settings.ReceiptWidth" placeholder="42"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>    
    <v:db-checkbox field="settings.AvoidReceiptPrint" caption="@PluginSettings.AvoidReceiptPrint" value="true" checked="<%=avoidPrint%>" onclick="changeAvoidReceipt()"/>
  </v:widget-block>
  <v:widget-block>    
    <v:db-checkbox field="settings.PrintReceiptForVoid" caption="Print receipt for void transactions" value="true" checked="<%=checkedVoid%>" onclick="changeReceiptForVoid()"/>
  </v:widget-block>
</v:widget>

<script>

function changeAvoidReceipt() {
  if ($("#settings\\.AvoidReceiptPrint").isChecked())
    $("#settings\\.PrintReceiptForVoid").prop("checked", false);
}

function changeReceiptForVoid() {
  if ($("#settings\\.PrintReceiptForVoid").isChecked())
    $("#settings\\.AvoidReceiptPrint").prop("checked", false);
}


function getPluginSettings() {
  return {
    TerminalId: $("#settings\\.TerminalId").val(),
    MerchantId: $("#settings\\.MerchantId").val(),
    ReceiptWidth: $("#settings\\.ReceiptWidth").val(),
    PrintReceiptForVoid: $("#settings\\.PrintReceiptForVoid").isChecked(),
    AvoidReceiptPrint: $("#settings\\.AvoidReceiptPrint").isChecked()
  };
}

</script> 