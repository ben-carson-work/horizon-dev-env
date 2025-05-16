<%@page import="com.vgs.snapp.dataobject.DOTimedTicketRule"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
BLBO_TimedTicketRule bl = pageBase.getBL(BLBO_TimedTicketRule.class);
DOTimedTicketRule rule = pageBase.isNewItem() ? bl.prepareNewRule() : bl.loadRule(pageBase.getId()); 
String title = pageBase.isNewItem() ? pageBase.getLang().Product.NewTimedTicketRule.getText() : rule.RuleName.getString();
request.setAttribute("rule", rule);
boolean canEdit = rights.ProductTypes.getOverallCRUD().canUpdate();
%>

<v:dialog id="timed_ticket_rule_dlg" icon="<%=rule.IconName.getString()%>" title="<%=JvString.escapeHtml(title)%>" width="800" height="600">

<style>
#toolbar {
  padding: 8px 0 0 8px;
}
.rule-grid-input{
  width:94%;
}
</style>

<v:widget caption="@Common.Profile">
  <v:widget-block>
    <v:form-field caption="@Common.Code" mandatory="true">
      <v:input-text field="rule.RuleCode" enabled="<%=canEdit%>"/>
    </v:form-field>
    <v:form-field caption="@Common.Name" mandatory="true">
      <v:input-text field="rule.RuleName" enabled="<%=canEdit%>"/>
    </v:form-field>
    <v:form-field caption="@Common.FromDate">
      <v:input-text type="datepicker" field="rule.ValidFromDate" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
    </v:form-field>
    <v:form-field caption="@Common.ToDate">
      <v:input-text type="datepicker" field="rule.ValidToDate" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="@Common.Items">
	<div id="toolbar">
	  <v:button caption="@Common.Add" fa="plus" href="javascript:addRuleItem()" enabled="<%=canEdit%>"/>
	  <v:button caption="@Common.Remove" fa="minus" href="javascript:removeRuleItem()" enabled="<%=canEdit%>"/>
	</div>
  <v:widget-block>
	  <v:grid id="rule-items-grid">
		  <thead>
			  <tr class="header">
			    <td><v:grid-checkbox header="true"/></td>
		      <td><v:itl key="@Common.Name"/></td>
		      <td width="90px"><v:itl key="@Product.FromTime"/></td>
		      <td width="90px"><v:itl key="@Product.ToTime"/></td>
	        <td width="90px"><v:itl key="@Common.Amount"/></td>
		      <td width="100px"><v:itl key="@Product.StepType"/></td>
		      <td width="90px"><v:itl key="@Product.StepValue"/></td>
			  </tr>
		  </thead>
		  <tbody></tbody>
	  </v:grid>
  </v:widget-block>
</v:widget>

<div id="rule-item-checkbox-template" class="v-hidden"><v:grid-checkbox name="rule-item-checkbox"/></div>
<div id="rule-item-optional-template" class="v-hidden"><v:grid-checkbox name="Optional"/></div>
<div id="step-type-template" class="v-hidden"><v:lk-combobox field="StepType" lookup="<%=LkSN.TimedTicketRuleStepType%>" allowNull="false" clazz="rule-grid-input" enabled="<%=canEdit%>"/></div>

<script>
var rule = <%=rule.getJSONString()%>;

$(document).ready(function() {
  var dlg = $("#timed_ticket_rule_dlg");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        text: itl("@Common.Save"),
        click: doSave,
        disabled: <%=!canEdit%>
      }, 
      {
        text: itl("@Common.Cancel"),
        click: doCloseDialog
      }
    ];
  }); 
	
	initRuleItems();
});

function initRuleItems() {
  if ((rule) && (rule.RuleItemList)) {
    for (var i=0; i<rule.RuleItemList.length; i++) 
    	addRuleItem(rule.RuleItemList[i]);    
  }
}

function doSaveRule() {
	var reqDO = {
		Command: "SaveTimedTicketRule",
		SaveTimedTicketRule: {
			TimedTicketRule: {
				TimedTicketRuleId: <%=rule.TimedTicketRuleId.isNull() ? null : "\"" + rule.TimedTicketRuleId.getEmptyString() + "\""%>,
        RuleName: $("#rule\\.RuleName").val(),
        RuleCode: $("#rule\\.RuleCode").val(),
        ValidFromDate: $("#rule\\.ValidFromDate").val(),
				ValidToDate: $("#rule\\.ValidToDate").val(),
				RuleItemList: getRuleItems()
			}
		}
	};
	
	vgsService("Product", reqDO, false, function(ansDO) {
		triggerEntityChange(<%=LkSNEntityType.TimedTicketRule.getCode()%>);
    $("#timed_ticket_rule_dlg").dialog("close");
	});
}

function doSave() {
  checkRequired("#timed_ticket_rule_dlg", function() {
    doSaveRule();
  })
}

function getRuleItems() { 
  var result = [];
  var trs = $("#rule-items-grid tbody tr");

  for (var i=0; i<trs.length; i++) {
    var tr = $(trs[i]);
    result.push({
      ItemName: tr.find("[name='Name']").val(),
      Optional: false,
      ApplyFromMinute: stringToTimeValue(tr.find("[name='FromMinute']").val()), 
      ApplyToMinute: stringToTimeValue(tr.find("[name='ToMinute']").val()), 
      StepType: strToIntDef(tr.find("[name='StepType']").val(), <%=LkSNTimedTicketRuleStepType.Minute.getCode()%>),
      StepValue: strToIntDef(tr.find("[name='StepValue']").val(), 0),
      StepAmount: strToFloatDef(tr.find("[name='StepAmount']").val(), 0)
    });
  }
  return result;
}

function  getNewRuleItem(){
  return {
	  Optional: false,
    ApplyFromMinute: null,
    ApplyToMinute: null,
    StepValue: 0,
    StepAmount: 0.0,
    ValidFromDate: null,
    ValidToDate: null
  };  
}

function addRuleItem(ruleItem) {
  ruleItem = (ruleItem) ? ruleItem : getNewRuleItem();
  
  var tbody = $("#rule-items-grid tbody");
  var trRuleItem = $("<tr/>").appendTo(tbody);
  
  var tdCheckbox = $("<td/>").appendTo(trRuleItem);
  var tdOptional = $("<td class='v-hidden'/>").appendTo(trRuleItem);
  var tdName = $("<td/>").appendTo(trRuleItem);
  var tdFromMinute = $("<td/>").appendTo(trRuleItem);
  var tdToMinute = $("<td/>").appendTo(trRuleItem);
  var tdStepAmount = $("<td/>").appendTo(trRuleItem);
  var tdStepType = $("<td/>").appendTo(trRuleItem);
  var tdStepValue = $("<td/>").appendTo(trRuleItem);
  
  tdCheckbox.html($("#rule-item-checkbox-template").html());
  tdOptional.html($("#rule-item-optional-template").html());
  tdName.html("<input type='text' name='Name' class='rule-grid-input form-control'  value='" + ((ruleItem.ItemName) ? ruleItem.ItemName : "") + "'/>");
  <% String stepHint = pageBase.getLang().Common.TimeStepHint.getText() ; %>
  timeValueToString(ruleItem.ApplyFromMinute);
  tdFromMinute.html("<input type='text' name='FromMinute' title='<%=stepHint%>' class='rule-grid-input form-control' placeholder='<v:itl key="@Common.Unlimited"/>' value='" + timeValueToString(ruleItem.ApplyFromMinute) + "'/>");
  tdToMinute.html("<input type='text' name='ToMinute' title='<%=stepHint%>' class='rule-grid-input form-control' placeholder='<v:itl key="@Common.Unlimited"/>' value='" + timeValueToString(ruleItem.ApplyToMinute) + "'/>");
  tdStepAmount.html("<input type='text' name='StepAmount' class='rule-grid-input form-control' value='" + ruleItem.StepAmount + "'/>");
  tdStepValue.html("<input type='number' min='1' name='StepValue' class='rule-grid-input form-control' value='" + ruleItem.StepValue + "'/>");
  tdStepType.html($("#step-type-template").html());
  tdStepType.find("select").change(function() {
	  if (tdStepType.find("select").val() == 0) {
	    tdStepValue.find("[name='StepValue']").addClass("v-hidden");
	    tdStepValue.find("[name='StepValue']").val(1);
	  }
	  else
	    tdStepValue.find("[name='StepValue']").removeClass("v-hidden");	  	  
  });
  tdStepType.find("select").val(ruleItem.StepType);
  tdStepType.find("select").trigger("change");
}

function stringToTimeValue(strValue) {
	if (strValue && (strValue.length > 1)) 
    result = strToIntDef(strValue.substr(0, strValue.length-1), null);		
	else
		result = null;
	
  if (result) {
	  switch (strValue.trim().charCodeAt(strValue.length-1)) {
      case 100: result = result*1440; //d
        break;
		  case 104: result = result*60; //h
		    break;
			case 109: result = result; //m
			  break;
			default:
				result = strToIntDef(strValue, null);  
		}
  }  
  return result;
}
	
function timeValueToString(timeValue) {
	result = "";
	if (timeValue) {
		if ((timeValue % 1440) == 0) 
			result = timeValue/1440 + 'd';
		else if ((timeValue % 60) == 0) 
      result = timeValue/60 + 'h';
		else
      result = timeValue + 'm';
	}  
	return result;
}

function stepTypeChanged(tdStepType, tdStepValue) {
	
}

function removeRuleItem() {
  var cbs = $("#rule-items-grid [name='rule-item-checkbox']:checked");
  for (var i=0; i<cbs.length; i++)
    $(cbs[i]).closest("tr").remove();
};
</script>

</v:dialog>