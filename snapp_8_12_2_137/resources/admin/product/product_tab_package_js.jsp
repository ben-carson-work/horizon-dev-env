<%@page import="com.vgs.snapp.dataobject.DOEvent.DODynRateCode"%>
<%@page import="com.vgs.snapp.dataobject.DOEvent.DODynPerformanceType"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProduct" scope="request"/>
<jsp:useBean id="product" class="com.vgs.snapp.dataobject.DOProduct" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
boolean canEdit = pageBase.getRightCRUD().canUpdate();
%>

<script>
$(document).ready(function() {

	$("#btn-package-save").click(_savePackage);
	$("#btn-add-product").click(_showProductPickupDialog);
	$("#btn-remove-product").click(_removeProducts);
	
	<%if (product.PackagePriceOnItems.getBoolean()) { %>
	  $("input[name=pricing-group-radio][value=2]").prop('checked', true);
	<% } else { %>
		$("input[name=pricing-group-radio][value=1]").prop('checked', true);
  <% } %>
	
	$("#product\\.ProductPackageType").change(setPackageTypeDiv);
	$('input[type=radio][name=pricing-group-radio]').change(setPriceColumn);
	
	$("#package-producttype-grid tbody").sortable({
		  handle: ".grid-move-handle",
		  helper: fixHelper
	});
	
	<%for (DOProduct.DOProductPackage item : product.ProductPackageList) {%>
	  _addProduct(
        <%=item.ProductId.getJsString()%>,
        <%=item.ProductCode.getJsString()%>,
        <%=item.ProductName.getJsString()%>,
        <%=item.OptionSetId.getJsString()%>,
        <%=item.OptionSetDesc.getJsString()%>,
        <%=item.PriceValueType.getJsString()%>,
        <%=item.PriceValue.getJsString()%>,
        <%=item.Quantity.getInt()%>
        );
  <% } %>

  setPackageTypeDiv();
  recalcTotalAmount();
  
  function setPriceColumn() {
    let hide = ($(".package-producttype").attr("data-packagetype") == <%=LkSNProductPackageType.ProductMerge.getCode()%>) || ($("input[name=pricing-group-radio]:checked").val() != 2);
    $('[data-pricing]').setClass("hidden", hide);
    
	}
  
  function setPackageTypeDiv() {
	  $(".package-producttype").attr("data-packagetype", $("#product\\.ProductPackageType").val());
	  
	  $("#packagetype-itemized-flags").setClass("hidden", $("#product\\.ProductPackageType").val() == <%=LkSNProductPackageType.ProductMerge.getCode()%>);
	  
	  $(".package-producttype").find(".tr-producttype .txt-quantity").prop('disabled', $(".package-producttype").attr("data-packagetype") == <%=LkSNProductPackageType.ProductMerge.getCode()%>);
	  
	  if ($(".package-producttype").attr("data-packagetype") == <%=LkSNProductPackageType.ProductMerge.getCode()%>) 
	    $(".package-producttype").find(".tr-producttype .txt-quantity").val(1);

	  $("tr .tr-producttype").each(function() {
		  $this = $(this);
		  var packageProduct = JSON.parse($this.attr("data-product"));
		  packageProduct.PriceValue = $this.find(".txt-pricevalue").val();
		  packageProduct.Quantity = $this.find(".txt-quantity").val();
		  $this.attr("data-product", JSON.stringify(packageProduct));
		});
	  
	  setPriceColumn();
  }
  
  function setPriceValue() {
    var packageProduct = JSON.parse($(this).closest('tr').attr("data-product"));
    packageProduct.PriceValue = convertPriceValue($(this).val());
    $(this).closest('tr').attr("data-product", JSON.stringify(packageProduct));
    recalcTotalAmount();
  }
  
  function setQuantity() {
	  var packageProduct = JSON.parse($(this).closest('tr').attr("data-product"));
	  packageProduct.Quantity = $(this).val();
	  $(this).closest('tr').attr("data-product", JSON.stringify(packageProduct));
	  recalcTotalAmount();
	}
  
  function recalcTotalAmount() {
	  var $trs = $("#individual-components-body tr");
	  var amount = 0;
	  for (var i=0; i<$trs.length; i++) {
	    var $tr = $($trs[i]);
	    var packageProduct = JSON.parse($tr.attr("data-product"));
	    amount = amount + (packageProduct.PriceValue * packageProduct.Quantity);
	  }
	  $("#txt-pricevalue-total").val(amount.toFixed(<%=pageBase.getSession().getMainCurrencyDecimals()%>));
  };
  
	function _showProductPickupDialog() {
	  showLookupDialog({
	    EntityType: <%=LkSNEntityType.ProductType.getCode()%>,
	    onPickup: function(item) {
	      if ($("#package-producttype-grid tr[data-ProductId='" + item.ItemId + "']").length > 0) 
	        showMessage(itl("@Product.ProductAlreadyExistsError"));
	      else if (item.ItemId == "<%=pageBase.getId()%>")
	        showMessage(itl("@Product.ProductSelfReferenceError")); 
	      else 
	    	  _addProduct(item.ItemId, item.ItemCode, item.ItemName, null, itl("@Common.None"), null, null, 1);
	    }
	  });
	}
	
	function _addProduct(id, code, name, optionSetId, optionSetDesc, priceValueType, priceValue, quantity) {
	  quantity = isNaN(parseInt(quantity)) ? 0 : parseInt(quantity);
	  
	  var packageProduct = {
			  "PackageId" : <%=JvString.jsString(pageBase.getId())%>,
			  "ProductId" : id,
			  "ProductCode" : code,
			  "ProductName" : name,
			  "OptionSetId" : optionSetId,
			  "OptionSetDesc" : optionSetDesc,
			  "PriceValueType" : priceValueType,
			  "PriceValue" : priceValue,
			  "Quantity" : quantity
	  };
	  
	  _doAddProduct(packageProduct);
	}
	
	function _doAddProduct(packageProduct) {
    let quantityEnabled = <%=canEdit%> && ($(".package-producttype").attr("data-packagetype") != <%=LkSNProductPackageType.ProductMerge.getCode()%>);
    
		let $tr = $("#package-producttype-templates .tr-producttype").clone().appendTo("#individual-components-body");
		$tr.attr("data-productId", packageProduct.ProductId);
    
		$tr.attr("data-product", JSON.stringify(packageProduct));
    
    $tr.find(".product-name").attr("href", "admin?page=product&id=" + packageProduct.ProductId).text(packageProduct.ProductName);
    
    $tr.find(".product-code").text(packageProduct.ProductCode);
    
    $tr.find(".optionset-desc").text(packageProduct.OptionSetDesc);
    
    $tr.find(".optionset-edit").attr("href", "javascript:asyncDialogEasy('product/product_package_options_dialog', 'ProductId=" + packageProduct.ProductId + "&OptionSetId=" + packageProduct.OptionSetId + "')");
    $tr.find(".optionset-edit").text(itl("@Common.Edit"));
    
    $tr.find(".txt-pricevalue").val(packageProduct.PriceValue);
    $tr.find(".txt-pricevalue").change(setPriceValue);
    
    $tr.find(".txt-quantity").val(packageProduct.Quantity);
    $tr.find(".txt-quantity").change(setQuantity);
    
    if (!quantityEnabled) 
      $tr.find(".txt-quantity").attr("disabled", "disabled");
	}
	
	function _removeProducts() {
	  $("#package-producttype-grid tbody .cblist:checked").closest("tr").remove();
	}
	
	function _savePackage() {
		let itemized = $(".package-producttype").attr("data-packagetype") == <%=LkSNProductPackageType.ProductItemized.getCode()%>;
		let priceOnItem = $("input[name=pricing-group-radio]:checked").val() == 2;
		let packageRedeem = $("#product\\.PackageRedeemPackage").isChecked();
		let propagateUsages = $("#product\\.PackagePropagateUsagesOnItems").isChecked();
		
    var reqDO = {
      Command: "SaveProduct",
      SaveProduct: {
        Product: {
          ProductId: <%=JvString.jsString(pageBase.getId())%>,
          ProductPackageType: $(".package-producttype").attr("data-packagetype"),
          PackagePriceOnItems: itemized && priceOnItem,
          PackageRedeemPackage: itemized && packageRedeem,
          PackagePropagateUsagesOnItems: itemized && packageRedeem && propagateUsages,
          ProductPackageReadType: <%=LkSNProductPackageReadType.Group.getCode()%>,
          ProductPackageList: getIndividualComponents(itemized, priceOnItem)
        }
      }
    };   

    showWaitGlass();
    vgsService("Product", reqDO, false, function(ansDO) {
      hideWaitGlass();
      entitySaveNotification(<%=LkSNEntityType.ProductType.getCode()%>, ansDO.Answer.SaveProduct.ProductId, "tab=package");
    });
  }
	
	function showAttributePickup() {
    asyncDialogEasy("attribute/attribute_pickup_dialog", "");
	}
	
	function getIndividualComponents(itemized, priceOnItem) {
		let list = [];
	  let $trs = $("#individual-components-body tr");
	  
	  for (let i=0; i<$trs.length; i++) {
		  let $tr = $($trs[i]);
		  let packageProduct = JSON.parse($tr.attr("data-product"));
		  let qty = !itemized ? 1 : packageProduct.Quantity;
		  let value = null;
		  if (itemized && priceOnItem) 
			  value = packageProduct.PriceValue == null ? "0" : packageProduct.PriceValue;
		  
	    list.push({
	    	  PriorityOrder: i + 1,
	    	  PackageId: packageProduct.PackageId,
	        ProductId: packageProduct.ProductId,
	        ProductCode: packageProduct.ProductCode,
	        ProductName: packageProduct.ProductName,
	        OptionSetId: packageProduct.OptionSetId,
	        OptionSetDesc: packageProduct.OptionSetDesc,
	        PriceValueType: packageProduct.PriceValueType,
	        PriceValue: value,
	        Quantity: qty
	      });
	  }
	  return list;
	}
	
});

</script>
