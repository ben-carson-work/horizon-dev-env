<%@page import="com.vgs.web.library.BLBO_Category"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.snapp.lookup.LkSN"%>
<%@page import="com.vgs.cl.lookup.LookupItem"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request" />
<script>
  
var currentStep = 0;

function populateProductSelection(ansDO) {
  var select = $("#productCrossSell\\.CrossProductNameSnapp");
  $(select).empty();
  for (i=0; i<ansDO.Answer.GetSharedProducts.SharedProductList.length; i++) {
    if (i > 0)
      selected = "";
    var item = ansDO.Answer.GetSharedProducts.SharedProductList[i];
    select.append("<option value='" + item.EntityId + "' data-Code='" + item.EntityCode + "' data-Price='" + item.EntityPrice + "'>" + item.EntityName + "</option>")
  }
  refreshSnappProductUI();
}

function refreshSnappProductUI() {
  var optionSelected = $("#productCrossSell\\.CrossProductNameSnapp").find('option:selected');
  $("#productCrossSell\\.CrossProductId").val(optionSelected.val());
  $("#productCrossSell\\.CrossProductCode").val(optionSelected.attr("data-Code"));
  $("#productCrossSell\\.Price").val(optionSelected.attr("data-Price"));
}

function doRefreshUI() {
  var optionSelected = $("#productCrossSell\\.CrossPlatformId").find('option:selected');
  var crossPlatformSnApp = <%=LkSNCrossPlatformType.SnApp.getCode()%>;
  var crossPlatformType = optionSelected.attr("data-Type");
  var crossPlatformURL = optionSelected.attr("data-URL");
  var crossPlatformRef = optionSelected.attr("data-Ref");
  
  $("#productCrossSell\\.CrossProductId").val("");
  $("#productCrossSell\\.CrossProductCode").val("");
  $("#productCrossSell\\.CrossProductNameGeneric").val("");
  $("#productCrossSell\\.CrossProductNameSnapp").val("");
  $("#productCrossSell\\.Price").val("");
  
  $("#product\\.ProductCode").attr("placeholder", "");
  $("#product\\.ProductName").attr("placeholder", "");
  $("#product\\.Price").attr("placeholder", "");
  
  $("#snapp-prod").setClass("v-hidden", crossPlatformSnApp != crossPlatformType);
  $("#xpi-crossproductid").setClass("v-hidden", crossPlatformSnApp == crossPlatformType);
  $("#generic-prod").setClass("v-hidden", crossPlatformSnApp == crossPlatformType);
  
  if (crossPlatformSnApp == crossPlatformType) {
    $("#productCrossSell\\.CrossProductCode").attr("readonly", "readonly");
    $("#productCrossSell\\.Price").attr("readonly", "readonly");
    
    showWaitGlass();
    var reqDO = {
        Command: "GetSharedProducts",
        GetSharedProducts: {
          CrossPlatformURL: crossPlatformURL,
          CrossPlatformRef: crossPlatformRef
        }
      };
      
    vgsService("Product", reqDO, false, function(ansDO) {
      hideWaitGlass();
      if (ansDO.Answer && (ansDO.Answer.GetSharedProducts.SharedProductList.length > 0))
        populateProductSelection(ansDO);
      else 
        showMessage(<v:itl key="@XPI.CrossProductListEmpty" encode="JS"/>);
    });
    
  }
  else {
    $("#productCrossSell\\.CrossProductCode").removeAttr("readonly");
    $("#productCrossSell\\.Price").removeAttr("readonly");
  }
}

function propagateProductInfo() {
	var optionSelected = $("#productCrossSell\\.CrossPlatformId").find('option:selected');
	var crossPlatformSnApp = <%=LkSNCrossPlatformType.SnApp.getCode()%>;
  var crossPlatformType = optionSelected.attr("data-Type");
  
  if (crossPlatformSnApp == crossPlatformType)
    $("#product\\.ProductName").attr("placeholder", $("#productCrossSell\\.CrossProductNameSnapp").find('option:selected').text());
  else
	  $("#product\\.ProductName").attr("placeholder", $("#productCrossSell\\.CrossProductNameGeneric").val());
  
  $("#product\\.ProductCode").attr("placeholder", $("#productCrossSell\\.CrossProductCode").val());
  $("#product\\.Price").attr("placeholder", $("#productCrossSell\\.Price").val());
}

function validateStep1() {
	var result = false;
	var optionSelected = $("#productCrossSell\\.CrossPlatformId").find('option:selected');
  var crossPlatformSnApp = <%=LkSNCrossPlatformType.SnApp.getCode()%>;
  var crossPlatformType = optionSelected.attr("data-Type");
	 
	<%-- This to avoid the "checkRequired" error in case of SnApp products --%>
	if (crossPlatformSnApp == crossPlatformType) 
	  $("#productCrossSell\\.CrossProductNameGeneric").val($("#productCrossSell\\.CrossProductNameSnapp").find('option:selected').text());
	  
	checkRequired("#xpi-prod-sync-create-dialog", function() {  
	  var price = encodeValue($("#productCrossSell\\.Price").val());
	  if (!price) {
	    showMessage(<v:itl key="@XPI.PriceNotValid" encode="JS"/>, function() {
	    	$("#productCrossSell\\.Price").focus();
	    });
	    result = false;
	  }
	  else {
		  $("#productCrossSell\\.Price").val(price);
		  result = true;
	  }
	});
	
	return result;
}

function encodeValue(price) {
  var value = price;
  value = value.replace("%", "");
  value = value.replace(",", ".");
  value = parseFloat(value);
  return isNaN(value) ? null : value;
}

function updateWizardDialogButtonsState(step){
  if(step == 0){
    $(".button-previous").prop("disabled", true).addClass("ui-button-disabled ui-state-disabled");
    $(".button-next").prop("disabled", false);
    $(".button-close").prop("disabled", false);
    $(".button-next").text(<v:itl key="@Common.Next" encode="JS"/>);
  }else if(step == 1){
	    $(".button-previous").prop("disabled", false).removeClass("ui-button-disabled ui-state-disabled");
	    $(".button-next").prop("disabled", false);
	    $(".button-close").prop("disabled", false);
	    $(".button-next").text(<v:itl key="@Common.Next" encode="JS"/>);
  }else if(step == 2){
    $(".button-previous").prop("disabled", false).removeClass("ui-button-disabled ui-state-disabled");
    $(".button-next").prop("disabled", false);
    $(".button-close").prop("disabled", false);
    $(".button-next").text(<v:itl key="@Common.Create" encode="JS"/>);
  }
}

function nextStep() {
  if (currentStep == 0) {
	  if (validateStep1()) {
		  propagateProductInfo();
      $("#wizard").steps("next");
	  }
  } else if (currentStep == 1) 
	    $("#wizard").steps("next");
    else if (currentStep == 2)
      doCreateProduct();
}

function doClose(){
	$("#xpi-prod-sync-create-dialog").dialog("close");
}

function prevStep() {
  $("#wizard").steps("previous");
}

  
$(document).ready(function() {
      
  $("#wizard").steps({
    headerTag: "h3",
    bodyTag: "section",
    transitionEffect: "slideLeft",
    autoFocus: true,
    enableCancelButton: false,
    enablePagination: false,
    enableAllSteps: false,
    enableKeyNavigation: false,
    onStepChanged: function(event, currentIndex, priorIndex){
      currentStep = currentIndex;
      updateWizardDialogButtonsState(currentStep);
    }
  });

  var dlg = $("#xpi-prod-sync-create-dialog");

  dlg.bind("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        "text": <v:itl key="@Common.Back" encode="JS"/>,
        "class": "button-previous",
        "click": prevStep,
        "disabled": true
      },
      {
        "text": <v:itl key="@Common.Next" encode="JS"/>,
        "class": "button-next",
        "click": nextStep,
        "disabled": false
      },
      {
        "text": <v:itl key="@Common.Cancel" encode="JS"/>,
        "class": "button-close",
        "click": doClose,
        "disabled": false
      }
    ];
  });

  $("#productCrossSell\\.CrossPlatformId").change(doRefreshUI);
  $("#productCrossSell\\.CrossProductNameSnapp").change(refreshSnappProductUI);
  
  doRefreshUI();
});

function doCreateProduct() {
	var categoryId = $("#product\\.CategoryId").val();
	if (categoryId == "")
		categoryId = <%=JvString.jsString(pageBase.getBL(BLBO_Category.class).getRootCategoryId(LkSNEntityType.ProductType))%>;
	var productCode = $("#product\\.ProductCode").val() == "" ? $("#product\\.ProductCode").attr("placeholder") : $("#product\\.ProductCode").val();
	var productName = $("#product\\.ProductName").val() == "" ? $("#product\\.ProductName").attr("placeholder") : $("#product\\.ProductName").val();
	var basePrice = $("#product\\.Price").val() == "" ? $("#product\\.Price").attr("placeholder") : $("#product\\.Price").val();
	basePrice = encodeValue(basePrice);
	
	var crossPrice = encodeValue($("#productCrossSell\\.Price").val());

	if (!basePrice) {
		showMessage(<v:itl key="@XPI.PriceNotValid" encode="JS"/>, function() {
	    	$("#product\\.Price").focus();
	    });
	}
	else {
		
		showWaitGlass();
		var reqDO = {
		  Command: "SaveProduct",
		  SaveProduct: {
			  Product: {
				  ProductType: <%=LkSNProductType.Product.getCode()%>,
				  ProductCode: productCode,
			    ProductName: productName,
				  ProductStatus: $("#product\\.ProductStatus").val(),
				  CategoryId: categoryId,
				  TagIDs: $("#product\\.TagIDs").selectize()[0].selectize.getValue(),
				  POS_AllowPrint: $("[name='product\\.POS_AllowPrint']").isChecked(),
          POS_DocTemplateId: $("#product\\.POS_DocTemplateId").val(),
          B2B_AllowPrint: $("[name='product\\.B2B_AllowPrint']").isChecked(),
          B2B_DocTemplateId: $("#product\\.B2B_DocTemplateId").val(),
          CLC_AllowPrint: $("[name='product\\.CLC_AllowPrint']").isChecked(),
          CLC_DocTemplateId: $("#product\\.CLC_DocTemplateId").val(),
          B2C_AllowPrint: $("[name='product\\.B2C_AllowPrint']").isChecked(),
          B2C_DocTemplateId: $("#product\\.B2C_DocTemplateId").val(),
          MOB_AllowPrint: $("[name='product\\.MOB_AllowPrint']").isChecked(),
          MOB_DocTemplateId: $("#product\\.MOB_DocTemplateId").val(),
				  XPIOneToOne: true,
				  PriceDateList: [{
					  PriceList: getPriceList(basePrice)
				  }],
				  ProductCrossSellList: getProductCrossSellList($("#product\\.ProductName").attr("placeholder"), crossPrice)
			  }
		  }
		};
		
	 	vgsService("Product", reqDO, false, function(ansDO) {
    	hideWaitGlass();
	    triggerEntityChange(<%=LkSNEntityType.ProductType.getCode()%>);
	    doClose();
	 	});
	}
}

function getPriceList(basePrice) {
	var list = [];
	var saleChannelIDs = $('#product\\.SaleChannelIDs').selectize()[0].selectize.getValue();
	var perfTypeIDs = $('#product\\.PerfTypeIDs').selectize()[0].selectize.getValue();
	
	saleChannelIDs.push("DEFAULT");
	perfTypeIDs.push("DEFAULT");
	
	for (var i=0; i<saleChannelIDs.length; i++) {
		for (var j=0; j<perfTypeIDs.length; j++) {
			var priceCell = {
						SaleChannelId: saleChannelIDs[i] === "DEFAULT" ? null : saleChannelIDs[i],
						PerformanceTypeId: perfTypeIDs[j] === "DEFAULT" ? null : perfTypeIDs[j],
						ActionType: ((saleChannelIDs[i] === "DEFAULT") && (perfTypeIDs[j] === "DEFAULT")) ? <%=LkSNPriceActionType.Fixed.getCode()%> : <%=LkSNPriceActionType.Inherit.getCode()%>,
						ValueType: <%=LkSNPriceValueType.Absolute.getCode()%>,
						Value: ((saleChannelIDs[i] === "DEFAULT") && (perfTypeIDs[j] === "DEFAULT")) ? basePrice : null
			}
			list.push(priceCell);
		}
	}
	return list;
}

function getProductCrossSellList(crossProdName, price) {
	var list = [];
	var productCrossSell = {
			CrossPlatformId: $("#productCrossSell\\.CrossPlatformId").val(),
			CrossProductId: $("#productCrossSell\\.CrossProductId").val(),
		  CrossProductName: crossProdName,
		  CrossProductCode: $("#productCrossSell\\.CrossProductCode").val(),
		  CrossProductStatus: <%=LkSNCrossProductStatus.Enabled.getCode()%>,
		  Price: price
	}
	list.push(productCrossSell);
	return list;
}

</script>