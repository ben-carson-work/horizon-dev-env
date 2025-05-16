<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProduct" scope="request"/>
<jsp:useBean id="product" class="com.vgs.snapp.dataobject.DOProduct" scope="request"/>

<jsp:include page="product_expiration_usagetype_handler_js.jsp"/>

<%  
FtCRUD rightCRUD = pageBase.getRightCRUD();
boolean canEdit = rightCRUD.canUpdate(); 
boolean canCreate = rightCRUD.canCreate(); 
boolean canDelete = rightCRUD.canDelete();
boolean canConsultStock = pageBase.getRights().WarehouseStocks.getBoolean();
%>

<script>
//# sourceURL=product_tab_main_js.jsp
$(document).ready(function() {
  var canEdit = <%=canEdit%>
  reloadMaskEdit(document.getElementById("product.CategoryId").value);
  refreshNameExt();
  refreshStockLink();
  refreshFamilyOptionsVisibility();
  refreshExpirationUsageType();
  
  $(".info-btn").attr("data-content", $("#templates .attribute-legend").html());
  $("#btn-stopsale").click(_showStopSaleCalendar);
  
  <% for (DOProduct.DOAttributeItem aiDO : product.AttributeItemList) { %>
    productAddAttributeItem(<%=aiDO.getJSONString()%>);
  <% } %>
  if (canEdit)
    $("#attribute-grid tbody").sortable({handle:".drag-handle"});

  function reloadMaskEdit(categoryId) {
    asyncLoad("#maskedit-container", "admin?page=maskedit_widget&id=<%=pageBase.getId()%>&EntityType=<%=LkSNEntityType.ProductType.getCode()%>&CategoryId=" + categoryId + "&readonly=" + !canEdit);
  }
  $("#product\\.CategoryId").change(function() {
    reloadMaskEdit(this.value);
  });

  $("#product\\.ProductPriorityLevel").change(refreshFamilyOptionsVisibility);
  
  $("#btn-save").click(doSave).setEnabled(canEdit);
  
  function refreshFamilyOptionsVisibility() {
    var hidden = $("#product\\.ProductPriorityLevel").val() != <%=LkSNProductPriorityLevel.Secondary.getCode()%>;
    $("#priority-order-check-type").setClass("hidden", hidden);
    $("#enforce-secondary-group").setClass("hidden", hidden);
    $("#allow-standalone-sales").setClass("hidden", hidden);
  }
  
  function _showStopSaleCalendar() {
    asyncDialogEasy("product/stopsale_dialog", "ProductId=<%=pageBase.getId()%>&CanEdit=<%=canEdit%>");
  }
  
  function refreshExpirationUsageType() {
	  var expUsageTypes = [];
	  expUsageTypes = decodeExpirationUsageType(<%=product.ExpirationUsageType.getLkValue().getCode()%>);
	  
	  if (expUsageTypes.length === 0) {  
	    $('input[id="product.ExpirationUsageType"]').prop('checked', false);
	  } else { 
	    $('input[id="product.ExpirationUsageType"]').each(function() {  
	      if (expUsageTypes.includes(Number($(this).val()))) { 
	        $(this).prop('checked', true); 
	      } else { 
	        $(this).prop('checked', false); 
	      }
	    });
	  }
	}
});
      
function refreshNameExt() {
  $("#product\\.ProductNameExt").attr("placeholder", $("#product\\.ProductName").val());
}
     
$(document).ready(refreshNameExt);
$("#product\\.ProductName").keyup(refreshNameExt);

$("#product\\.TrackInventory").click(function() {
  $("#inventory-stock-link").setClass("v-hidden", !$(this).is(":checked"));
});

function refreshStockLink() {
  $("#stock-link").setClass("hidden", !$("#product\\.TrackInventory").isChecked() || <%=pageBase.isNewItem()%> || <%=!canConsultStock%>);
}

function showStockDialog() {
  asyncDialogEasy("inventory/product_stock_dialog", "id=<%=pageBase.getId()%>");
}

function showAttributePickup() {
  asyncDialogEasy("attribute/attribute_pickup_dialog", "ParentEntityType=<%=LkSNEntityType.ProductType.getCode()%>&ParentEntityId=<%=pageBase.getId()%>");
}

function productAddAttributeItem(obj) {
  var $tr = $("#templates .attribute-item").clone().appendTo("#attribute-grid tbody");
  $tr.attr("data-AttributeId", obj.AttributeId);
  $tr.attr("data-AttributeItemId", obj.AttributeItemId);
  $tr.attr("data-SelectionType", obj.SelectionType);
  $tr.attr("data-Active", obj.Active);
  $tr.attr("data-Seat", (obj.SeatCategory));
  $tr.attr("data-DynamicEntitlement", obj.DynamicEntitlement);
  $tr.data(obj);

  $tr.find(".item-name").text(obj.AttributeItemName);
  $tr.find(".attribute-name").text(obj.AttributeName);
  $tr.find("a.item-name").attr("href", getPageURL(<%=LkSNEntityType.Attribute.getCode()%>, obj.AttributeId));
}

function toggleAttributeItemDynamicEntitlement(elem) {
  var $elem = $(elem); 
  var $tr = $elem.closest("tr");
  var value = $tr.attr("data-DynamicEntitlement") != "true";
  
  if ((value == true) && ($tr.attr("data-SelectionType") != 1))
    showMessage(itl("@Entitlement.SelectionTypeDynamicEntitlementMismatch"));
  else 
    $tr.attr("data-DynamicEntitlement", value);
  

  $elem.closest(".btn-group").removeClass("open");
  event.stopPropagation();
  event.preventDefault();
}

function removeAttributeItem(elem) {
  var $elem = $(elem); 
  var $tr = $elem.closest("tr");
  
  confirmDialog(null, function() {
    $tr.remove();
  });

  $elem.closest(".btn-group").removeClass("open");
  event.stopPropagation();
  event.preventDefault();
}

function changeAttributeSelection(elem, seltype) {
  var $elem = $(elem); 
  var $tr = $elem.closest("tr");
  
  $tr.attr("data-SelectionType", seltype);
  if (seltype != 1/*fixed*/)
    $tr.attr("data-DynamicEntitlement", false);

  $elem.closest(".btn-group").removeClass("open");
  event.stopPropagation();
  event.preventDefault();
}

function attributePickupCallback(obj) {
  if ($(".attribute-item[data-AttributeId='" + obj.AttributeId + "']").length > 0) 
    showMessage("Attribute already selected \"" + obj.AttributeName + "\"");
  else {
    obj.SelectionType = 1;
    obj.Active = true;
    productAddAttributeItem(obj);
  }
}

function refreshPayMethodsVisibility() {
  $("#payments-container").setClass("v-hidden", !$("#cbRestrictPaymentMethods").isChecked());
}

function checkDataTypes() {
  portfolioPriority = $("#product\\.PortfolioPriority").val();
  if (portfolioPriority)
    if (!$.isNumeric(portfolioPriority) || (portfolioPriority <= 0) || (portfolioPriority >= 32767)) {
      $("#product\\.PortfolioPriority").focus();
      fieldName = itl("@Product.PortfolioPriority");
      showIconMessage("warning", itl("@Common.InvalidValueFieldError", fieldName));
      return false;
    }
    
  return true;
}
      
function doSave() {
  var metaDataList = prepareMetaDataArray("#product-form");
  if (!(metaDataList)) 
    showIconMessage("warning", itl("@Common.CheckRequiredFields"));
  else {
    if (checkDataTypes()) {   
      var saleTimeFrom = null;
      if (($("#product\\.OnSaleTimeFrom-HH").getComboIndex() > 0) || ($("#product\\.OnSaleTimeFrom-MM").getComboIndex() > 0))
        saleTimeFrom = "1970-01-01T" + $("#product\\.OnSaleTimeFrom").getXMLTime();
                      
      var saleTimeTo = null;
      if (($("#product\\.OnSaleTimeTo-HH").getComboIndex() > 0) || ($("#product\\.OnSaleTimeTo-MM").getComboIndex() > 0))
        saleTimeTo = "1970-01-01T" + $("#product\\.OnSaleTimeTo").getXMLTime();
  
      var onSaleDateFrom = null;
      if ($("#product\\.OnSaleDateFrom-picker").length > 0)
        onSaleDateFrom = $("#product\\.OnSaleDateFrom-picker").getXMLDate();
      
      var onSaleDateTo = null;
      if ($("#product\\.OnSaleDateTo-picker").length > 0)
        onSaleDateTo = $("#product\\.OnSaleDateTo-picker").getXMLDate();
      
      var performanceTimeFrom = null;
      if (($("#product\\.PerformanceTimeFrom-HH").getComboIndex() > 0) || ($("#product\\.PerformanceTimeFrom-MM").getComboIndex() > 0))
        performanceTimeFrom = "1970-01-01T" + $("#product\\.PerformanceTimeFrom").getXMLTime();
                      
      var performanceTimeTo = null;
      if (($("#product\\.PerformanceTimeTo-HH").getComboIndex() > 0) || ($("#product\\.PerformanceTimeTo-MM").getComboIndex() > 0))
        performanceTimeTo = "1970-01-01T" + $("#product\\.PerformanceTimeTo").getXMLTime();
  
      var attributeItemList = [];
      $("#attribute-grid .attribute-item").each(function() {
        var $elem = $(this);
        attributeItemList.push({
          "AttributeItemId": $elem.attr("data-AttributeItemId"),
          "SelectionType": $elem.attr("data-SelectionType"),
          "DynamicEntitlement": $elem.attr("data-DynamicEntitlement") == "true"
        });
      });
      
      var requiredPluginList = [];
      var $options = $("#product\\.RequiredPluginIDs option:selected");
      $options.each(function() {
        requiredPluginList.push({
          PluginId: $(this).val(),
          PluginName: $(this).text()
        });
      })
      
      var bioCheckLevel = $("#product\\.BiometricCheckLevel").val();
      var bioAdditional = (bioCheckLevel != <%=LkSNBiometricCheckLevel.None.getCode()%>) && (bioCheckLevel != <%=LkSNBiometricCheckLevel.Simulate.getCode()%>);
      var isStaffCard = <%=product.ProductType.isLookup(LkSNProductType.StaffCard)%>;
      var isPackage = <%=product.ProductType.isLookup(LkSNProductType.Package)%>;
      var requireAccount = $("[name='product\\.RequireAccount']").isChecked();
      var requireAccountOnEncoding = requireAccount && ($("[name='RequireAccountOption']:checked").val() == "<%=BLBO_Product.RequestAccountOption.ON_ENCODING%>");  
      var requireAccountOnRedemption = requireAccount && !requireAccountOnEncoding && ($("[name='RequireAccountOption']:checked").val() == "<%=BLBO_Product.RequestAccountOption.ON_REDEMPTION%>");  
      
      var reqDO = {
        Command: "SaveProduct",
        SaveProduct: {
          Product: {
            <%-- GENERAL --%>            
            ProductId: <%=product.ProductId.getJsString()%>,
            ProductCode: $("#product\\.ProductCode").val(),
            ProductName: $("#product\\.ProductName").val(),
            ShowNameExt: $("[name='product\\.ShowNameExt']").isChecked(),
            ProductNameExt: $("#product\\.ProductNameExt").val(),
            ParentEntityType: $("#product\\.ParentEntityType").val(),
            ParentEntityId: $("#product\\.ParentEntityId").val(),
            LocationId: $("#product\\.LocationId").val(),
            ProductStatus: $("#product\\.ProductStatus").val(),
            CategoryId: $("#product\\.CategoryId").val(),
            AgeCategory: $("#product\\.AgeCategory").val(),
            ProfilePictureId: $("#product\\.ProfilePictureId").val(),
            CalendarId: $("[name='product\\.CalendarId']").val(),
            OnSaleTimeFrom: saleTimeFrom,
            OnSaleTimeTo: saleTimeTo,
            OnSaleDateFrom: onSaleDateFrom,
            OnSaleDateTo: onSaleDateTo,
            PerformanceTimeFrom: performanceTimeFrom,
            PerformanceTimeTo: performanceTimeTo,
            PerformanceSelectionType: $("[name='product\\.PerformanceSelectionType']").val(),
            VisitCalendarId: $("[name='product\\.VisitCalendarId']").val(),
            StopSaleList: $("#btn-stopsale").data("stopsale-data"),
            PrintGroupTagId: $("[name='product\\.PrintGroupTagId']").val(),
            FinanceGroupTagId: $("[name='product\\.FinanceGroupTagId']").val(),
            AdmGroupTagId: $("[name='product\\.AdmGroupTagId']").val(),
            AreaGroupTagId: $("[name='product\\.AreaGroupTagId']").val(),
            PriorityOrder: $("[name='product\\.PriorityOrder']").val(),
            PortfolioPriority: $("[name='product\\.PortfolioPriority']").val(),
            ExpirationUsageType: encodeExpirationUsageTypes(),
            TagIDs: $("#product\\.TagIDs").val(),
            PaymentProfileId: $("[name='product\\.PaymentProfileId']").val(),
            LedgerRuleTemplateIDs: $("#product\\.LedgerRuleTemplateIDs").val(),
            MeasureProfileId: $("[name='product\\.MeasureProfileId']").val(),
            BackgroundColor: $("[name='product\\.BackgroundColor']").val(),
            ForegroundColor: $("[name='product\\.ForegroundColor']").val(),
            IconAlias: $("#product\\.IconAlias").attr("data-alias"),
            DatedCalendarId: $("[name='product\\.DatedCalendarId']").val(),
            EntryQty: strToIntDef($("[name='product\\.EntryQty']").val(), null),
            ProductNegativeTransaction: $("[name='product\\.ProductNegativeTransaction']").val(),
            MembershipPluginId: $("[name='product\\.MembershipPluginId']").val(),
            GateCategoryIDs : $("#product\\.GateCategoryIDs").val(),
            ChangePerformanceAdvanceDays: $("[name='product\\.ChangePerformanceAdvanceDays']").val(),
            ChangePerformance: $("[name='product\\.ChangePerformance']").isChecked(),
            ChangeVisitDateFeeProductId: $("[name='product\\.ChangeVisitDateFeeProductId']").val(),
            ChangeVisitDateFeeDays: $("[name='product\\.ChangeVisitDateFeeDays']").val(),
            PerformanceFutureDays: $("[name='product\\.PerformanceFutureDays']").val(),
            PerformanceFutureDaysExt: $("[name='product\\.PerformanceFutureDaysExt']").val(),
            PerformanceFutureQty: $("[name='product\\.PerformanceFutureQty']").val(),
            PerformanceFutureQtyExt: $("[name='product\\.PerformanceFutureQtyExt']").val(),
            
            <%-- OPTIONS --%>    
            WritePerformanceAccountId: $("[name='product\\.WritePerformanceAccountId']").isChecked(),
            VariableDescription: $("[name='product\\.VariableDescription']").isChecked(),   
            TrackInventory: $("[name='product\\.TrackInventory']").isChecked(),   
            HidePriceVisibility: $("[name='product\\.HidePriceVisibility']").isChecked(),
            Membership: $("[name='product\\.Membership']").isChecked(),
            RestrictOpenOrder: $("[name='product\\.RestrictOpenOrder']").isChecked(), 
            IgnoreEncodedEntitlements: $("[name='product\\.IgnoreEncodedEntitlements']").isChecked(),
            AutoRedeemOnSale: $("[name='product\\.AutoRedeemOnSale']").isChecked(),
            SpecialProductDoNotOpenApt: $("[name='product\\.SpecialProductDoNotOpenApt']").isChecked(),
            ForceReceiptPrint: $("[name='product\\.ForceReceiptPrint']").isChecked(),
            PeopleOfDetermination: $("[name='product\\.PeopleOfDetermination']").isChecked(),
            Transferable: $("[name='product\\.Transferable']").isChecked(),
            IgnoreAdmissionStatistics: $("[name='product\\.IgnoreAdmissionStatistics']").isChecked(),
            AccountMetaDataEngrave: $("[name='product\\.AccountMetaDataEngrave']").isChecked(),
            ChangeStartValidity: $("[name='product\\.ChangeStartValidity']").isChecked(),
            ChangeExpirationDate: $("[name='product\\.ChangeExpirationDate']").isChecked(),
            PrintValidityDescOnTrnReceipt: $("[name='product\\.PrintValidityDescOnTrnReceipt']").isChecked(),
            ValidateSecurityRestriction: $("[name='product\\.ValidateSecurityRestriction']").isChecked(),
            ValidateFromVisitDate: $("[name='product\\.ValidateFromVisitDate']").isChecked(),
            OrderGuestOnly: $("[name='product\\.OrderGuestOnly']").isChecked(),
            PreventDirectSale: $("[name='product\\.PreventDirectSale']").isChecked(),
            ForceDynAttrView: $("[name='product\\.ForceDynAttrView']").isChecked(),
            PreventAdmission: $("[name='product\\.PreventAdmission']").isChecked(),
            Principal: $("[name='product\\.Principal']").isChecked(),
            NotPrintableAtUnmannedWks: $("[name='product\\.NotPrintableAtUnmannedWks']").isChecked(),
            IssueForRefund: $("[name='product\\.IssueForRefund']").isChecked(),
            BindWalletRewardToProduct: $("[name='product\\.BindWalletRewardToProduct']").isChecked(),
            WalletRewardSingleUse: $("[name='product\\.BindWalletRewardToProduct']").isChecked() && $("[name='product\\.WalletRewardSingleUse']").isChecked(),
            WalletRewardPayPartial: $("[name='product\\.BindWalletRewardToProduct']").isChecked() && $("[name='product\\.WalletRewardPayPartial']").isChecked(),
            ChargePPUOnBooking: $("[name='product\\.ChargePPUOnBooking']").isChecked(),
            PromptPerformanceSelection: $("[name='product\\.PromptPerformanceSelection']").isChecked(),
            MultipleBookingsOnSamePerformance: $("[name='product\\.MultipleBookingsOnSamePerformance']").isChecked(),
            NoEventDetailsOnTrnVoidReceipt: $("[name='product\\.NoEventDetailsOnTrnVoidReceipt']").isChecked(),
            EntitlementStrictMerge: $("[name='product\\.EntitlementStrictMerge']").isChecked(),
            
            <%-- PACAKGE --%>
            ProductPackageType: isPackage? $("#product\\.ProductPackageType").val() : null,
            ProductPackageReadType: isPackage? <%=LkSNProductPackageReadType.Group.getCode()%> : null, <%-- Fixed for now --%>
            
            <%-- MEDIA --%>
            POS_AllowPrint: $("[name='product\\.POS_AllowPrint']").isChecked(),
            POS_DocTemplateList:getDocTemplateIdArray($("#product\\.POS_DocTemplateIDs").val()), 
            B2B_AllowPrint: $("[name='product\\.B2B_AllowPrint']").isChecked(),
            B2B_DocTemplateId: $("#product\\.B2B_DocTemplateId").val(),
            CLC_AllowPrint: $("[name='product\\.CLC_AllowPrint']").isChecked(),
            CLC_DocTemplateId: $("#product\\.CLC_DocTemplateId").val(),
            B2C_AllowPrint: $("[name='product\\.B2C_AllowPrint']").isChecked(),
            B2C_DocTemplateId: $("#product\\.B2C_DocTemplateId").val(),
            MOB_AllowPrint: $("[name='product\\.MOB_AllowPrint']").isChecked(),
            MOB_DocTemplateId: $("#product\\.MOB_DocTemplateId").val(),
            MWLT_AllowPrint: $("[name='product\\.MWLT_AllowPrint']").isChecked(),
            MWLT_DocTemplateId: $("#product\\.MWLT_DocTemplateId").val(),
            MediaPrintCodeAliasTypeId: $("#product\\.MediaPrintCodeAliasTypeId").val(),
            MediaEncoderPluginId: $("#product\\.MediaEncoderPluginId").val(),
            ExtMediaGroupTagId: $("[name='product\\.ExtMediaGroupTagId']").val(),
            ExtMediaGroupId: $("[name='product\\.ExtMediaGroupId']").val(),
            GroupTicketOption: $("#product\\.GroupTicketOption").val(),
            ForceMediaGeneration: $("[name='product\\.ForceMediaGeneration']").isChecked(),
            MediaExclusiveUse: isStaffCard ? true : $("[name='product\\.MediaExclusiveUse']").isChecked(),
            PahGenerateMedia: $("[name='product\\.PahGenerateMedia']").isChecked(),
            RequireOrganizeStep: $("[name='product\\.RequireOrganizeStep']").isChecked(),
            MediaNotExisting: $("[name='product\\.MediaNotExisting']").isChecked(),
            MediaAlreadyExisting: $("[name='product\\.MediaAlreadyExisting']").isChecked(),
            RequireMediaInputOnCLC: $("[name='product\\.RequireMediaInputOnCLC']").isChecked(),
            
            <%-- ATTRIBUTE ITEM LIST --%>
            AttributeItemList: attributeItemList,
            
            <%-- ACCOUNT --%> 
            RequireAccount: requireAccount,
            RequireAccountOnEncodingOnly: requireAccountOnEncoding,
            RequireAccountOnRedemptionOnly: requireAccountOnRedemption,
            AccountCategoryId: $("#product\\.AccountCategoryId").val(),
            MinAge: $("#product\\.MinAge").val(),
            MaxAge: $("#product\\.MaxAge").val(),
              
            <%-- GROUPS --%>
            QuantityMin: $("#product\\.QuantityMin").val(),
            QuantityStep: $("#product\\.QuantityStep").val(),
            TrnMaxQty: $("#product\\.TrnMaxQty").val(),
            
            <%-- IDENTITY CHECK --%>
            BiometricCheckLevel: $("#product\\.BiometricCheckLevel").val(),
            BiometricEnrollment: $("#product\\.BiometricEnrollment").val(),
            BioValidityPeriod: bioAdditional ? $("#product\\.BioValidityPeriod").val() : null,
            ManualVerificationType: $("#product\\.ManualVerificationType").val(),
            ManualVerificationMessage: $("#product\\.ManualVerificationType").val() == <%=LkSNManualVerificationType.Never.getCode()%> ? null : $("#product\\.ManualVerificationMessage").val(),
            
            <%-- FAMILY --%>
            ProductPriorityLevel: $("#product\\.ProductPriorityLevel").val(),
            PriorityOrderCheckType: $("#product\\.PriorityOrderCheckType").val(),
            EnforceSecondaryGroup: $("[name='product\\.EnforceSecondaryGroup']").isChecked(),
            AllowStandaloneSales: $("[name='product\\.AllowStandaloneSales']").isChecked(),
            
            <%-- AUTO GENERATED DOC --%>
            AutoGenDocTemplateId: $("#product\\.AutoGenDocTemplateId").val(),
            AutoGenDocAfterPayment: $("[name='product\\.AutoGenDocAfterPayment']").isChecked(),
            /*
            AutoGenDocStep: $("#product\\.AutoGenDocStep").val(),
            AutoGenDocActivation: $("#product\\.AutoGenDocActivation").val(),
            */
            
            <%-- ORDER DISPATCH --%>
            DocTemplateIDs: $("#product\\.DocTemplateIDs").val(),
            SpecificDocTemplateIDs: $("#product\\.SpecificDocTemplateIDs").val(),
            
            <%-- PORTFOLIO --%>
            WalletClearingTriggerType: $("#product\\.WalletClearingTriggerType").val(),
            RewardPointClearingTriggerType: $("#product\\.RewardPointClearingTriggerType").val(),
  
            <%-- PRODUCT MASK --%>
            MetaDataList: metaDataList,
            
            <%-- REQUIRED PLUGINS --%>
            RequiredPluginList: requiredPluginList
          }
        }
      };
      
      if (reqDO.SaveProduct.Product.ProductId == null)
        reqDO.SaveProduct.Product.ProductType = strToIntDef(<%=pageBase.getParameter("ProductType")%>);
  
      <% if (product.ProductType.isLookup(LkSNProductType.Material)) { %>
        reqDO.SaveProduct.Product.ProductStatus = $("#product\\.ProductStatus").isChecked() ? <%=LkSNProductStatus.OnSale.getCode()%> : <%=LkSNProductStatus.Draft.getCode()%>;
      <% } %>
      
      $(document).trigger("product-save", {Product: reqDO.SaveProduct.Product});
  
      showWaitGlass();
      vgsService("Product", reqDO, false, function(ansDO) {
        hideWaitGlass();
        entitySaveNotification(<%=LkSNEntityType.ProductType.getCode()%>, ansDO.Answer.SaveProduct.ProductId);
      });
    }
  }
}

function doDuplicate() {
  var reqDO = {
      Command: "GenerateDuplicateCodeName",
      GenerateDuplicateCodeName: {
        ProductCode: $("#product\\.ProductCode").val(),
        ProductName: $("#product\\.ProductName").val()
      }
  }
  
  vgsService("Product", reqDO, false, function(ansDO) {
    inputProductDetails(ansDO.Answer.GenerateDuplicateCodeName.CandidateProductCode, ansDO.Answer.GenerateDuplicateCodeName.CandidateProductName);
  });
  
  function inputProductDetails(productCode, productName) {
    var dlgInput = $("<div class='duplicate-input-dialog'/>");
    dlgInput.append("<div class='form-field'><div class='form-field-caption'><v:itl key='@Common.NewCode'/></div><div class='form-field-value'><input type='text' class='form-control' id='product.CandidateProductCode' name='product.CandidateProductCode' value='" + productCode + "'/></div></div>");
    dlgInput.append("<div class='form-field'><div class='form-field-caption'><v:itl key='@Common.NewName'/></div><div class='form-field-value'><input type='text' class='form-control' id='product.CandidateProductName' name='product.CandidateProductName' value='" + productName + "'/></div></div>");
    
    
    if (<%=product.ProductType.isLookup(LkSNProductType.Presale)%>)
      $("#newStatus").val(<%=LkSNProductStatus.OnSale.getCode()%>);
    else
      dlgInput.append('<div class="form-field"><div class="form-field-caption"><v:itl key="@Common.Status"/></div><div class="form-field-value"><v:lk-combobox field="newStatus" lookup="<%=LkSN.ProductStatus%>" allowNull="false"/></div></div>');
    
    dlgInput.dialog({
      title: <v:itl key="@Product.ProductType" encode="JS"/>,
      modal: true,
      width: 550,
      height: 250,
      close: function() {
        dlgInput.remove()
      },
      buttons: {
        <v:itl key="@Common.Ok" encode="JS"/>: function() {
          var reqDODup = {
            Command: "DuplicateProduct",
            DuplicateProduct: {
              ProductId: <%=JvString.jsString(pageBase.getId())%>,
              CandidateProductCode: $("#product\\.CandidateProductCode").val(),
              CandidateProductName: $("#product\\.CandidateProductName").val(),
              ProductStatus: $("#newStatus").val()
            }
          };
          dlgInput.dialog("close");

          showWaitGlass();
          vgsService("Product", reqDODup, false, function(ansDODup) {
            hideWaitGlass();
            if (ansDODup.Answer.DuplicateProduct.CandidateCodeNameDifferent == true)
              showDuplicateResultDialog(ansDODup.Answer.DuplicateProduct.ProductId, ansDODup.Answer.DuplicateProduct.ProductCode, ansDODup.Answer.DuplicateProduct.ProductName);
            else
              window.location = "<v:config key="site_url"/>/admin?page=product&id=" + ansDODup.Answer.DuplicateProduct.ProductId;
          });
        },
        <v:itl key="@Common.Cancel" encode="JS"/>: function() {
          dlgInput.dialog("close");
        }
      }
    });
  }
}

function showDuplicateResultDialog(id, code, name) {
  var dlgRes = $("<div class='duplicate-dialog'/>");
  dlgRes.append("Code or Name already used, new code and name are the ones below.<br/><br/>")
  dlgRes.append("<div><v:itl key="@Common.Code"/><span class='recap-value'>" + code + "</span><br/>")
  dlgRes.append("<v:itl key="@Common.Name"/><span class='recap-value'>" + name + "</span><br/></div>")

  dlgRes.dialog({
    title: itl("@Product.NewProductTypeCreated"),
    modal: true,
    width: 450,
    height: 250,
    close: function() {
      dlgInput.remove()
    },
    buttons: [
      dialogButton("@Common.Close", function() {
        dlgRes.dialog("close");
        window.location = "<%=pageBase.getContextURL()%>?page=product&id=" + id;
      })
    ]
  });
}

function getDocTemplateIdArray(idArray){
  var retVal=[];
  var i=0;
  if (idArray){
    for ( i=0; i<idArray.length; ++i){
      retVal.push({DocTemplateId: idArray[i] });
    }
  }
  return retVal;
}
</script>
