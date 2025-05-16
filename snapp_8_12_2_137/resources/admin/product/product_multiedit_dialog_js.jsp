<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="product_expiration_usagetype_handler_js.jsp"/>

<%
String queryBase64 = pageBase.getNullParameter("QueryBase64");
String sProductIDs = pageBase.getNullParameter("ProductIDs");
%>
 
<script>  
setRadioChecked("[name='AttributeSelection']", <%=LkSNAttributeSelection.Fixed.getCode()%>);
setRadioChecked("[name='PriceTaxSelection']", <%=LkSNTaxCalcType.TaxExempt.getCode()%>);

function refreshAttributeSelectionType(hide) {
  $("#attribute-selection-type-container").setClass("v-hidden", hide);
}

function refreshTaxSelectionType() {
  var priceTaxSelection = $("#ProdME-PriceTaxes").find("[name='PriceTaxSelection']:checked").val();
  var hide = priceTaxSelection == <%=Integer.toString(LkSNTaxCalcType.TaxExempt.getCode())%>;
    $("#pricetaxes-selection").setClass("v-hidden", hide);
}

function refreshProdMEVisibility() {
  var cbs = $("#product_multiedit_dialog .form-field-caption input");
    for (var i=0; i<cbs.length; i++) 
      $(cbs[i]).closest(".form-field").find(".form-field-value").setClass("v-hidden", !$(cbs[i]).isChecked());
}

$(document).ready(function() {
  var dlg = $("#product_multiedit_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {
      <v:itl key="@Common.Ok" encode="JS"/>: doUpdateProducts,
      <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
    };
  });
});

function showAttributePickup() {
  asyncDialogEasy("attribute/attribute_pickup_dialog", "");
}

function attributePickupCallback(obj) {
  if ($(".attribute-item-box[data-AttributeId='" + obj.AttributeId + "']").length > 0) 
    showMessage("<v:itl key="@Product.AttributeAlreadySelected"/> \"" + obj.AttributeName + "\"");
  else {
    obj.SelectionType = <%=LkSNAttributeSelection.Fixed.getCode()%>;
    obj.Active = true;
    addAttributeItem(obj);
  }
}

function addAttributeItem(obj) {
  var divBox = $("<div class='attribute-item-box'/>").insertBefore("#add-btn");
  divBox.attr("data-AttributeItemId", obj.AttributeItemId);
  divBox.attr("data-AttributeId", obj.AttributeId);
  divBox.attr("data-SelectionType", obj.SelectionType);
  divBox.attr("data-Active", obj.Active);
  divBox.attr("onclick", "$(this).remove()");
  
  $("<div class='item-code v-hidden'/>").appendTo(divBox).html(obj.AttributeItemCode);
  $("<div class='item-name'/>").appendTo(divBox).html(obj.AttributeItemName);
  $("<div class='attr-name'/>").appendTo(divBox).html(obj.AttributeName);
  
  if (obj.SeatCategory) {
    divBox.find(".attr-name").addClass("seat");
  }
  
  return divBox;
}

function encodePercValue(originalValue) {
  var value = originalValue;
  value = value.replace("%", "");
  value = value.replace(",", ".");
  value = parseFloat(value);
  return isNaN(value) ? null : value;
}

function encodePresaleValueType(value) {
  if (value.indexOf("%") !== -1) 
    return <%=LkSNPriceValueType.Percentage.getCode()%>;
  else 
    return <%=LkSNPriceValueType.Absolute.getCode()%>;
}

function doUpdateProducts() {
  var reqDO = {
    Command: "SaveMultiEditProduct",
    SaveMultiEditProduct: {
      ProductIDs: <%=JvString.jsString(sProductIDs)%>,
      ProductType: <%=LkSNProductType.Product.getCode()%>,
      QueryBase64: <%=JvString.jsString(queryBase64)%>,
      Product: {
        ProductUpgrade: {
          Flags: {}
        }   
      },
      General: {},
      Templates: {},
      AttAccBio: {},
      Profiles: {},
      RefundUpgradeRenewal: {},
      Price: {},
      Suspension: {},
      RevenueRecognition: {}
    }
  }
  
  var doProceed = true;
  var warnFixedAmount = false;
  var warnTotPercentage = false;
  
  doProceed = doProceed && fillGeneral(reqDO);
  doProceed = doProceed && fillOptions(reqDO);
  doProceed = doProceed && fillTemplates(reqDO);
  doProceed = doProceed && fillAttributeAccountBiometricFamily(reqDO);
  doProceed = doProceed && fillProfiles(reqDO);
  doProceed = doProceed && fillRefundUpgradeRenewal(reqDO);
  doProceed = doProceed && fillPrices(reqDO);
  doProceed = doProceed && fillSuspension(reqDO);
  doProceed = doProceed && fillRevRec(reqDO);
  
  if ($("#ProdME-ClearingLimit [name='field-checkbox']").isChecked()) {
    reqDO.SaveMultiEditProduct.RevenueRecognition.Update = true;
    var clearingLimit = $("#product\\.ClearingLimit").val()=="" ? "100%" : $("#product\\.ClearingLimit").val();
    
    if (clearingLimit.indexOf("%") >= 0)
      clearingLimitType = <%=LkSNPriceValueType.Percentage.getCode()%>; 
    else
      clearingLimitType = <%=LkSNPriceValueType.Absolute.getCode()%>;
    
    warnFixedAmount = clearingLimitType == <%=LkSNPriceValueType.Absolute.getCode()%>
    warnTotPercentage = false;
    
    if (clearingLimitType == <%=LkSNPriceValueType.Percentage.getCode()%>) {
      var totPercentage = reqDO.SaveMultiEditProduct.RevenueRecognition.GateCategoryIDs.length * clearingLimit.replace("%","");
      if (totPercentage != 100)
        warnTotPercentage = true;
    }

    reqDO.SaveMultiEditProduct.RevenueRecognition.ClearingLimitType  = clearingLimitType;
    reqDO.SaveMultiEditProduct.RevenueRecognition.ClearingLimit = clearingLimit=="100%" ? null : clearingLimit.replace("%","");
  }
  
  if (doProceed) {
	  if (warnFixedAmount || warnTotPercentage) {
	    var warnMessage = warnFixedAmount ? <v:itl key="@Product.RevenueRecognitionFixedAmountWarn" encode="JS"/> : <v:itl key="@Product.RevenueRecognitionPercentageAmountWarn" encode="JS"/> 
	    confirmDialog(warnMessage, function () {
	      vgsService("Product", reqDO, false, function(ansDO) {
	        showAsyncProcessDialog(ansDO.Answer.SaveMultiEditProduct.AsyncProcessId, function() {
	         $("#product_multiedit_dialog").dialog("close");
	         triggerEntityChange(<%=LkSNEntityType.ProductType.getCode()%>);
	         });
	      });
	    }, null);
	  } 
	  else {
		  console.log(reqDO);
	    vgsService("Product", reqDO, false, function(ansDO) {
	      showAsyncProcessDialog(ansDO.Answer.SaveMultiEditProduct.AsyncProcessId, function() {
	        $("#product_multiedit_dialog").dialog("close");
	        triggerEntityChange(<%=LkSNEntityType.ProductType.getCode()%>);
	      });
	    });
	  }
  }
}

function fillGeneral(reqDO) {
	
	var requiredPluginList = [];
  var $options = $("#ProdME-PluginIDs option:selected");
  
  $options.each(function() {
    requiredPluginList.push({
      PluginId: $(this).val(),
      PluginName: $(this).text()
    });
  })
	
	if ($("#ProdME-Status .form-field-caption input[type='checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.ProductStatus = $("#ProdME-Status .form-field-value select").val();
  
  if ($("#ProdME-Category .form-field-caption input[type='checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.CategoryId = $("#ProdME-Category .form-field-value select").val();
  
  if ($("#ProdME-Calendar .form-field-caption input[type='checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.CalendarId = $("#ProdME-Calendar .form-field-value select").val();
  
  if ($("#ProdME-VisitCalendar .form-field-caption input[type='checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.VisitCalendarId = $("#ProdME-VisitCalendar .form-field-value select").val();
  
  if ($("#ProdME-DatedCalendar .form-field-caption input[type='checkbox']").isChecked()) 
      reqDO.SaveMultiEditProduct.Product.DatedCalendarId = $("#ProdME-DatedCalendar .form-field-value select").val();
    
  if ($("#ProdME-FromDate .form-field-caption input[type='checkbox']").isChecked()) {
    if ($("#product\\.OnSaleDateFrom-picker") != "")
      reqDO.SaveMultiEditProduct.Product.OnSaleDateFrom = $("#product\\.OnSaleDateFrom-picker").getXMLDate();
    else
      reqDO.SaveMultiEditProduct.Product.OnSaleDateFrom = null;
  }
  
  if ($("#ProdME-ToDate .form-field-caption input[type='checkbox']").isChecked()) {
    if ($("#product\\.OnSaleDateTo-picker") != "")
      reqDO.SaveMultiEditProduct.Product.OnSaleDateTo = $("#product\\.OnSaleDateTo-picker").getXMLDate();
    else
      reqDO.SaveMultiEditProduct.Product.OnSaleDateTo = null;
  }
  
  if ($("#ProdME-FromTime .form-field-caption input[type='checkbox']").isChecked()) {
    if (($("#product\\.OnSaleTimeFrom-HH").getComboIndex() > 0) || ($("#product\\.OnSaleTimeFrom-MM").getComboIndex() > 0))
      reqDO.SaveMultiEditProduct.Product.OnSaleTimeFrom = "1970-01-01T" + $("#product\\.OnSaleTimeFrom").getXMLTime();
    else
      reqDO.SaveMultiEditProduct.Product.OnSaleTimeFrom = null;
  }
  
  if ($("#ProdME-ToTime .form-field-caption input[type='checkbox']").isChecked()) {
    if (($("#product\\.OnSaleTimeTo-HH").getComboIndex() > 0) || ($("#product\\.OnSaleTimeTo-MM").getComboIndex() > 0))
      reqDO.SaveMultiEditProduct.Product.OnSaleTimeTo = "1970-01-01T" + $("#product\\.OnSaleTimeTo").getXMLTime();
    else
      reqDO.SaveMultiEditProduct.Product.OnSaleTimeTo = null;
  }
  
  if ($("#ProdME-Parent .form-field-caption input[type='checkbox']").isChecked()) {
    reqDO.SaveMultiEditProduct.Product.ParentEntityId = $("#product\\.ParentEntityId").val();
    reqDO.SaveMultiEditProduct.Product.ParentEntityType = $("#product\\.ParentEntityType").val();  
  }
  
  if ($("#ProdME-Location .form-field-caption input[type='checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.LocationId = $("#product\\.LocationId").val();
  
  if ($("#ProdME-PerformanceSelectionType .form-field-caption input[type='checkbox']").isChecked()) 
	  reqDO.SaveMultiEditProduct.Product.PerformanceSelectionType = $("#product\\.PerformanceSelectionType").val();
  
  if ($("#ProdME-PortfolioPriority .form-field-caption input[type='checkbox']").isChecked()) 
	    reqDO.SaveMultiEditProduct.Product.PortfolioPriority = $("#ProdME-PortfolioPriority [name='field-value']").val();
  
  if ($("#ProdME-PrintGroup .form-field-caption input[type='checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.PrintGroupTagId = $("#ProdME-PrintGroup [name='field-value']").val();
  
  if ($("#ProdME-FinanceGroup .form-field-caption input[type='checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.FinanceGroupTagId = $("#ProdME-FinanceGroup [name='field-value']").val();
  
  if ($("#ProdME-PriceGroup .form-field-caption input[type='checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.PriceGroupTagId = $("#ProdME-PriceGroup [name='field-value']").val();
  
  if ($("#ProdME-AdmGroup .form-field-caption input[type='checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.AdmGroupTagId = $("#ProdME-AdmGroup [name='field-value']").val();
  
  if ($("#ProdME-AreaGroup .form-field-caption input[type='checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.AreaGroupTagId = $("#ProdME-AreaGroup [name='field-value']").val();
  
  if ($("#ProdME-Tags .form-field-caption input[type='checkbox']").isChecked()) {
    reqDO.SaveMultiEditProduct.General.TagOperation = $("#ProdME-Tags").find("[name='TagOperation']:checked").val();
    reqDO.SaveMultiEditProduct.General.TagIDs = $("#ProdME-TagIDs").getStringArray();
  }
  
  if ($("#ProdME-ExpirationUsageType .form-field-caption input[type='checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.ExpirationUsageType = encodeExpirationUsageTypes();
  
  if ($("#ProdME-Plugins .form-field-caption input[type='checkbox']").isChecked()) {
    reqDO.SaveMultiEditProduct.General.PluginOperation = $("#ProdME-Plugins").find("[name='PluginOperation']:checked").val();
    reqDO.SaveMultiEditProduct.General.RequiredPluginList = requiredPluginList;
  }
  
  if ($("#ProdME-ProductNegativeTransaction .form-field-caption input[type='checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.ProductNegativeTransaction = $("#ProdME-ProductNegativeTransaction .form-field-value select").val();
  
  if ($("#ProdME-QuantityMin .form-field-caption input[type='checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.QuantityMin = $("#ProdME-QuantityMin [name='field-value']").val();
  
  if ($("#ProdME-QuantityStep .form-field-caption input[type='checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.QuantityStep = $("#ProdME-QuantityStep [name='field-value']").val();
  
  if ($("#ProdME-TrnMaxQty .form-field-caption input[type='checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.TrnMaxQty = $("#ProdME-TrnMaxQty [name='field-value']").val();
   
  return true;
}

function fillOptions(reqDO) {
  if ($("#ProdME-PerformanceFutureDays .form-field-caption input[type='checkbox']").isChecked()) 
	 reqDO.SaveMultiEditProduct.Product.PerformanceFutureDays = $("#ProdME-PerformanceFutureDays [name='field-value']").val();
	  
  if ($("#ProdME-ChangePerformanceAdvanceDays [name='Upd_ChangePerformance']").isChecked()) {   
    reqDO.SaveMultiEditProduct.Product.ChangePerformanceAdvanceDays = $("#ProdME-ChangePerformanceAdvanceDays [name='field-value']").val();
    reqDO.SaveMultiEditProduct.Product.ChangePerformance = $("[name='Upd_ChangePerformance']").isChecked();
  } 
  
  if ($("#ProdME-PerformanceFutureDaysExt .form-field-caption input[type='checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.PerformanceFutureDaysExt = $("#ProdME-PerformanceFutureDaysExt [name='field-value']").val();

  if ($("#ProdME-PerformanceFutureQty .form-field-caption input[type='checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.PerformanceFutureQty = $("#ProdME-PerformanceFutureQty [name='field-value']").val();
  
  if ($("#ProdME-PerformanceFutureQtyExt .form-field-caption input[type='checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.PerformanceFutureQtyExt = $("#ProdME-PerformanceFutureQtyExt [name='field-value']").val();

  if ($("#ProdME-TrackInventory [name='Upd_TrackInventory']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.TrackInventory = $("#ProdME-TrackInventory [name='field-value']").val();
  
  if ($("#ProdME-WritePerformanceAccountId [name='Upd_WritePerformanceAccountId']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.WritePerformanceAccountId = $("#ProdME-WritePerformanceAccountId [name='field-value']").val();
  
  if ($("#ProdME-VariableDescription [name='Upd_VariableDescription']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.VariableDescription = $("#ProdME-VariableDescription [name='field-value']").val();
  
  if ($("#ProdME-HidePriceVisibility [name='Upd_HidePriceVisibility']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.HidePriceVisibility = $("#ProdME-HidePriceVisibility [name='field-value']").val();
  
  if ($("#ProdME-PrivilegeCard [name='Upd_PrivilegeCard']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.Membership = $("#ProdME-PrivilegeCard [name='field-value']").val();
  
  if ($("#ProdME-RestrictOpenOrder [name='Upd_RestrictOpenOrder']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.RestrictOpenOrder = $("#ProdME-RestrictOpenOrder [name='field-value']").val();
  
  if ($("#ProdME-IgnoreEncodedEntitlements [name='Upd_IgnoreEncodedEntitlements']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.IgnoreEncodedEntitlements = $("#ProdME-IgnoreEncodedEntitlements [name='field-value']").val();
  
  if ($("#ProdME-AutoRedeemOnSale [name='Upd_AutoRedeemOnSale']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.AutoRedeemOnSale = $("#ProdME-AutoRedeemOnSale [name='field-value']").val();
  
  if ($("#ProdME-SpecialProductDoNotOpenApt [name='Upd_SpecialProductDoNotOpenApt']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.SpecialProductDoNotOpenApt = $("#ProdME-SpecialProductDoNotOpenApt [name='field-value']").val();
  
  if ($("#ProdME-ForceReceiptPrint [name='Upd_ForceReceiptPrint']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.ForceReceiptPrint = $("#ProdME-ForceReceiptPrint [name='field-value']").val();
  
  if ($("#ProdME-PeopleOfDetermination [name='Upd_PeopleOfDetermination']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.PeopleOfDetermination = $("#ProdME-PeopleOfDetermination [name='field-value']").val();
  
  if ($("#ProdME-Transferable [name='Upd_Transferable']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.Transferable = $("#ProdME-Transferable [name='field-value']").val();
  
  if ($("#ProdME-IgnoreAdmissionStatistics [name='Upd_IgnoreAdmissionStatistics']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.IgnoreAdmissionStatistics = $("#ProdME-IgnoreAdmissionStatistics [name='field-value']").val();
  
  if ($("#ProdME-AccountMetaDataEngrave [name='Upd_AccountMetaDataEngrave']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.AccountMetaDataEngrave = $("#ProdME-AccountMetaDataEngrave [name='field-value']").val();
  
  if ($("#ProdME-ChangeExpirationDate [name='Upd_ChangeExpirationDate']").isChecked()) 
   reqDO.SaveMultiEditProduct.Product.ChangeExpirationDate = $("#ProdME-ChangeExpirationDate [name='field-value']").val();
  
  if ($("#ProdME-ChangeStartValidity [name='Upd_ChangeStartValidity']").isChecked()) 
     reqDO.SaveMultiEditProduct.Product.ChangeStartValidity = $("#ProdME-ChangeStartValidity [name='field-value']").val();
  
  if ($("#ProdME-PreventAdmission [name='Upd_PreventAdmission']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.PreventAdmission = $("#ProdME-PreventAdmission [name='field-value']").val();
  
  if ($("#ProdME-IssueForRefund [name='Upd_IssueForRefund']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.IssueForRefund = $("#ProdME-IssueForRefund [name='field-value']").val();
  
  if ($("#ProdME-BindWalletRewardToProduct [name='Upd_BindWalletRewardToProduct']").isChecked()) 
	  reqDO.SaveMultiEditProduct.Product.BindWalletRewardToProduct = $("#ProdME-BindWalletRewardToProduct [name='field-value']").val();
  
  if ($("#ProdME-ChargePPUOnBooking [name='Upd_ChargePPUOnBooking']").isChecked()) 
	  reqDO.SaveMultiEditProduct.Product.ChargePPUOnBooking = $("#ProdME-ChargePPUOnBooking [name='field-value']").val();

  if ($("#ProdME-PromptPerformanceSelection [name='Upd_PromptPerformanceSelection']").isChecked()) 
	  reqDO.SaveMultiEditProduct.Product.PromptPerformanceSelection = $("#ProdME-PromptPerformanceSelection [name='field-value']").val();

  if ($("#ProdME-NoEventDetailsOnTrnVoidReceipt [name='Upd_NoEventDetailsOnTrnVoidReceipt']").isChecked()) 
	  reqDO.SaveMultiEditProduct.Product.NoEventDetailsOnTrnVoidReceipt = $("#ProdME-NoEventDetailsOnTrnVoidReceipt [name='field-value']").val();
  
  if ($("#ProdME-EntitlementStrictMerge [name='Upd_EntitlementStrictMerge']").isChecked()) 
	    reqDO.SaveMultiEditProduct.Product.EntitlementStrictMerge = $("#ProdME-EntitlementStrictMerge [name='field-value']").val();
  
  return true;
}

function fillTemplates(reqDO) {
	if ($("#ProdME-POS_AllowPrint [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.POS_AllowPrint = $("#ProdME-POS_AllowPrint [name=field-value]").val();
  
  if ($("#ProdME-POS_Template [name='field-checkbox']").isChecked()) {
    reqDO.SaveMultiEditProduct.Templates.POS_TemplateOperation = $("#ProdME-POS_Template").find("[name='POS_TemplateOperation']:checked").val();
    reqDO.SaveMultiEditProduct.Templates.POS_TemplateIDs = $("#ProdME-POS_TemplateIDs").getStringArray();
  }
  
  if ($("#ProdME-CLC_AllowPrint [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.CLC_AllowPrint = $("#ProdME-CLC_AllowPrint [name=field-value]").val();
  
  if ($("#ProdME-CLC_Template [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.CLC_DocTemplateId = $("#ProdME-CLC_Template [name=field-value]").val();
  
  if ($("#ProdME-B2B_AllowPrint [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.B2B_AllowPrint = $("#ProdME-B2B_AllowPrint [name=field-value]").val();
  
  if ($("#ProdME-B2B_Template [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.B2B_DocTemplateId = $("#ProdME-B2B_Template [name=field-value]").val();
  
  if ($("#ProdME-B2C_AllowPrint [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.B2C_AllowPrint = $("#ProdME-B2C_AllowPrint [name=field-value]").val();
  
  if ($("#ProdME-B2C_Template [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.B2C_DocTemplateId = $("#ProdME-B2C_Template [name=field-value]").val();
  
  if ($("#ProdME-MOB_AllowPrint [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.MOB_AllowPrint = $("#ProdME-MOB_AllowPrint [name=field-value]").val();
  
  if ($("#ProdME-MOB_Template [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.MOB_DocTemplateId = $("#ProdME-MOB_Template [name=field-value]").val();
  
  if ($("#ProdME-MWLT_AllowPrint [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.MWLT_AllowPrint = $("#ProdME-MWLT_AllowPrint [name=field-value]").val();
      
  if ($("#ProdME-MWLT_Template [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.MWLT_DocTemplateId = $("#ProdME-MWLT_Template [name=field-value]").val();
  
  if ($("#ProdME-ExtMediaGroup [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.ExtMediaGroupTagId = $("#ProdME-ExtMediaGroup [name=field-value]").val();
  
  if ($("#ProdME-GroupTicketOption [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.GroupTicketOption = $("#ProdME-GroupTicketOption [name=field-value]").val();
  
  if ($("#ProdME-ForceMediaGeneration [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.ForceMediaGeneration = $("#ProdME-ForceMediaGeneration [name=field-value]").val();
  
  if ($("#ProdME-MediaExclusiveUse [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.MediaExclusiveUse = $("#ProdME-MediaExclusiveUse [name=field-value]").val();
  
  if ($("#ProdME-PahGenerateMedia [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.PahGenerateMedia = $("#ProdME-PahGenerateMedia [name=field-value]").val();
  
  if ($("#ProdME-MediaNotExisting [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.MediaNotExisting = $("#ProdME-MediaNotExisting [name=field-value]").val();
  
  if ($("#ProdME-MediaAlreadyExisting [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.MediaAlreadyExisting = $("#ProdME-MediaAlreadyExisting [name=field-value]").val();
  
  if ($("#ProdME-RequireOrganizeStep [name='field-checkbox']").isChecked()) 
      reqDO.SaveMultiEditProduct.Product.RequireOrganizeStep = $("#ProdME-RequireOrganizeStep [name=field-value]").val();
  
  if ($("#ProdME-AutoGenDocTemplate [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.AutoGenDocTemplateId = $("#ProdME-AutoGenDocTemplate [name=field-value]").val();
  
  if ($("#ProdME-AutoGenDocStep [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.AutoGenDocStep = $("#ProdME-AutoGenDocStep [name=field-value]").val();
  
  if ($("#ProdME-AutoGenDocActivation [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.AutoGenDocActivation = $("#ProdME-AutoGenDocActivation [name=field-value]").val();
  
  if ($("#ProdME-CommonOrderDispatch [name='field-checkbox']").isChecked()) {
    reqDO.SaveMultiEditProduct.Templates.CommonOrderDispatchOperation = $("#ProdME-CommonOrderDispatch").find("[name='CommonOrderDispatchOperation']:checked").val();
    reqDO.SaveMultiEditProduct.Templates.CommonOrderDispatchIDs = $("#ProdME-CommonOrderDispatchIDs").getStringArray();
  }
  
  if ($("#ProdME-SpecificOrderDispatch [name='field-checkbox']").isChecked()) {
    reqDO.SaveMultiEditProduct.Templates.SpecificOrderDispatchOperation = $("#ProdME-SpecificOrderDispatch").find("[name='SpecificOrderDispatchOperation']:checked").val();
    reqDO.SaveMultiEditProduct.Templates.SpecificOrderDispatchIDs = $("#ProdME-SpecificOrderDispatchIDs").getStringArray();
  }
  
  return true;
}

function fillAttributeAccountBiometricFamily(reqDO) {
	if ($("#ProdME-Attributes [name='field-checkbox']").isChecked()) {
    reqDO.SaveMultiEditProduct.AttAccBio.AttributeOperation = $("#attribute-operation-type-container").find("[name='AttributeOperation']:checked").val();
    reqDO.SaveMultiEditProduct.AttAccBio.AttributeSelection = $("#attribute-selection-type-container").find("[name='AttributeSelection']:checked").val();
    var attributeData = [];
    var elems = $(".attribute-item-box");
    for (var i=0; i<elems.length; i++) { 
      var itemId = $(elems[i]).attr("data-AttributeItemId");
      if (itemId != null)
        attributeData.push($(elems[i]).attr("data-AttributeId") + "|" + $(elems[i]).attr("data-AttributeItemId"));
    }
    reqDO.SaveMultiEditProduct.AttAccBio.AttributeData = attributeData;
  }
	  
  if ($("#ProdME-SaleRights [name='field-checkbox']").isChecked()) {
    reqDO.SaveMultiEditProduct.AttAccBio.SaleRightsOperation = $("#salerights-operation-type-container").find("[name='SaleRightsOperation']:checked").val();
    var saleRightsData = [];
    var elems = $(".salerights-item-box");
    for (var i=0; i<elems.length; i++) { 
      var itemId = $(elems[i]).attr("data-entityid");
      if (itemId != null)
        saleRightsData.push($(elems[i]).attr("data-entityid") + "|" + $(elems[i]).attr("data-entitytype"));
    }
    reqDO.SaveMultiEditProduct.AttAccBio.SaleRightsData = saleRightsData;
  }
  
  if ($("#ProdME-ReqAccount [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.RequireAccount = $("#ProdME-ReqAccount [name=field-value]").val();
  
  if ($("#ProdME-CategoryAccount [name='field-checkbox']").isChecked())  
    reqDO.SaveMultiEditProduct.Product.AccountCategoryId = $("#ProdME-CategoryAccount [name=field-value]").val();
  
  if ($("#ProdME-RequireAccountOptions [name='field-checkbox']").isChecked()) {
    if (($("[name='ProdME-RequireAccountOption']:checked").val() == "<%=BLBO_Product.RequestAccountOption.ON_SALE%>")) {
      reqDO.SaveMultiEditProduct.Product.RequireAccountOnEncodingOnly = false;  
      reqDO.SaveMultiEditProduct.Product.RequireAccountOnRedemptionOnly = false;  
    } else { 
      reqDO.SaveMultiEditProduct.Product.RequireAccountOnEncodingOnly = ($("[name='ProdME-RequireAccountOption']:checked").val() == "<%=BLBO_Product.RequestAccountOption.ON_ENCODING%>");  
      reqDO.SaveMultiEditProduct.Product.RequireAccountOnRedemptionOnly = ($("[name='ProdME-RequireAccountOption']:checked").val() == "<%=BLBO_Product.RequestAccountOption.ON_REDEMPTION%>");
    }
  }
  
  if ($("#ProdME-Biometric [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.BiometricCheckLevel = $("#ProdME-Biometric [name=field-value]").val();
  
  if ($("#ProdME-BiometricEnrollment [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.BiometricEnrollment = $("#ProdME-BiometricEnrollment [name=field-value]").val();
  
  if ($("#ProdME-ManualVerificationMessage .form-field-caption input[type='checkbox']").isChecked()) 
	   reqDO.SaveMultiEditProduct.Product.ManualVerificationMessage = $("#ProdME-ManualVerificationMessage [name='field-value']").val();

  if ($("#ProdME-BiometricValidityPeriod [name='field-checkbox']").isChecked()) 
      reqDO.SaveMultiEditProduct.Product.BioValidityPeriod = $("#ProdME-BiometricValidityPeriod [name='field-value']").val();
  
  if ($("#ProdME-ManualVerification [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.ManualVerificationType = $("#ProdME-ManualVerification [name='field-value']").val();
  
  if ($("#ProdME-ProdPriorityLevel [name='field-checkbox']").isChecked()) 
      reqDO.SaveMultiEditProduct.Product.ProductPriorityLevel = $("#ProdME-ProdPriorityLevel .form-field-value select").val();

  if ($("#ProdME-PriorityOrderCheckType [name='field-checkbox']").isChecked()) 
      reqDO.SaveMultiEditProduct.Product.PriorityOrderCheckType = $("#ProdME-PriorityOrderCheckType .form-field-value select").val();
  
  if ($("#ProdME-EnforceSecondaryGroup [name='field-checkbox']").isChecked()) 
      reqDO.SaveMultiEditProduct.Product.EnforceSecondaryGroup = $("#ProdME-EnforceSecondaryGroup [name=field-value]").val();
  
  if ($("#ProdME-AllowStandaloneSales [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.AllowStandaloneSales = $("#ProdME-AllowStandaloneSales [name=field-value]").val();
  
  return true;
}

function fillProfiles(reqDO) {
  if ($("#ProdME-LedgerRuleTemplate [name='field-checkbox']").isChecked()) {
    reqDO.SaveMultiEditProduct.Profiles.LedgerRuleTemplateOperation = $("#ProdME-LedgerRuleTemplateOperation").find("[name='LedgerRuleTemplateOperation']:checked").val();
    reqDO.SaveMultiEditProduct.Profiles.LedgerRuleTemplateIDs = $("#ProdME-LedgerRuleTemplateIDs").getStringArray();
  }
  
  if ($("#ProdME-PaymentProfile [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.PaymentProfileId = $("#ProdME-PaymentProfile [name='field-value']").val();
  
  if ($("#ProdME-PaymentProfile [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.MeasureProfileId = $("#ProdME-MeasureProfile [name='field-value']").val();
  
  return true;
}

function fillRefundUpgradeRenewal(reqDO) {  
  if ($("#ProdME-Refundable [name='field-checkbox']").isChecked()) {      
    reqDO.SaveMultiEditProduct.Product.Refundable = $("#ProdME-Refundable [name=field-value]").val();
    
    if ($("#ProdME-TicketVoidAdvanceDays [name='field-checkbox']").isChecked())
      reqDO.SaveMultiEditProduct.Product.TicketVoidAdvanceDays = $("#ProdME-TicketVoidAdvanceDays [name=field-value]").val();
  } 
  
  if ($("#ProdME-PartiallyRefundable [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.PartiallyRefundable = $("#ProdME-PartiallyRefundable [name=field-value]").val();

  if ($("#ProdME-Upgradable [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.Upgradable = $("#ProdME-Upgradable [name=field-value]").val();

  if ($("#ProdME-Downgradable [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.Downgradable = $("#ProdME-Downgradable [name=field-value]").val();

  if ($("#ProdME-InheritFromCat [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.InheritFromCat = $("#ProdME-InheritFromCat [name=field-value]").val();

  if ($("#ProdME-AllowCrossLocationUpg [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.AllowCrossLocationUpg = $("#ProdME-AllowCrossLocationUpg [name=field-value]").val();

  if ($("#ProdME-UpgDays [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.FirstUsageUpgradeDays = $("#ProdME-UpgDays [name=field-value]").val();

  if ($("#ProdME-ExpUpgDays [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.ProductUpgrade.Flags.ExpirationUpgradeDays = $("#ProdME-ExpUpgDays [name=field-value]").val();
  
  if ($("#ProdME-FromVisitUpgDays [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.ProductUpgrade.Flags.FromVisitUpgradeDays = $("#ProdME-FromVisitUpgDays [name=field-value]").val();
  
  if ($("#ProdME-FromVisitUpgPerfDays [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.ProductUpgrade.Flags.FromVisitUpgradePerfDays = $("#ProdME-FromVisitUpgPerfDays [name=field-value]").val();
  
  if ($("#ProdME-RenewStartDelta [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.RenewalWindowStartDays = $("#ProdME-RenewStartDelta [name=field-value]").val();
  
  if ($("#ProdME-RenewEndDelta [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.RenewalWindowEndDays = $("#ProdME-RenewEndDelta [name=field-value]").val();
  
  if ($("#ProdME-RenewableFromAny [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.RenewableFromAny = $("#ProdME-RenewableFromAny [name=field-value]").val();
  
  if ($("#ProdME-RenewableToAny [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.RenewableToAny = $("#ProdME-RenewableToAny [name=field-value]").val();
  
  if ($("#ProdME-RenewalSrcProd [name='field-checkbox']").isChecked()) {
    reqDO.SaveMultiEditProduct.RefundUpgradeRenewal.Upd_RenewSrcProducts = true;
    reqDO.SaveMultiEditProduct.RefundUpgradeRenewal.RenewSrcProductOperation = $("#srcproducts-operation-type-container").find("[name='SrcProductsOperation']:checked").val();
    
    var srcProductsIDs = [];
    var elems = $(".srcproducts-item-box");
    for (var i=0; i<elems.length; i++) { 
      var itemId = $(elems[i]).attr("data-entityid");
      if (itemId != null)
        srcProductsIDs.push($(elems[i]).attr("data-entityid"));
    }
    reqDO.SaveMultiEditProduct.RefundUpgradeRenewal.RenewSrcProductIDs = srcProductsIDs;
  }
  
  return true;
}

function fillPrices(reqDO) {
  if ($("#ProdME-FacePrice [name='field-checkbox']").isChecked()) {
    reqDO.SaveMultiEditProduct.Price.FacePrice = encodePercValue($("#ProdME-FacePrice [name=field-value]").val());
    reqDO.SaveMultiEditProduct.Price.FacePriceType = encodePresaleValueType($("#ProdME-FacePrice [name=field-value]").val());
    reqDO.SaveMultiEditProduct.Price.StartDate = $("#FacePriceDateFrom-picker").getXMLDate();
  }
  
  if ($("#ProdME-PriceTaxes [name='field-checkbox']").isChecked()) {
    reqDO.SaveMultiEditProduct.Product.TaxCalcType = $("#pricetaxes-selection-type-container").find("[name='PriceTaxSelection']:checked").val();
    reqDO.SaveMultiEditProduct.Product.TaxProfileId = $("#taxProfileId").val();
  }

  if ($("#ProdME-TaxablePrice [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.TaxablePrice = encodePercValue($("#ProdME-TaxablePrice [name=field-value]").val());
  
  if ($("#ProdME-VariablePrice [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.VariablePrice = $("#ProdME-VariablePrice [name=field-value]").val();
  
  if ($("#ProdME-ChargeToWallet [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.ChargeToWallet = $("#ProdME-ChargeToWallet [name=field-value]").val();
    
  if ($("#ProdME-MinPrice [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.VariablePriceMin = strToFloatDef($("#ProdME-MinPrice [name=field-value]").val(), null);
  
  if ($("#ProdME-MaxPrice [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.VariablePriceMax = strToFloatDef($("#ProdME-MaxPrice [name=field-value]").val(), null);
  
  if ($("#ProdME-ClearingLimitPerc [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.ClearingLimitPerc = encodePercValue($("#ProdME-ClearingLimitPerc [name=field-value]").val());
  
  if ($("#ProdME-IncludeBearedDiscounts [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.ClearingLimitIncludeBearedDisc = $("#ProdME-IncludeBearedDiscounts [name=field-value]").val();
  
  if ($("#ProdME-IncludeBearedTaxes [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.ClearingLimitIncludeBearedTaxes = $("#ProdME-IncludeBearedTaxes [name=field-value]").val();
  
  if ($("#ProdME-PresaleValue [name='field-checkbox']").isChecked()) {
    reqDO.SaveMultiEditProduct.Product.PresaleValue = encodePercValue($("#ProdME-PresaleValue [name=field-value]").val());
    reqDO.SaveMultiEditProduct.Product.PresaleValueType = encodePresaleValueType($("#ProdME-PresaleValue [name=field-value]").val());
  }
  
  if ($("#ProdME-SaleChannels [name='field-checkbox']").isChecked()) {
    reqDO.SaveMultiEditProduct.Price.SaleChannelOperation = $("#ProdME-SaleChannels").find("[name='SaleChannelOperation']:checked").val();
    reqDO.SaveMultiEditProduct.Price.SaleChannelIDs = $("#ProdME-SaleChannelIDs").getStringArray();
  }
  
  if ($("#ProdME-PerformanceTypes [name='field-checkbox']").isChecked()) {
    reqDO.SaveMultiEditProduct.Price.PerformanceTypeOperation = $("#ProdME-PerformanceTypes").find("[name='PerformanceTypeOperation']:checked").val();
    reqDO.SaveMultiEditProduct.Price.PerformanceTypeIDs = $("#ProdME-PerformanceTypeIDs").getStringArray();
  }
  
  if ($("#ProdME-PosPricingPlugin [name='field-checkbox']").isChecked()) 
    reqDO.SaveMultiEditProduct.Product.PosPricingPluginId = $("#product\\.PosPricingPluginId").val();
  
  return true;
}
  
function fillSuspension(reqDO) {
	
	if ($("#ProdME-Suspend .form-field-caption input[type='checkbox']").isChecked()) {
		var dateFrom = null;
	  var dateTo = null;
		
	  if ($("#Suspend-DateFrom").val() != "")
		  dateFrom = new Date($("#Suspend-DateFrom").val());
		
		if ($("#Suspend-DateTo").val() != "")
			dateTo = new Date($("#Suspend-DateTo").val());
		
    var nowDate = new Date();
		nowDate.setHours(0, 0, 0, 0);
		
		if (dateFrom == null) {
			showMessage(itl("@Product.SuspendDateFromEmpty"));
		  return false;
		}
		else if ((dateTo != null) && (dateTo.getTime() < dateFrom.getTime())) {
			showMessage(itl("@Product.SuspendDateFromAfterDateTo"));
			return false;
		}
		else if (dateFrom.getTime() < nowDate.getTime()) {
      showMessage(itl("@Product.SuspendDateFromInThePast"));
      return false;
    }
	  else {		
  		reqDO.SaveMultiEditProduct.Suspension.SuspendOperation = $("#ProdME-Suspend").find("[name='SuspendOperation']:checked").val();
      reqDO.SaveMultiEditProduct.Suspension.SuspendDateFrom = $("#Suspend-DateFrom").val();
      reqDO.SaveMultiEditProduct.Suspension.SuspendDateTo = $("#Suspend-DateTo").val();
      return true;
	  }
  }
	else
  	return true;
}
	
function fillRevRec(reqDO) {
	reqDO.SaveMultiEditProduct.RevenueRecognition.DateFrom = $("#RevRec-DateFrom").val(); 
  reqDO.SaveMultiEditProduct.RevenueRecognition.DateTo = $("#RevRec-DateTo").val();
  
  if ($("#ProdME-BreakageType [name='field-checkbox']").isChecked()) {
    reqDO.SaveMultiEditProduct.RevenueRecognition.Update = true;
    reqDO.SaveMultiEditProduct.RevenueRecognition.BreakageDaysType = $("#product\\.BreakageType").val();
  }
  
  if ($("#ProdME-BreakageDays [name='field-checkbox']").isChecked()) {
    reqDO.SaveMultiEditProduct.RevenueRecognition.Update = true;
    reqDO.SaveMultiEditProduct.RevenueRecognition.BreakageDays = $("#product\\.BreakageDays").val();
  }
  
  if ($("#ProdME-RevenueRecognitionType [name='field-checkbox']").is(":checked")) {
    reqDO.SaveMultiEditProduct.RevenueRecognition.Update = true;
    reqDO.SaveMultiEditProduct.RevenueRecognition.RevenueRecognitionType = $("#product\\.RevenueRecognitionType").val();
  }
  
  if ($("#ProdME-GateCategories [name='field-checkbox']").is(":checked")) {
    reqDO.SaveMultiEditProduct.RevenueRecognition.Update = true;
    reqDO.SaveMultiEditProduct.RevenueRecognition.GateCategoriesOperation = $("#gatecategories-operation-type-container").find("[name='GateCategoriesOperation']:checked").val();
    
    var gateCategoriesIDs = [];
    var elems = $(".gatecategory-item-box");
    for (var i=0; i<elems.length; i++) { 
      var itemId = $(elems[i]).attr("data-entityid");
      if (itemId != null)
        gateCategoriesIDs.push($(elems[i]).attr("data-entityid"));
    }
    reqDO.SaveMultiEditProduct.RevenueRecognition.GateCategoryIDs = gateCategoriesIDs;
  }
  
  if ($("#ProdME-VisitPerTicket [name='field-checkbox']").isChecked()) {
    reqDO.SaveMultiEditProduct.RevenueRecognition.Update = true;
    reqDO.SaveMultiEditProduct.RevenueRecognition.VisitPerTicket = $("#product\\.VisitPerTicket").val();
  }

  if ($("#ProdME-AmortizationPeriods [name='field-checkbox']").isChecked()) {
    reqDO.SaveMultiEditProduct.RevenueRecognition.Update = true;
    reqDO.SaveMultiEditProduct.RevenueRecognition.AmortizationPeriods = $("#product\\.AmortizationPeriods").val();
  }
  
  if ($("#ProdME-AmortizationPeriodType [name='field-checkbox']").isChecked()) {
    reqDO.SaveMultiEditProduct.RevenueRecognition.Update = true;
    reqDO.SaveMultiEditProduct.RevenueRecognition.AmortizationPeriodType = $("#product\\.AmortizationPeriodType").val();
  }
  
  if ($("#ProdME-AmortizationWithinExpiration [name='Upd_AmortizationWithinExpiration']").isChecked()) 
    reqDO.SaveMultiEditProduct.RevenueRecognition.AmortizationWithinExpiration = $("#ProdME-AmortizationWithinExpiration [name='field-value']").val();
  
  if ($("#ProdME-AmortizationTrigger [name='field-checkbox']").isChecked()) {
    reqDO.SaveMultiEditProduct.RevenueRecognition.Update = true;
    reqDO.SaveMultiEditProduct.RevenueRecognition.AmortizationTrigger = $("#product\\.AmortizationTrigger").val();
  }
  
  if ($("#ProdME-AmortizationDelay [name='field-checkbox']").isChecked()) {
    reqDO.SaveMultiEditProduct.RevenueRecognition.Update = true;
    reqDO.SaveMultiEditProduct.RevenueRecognition.AmortizationDelay = $("#product\\.AmortizationDelay").val();
  }
  
  if ($("#ProdME-AmortizationVPTCalendar [name='field-checkbox']").isChecked()) {
    reqDO.SaveMultiEditProduct.RevenueRecognition.Update = true;
    reqDO.SaveMultiEditProduct.RevenueRecognition.AmortizationVPTCalendar = $("#product\\.AmortizationVPTCalendarId").val();
  }
  
  if ($("#ProdME-PortfolioExpirationWallet .form-field-caption input[type='checkbox']").isChecked()) 
 	reqDO.SaveMultiEditProduct.Product.WalletClearingTriggerType = $("#ProdME-PortfolioExpirationWallet .form-field-value select").val();
	  
  if ($("#ProdME-PortfolioExpirationRewardPoint .form-field-caption input[type='checkbox']").isChecked()) 
	reqDO.SaveMultiEditProduct.Product.RewardPointClearingTriggerType = $("#ProdME-PortfolioExpirationRewardPoint .form-field-value select").val();
  
  return true;
}

function showSearchDialog(entityType) {
  var params = {
    EntityType: entityType,
    ShowCheckbox: true,
    isItemChecked: function(item) {
      return (_getItem(item.ItemId).length > 0);
    },
    onPickup: function(item, add) {
      var $item = _getItem(item.ItemId);
      if (add !== ($item.length > 0)) {
        if (add)
          doAddEntityRight(item.IconName, item.ItemId, entityType, item.ItemName, <%=LkSNRightLevel.Read.getCode()%>);
        else
          $item.remove();
      }
    }
  };
  
  if (entityType == <%=LkSNEntityType.Person.getCode()%>) {
    params.AccountParams = {
      HasLogin: true
    }  
  }
  
  showLookupDialog(params);
  
  function _getItem(entityId) {
    return $(".salerights-box-container .salerights-item-box[data-entityid='" + entityId + "']");
  }
}

function doAddEntityRight(iconName, entityId, entityType, entityName, rightLevel) {
  var existCount = $(".salerights-item-box[data-entityid='" + entityId + "']").length;
  if (existCount > 0)
    showMessage(itl("@Common.DuplicatedItem"));
  else {
    var divBox = $("<div class='salerights-item-box'/>").appendTo(".salerights-box-container");
    divBox.attr("data-EntityId", entityId);
    divBox.attr("data-EntityType", entityType);
    divBox.attr("onclick", "$(this).remove()");
    
    $("<div class='item-name'/>").appendTo(divBox).text(itl(entityName));
    $("<div class='ent-type-name'/>").appendTo(divBox).html(calcEntityRightDesc(entityType));
  }
}

function showProductPickupDialog() {
  showLookupDialog({
    EntityType: <%=LkSNEntityType.ProductType.getCode()%>,
    onPickup: function(item) {
      addProduct(item.ItemId, item.ItemCode, item.ItemName);
    }
  });
}

function addProduct(entityId, entityCode, entityName) {
  var existCount = $(".srcproducts-item-box[data-entityid='" + entityId + "']").length;
  if (existCount > 0)
    showMessage(<v:itl key="@Common.DuplicatedItem" encode="JS"/>);
  else {
    var divBox = $("<div class='srcproducts-item-box'/>").appendTo(".srcproducts-box-container");
    divBox.attr("data-EntityId", entityId);
    divBox.attr("data-EntityType", entityCode);
    divBox.attr("onclick", "$(this).remove()");
    
    $("<div class='item-name'/>").appendTo(divBox).html(entityName);
    $("<div class='item-code'/>").appendTo(divBox).html(entityCode);
    
  }
}

function optGroupLabel(id) {
  var elt = $('#'+id)[0];
  var label = $(elt.options[elt.selectedIndex]).closest('optgroup').prop('label');
  return label;
}

</script>