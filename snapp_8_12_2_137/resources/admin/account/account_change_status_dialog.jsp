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
LookupItem accountStatus = pageBase.getBL(BLBO_Account.class).getAccountStatus(pageBase.getId());
String[] transactionSurveyIDs = pageBase.getBL(BLBO_Survey.class).getShopCartSurvey(LkSNTransactionType.AccountChangeStatus).tranSurveyIDs;
String[] maskIDs = pageBase.getBL(BLBO_Survey.class).getMaskIDsBySurvey(transactionSurveyIDs);
boolean canCreateNoteType = LkSNHighlightedNoteRightLevel.Create.check(rights.HighlightedNote);
%>

<v:dialog id="account_change_status_dialog" title="@Common.ChangeStatus" width="800" height="600" autofocus="false">

  <style>
    #account_change_status_dialog .status-label {
      display: block;
    }
  </style>

  <div class="wizard">
    <div class="wizard-step">
      <div class="wizard-step-title"><v:itl key="@Common.Status"/></div>
      <div class="wizard-step-content">
        <v:widget>
          <v:widget-block>
            <% List<LookupItem> hiddenAccountStatuses = LookupManager.getArray(accountStatus, LkSNAccountStatus.Temp); %>
            <v:lk-radio lookup="<%=LkSN.AccountStatus%>" field="AccountStatus" allowNull="false" hideItems="<%=hiddenAccountStatuses%>"/>
          </v:widget-block>
        </v:widget>
      </div>
    </div>
    
    <div class="wizard-step wizard-step-survey">
      <div class="wizard-step-title"><v:itl key="@Common.Survey"/></div>
      <div class="wizard-step-content"></div>
    </div>
    
    <div class="wizard-step">
      <div class="wizard-step-title"><v:itl key="@Common.Notes"/></div>
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
  var $dlg = $("#account_change_status_dialog");
  var $wizard = $dlg.find(".wizard");
  var $stepSurvey = $wizard.find(".wizard-step-survey");
  var accountId = <%=JvString.jsString(pageBase.getId())%>;
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
  
  $dlg.find("[name='AccountStatus']").first().setChecked(true);

  
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
    confirmDialog(null, function() {
      var reqDO = {
        Command: "ChangeAccountStatus",
        ChangeAccountStatus: _prepareUpdateCommand()
      };
      
      showWaitGlass();
      vgsService("Account", reqDO, false, function(ansDO) {
        hideWaitGlass(); 
        entitySaveNotification(<%=LkSNEntityType.Account_All.getCode()%>, accountId);
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
  
  function _prepareUpdateCommand() {
    var noteType = $dlg.find("#NoteHighlighted").isChecked() ? <%=LkSNNoteType.Highlighted.getCode()%> : <%=LkSNNoteType.Standard.getCode()%>;
    var reqDO = {
      LocateAccount: {
        AccountId: accountId,
      },
      AccountStatus: $dlg.find("[name='AccountStatus']:checked").val(),
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


