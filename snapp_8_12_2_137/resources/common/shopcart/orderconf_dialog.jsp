<%@page import="com.vgs.snapp.web.gencache.*"%>
<%@page import="com.vgs.snapp.web.plugin.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.web.common.page.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_DocTemplate.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
String saleId = pageBase.getNullParameter("SaleId");
String accountId = pageBase.getNullParameter("AccountId");
String accountName = null;
boolean alreadyCommitted = pageBase.isParameter("AlreadyCommitted", "true");
long totalDue = JvString.strToMoneyDef(pageBase.getParameter("TotalDue"), 0);
long totalAmount = JvString.strToMoneyDef(pageBase.getParameter("TotalAmount"), 0);
int itemCount = JvString.strToIntDef(pageBase.getParameter("ItemCount"), 0);
int pahTicketCount = JvString.strToIntDef(pageBase.getParameter("PahTicketCount"), 0);

boolean outstandingDebt = false;
long totalAvailable = 0;
Long creditPerTrans = null;
Integer itemsPerTrans = null;
boolean organizationInventory = pageBase.getSession().getOrgAllowInventory();
boolean preventTicketEncoding = false;
boolean openOrderAffectCredit = false;
boolean allowOpenOrder = false;

{
  QueryDef qdef = new QueryDef(QryBO_Account.class)
      .addFilter(QryBO_Account.Fil.AccountId, accountId)
      .addSelect(
          QryBO_Account.Sel.EntityType,
          QryBO_Account.Sel.DisplayName,
          QryBO_Account.Sel.FinanceActive,
          QryBO_Account.Sel.FinanceOutstandingDebt,
          QryBO_Account.Sel.FinanceTotalAvailable,
          QryBO_Account.Sel.FinanceCreditPerTransaction,
          QryBO_Account.Sel.FinanceItemsPerTransaction,
          QryBO_Account.Sel.OpenOrderAffectCredit,
          QryBO_Account.Sel.CalcAllowOpenOrder,
          QryBO_Account.Sel.B2BPreventTicketEncoding);

  try (JvDataSet ds = pageBase.execQuery(qdef)) {
    if (!ds.isEmpty()) {
      LookupItem entityType = LkSN.EntityType.getItemByCode(ds.getField(QryBO_Account.Sel.EntityType));
      
      accountName = ds.getString(QryBO_Account.Sel.DisplayName);
      outstandingDebt = ds.getBoolean(QryBO_Account.Sel.FinanceOutstandingDebt);
      totalAvailable = ds.getMoney(QryBO_Account.Sel.FinanceTotalAvailable);
      openOrderAffectCredit = ds.getBoolean(QryBO_Account.Sel.OpenOrderAffectCredit);
      allowOpenOrder = ds.getBoolean(QryBO_Account.Sel.CalcAllowOpenOrder);
      preventTicketEncoding = ds.getBoolean(QryBO_Account.Sel.B2BPreventTicketEncoding);
      if (!ds.getField(QryBO_Account.Sel.FinanceCreditPerTransaction).isNull())
        creditPerTrans = ds.getMoney(QryBO_Account.Sel.FinanceCreditPerTransaction);
      if (!ds.getField(QryBO_Account.Sel.FinanceItemsPerTransaction).isNull())
        itemsPerTrans = ds.getInt(QryBO_Account.Sel.FinanceItemsPerTransaction);
    }
  }
}

QueryDef qdef = new QueryDef(QryBO_DocTemplate.class)
    .addFilter(Fil.DocTemplateType, LkSNDocTemplateType.OrderConfirmation.getCode())
    .addFilter(Fil.DocEnabled, "true")
    .addFilter(Fil.ForUserAccountId, "true")
    .addFilter(Fil.ForWorkstationId, "true")
    .addSort(Sel.DocTemplateName)
    .addSelect(
        Sel.IconName,
        Sel.DocTemplateId,
        Sel.DocTemplateName,
        Sel.DocEditorType,
        Sel.SaleOpen,
        Sel.SalePaid,
        Sel.SaleCompleted);
JvDataSet ds = pageBase.execQuery(qdef);

boolean restrictOpenOrder = pageBase.isParameter("RestrictOpenOrder", "true") || !allowOpenOrder;

boolean requireApproval = false;
boolean showReApprovalWarn = false;
boolean canApprove = true;
boolean canPay = true;
boolean canPrint = true;

if (pageBase.isVgsContext("CLC")) {
  DOOrderApproveDetails approvalDetails = pageBase.getBL(BLBO_Sale.class).getOrderApprovedDetails(saleId);
  boolean approved = pageBase.getDB().getBoolean("select Approved from tbSale where SaleId=" + JvString.sqlStr(saleId)); 

  if (!approved) 
    requireApproval = true;
  
  if (!approvalDetails.MaxAmount.isNull() && (approvalDetails.MaxAmount.getMoney() < totalAmount)) {
    requireApproval = true;
    if (approved)
      showReApprovalWarn = true;
  }
  
  if (rights.ReservationApprove.getBoolean() && (rights.OrderApprovalAmount.isNull() || (rights.OrderApprovalAmount.getMoney() >= totalAmount))) {
    requireApproval = false;
    showReApprovalWarn = false;
  }
  
  canApprove = !approved && rights.ReservationApprove.getBoolean() && (rights.OrderApprovalAmount.isNull() || (rights.OrderApprovalAmount.getMoney() >= totalDue));
  canPay = rights.ReservationPay.getBoolean();
  canPrint = rights.ReservationPrint.getBoolean();
}
%>

<v:dialog id="orderconf_dialog" title="@DocTemplate.OrderConfirmation" width="900" height="700" autofocus="false">

<script>
//# sourceURL=orderconf_dialog.jsp

var dlg = $("#orderconf_dialog");
dlg.on("snapp-dialog", function(event, params) {

  dlg.find("#btn-confirm").click(doConfirm);
  dlg.find("#btn-stepback").click(function() {
    dlg.dialog("close"),
    stepCallBack(Step_OrderConf, StepDir_Back);
  });
 
  var isTransactionTypeHandover = shopCart.Transaction.TransactionType == <%=LkSNTransactionType.OrganizationInventoryHandover.getCode()%>;
  var preventTicketEncoding = <%=preventTicketEncoding%>;
  var restrictOpenOrder = <%=restrictOpenOrder%>;
  
  shopCart.ReceiptEmailAddress = shopCart.ReceiptEmailAddress || shopCart.ShipAccountEmail || shopCart.AccountEmail || (shopCart.OrderConfirmationList || []).ReceiptEmailAddress;
  if (shopCart.ReceiptEmailAddress == null) {
    $("#CreateOrderConf").prop("disabled", true);
    $("#CreateOrderConf").closest(".checkbox-label").addClass("readonly-text");
  }
  
  $("#PreparePahDownload").setChecked(!preventTicketEncoding && (isTransactionTypeHandover || restrictOpenOrder));
  $("#CreateOrderConf").setChecked((shopCart.ReceiptEmailAddress != null) && isTransactionTypeHandover);
  $("#SendOrderConf").setChecked($("#CreateOrderConf").isChecked() && isTransactionTypeHandover);

  $("#ApproveReservation").click(function() {
    if (!$(this).isChecked()) {
      $("#CommitReservation").setChecked(false);
      $("#PreparePahDownload").setChecked(false);
      $("#InventoryBuild").setChecked(false);
      $("#BatchPrint").setChecked(false);
      $("#CreateOrderConf").setChecked(false);
      $("#SendOrderConf").setChecked(false);
      $("#IncludeTickets").setChecked(false);
    }
    doEnableDisable();
  });
  
  $("#CommitReservation").click(function() {
    if (!$(this).isChecked()) {
      $("#PreparePahDownload").setChecked(false);
      $("#InventoryBuild").setChecked(false);
      $("#IncludeTickets").setChecked(false);
    } 
    else {
      $("#PreparePahDownload").setChecked(!preventTicketEncoding);
      $("#InventoryBuild").setChecked(false);
    }
    
    doEnableDisable();
  });
  
  $("input[name='payment-method']").click(doEnableDisable);
  
  $("#PreparePahDownload").click(function() {
    if ($(this).isChecked()) {
      $("#CommitReservation").setChecked(true);
      $("#BatchPrint").setChecked(false);
      $("#InventoryBuild").setChecked(false);
    }
    else
      $("#IncludeTickets").setChecked(false);
    doEnableDisable();
  });
  
  $("#InventoryBuild").click(function() {
    if ($(this).isChecked()) { 
      $("#PreparePahDownload").setChecked(false);
      $("#CreateOrderConf").setChecked(false);
    }
      doEnableDisable();
  });

  $("#BatchPrint").setChecked(shopCart.Reservation.WishedBatch);
  $("#BatchPrint-Number").val(shopCart.Reservation.BatchNumber || "1");
  $("#BatchPrint-Date-picker").datepicker("setDate", xmlToDate(shopCart.Reservation.BatchDate));
  $("#BatchPrint").click(function() {
    if ($(this).isChecked()) {
      $("#PreparePahDownload").setChecked(false);
      $("#InventoryBuild").setChecked(false);
      $("#CreateOrderConf").setChecked(false);
      $("#SendOrderConf").setChecked(false);
      $("#IncludeTickets").setChecked(false);
    }
    doEnableDisable();
  });

  $("#CreateOrderConf").click(function() {
    if ($(this).isChecked()) {
      $("#SendOrderConf").setChecked(true);    
      $("#BatchPrint").setChecked(false);
    }
    else {
      $("#SendOrderConf").setChecked(false);
      $("#IncludeTickets").setChecked(false);
    }
    doEnableDisable();
  });
  
  $("#SendOrderConf").click(function() {
    if (!$(this).isChecked()) {
      $("#IncludeTickets").setChecked(false);
    }
    doEnableDisable();
  });

  $("#IncludeTickets").click(function() {
    if ($(this).isChecked()) {
      $("#SendOrderConf").setChecked(true);
      $("#PreparePahDownload").setChecked(!preventTicketEncoding);     
      $("#BatchPrint").setChecked(false);
    }
    doEnableDisable();
  });

  doEnableDisable();
  disableInvalidPaymentTypes();
  
  function doEnableDisable() {
    var isTransactionTypeHandover = shopCart.Transaction.TransactionType == <%=LkSNTransactionType.OrganizationInventoryHandover.getCode()%>;
    var approve = $("#ApproveReservation").isChecked();
    var commit = $("#CommitReservation").isChecked() || isTransactionTypeHandover;
    var preparePahDownload = $("#PreparePahDownload").isChecked();
    var createConf = $("#CreateOrderConf").isChecked();
    var batchCanCreate = <%=rights.ResBatch_Create.getBoolean()%>;
    var batch = $("#BatchPrint").isChecked() && batchCanCreate;
    var inventoryBuild = $("#InventoryBuild").isChecked();
    
    $("#CreateOrderConf").prop("disabled", (shopCart.ReceiptEmailAddress == null) || inventoryBuild);
    $("#CreateOrderConf").closest(".checkbox-label").setClass("readonly-text", (shopCart.ReceiptEmailAddress == null) || inventoryBuild);
    
    var templates = $(".template-item");
    templates.addClass("v-hidden");
    if (!commit) 
      templates = templates.filter("[data-saleopen='true']");
    else if (!preparePahDownload)
      templates = templates.filter("[data-salepaid='true']");
    else
      templates = templates.filter("[data-salepaid='true'],[data-salecompleted='true']");
    templates.removeClass("v-hidden");
    
    $(".template-item.v-hidden").find("input").setChecked(false);
    if ((templates.length != 0) && (templates.find("input:checked").length == 0)) 
      $(templates[0]).find("input").setChecked(true);

    $("#template-empty").setClass("v-hidden", templates.length != 0);
   
    $("#approval-container").setClass("v-hidden", <%=pageBase.isVgsContext("B2B")%>);
    $("#commit-container").setClass("v-hidden", !approve || isTransactionTypeHandover);
    $("#payment-method-container").setClass("v-hidden", !commit);
    $("#create-email-container").setClass("v-hidden", !approve);
    $("#send-email-container").setClass("v-hidden", !approve || !createConf);
    $("#prepare-pah-container").setClass("v-hidden", !approve || !commit || preventTicketEncoding);
    $("#include-tickets-container").setClass("v-hidden", !approve || !commit || !createConf || preventTicketEncoding);
    $("#doctemplate-list-container").setClass("v-hidden", !approve || !createConf);
    $("#batch-container").setClass("v-hidden", !approve || !batchCanCreate);
    $("#batch-detail-container").setClass("v-hidden", !batch);
    $("#InventoryBuild").parent(".checkbox-label").setClass("v-hidden", <%=!organizationInventory%> || isTransactionTypeHandover);

    $(".paymethod-item").removeClass("selected");
    $("input[name='payment-method']:checked").closest(".paymethod-item").addClass("selected");
  }
});

function disableInvalidPaymentTypes() {
  if (validPaymentMethodIDs) {
    var first = true;
    var paymentRadioList = dlg.find(".paymethod-item input");
    for (var paymentMethodItem of paymentRadioList) {
      var paymentMethodId = $(paymentMethodItem).val();
      var $label = $(paymentMethodItem).closest("label");
      if (!validPaymentMethodIDs.includes(paymentMethodId)) {
        $label.prop("title", itl("@Payment.InvalidPaymentMethodHint"));
        $(paymentMethodItem).prop("disabled", true);
      }
      else {
        $label.prop("title", "");
        if (first) {
          $(paymentMethodItem).prop("checked", "true");
          first = false;
        }        
      }
    }    
  }
}
  
function doConfirm() {
  var isTransactionTypeHandover = shopCart.Transaction.TransactionType == <%=LkSNTransactionType.OrganizationInventoryHandover.getCode()%>;
  var doContinue = true;
  var commitReservation = dlg.find("#CommitReservation").isChecked() && !isTransactionTypeHandover;
  var paymentRadio = dlg.find("#payment-method-container input:checked");
  var supportIFrame = parseInt(paymentRadio.attr("data-supportiframe"));
  var createOrderConfirmation = dlg.find("#CreateOrderConf").isChecked();
  var docTemplateId = dlg.find("[name='DocTemplateId']:checked").val();
  
  var paymentType = parseInt(paymentRadio.attr("data-paymenttype"));
  if (!commitReservation)
    paymentType = null;

  var sMaskIDs = getNull(paymentRadio.attr("data-maskids"));
  var intercompanyCostCenterId = null;
  if (commitReservation && (paymentType == <%=LkSNPaymentType.Intercompany.getCode()%>)) {
    var $cbCostCenter = paymentRadio.closest(".paymethod-item").find("[name='IntercompanyCostCenter']");
    intercompanyCostCenterId = getNull($cbCostCenter.val());

    var sCostCenterMaskIDs = getNull($cbCostCenter.find("option[value='" + intercompanyCostCenterId + "']").attr("data-maskids"));
    if (sCostCenterMaskIDs != null)
      sMaskIDs = sCostCenterMaskIDs;
  }

  if (commitReservation) {
    if ((paymentType == <%=LkSNPaymentType.Credit.getCode()%>)) {
      if (<%=outstandingDebt%>) {
        doContinue = false;
        showMessage(itl("@Account.Credit.ErrorOutstandingDebts"));
      }
      else if (<%=(totalAvailable < totalDue)%>) {
        doContinue = false;
        showMessage(itl("@Account.Credit.ErrorTotalCredit", <%=JvString.jsString(pageBase.formatCurr(totalAvailable))%>));
      }
      else if (<%=(creditPerTrans != null) && (creditPerTrans.longValue() < totalDue)%>) {
        doContinue = false;
        showMessage(itl("@Account.Credit.ErrorTransactionLimit", <%=JvString.jsString(accountName)%>, <%=JvString.jsString(pageBase.formatCurr(JvString.coalesce(creditPerTrans, 0l)))%>));
      }
      else if (<%=(itemsPerTrans != null) && (itemsPerTrans.intValue() < itemCount)%>) {
        doContinue = false;
        showMessage(itl("@Account.Credit.ErrorItemLimit", <%=JvString.jsString(accountName)%>, <%=JvString.jsString((itemsPerTrans == null) ? "" : itemsPerTrans.toString())%>));
      }
    }
  }
  else if (!isTransactionTypeHandover) {
    if (<%=openOrderAffectCredit && (totalAvailable < totalDue)%>) {
      doContinue = false;
      showMessage(itl("@Account.Credit.ErrorTotalCredit", <%=JvString.jsString(pageBase.formatCurr(totalAvailable))%>));
    }
  }
   
  if (commitReservation && <%=(totalDue != 0)%> && (isNaN(paymentType) || paymentType <= 0)) {
    doContinue = false;
    showMessage(itl("@Account.Credit.ErrorNoPayMethod"));
  }
  
  if (doContinue && createOrderConfirmation && !$("#template-empty").is(".v-hidden")) {
    doContinue = false;
    showMessage(itl("@DocTemplate.NoTemplateAvailable"));
  }
  
  var metaData = getNull(dlg.find("#commit-container").data("metaData"));
  if (doContinue && commitReservation && (sMaskIDs != null) && (metaData == null)) {
    doShowMaskEdit(sMaskIDs.split(","));
    doContinue = false;
  }

  var authCode = paymentRadio.attr("data-AuthCode");
  if (doContinue && commitReservation && (paymentType == <%=LkSNPaymentType.CreditCard.getCode()%>) && (getNull(authCode) == null)) {
    doContinue = false;
    doAuthCodeInput(paymentRadio, doConfirm);
  }

  var folio = paymentRadio.data("folio");
  if (doContinue && commitReservation && (paymentType == <%=LkSNPaymentType.Membership.getCode()%>) && (getNull(folio) == null)) {
    doContinue = false;
    doFolioInput(paymentRadio);
  }

  if (doContinue) {
    var orderData = {
      ApproveReservation: dlg.find("#ApproveReservation").isChecked(),
      CommitReservation: dlg.find("#CommitReservation").isChecked(),
      PaymentMethodId: paymentRadio.val(),
      PaymentTokenId: paymentRadio.attr("data-paymenttokenid"),
      PaymentType: paymentType,
      PaymentMetaDataList: metaData,
      SupportIFrame: supportIFrame,
      AuthorizationCode: authCode,
      IntercompanyCostCenterId: intercompanyCostCenterId,
      PreparePahDownload: dlg.find("#PreparePahDownload").isChecked(),
      OrganizationInventoryBuild: dlg.find("#InventoryBuild").isChecked() && <%=organizationInventory%>,
      CreateOrderConfirmation: createOrderConfirmation,
      SendOrderConfirmation: dlg.find("#SendOrderConf").isChecked(),
      IncludeTickets: dlg.find("#IncludeTickets").isChecked(),
      DocTemplateId: docTemplateId,
      Membership: folio
    };
    
    shopCart.Reservation.WishedBatch = $("#BatchPrint").isChecked();
    if (shopCart.Reservation.WishedBatch) {
      shopCart.Reservation.BatchDate = $("#BatchPrint-Date-picker").getXMLDate();
      shopCart.Reservation.BatchNumber = strToIntDef($("#BatchPrint-Number").val(), 1);
    }
    
    $("#orderconf_dialog").dialog("close");
    stepCallBack(Step_OrderConf, StepDir_Next, orderData);
  }
}

function doAuthCodeInput(paymentRadio, callback) {
  inputDialog(itl("@Payment.CreditCard"), itl("@Payment.AuthorizationCode"), "", paymentRadio.attr("data-AuthCode"), false, function(value) {
    paymentRadio.attr("data-AuthCode", value);
      if (callback)
        callback();
  }, "", 20);
}

function doFolioInput(paymentRadio) {
  asyncDialogEasy("../common/shopcart/membership_dialog", "paymentMethodId=" + paymentRadio.val() + "&chargeAmount=<%=JvString.moneyToStr(totalDue)%>");
}

$(document).von("#orderconf_dialog", "folio-pickup", function(event, data) {
  var message = itl("@Payment.ChargeConfirm", <%=JvString.jsString(pageBase.formatCurr(totalDue))%>) + "\n\n" + data.MembershipPlanName + "\n" + data.MembershipCardCodeDisplay + "\n" + data.CardHolderName;
  
  confirmDialog(message, function() {
    $("[name='payment-method']:checked").data("folio", data);
    doConfirm();
  });
});

function doShowMaskEdit(maskIDs, callback) {
  var $dlgMaskEdit = $("<div><div class='maskedit-container'></div></div>");
  var maskEditURL = "<%=pageBase.getContextURL()%>?page=maskedit_widget&MaskIDs=" + maskIDs.join(",");
  
  asyncLoad($dlgMaskEdit.find(".maskedit-container"), maskEditURL, _showDialog);
  
  function _showDialog() {
    $dlgMaskEdit.dialog({
      title: itl("@Payment.PaymentMethodMasks"),
      modal: true,
      width: 800,
      close: function() {
        $dlgMaskEdit.remove();
      },
      buttons: [
        dialogButton("@Common.Ok", _maskEditSave),
        dialogButton("@Common.Cancel", doCloseDialog)
      ]
    });
  };
  
  function _maskEditSave() {
    var metaDataList = prepareMetaDataArray($dlgMaskEdit);
    if (metaDataList) {
      var reqDO = {
        Command: "ValidateMetaData",
        ValidateMetaData: {
          EntityType: <%=LkSNEntityType.Payment.getCode()%>,
          MetaDataList: metaDataList
        }
      };
      
      showWaitGlass();
      vgsService("MetaData", reqDO, false, function() {
        hideWaitGlass();
        dlg.find("#commit-container").data("metaData", metaDataList);
        $dlgMaskEdit.dialog("close");
        if (callback)
          callback();
      });
    }
  }

}

</script>

<style>
  #payment-method-container,
  #pah-method-container,
  #send-email-container,
  #include-tickets-container {
    padding-left: 30px;
  }
  
  .paymethod-item {
    display: flex;
    justify-content: space-between;
  }
  
  .paymethod-detail-container {
    display: none;
    flex-grow: 1;
    margin-left: 50px;
  }
  
  .paymethod-item.selected .paymethod-detail-container {
    display: block;
  }

  #payment-method-container,
  #pah-method-container {
    padding-bottom: 10px; 
  }
  
  #batch-print-container {
    display: inline-block;
    margin-left: 50px;
  }
  #batch-print-container.v-hidden {
    display: none;
  }
  
  #BatchPrint-Date-picker {
    width: 120px;
  }
  
  #BatchPrint-Number {
    width: 50px;
  }
  
  input[type="radio"]:disabled ~ * {
    color: gray;
    text-decoration: line-through; 
  }
</style>

<div class="body-block">
<v:widget caption="@Common.Options">
  <v:widget-block>
    <% if (!rights.PaymentCommitText.isNull()) { %>
      <v:alert-box type="info"><%=JvString.escapeHtml(rights.PaymentCommitText.getString())%></v:alert-box>
    <% } %>
  
    <div id="approval-container">
      <v:db-checkbox caption="@Reservation.ApproveReservation" value="true" field="ApproveReservation" checked="<%=!requireApproval || restrictOpenOrder%>" enabled="<%=canApprove && !restrictOpenOrder%>"/><br/>
    </div>
    <div id="commit-container">
      <% List<DOPaymentMethodRef> payMethods = pageBase.getBL(BLBO_PayMethod.class).getWebEnabledPaymentMethods(LkSNTransactionType.Normal, accountId, LkSNPaymentTokenType.PayByToken); %>
      <v:db-checkbox caption="@Reservation.CommitReservation" value="true" field="CommitReservation" checked="<%=alreadyCommitted || restrictOpenOrder%>" enabled="<%=canPay && !alreadyCommitted && !payMethods.isEmpty() && !restrictOpenOrder%>"/><br/>
      <% if (totalDue != 0) { %>
        <div id="payment-method-container">
          <% for (DOPaymentMethodRef payMethod : payMethods) { %>
            <% 
            TagAttributeBuilder attributes = TagAttributeBuilder.builder()
                .put("data-paymenttype", payMethod.PaymentType.getInt())
                .put("data-supportiframe", payMethod.WebPayment.SupportIFrame.getBoolean())
                .put("data-maskids", payMethod.MaskIDs.getEmptyString()); 
            %> 
            
            <div class="paymethod-item">
              <v:radio name="payment-method" value="<%=payMethod.PaymentMethodId.getString()%>" caption="<%=payMethod.PaymentMethodName.getString()%>" attributes="<%=attributes%>"/>
              <div class="paymethod-detail-container">
                <% if (payMethod.PaymentType.isLookup(LkSNPaymentType.Intercompany)) { %>
                  <select class="form-control" name="IntercompanyCostCenter">
                  <% for (DOIntercompanyCostCenter costCenter : payMethod.Intercompany.CostCenterList) { %>
                    <option value="<%=costCenter.IntercompanyCostCenterId.getString()%>" data-maskids="<%=costCenter.MaskIDs.getEmptyString()%>"><%=costCenter.IntercompanyCostCenterName.getHtmlString()%></option>
                  <% } %>
                  </select>
                <% } %>
              </div>
            </div>
            
            <% for (DOPaymentToken token : payMethod.WebPayment.TokenList) { %> 
              <% attributes.put("data-paymenttokenid", token.PaymentTokenId.getString()); %>
              <div class="paymethod-container"><v:radio name="payment-method" value="<%=payMethod.PaymentMethodId.getString()%>" caption="<%=token.CommonDesc.getString()%>" attributes="<%=attributes%>"/></div>
            <% } %>
          <% } %>
        </div>
      <% } %>
    </div>
    <div id="prepare-pah-container">
      <v:db-checkbox caption="@Sale.PreparePahDownload" value="true" field="PreparePahDownload" enabled="<%=canPrint%>"/>&nbsp;&nbsp;
      <v:db-checkbox caption="@Lookup.TransactionType.OrganizationInventoryBuild" value="true" field="InventoryBuild"/>
    </div>
    <% if (pageBase.isVgsContext("CLC")) { %>
      <div id="batch-container">
        <v:db-checkbox caption="@Reservation.BatchPrinting" value="true" field="BatchPrint" enabled="<%=canPrint%>"/>
        <div id="batch-detail-container">
          <v:input-text type="datepicker" field="BatchPrint-Date"/>
          <v:input-text type="text" field="BatchPrint-Number" placeholder="#"/>
        </div>
      </div>
    <% } %>
    <div id="create-email-container">
      <v:db-checkbox caption="@Sale.CreateOrderConfirmation" value="true" field="CreateOrderConf" enabled="<%=canPrint%>"/><br/>
    </div>
    <div id="send-email-container">
      <v:db-checkbox caption="@Sale.SendConfirmationEmail" value="true" field="SendOrderConf" enabled="<%=canPrint%>"/><br/>
    </div>
    
    <% if (!preventTicketEncoding && (rights.PdfAttachMaxTickets.isNull() || (rights.PdfAttachMaxTickets.getInt() != 0))) {%>
      <% boolean canAttach = rights.PdfAttachMaxTickets.isNull() || (pahTicketCount <= rights.PdfAttachMaxTickets.getInt()); %>
      <div id="include-tickets-container">
        <v:db-checkbox caption="@Sale.IncludeTickets" value="true" field="IncludeTickets" enabled="<%=canPrint && canAttach%>"/><br/>
      </div>
    <% } %>
    
  </v:widget-block>
</v:widget>

<% if (showReApprovalWarn) { %>
  <div class="warning-box"><v:itl key="@Right.ApprovedAmount_Error_Autodisabled"/></div>
<% } %>

<div id="doctemplate-list-container">
  <v:widget caption="@DocTemplate.DocTemplate">
    <v:widget-block>
      <div id="template-empty" class="v-hidden"><v:itl key="@DocTemplate.NoTemplateAvailable"/></div>
      <% boolean first = true; %>
      <v:ds-loop dataset="<%=ds%>">
        <%
          String sChecked = "";
          if (first) {
            first = false;
            sChecked = " checked=\"checked\"";
          }
        %>
        <div class="template-item" data-saleopen="<%=ds.getField(Sel.SaleOpen).getBoolean()%>" data-salepaid="<%=ds.getField(Sel.SalePaid).getBoolean()%>" data-salecompleted="<%=ds.getField(Sel.SaleCompleted).getBoolean()%>">
          <label class="checkbox-label">
            <input type="radio" name="DocTemplateId" value="<%=ds.getField(Sel.DocTemplateId).getHtmlString()%>" <%=sChecked%>/>&nbsp;
            <%=ds.getField(Sel.DocTemplateName).getHtmlString()%>
          </label>
        </div>
      </v:ds-loop>
    </v:widget-block>
  </v:widget>
</div>
</div>

<div class="toolbar-block">
  <div id="btn-confirm" class="v-button hl-green"><v:itl key="@Common.Confirm"/></div>
  <div id="btn-stepback" class="v-button hl-green"><v:itl key="@Common.Back"/></div>
</div>


</v:dialog>
