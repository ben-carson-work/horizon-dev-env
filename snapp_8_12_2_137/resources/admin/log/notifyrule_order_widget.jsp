<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
DONotifyRule.DONotifyRuleOrder settings = ((DONotifyRule)request.getAttribute("notifyRule")).NotifyRuleOrder;

boolean saleAccountTypeFixed = settings.NotifyOrder_OrderNotificationRecipientType.isNull();
int daysFromVisitDate = settings.NotifyOrder_DocData.DaysFromVisitDate.getInt();

boolean fil_Used      = JvArray.contains(LkSNNotifyRuleFlag.Filter_Used.getCode(), settings.NotifyOrder_Fil_Flags.getArray());
boolean fil_Approved  = JvArray.contains(LkSNNotifyRuleFlag.Filter_Approved.getCode(), settings.NotifyOrder_Fil_Flags.getArray());
boolean fil_Paid      = JvArray.contains(LkSNNotifyRuleFlag.Filter_Paid.getCode(), settings.NotifyOrder_Fil_Flags.getArray());
boolean fil_Encoded   = JvArray.contains(LkSNNotifyRuleFlag.Filter_Encoded.getCode(), settings.NotifyOrder_Fil_Flags.getArray());
boolean fil_Validated = JvArray.contains(LkSNNotifyRuleFlag.Filter_Validated.getCode(), settings.NotifyOrder_Fil_Flags.getArray());

boolean trg_Created   = JvArray.contains(LkSNNotifyRuleFlag.Trigger_Created.getCode(), settings.NotifyOrder_Trg_Flags.getArray());
boolean trg_Modified  = JvArray.contains(LkSNNotifyRuleFlag.Trigger_Modified.getCode(), settings.NotifyOrder_Trg_Flags.getArray());
boolean trg_Paid      = JvArray.contains(LkSNNotifyRuleFlag.Trigger_Paid.getCode(), settings.NotifyOrder_Trg_Flags.getArray());
boolean trg_Validated = JvArray.contains(LkSNNotifyRuleFlag.Trigger_Validated.getCode(), settings.NotifyOrder_Trg_Flags.getArray());
boolean trg_Voided    = JvArray.contains(LkSNNotifyRuleFlag.Trigger_Voided.getCode(), settings.NotifyOrder_Trg_Flags.getArray());

boolean exc_Approved  = JvArray.contains(LkSNNotifyRuleFlag.Exclude_Approved.getCode(), settings.NotifyOrder_Exclude_Flags.getArray());
boolean exc_Consignment = JvArray.contains(LkSNNotifyRuleFlag.Exclude_Consignment.getCode(), settings.NotifyOrder_Exclude_Flags.getArray());
boolean exc_Paid      = JvArray.contains(LkSNNotifyRuleFlag.Exclude_Paid.getCode(), settings.NotifyOrder_Exclude_Flags.getArray());
boolean exc_Encoded   = JvArray.contains(LkSNNotifyRuleFlag.Exclude_Encoded.getCode(), settings.NotifyOrder_Exclude_Flags.getArray());
boolean exc_Printed   = JvArray.contains(LkSNNotifyRuleFlag.Exclude_Printed.getCode(), settings.NotifyOrder_Exclude_Flags.getArray());
boolean exc_Validated = JvArray.contains(LkSNNotifyRuleFlag.Exclude_Validated.getCode(), settings.NotifyOrder_Exclude_Flags.getArray());
boolean exc_Completed = JvArray.contains(LkSNNotifyRuleFlag.Exclude_Completed.getCode(), settings.NotifyOrder_Exclude_Flags.getArray());

List<String> notifyOrder_Fil_OrderLocationIdList = new ArrayList<>();
settings.NotifyOrder_Fil_OrderLocationList.forEach(location -> notifyOrder_Fil_OrderLocationIdList.add(location.LocationId.getString()));

List<String> notifyOrder_Fil_OrgCategoryIdList = new ArrayList<>();
settings.NotifyOrder_Fil_OrgCategoryList.forEach(category -> notifyOrder_Fil_OrgCategoryIdList.add(category.CategoryId.getString()));

List<String> notifyOrder_Fil_ProductTagIdList = new ArrayList<>();
settings.NotifyOrder_Fil_ProductTagList.forEach(productTag -> notifyOrder_Fil_ProductTagIdList.add(productTag.TagId.getString()));

List<String> notifyOrder_Fil_EventIdList = new ArrayList<>();
settings.NotifyOrder_Fil_EventList.forEach(event -> notifyOrder_Fil_EventIdList.add(event.EventId.getString()));

request.setAttribute("settings", settings);
%>

<v:widget caption="@Common.Options" hint="@Notify.NotifyRuleOrder_Options_Hint" id="notifyorder-options-widget">
  <v:widget-block>
    <v:form-field caption="@Notify.DynamicRecipient">
      <v:lk-combobox lookup="<%=LkSN.OrderNotificationRecipientType%>" field="settings.NotifyOrder_OrderNotificationRecipientType" allowNull="true"/>
    </v:form-field>
    <v:form-field caption="@Notify.SpecificRecipients" hint="@Notify.SpecificRecipients_Hint">
      <v:input-text field="settings.NotifyOrder_AltEmailAddress" />
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="@Common.Template">
      <% JvDataSet dsTemplate = pageBase.getBL(BLBO_DocTemplate.class).getDocTemplateDS(LkSNDocTemplateType.OrderConfirmation); %>
      <v:combobox field="settings.NotifyOrder_DocTemplateId" lookupDataSet="<%=dsTemplate%>" idFieldName="DocTemplateId" captionFieldName="DocTemplateName" allowNull="false"/>
    </v:form-field>
  </v:widget-block>
</v:widget>
<v:widget caption="@Task.Triggers" id="notifyorder-triggers-widget">
  <v:widget-block>
    <v:form-field caption="@Common.Type">
      <v:lk-combobox lookup="<%=LkSN.NotifyRuleOrderTriggerType%>" field="settings.NotifyOrder_Trg_TriggerType" allowNull="false"/>
    </v:form-field>
    <v:form-field id="triggers-status-widget" caption="@Common.Status">
      <v:db-checkbox field="trg_Created"      checked="<%=trg_Created%>"     value="" caption="@Common.Created"/>&nbsp;&nbsp;&nbsp;
      <v:db-checkbox field="trg_Modified"     checked="<%=trg_Modified%>"    value="" caption="@Common.MultiEditModified"/>&nbsp;&nbsp;&nbsp;
      <v:db-checkbox field="trg_Paid"         checked="<%=trg_Paid%>"        value="" caption="@Reservation.Flag_Paid"/>&nbsp;&nbsp;&nbsp;
      <v:db-checkbox field="trg_Validated"    checked="<%=trg_Validated%>"   value="" caption="@Reservation.Flag_Validated"/>&nbsp;&nbsp;&nbsp;
      <v:db-checkbox field="trg_Voided"       checked="<%=trg_Voided%>"      value="" caption="@Common.Voided"/>
    </v:form-field>
                 
    <v:form-field id="triggers-exclude-widget" caption="@Common.Exclude">
      <v:db-checkbox field="exc_Approved"     checked="<%=exc_Approved%>"    value="" caption="@Reservation.Flag_Approved"/>&nbsp;&nbsp;&nbsp;
      <v:db-checkbox field="exc_Consignment"  checked="<%=exc_Consignment%>" value="" caption="@Reservation.Flag_Consigned"/>&nbsp;&nbsp;&nbsp;
      <v:db-checkbox field="exc_Paid"         checked="<%=exc_Paid%>"        value="" caption="@Reservation.Flag_Paid"/>&nbsp;&nbsp;&nbsp;
      <v:db-checkbox field="exc_Encoded"      checked="<%=exc_Encoded%>"     value="" caption="@Reservation.Flag_Encoded"/>&nbsp;&nbsp;&nbsp;
      <v:db-checkbox field="exc_Printed"      checked="<%=exc_Printed%>"     value="" caption="@Reservation.Flag_Printed"/>&nbsp;&nbsp;&nbsp;
      <v:db-checkbox field="exc_Validated"    checked="<%=exc_Validated%>"   value="" caption="@Reservation.Flag_Validated"/>&nbsp;&nbsp;&nbsp;
      <v:db-checkbox field="exc_Completed"    checked="<%=exc_Completed%>"   value="" caption="@Reservation.Flag_Completed"/>
    </v:form-field>
    
    <v:form-field id="triggers-days-widget" caption="@Notify.NotifyRuleNumberOfDays" hint="@Notify.NotifyRuleNumberOfDays_Hint">
      <v:input-text field="daysFromVisitDate" placeholder="0" />
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="@Notify.NotifyRuleTransactionFilters" id="notifyorder-filters-widget">
   <v:widget-block>
     <v:form-field caption="@Common.TransactionType" hint="@Notify.NotifyRuleWorkstationType_Hint">
       <v:lk-combobox lookup="<%=LkSN.TransactionType%>" field="settings.NotifyOrder_Fil_TrnType" allowNull="true"/>
     </v:form-field>
     <v:form-field caption="@Common.DistributionChannel" hint="@Notify.NotifyRuleSaleChannel_Hint">
       <v:lk-combobox lookup="<%=LkSN.WorkstationType%>" field="settings.NotifyOrder_Fil_WksType" allowNull="true"/>
     </v:form-field>
     <v:form-field caption="@Account.Location" hint="@Notify.NotifyRuleLocation_Hint">
       <snp:dyncombo id="settings.NotifyOrder_Fil_LocationId" entityId="<%=settings.NotifyOrder_Fil_LocationId.getString()%>" entityType="<%=LkSNEntityType.Location%>" auditLocationFilter="true"/>
     </v:form-field>
     <v:form-field caption="@Account.OpArea" hint="@Notify.NotifyRuleOpArea_Hint">
  	   <snp:dyncombo id="settings.NotifyOrder_Fil_OpAreaId" entityId="<%=settings.NotifyOrder_Fil_OpAreaId.getString()%>" entityType="<%=LkSNEntityType.OperatingArea%>" auditLocationFilter="true" parentComboId="settings.NotifyOrder_Fil_LocationId"/>
	   </v:form-field>
	   <v:form-field caption="@Common.Workstation" hint="@Notify.NotifyRuleWorkstation_Hint">
	     <snp:dyncombo id="settings.NotifyOrder_Fil_WorkstationId" entityId="<%=settings.NotifyOrder_Fil_WorkstationId.getString()%>" entityType="<%=LkSNEntityType.Workstation%>" auditLocationFilter="true" parentComboId="settings.NotifyOrder_Fil_OpAreaId"/>
	   </v:form-field>
	</v:widget-block>
</v:widget>
<v:widget caption="@Notify.NotifyRuleOrderFilters" id="notifyorder-filters-widget">
  <v:widget-block>
    <v:form-field caption="@Notify.NotifyRuleOrderLocations" hint="@Notify.NotifyRuleOrderLocations_Hint">
      <v:multibox value='<%=JvArray.arrayToString(notifyOrder_Fil_OrderLocationIdList, ",")%>' field="notifyOrder_Fil_OrderLocationIDs" lookupDataSet="<%=pageBase.getBL(BLBO_Account.class).getAccountDS(LkSNEntityType.Location)%>" idFieldName="AccountId" captionFieldName="DisplayName"/>
    </v:form-field>
    <v:form-field caption="@Notify.NotifyRuleOrgCategories" hint="@Notify.NotifyRuleOrgCategories_Hint">
      <v:multibox value='<%=JvArray.arrayToString(notifyOrder_Fil_OrgCategoryIdList, ",")%>' field="notifyOrder_Fil_OrgCategoryIDs" lookupDataSet="<%=pageBase.getBL(BLBO_Category.class).getCategoryAshedTreeDS(LkSNEntityType.Organization)%>" idFieldName="CategoryId" captionFieldName="CategoryName"/>
    </v:form-field>
    <v:form-field caption="@Notify.NotifyRuleProductTags" hint="@Notify.NotifyRuleProductTags_Hint">
      <v:multibox value='<%=JvArray.arrayToString(notifyOrder_Fil_ProductTagIdList, ",")%>' field="notifyOrder_Fil_ProductTagIDs" lookupDataSet="<%=pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType)%>" idFieldName="TagId" captionFieldName="TagName"/>
    </v:form-field>
    <v:form-field caption="@Event.Events" hint="@Notify.NotifyRuleEvents_Hint">
      <v:multibox value='<%=JvArray.arrayToString(notifyOrder_Fil_EventIdList, ",")%>' field="notifyOrder_Fil_EventIDs" lookupDataSet="<%=pageBase.getBL(BLBO_Event.class).getEventDS()%>" idFieldName="EventId" captionFieldName="EventName"/>
    </v:form-field>
    <v:form-field caption="@Common.Status">
      <v:db-checkbox field="fil_Used" checked="<%=fil_Used%>" value="" caption="@Common.Used" hint="@Notify.NotifyRuleUsed_Hint"/>&nbsp;&nbsp;&nbsp;
      <v:db-checkbox field="fil_Approved" checked="<%=fil_Approved%>" value="" caption="@Reservation.Flag_Approved"/>&nbsp;&nbsp;&nbsp;
      <v:db-checkbox field="fil_Paid" checked="<%=fil_Paid%>" value="" caption="@Reservation.Flag_Paid"/>&nbsp;&nbsp;&nbsp;
      <v:db-checkbox field="fil_Encoded" checked="<%=fil_Encoded%>" value="" caption="@Reservation.Flag_Encoded"/>&nbsp;&nbsp;&nbsp;
      <v:db-checkbox field="fil_Validated" checked="<%=fil_Validated%>" value="" caption="@Reservation.Flag_Validated"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script> 
$(document).ready(function() {
  $("#trg_Paid").change(enableDisableCheckBox);
  $("#triggers-status-widget").change(enableDisableCheckBox);
	$("#daysFromVisitDate").val(<%=daysFromVisitDate%>);
	$("#settings\\.NotifyOrder_Trg_TriggerType").change(refreshVisibility);
	
	refreshVisibility();
	
	function refreshVisibility() {
	  setVisible("#triggers-status-widget", $("#settings\\.NotifyOrder_Trg_TriggerType").val() == <%=LkSNNotifyRuleOrderTriggerType.OrderStatusChange.getCode()%>);
	  setVisible("#triggers-days-widget", $("#settings\\.NotifyOrder_Trg_TriggerType").val() != <%=LkSNNotifyRuleOrderTriggerType.OrderStatusChange.getCode()%>);
	  setVisible("#triggers-exclude-widget", $("#settings\\.NotifyOrder_Trg_TriggerType").val() == <%=LkSNNotifyRuleOrderTriggerType.OrderStatusChange.getCode()%>);	  
  }
  
	enableDisableCheckBox();
	
	function enableDisableCheckBox() {
	  let trgFlags = $("#trg_Created, #trg_Modified, #trg_Paid, #trg_Validated, #trg_Voided");
	  let excFlags = $("#exc_Approved, #exc_Consignment, #exc_Paid, #exc_Encoded, #exc_Printed, #exc_Validated, #exc_Completed");
	  let trgChecked = trgFlags.is(":checked");
	  
	  excFlags.each(function() {
	    $(this).prop("disabled", !trgChecked);
	    if (!trgChecked)
	      $(this).prop("checked", false);
	  });
	  	  
	  if ($("#trg_Paid").isChecked()){
	    $("#exc_Paid").attr("disabled", true);
	    $("#exc_Paid").prop("checked", false);
	  }
	  else
	    $("#exc_Paid").removeAttr("disabled");
  }
  
});

var NotifyRuleOrderTriggerType_DaysFromVisitDate = <%=LkSNNotifyRuleOrderTriggerType.DaysFromVisitDate.getCode()%>;

function getOrderLocationList() {
	var list = [];
	var ids = $("#notifyOrder_Fil_OrderLocationIDs").val();
  for (var i=0; i<ids.length; i++) {
    list.push({
      LocationId: ids[i]
    });
  }
  return list;
}

function getOrgCategoryList() {
	var list = [];
 	var ids = $("#notifyOrder_Fil_OrgCategoryIDs").val();
 	for (var i=0; i<ids.length; i++) {
 		list.push({
 	    CategoryId: ids[i]
 	  });
 	}
	return list;
}

function getProductTagList() {
  var list = [];
  var ids = $("#notifyOrder_Fil_ProductTagIDs").val();
  for (var i=0; i<ids.length; i++) {
    list.push({
      TagId: ids[i]
    });
  }
  return list;
}
	
function getEventList() {
  var list = [];
  var ids = $("#notifyOrder_Fil_EventIDs").val();
  for (var i=0; i<ids.length; i++) {
    list.push({
      EventId: ids[i]
    });
  }
  return list;
}

function getFilFlags() {
	var result = "";
	if ($("#fil_Used").isChecked())
		result = result + "<%=LkSNNotifyRuleFlag.Filter_Used.getCode()%>,";
  if ($("#fil_Approved").isChecked())
	  result = result + "<%=LkSNNotifyRuleFlag.Filter_Approved.getCode()%>,";
	if ($("#fil_Paid").isChecked())
	  result = result + "<%=LkSNNotifyRuleFlag.Filter_Paid.getCode()%>,";
	if ($("#fil_Encoded").isChecked())
	  result = result + "<%=LkSNNotifyRuleFlag.Filter_Encoded.getCode()%>,";
	if ($("#fil_Validated").isChecked())
	  result = result + "<%=LkSNNotifyRuleFlag.Filter_Validated.getCode()%>,";
	return result;
}

function getTrgFlags() {
	if ($("#settings\\.NotifyOrder_Trg_TriggerType").val() != <%=LkSNNotifyRuleOrderTriggerType.OrderStatusChange.getCode()%>)
		return null;
	else {
  	var result = "";
    if ($("#trg_Created").isChecked())
	    result = result + "<%=LkSNNotifyRuleFlag.Trigger_Created.getCode()%>,";
	  if ($("#trg_Modified").isChecked())
	    result = result + "<%=LkSNNotifyRuleFlag.Trigger_Modified.getCode()%>,";
	  if ($("#trg_Paid").isChecked())
	    result = result + "<%=LkSNNotifyRuleFlag.Trigger_Paid.getCode()%>,";
	  if ($("#trg_Validated").isChecked())
	    result = result + "<%=LkSNNotifyRuleFlag.Trigger_Validated.getCode()%>,";
	  if ($("#trg_Voided").isChecked())
	    result = result + "<%=LkSNNotifyRuleFlag.Trigger_Voided.getCode()%>,";
	  return result;
	}
  
}
	
function getExcludeFlags() {
	 if ($("#settings\\.NotifyOrder_Trg_TriggerType").val() != <%=LkSNNotifyRuleOrderTriggerType.OrderStatusChange.getCode()%>)
     return null;
   else {
	   var result = "";
	   
	  if ($("#exc_Approved").isChecked())
	    result = result + "<%=LkSNNotifyRuleFlag.Exclude_Approved.getCode()%>,";
	  if ($("#exc_Consignment").isChecked())
	    result = result + "<%=LkSNNotifyRuleFlag.Exclude_Consignment.getCode()%>,";
	  if ($("#exc_Paid").isChecked())
	    result = result + "<%=LkSNNotifyRuleFlag.Exclude_Paid.getCode()%>,";
	  if ($("#exc_Encoded").isChecked())
	    result = result + "<%=LkSNNotifyRuleFlag.Exclude_Encoded.getCode()%>,";
	  if ($("#exc_Printed").isChecked())
	    result = result + "<%=LkSNNotifyRuleFlag.Exclude_Printed.getCode()%>,";
	  if ($("#exc_Validated").isChecked())
	    result = result + "<%=LkSNNotifyRuleFlag.Exclude_Validated.getCode()%>,";
	  if ($("#exc_Completed").isChecked())
	    result = result + "<%=LkSNNotifyRuleFlag.Exclude_Completed.getCode()%>,";
	
	  return result;
  }     
}
  
function getDocData() {
	if ($("#settings\\.NotifyOrder_Trg_TriggerType").val() > <%=LkSNNotifyRuleOrderTriggerType.DaysFrom_Start%>) {
		var result = {
			  DaysFromVisitDate: $("#daysFromVisitDate").val()
		}
		return result;
	}
	else
		return null;
}

function getNotifyRuleOrder_Config() {
	var result = {
			NotifyOrder_OrderNotificationRecipientType: $("#settings\\.NotifyOrder_OrderNotificationRecipientType").val(),
		  NotifyOrder_AltEmailAddress:                $("#settings\\.NotifyOrder_AltEmailAddress").val(),
		  NotifyOrder_DocTemplateId:                  $("#settings\\.NotifyOrder_DocTemplateId").val(),
		  NotifyOrder_DocData:                        getDocData(),
		  NotifyOrder_Fil_TrnType:                    $("#settings\\.NotifyOrder_Fil_TrnType").val(),
		  NotifyOrder_Fil_WksType:                    $("#settings\\.NotifyOrder_Fil_WksType").val(),
		  NotifyOrder_Fil_LocationId:                 $("#settings\\.NotifyOrder_Fil_LocationId").val(),
		  NotifyOrder_Fil_OpAreaId:                   $("#settings\\.NotifyOrder_Fil_OpAreaId").val(),
		  NotifyOrder_Fil_WorkstationId:              $("#settings\\.NotifyOrder_Fil_WorkstationId").val(),
		  NotifyOrder_Fil_OrderLocationList:          getOrderLocationList(),
		  NotifyOrder_Fil_OrgCategoryList:            getOrgCategoryList(),
		  NotifyOrder_Fil_ProductTagList:             getProductTagList(),
		  NotifyOrder_Fil_EventList:                  getEventList(),
		  NotifyOrder_Fil_Flags:                      getFilFlags(),
		  NotifyOrder_Trg_TriggerType:                $("#settings\\.NotifyOrder_Trg_TriggerType").val(),
		  NotifyOrder_Trg_Flags:                      getTrgFlags(),
 	    NotifyOrder_Exclude_Flags:                  getExcludeFlags()
	};
	return result;
} 

</script>