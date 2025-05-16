<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.service.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<% String productId = pageBase.getNullParameter("ProductId"); %>
<% String performanceId = pageBase.getNullParameter("PerformanceId"); %>
<% float basePrice = JvString.strToFloatDef(pageBase.getParameter("BasePrice"), 0); %>
<% DOProduct prod = SrvBO_OC.getProduct(pageBase.getConnector(), productId).Product; %>

<v:dialog id="options_dialog" title="@Common.Options" icon="attribute.png" width="979" height="750" resizable="false" showTitlebar="false">

<style>
  #options_dialog {
    padding: 5px;
  }

  #options_dialog .v-button {
    min-width: 100px;
  }
  .product-block {
    position: relative;
    margin: 5px;
    padding: 4px;
    border: 1px var(--tab-border-color) solid;
    background-color: white;
  }
  
  .product-icon {
    width: 86px;
    height: 86px;
    background-size: cover;
    background-repeat: no-repeat;
    background-position: center center;
  }
  
  .product-caption {
    position: absolute;
    top: 10px;
    left: 100px;
    right: 370px;
    font-size: 2em;
  }
  
  .product-mandatory-hint {
    position: absolute;
    bottom: 4px;
    left: 100px;
    font-size: 1.3em;
    color: rgba(0,0,0,0.5);
    font-style: italic;
  }
  
  #product-price-details {
    position: absolute;
    top: 12px;
    right: 10px;
    width: 200px;
  }
  
  #product-price-details .product-price-item {
    overflow: hidden;
    font-size: 1.3em;
    padding: 2px 0 2px 0;
  }
  
  #product-price-details .price-caption {
    float: left;
  }
  
  #product-price-details .price-value {
    float: right;
  }
  
  #product-price-final {
    font-weight: bold;
    border-top: 1px rgba(0,0,0,0.2) solid;
    margin-top: 2px;
  }
  
  .attribute-list-block {
    overflow: auto;
    position: absolute;
    left: 0;
    right: 0;
    top: 106px;
    bottom: 60px;
    padding: 5px;
  }

  .attribute-block {
    float: left;
    width: 230px;
    margin: 5px;
    background-color: white;
    border: 1px var(--tab-border-color) solid;
    font-size: 1.3em;
  }
  
  .attribute-title {
    background-color: var(--pagetitle-bg-color);
    border-bottom: 1px var(--tab-border-color) solid;
    padding: 10px;
    text-align: center;
    font-weight: bold;
  }
  
  .option-item {
    position: relative;
    overflow: hidden;
    padding: 4px;
    height: 48px;
    cursor: pointer;
  }
  
  .option-item.selected {
    background-color: var(--highlight-color);
  }
  
  .option-item:not(.selected):hover {
    background-color: var(--body-bg-color);
  }
  
  .option-item-icon {
    display: inline-block;
    vertical-align: middle;
    width: 40px;
    height: 40px;
    background-repeat: no-repeat;
    background-position: center center;
  }
  
  .option-item-caption {
    position: absolute;
    left: 48px;
    top: 4px;
    right: 0;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    height: 40px;
    line-height: 40px;
  }
  
  .option-item-caption.has-price {
    height: 20px;
    line-height: 20px;
  }
  
  .option-item-price {
    position: absolute;
    left: 48px;
    top: 24px;
    right: 0;
    height: 20px;
    vertical-align: bottom;
    font-weight: bold;
  }
  
  #quantity-box {
    float: right;
    position: relative;
    width: 130px;
    height: 40px;
    border-right: 1px var(--tab-border-color) solid;
  }
  
  #quantity-box .v-button {
    position: absolute;
    top: 0;
    bottom: 0;
    width: 40px;
    min-width: 40px;
    line-height: 40px;
    padding: 0;
    background-position: center center;
    background-repeat: no-repeat;
    font-size: 22px;
  }
  
  #btn-qtymin {
    left: 0;
  }
  
  #btn-qtypls {
    right: 10px;
  }
  
  #quantity-value {
    position: absolute;
    top: 0;
    left: 0;
    bottom: 0;
    right: 10px;
    line-height: 40px;
    text-align: center;
    font-size: 1.5em;
  }
</style>

<div class="product-block">
  <% String imgProd = prod.ProfilePictureId.isNull() ? "imagecache?name=" + prod.IconName.getHtmlString() + "&size=32" : "repository?type=small&id=" + prod.ProfilePictureId.getHtmlString(); %>
  <div class="product-icon" style="background-image:url('<v:config key="site_url"/>/<%=imgProd%>')"></div>
  <div class="product-caption">
    <%=(prod.ShowNameExt.getBoolean() && !prod.ProductNameExt.isNull()) ? prod.ProductNameExt.getHtmlString() : prod.ProductName.getHtmlString()%>
  </div>
  <div class="product-mandatory-hint">(*) <v:itl key="@Product.MandatoryChoices"/></div>
  <div id="product-price-details">
    <div id="product-price-base" class="product-price-item">
      <div class="price-caption"><v:itl key="@Product.BasePrice"/></div>
      <div class="price-value"><%=pageBase.formatCurrHtml(basePrice)%></div>
    </div>
    <div id="product-price-options" class="product-price-item">
      <div class="price-caption"><v:itl key="@Common.Options"/></div>
      <div class="price-value"></div>
    </div>
    <div id="product-price-final" class="product-price-item">
      <div class="price-caption"><v:itl key="@Common.Total"/></div>
      <div class="price-value"></div>
    </div>
  </div>
</div>

<div class="attribute-list-block">
<% for (DOProduct.DOAttributeItem attrItem : prod.AttributeItemList.getItems()) { %>
  <% if (attrItem.Active.getBoolean() && !attrItem.SelectionType.isLookup(LkSNAttributeSelection.Fixed)) { %>
    <% boolean mandatory = attrItem.SelectionType.isLookup(LkSNAttributeSelection.DynForce); %>
    <div class="attribute-block noselect <%=mandatory?"mandatory":""%>" data-AttributeId="<%=attrItem.AttributeId.getHtmlString()%>">
      <div class="attribute-title"><%=attrItem.AttributeName.getHtmlString()%><%=mandatory?" (*)":""%></div>
      <div class="option-list">
      <% for (DOProduct.DOOption option : attrItem.OptionList.getItems()) { %>
        <% boolean selected = mandatory && option.AttributeItemId.isSameString(attrItem.AttributeItemId); %>
        <div class="option-item <%=selected?"selected":""%>" data-AttributeItemId="<%=option.AttributeItemId.getHtmlString()%>" data-OptionalPrice="<%=option.OptionalPrice.getString()%>">
          <% boolean showPrice = option.OptionalPrice.getMoney() != 0; %>
          <% String imgOpt = option.ProfilePictureId.isNull() ? "imagecache?name=" + JvString.urlEncode(LkSNEntityType.AttributeItem.getIconName()) + "&size=32" : "repository?type=thumb&id=" + option.ProfilePictureId.getHtmlString(); %>
          <img class="option-item-icon" src="<v:config key="site_url"/>/<%=imgOpt%>"/>
          <div class="option-item-caption <%=showPrice?"has-price":""%>"><%=option.AttributeItemName.getHtmlString()%></div>
          <% if (showPrice) { %>
            <div class="option-item-price"><%=pageBase.formatCurrHtml(option.OptionalPrice)%></div>
          <% } %>
        </div>
      <% } %>
      </div>
    </div>
  <% } %>
<% } %>
</div>

<div class="toolbar-block">
  <div id="btn-addtocart" class="v-button hl-green"><v:itl key="@Common.Add"/></div>
  <div id="btn-close" class="v-button hl-red"><v:itl key="@Common.Close"/></div>
  <div id="quantity-box">
    <div id="quantity-value"><%=prod.QuantityMin.getInt()%></div>
    <div id="btn-qtypls" class="v-button btn-quantity" onclick="editQuantity(+<%=prod.QuantityStep.getInt()%>)"><i class="fa fa-plus"></i></div>
    <div id="btn-qtymin" class="v-button btn-quantity" onclick="editQuantity(-<%=prod.QuantityStep.getInt()%>)"><i class="fa fa-minus"></i></div>
  </div>
</div>

<script>

$("#options_dialog .option-item").click(function() {
  var divAttr = $(this).closest(".attribute-block");
  if ($(this).hasClass("selected")) {
    if (!divAttr.hasClass("mandatory"))
      $(this).removeClass("selected");
  }
  else {
    divAttr.find(".option-item").removeClass("selected");
    $(this).addClass("selected");
  }
  recalcPrices();
});

$(document).ready(recalcPrices);

function recalcPrices() {
  var items = $(".option-item.selected");
  var options = 0;
  for (var i=0; i<items.length; i++) 
    options += parseFloat($(items[i]).attr("data-OptionalPrice"));
  var unit = options+<%=basePrice%>;
  var total = unit * getQuantity();
  
  $("#product-price-options .price-value").html(formatCurr(options));
  $("#product-price-final .price-value").html(formatCurr(unit));
}

function getQuantity() {
  return parseInt($("#quantity-value").text());
}

function setQuantity(quantity) {
  $("#quantity-value").text(quantity);
}

function editQuantity(delta) {
  var quantity = getQuantity();
  var mult = (quantity < 0) ? -1 : 1;
  setQuantity(Math.max(Math.abs(quantity + delta), <%=prod.QuantityMin.getInt()%>) * mult);
}

$("#btn-addtocart").click(function() {
  var productId = "<%=productId%>";
  var performanceId = <%=(performanceId == null) ? null : "\"" + performanceId + "\""%>;
  var optionIDs = [];
  var items = $(".option-item.selected");
  for (var i=0; i<items.length; i++)
    optionIDs.push($(items[i]).attr("data-AttributeItemId"));
  
	addCheckAddToCartValues({"OptionIDs": optionIDs.join(","), "QuantityDelta": getQuantity()});
  //doAddToCart(productId, optionIDs.join(","), performanceId, null, 1, getQuantity());
  $("#options_dialog").dialog("close");
});

$("#btn-close").click(function() {
  $("#options_dialog").dialog("close");
});

</script>

</v:dialog>