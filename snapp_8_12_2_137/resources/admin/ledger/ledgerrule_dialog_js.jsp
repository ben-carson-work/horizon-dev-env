<%@page import="com.vgs.web.library.product.NSystemProduct"%>
<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.cl.lookup.LookupManager"%>
<%@page import="com.vgs.cl.JvArray"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="ledgerRule" class="com.vgs.snapp.dataobject.DOLedgerRule" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
boolean canEdit = rights.SettingsLedgerAccounts.canUpdate();

boolean isProductTriggerType = ledgerRule.TriggerEntityType.isLookup(LkSNEntityType.ProductType);
boolean walletRewardPaymentMethod = false;
boolean isOverRefund     = isProductTriggerType && ledgerRule.TriggerEntityId.isSameString(NSystemProduct.OverRefund.getProductId());
boolean isWalletDeposit  = isProductTriggerType && ledgerRule.TriggerEntityId.isSameString(NSystemProduct.WalletDeposit.getProductId());
boolean isWalletClearing = isProductTriggerType && ledgerRule.TriggerEntityId.isSameString(NSystemProduct.WalletClearing.getProductId());
boolean isRewardClearing = isProductTriggerType && ledgerRule.TriggerEntityId.isSameString(NSystemProduct.RewardPointClearing.getProductId());

if (ledgerRule.TriggerEntityType.isLookup(LkSNEntityType.PaymentMethod)) {
  LookupItem driverType = pageBase.getBL(BLBO_Plugin.class).getDriverTypeByPluginId(ledgerRule.TriggerEntityId.getString());
  walletRewardPaymentMethod = driverType.isLookup(LkSNDriverType.Wallet) || driverType.isLookup(LkSNDriverType.RewardPoints);
}

boolean pluginEnabled = ledgerRule.PluginEnabled.getBoolean();
String FIXED_TYPE = "fixed";
String GATE_CAT_TYPE = "gate-cat";

request.setAttribute("ledgerRule", ledgerRule);
%>

<script>
var lastIdx = 0;

var dlg = $("#ledgerrule_dialog");
dlg.on("snapp-dialog", function(event, params) {
  params.buttons = [];
  
  params.buttons.push({
    text: itl("@Common.SaveAndCopy"),
    disabled: <%=!canEdit%>,
    click: function() {
      doSaveLedgerRule(function(ledgerRuleId) {
        dlg.dialog("close");
        asyncDialogEasy("ledger/ledgerrule_dialog", "id=new&TemplateLedgerRuleId=" + ledgerRuleId + "&EntityType=<%=pageBase.getEmptyParameter("EntityType")%>");
      });
    }
  });
  params.buttons.push({
    text: itl("@Common.Save"),
    disabled: <%=!canEdit%>,
    click: function() {
      doSaveLedgerRule(function(ledgerRuleId) {
        dlg.dialog("close");
      });
    }
  });
  params.buttons.push({
	  text: itl("@Common.Cancel"),
    click: doCloseDialog
  });
});

dlg.keypress(function() {
  if (event.keyCode == KEY_ENTER)
    doSaveLedgerRule();
});

function addEmptyDetailLine() {
  addRuleDetail(lastIdx, null, null, <%=Integer.toString(LkSNLedgerRuleAccountType.SaleLocation.getCode())%>, null, null, <%=Integer.toString(LkSNLedgerRuleAccountType.SaleLocation.getCode())%>, null, 100, 2, null, null, 0);

  var ledgerType = parseInt($("#ledgerRule\\.LedgerTriggerType").val());

  refreshWeight();
  adjustLocationOptions(ledgerType);
}

function removeObject() {
  $("#ledgerrule_dialog .cblist:checked").not(".header").closest("tr").remove();
}

function addRuleDetail(idx, ledgerId, debitLedgerId, debitLocType, debitLocId, creditLedgerId, creditLocType, creditLocId, weight, weightType, locUsageFilterId, gateCategoryId, detailSerialNumber) {
  var tr = $("<tr class='grid-row' data-id='" + idx + "' data-DetailLedgerAccountId='" + ledgerId + "' data-DetailSerialNumber='"+ detailSerialNumber +"'/>").appendTo("#rule-detail-body");

  var tdCB = $("<td/>").appendTo(tr);
  var tdSN = $("<td/>").appendTo(tr);
  var tdDebit = $("<td/>").appendTo(tr);
  var tdCredit = $("<td/>").appendTo(tr);
  var tdWeightLocation = $("<td/>").appendTo(tr);

  tdCB.append("<input value='" + ledgerId + "' type='checkbox' class='cblist'>");
  
  tdSN.append(detailSerialNumber);
  
  $("#ledger-rule-templates .LedgerAccountTemplate-Select").clone().addClass("DebitLedgerAccountTemplate-Select").appendTo(tdDebit).val(debitLedgerId);
  tdDebit.append("<br/>");
  var debitLocValue = (parseInt(debitLocType) == <%=LkSNLedgerRuleAccountType.Fixed.getCode()%>) ? debitLocId : debitLocType;
  $("#ledger-rule-templates .LocationTypeTemplate-Select").clone().addClass("DebitLocationTypeTemplate-Select").appendTo(tdDebit).val(debitLocValue);
  
  $("#ledger-rule-templates .LedgerAccountTemplate-Select").clone().addClass("CreditLedgerAccountTemplate-Select").appendTo(tdCredit).val(creditLedgerId);
  tdCredit.append("<br/>");
  var creditLocValue = (parseInt(creditLocType) == <%=LkSNLedgerRuleAccountType.Fixed.getCode()%>) ? creditLocId : creditLocType;
  $("#ledger-rule-templates .LocationTypeTemplate-Select").clone().addClass("CreditLocationTypeTemplate-Select").appendTo(tdCredit).val(creditLocValue);
  
  <%
  String disabled = canEdit ? "" : "disabled='disabled'";
  %>
  
  var radioWeightGroupName = "radio-weight-type-group-" + idx; 
  
  if (<%=!ledgerRule.TriggerEntityType.isLookup(LkSNEntityType.Tax, LkSNEntityType.PaymentMethod)%>) 
    tdWeightLocation.append("<label><input name='" + radioWeightGroupName + "' type='radio' value='<%=FIXED_TYPE%>'>" + <v:itl key="@Product.SelectionFixed" encode="JS"/> + "</label>&nbsp;&nbsp;<label><input type='radio' name='" + radioWeightGroupName + "' value='<%=GATE_CAT_TYPE%>'>" + <v:itl key="@Product.GateCategory" encode="JS"/> + "</label><br/>");

  $("[name='" + radioWeightGroupName + "']").change(refreshWeight);
  
  divWeightLocation = $("<div class='relative'>").appendTo(tdWeightLocation);
  divWeightLocation.append("<input type='text' name='txt-perc' class='txt-perc form-control' <%=disabled%>/>");
  $("#ledger-rule-templates .usage-filter-loc-select").clone().appendTo(divWeightLocation).val(locUsageFilterId);
  $("#ledger-rule-templates .gate-cat-select").clone().appendTo(divWeightLocation).val(gateCategoryId);
  
  if (weightType == <%=LkSNLedgerRuleWeightType.GateCat.getCode()%>) {
    $("input[name='" + radioWeightGroupName + "']").prop('checked',false);
    $("input[name='" + radioWeightGroupName + "'][value='<%=GATE_CAT_TYPE%>']").prop('checked', true);
  }
  else  {
    $("input[name='" + radioWeightGroupName + "']").prop('checked',false);
    $("input[name='" + radioWeightGroupName + "'][value='<%=FIXED_TYPE%>']").prop('checked', true);  
  }
  tdWeightLocation.find("input[name='txt-perc']").val((weightType == <%=LkSNLedgerRuleWeightType.Percentage.getCode()%>) ? (weight + "%") : weight);
  lastIdx = lastIdx + 1;
}

function refreshWeight() {
  var ledgerType = parseInt($("#ledgerRule\\.LedgerTriggerType").val());
  var usedTickets = (((ledgerType == <%=LkSNLedgerType.Clearing.getCode()%>) || (ledgerType == <%=LkSNLedgerType.Expiration.getCode()%>)) && $("#ledgerRule\\.UsedTicket").isChecked()) ||  (ledgerType == <%=LkSNLedgerType.Amortization.getCode()%>);
  
  var $trs = $("#rule-detail-body tr");
  for (var i=0; i<$trs.length; i++) {
    var $tr = $($trs[i]);
    var idx = $tr.attr("data-id");
    var radioWeightGroupName = "radio-weight-type-group-" + idx; 
    var radioGroupValue = $("input[name='" + radioWeightGroupName + "']:checked").val();
    if (radioGroupValue == '<%=FIXED_TYPE%>') {
      if (!usedTickets)
        $tr.attr("data-weighttype", "perc");
      else
        $tr.attr("data-weighttype", "perc-loc");
    }
    else if (radioGroupValue == '<%=GATE_CAT_TYPE%>') 
      $tr.attr("data-weighttype", "gate-cat");
    else {
      $("input[name='" + radioWeightGroupName + "']").prop('checked',false);
      $("input[name='" + radioWeightGroupName + "'][value='<%=FIXED_TYPE%>']").prop('checked', true);
      $tr.attr("data-weighttype", "perc");
    }
  }
  if (!usedTickets)
    $("#used-location-only-block").addClass("hidden");
  else
    $("#used-location-only-block").removeClass("hidden");
  
  if (!usedTickets || (ledgerType == <%=LkSNLedgerType.Amortization.getCode()%>))
	  $("#prod-upgrade-location-only-block").addClass("hidden");
	else
	  $("#prod-upgrade-location-only-block").removeClass("hidden");
}

function setPluginDetailsVisibility() {
	let usePlugin = $("#ledgerRule\\.UsePlugin").isChecked();
  if (usePlugin) {
    $("#plugin-detail-grid").show();
    $("#rule-detail-grid").hide();
  }
  else {
    $("#plugin-detail-grid").hide();
    $("#rule-detail-grid").show();
  }
}

function refreshVisibility() {
  setPluginDetailsVisibility();

  var ledgerEntityType = <%=ledgerRule.TriggerEntityType.getInt()%>;
  
  var ledgerType = parseInt($("#ledgerRule\\.LedgerTriggerType").val());
  
  var isRefundUpgradeExpirationTrigger = (ledgerType == <%=LkSNLedgerType.Refund.getCode()%>) || (ledgerType == <%=LkSNLedgerType.UpgradeSrc.getCode()%>) || (ledgerType == <%=LkSNLedgerType.UpgradeDst.getCode()%>) || (ledgerType == <%=LkSNLedgerType.Clearing.getCode()%>) || (ledgerType == <%=LkSNLedgerType.Expiration.getCode()%>);
  
  var isAdmissionTrigger = (ledgerType > <%=LkSNLedgerType.AdmissionStart%>) && (ledgerType < <%=LkSNLedgerType.AdmissionEnd%>); 
  
  var isProdFirstUsageTrigger = (ledgerType == <%=LkSNLedgerType.RedeemFirstUsage.getCode()%>);
  
  var isProductWalletRewardClearing = <%=isProductTriggerType%> && (ledgerType == <%=LkSNLedgerType.WalletClearing.getCode()%> || ledgerType == <%=LkSNLedgerType.RewardPointClearing.getCode()%>);
 
  var $amountType = $("#ledgerRule\\.LedgerRuleAmountType");
  var hideTriggerRefund = 
    (ledgerType != <%=LkSNLedgerType.ResPayNotEnc.getCode()%>) && 
    (ledgerType != <%=LkSNLedgerType.ResEncNotPaid.getCode()%>) &&
    (ledgerType != <%=LkSNLedgerType.SalePay.getCode()%>) &&
    (ledgerType != <%=LkSNLedgerType.SaleEncoding.getCode()%>) &&
    (ledgerType != <%=LkSNLedgerType.SalePayEncoding.getCode()%>);
  var hideTriggerResStatus = (ledgerType != <%=LkSNLedgerType.Refund.getCode()%>);
  var hideTriggerOrderPayment = !_allowTriggerOrderPayment(ledgerType);
  var hideAmount = ($amountType.val() == <%=LkSNLedgerRuleAmountType.VPT.getCode()%>) || ($amountType.val() == <%=LkSNLedgerRuleAmountType.RedeemValue.getCode()%>);
  var isResource = (ledgerType == <%=LkSNLedgerType.ResourceHandOver.getCode()%>) || (ledgerType == <%=LkSNLedgerType.ResourceReturn.getCode()%>);
  var hideTriggerPointsValidForDiscount = 
	  ($amountType.val() != <%=LkSNLedgerRuleAmountType.PercPPUGrossExclComm.getCode()%>) && 
	  ($amountType.val() != <%=LkSNLedgerRuleAmountType.PercPPUGrossInclComm.getCode()%>) &&
	  ($amountType.val() != <%=LkSNLedgerRuleAmountType.PercPPUNetExclComm.getCode()%>) &&
	  ($amountType.val() != <%=LkSNLedgerRuleAmountType.PercPPUNetInclComm.getCode()%>);
  
  $("#only-product-block").setClass("hidden", ledgerEntityType == <%=LkSNEntityType.PaymentMethod.getCode()%> || ledgerEntityType == <%=LkSNEntityType.Tax.getCode()%>);
  $("#workstation-type-filter").setClass("hidden", isAdmissionTrigger || isResource || ledgerType == <%=LkSNLedgerType.Clearing.getCode()%> || ledgerType == <%=LkSNLedgerType.Expiration.getCode()%> || ledgerType == <%=LkSNLedgerType.Breakage.getCode()%> || ledgerType == <%=LkSNLedgerType.Amortization.getCode()%>);
  $("#usage-filter").setClass("hidden", !isRefundUpgradeExpirationTrigger);
  $("#product-location-filter").setClass("hidden", !_isUpgradeFlagVisible(ledgerType) && !isAdmissionTrigger);
  $("#product-workstation-filter").setClass("hidden", !_isUpgradeFlagVisible(ledgerType) && !isAdmissionTrigger);
  $("#gate-category-filter").setClass("hidden", !isAdmissionTrigger);
  $("#event-filter").setClass("hidden", !isAdmissionTrigger && (ledgerType != <%=LkSNLedgerType.SalePay.getCode()%>));
  $("#access-point-filter").setClass("hidden", !isAdmissionTrigger && (ledgerType != <%=LkSNLedgerType.SalePay.getCode()%>));
  $("#membershippoint-filter").setClass("hidden", <%=!isWalletDeposit%> && <%=!isWalletClearing%> && <%=!isRewardClearing%> && !isProductWalletRewardClearing && <%=!walletRewardPaymentMethod%>);
  $("#trigger-refund").setClass("hidden", hideTriggerRefund || 
																				  <%=isOverRefund%> || 
																				  <%=isWalletDeposit%> || 
																          <%=isWalletClearing%> || 
																          <%=isRewardClearing%>);
  $("#trigger-upgrade").setClass("hidden", (ledgerType != <%=LkSNLedgerType.SalePay.getCode()%> && 
		                                        ledgerType != <%=LkSNLedgerType.Refund.getCode()%> && 
		                                        ledgerType != <%=LkSNLedgerType.SaleEncoding.getCode()%> && 
		                                        ledgerType != <%=LkSNLedgerType.SalePayEncoding.getCode()%>) || 
		                                        <%=isWalletDeposit%> || 
		                                        <%=isWalletClearing%> || 
		                                        <%=isRewardClearing%>);
  $("#trigger-res-status").setClass("hidden", hideTriggerResStatus);
  $("#trigger-order-payment").setClass("hidden", hideTriggerOrderPayment);
  $("#trigger-used-unused").setClass("hidden", !isRefundUpgradeExpirationTrigger || <%=isOverRefund%> || <%=isWalletDeposit%> || <%=isWalletClearing%> || <%=isRewardClearing%>);

  $("#trigger-online-offline").setClass("hidden", !isAdmissionTrigger || (ledgerType == <%=LkSNLedgerType.RedeemPPUPartialAmount.getCode()%>));
  $("#trigger-pointsvalidfordiscount").setClass("hidden", hideTriggerPointsValidForDiscount);
  
  $("#include-filters").setClass("hidden", $("#trigger-used-unused").hasClass("hidden") && $("#trigger-online-offline").hasClass("hidden"));
  $("#additional-triggers").setClass("hidden", 
		  $("#trigger-refund").hasClass("hidden") && 
		  $("#trigger-upgrade").hasClass("hidden") && 
		  $("#trigger-res-status").hasClass("hidden") && 
		  $("#trigger-order-payment").hasClass("hidden")); 
  
  refreshTriggerAndWeightOptions();
  
  $("#value-type-block").setClass("hidden", ledgerType == <%=LkSNLedgerType.Amortization.getCode()%>);
  $("#value-type-value").setClass("hidden", hideAmount);
  
  refreshAutomaticRevert(ledgerType);
  
  var showGeneralOptions = !isProductWalletRewardClearing && (ledgerType != <%=LkSNLedgerType.RedeemPPUPartialAmount.getCode()%>);
  if (showGeneralOptions) 
    $amountType.find("option.general").removeClass("hidden");
  else { 
    $amountType.find("option.general").addClass("hidden");
    if ($amountType.find("option.general").is(":selected")) 
      $amountType.val(<%=LkSNLedgerRuleAmountType.Absolute.getCode()%>);
  }
  
  var showGeneralPaymentOptions = 
	  ledgerType == <%=LkSNLedgerType.SalePay.getCode()%> ||
	  ledgerType == <%=LkSNLedgerType.SalePayEncoding.getCode()%> ||
	  ledgerType == <%=LkSNLedgerType.Refund.getCode()%> ||
	  ledgerType == <%=LkSNLedgerType.UpgradeSrc.getCode()%> ||
	  ledgerType == <%=LkSNLedgerType.UpgradeDst.getCode()%>; 
	  
  if (showGeneralPaymentOptions) 
    $amountType.find("option.general-payment").removeClass("hidden");
  else { 
    $amountType.find("option.general-payment").addClass("hidden");
    if ($amountType.find("option.general-payment").is(":selected")) 
      $amountType.val(<%=LkSNLedgerRuleAmountType.Absolute.getCode()%>);
  }

	var showDiscountOptions = !isProductWalletRewardClearing && (ledgerType != <%=LkSNLedgerType.RedeemPPUPartialAmount.getCode()%>);
	if (showDiscountOptions) 
	  $amountType.find("option.discount").removeClass("hidden");
	else { 
	  $amountType.find("option.discount").addClass("hidden");
	  if ($amountType.find("option.discount").is(":selected")) 
	    $amountType.val(<%=LkSNLedgerRuleAmountType.Absolute.getCode()%>);
	}
  
  var showClearingOptions = (ledgerType != <%=LkSNLedgerType.SalePay.getCode()%>) && !isProductWalletRewardClearing && (ledgerType != <%=LkSNLedgerType.RedeemPPUPartialAmount.getCode()%>);
  if (showClearingOptions) 
    $amountType.find("option.clearing").removeClass("hidden");
  else { 
    $amountType.find("option.clearing").addClass("hidden");
    if ($amountType.find("option.clearing").is(":selected")) 
      $amountType.val(<%=LkSNLedgerRuleAmountType.Absolute.getCode()%>);
  } 
  
  var showWalletPointClearing = 
      (ledgerType == <%=LkSNLedgerType.Expiration.getCode()%>) || 
      (ledgerType == <%=LkSNLedgerType.Clearing.getCode()%>) ||
      (ledgerType == <%=LkSNLedgerType.Breakage.getCode()%>) ||
      (ledgerType == <%=LkSNLedgerType.WalletClearing.getCode()%>) ||
      <%=isWalletClearing%>;
    if (showWalletPointClearing) 
      $amountType.find("option.wallet").removeClass("hidden");
    else {
      $amountType.find("option.wallet").addClass("hidden");
      if ($amountType.find("option.wallet").is(":selected")) 
        $amountType.val(<%=LkSNLedgerRuleAmountType.Absolute.getCode()%>);
    }
  
  var showRewardPointClearing = 
    (ledgerType == <%=LkSNLedgerType.Expiration.getCode()%>) || 
    (ledgerType == <%=LkSNLedgerType.Clearing.getCode()%>) ||
    (ledgerType == <%=LkSNLedgerType.Breakage.getCode()%>) ||
    (ledgerType == <%=LkSNLedgerType.RewardPointClearing.getCode()%>) ||
    <%=isRewardClearing%>;
  if (showRewardPointClearing) 
    $amountType.find("option.reward-point").removeClass("hidden");
  else {
    $amountType.find("option.reward-point").addClass("hidden");
    if ($amountType.find("option.reward-point").is(":selected")) 
      $amountType.val(<%=LkSNLedgerRuleAmountType.Absolute.getCode()%>);
  }
  
  var $optVPT = $amountType.find("option.vpt");
  var $optPoints = $amountType.find("option.points");
    
  if (isAdmissionTrigger && (ledgerType != <%=LkSNLedgerType.RedeemPPUPartialAmount.getCode()%>)) 
    $optVPT.removeClass("hidden");
  else {
    $optVPT.addClass("hidden");
    if ($optVPT.is(":selected")) {
      $amountType.val(<%=LkSNLedgerRuleAmountType.Absolute.getCode()%>);
      $("#trigger-pointsvalidfordiscount").setClass("hidden", true);
    }
  }
  
  if (isAdmissionTrigger) 
    $optPoints.removeClass("hidden");
  else {
    $optPoints.addClass("hidden");
    if ($optPoints.is(":selected")) {
      $amountType.val(<%=LkSNLedgerRuleAmountType.Absolute.getCode()%>);
      $("#trigger-pointsvalidfordiscount").setClass("hidden", true);
    }
  }

  var $optRedeem = $amountType.find("option.redeem");
  if (isProdFirstUsageTrigger)
    $amountType.find("option.redeem").removeClass("hidden");
  else {
    $amountType.find("option.redeem").addClass("hidden");
    if ($amountType.find("option.redeem").is(":selected")) 
      $amountType.val(<%=LkSNLedgerRuleAmountType.Absolute.getCode()%>);
  }
 
  refreshWeight();
  adjustLocationOptions(ledgerType);
}

function refreshAutomaticRevert(ledgerType) {
  let isRefund = (ledgerType == <%=LkSNLedgerType.Refund.getCode()%>) && $("#ledgerRule\\.AutomaticRevertRefund").isChecked();
  $("#ledgerRule-automaticRevertRefund").toggleClass("hidden", !isRefund);
  $("#automatic-revert-refund-block").toggleClass("hidden", ledgerType != <%=LkSNLedgerType.Refund.getCode()%>);
	$("#automatic-revert-refund-block #ledgerRule\\.AutoRevertLedgerAccountId").toggleClass("hidden", !isRefund);
  $("#automatic-revert-refund-block #autorevert-location-select").toggleClass("hidden", !isRefund);

	
	let isUpgradeDest = (ledgerType == <%=LkSNLedgerType.UpgradeDst.getCode()%>) && $("#ledgerRule\\.AutomaticRevertUpgrade").isChecked();
  $("#ledgerRule-automaticRevertUpgrade").toggleClass("hidden", !isUpgradeDest);
	$("#automatic-revert-upgrade-block").toggleClass("hidden", ledgerType != <%=LkSNLedgerType.UpgradeDst.getCode()%>);
	$("#automatic-revert-upgrade-block #ledgerRule\\.AutoRevertLedgerAccountId").toggleClass("hidden", !isUpgradeDest);
	$("#automatic-revert-upgrade-block #autorevert-location-select").toggleClass("hidden", !isUpgradeDest);
	
	if (isRefund) {
	  $("#plugin-detail-grid").hide();
	  $("#rule-detail-grid").hide();
	}
	else
	  setPluginDetailsVisibility();
}

function refreshTriggerAndWeightOptions() {
  let triggerType = parseInt($("#ledgerRule\\.LedgerTriggerType").val()); 
  let allowTriggerOnRefund = _allowTriggerRefund(triggerType); 
  let allowTriggerOnUpgrade = _isUpgradeFlagVisible(triggerType);
  let $additionalTriggers = $("input[name='AdditionalTriggers'][type='checkbox']");
	
	let activateAdditionalTriggers = 
	      (<%=ledgerRule.TriggerOnRefund.getBoolean()%>  && allowTriggerOnRefund) ||
	      (<%=ledgerRule.TriggerOnUpgrade.getBoolean()%> && allowTriggerOnUpgrade) ||
	      <%=ledgerRule.TriggerOnPaidNotEnc.getBoolean()%> ||
	      <%=ledgerRule.TriggerOnEncNotPaid.getBoolean()%> ||
	      <%=ledgerRule.TriggerOnUnpaidProduct.getBoolean()%>;
	      
	  if (activateAdditionalTriggers) {
      if (!$additionalTriggers.isChecked())
        $additionalTriggers.click();
	  } 
	  else {
      if ($additionalTriggers.isChecked())
        $additionalTriggers.click();
    }
	  

	  let activateWeightOptions = 
	      <%=ledgerRule.MultiplyWeight.getBoolean()%> ||
	      <%=ledgerRule.IncludeUpgradedProductsUsages.getBoolean()%> ||
	      <%=ledgerRule.InheritProductWeights.getBoolean()%>;
	  if (activateWeightOptions) {
	    let $weightOptions = $("input[name='WeightOptions'][type='checkbox']");
	    if (!$weightOptions.isChecked())
	      $weightOptions.click();
	  }
}

function _isUpgradeFlagVisible(ledgerTriggerType) {
  var allowedValues = [<%=JvArray.arrayToString(LookupManager.getIntArray(LkSNLedgerType.SalePay, LkSNLedgerType.Refund, LkSNLedgerType.SaleEncoding, LkSNLedgerType.SalePayEncoding), ",")%>];
  return (allowedValues.indexOf(ledgerTriggerType) >= 0);
}

function adjustLocationOptions(ledgerType) {
  var isNotUpgrade = (ledgerType != <%=LkSNLedgerType.UpgradeSrc.getCode()%>) && (ledgerType != <%=LkSNLedgerType.UpgradeDst.getCode()%>);
  var isWalletDeposit = <%=isWalletDeposit%>;
  var isWalletClearing = <%=isWalletClearing%>;
  var isRewardClearing = <%=isRewardClearing%>;
  
  $(".DebitLocationTypeTemplate-Select option[value='<%=LkSNLedgerRuleAccountType.TransactionLocation.getCode()%>']").setClass("hidden", isNotUpgrade);  
  $(".DebitLocationTypeTemplate-Select option[value='<%=LkSNLedgerRuleAccountType.AdmissionLocation.getCode()%>']").setClass("hidden", isWalletDeposit || isWalletClearing || isRewardClearing);
  $(".DebitLocationTypeTemplate-Select option[value='<%=LkSNLedgerRuleAccountType.ProductLocation.getCode()%>']").setClass("hidden", isWalletDeposit || isWalletClearing || isRewardClearing);
  
  $(".CreditLocationTypeTemplate-Select option[value='<%=LkSNLedgerRuleAccountType.TransactionLocation.getCode()%>']").setClass("hidden", isNotUpgrade);
  $(".CreditLocationTypeTemplate-Select option[value='<%=LkSNLedgerRuleAccountType.AdmissionLocation.getCode()%>']").setClass("hidden", isWalletDeposit || isWalletClearing || isRewardClearing);
  $(".CreditLocationTypeTemplate-Select option[value='<%=LkSNLedgerRuleAccountType.ProductLocation.getCode()%>']").setClass("hidden", isWalletDeposit || isWalletClearing || isRewardClearing);
  
  if (isNotUpgrade) {
    var trs = $("#rule-detail-body tr");
    for (var i=0; i<trs.length; i++) {
      var tr = $(trs[i]);
      locationColumn = tr.find(".DebitLocationTypeTemplate-Select");
      if ($(locationColumn).val() == <%=Integer.toString(LkSNLedgerRuleAccountType.TransactionLocation.getCode())%>)
        $(locationColumn).val(<%=LkSNLedgerRuleAccountType.SaleLocation.getCode()%>);
      locationColumn = tr.find(".CreditLocationTypeTemplate-Select");
      if ($(locationColumn).val() == <%=Integer.toString(LkSNLedgerRuleAccountType.TransactionLocation.getCode())%>)
        $(locationColumn).val(<%=LkSNLedgerRuleAccountType.SaleLocation.getCode()%>);
    }
  }
  
}

function loadRuleDetailList() {
  lastIdx = 0;
  <% if (ledgerRule.LedgerRuleDetailList.getSize() == 0) {%>
    addEmptyDetailLine();
  <% } else {
    for (int i=0; i<ledgerRule.LedgerRuleDetailList.getSize(); i++) { %>
      var weightStr = <%=ledgerRule.LedgerRuleDetailList.getItem(i).Weight.isNull() || (ledgerRule.LedgerRuleDetailList.getItem(i).Weight.getMoney() == 0) %> ? "100%" : <%=ledgerRule.LedgerRuleDetailList.getItem(i).Weight.getString()%>;
      addRuleDetail(lastIdx, <%=ledgerRule.LedgerRuleId.getJsString()%>,
        <%=ledgerRule.LedgerRuleDetailList.getItem(i).DebitLedgerAccountId.getJsString()%>,
        <%=ledgerRule.LedgerRuleDetailList.getItem(i).DebitAccountType.getInt()%>,
        <%=ledgerRule.LedgerRuleDetailList.getItem(i).DebitAccountId.getJsString()%>,
        <%=ledgerRule.LedgerRuleDetailList.getItem(i).CreditLedgerAccountId.getJsString()%>,
        <%=ledgerRule.LedgerRuleDetailList.getItem(i).CreditAccountType.getInt()%>,
        <%=ledgerRule.LedgerRuleDetailList.getItem(i).CreditAccountId.getJsString()%>,
        weightStr,
        <%=ledgerRule.LedgerRuleDetailList.getItem(i).WeightType.getInt()%>,
        <%=ledgerRule.LedgerRuleDetailList.getItem(i).UsageFilterLocationId.getJsString()%>,
        <%=ledgerRule.LedgerRuleDetailList.getItem(i).GateCategoryId.getJsString()%>,
        <%=ledgerRule.LedgerRuleDetailList.getItem(i).LedgerRuleDetailSerial.getJsString()%>);
    <% } %>
  <% } %>
}

function loadAutomaticRevert() {
	$("#ledgerRule\\.AutomaticRevertRefund").change(refreshVisibility);
	$("#ledgerRule\\.AutomaticRevertUpgrade").change(refreshVisibility);
	  
  let triggerTypeRefund = parseInt($("#ledgerRule\\.LedgerTriggerType").val()) == <%=LkSNLedgerType.Refund.getCode()%>; 
  let triggerTypeUpgradeDest = parseInt($("#ledgerRule\\.LedgerTriggerType").val()) == <%=LkSNLedgerType.UpgradeDst.getCode()%>;
  let autoRevertLocValue = <%=ledgerRule.AutoRevertLocationType.getInt()%> == <%=LkSNLedgerRuleAccountType.Fixed.getCode()%> ? <%=ledgerRule.AutoRevertLocationId.getJsString()%> : <%=ledgerRule.AutoRevertLocationType.getInt()%>;
  
	$("#ledgerRule\\.AutomaticRevertRefund").prop("checked", <%=ledgerRule.AutomaticRevert.getBoolean()%> && triggerTypeRefund);
	$("#ledgerRule\\.AutomaticRevertUpgrade").prop("checked", <%=ledgerRule.AutomaticRevert.getBoolean()%> && triggerTypeUpgradeDest);
	
	if (triggerTypeRefund) {
	  $("#ledgerRule\\.AutoRevertRefundLedgerAccountId").val(<%=ledgerRule.AutoRevertLedgerAccountId.getJsString()%>);
	  $("#autorevert-location-refund-select").val(autoRevertLocValue);
	  $("#auto-hide-automaticrevertrefund").toggleClass("hidden", <%=!ledgerRule.AutomaticRevert.getBoolean()%>);
	}
	
	if (triggerTypeUpgradeDest) {
    $("#ledgerRule\\.AutoRevertUpgradeLedgerAccountId").val(<%=ledgerRule.AutoRevertLedgerAccountId.getJsString()%>);
    $("#autorevert-location-upgrade-select").val(autoRevertLocValue);
    $("#auto-hide-automaticrevertupgrade").toggleClass("hidden", <%=!ledgerRule.AutomaticRevert.getBoolean()%>);
	}
}

$(document).ready(function() {
  $("#tabs").tabs();

  loadRuleDetailList();
  
  var sel = $("#ledgerRule\\.LedgerTriggerType");
  $(sel).find("option").each(function(i){
    if ($(this).val() == <%=ledgerRule.LedgerTriggerType.getSqlString()%>)
      $(this).attr("selected","selected");
  });
  
  <% if (ledgerRule.FilterLocationId.getString() != null) { %>
     var sel = $("#ledgerRule\\.FilterLocationId");
     $(sel).find("option").each(function(i){
       if ($(this).val() == <%=ledgerRule.FilterLocationId.getSqlString()%>)
         $(this).attr("selected","selected");
     });
  <% } %>
  
  <% if (ledgerRule.FilterWorkstationId.getString() != null) { %>
    var sel = $("#ledgerRule\\.FilterWorkstationId");
    $(sel).find("option").each(function(i){
      if ($(this).val() == <%=ledgerRule.FilterWorkstationId.getSqlString()%>)
        $(this).attr("selected","selected");
    });
  <% } %>
  
  <% if (ledgerRule.FilterSaleLocationId.getString() != null) { %>
     var sel = $("#ledgerRule\\.FilterSaleLocationId");
     $(sel).find("option").each(function(i){
       if ($(this).val() == <%=ledgerRule.FilterSaleLocationId.getSqlString()%>)
       $(this).attr("selected","selected");
     });
  <% } %>
  
  $("#ledgerRule\\.LedgerRuleAmountType option[value='<%=LkSNLedgerRuleAmountType.PercGrossInclComm.getCode()%>']").addClass("general");
  $("#ledgerRule\\.LedgerRuleAmountType option[value='<%=LkSNLedgerRuleAmountType.PercGrossExclComm.getCode()%>']").addClass("general");
  $("#ledgerRule\\.LedgerRuleAmountType option[value='<%=LkSNLedgerRuleAmountType.PercNetInclComm.getCode()%>']").addClass("general");
  $("#ledgerRule\\.LedgerRuleAmountType option[value='<%=LkSNLedgerRuleAmountType.PercNetExclComm.getCode()%>']").addClass("general");
  $("#ledgerRule\\.LedgerRuleAmountType option[value='<%=LkSNLedgerRuleAmountType.PercTax.getCode()%>']").addClass("general");
  $("#ledgerRule\\.LedgerRuleAmountType option[value='<%=LkSNLedgerRuleAmountType.PercComm.getCode()%>']").addClass("general");
  $("#ledgerRule\\.LedgerRuleAmountType option[value='<%=LkSNLedgerRuleAmountType.PercCommTax.getCode()%>']").addClass("general");
  
  $("#ledgerRule\\.LedgerRuleAmountType option[value='<%=LkSNLedgerRuleAmountType.PercDiscAmount.getCode()%>']").addClass("discount");
  $("#ledgerRule\\.LedgerRuleAmountType option[value='<%=LkSNLedgerRuleAmountType.PercDiscBearedAmount.getCode()%>']").addClass("discount");
  $("#ledgerRule\\.LedgerRuleAmountType option[value='<%=LkSNLedgerRuleAmountType.PercDiscNotBearedAmount.getCode()%>']").addClass("discount");
  
  $("#ledgerRule\\.LedgerRuleAmountType option[value='<%=LkSNLedgerRuleAmountType.PercClearingUsed.getCode()%>']").addClass("clearing");
  $("#ledgerRule\\.LedgerRuleAmountType option[value='<%=LkSNLedgerRuleAmountType.PercClearingLeft.getCode()%>']").addClass("clearing");
  $("#ledgerRule\\.LedgerRuleAmountType option[value='<%=LkSNLedgerRuleAmountType.PercClearingOver.getCode()%>']").addClass("clearing");
  $("#ledgerRule\\.LedgerRuleAmountType option[value='<%=LkSNLedgerRuleAmountType.PercClearingUnder.getCode()%>']").addClass("clearing");
  
  $("#ledgerRule\\.LedgerRuleAmountType option[value='<%=LkSNLedgerRuleAmountType.VPT.getCode()%>']").addClass("vpt");
  $("#ledgerRule\\.LedgerRuleAmountType option[value='<%=LkSNLedgerRuleAmountType.RedeemValue.getCode()%>']").addClass("redeem");
  
  $("#ledgerRule\\.LedgerRuleAmountType option[value='<%=LkSNLedgerRuleAmountType.PercGrossClearingWallet.getCode()%>']").addClass("wallet");
  $("#ledgerRule\\.LedgerRuleAmountType option[value='<%=LkSNLedgerRuleAmountType.PercNetClearingWallet.getCode()%>']").addClass("wallet");
  $("#ledgerRule\\.LedgerRuleAmountType option[value='<%=LkSNLedgerRuleAmountType.PercTaxClearingWallet.getCode()%>']").addClass("wallet");
  $("#ledgerRule\\.LedgerRuleAmountType option[value='<%=LkSNLedgerRuleAmountType.PercGrossClearingRewardPoint.getCode()%>']").addClass("reward-point");
  $("#ledgerRule\\.LedgerRuleAmountType option[value='<%=LkSNLedgerRuleAmountType.PercNetClearingRewardPoint.getCode()%>']").addClass("reward-point");
  $("#ledgerRule\\.LedgerRuleAmountType option[value='<%=LkSNLedgerRuleAmountType.PercTaxClearingRewardPoint.getCode()%>']").addClass("reward-point");
  
  $("#ledgerRule\\.LedgerRuleAmountType option[value='<%=LkSNLedgerRuleAmountType.PercPPUComm.getCode()%>']").addClass("points");
  $("#ledgerRule\\.LedgerRuleAmountType option[value='<%=LkSNLedgerRuleAmountType.PercPPUFee.getCode()%>']").addClass("points");
  
  $("#ledgerRule\\.LedgerRuleAmountType option[value='<%=LkSNLedgerRuleAmountType.PercPPUGrossInclComm.getCode()%>']").addClass("points");
  $("#ledgerRule\\.LedgerRuleAmountType option[value='<%=LkSNLedgerRuleAmountType.PercPPUGrossExclComm.getCode()%>']").addClass("points");
  $("#ledgerRule\\.LedgerRuleAmountType option[value='<%=LkSNLedgerRuleAmountType.PercPPUNetInclComm.getCode()%>']").addClass("points");
  $("#ledgerRule\\.LedgerRuleAmountType option[value='<%=LkSNLedgerRuleAmountType.PercPPUNetExclComm.getCode()%>']").addClass("points");
  
  $("#ledgerRule\\.UsedTicket").change(refreshVisibility);
  $("#ledgerRule\\.LedgerTriggerType").change(refreshVisibility);
  $("#ledgerRule\\.UsePlugin").change(refreshVisibility);
  $("#ledgerRule\\.LedgerRuleAmountType").change(refreshVisibility);
  

  
  loadAutomaticRevert();
  
  var pluginId = <%=ledgerRule.PluginId.getJsString()%>;
  var usePlugin = pluginId != null && pluginId != "";
  var active = $("#ledgerRule\\.Active").isChecked();
  
  $("#ledgerRule\\.UsePlugin").prop("checked", usePlugin);
  if (usePlugin)
    $("#ledgerRule\\.Active").prop("checked", active && <%=pluginEnabled%>);
    
  refreshVisibility();
});

function findWeightType(value, type) {
  if ((type == undefined) || (type == '<%=FIXED_TYPE%>')) {
    if (value.indexOf("%") >= 0) 
      return <%=LkSNLedgerRuleWeightType.Percentage.getCode()%>; 
    else
      return <%=LkSNLedgerRuleWeightType.Absolute.getCode()%>;
  } else {
    return <%=LkSNLedgerRuleWeightType.GateCat.getCode()%>;
  }
}

function convertWeight(value) {
  var result = null;
  value = value.replace("%", "");
  value = value.replace(",", ".");
  if (value != "") {
    result = parseFloat(value);
    if (isNaN(result))
      result = null;
  }
  return result;
}

function getLedgerRuleDetailList(triggerType) {
  var list = [];
  var trs = $("#rule-detail-body tr");
  for (var i=0; i<trs.length; i++) {
    var tr = $(trs[i]);
    
    var idx = tr.attr("data-id");
    
    var radioWeightGroupName = "radio-weight-type-group-" + idx; 
    var radioGroupValue = $("input[name='" + radioWeightGroupName + "']:checked").val();  
    var weightType = findWeightType(tr.find(".txt-perc").val(), radioGroupValue);
    var weight = weightType == <%=LkSNLedgerRuleWeightType.GateCat.getCode()%> ? null : convertWeight(tr.find(".txt-perc").val());

    var tDebit = tr.find(".DebitLocationTypeTemplate-Select option:selected");
    var debitAccountType = parseInt(tDebit.attr("data-accounttype"));
    var debitAccountId = (debitAccountType == <%=LkSNLedgerRuleAccountType.Fixed.getCode()%>) ? tDebit.val() : null; 
    
    var tCredit = tr.find(".CreditLocationTypeTemplate-Select option:selected");
    var creditAccountType = parseInt(tCredit.attr("data-accounttype"));
    var creditAccountId = (creditAccountType == <%=LkSNLedgerRuleAccountType.Fixed.getCode()%>) ? tCredit.val() : null; 
    
    var usageFilterLocationId = getNull(tr.find(".usage-filter-loc-select option:selected").val());
    var gateCategoryId = getNull(tr.find(".gate-cat-select option:selected").val());
    
    list.push({
      LedgerRuleDetailSerial: tr.attr("data-DetailSerialNumber"),
      DebitLedgerAccountId: tr.find("#LedgerAccountId.DebitLedgerAccountTemplate-Select").val(),
      DebitAccountType: debitAccountType,
      DebitAccountId: debitAccountId,
      CreditLedgerAccountId: tr.find("#LedgerAccountId.CreditLedgerAccountTemplate-Select").val(),
      CreditAccountType: creditAccountType,
      CreditAccountId: creditAccountId,
      Weight: weight,
      WeightType: weightType,
      UsageFilterLocationId: (triggerType == <%=LkSNLedgerType.Clearing.getCode()%> || triggerType == <%=LkSNLedgerType.Expiration.getCode()%> || triggerType == <%=LkSNLedgerType.Amortization.getCode()%>) ?  usageFilterLocationId : null,
      GateCategoryId: (weightType == <%=LkSNLedgerRuleWeightType.GateCat.getCode()%>) ? gateCategoryId : null
    });
  }
  return list;
}

function _allowTriggerRefund(ledgerType) {
  let allowTriggerRefund = 
    (ledgerType == <%=LkSNLedgerType.ResPayNotEnc.getCode()%>) || 
    (ledgerType == <%=LkSNLedgerType.ResEncNotPaid.getCode()%>) ||
    (ledgerType == <%=LkSNLedgerType.SalePay.getCode()%>) ||
    (ledgerType == <%=LkSNLedgerType.SaleEncoding.getCode()%>) ||
    (ledgerType == <%=LkSNLedgerType.SalePayEncoding.getCode()%>);
  
  return allowTriggerRefund;
}

function _allowTriggerOrderPayment(ledgerType) {
  let allowTriggerOrderPayment =
    (ledgerType == <%=LkSNLedgerType.Breakage.getCode()%>) ||
    (ledgerType == <%=LkSNLedgerType.Clearing.getCode()%>) ||
    (ledgerType == <%=LkSNLedgerType.Expiration.getCode()%>);
  
  return allowTriggerOrderPayment;
}

function doSaveLedgerRule(callback) {
  let triggerType = parseInt($("#ledgerRule\\.LedgerTriggerType").val());
  let $amountType = $("#ledgerRule\\.LedgerRuleAmountType");
  
  let isRefundUpgradeExpirationTrigger = (triggerType == <%=LkSNLedgerType.Refund.getCode()%>) || (triggerType == <%=LkSNLedgerType.UpgradeSrc.getCode()%>) || (triggerType == <%=LkSNLedgerType.UpgradeDst.getCode()%>) || (triggerType == <%=LkSNLedgerType.Clearing.getCode()%> || triggerType == <%=LkSNLedgerType.Expiration.getCode()%>);
  let isAdmissionTrigger = (triggerType > <%=LkSNLedgerType.AdmissionStart%>) && (triggerType < <%=LkSNLedgerType.AdmissionEnd%>); 
  
  let filterWorkstationType = parseInt($("#ledgerRule\\.FilterWorkstationType").val());
  if ((isAdmissionTrigger) || (triggerType == <%=LkSNLedgerType.Clearing.getCode()%>) || (triggerType == <%=LkSNLedgerType.Expiration.getCode()%>)) 
    filterWorkstationType = null;
  
  let filterLocation = $("#ledgerRule\\.FilterLocationId").val();
  let filterWorkstation = $("#ledgerRule\\.FilterWorkstationId").val();
  if (triggerType == <%=LkSNLedgerType.Clearing.getCode()%> || triggerType == <%=LkSNLedgerType.Expiration.getCode()%>) {
    filterLocation = null;
    filterWorkstation = null;
  }
    
  let filterSaleWorkstationType = parseInt($("#ledgerRule\\.FilterSaleWorkstationType").val());
  let filterSaleLocation = $("#ledgerRule\\.FilterSaleLocationId").val();
  let filterGateCategory = $("#ledgerRule\\.FilterGateCategoryId").val();
  let filterEvent = $("#ledgerRule\\.FilterEventId").val();
  let filterAccessPoint = $("#ledgerRule\\.FilterAccessPointId").val();
  let filterTaxExempt = parseInt($("#ledgerRule\\.FilterTaxExempt").val());
  
  let walletRewardPaymentMethod = <%=walletRewardPaymentMethod%>;
  let isWalletDeposit = <%=isWalletDeposit%>;
  let isWalletClearing = <%=isWalletClearing%>;
  let isRewardClearing = <%=isRewardClearing%>;
  let isProductWalletRewardClearing = <%=isProductTriggerType%> && (triggerType == <%=LkSNLedgerType.WalletClearing.getCode()%> || triggerType == <%=LkSNLedgerType.RewardPointClearing.getCode()%>);
  
  let allowTriggerOnPoints = 
      ($amountType.val() == <%=LkSNLedgerRuleAmountType.PercPPUGrossExclComm.getCode()%>) || 
      ($amountType.val() == <%=LkSNLedgerRuleAmountType.PercPPUGrossInclComm.getCode()%>) ||
      ($amountType.val() == <%=LkSNLedgerRuleAmountType.PercPPUNetExclComm.getCode()%>) ||
      ($amountType.val() == <%=LkSNLedgerRuleAmountType.PercPPUNetInclComm.getCode()%>);
  
  let weightOnUsagesType = triggerType == <%=LkSNLedgerType.Clearing.getCode()%> || triggerType == <%=LkSNLedgerType.Expiration.getCode()%> || triggerType == <%=LkSNLedgerType.Amortization.getCode()%>;
  
  let additionalTriggersChecked = $("input[name='AdditionalTriggers'][type='checkbox']").isChecked();
  let weightOptions = $("input[name='WeightOptions'][type='checkbox']").isChecked();
  
  let reqDO = {
    Command: "SaveLedgerRule",
    SaveLedgerRule: {
      LedgerRule: {
        LedgerRuleId: <%=ledgerRule.LedgerRuleId.getJsString()%>,
        LedgerTriggerType: triggerType,
        LedgerRuleStatus: $("#ledgerRule\\.Active").isChecked() ? <%=LkSNLedgerRuleStatus.Active.getCode()%> : <%=LkSNLedgerRuleStatus.Inactive.getCode()%>,
        TriggerEntityType: <%=ledgerRule.TriggerEntityType.getJsString()%>,
        TriggerEntityId: <%=ledgerRule.TriggerEntityId.getJsString()%>,
        TriggerOnRefund: $("#ledgerRule\\.TriggerOnRefund").isChecked() && _allowTriggerRefund(triggerType) && additionalTriggersChecked,
        TriggerOnUpgrade: $("#ledgerRule\\.TriggerOnUpgrade").isChecked() && _isUpgradeFlagVisible(triggerType) && additionalTriggersChecked,
        TriggerOnPaidNotEnc: $("#ledgerRule\\.TriggerOnPaidNotEnc").isChecked() && additionalTriggersChecked,
        TriggerOnEncNotPaid: $("#ledgerRule\\.TriggerOnEncNotPaid").isChecked() && additionalTriggersChecked,
        TriggerOnPointsValidForDiscount: $("#ledgerRule\\.TriggerOnPointsValidForDiscount").isChecked() && allowTriggerOnPoints,
        TriggerOnPointsValidForPayment: $("#ledgerRule\\.TriggerOnPointsValidForPayment").isChecked() && allowTriggerOnPoints,
        TriggerOnUnpaidProduct: $("#ledgerRule\\.TriggerOnUnpaidProduct").isChecked() && _allowTriggerOrderPayment(triggerType) && additionalTriggersChecked,
        FilterWorkstationType: (isNaN(filterWorkstationType)? null : filterWorkstationType),
        FilterLocationId: filterLocation ? filterLocation : null,
        FilterWorkstationId: filterWorkstation ? filterWorkstation : null,
        FilterSaleWorkstationType: (isNaN(filterSaleWorkstationType)? null : filterSaleWorkstationType),
        FilterSaleLocationId: (filterSaleLocation) ? filterSaleLocation : null,
        FilterGateCategoryId: (filterGateCategory) ? filterGateCategory : null,
        FilterEventId: (filterEvent) ? filterEvent : null,
        FilterAccessPointId: (filterAccessPoint) ? filterAccessPoint : null,
        FilterTaxExempt: (filterTaxExempt) ? filterTaxExempt : null,
        FilterPaymentCodes: $("#ledgerRule\\.FilterPaymentCodes").val(),
        FilterMembershipPointIDs: (!walletRewardPaymentMethod && !isWalletDeposit && !isWalletClearing && !isRewardClearing && !isProductWalletRewardClearing) ? '' : $("#ledgerRule\\.FilterMembershipPointIDs").val(),
        FilterSaleChannelIDs: $("#ledgerRule\\.FilterSaleChannelIDs").val(),
        FilterFolioClientIDs: $("#ledgerRule\\.FilterFolioClientIDs").val(),        		
        LedgerRuleAmountType: $("#ledgerRule\\.LedgerRuleAmountType").val(),
        AffectClearingLimit: $("#ledgerRule\\.AffectClearingLimit").isChecked(),
        PluginId: $("#ledgerRule\\.UsePlugin").isChecked() ? $("#ledgerRule\\.PluginId").val(): null,
        LedgerRuleDetailList: $("#ledgerRule\\.UsePlugin").isChecked() ? null : getLedgerRuleDetailList(triggerType),
        IncludeUpgradedProductsUsages: ((triggerType == <%=LkSNLedgerType.Clearing.getCode()%>) || (triggerType == <%=LkSNLedgerType.Expiration.getCode()%>)) && weightOptions ? $("#ledgerRule\\.IncludeUpgradedProductsUsages").isChecked() : false,
        MultiplyWeight: weightOnUsagesType && weightOptions ? $("#ledgerRule\\.MultiplyWeight").isChecked() : false,
        InheritProductWeights: weightOnUsagesType && weightOptions? $("#ledgerRule\\.InheritProductWeights").isChecked() : false,
        ValidOnlineOffline: (isAdmissionTrigger && (triggerType != <%=LkSNLedgerType.RedeemPPUPartialAmount.getCode()%>)) ? $("#ledgerRule\\.ValidOnlineOffline").isChecked() : false,
        InvalidOffline: (isAdmissionTrigger && (triggerType != <%=LkSNLedgerType.RedeemPPUPartialAmount.getCode()%>)) ? $("#ledgerRule\\.InvalidOffline").isChecked() : false,
        UsedTicket: (isRefundUpgradeExpirationTrigger && !isWalletDeposit && !isWalletClearing && !isRewardClearing) ? $("#ledgerRule\\.UsedTicket").isChecked() : false,
        UnusedTicket: (isRefundUpgradeExpirationTrigger && !isWalletDeposit && !isWalletClearing && !isRewardClearing) ? $("#ledgerRule\\.UnusedTicket").isChecked() : false,
        SerialNumber: <%=ledgerRule.SerialNumber.getInt()%>
      }
    }
  };
  fillAutomaticRevert(triggerType, reqDO);
  
  let amount = $("#ledgerRule\\.LedgerRuleAmount").val();
  amount = ((amount) ? amount + "" : "100").trim().replace(",", ".");
  reqDO.SaveLedgerRule.LedgerRule.LedgerRuleAmount = isNaN(amount) ? null : amount;
  
  vgsService("Ledger", reqDO, false, function(ansDO) {
    changeGridPage("#ledgerrule-grid", 1);
    if (callback)
      callback(ansDO.Answer.SaveLedgerRule.LedgerRuleId);
  });
}

function fillAutomaticRevert(triggerType, reqDO) {
	let automaticRevert = ($("#ledgerRule\\.AutomaticRevertRefund").isChecked() && (triggerType == <%=LkSNLedgerType.Refund.getCode()%>)) || 
                        ($("#ledgerRule\\.AutomaticRevertUpgrade").isChecked() && (triggerType == <%=LkSNLedgerType.UpgradeDst.getCode()%>));

	let autoRevertLedgerAccountId = null;
	let autoRevertLocationType = null;
	let autoRevertLocationId = null;
	
	if (triggerType == <%=LkSNLedgerType.Refund.getCode()%>) {
		autoRevertLedgerAccountId = $("#ledgerRule\\.AutoRevertRefundLedgerAccountId").val();
		autoRevertLocationType = parseInt($("#autorevert-location-refund-select option:selected").attr("data-accounttype")),
		autoRevertLocationId = autoRevertLocationType == <%=LkSNLedgerRuleAccountType.Fixed.getCode()%> ? $("#autorevert-location-refund-select").val() : null;
	}
	
	if (triggerType == <%=LkSNLedgerType.UpgradeDst.getCode()%>) {
		autoRevertLedgerAccountId = $("#ledgerRule\\.AutoRevertUpgradeLedgerAccountId").val();
		autoRevertLocationType = parseInt($("#autorevert-location-upgrade-select option:selected").attr("data-accounttype")),
		autoRevertLocationId = autoRevertLocationType == <%=LkSNLedgerRuleAccountType.Fixed.getCode()%> ? $("#autorevert-location-upgrade-select").val() : null;
	}
	
  reqDO.SaveLedgerRule.LedgerRule.AutomaticRevert = automaticRevert;
  reqDO.SaveLedgerRule.LedgerRule.AutoRevertLedgerAccountId = autoRevertLedgerAccountId;
  reqDO.SaveLedgerRule.LedgerRule.AutoRevertLocationType = autoRevertLocationType;
  reqDO.SaveLedgerRule.LedgerRule.AutoRevertLocationId = autoRevertLocationId;
}

</script>