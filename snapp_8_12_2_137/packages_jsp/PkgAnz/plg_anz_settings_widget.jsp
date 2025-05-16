<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>
<% 
JvDocument settings = (JvDocument)request.getAttribute("settings");
boolean checkedVoid =settings.getChildField("PrintReceiptForVoid").getBoolean();
boolean avoidPrint = settings.getChildField("AvoidReceiptPrint").isUndefined() || settings.getChildField("AvoidReceiptPrint").isNull() || settings.getChildField("AvoidReceiptPrint").getBoolean();

QueryDef qdef = new QueryDef(QryBO_DocTemplate.class);
// Select
qdef.addSelect(QryBO_DocTemplate.Sel.IconName);
qdef.addSelect(QryBO_DocTemplate.Sel.DocTemplateId);
qdef.addSelect(QryBO_DocTemplate.Sel.DocTemplateName);
qdef.addSelect(QryBO_DocTemplate.Sel.DriverCount);
// Where
qdef.addFilter(QryBO_DocTemplate.Fil.DocTemplateType, LkSNDocTemplateType.CCReceipt.getCode());
// Sort
qdef.addSort(QryBO_DocTemplate.Sel.DocTemplateName);
// Exec
JvDataSet dsDocTemplates = pageBase.execQuery(qdef);
pageBase.getReq().setAttribute("dsDocTemplates", dsDocTemplates);
%>

  <v:widget id="anz-pay-settings" caption="Settings" icon="settings.png">
    <v:widget-block>
      <v:form-field caption="@Common.IPAddress">
        <v:input-text field="Address" placeholder="127.0.0.1"/>
      </v:form-field>
      <v:form-field caption="@Common.HostPort">
        <v:input-text field="Port" type="number" placeholder="2011"/>
      </v:form-field>
			<v:form-field caption="@Common.Timeout" hint="Set the timeout, in seconds, for all transactions. If not specified, the default value of 250 seconds will be used.">
        <v:input-text field="Timeout" type="number" placeholder="250" />
      </v:form-field>
    </v:widget-block>
		<v:widget-block>    
    	<v:db-checkbox field="AvoidReceiptPrint" caption="@PluginSettings.AvoidReceiptPrint" value="true" checked="<%=avoidPrint%>"/>
  	</v:widget-block>
  	<v:widget-block>    
    	<v:db-checkbox field="PrintReceiptForVoid" caption="@PluginSettings.PrintVoidReceipt" value="true" checked="<%=checkedVoid%>"/>
  	</v:widget-block>
  	<v:widget-block>    
			<v:form-field caption="Logon template" field="settings.LogonTemplateId">
      	<v:combobox field="LogonTemplateId" lookupDataSetName="dsDocTemplates" idFieldName="DocTemplateId" captionFieldName="DocTemplateName"/>
    	</v:form-field>
  	</v:widget-block>
  	<v:widget-block>
    	<v:form-field caption="@Receipt.ReceiptWidth">
      	<v:input-text field="ReceiptWidth" type="number" placeholder="42"/>
    	</v:form-field>
  	</v:widget-block>
  </v:widget>


<script>
$(document).ready(function() {
  var $cfg = $("#anz-pay-settings");
  $("#PrintReceiptForVoid").click(changeReceiptForVoid);
  $("#AvoidReceiptPrint").click(changeAvoidReceipt);

  
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.find("#Address").val(params.settings.Address);
    $cfg.find("#Port").val(params.settings.Port);
    $cfg.find("#Timeout").val(params.settings.Timeout);
    $cfg.find("#AvoidReceiptPrint").val(params.settings.AvoidReceiptPrint);
    $cfg.find("#PrintReceiptForVoid").val(params.settings.PrintReceiptForVoid);
    $cfg.find("#ReceiptWidth").val(params.settings.ReceiptWidth);
    $cfg.find("#LogonTemplateId").val(params.settings.LogonTemplateId);
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
        Address: $("#Address").val(),
        Port: $("#Port").val(),
        Timeout: $("#Timeout").val(),
        AvoidReceiptPrint: $("#AvoidReceiptPrint").isChecked(),
        PrintReceiptForVoid: $("#PrintReceiptForVoid").isChecked(),
        ReceiptWidth: $("#ReceiptWidth").val(),
        LogonTemplateId: $("#LogonTemplateId").val()
      };
    });
  
  function changeAvoidReceipt() {
    if ($("#AvoidReceiptPrint").isChecked())
      $("#PrintReceiptForVoid").prop("checked", false);
  }

  function changeReceiptForVoid() {
    if ($("#PrintReceiptForVoid").isChecked())
      $("#AvoidReceiptPrint").prop("checked", false);
  }
  
});
</script>

  
<script>

/* function changeAvoidReceipt() {
  if ($("#settings\\.AvoidReceiptPrint").isChecked())
    $("#settings\\.PrintReceiptForVoid").prop("checked", false);
}

function changeReceiptForVoid() {
  if ($("#settings\\.PrintReceiptForVoid").isChecked())
    $("#settings\\.AvoidReceiptPrint").prop("checked", false);
} */

function getPluginSettings() {
  return {
    Address: $("#settings\\.Address").val(),
    Port: $("#settings\\.Port").val(),
    Timeout: $("#settings\\.Timeout").val(),
    AvoidReceiptPrint: $("#settings\\.AvoidReceiptPrint").isChecked(),
    PrintReceiptForVoid: $("#settings\\.PrintReceiptForVoid").isChecked(),
    ReceiptWidth: $("#settings\\.ReceiptWidth").val(),
    LogonTemplateId: $("#settings\\.LogonTemplateId").val()
	};
}
</script>