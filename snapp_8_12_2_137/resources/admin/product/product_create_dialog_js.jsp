<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.snapp.lookup.LkSN"%>
<%@page import="com.vgs.cl.lookup.LookupItem"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request" />
<script>

var currentStep = 0;
$('#product-create-dialog').on('dialogclose', function(event) {
	if(currentStep!=1)
    	triggerEntityChange(<%=LkSNEntityType.ProductType.getCode()%>);
});

$(document).ready(function() {
  var dlg = $("#product-create-dialog");

  dlg.bind("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        "text": <v:itl key="@Common.Back" encode="JS"/>,
        "id": "create-prod-btn-prev",
        "click": prevStep,
        "disabled": true
      },
      {
        "text": <v:itl key="@Common.Next" encode="JS"/>,
        "id": "create-prod-btn-next",
        "click": nextStep,
        "disabled": false
      },
      {
        "text": <v:itl key="@Common.Close" encode="JS"/>,
        "id": "create-prod-btn-close",
        "click": function() {
          var msg = (currentStep == 2) ? <v:itl key="@Product.CreateWizCloseWarn2" encode="JS"/> : <v:itl key="@Product.CreateWizCloseWarn1" encode="JS"/>;          
          confirmDialog(msg, function() {
            dlg.dialog("close");            
          });
        },
        "disabled": false
      }
    ];
  });

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
  
  refreshRecap();
});

function nextStep() {
  if (currentStep == 0) {
    if ($(".attribute-item-row [type='checkbox']:checked").length > 0) 
      $("#wizard").steps("next");
    else
      showMessage(<v:itl key="@Common.NoElementWasSelected" encode="JS"/>);
  }
  else if (currentStep == 1)
    doCreateProducts();
  else if (currentStep == 2) {
    var invalidEntries = $('.invalid-entry').length;
    if (invalidEntries > 0) 
      showMessage(<v:itl key="@Common.NInvalidEntriesMessage" encode="JS" param1="%1"/>.replace("%1", invalidEntries));
    else{
      doUpdateProducts();
      $("#product-create-dialog").dialog("close");  
    }
  }

}

function prevStep() {
  $("#wizard").steps("previous");
}

function updateWizardDialogButtonsState(step) {
  var dlg = $("#product-create-dialog");
  if (step == 0) {
    $("#create-prod-btn-prev").prop("disabled", true);
    $("#create-prod-btn-next").prop("disabled", false).text(<v:itl key="@Common.Next" encode="JS"/>);
    $("#create-prod-btn-close").prop("disabled", false);
  }
  else if (step == 1) {
    $("#create-prod-btn-prev").prop("disabled", false);
    $("#create-prod-btn-next").prop("disabled", false).text(<v:itl key="@Common.Create" encode="JS"/>);
    $("#create-prod-btn-close").prop("disabled", false);
  } 
  else if(step == 2) {
    $("#create-prod-btn-prev").prop("disabled", true);
    $("#create-prod-btn-next").prop("disabled", false).text(<v:itl key="@Common.Update" encode="JS"/>);
    $("#create-prod-btn-close").prop("disabled", false);
  }
}

function getSelType() {
  return strToIntDef($("#attribute-widget .attribute-row.selected").attr("data-seltype"), <%=LkSNAttributeSelection.Fixed.getCode()%>);
}

function onSelTypeClick(elem) {
  var selType = strToIntDef($(elem).val(), <%=LkSNAttributeSelection.Fixed.getCode()%>);
  $("#attribute-widget .attribute-row.selected").attr("data-seltype", selType);

  if (selType != <%=LkSNAttributeSelection.Fixed.getCode()%>) 
    $("#attribute-item-widget .attribute-block.selected .attribute-item-row [type='checkbox']:checked").setChecked(false).first().setChecked(true);
  refreshRecap();
}

function onAttributeClick(row) {
  var $row = $(row);
  var attributeId = $row.attr("data-attributeid");
  $row.addClass("selected").siblings().removeClass("selected");
  $("#attribute-item-widget .attribute-block").removeClass("selected").filter("[data-attributeid='" + attributeId + "']").addClass("selected");
  $("#selection-type").val(getSelType());
}

function onAttributeItemClick(cb) {
  if (getSelType() != <%=LkSNAttributeSelection.Fixed.getCode()%>) 
    $(cb).closest(".attribute-block").find(".attribute-item-row [type='checkbox']").not(cb).setChecked(false);
  refreshRecap();
}

function refreshRecap() {

  var total = 0;
  var $recap = $(".recap-widget .recap-block").empty();
  
  $("#attribute-widget .attribute-row").each(function(idx, row) {
    var $row = $(row);
    var attributeId = $row.attr("data-attributeid");
    var $cbs = $("#attribute-item-widget .attribute-block[data-attributeid='" + attributeId + "'] .attribute-item-row [type='checkbox']:checked");
    if ($cbs.length > 0) {
      var selType = strToIntDef($row.attr("data-seltype"), <%=LkSNAttributeSelection.Fixed.getCode()%>);
      var $rb = $("#product-create-templates .recap-group").clone().appendTo($recap);
      $rb.find(".recap-title-attribute").html($row.html());
      $rb.find(".recap-title-seltype").html("(" + $("#selection-type option[value='" + selType + "']").text() + ")");
      
      if (total == 0)
        total = 1;
      if (selType == <%=LkSNAttributeSelection.Fixed.getCode()%>)
        total *= $cbs.length;
      
      var $body = $rb.find(".recap-body");
      $cbs.each(function(idx, cb) {
        if (idx > 0)
          $body.append(", ");
        $("<span class='recap-item'/>").appendTo($body).text($(cb).closest("label").text().trim());
      });
    }
  });

  $(".recap-widget .recap-total-value").text(total);
}

function drawProducts(productList) {

  if (productList) {
    for (var i = 0; i < productList.length; i++) {
      var prd = productList[i];
      var $row = $("#product-create-templates .product-row").clone().appendTo(".product-list-body");
      $row.attr("data-productid", prd.ProductId);
      $row.find(".product-code").val(prd.ProductCode);
      $row.find(".product-name").val(prd.ProductName);
      
      $row.find("input").change(function() {
        $(this).closest(".product-row").addClass("modified");
      });
    }
  }
}

function doCreateProducts() {
	
	var saleChannelIDs = $("#salechannels").selectize()[0].selectize.getValue();
	var perfTypeIDs = $("#perftypes").selectize()[0].selectize.getValue();
	
	saleChannelIDs.push("DEFAULT");
	perfTypeIDs.push("DEFAULT");
	
  var reqDO = {
    Command: "CreateProduct",
    CreateProduct: {
      ParentEntityType: <%=JvString.jsString(pageBase.getNullParameter("ParentEntityType"))%>,  
      ParentEntityId: <%=JvString.jsString(pageBase.getNullParameter("ParentEntityId"))%>,
      ProductStatus: $("#product-create-dialog [name='ProductStatus']").val(),
      CategoryId: $("#product-create-dialog [name='CategoryId']").val(),
      TagIDs: $("#product-create-dialog-TagIDs").val(),
      PaymentProfileId: $("#product-create-dialog [name='PaymentProfileId']").val(),
      SaleChannelIDs: saleChannelIDs,
      PerformanceTypeIDs: perfTypeIDs,
      AttributeList: [],
      ReturnProductList: true
    }
  };
  
  $("#attribute-widget .attribute-row").each(function(idx, row) {
    var $row = $(row);
    var attributeId = $row.attr("data-attributeid");
    var $cbs = $("#attribute-item-widget .attribute-block[data-attributeid='" + attributeId + "'] .attribute-item-row [type='checkbox']:checked");
    if ($cbs.length > 0) {
      var ids = [];
      $cbs.each(function(idx, cb) {
        ids.push($(cb).val());
      });

      reqDO.CreateProduct.AttributeList.push({
        AttributeId: attributeId,
        SelectionType: strToIntDef($row.attr("data-seltype"), <%=LkSNAttributeSelection.Fixed.getCode()%>),
        AttributeItemIDs: ids
      });
    }
  });
  
  showWaitGlass();
  vgsService("Product", reqDO, false, function(ansDO) {
    hideWaitGlass();
    if (ansDO.Answer.CreateProduct.ProductCount>0) {

      drawProducts(ansDO.Answer.CreateProduct.ProductList);
      $("#wizard").steps("next");
    }
  });

}

function doUpdateProducts() {
  var reqDO = {
    Command: "FinalizeProductCreation",
    FinalizeProductCreation: {
      ProductList: []
    }
  }
  
  $(".product-list .product-row.modified").each(function(idx, row) {
    var $row = $(row);
    
    if (strToFloatDef($row.find(".product-price").val(), null) == null) {
        reqDO.FinalizeProductCreation.ProductList.push({
            ProductId: $row.attr("data-productid"),
            ProductCode: $row.find(".product-code").val(),
            ProductName: $row.find(".product-name").val()
          });
    }
    else
    	{    
		    reqDO.FinalizeProductCreation.ProductList.push({
		      ProductId: $row.attr("data-productid"),
		      ProductCode: $row.find(".product-code").val(),
		      ProductName: $row.find(".product-name").val(),
		      ProductPrice: strToFloatDef($row.find(".product-price").val(), null)
		    });
    	}
  });
  
  vgsService("Product", reqDO, false, function(ansDO) {
    showAsyncProcessDialog(ansDO.Answer.FinalizeProductCreation.AsyncProcessId, function() {
    	triggerEntityChange(<%=LkSNEntityType.ProductType.getCode()%>);
    });
  });
}

function doSearchAttribute() {
  var keys = $("#attr-search-box").val().toLowerCase().split(" ");
  
  function _isTextMatch(text) {
    text = text.toLowerCase();
    for (var i=0; i<keys.length; i++)
      if (text.indexOf(keys[i]) < 0)
        return false;
    return true;
  }

  function _isRowMatch($row) {
    if (_isTextMatch($row.text()))
      return true;
    else {
      var $items = $("#attribute-item-widget .attribute-block[data-attributeid='" + $row.attr("data-attributeid") + "'] .attribute-item-row");
      for (var i=0; i<$items.length; i++)
        if (_isTextMatch($($items[i]).text())) 
          return true;
    }
    return false;
  }
  
  var $attrs = $("#attribute-widget .attribute-row").removeClass("hidden");
  if (keys.length > 0) {
    $attrs.each(function(idx, row) {
      $(row).setClass("hidden", !_isRowMatch($(row)));
    });
  }
}

</script>