<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.entity.dataobject.DOPlgSettings_VirtualProdPricing.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="snp-tags" prefix="snp" %>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>
<jsp:useBean id="settings" class="com.vgs.entity.dataobject.DOPlgSettings_VirtualProdPricing" scope="request"/>

<%
  int dateFormat = LkSNDateFormat._102.getCode();
  if (pageBase.isAmericanDateFormat())
    dateFormat = LkSNDateFormat._104.getCode();

  boolean simulateDynamicGateCategories = settings.getChildField("SimulateDynamicGateCetgories").getBoolean();
  boolean simulateMetadata = settings.getChildField("SimulateMetadata").getBoolean();
  boolean simulateOfflineTransaction = settings.getChildField("SimulateOfflineTransaction").getBoolean();
  
  float commissionAmount = settings.getChildField("CommissionAmount").getFloat();
  float downPaymentAmount = settings.getChildField("DownPaymentAmount").getFloat();
  
  String simulateDynamicGateCategoriestHint = 
      "When checked, SnApp will respond with fixed set of gate categories to every price call</br>" +  
      "TP - 150$</br>" +
      "OGA - 20$";
      
  String simulateMetadataHint = 
      "When checked, SnApp will respond with fixed set of metadata to every price call (MetaFieldCode + Value)</br>" +  
      "PF1 - test1</br>" + 
      "PF2 - test2";      
  
%>

<v:widget caption="Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
<div class="tab-content">
	<v:grid id="product-pricing-grid" style="margin-bottom:10px">
		<thead>
		  <tr>
		    <td><v:grid-checkbox header="true"/></td>
		    <td width="15%"><v:itl key="@Product.ProductType"/></td>
		    <td width="25%"><v:itl key="@Common.VisitingRange"/></td>
		    <td width="25%"><v:itl key="@Common.SaleDateRange"/></td>
		    <td width="12%"><v:itl key="@Product.Price"/><br/><v:itl key="@Product.FacePrice"/></td> 
		    <td width="15%"><v:itl key="@Common.OrganizationCode"/></td>
		    <td width="8%"><v:itl key="@Common.ValidityDays"/></td>
		    <td></td>              
		  </tr>
		</thead>
		<tbody id="pricing-rule-body">
		</tbody>
		<tbody>
	    <tr>
	      <td colspan="100%">
					<v:button fa="plus" caption="@Common.Add" onclick="showProductPickupDialog()"/>
					<v:button fa="minus" caption="@Common.Remove" onclick="removeRules()"/>
					<v:button fa="clone" caption="@Common.Duplicate" onclick="duplicateRule()"/>
	      </td>
	    </tr>
	  </tbody>
	</v:grid>
	<v:widget-block>
    <v:db-checkbox field="settings.SimulateDynamicGateCetgories" caption="Return dynamic gate categories" hint="<%=simulateDynamicGateCategoriestHint%>" value="true" checked="<%=simulateDynamicGateCategories%>" /><br/>
    <v:db-checkbox field="settings.SimulateMetadata" caption="Return product meta-data" hint="<%=simulateMetadataHint%>" value="true" checked="<%=simulateMetadata%>" /><br/>
    <v:db-checkbox field="settings.SimulateOfflineTransaction" caption="Simulate offline transaction" value="true" checked="<%=simulateOfflineTransaction%>" /><br/>
    <v:db-checkbox field="settings.CommissionChecked" caption="Commission amount" value="true" checked="<%=commissionAmount!=0%>"/>
    <div data-visibilitycontroller="#settings\.CommissionChecked">
      <v:input-text field="settings.CommissionAmount"/>
    </div><br/>
    <v:db-checkbox field="settings.DownPaymentChecked" caption="Downpayment amount" value="true" checked="<%=downPaymentAmount!=0%>"/>
    <div data-visibilitycontroller="#settings\.DownPaymentChecked">
      <v:input-text field="settings.DownPaymentAmount"/>
    </div>
  </v:widget-block>
</div>

<div id="product-pricing-rule-template" class="v-hidden">
	<tr>
	  <td><input type="text" class="form-control productTemplate"/></td>
	  <td><input type="text" class="form-control dateFrom-picker-template" autocomplete="off" placeholder="Unlimited"></td>
	  <td><input type="text" class="form-control dateTo-picker-template" autocomplete="off" placeholder="Unlimited"></td>
	  <td><input type="text" class="form-control dateSellFrom-picker-template" autocomplete="off" placeholder="Unlimited"></td>
	  <td><input type="text" class="form-control dateSellTo-picker-template" autocomplete="off" placeholder="Unlimited"></td>
	  <td><input type="text" class="form-control priceTemplate"/></td>
	  <td><input type="text" class="form-control facePriceTemplate"/></td>
	  <td><input type="text" class="form-control organization"/></td>	      <!-- There's a world where I need form-filed instead of form control LkSNEntityType.Organization -->
	  <td><input type="text" class="form-control validityDaysTemplate"/></td>
	</tr>
</div>
</v:widget>
 
<script>

$(document).ready(function() {
  var settings = <%=settings.getJSONString()%>;
  
  if (settings.ProductPricingRules != undefined) {
    for (var i=0; i<settings.ProductPricingRules.length; i++) {
      var rule = settings.ProductPricingRules[i];
      addProductPriceRule(rule.ProductId, rule.ProductName, rule.SearchDateFrom, rule.SearchDateTo, rule.SellDateFrom, rule.SellDateTo, rule.Price, rule.FacePrice, rule.OrganizationCode, rule.ValidityDays);
    }
  }
});

function showProductPickupDialog() {

  showLookupDialog({
    EntityType: <%=LkSNEntityType.ProductType.getCode()%>,
    onPickup: function(item) {
      addProductPriceRule(item.ItemId, item.ItemName, "", "", "", "", "", "", "", "");
    }
  });
}

function addProductPriceRule (productId, productName, searchDateFrom, searchDateTo, sellFromDate, sellDateTo, price, facePrice, organization, validityDays) {
  var rowNumbers = $("#product-pricing-grid tbody#pricing-rule-body tr").length;
  var tr = $("<tr class='grid-row'" + "' data-ProductId='" + productId + "' data-ProductName='" + productName + "'/>").appendTo("#pricing-rule-body");

  var tdCB = $("<td/>").appendTo(tr);
  var tdProduct = $("<td/>").appendTo(tr);
  var tdFromDate = $("<td display='inline-block'/>").appendTo(tr);
  var tdSellFromDate = $("<td display='inline-block'/>").appendTo(tr);
  var tdPrice = $("<td/>").appendTo(tr);
  var tdOrganization = $("<td/>").appendTo(tr);
  var tdValidityDays = $("<td/>").appendTo(tr);

  tdCB.append("<input value='" + productId + "' type='checkbox' class='cblist'>");
  
  var hrefURL = <%=JvString.jsString(ConfigTag.getValue("site_url"))%> + "/admin?page=product&id=" + productId;
  $("#product-pricing-rule-template .productTemplate").clone().appendTo(tdProduct).val(productId);
  tdProduct.html("<a href=" + hrefURL + ">" + productName + "</a>");
  
  var labelFrom = $("<label width='25%' display='inline-block'>From:&nbsp;</label> ").appendTo(tdFromDate);
  var dateFromPickerId = buildDatePickerId("dateFrom", productId, rowNumbers);
  $("#product-pricing-rule-template .dateFrom-picker-template")
    .clone()
    .attr("id", dateFromPickerId).css({"display": "inline-block", "width": "75%"})
    .appendTo(tdFromDate);
  initDatePicker($("#" + dateFromPickerId));
  if (searchDateFrom != null)
    $("#" + dateFromPickerId).datepicker('setDate', new Date(searchDateFrom));
  var labelTo = $("<label width='25%' display='inline-block'>To:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label> ").appendTo(tdFromDate);
  var dateToPickerId = buildDatePickerId("dateTo", productId, rowNumbers);
  $("#product-pricing-rule-template .dateTo-picker-template")
    .clone()
    .attr("id", dateToPickerId).css({"display": "inline-block", "width": "75%"})
    .appendTo(tdFromDate)
  initDatePicker($("#" + dateToPickerId));
  if (searchDateTo != null)
    $("#" + dateToPickerId).datepicker('setDate', new Date(searchDateTo));
 
  var labelSellFrom = $("<label width='25%' display='inline-block'>From:&nbsp;</label> ").appendTo(tdSellFromDate);
  var dateSellFromPickerId = buildDatePickerId("dateSellFrom", productId, rowNumbers);
  $("#product-pricing-rule-template .dateFrom-picker-template")
    .clone()
    .attr("id", dateSellFromPickerId).css({"display": "inline-block", "width": "75%"})
    .appendTo(tdSellFromDate);
  initDatePicker($("#" + dateSellFromPickerId));
  if (sellFromDate != null)
    $("#" + dateSellFromPickerId).datepicker('setDate', new Date(sellFromDate));
  var labelSellTo = $("<label width='25%' display='inline-block'>To:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label> ").appendTo(tdSellFromDate);

  var dateSellToPickerId = buildDatePickerId("dateSellTo", productId, rowNumbers);
  $("#product-pricing-rule-template .dateTo-picker-template")
    .clone()
    .attr("id", dateSellToPickerId).css({"display": "inline-block", "width": "75%"})
    .appendTo(tdSellFromDate)
  initDatePicker($("#" + dateSellToPickerId));
  if (sellDateTo != null)
    $("#" + dateSellToPickerId).datepicker('setDate', new Date(sellDateTo));
  
  $("#product-pricing-rule-template .priceTemplate").clone().appendTo(tdPrice).val(price);
  $("#product-pricing-rule-template .facePriceTemplate").clone().appendTo(tdPrice).val(facePrice);
  $("#product-pricing-rule-template .organization").clone().appendTo(tdOrganization).val(organization);
  $("#product-pricing-rule-template .validityDaysTemplate").clone().appendTo(tdValidityDays).val(validityDays);
}

function removeRules() {
  if ($("#product-pricing-grid tbody .cblist:checked").length == 0)
    showMessage(itl("@Common.NoElementWasSelected"));
  else
    $("#product-pricing-grid tbody .cblist:checked").closest("tr").remove();
}

function duplicateRule() {
  var selectedItems = $("#product-pricing-grid tbody .cblist:checked").length;
  if (selectedItems == 0)
    showMessage(itl("@Common.NoElementWasSelected"));
  else if (selectedItems > 1)
    showMessage("You can duplicate one rule at a time");
  else {
    var clone = $("#product-pricing-grid tbody .cblist:checked").closest("tr").clone();
    var productId = clone.attr("data-ProductId");
    var rowNumbers = $("#product-pricing-grid tbody#pricing-rule-body tr").length;

    var dateFromId = buildDatePickerId("dateFrom", productId, rowNumbers);
    var dateToId = buildDatePickerId("dateTo", productId, rowNumbers);
    var dateSellFromId = buildDatePickerId("dateSellFrom", productId, rowNumbers);
    var dateSellToId = buildDatePickerId("dateSellTo", productId, rowNumbers);

    clone.find(".dateFrom-picker-template").removeClass("hasDatepicker").removeAttr('id');
    clone.find(".dateTo-picker-template").removeClass("hasDatepicker").removeAttr('id');
    
    clone.find(".dateFrom-picker-template").attr("id", dateFromId);
    clone.find(".dateTo-picker-template").attr("id", dateToId);
    
    clone.find(".dateSellFrom-picker-template").removeClass("hasDatepicker").removeAttr('id');
    clone.find(".dateSellTo-picker-template").removeClass("hasDatepicker").removeAttr('id');
    
    clone.find(".dateSellFrom-picker-template").attr("id", dateSellFromId);
    clone.find(".dateSellTo-picker-template").attr("id", dateSellToId);

    
    //Append coned rule to the grid
    clone.appendTo("#pricing-rule-body");
    
    initDatePicker($("#" + dateFromId));
    initDatePicker($("#" + dateToId));
    initDatePicker($("#" + dateSellFromId));
    initDatePicker($("#" + dateSellToId));

    $("#product-pricing-grid tbody .cblist:checked").setChecked(false)
  }
}

function getProductPricingRules() {
	var prodPricingRules = [];
  var rules = $("#product-pricing-grid tbody#pricing-rule-body tr");
  for (var i=0; i<rules.length; i++) {
    var rule = $(rules[i]);
    
    var productId = rule.attr("data-ProductId");
    var productName = rule.attr("data-ProductName");
    
    var dateFromId = buildDatePickerId("dateFrom", productId, i)
    var fromDate = rule.find("#" + dateFromId).getXMLDate();
    
    var dateToId = buildDatePickerId("dateTo", productId, i)
    var toDate = rule.find("#" + dateToId).getXMLDate();
    
    var dateSellFromId = buildDatePickerId("dateSellFrom", productId, i)
    var fromSellDate = rule.find("#" + dateSellFromId).getXMLDate();
    
    var dateSellToId = buildDatePickerId("dateSellTo", productId, i)
    var toSellDate = rule.find("#" + dateSellToId).getXMLDate();

    
    var price = strToFloatDef(rule.find(".priceTemplate").val(), null);
    var facePrice = strToFloatDef(rule.find(".facePriceTemplate").val(), null);
    var organization = rule.find(".organization").val();
    var validityDays = strToIntDef(rule.find(".validityDaysTemplate").val(), null);
    
    validateFields(fromDate, toDate, fromSellDate, toSellDate, price, facePrice, organization, validityDays);
    
    prodPricingRules.push({
      "ProductId": productId,
      "ProductName": productName,
      "SearchDateFrom": fromDate,
      "SearchDateTo": toDate,
      "SellDateFrom": fromSellDate,
      "SellDateTo": toSellDate,
      "Price": price,
      "FacePrice": facePrice,
      "OrganizationCode": organization,
      "ValidityDays": validityDays,
      "PriceQuoteToken": ""
    });
  }
  return prodPricingRules;
}

function validateFields(fromDate, toDate, fromSellDate, toSellDate, price, facePrice, organization, validityDays) {
  if (fromDate == null || fromDate == "")
    throw(itl("@Common.MandatoryFieldMissingError", "From date"));
  
  if (toDate != null && toDate != "") {
    if (fromDate > toDate)
      throw(itl("@Product.DateFromGreaterThanDateTo", getDisplayDate(fromDate), getDisplayDate(toDate)));
  }
    
  if (price == null)
    throw(itl("@Common.InvalidValueFieldError", "Price"));
  
  if (facePrice == null)
    throw(itl("@Common.InvalidValueFieldError", "Face price"));
  if (validityDays == null)
    throw(itl("@Common.InvalidValueFieldError", "Validity days"));
  else if (validityDays <= 0)
    throw(itl("@Common.ValueFieldGreterThanError", "Validity days", "0"));
}

function buildDatePickerId(prefix, productId, rowNumbers) {
  return prefix + "-" + productId + "-" + eval(rowNumbers+1);
}

function getDisplayDate(date) {
  if (date != null && date != "")
    return formatDate(date, '<%=dateFormat%>')
}

function getPluginSettings() {
  return {
	  SimulateDynamicGateCetgories: $("#settings\\.SimulateDynamicGateCetgories").isChecked(),
	  SimulateMetadata: $("#settings\\.SimulateMetadata").isChecked(),
	  SimulateOfflineTransaction: $("#settings\\.SimulateOfflineTransaction").isChecked(),
	  CommissionAmount: $("#settings\\.CommissionChecked").isChecked() ? strToFloatDef($("#settings\\.CommissionAmount").val(), 0) : null,
		DownPaymentAmount: $("#settings\\.DownPaymentChecked").isChecked() ? strToFloatDef($("#settings\\.DownPaymentAmount").val(), 0) : null,
    ProductPricingRules: getProductPricingRules()
  };
}

</script>
