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
            <option value="4" selected>USB HID</option>
          </select>
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
    </table>
  </v:widget-block>
  <v:widget-block>
    <table class="form-table" >
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
    $cfg.find("#settings\\.HostName").val(params.settings.HostName);
    $cfg.find("#settings\\.PrinterSerial").val(params.settings.PrinterSerial);
    $cfg.find("#settings\\.ChineseText").val(params.settings.ChineseText);
    
    enableDisable($interfaceType)
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
		InterfaceType: $("#settings\\.InterfaceType").val(),
		HostName: $("#settings\\.HostName").val(),
		PrinterSerial: $("#settings\\.PrinterSerial").val(),
		ChineseText: $("#settings\\.ChineseText").isChecked()
    };
  });
  
  $cfg.find("#settings\\.InterfaceType").change(function() {
	  enableDisable(this);
  })
  
  function enableDisable(interfaceTypeElem) {
	  var jInterfaceType = $(interfaceTypeElem).val()
	    $("#interface-tcp").setClass("v-hidden", jInterfaceType != 1); 
	    $("#interface-usb").setClass("v-hidden", jInterfaceType != 4);
  }
 
});

</script>
