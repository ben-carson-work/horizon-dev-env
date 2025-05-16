<%@page import="java.util.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
boolean canEdit = true;
String[] transactionSurveyIDs = pageBase.getBL(BLBO_Survey.class).getShopCartSurvey(LkSNTransactionType.ManualEntryLedger).tranSurveyIDs;
String[] trnSurveyMaskIDs = pageBase.getBL(BLBO_Survey.class).getMaskIDsBySurvey(transactionSurveyIDs);
String maskEditURL = pageBase.getContextURL() + "?page=maskedit_widget&LoadData=true&id=new&EntityType=" + LkSNEntityType.LedgerManual.getCode();

String ticketId  = pageBase.getNullParameter("TicketId");
boolean ticketPaid  = JvString.isSameString(pageBase.getNullParameter("TicketPaid"), "true");
Map<String, String> mapClearing = new HashMap<>(); // GateCategoryId, Amount

if (ticketId != null)
  mapClearing = pageBase.getBL(BLBO_Ticket.class).fillClearingLeftMap(ticketId);

long totClearingLeft = 0;
for (String amount : mapClearing.values()) 
  totClearingLeft += JvString.strToMoneyDef(amount, 0);
%>

<v:dialog id="ledgermanual_dialog" width="1000" height="700" title="@Ledger.ManualEntry">
<v:page-form id="ledgermanual-form">
<div class="wizard">
  <div class="wizard-step wizard-step-params">
    <div class="wizard-step-title"><v:itl key="@ManualRedemption.Parameters"/></div>
    <div class="wizard-step-content">

	  <div id="maskedit-container"></div>
	  
	  <v:widget caption="@Common.General">
	    <v:widget-block>
	      <v:form-field caption="@Account.Location" mandatory="true">
          <v:combobox id="LocationId" lookupDataSet="<%=pageBase.getBL(BLBO_Account.class).getLocationDS(true)%>" idFieldName="AccountId" captionFieldName="DisplayName" codeFieldName="AccountCode" allowNull="false" />
        </v:form-field>
		    <v:form-field caption="@Common.DateTime" hint="@Ledger.ManualLedgerDateTimeHint" checkBoxField="LedgerLocalDateTime">
          <v:input-text type="datetimepicker" field="LedgerLocalDateTimeField" style="width:200px"/>
        </v:form-field>
      </v:widget-block>
      <v:widget-block>
        <v:form-field caption="@Common.Description">
          <v:input-text field="LedgerManualDescription"/>
        </v:form-field>
	    </v:widget-block>
	  </v:widget>

	  <% if ((ticketId != null) && (ticketPaid) && (totClearingLeft != 0)) { %>
		  <% JvDataSet dsGateCategory = pageBase.getBL(BLBO_GateCategory.class).getGateCategoriesByTicketIdDS(ticketId); %>    
	    <v:widget caption="@Common.Clearing">
	      <v:widget-block>
	        <v:form-field caption="@Ledger.AffectClearingLimit" checkBoxField="LedgerManual_AffectClearingLimit">
              <% boolean emptyGateCategory = dsGateCategory.isEmpty(); %> 
	            <select name="LedgerManual_GateCategoryId" id="LedgerManual_GateCategoryId" class="form-control">
	          	  <% if (!emptyGateCategory) {%>
			        <% while (!dsGateCategory.isEof()) { %>
			          <% String gateCategoryId = dsGateCategory.getField("GateCategoryId").getString(); %>
			          <option value="<%=gateCategoryId%>" data-Amount="<%=mapClearing.get(gateCategoryId)%>"><%=dsGateCategory.getField("GateCategoryName").getString()%></option>
			          <% dsGateCategory.next(); %>
			        <% } %>
			      <% } else { %>
		            <option value="DEFAULT" data-Amount="<%=mapClearing.get("DEFAULT")%>"></option>
		          <% } %>	        
	            </select>
	        </v:form-field>
			    <v:form-field id="ClearingLeftAmountField" caption="@Ledger.ClearingLeft">
	          <v:input-text field="ClearingLeftAmount" enabled="false"/>
    		  </v:form-field>
	      </v:widget-block>
	    </v:widget>	  
	  <% } %>
	  <table style="width:100%">
	    <tr id="ledger-entry-table">
	      <td colspan="100%">
	        <%-- ENTRIES --%>
	        <v:grid id="rule-detail-grid">
	          <thead>
	            <v:grid-title caption="@Common.Entries"/>
	            <tr>
	              <td><v:grid-checkbox header="true"/></td>
	              <td width="40%">
	                <v:itl key="@Account.Account"/>
	              </td>
	              <td width="40%">
	                <v:itl key="@Account.Location"/>
	              </td>
	              <td width="10%">
	  		  	    <v:itl key="@Ledger.LedgerDebit"/>
	              </td>
	              <td width="10%">
				    <v:itl key="@Ledger.LedgerCredit"/><br/>
	              </td>
	            </tr>
	          </thead>
	          <tbody id="entry-ledger-body">
	          </tbody>
	          <tbody>
	            <tr>
	              <td colspan="100%">
	                <v:button caption="@Common.Add" fa="plus" onclick="addEntry()" enabled="true"/>
	                <v:button caption="@Common.Remove" fa="minus" onclick="removeEntries()" enabled="true"/>
	              </td>
	            </tr>
	          </tbody>
	        </v:grid>
	      </td>
	    </tr>
	  </table>
	
	  <div id="ledger-entry-templates" class="hidden">
	    <snp:dyncombo clazz="LedgerAccountTemplate-Select" field="LedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" allowNull="false" showItemCode="true" enabled="<%=canEdit%>"/>  
	    <v:combobox clazz="LocationTypeTemplate-Select" lookupDataSet="<%=pageBase.getBL(BLBO_Account.class).getLocationDS(true)%>" idFieldName="AccountId" captionFieldName="DisplayName" codeFieldName="AccountCode" allowNull="false"/>
	    <input type="text" class="form-control LedgerAccounDebitValue"/>
	    <input type="text" class="form-control LedgerAccounCreditValue"/>
	  </div>
    </div>
  </div>
  
   <div class="wizard-step wizard-step-survey">
     <div class="wizard-step-title"><v:itl key="@Media.StatusWizard_Survey"/></div>
     <div class="wizard-step-content"></div>
   </div>
    
  <div class="wizard-step">
    <div class="wizard-step-title"><v:itl key="@Media.StatusWizard_Notes"/></div>
    <div class="wizard-step-content">
      <v:input-txtarea field="LedgerManual_Notes" rows="16"/>
       <% if (/* canCreateNoteType */ true) { %>
        <v:widget>
          <v:widget-block>
            <v:db-checkbox field="NoteHighlighted" value="true" caption="@Common.Highlighted"/>
          </v:widget-block>
        </v:widget>
      <% } %>
    </div>
  </div>
</div>

<script>
  $dlg = $("#ledgermanual_dialog");
  var $wizard = $dlg.find(".wizard");
  var $stepParams = $wizard.find(".wizard-step-params");
  var $stepSurvey = $wizard.find(".wizard-step-survey");
  var trnSurveyMaskIDs = <%=JvString.jsString(JvArray.arrayToString(trnSurveyMaskIDs, ","))%>;
  var transactionMetaDataList = [];
  
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
        click: function() {
          doSaveManualEntry(function() {
            $dlg.dialog("close");
            <% if (ticketId != null) { %>
              window.location.reload();
            <% } else { %>
              triggerEntityChange(<%=LkSNEntityType.LedgerGroup.getCode()%>);
            <% } %>
          });
        }
      },
      {
        text: itl("@Common.Close"),
        click: doCloseDialog
      }
    ]; 
    
    addDefaultEntries();
    
    $(".LedgerAccounDebitValue").keyup(enableDisableAccValue);
    $(".LedgerAccounCreditValue").keyup(enableDisableAccValue);
    
    $("input[name='LedgerManual_AffectClearingLimit']").change(refreshGateCategory);
    
    $("#LedgerManual_GateCategoryId").change(refreshDefaultAmount);
    refreshGateCategory();
    refreshDefaultAmount();
    
    $("input[name='LedgerManual_AffectClearingLimit']").click()
    
  });
  
  $dlg.find("#LedgerLocalDateTimeField-picker").datepicker("setDate", new Date());
  $dlg.find("#LedgerLocalDateTimeField-HH").val(<%=JvString.jsString(JvString.leadZero(rights.FiscalDateSwitchHour.getInt(), 2))%>);
  $dlg.find("#LedgerLocalDateTimeField-MM").val("00");
  
  asyncLoad("#maskedit-container", <%=JvString.jsString(maskEditURL)%>);
  
  if (trnSurveyMaskIDs == "")
    $stepSurvey.remove();
  else {
    window.metaFields = {};
    asyncLoad($stepSurvey.find(".wizard-step-content"), addTrailingSlash(BASE_URL) + "admin?page=maskedit_widget&MaskIDs=" + trnSurveyMaskIDs);
  }
  
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
    if ($stepParams.is(".active")) {
      _validation(function() {
        $wizard.vWizard("next");
      });
    }
    else if ($stepSurvey.is(".active")) {
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
  
function _validateMetaData(callback) {
  transactionMetaDataList = prepareMetaDataArray($stepSurvey);
  checkRequired($stepSurvey, function() {
    var reqDO = {
      Command: "ValidateMetaData",
      ValidateMetaData: {
        EntityType: <%=LkSNEntityType.Transaction.getCode()%>,
        MetaDataList: transactionMetaDataList
      }
    };
    
    showWaitGlass();
    vgsService("MetaData", reqDO, false, function(ansDO) {
      hideWaitGlass();
      callback();
    });
  });
}

function roundedValue(value) {
	return Math.round(value * 10000) / 10000;
}

function _validation(callback) {
  var entryNumber = $("#entry-ledger-body .entryledger-item").length;
  var affectClearingLimit = $("#LedgerManual_AffectClearingLimit").isChecked();
  
  try {
    var ledgerTotalAmounts = calculateTotalLedgerAmounts();
    var totalCreditAmount = ledgerTotalAmounts.CreditAmount;
    var totalDebitAmount = ledgerTotalAmounts.DebitAmount;
    
    var gateCatObj = $("#LedgerManual_GateCategoryId").find(":selected");
    var suggestedAmount = parseFloat(gateCatObj.attr("data-Amount")); 
  
    checkLedgerAccount();
    
    if (entryNumber < 2)
      throw itl("@Ledger.ManualLedgerMinEntryNumberError");
    
    if (totalCreditAmount == 0)
      throw itl("@Ledger.ManualLedgerTotalCreditAmountError");
    
    if (roundedValue(totalDebitAmount) != roundedValue(totalCreditAmount))
      throw itl("@Ledger.ManualLedgerTotalAmountError", roundedValue(totalDebitAmount), roundedValue(totalCreditAmount));
    
    if ((totalCreditAmount > 0) && (roundedValue(totalCreditAmount) > roundedValue(suggestedAmount))) 
      throw itl("@Ledger.ManualLedgerTotalAmountExceedsClearingLeftError");
    
    if (affectClearingLimit) {
      if ((totalCreditAmount < 0) && (suggestedAmount > 0)) 
        throw itl("@Ledger.ManualLedgerAmountNegativeError");
      else if (affectClearingLimit && (totalCreditAmount < 0) && (roundedValue(totalCreditAmount) < roundedValue(suggestedAmount)))
        throw itl("@Ledger.ManualLedgerAmountTooNegativeError");
      else if (affectClearingLimit && (totalCreditAmount > 0) && (roundedValue(totalCreditAmount) > roundedValue(suggestedAmount))) 
        throw itl("@Ledger.ManualLedgerAmountTooHighError");
    }
    callback();
  }
  catch (err) {
    showMessage(err);
  }
}

function enableDisableAccValue() {
  var $this = $(this);
  var $entryLedgerRow = $this.closest(".entryledger-item");
  
  if ($this.hasClass("LedgerAccounDebitValue"))
    var $obj = $entryLedgerRow.find(".LedgerAccounCreditValue");
  else if ($this.hasClass("LedgerAccounCreditValue"))
    var $obj = $entryLedgerRow.find(".LedgerAccounDebitValue");
  
  $obj.attr("disabled", $this.val() != "");
}

function refreshGateCategory() {
  $("#ClearingLeftAmountField").setClass("hidden", !$("input[name='LedgerManual_AffectClearingLimit']").isChecked());
  
  refreshDefaultAmount();
}

function refreshDefaultAmount() {
  var obj = $("#LedgerManual_GateCategoryId").find(":selected");
  $("#ClearingLeftAmount").val(obj.attr("data-Amount"));
}

function calculateTotalLedgerAmounts() {
  var totalLedgerAmounts = {};
  var $entryLedgerItems = $("#entry-ledger-body .entryledger-item");
  var totalCreditAmount = 0;
  var totalDebitAmount = 0;

  $entryLedgerItems.each(function(index, obj) {
	  
    creditAmount = parseFloatOrNull($(obj).find(".LedgerAccounCreditValue").val());
    debitAmount = parseFloatOrNull($(obj).find(".LedgerAccounDebitValue").val());
    
    if (isNaN(creditAmount) || isNaN(debitAmount))
      throw itl("@Common.InvalidValue");
    else {
      if (creditAmount != null)
        totalCreditAmount = totalCreditAmount + creditAmount;
      if (debitAmount != null)
        totalDebitAmount = totalDebitAmount + debitAmount;
    }
  });
  
  totalLedgerAmounts.CreditAmount = totalCreditAmount;
  totalLedgerAmounts.DebitAmount = totalDebitAmount;
  
  return totalLedgerAmounts;
}

function checkLedgerAccount() {
  var ledgerAccountIDs = [];
  var $entryLedgerItems = $("#entry-ledger-body .entryledger-item");

  $entryLedgerItems.each(function(index, obj) {
    ledgerAccountIDs.push($(obj).find(".LedgerAccountTemplate-Select").val());
  });

  if (ledgerAccountIDs.every((val, i, arr) => val === arr[0]))
    throw itl("@Ledger.ManualLedgerAccountsError");
}

function doSaveManualEntry(callback) {
  var metaDataList = prepareMetaDataArray($stepParams);
  var affectClearingLimit = $("input[name='LedgerManual_AffectClearingLimit']").isChecked();
  var ledgerTotalAmounts = calculateTotalLedgerAmounts();
  var totalCreditAmount = ledgerTotalAmounts.CreditAmount;
  var obj = $("#LedgerManual_GateCategoryId").find(":selected");
  var suggestedAmount = parseFloat(obj.attr("data-Amount"));  
  var gateCategoryId = $("#LedgerManual_GateCategoryId").val();
  if (gateCategoryId==="DEFAULT")
   	gateCategoryId = null;
  
  var reqDO = {
    Command: "SaveManualEntry",
    SaveManualEntry: {
      ManualEntry: {
        LedgerLocalDateTime: $dlg.find('input[name ="LedgerLocalDateTime"]').isChecked() ? $("#LedgerLocalDateTimeField-picker").getXMLDateTime() : null,
        LocationId: $("#LocationId").val(),
        LedgerManualDescription: $("#LedgerManualDescription").val(),
        NoteType: $("#NoteHighlighted").isChecked() ? <%=LkSNNoteType.Highlighted.getCode()%> : <%=LkSNNoteType.Standard.getCode()%>,
        Note: $("#LedgerManual_Notes").val() == "" ? null : $("#LedgerManual_Notes").val(),
        TicketId: <%=JvString.jsString(ticketId)%>,
        AffectClearingLimit: affectClearingLimit,
        GateCategoryId: affectClearingLimit ? gateCategoryId : null,
        ManualEntryItemList: [],
        MetaDataList: metaDataList
      },
      ApproveManualEntry: {
        TransactionMetaDataList: transactionMetaDataList,
        TransactionMaskList: [],
        NoteType: $("#NoteHighlighted").isChecked() ? <%=LkSNNoteType.Highlighted.getCode()%> : <%=LkSNNoteType.Standard.getCode()%>,
        Note: $("#LedgerManual_Notes").val() == "" ? null : $("#LedgerManual_Notes").val()
      }
    }
  };
  
  if (trnSurveyMaskIDs.length > 0) {
    $(trnSurveyMaskIDs.split(",")).each(function(index, maskId) {
      reqDO.SaveManualEntry.ApproveManualEntry.TransactionMaskList.push({"MaskId":maskId});
    });
  }
  
  var $entryLedgerItems = $("#entry-ledger-body .entryledger-item");
  $entryLedgerItems.each(function(index, obj) {
    var entryItem = {};
    var accountId = $(obj).find(".LedgerAccountTemplate-Select").val();
    var locationId = $(obj).find(".LocationTypeTemplate-Select").val();
    var debitAmount = $(obj).find(".LedgerAccounDebitValue").val();
    var creditAmount = $(obj).find(".LedgerAccounCreditValue").val();
    
    entryItem.LedgerAccountId = accountId;
    entryItem.LocationId = locationId;
    entryItem.LedgerDebitAmount = debitAmount=="" ? null : debitAmount;
    entryItem.LedgerCreditAmount = creditAmount=="" ? null : creditAmount;
    
    reqDO.SaveManualEntry.ManualEntry.ManualEntryItemList.push(entryItem);
  });

  if (affectClearingLimit && (totalCreditAmount < suggestedAmount)) {
    confirmDialog(itl("@Ledger.ManualLedgerAmountTooLowWarning"), function() {
      vgsService("Ledger", reqDO, false, function(ansDO) {
    	 if (callback)
    		callback();
    	});
      });
    }
    else if (affectClearingLimit && (totalCreditAmount < 0)) {
       confirmDialog(itl("@Ledger.ManualLedgerAmountNegativeWarning"), function() {
         vgsService("Ledger", reqDO, false, function(ansDO) {
           if (callback)
             callback();
         });
       });
     } 
  else 
    vgsService("Ledger", reqDO, false, function(ansDO) {
	  if (callback)
	    callback();
    });
}

function addDefaultEntries() {
  addEntry();
  addEntry();
}

function addEntry() {
  var serialNumber = parseInt($(".entryledger-item").last().find(".serial-number input").val());
  var serialNumber = isNaN(serialNumber) ? 0 : serialNumber + 1;
  var tr = $("<tr class='grid-row entryledger-item'/>").appendTo("#entry-ledger-body");

  var tdCB = $("<td class='cb serial-number'/>").appendTo(tr);
  var tdAcc = $("<td/>").appendTo(tr);
  var tdLocation = $("<td/>").appendTo(tr);
  var tdDebitValue = $("<td/>").appendTo(tr);
  var tdCreditValue = $("<td/>").appendTo(tr);

  tdCB.append("<input value='" + serialNumber + "' type='checkbox' class='cblist'>");
  
  $("#ledger-entry-templates .LedgerAccountTemplate-Select").attr("id", "LedgerAccount_" + serialNumber).clone().appendTo(tdAcc);
  $("#ledger-entry-templates .LocationTypeTemplate-Select").attr("id", "LedgerLocation_" + serialNumber).clone().appendTo(tdLocation);
  
  $("#ledger-entry-templates .LedgerAccounDebitValue").clone().appendTo(tdDebitValue);
  $("#ledger-entry-templates .LedgerAccounCreditValue").clone().appendTo(tdCreditValue);
  
  $(".LedgerAccounDebitValue").keyup(enableDisableAccValue);
  $(".LedgerAccounCreditValue").keyup(enableDisableAccValue);
} 

function removeEntries() {
  var ids = $(".cb.serial-number input").getCheckedValues()
  if (ids == "")
    showMessage(itl("@Common.NoElementWasSelected"));
  else {
    $(".cb.serial-number input").filter(":checked").closest(".entryledger-item").remove();
  }
} 
</script>

</v:page-form>
</v:dialog>

