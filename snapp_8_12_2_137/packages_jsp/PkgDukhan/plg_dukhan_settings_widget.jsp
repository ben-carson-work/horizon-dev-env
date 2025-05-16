<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>
<% 
JvDocument settings = (JvDocument)request.getAttribute("settings");
boolean checkedVoid =settings.getChildField("PrintReceiptForVoid").getBoolean();
boolean avoidPrint = settings.getChildField("AvoidReceiptPrint").isUndefined() || settings.getChildField("AvoidReceiptPrint").isNull() || settings.getChildField("AvoidReceiptPrint").getBoolean();
%>

  <v:widget caption="Settings" icon="settings.png">
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
    </v:widget-block>
    <v:widget-block>
    	<v:form-field caption="Currency name">
      	<v:input-text field="settings.CurrencyName" placeholder="QAR"/>
    	</v:form-field>
  	</v:widget-block>
      	<v:widget-block>
    	<v:form-field caption="Currentcy code">
      	<v:input-text field="settings.CurrencyCode" placeholder="634"/>
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
    COMPort: $("#settings\\.COMPort").val(),
    CurrencyName: $("#settings\\.CurrencyName").val(),
    CurrencyCode: $("#settings\\.CurrencyCode").val(),
    AvoidReceiptPrint: $("#settings\\.AvoidReceiptPrint").isChecked(),
    PrintReceiptForVoid: $("#settings\\.PrintReceiptForVoid").isChecked(),
    ReceiptWidth: $("#settings\\.ReceiptWidth").val()
	};
}
</script>