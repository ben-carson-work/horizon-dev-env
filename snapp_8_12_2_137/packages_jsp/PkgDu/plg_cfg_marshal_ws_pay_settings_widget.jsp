<%@page import="com.vgs.vcl.JvImageCache"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.LkSN"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget id="pay-marshal-ws-settings" caption="Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
  	<v:form-field caption="WSDL Url">
      <v:input-text field="Url" />
    </v:form-field>
    <v:form-field caption="@Common.PortName">
      <select id="PortName" class="form-control">
      <% for (LookupItem comPort : LkSN.ComPort.getItems()) { %>
        <% String com = comPort.getDescription(); %>
        <option value="<%=com%>"><%=com%></option>
      <% } %>
      </select>
    </v:form-field>
    <v:form-field caption="Baudrate" mandatory="true">
      <v:input-text field="BaudRate" type="number"/>
    </v:form-field>
    <v:form-field caption="Timeout" mandatory="true">
      <v:input-text field="Timeout" placeholder="10" type="number"/>
    </v:form-field>
    <v:form-field caption="Transaction timeout" mandatory="true">
      <v:input-text field="TxnTimeout"  placeholder="90" type="number"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
  	<v:db-checkbox field="SettlementLoop" caption="Settlement loop" hint="Flag if settlement needs to be called recursively during the day" value="true"/>
			<div class="v-hidden" id="loop-config">
				<v:form-field caption="Settlement reccurrence" hint="Define here the recurrence time for settelment loop,value is in minutes ">
					<v:input-text field="SettlementRecurTime"  type="number"/>
				</v:form-field>
		</div>
  </v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
  var $cfg = $("#pay-marshal-ws-settings");
  $cfg.find("#SettlementLoop").change(enableDisableRecur);

  
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.find("#Url").val(params.settings.Url);
    $cfg.find("#BaudRate").val(params.settings.BaudRate);
    $cfg.find("#Timeout").val(params.settings.Timeout);
    $cfg.find("#TxnTimeout").val(params.settings.TxnTimeout);
    $cfg.find("#SettlementRecurTime").val(params.settings.SettlementRecurTime);
    $cfg.find("#SettlementLoop").prop('checked', params.settings.SettlementLoop);
    $("#PortName").val(params.settings.PortName);
    enableDisableRecur();

  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
        Url :     								$("#Url").val(),
        PortName : 								$("#PortName").val(),
        BaudRate : 								$cfg.find("#BaudRate").val(),
        Timeout : 								$cfg.find("#Timeout").val(),
        TxnTimeout : 							$cfg.find("#TxnTimeout").val(),
        SettlementLoop : 					$("#SettlementLoop").isChecked(),
        SettlementRecurTime : 		$cfg.find("#SettlementRecurTime").val()
      };
    });
  
	function enableDisableRecur() {
	  var enabled = $cfg.find("#SettlementLoop").isChecked();
	  $("#loop-config").setClass("v-hidden", !enabled);
	}
  });
</script>