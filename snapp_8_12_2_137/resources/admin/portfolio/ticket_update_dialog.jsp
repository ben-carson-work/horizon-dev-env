<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="vgs-tags" prefix="v" %>
<%@taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
String queryBase64 = pageBase.getNullParameter("QueryBase64");
boolean canCreateNoteType = LkSNHighlightedNoteRightLevel.Create.check(rights.HighlightedNote);  
boolean multiEdit = pageBase.getNullParameter("multiEdit") != null;
boolean enableExpirationDate = LkSNRightChangeProductValidities.OnlyOnFlaggedProduct.check(rights.ProductExpDate);
boolean enableStartValidity = LkSNRightChangeProductValidities.OnlyOnFlaggedProduct.check(rights.ChangeStartValidity);
boolean enableIgnoreCrossoverConstraints = rights.UpdateIgnoreCrossoverTimeRestrictions.getBoolean();

String requiredTicketStatus = pageBase.getEmptyParameter("ticketStatus");
boolean requireBlock = (multiEdit || requiredTicketStatus.equals("block"));
boolean requireUnblock = (multiEdit || requiredTicketStatus.equals("unblock"));
List<LookupItem> ticketStatuses = new ArrayList<>();
if (requireUnblock && (rights.TicketManualBlockUnblock.getBoolean() || rights.TicketSupervisorBlockUnblock.getBoolean()))
  ticketStatuses.add(LkSNTicketStatus.Active);
if (requireBlock && rights.TicketManualBlockUnblock.getBoolean())
  ticketStatuses.add(LkSNTicketStatus.ManuallyBlocked);
if (requireBlock && rights.TicketSupervisorBlockUnblock.getBoolean())
  ticketStatuses.add(LkSNTicketStatus.SupervisorBlocked);

String enableStatus = rights.TicketManualBlockUnblock.getBoolean() ? "" : "disabled";
String[] ticketIDs = JvArray.stringToArray(pageBase.getNullParameter("ticketIDs"), ",");
String[] transactionSurveyIDs = pageBase.getBL(BLBO_Survey.class).getShopCartSurvey(LkSNTransactionType.TicketUpdate).tranSurveyIDs;
String[] maskIDs = pageBase.getBL(BLBO_Survey.class).getMaskIDsBySurvey(transactionSurveyIDs);
int[] steps = JvArray.stringToIntArray(pageBase.getNullParameter("TicketUpdateSteps"), ",");
%>

<v:dialog id="ticket_update_dialog" title="@Lookup.TransactionType.TicketUpdate" width="800" height="600" autofocus="false">
  <style>
    #ticket_update_dialog .form-field-caption {width:35%}
    #ticket_update_dialog .form-field-value {margin-left:40%}
  </style>

  <div class="wizard">    
    <div class="wizard-step wizard-step-validity">
      <div class="wizard-step-title"><v:itl key="@Common.Validity"/></div>
      <div class="wizard-step-content">
        <v:widget caption="@Common.Parameters">
          <v:widget-block>
            <v:form-field id="start-validity" caption="@Ticket.StartValidity" checkBoxField="start-validity" enabled="<%=enableStartValidity%>">
              <v:input-text type="datepicker" field="startValidity" placeholder="@Common.Unlimited" enabled="<%=enableStartValidity%>"/>
            </v:form-field>  
            <v:form-field id="exp-date" caption="@Common.Expiration" checkBoxField="exp-date" enabled="<%=enableExpirationDate%>">
              <v:input-text type="datepicker" field="expirationDate" placeholder="@Common.Unlimited" enabled="<%=enableExpirationDate%>"/>
            </v:form-field>  
            <v:form-field id="ignore-crossover-time-until-date" caption="@Ticket.IgnoreCrossoverTimeUntilDate" hint="@Ticket.IgnoreCrossoverTimeUntilDateHint" checkBoxField="ignore-crossover-time-until-date" enabled="<%=enableIgnoreCrossoverConstraints%>">
              <v:input-text type="datepicker" field="ignoreCrossoverTimeUntilDate" placeholder="@Common.Unlimited" enabled="<%=enableIgnoreCrossoverConstraints%>"/>
            </v:form-field>  
          </v:widget-block>
        </v:widget>       
      </div>
    </div>
    
    <div class="wizard-step wizard-step-status">
      <div class="wizard-step-title"><v:itl key="@Common.Status"/></div>
      <div class="wizard-step-content">
        <v:widget caption="@Common.Parameters">
          <v:widget-block>
	          <v:form-field id="tck-status" caption="@Common.Status" checkBoxField="tck-status">
              <v:lk-combobox field="tckStatus" lookup="<%=LkSN.TicketStatus%>" limitItems="<%=ticketStatuses%>" allowNull="false"/>
            </v:form-field>
          </v:widget-block>
        </v:widget>       
      </div>
    </div>
    
    <div class="wizard-step wizard-step-survey">
      <div class="wizard-step-title"><v:itl key="@Media.StatusWizard_Survey"/></div>
      <div class="wizard-step-content"></div>
    </div>
    
    <div class="wizard-step">
      <div class="wizard-step-title"><v:itl key="@Media.StatusWizard_Notes"/></div>
      <div class="wizard-step-content">
        <v:input-txtarea field="Note" rows="16"/>
        <% if (canCreateNoteType) { %>
          <v:widget>
            <v:widget-block>
              <v:db-checkbox field="NoteHighlighted" value="true" caption="@Common.Highlighted"/>
            </v:widget-block>
          </v:widget>
        <% } %>
      </div>
    </div>

<script>

  var $dlg = $("#ticket_update_dialog");
  var $wizard = $dlg.find(".wizard");
  var $stepExpDate = $wizard.find(".wizard-step-validity");
  var $stepStatus = $wizard.find(".wizard-step-status");
  var $stepSurvey = $wizard.find(".wizard-step-survey"); 
  var multiEdit = <%=multiEdit%>;
  var maskIDs = <%=JvString.jsString(JvArray.arrayToString(maskIDs, ","))%>;
  var ticketIDs = <%=JvString.jsString(JvArray.arrayToString(ticketIDs, ","))%>;
  
  var metaDataList = [];

 $dlg.on("snapp-dialog", function(event, params) {
   params.open = _enableDisable;
   params.buttons = [
     {
       id: "btn-back",
       text: itl("@Common.Back"),
       click: _previousStep
     },
     {
       id: "btn-continue",
       text: itl("@Common.Continue"),
       click: _nextStep
     },
     {
       id: "btn-confirm",
       text: itl("@Common.Confirm"),
       click: _confirm
     },
     {
       text: itl("@Common.Close"),
       click: doCloseDialog
     }
   ]; 
 });
 
 if (maskIDs == "")
   $stepSurvey.remove();
 else {
   window.metaFields = {};
   asyncLoad($stepSurvey.find(".wizard-step-content"), addTrailingSlash(BASE_URL) + "admin?page=maskedit_widget&MaskIDs=" + maskIDs);
 }
 
 <% if (!JvArray.contains(LkSNTicketUpdateStep.Validity.getCode(), steps)) { %>
   $stepExpDate.remove();
 <% } %>
 
 <% if (!JvArray.contains(LkSNTicketUpdateStep.Status.getCode(), steps)) { %>
   $stepStatus.remove();
 <% } %>
 
 <% if (!multiEdit && (steps.length == 1) && JvArray.contains(LkSNTicketUpdateStep.Status.getCode(), steps)) {%>
   $dlg.find("[name='tck-status']").click();
 <% } %>
 
 $wizard.vWizard({
   onStepChanged: _enableDisable
 });
 
 function _enableDisable() {
   var confirm = ($wizard.vWizard("activeIndex") == $wizard.vWizard("length") - 1);
   var lastStep = ($wizard.vWizard("activeIndex") == $wizard.vWizard("length"));
   var firstStep = ($wizard.vWizard("activeIndex") == 0);
   var $buttonPane = $dlg.siblings(".ui-dialog-buttonpane");
   $buttonPane.find("#btn-continue").setClass("hidden", confirm || lastStep);
   $buttonPane.find("#btn-confirm").setClass("hidden", !confirm || lastStep);
   $buttonPane.find("#btn-back").setClass("hidden", firstStep || lastStep);
 }
 
 function _nextStep() {
   if ($stepSurvey.is(".active")) {
     _validateMetaData(function() {
       $wizard.vWizard("next");
     });
   }
   else
     $wizard.vWizard("next");
 }
 
 function _previousStep() {
   $wizard.vWizard("prior");
 }
 
 function _isSetField(selector) {
	 var $comp = $(selector);
			 
	 if ($comp.length == 0)
		 return false;
	 
	 if ($comp.attr("disabled") == "disabled")
		 return false;

   var $checkbox = $comp.closest(".form-field").find(".form-field-caption input[type='checkbox']");
   if (($checkbox.length > 0) && !$checkbox.isChecked())
     return false;
	 
	 return true;
 }

 function _confirm() {
   confirmDialog(null, function() {
     var noteType = $dlg.find("#NoteHighlighted").isChecked() ? <%=LkSNNoteType.Highlighted.getCode()%> : <%=LkSNNoteType.Standard.getCode()%>;
     var reqDO = {
       Command: "UpdateTicket",
       UpdateTicket: {
         TicketList: [],
         QueryBase64: <%=JvString.jsString(queryBase64)%>,
         AddNote: $("#Note").val()=="" ? null : $("#Note").val(),
         NoteType: noteType,
		     TransactionSurveyMetaDataList: metaDataList,
		     TransactionMaskList: []
       }
     };
     
     if (ticketIDs != ""){
	   $(ticketIDs.split(",")).each(function(index, elem) {
	     reqDO.UpdateTicket.TicketList.push({"TicketId":elem});
	   });
     }
     
     if (maskIDs.length > 0) {
       $(maskIDs.split(",")).each(function(index, elem) {
         reqDO.UpdateTicket.TransactionMaskList.push({"MaskId":elem});
       });
     }
     
     if (_isSetField("#expirationDate-picker"))
       reqDO.UpdateTicket.ValidDateTo = $("#expirationDate-picker").getXMLDate();
     
     if (_isSetField("#startValidity-picker"))
       reqDO.UpdateTicket.ValidDateFrom = $("#startValidity-picker").getXMLDate();
     
     if (_isSetField("#ignoreCrossoverTimeUntilDate-picker"))
       reqDO.UpdateTicket.IgnoreCrossoverTimeUntilDate = $("#ignoreCrossoverTimeUntilDate-picker").getXMLDate();
     
     if (_isSetField("#tckStatus"))
       reqDO.UpdateTicket.TicketStatus = $("#tckStatus").val();
     
     showWaitGlass();
     vgsService("Ticket", reqDO, false, function(ansDO) {
       window.location.reload();
       hideWaitGlass(); 
     });
   });
 }
 
 function _validateMetaData(callback) {
   metaDataList = prepareMetaDataArray($stepSurvey);
     checkRequired($stepSurvey, function() {
    	 if (metaDataList && metaDataList.length > 0) {
			     var reqDO = {
			       Command: "ValidateMetaData",
			       ValidateMetaData: {
			         EntityType: <%=LkSNEntityType.Transaction.getCode()%>,
			         MetaDataList: metaDataList
			       }
			     };
			     showWaitGlass();
			     vgsService("MetaData", reqDO, false, function(ansDO) {
			       hideWaitGlass();
			       callback();
			     });
    	 } else
    		 callback();
   });
    
 }
 

</script>

</v:dialog>
