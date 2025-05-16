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
boolean canCreateNoteType = LkSNHighlightedNoteRightLevel.Create.check(rights.HighlightedNote);  
boolean canManualExport = rights.ManualExportInstallmentContract.getBoolean();

String[] transactionSurveyIDs = pageBase.getBL(BLBO_Survey.class).getShopCartSurvey(LkSNTransactionType.TicketUpdate).tranSurveyIDs;
String[] maskIDs = pageBase.getBL(BLBO_Survey.class).getMaskIDsBySurvey(transactionSurveyIDs);

String contractId = pageBase.getEmptyParameter("contractid");
%>

<v:dialog id="contract_export_dialog" title="@Installment.SetContractAsExported" width="800" height="600" autofocus="false">
<div class="wizard">
    <div class="wizard-step wizard-step-info">
      <div class="wizard-step-title"><v:itl key="@Common.Info"/></div>
      <div class="wizard-step-content">
        <v:alert-box type="info" title=""><v:itl key="@Installment.SetContractAsExportedWizardInfo"/></v:alert-box>
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
    

  </div>
<script>
//# sourceURL=contract_export_dialog.jsp
$(document).ready(function() {
  var $dlg = $("#contract_export_dialog");
  var $wizard = $dlg.find(".wizard");
  var $stepSurvey = $wizard.find(".wizard-step-survey"); 
  var maskIDs = <%=JvString.jsString(JvArray.arrayToString(maskIDs, ","))%>;
  
  var metaDataList = [];
  
  $dlg.on("snapp-dialog", function(event, params) {
     params.open = _enableDisable;
     params.buttons = [
       dialogButton("@Common.Back", _previousStep, "btn-back"),
       dialogButton("@Common.Continue", _nextStep, "btn-continue"),
       dialogButton("@Common.Confirm", _confirm, "btn-confirm"),
       dialogButton("@Common.Close", doCloseDialog)
     ]; 
   });
  
  if (maskIDs == "")
    $stepSurvey.remove();
  else {
    window.metaFields = {};
    asyncLoad($stepSurvey.find(".wizard-step-content"), addTrailingSlash(BASE_URL) + "admin?page=maskedit_widget&MaskIDs=" + maskIDs);
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
  
  function _confirm() {
    confirmDialog(null, function() {
      var noteType = $dlg.find("#NoteHighlighted").isChecked() ? <%=LkSNNoteType.Highlighted.getCode()%> : <%=LkSNNoteType.Standard.getCode()%>;
      var reqDO = {
        Command: "SetManuallyExported",
        SetManuallyExported: {
     	 LocateInstallmentContractList: [{InstallmentContractId:<%=JvString.jsString(contractId)%>}],
     	 Transaction: {
     	   Note: $("#Note").val()=="" ? null : $("#Note").val(),
     	   NoteType: noteType, 
           TransactionSurveyMetaDataList: metaDataList,
           TransactionMaskList: []
     	 }
        }
      };
      
      
      if (maskIDs.length > 0) {
        $(maskIDs.split(",")).each(function(index, elem) {
          reqDO.SetManuallyExported.Transaction.TransactionMaskList.push({"MaskId":elem});
        });
      }
      
      
      showWaitGlass();
      vgsService("Installment", reqDO, false, function(ansDO) {
        window.location.reload();
        hideWaitGlass(); 
      });
    });
  }
  
  function _validateMetaData(callback) {
    metaDataList = prepareMetaDataArray($stepSurvey);
    checkRequired($stepSurvey, function() {
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
    });
  }
});
</script>

</v:dialog>
