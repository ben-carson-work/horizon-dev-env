<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.List"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
String ticketUsageId = pageBase.getEmptyParameter("ticketUsageId"); 

String[] transactionSurveyIDs = pageBase.getBL(BLBO_Survey.class).getShopCartSurvey(LkSNTransactionType.RedemptionVoid).tranSurveyIDs;
String[] maskIDs = pageBase.getBL(BLBO_Survey.class).getMaskIDsBySurvey(transactionSurveyIDs);
boolean canCreateNoteType = LkSNHighlightedNoteRightLevel.Create.check(rights.HighlightedNote);
%>

<v:dialog id="accesslog_voidredemption_dialog" title="@Lookup.TransactionType.RedemptionVoid" width="800" height="600" autofocus="false">

  <style>
    #accesslog_voidredemption_dialog .status-label {
      display: block;
    }
    
    #accesslog_voidredemption_dialog .progress {
      margin-bottom: 0;
    }
  </style>

  <div class="wizard">
    
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

$(document).ready(function() {
  var $dlg = $("#accesslog_voidredemption_dialog");
  var $wizard = $dlg.find(".wizard");
  var $stepSurvey = $wizard.find(".wizard-step-survey");
  var ticketUsageId = <%=JvString.jsString(ticketUsageId)%>;
  var maskIDs = <%=JvString.jsString(JvArray.arrayToString(maskIDs, ","))%>;
  var metaDataList = [];
  
  $dlg.on("snapp-dialog", function(event, params) {
    params.open = _enableDisable;
    params.buttons = [
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
  
  $wizard.vWizard({
    onStepChanged: _enableDisable
  });
  
  function _enableDisable() {
    var last = ($wizard.vWizard("activeIndex") == $wizard.vWizard("length") - 1);
    var $buttonPane = $dlg.siblings(".ui-dialog-buttonpane");
    $buttonPane.find("#btn-continue").setClass("hidden", last);
    $buttonPane.find("#btn-confirm").setClass("hidden", !last);
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
  
  function _confirm() {
    confirmDialog(itl("@Ticket.VoidRedemptionConfirm"), function() {
      var reqDO = {
        Command: "VoidTicketRedemption",
        VoidTicketRedemption: _prepareVoidTicketRedemptionCommand()
      };

      showWaitGlass();
      vgsService("Admission", reqDO, false, function(ansDO) {
        triggerEntityChange(<%=LkSNEntityType.TicketUsage.getCode()%>);
        hideWaitGlass();
        $dlg.dialog("close");
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
  
  function _prepareVoidTicketRedemptionCommand() {
    var noteType = $dlg.find("#NoteHighlighted").isChecked() ? <%=LkSNNoteType.Highlighted.getCode()%> : <%=LkSNNoteType.Standard.getCode()%>;
    var reqDO = {
      TicketUsageId: ticketUsageId,
      Note: $dlg.find("#Note").val(),
      NoteType: noteType,
      TransactionSurveyMetaDataList: metaDataList,
      TransactionMaskList: []
    };
    
    if (maskIDs.length > 0) {
      $(maskIDs.split(",")).each(function(index, elem) {
        reqDO.TransactionMaskList.push({"MaskId":elem});
      });
    }
    
    return reqDO;
  }

});

</script>

</v:dialog>


