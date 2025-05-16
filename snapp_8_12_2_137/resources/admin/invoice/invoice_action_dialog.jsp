<%@page import="com.vgs.snapp.exception.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%
String invoiceIDs = pageBase.getEmptyParameter("invoiceIDs");
LookupItem transactionType = LkSN.TransactionType.findItemByCode(pageBase.getNullParameter("transactionType"));

String errorDesc = null;
try {
  pageBase.getBL(BLBO_Invoice.class).checkInvoiceStatus(transactionType, JvArray.stringToArray(invoiceIDs, ","));
}
catch (EWsInvalidInvoiceStatus e) {
  errorDesc = e.getLocalizedMessage();
}

String title = transactionType.getDescription();

QueryDef qdef = new QueryDef(QryBO_Invoice.class);
//Select
qdef.addSelect(
 QryBO_Invoice.Sel.InvoiceCode,
 QryBO_Invoice.Sel.InvoiceStatusDesc,
 QryBO_Invoice.Sel.IssueFiscalDate);
//Where
qdef.addFilter(QryBO_Invoice.Fil.InvoiceId, JvArray.stringToArray(invoiceIDs, ","));
//Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

boolean canCreateNoteType = LkSNHighlightedNoteRightLevel.Create.check(rights.HighlightedNote);
String[] transactionSurveyIDs = pageBase.getBL(BLBO_Survey.class).getShopCartSurvey(LkSNTransactionType.InvoiceVoid).tranSurveyIDs;
String[] maskIDs = pageBase.getBL(BLBO_Survey.class).getMaskIDsBySurvey(transactionSurveyIDs);
%>

<v:dialog id="invoice_action_dialog" icon="invoice.png" title="<%=title%>" autofocus="false" width="800" height="540">
  <%if (errorDesc != null) {%>
  <div class="errorbox"><%=errorDesc%></div>
  <%} else {%>
  
  <div class="wizard">
    <div class="wizard-step wizard-step-selection">
      <div class="wizard-step-title"><v:itl key="@Invoice.VoidWizard_Details"/></div>
      <div class="wizard-step-content">
        <v:widget caption="@Invoice.Invoice">
          <v:widget-block>
            <% ds.getField(QryBO_Invoice.Sel.IssueFiscalDate).setDisplayFormat(pageBase.getShortDateFormat()); %>
            <div class="recap-value-item">
              <v:itl key="@Invoice.IssueDate"/>
              <span class="recap-value"><%= ds.getField(QryBO_Invoice.Sel.IssueFiscalDate).getHtmlString() %></span>
            </div>

            <div class="recap-value-item">
              <v:itl key="@Common.Code"/> 
              <span class="recap-value"><%=ds.getField(QryBO_Invoice.Sel.InvoiceCode).getHtmlString()%></span>
            </div>
    
            <div class="recap-value-item">
              <v:itl key="@Common.Status"/>
              <span class="recap-value"><%=ds.getField(QryBO_Invoice.Sel.InvoiceStatusDesc).getHtmlString()%></span>
            </div>
          </v:widget-block>
        </v:widget>
          <% if (transactionType.isLookup(LkSNTransactionType.InvoiceDueDateChange)) {%>
        <v:widget caption="@Invoice.DueDate">
          <v:widget-block>
            <div id="invoice-duedate-dialog" title="<v:itl key="@Invoice.ChangeDueDate"/>">
              <v:input-text type="datepicker" field="NewDueDatePicker" style="width:130px"/>
            </div>
          </v:widget-block>
        </v:widget>
          <%}%>
          
      </div>
    </div>
    
    <div class="wizard-step wizard-step-survey">
      <div class="wizard-step-title"><v:itl key="@Invoice.VoidWizard_Survey"/></div>
      <div class="wizard-step-content"></div>
    </div>
    
    <div class="wizard-step">
      <div class="wizard-step-title"><v:itl key="@Invoice.VoidWizard_Notes"/></div>
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
    
    <div class="wizard-step">
      <div class="wizard-step-title"><v:itl key="@Invoice.VoidWizard_Result"/></div>
      <div class="wizard-step-content">
        <v:widget caption="@Sale.Transaction">
          <v:widget-block>
            <div class="recap-value-item">
              <v:itl key="@Sale.PNR"/>
              <span class="recap-value">
                <a id="sale-link" class="recap-value"></a>
              </span>
            </div>
            <div class="recap-value-item">
              <v:itl key="@Sale.Transaction"/>
              <span class="recap-value">
                <a id="transaction-link" class="recap-value"></a>
              </span>
            </div>
          </v:widget-block>
        </v:widget> 
      </div>
    </div>
  </div>
  <%}%>

<script>  
//# sourceURL=invoice_action_dialog.jsp

$(document).ready(function() {
  var $dlg = $("#invoice_action_dialog");
  var $wizard = $dlg.find(".wizard");
  var $stepSurvey = $wizard.find(".wizard-step-survey");
  var $stepSelection = $wizard.find(".wizard-step-selection");
  var invoiceIDs = <%=JvString.jsString(invoiceIDs)%>;
  var maskIDs = <%=JvString.jsString(JvArray.arrayToString(maskIDs, ","))%>;
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
  
  $wizard.vWizard({
    onStepChanged: _enableDisable
  });
  
  function _enableDisable() {
    var confirm = ($wizard.vWizard("activeIndex") == $wizard.vWizard("length") - 2);
    var lastStep = ($wizard.vWizard("activeIndex") == $wizard.vWizard("length") -1);
    var firstStep = ($wizard.vWizard("activeIndex") == 0);
    var $buttonPane = $dlg.siblings(".ui-dialog-buttonpane");
    $buttonPane.find("#btn-continue").setClass("hidden", confirm || lastStep);
    $buttonPane.find("#btn-confirm").setClass("hidden", !confirm || lastStep);
    $buttonPane.find("#btn-back").setClass("hidden", firstStep || lastStep);
    
  }

  function _nextStep() {
    if ($stepSelection.is(".active")) {
      <%if (transactionType.isLookup(LkSNTransactionType.InvoiceDueDateChange)) {%>
        if ($("#NewDueDatePicker").val() == "")
          showMessage("<v:itl key="@Common.PleaseSelectADate" encode="UTF-8"/>");
        else
          $wizard.vWizard("next");
      <%} else {%>
        $wizard.vWizard("next");
      <%}%>
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

  
  function _confirm() {
    confirmDialog(null, function() {
      <% if (transactionType.isLookup(LkSNTransactionType.InvoiceWriteOff)) {%>
        _doWriteOffInvoice();
      <%} else if (transactionType.isLookup(LkSNTransactionType.InvoiceVoid)) {%>
        _doVoidInvoice();
      <%} else if (transactionType.isLookup(LkSNTransactionType.InvoiceDueDateChange)) {%>
        _doChangeInvoiceDueDate();
      <%} else if (transactionType.isLookup(LkSNTransactionType.InvoiceRestore)) {%>
        _doRestoreInvoice();
      <%}%>
    });
  }
  
  function _doVoidInvoice() {
    var reqDO = {
        Command: "VoidInvoice",
        VoidInvoice: _prepareInvoiceCommand()
      };
    
    showWaitGlass();
    vgsService("Invoice", reqDO, false, function(ansDO) {
      ansDO.Answer.VoidInvoice.InvoiceList.forEach((invoice) => {
        entitySaveNotification(<%=LkSNEntityType.Invoice.getCode()%>, invoice.InvoiceId);
      });
      _renderResult(ansDO.Answer.VoidInvoice);
      hideWaitGlass();
      $wizard.vWizard("next");
    });    
  }
  
  function _doWriteOffInvoice() {
    var reqDO = {
        Command: "WriteOffInvoice",
        WriteOffInvoice: _prepareInvoiceCommand()
      };
    
    showWaitGlass();
    vgsService("Invoice", reqDO, false, function(ansDO) {
      ansDO.Answer.WriteOffInvoice.InvoiceList.forEach((invoice) => {
        entitySaveNotification(<%=LkSNEntityType.Invoice.getCode()%>, invoice.InvoiceId);
      });
      _renderResult(ansDO.Answer.WriteOffInvoice);
      hideWaitGlass();
      $wizard.vWizard("next");
    });    
  }
  
  function _doRestoreInvoice() {
    var reqDO = {
        Command: "RestoreInvoice",
        RestoreInvoice: _prepareInvoiceCommand()
      };
    
    showWaitGlass();
    vgsService("Invoice", reqDO, false, function(ansDO) {
      ansDO.Answer.RestoreInvoice.InvoiceList.forEach((invoice) => {
        entitySaveNotification(<%=LkSNEntityType.Invoice.getCode()%>, invoice.InvoiceId);
      });
      _renderResult(ansDO.Answer.RestoreInvoice);
      hideWaitGlass();
      $wizard.vWizard("next");
    });    
  }

  function _doChangeInvoiceDueDate() {
    var reqDO = {
        Command: "ChangeInvoiceDueDate",
        ChangeInvoiceDueDate: _prepareInvoiceCommand()
      };
    reqDO.ChangeInvoiceDueDate.DueDate = $("#NewDueDatePicker").val();
    
    showWaitGlass();
    vgsService("Invoice", reqDO, false, function(ansDO) {
      ansDO.Answer.ChangeInvoiceDueDate.InvoiceList.forEach((invoice) => {
        entitySaveNotification(<%=LkSNEntityType.Invoice.getCode()%>, invoice.InvoiceId);
      });
      _renderResult(ansDO.Answer.ChangeInvoiceDueDate);
      hideWaitGlass();
      $wizard.vWizard("next");
    });    
  }

  function _prepareInvoiceCommand() {
    var noteType = $dlg.find("#NoteHighlighted").isChecked() ? <%=LkSNNoteType.Highlighted.getCode()%> : <%=LkSNNoteType.Standard.getCode()%>;
    var reqDO = {
        InvoiceList: [],
        Note: $dlg.find("#Note").val(),
        NoteType: noteType,
        TransactionSurveyMetaDataList: metaDataList,
        TransactionMaskList: []
      };
    
    if (invoiceIDs.length > 0) {
      $(invoiceIDs.split(",")).each(function(index, elem) {
        reqDO.InvoiceList.push({"InvoiceId":elem});
      });
    }
    
    if (maskIDs.length > 0) {
      $(maskIDs.split(",")).each(function(index, elem) {
        reqDO.TransactionMaskList.push({"MaskId":elem});
      });
    }
    
    return reqDO;
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
  
  function _renderResult(ans) {
    if (ans.TransactionRecap != null) {
      $("#sale-link").text(ans.TransactionRecap.SaleCode);    
      $("#sale-link").attr("href", getPageURL(<%=LkSNEntityType.Sale.getCode()%>, ans.TransactionRecap.SaleId));
      $("#transaction-link").text(ans.TransactionRecap.TransactionCode);    
      $("#transaction-link").attr("href", getPageURL(<%=LkSNEntityType.Transaction.getCode()%>, ans.TransactionRecap.TransactionId));
    }
  }

});

</script>

</v:dialog>