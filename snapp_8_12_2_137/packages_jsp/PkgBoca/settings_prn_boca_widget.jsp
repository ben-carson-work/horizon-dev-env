<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>


<v:widget id="boca-settings" caption="@Common.Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
    <table class="form-table" >
      <tr>
        <th><label for="settings.InterfaceType"><v:itl key="@Common.InterfaceType"/></label></th>
        <td>
          <select id="settings.InterfaceType" class="form-control">
            <option value="1">TCP/IP</option>
            <option value="2">Serial</option>
            <option value="3">Driver</option>
            <option value="4">USB HID</option>
          </select>
        </td>       
      </tr>
    </table>
  </v:widget-block>
  <v:widget-block id="interface-driver" clazz="v-hidden">
    <table class="form-table">
      <tr>
        <th><label for="settings.PrinterName"><v:itl key="@Plugin.PrinterName"/></label></th>
        <td><v:input-text field="settings.PrinterName"/></td>
      </tr>
    </table>
  </v:widget-block>
  <v:widget-block id="interface-serial" clazz="v-hidden">
    <table class="form-table" >
      <tr>
        <th><label for="settings.PortName"><v:itl key="@Common.PortName"/></label></th>
        <td> 
          <select id="settings.PortName" class="form-control">
          <% for (LookupItem comPort : LkSN.ComPort.getItems()) { %>
            <% String com = comPort.getDescription(); %>
            <option value="<%=com%>"><%=com%></option>
          <% } %>
          </select>
        </td>       
      </tr>
      <tr>
        <th><label for="settings.BaudRate"><v:itl key="@Common.Baudrate"/></label></th>
        <td>
          <v:lk-combobox lookup="<%=LkSN.BaudRate%>" field="settings.BaudRate"/>
        </td>
      </tr>
    </table>
  </v:widget-block>
  <v:widget-block id="interface-usb" clazz="v-hidden">
    <table class="form-table" >
      <tr>
        <th><label for="settings.PrinterSerial"><v:itl key="Printer Serial"/></label></th>
        <td><v:input-text field="settings.PrinterSerial"/></td>
      </tr>
    </table>
  </v:widget-block>
  <v:widget-block id="interface-tcp" clazz="v-hidden">
    <table class="form-table" >
      <tr>
        <th><label for="settings.HostName"><v:itl key="@Common.HostName"/></label></th>
        <td><v:input-text field="settings.HostName"/></td>
      </tr>
      <tr>
        <th><label for="settings.HostPort"><v:itl key="@Common.HostPort"/></label></th>
        <td><v:input-text field="settings.HostPort"/></td>
      </tr>
    </table>
  </v:widget-block>
  <v:widget-block>
    <table class="form-table" >
      <tr>
        <th><label for="settings.CutAllTickets"><v:itl key="@Common.CutAllTickets"/></label></th>
        <td><v:db-checkbox field="settings.CutAllTickets" caption="" value="true" /></td>
      </tr>
      <tr>
        <th><label for="settings.ChineseText"><v:itl key="@Common.Chinese"/></label></th>
        <td><v:db-checkbox field="settings.ChineseText" hint="Flag it if Chinese text has to printed" caption="" value="true" /></td>
      </tr>
    </table>
  </v:widget-block>
</v:widget>

 
<script>

$(document).ready(function() {
  var $cfg = $("#boca-settings");
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
	var $interfaceType = $cfg.find("#settings\\.InterfaceType");
    $cfg.find($interfaceType).val(params.settings.InterfaceType);
    $cfg.find("#settings\\.PrinterName").val(params.settings.PrinterName);
    $cfg.find("#settings\\.PortName").val(params.settings.PortName);
    $cfg.find("#settings\\.BaudRate").val(params.settings.BaudRate);
    $cfg.find("#settings\\.HostName").val(params.settings.HostName);
    $cfg.find("#settings\\.HostPort").val(params.settings.HostPort);
    $cfg.find("#settings\\.PrinterSerial").val(params.settings.PrinterSerial);
    $cfg.find("#settings\\.CutAllTickets").val(params.settings.CutAllTickets);
    $cfg.find("#settings\\.ChineseText").val(params.settings.ChineseText);
    
    enableDisable($interfaceType)
    
    if(params.settings.PortName) {
    	$cfg.find("#settings\\.PortName > option").each(function() {
    		if(params.settings.PortName === this.value)
    			this.selected = true;
    	})
    }
    
  });
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
		InterfaceType: $("#settings\\.InterfaceType").val(),
		PrinterName: $("#settings\\.PrinterName").val(),
		PortName: $("#settings\\.PortName").val(),
		BaudRate: $("#settings\\.BaudRate").val(),
		HostName: $("#settings\\.HostName").val(),
		HostPort: $("#settings\\.HostPort").val(),
		PrinterSerial: $("#settings\\.PrinterSerial").val(),
		CutAllTickets: $("#settings\\.CutAllTickets").isChecked(),
		ChineseText: $("#settings\\.ChineseText").isChecked()
    };
  });
  
  $cfg.find("#settings\\.InterfaceType").change(function() {
	  enableDisable(this);
  })
  
  function enableDisable(interfaceTypeElem) {
	  var jInterfaceType = $(interfaceTypeElem).val()
	    $("#interface-tcp").setClass("v-hidden", jInterfaceType != 1); 
	    $("#interface-serial").setClass("v-hidden", jInterfaceType != 2); 
	    $("#interface-driver").setClass("v-hidden", jInterfaceType != 3); 
	    $("#interface-usb").setClass("v-hidden", jInterfaceType != 4);
  }
  
});

</script>
