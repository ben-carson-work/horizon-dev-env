<%@page import="com.vgs.web.library.BLBO_Plugin"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>
<%
boolean checkedVoid = settings.getChildField("PrintReceiptForVoid").isUndefined() || settings.getChildField("PrintReceiptForVoid").isNull() || settings.getChildField("PrintReceiptForVoid").getBoolean();
boolean avoidPrint = settings.getChildField("AvoidReceiptPrint").getBoolean();
%>

<v:widget caption="@Common.Settings" icon="settings.png">
  <v:widget-block>
    <v:form-field caption="@Common.PortName">
      <select id="settings.COMPort" class="form-control">
        <% for (LookupItem comPort : LkSN.ComPort.getItems()) { %>
          <% String com = comPort.getDescription(); %>
          <% String sel = JvString.isSameText(com, settings.getChildField("COMPort").getString()) ? "selected" : ""; %>
          <option value="<%=com%>" <%=sel%>><%=com%></option>
        <% } %>
      </select>
    </v:form-field>
    <v:form-field caption="@Common.Baudrate">
      <select id="settings.BaudRate" class="form-control">
        <option value="0" <%=JvString.isSameText("0", settings.getChildField("BaudRate").getString()) ? "selected" : ""%>>300</option>
        <option value="1" <%=JvString.isSameText("1", settings.getChildField("BaudRate").getString()) ? "selected" : ""%>>1200</option>
        <option value="2" <%=JvString.isSameText("2", settings.getChildField("BaudRate").getString()) ? "selected" : ""%>>2400</option>
        <option value="3" <%=JvString.isSameText("3", settings.getChildField("BaudRate").getString()) ? "selected" : ""%>>4800</option>
        <option value="4" <%=JvString.isSameText("4", settings.getChildField("BaudRate").getString()) ? "selected" : ""%>>9600</option>
        <option value="5" <%=JvString.isSameText("5", settings.getChildField("BaudRate").getString()) ? "selected" : ""%>>19200</option>
      </select>
    </v:form-field>
    <v:form-field caption="@Common.DataBits">
      <select id="settings.DataBits" class="form-control">
        <option value="0" <%=JvString.isSameText("0", settings.getChildField("DataBits").getString()) ? "selected" : ""%>>7</option>
        <option value="1" <%=JvString.isSameText("1", settings.getChildField("DataBits").getString()) ? "selected" : ""%>>8</option>
      </select>
    </v:form-field>
    <v:form-field caption="@Common.Parity">
      <select id="settings.Parity" class="form-control">
        <option value="0" <%=JvString.isSameText("0", settings.getChildField("Parity").getString()) ? "selected" : ""%>>NONE</option>
        <option value="1" <%=JvString.isSameText("1", settings.getChildField("Parity").getString()) ? "selected" : ""%>>ODD</option>
        <option value="2" <%=JvString.isSameText("2", settings.getChildField("Parity").getString()) ? "selected" : ""%>>EVEN</option>
      </select>
    </v:form-field>
    <v:form-field caption="@Common.StopBits">
      <select id="settings.StopBits" class="form-control">
        <option value="0" <%=JvString.isSameText("0", settings.getChildField("StopBits").getString()) ? "selected" : ""%>>0</option>
        <option value="1" <%=JvString.isSameText("1", settings.getChildField("StopBits").getString()) ? "selected" : ""%>>1</option>
      </select>
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
    ReceiptWidth: $("#settings\\.ReceiptWidth").val(),
    COMPort: $("#settings\\.COMPort").val(),
    BaudRate: $("#settings\\.BaudRate").val(),
    DataBits: $("#settings\\.DataBits").val(),
    Parity: $("#settings\\.Parity").val(),
    StopBits: $("#settings\\.StopBits").val(),
    PrintReceiptForVoid: $("#settings\\.PrintReceiptForVoid").isChecked(),
    AvoidReceiptPrint: $("#settings\\.AvoidReceiptPrint").isChecked()
  };
}

</script>
 