<%@page import="com.vgs.vcl.JvImageCache"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.LkSN"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget id="pay-cpi-pay-settings" caption="Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
	<v:widget-block>
    <v:form-field caption="Payment timeout" hint="Waiting time for terminate the payment process in second">
      <v:input-text field="PaymentTimeout" type="number"/>
    </v:form-field>
		<v:form-field caption="Banknote port">
      <select id="BanknoteSerialPortName" class="form-control">
      <% for (LookupItem comPort : LkSN.ComPort.getItems()) { %>
        <% String com = comPort.getDescription(); %>
        <option value="<%=com%>"><%=com%></option>
      <% } %>
      </select>
    </v:form-field>
		<v:form-field caption="Accepted banknotes">
		  <label class="checkbox-label"><input type="checkbox" id="5AED" value="true">&nbsp;5 AED</label>&nbsp;&nbsp;&nbsp;
			<label class="checkbox-label"><input type="checkbox" id="10AED" value="true">&nbsp;10 AED</label>&nbsp;&nbsp;&nbsp;
			<label class="checkbox-label"><input type="checkbox" id="20AED" value="true">&nbsp;20 AED</label>&nbsp;&nbsp;&nbsp;
			<label class="checkbox-label"><input type="checkbox" id="50AED" value="true">&nbsp;50 AED</label>&nbsp;&nbsp;&nbsp;
			<label class="checkbox-label"><input type="checkbox" id="100AED" value="true">&nbsp;100 AED</label>&nbsp;&nbsp;&nbsp;
			<label class="checkbox-label"><input type="checkbox" id="200AED" value="true">&nbsp;200 AED</label>&nbsp;&nbsp;&nbsp;
			<label class="checkbox-label"><input type="checkbox" id="500AED" value="true">&nbsp;500 AED</label>
		</v:form-field>
  </v:widget-block>
	<v:widget-block>
  	<v:db-checkbox field="HasCoin" caption="Coins management" hint="Flag if kiosk has coins devices" value="true"/>
		<div class="v-hidden" id="coins-config">
			<v:form-field caption="@Common.PortName">
	      <select id="CoinSerialPortName" class="form-control">
	      <% for (LookupItem comPort : LkSN.ComPort.getItems()) { %>
	        <% String com = comPort.getDescription(); %>
	        <option value="<%=com%>"><%=com%></option>
	      <% } %>
	      </select>
    	</v:form-field>
	    <v:form-field caption="Baudrate">
	      <v:input-text field="BaudRate" type="number"/>
	    </v:form-field>
			<v:form-field caption="@Common.Parity">
	      <select id="Parity" class="form-control">
	        <option value="N">NONE</option>
	        <option value="O">ODD</option>
	        <option value="E">EVEN</option>
	      </select>
    	</v:form-field>
			<v:form-field caption="Stop bit">
      	<v:input-text field="StopBit" type="number"/>
    	</v:form-field>
    	<v:form-field caption="Byte size">
      	<v:input-text field="ByteSize" type="number"/>
    	</v:form-field>
			<v:form-field caption="Coin value" hint="Value of the coins used for changes">
      	<v:input-text field="CoinValue" type="number"/>
    	</v:form-field>
   	</div>  
	</v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
  var $cfg = $("#pay-cpi-pay-settings");  
  $cfg.find("#HasCoin").change(enableDisableCoins);
  
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.find("#BanknoteSerialPortName").val(params.settings.BanknoteSerialPortName);
    $cfg.find("#HasCoin").prop('checked', params.settings.HasCoin);
    $("#CoinSerialPortName").val(params.settings.CoinSerialPortName);
    $cfg.find("#BaudRate").val(params.settings.BaudRate);
    $cfg.find("#Parity").val(params.settings.Parity);
    $cfg.find("#StopBit").val(params.settings.StopBit);
    $cfg.find("#ByteSize").val(params.settings.ByteSize);
    $cfg.find("#CoinValue").val(params.settings.CoinValue);
    $cfg.find("#PaymentTimeout").val(params.settings.PaymentTimeout);
	
    setCheckboxesFromIntArray(params.settings.AcceptedNotes); 
    
    enableDisableCoins();
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
        BanknoteSerialPortName :	$("#BanknoteSerialPortName").val(),
        AcceptedNotes:						getIntArrayFromCheckboxes(),
        HasCoin : 								$("#HasCoin").isChecked(),
        CoinSerialPortName : 			$("#CoinSerialPortName").val(),
        BaudRate:     						$("#BaudRate").val(),
        Parity:										$("#Parity").val(),
        StopBit:									$("#StopBit").val(),
        ByteSize:									$("#ByteSize").val(),
        CoinValue: 								$cfg.find("#CoinValue").val(),
        PaymentTimeout:						$cfg.find("#PaymentTimeout").val()
      };
    });
  
	function enableDisableCoins() {
	  var enabled = $cfg.find("#HasCoin").isChecked();
	  $("#coins-config").setClass("v-hidden", !enabled);
	}
	
	function getIntArrayFromCheckboxes(){
	  var result = [];
	  result[0] = $("#5AED").isChecked() ? 1 : 0; 
	  result[1] = $("#10AED").isChecked() ? 1 : 0; 
	  result[2] = $("#20AED").isChecked() ? 1 : 0; 
	  result[3] = $("#50AED").isChecked() ? 1 : 0; 
	  result[4] = $("#100AED").isChecked() ? 1 : 0; 
	  result[5] = $("#200AED").isChecked() ? 1 : 0;
	  result[6] = $("#500AED").isChecked() ? 1 : 0;
	  return result;
	}
	
	function setCheckboxesFromIntArray(array) {
	  if (typeof array != "undefined" && array.length >= 7) {
	    $("#5AED").prop('checked', (array[0] == 1));
	    $("#10AED").prop('checked', (array[1] == 1));
	    $("#20AED").prop('checked', (array[2] == 1));
	    $("#50AED").prop('checked', (array[3] == 1));
	    $("#100AED").prop('checked', (array[4] == 1));
	    $("#200AED").prop('checked', (array[5] == 1));
	    $("#500AED").prop('checked', (array[6] == 1));
	  }
	}
});
</script>