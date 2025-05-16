<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.snapp.lookup.LkSN"%>
<%@page import="com.vgs.cl.lookup.LookupItem"%>
<%@page import="com.vgs.cl.document.JvDocument"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>

<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>
<v:widget caption="@Common.Settings" icon="settings.png">
	<v:widget caption="Barcode Reader configuration" icon="settings.png">
	  <v:widget-block>
	    <v:form-field caption="@Common.PortName">
	      <select id="settings.PortName" class="form-control">
	      <% for (LookupItem comPort : LkSN.ComPort.getItems()) { %>
	        <% String com = comPort.getDescription(); %>
	        <% String sel = JvString.isSameText(com, settings.getChildField("PortName").getString()) ? "selected" : ""; %>
	        <option value="<%=com%>" <%=sel%>><%=com%></option>
	      <% } %>
	      </select>
	    </v:form-field>
	    <v:form-field caption="@Common.Baudrate">
	      <v:lk-combobox lookup="<%=LkSN.BaudRate%>" field="settings.BaudRate"/>
	    </v:form-field>
	  </v:widget-block>
  </v:widget>
  <v:widget caption="RFID configuration" icon="settings.png">
		<v:widget-block>
		<v:db-checkbox field="settings.RFIDEnabled" caption="Enable RFID " hint="If checked RFID reader will be enabled on the scanner" value="true"/>
			<div class="v-hidden rfid-config" id="rfid-config">
			 <v:form-field caption="Reversal read" hint="Read card id in reversal way">
		    	<v:db-checkbox field="settings.ReversalRead" caption="@Common.Enable" value="true"/>
		    </v:form-field>
		   	<v:form-field caption="Keep leading zero" hint="If flaged leading zero won't be removed from read card id">
		    	<v:db-checkbox field="settings.KeepLeadingZero" caption="@Common.Enable" value="true"/>
		    </v:form-field>
		    <v:form-field caption="@PluginSettings.FeigRfid.ReadData">
		      <v:db-checkbox field="settings.ReadData" caption="@Common.Enabled" value="true"/>
		    </v:form-field>
		    <v:form-field id="data-read-first-db" caption="@PluginSettings.FeigRfid.FirstDataBlock">
		      <v:input-text field="settings.FirstDataBlock"/>
		    </v:form-field>
		    <v:form-field id="data-read-num-of-bytes" caption="@PluginSettings.FeigRfid.NumberOfBytes">
		      <v:input-text field="settings.NumberOfBytes"/>
		    </v:form-field>
   		</div>  
		</v:widget-block>
  </v:widget>
</v:widget>

<script>
$(document).ready(function() {
  enableDisableRfidConfig()
  enableDisableDataRead();
  $("#settings\\.RFIDEnabled").change(enableDisableRfidConfig);
	$("#settings\\.ReadData").change(enableDisableDataRead);
  
	function enableDisableRfidConfig() {
	  var enabled = $("#settings\\.RFIDEnabled").isChecked();
	  $("#rfid-config").setClass("v-hidden", !enabled);
	}
	
	function enableDisableDataRead() {
		var enabled = $("#settings\\.ReadData").isChecked();
		  $("#data-read-first-db").setClass("v-hidden", !enabled); 
		  $("#data-read-num-of-bytes").setClass("v-hidden", !enabled); 
	}
	
});

function getPluginSettings() {
  return {
    PortName: $("#settings\\.PortName").val(),
    BaudRate: $("#settings\\.BaudRate").val(),
    ReadData: $("#settings\\.ReadData").isChecked(),
    FirstDataBlock: $("#settings\\.FirstDataBlock").val(),
    NumberOfBytes: $("#settings\\.NumberOfBytes").val(),
    ReversalRead: $("#settings\\.ReversalRead").isChecked(),
    RFIDEnabled: $("#settings\\.RFIDEnabled").isChecked()
  };
}

</script>