<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.JvDataSet"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>

<div id="settings-dialog">
	<div id="promorule-templates" class="hidden">
	  <div class="v-hidden">
	    <v:combobox clazz="promorule-select-template" lookupDataSet="<%=pageBase.getBL(BLBO_PromoRule.class).getPromoRuleDS()%>" idFieldName="ProductId" captionFieldName="ProductName" codeFieldName="ProductCode"/>
	  </div>
	</div>
	
	<v:widget caption="@Common.Settings">
	  <v:widget-block>
	    <v:form-field caption="Organization Tag">
	      <v:combobox field="settings.AccountTagId" lookupDataSet="<%=pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.Organization)%>" allowNull="true" idFieldName="TagId" captionFieldName="TagName"/>
	    </v:form-field>	  
	    <v:form-field caption="Product Tag">
	      <v:combobox field="settings.ProductTagId" lookupDataSet="<%=pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType)%>" allowNull="true" idFieldName="TagId" captionFieldName="TagName"/>
	    </v:form-field>
		</v:widget-block>
	</v:widget>
	<v:widget caption="Discount slots">
	  <v:widget-block>
	    <v:grid id="discount-slot-grid">
	      <thead>
	        <tr>
	          <td><v:grid-checkbox header="true"/></td>
	          <td width="50%"><v:itl key="Promotion code"/></td>
	          <td width="25%"><v:itl key="@Commission.QuantityFrom"/></td>
	          <td width="25%"><v:itl key="@Commission.QuantityTo"/></td>
	        </tr>
	      </thead>
	      <tbody id="discount-slot-body">
	      
	      </tbody>
	      <tbody>
	        <tr>
	          <td colspan="100%">
	            <% String href="javascript:addDetail(true)"; %>
	            <v:button caption="@Common.Add" fa="plus" href="<%=href%>"/>
	            <v:button caption="@Common.Remove" fa="minus" href="javascript:removeDetail()"/>
	          </td>
	        </tr>
	      </tbody>
	    </v:grid>
	  </v:widget-block>
	</v:widget>
</div>

<script>

function addDetail(promoCodeId, qtyFrom, qtyTo) {
  var trs = $("#discount-slot-body tr");
  var id = trs.length + 1;
  
  var tr = $("<tr class='grid-row'/>").appendTo("#discount-slot-body");
  var tdCB = $("<td/>").appendTo(tr);  
  var tdCombo = $("<td/>").appendTo(tr);
  var tdQtyFrom = $("<td/>").appendTo(tr);
  var tdQtyTo = $("<td/>").appendTo(tr);
  var tdPercentage = $("<td/>").appendTo(tr);
  
  tdCB.append("<input value='" + id + "' type='checkbox' class='cblist'>");
  var combo = $("#promorule-templates .promorule-select-template").clone().addClass("promorule-select").appendTo(tdCombo).val(promoCodeId);
  tdQtyFrom.append("<input type='text' class='form-control' name='qtyFrom'/>"); 
  tdQtyFrom.find("input").attr("placeholder", "0");
  tdQtyFrom.find("input").val(qtyFrom);
  
  tdQtyTo.append("<input type='text' class='form-control' name='qtyTo'/>"); 
  tdQtyTo.find("input").attr("placeholder", <v:itl key="@Common.Unlimited" encode="JS"/>);
  tdQtyTo.find("input").val(qtyTo);
}
  
function removeDetail() {
  $("#settings-dialog .cblist:checked").not(".header").closest("tr").remove();
}  

function getDiscountSlotList() {
	var list = [];
  var trs = $("#discount-slot-body tr");
  
  for (var i=0; i<trs.length; i++) {
	  var tr = $(trs[i]);
	  var percentage = convertPriceValue(tr.find("[name='percentage']").val());
	  list.push({
		  PromoCodeId: tr.find(".promorule-select option:selected").val(),
		  QuantityFrom: (tr.find("[name='qtyFrom']").val())? tr.find("[name='qtyFrom']").val() : 0,
			QuantityTo: tr.find("[name='qtyTo']").val() ? tr.find("[name='qtyTo']").val() : null
	  });
	}
	
	return list;
}

function getPluginSettings() {
  return {
	  AccountTagId: $("#settings\\.AccountTagId").val(),
	  ProductTagId: $("#settings\\.ProductTagId").val(),
	  DiscountSlotList: getDiscountSlotList()
  };
}

var settings;

$(document).ready(function() {
  settings = <%=settings.getJSONString()%>;
  if (settings) 
	  for (var i=0; i<settings.DiscountSlotList.length; i++) {
		  addDetail(settings.DiscountSlotList[i].PromoCodeId,
		      settings.DiscountSlotList[i].QuantityFrom, 
		      settings.DiscountSlotList[i].QuantityTo);   
		}   
});
</script>