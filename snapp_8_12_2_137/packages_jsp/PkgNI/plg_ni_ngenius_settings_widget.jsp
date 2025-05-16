<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
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
      <v:form-field caption="@Common.IPAddress">
        <v:input-text field="settings.Address" placeholder="localhost"/>
      </v:form-field>
      <v:form-field caption="@Common.HostPort">
        <v:input-text field="settings.HostPort" type="number" placeholder="8085"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>    
    	<v:db-checkbox field="settings.SettlementSupervisorOnly" caption="Settlement supervisor only" hint="If checked only supervisor users can perform a settlement" value="true"/>
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
  	<v:widget-block>    
    	<v:db-checkbox field="settings.NewTerminal" caption="New Terminal" value="true" hint="Flag if new device is used and new management of updateTransaction message is required"/>
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
    Address: $("#settings\\.Address").val(),
    HostPort: $("#settings\\.HostPort").val(),
    AvoidReceiptPrint: $("#settings\\.AvoidReceiptPrint").isChecked(),
    PrintReceiptForVoid: $("#settings\\.PrintReceiptForVoid").isChecked(),
    ReceiptWidth: $("#settings\\.ReceiptWidth").val(),
    SettlementSupervisorOnly: $("#settings\\.SettlementSupervisorOnly").isChecked(),
    NewTerminal: $("#settings\\.NewTerminal").isChecked()
	};
}
</script>