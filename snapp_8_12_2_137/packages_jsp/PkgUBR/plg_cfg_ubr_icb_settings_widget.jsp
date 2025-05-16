<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.snapp.lookup.LkSNDriverType"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>

<%
JvDocument settings = (JvDocument)request.getAttribute("settings");
boolean checkedVoid =settings.getChildField("PrintReceiptForVoid").getBoolean();
boolean avoidPrint = settings.getChildField("AvoidReceiptPrint").isUndefined() || settings.getChildField("AvoidReceiptPrint").isNull() || settings.getChildField("AvoidReceiptPrint").getBoolean();
%>

<v:widget caption="@Common.Settings">
  <v:widget-block>
    <v:form-field caption="Receipt file full path">
      <v:input-text field="settings.ReceiptFilePath" placeholder="C:\Users\Public\Vgs\Ticket\libraries\ICBCPRTTKT.txt"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>    
    <v:db-checkbox field="settings.AvoidReceiptPrint" caption="@PluginSettings.AvoidReceiptPrint" value="true" checked="<%=avoidPrint%>" onclick="changeAvoidReceipt()"/>
  </v:widget-block>
  <v:widget-block>    
    <v:db-checkbox field="settings.PrintReceiptForVoid" caption="@PluginSettings.PrintVoidReceipt" value="true" checked="<%=checkedVoid%>" onclick="changeReceiptForVoid()"/>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="@Receipt.ReceiptWidth">
      <v:input-text field="settings.ReceiptWidth" placeholder="42"/>
    </v:form-field>
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
    PrintReceiptForVoid: $("#settings\\.PrintReceiptForVoid").isChecked(),
    AvoidReceiptPrint: $("#settings\\.AvoidReceiptPrint").isChecked(),
    ReceiptWidth: $("#settings\\.ReceiptWidth").val(),
    ReceiptFilePath: $("#settings\\.ReceiptFilePath").val()
  };
}

</script>

