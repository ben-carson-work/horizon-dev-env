<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@page import="com.vgs.cl.JvDataSet"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.json.JSONObject"%>
<%@page import="com.vgs.snapp.query.QryBO_OutboundMessage.*"%>
<%@page import="com.vgs.snapp.web.queue.outbound.BOOutboundManager"%>

<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>

<v:widget id="azure-event-hub-settings" caption="Settings">
  <v:widget-block>
    <v:form-field caption="Service host" hint="bootstrap.servers" mandatory="true">
      <v:input-text field="FullyQualifiedNamespace"/>
    </v:form-field>
    <v:form-field caption="Even hub name" mandatory="true">
      <v:input-text field="EventHubName"/>
    </v:form-field>
    <v:form-field caption="Shared key name" mandatory="true">
      <v:input-text field="SharedAccessKeyName"/>
    </v:form-field>
    <v:form-field caption="Shared key" mandatory="true">
      <v:input-text field="SharedAccessKey" type="password"/>
    </v:form-field>
    <v:form-field caption="Default Configuration" hint="When enabled uses above configuration for all messages. Unflag it to use custom settings." mandatory="true">
      <v:db-checkbox caption="" field="UseSameConfiguration" enabled="true" value="true"/>
    </v:form-field>    
	</v:widget-block> 
</v:widget>
<div id="cfg-parameters-body">
	<v:widget caption="Messages">
	  <v:widget-block>
			  <v:grid clazz="grid-item" >
				  <thead>
				    <tr>
				      <td width="30%"><v:itl key="Type"/></td>
				      <td width="70%"><v:itl key="Event hub name"/></td>
				    </tr>
				  </thead>
					<tbody class="data-tbody"> </tbody>
	  		</v:grid>
	  </v:widget-block>
	</v:widget>
</div>  


<div id="message-detail-template" class="hidden">
  <table>
    <tr class="tr-item">
			<td id ="message_type"></td>
			<td><v:input-text type="text" field="event_hub_name"/></td>
    </tr>
  </table>

</div>

<script>

<%
	QueryDef qdef = new QueryDef(QryBO_OutboundMessage.class);
	JSONObject doMessageDescriptionJson = new JSONObject();
	qdef.addSelect(
		 Sel.OutboundMessageId,
		 Sel.OutboundMessageName
		);
		qdef.addFilter(Fil.ExtensionPackageId, plugin.ExtensionPackageId.getString());
		
	  try (JvDataSet ds = pageBase.execQuery(qdef)) {    
	    while (!ds.isEof()) {
	      doMessageDescriptionJson.put(BOOutboundManager.getInstance().getOBMMessageClass(ds.getString(Sel.OutboundMessageId)).getCanonicalName(),
	          												 ds.getString(Sel.OutboundMessageName));
	      ds.next();
	    }
	  }
		request.setAttribute("doMessageDescriptionMap", doMessageDescriptionJson.toString());
%>

$(document).ready(function() {
	var default_cfg = [];
	var messageMap = ${doMessageDescriptionMap}
	for (let key in messageMap)
	  default_cfg.push({"Type": key, "Description": messageMap[key]})


  function refreshVisibility() {	
    var isChecked = $("#UseSameConfiguration").isChecked();
    if (isChecked)
    	$("#cfg-parameters-body").addClass("v-hidden");
    else
    	$("#cfg-parameters-body").removeClass("v-hidden");
    
    _setMandatory($("#EventHubName"), isChecked);
    _setMandatory($(".data-tbody" ), isChecked);
  }
  
  function _setMandatory(selector, mandatory) {
		$formFieldSel = selector.closest(".form-field")
		$formFieldCaptionSel = $formFieldSel.find(".form-field-caption")
  	if (mandatory) {
  		$formFieldSel.attr("data-required", true);
  		$formFieldCaptionSel.addClass("mandatory-field");  		
  	} else {
  		$formFieldSel.attr("data-required", false);
  		$formFieldCaptionSel.removeClass("mandatory-field");
  	}
  }
	
	function _extractMessageDetails() {
	  var $rows = $(".data-tbody tr");
	  var result = [];
	  for (var i=0; i < $rows.length; i++) {
	    var $row = $($rows[i]);
	    result.push({
	      "Type": $row.find("#message_type").attr("type"),
	      "EventHubName": $row.find("[name='event_hub_name']").val()
	    });
	  }
	  return result;
	}	

	function _showMessageDetails(type, description, event_hub_name) {
		let $table = $(".data-tbody");
	  var $tr = $("#message-detail-template .tr-item").clone().appendTo($table);
	  let $messageTypeSel = $tr.find("#message_type");
	  let $eventHubNameSel = $tr.find("[name='event_hub_name']");
	  $messageTypeSel.html(description);
	  $messageTypeSel.attr("type", type);
	  $eventHubNameSel.val(event_hub_name);
	  $eventHubNameSel.attr('id', newStrUUID());
	}

	function _showMessagesDetails(values = []) {		
		for (let index in default_cfg) {
			let default_msg_type = default_cfg[index]
			let cfg_msg_type = values.filter((value) => value.Type == default_msg_type.Type)[0] 
			if (!cfg_msg_type) {
				values.push(default_msg_type)
				_showMessageDetails(default_msg_type.Type, default_msg_type.Description, default_msg_type.EventHubName);
			} else {
				_showMessageDetails(cfg_msg_type.Type, default_msg_type.Description, cfg_msg_type.EventHubName);
			}
		}
	}
	
  var $cfg = $("#azure-event-hub-settings");
  
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.find("#FullyQualifiedNamespace").val(params.settings.FullyQualifiedNamespace);
    $cfg.find("#EventHubName").val(params.settings.EventHubName);  
    $cfg.find("#SharedAccessKeyName").val(params.settings.SharedAccessKeyName);
    $cfg.find("#SharedAccessKey").val(params.settings.SharedAccessKey);
    $cfg.find("#UseSameConfiguration").prop('checked', (params.settings.UseSameConfiguration));
  	_showMessagesDetails(params.settings.MessageDetails);
    refreshVisibility();
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
      	FullyQualifiedNamespace: $("#FullyQualifiedNamespace").val(),
      	EventHubName: $("#EventHubName").val(),
      	SharedAccessKeyName: $("#SharedAccessKeyName").val(),
      	SharedAccessKey: $("#SharedAccessKey").val(),
      	UseSameConfiguration :$("#UseSameConfiguration").isChecked(),
      	MessageDetails: _extractMessageDetails()
    };
  });

  $("#UseSameConfiguration").click(refreshVisibility);
  refreshVisibility();

  
});


</script>