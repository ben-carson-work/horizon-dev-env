<%@page import="com.vgs.snapp.dataobject.DOProduct"%>
<%@page import="java.util.List"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_ProductRefund.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-81" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
boolean canEdit = !pageBase.isParameter("ReadOnly", "true");
DOProduct product = pageBase.getBL(BLBO_Product.class).loadProduct(pageBase.getId());

QueryDef qdef = new QueryDef(QryBO_ProductRefund.class);
// Select
qdef.addSelect(Sel.EventId);
qdef.addSelect(Sel.EventName);
qdef.addSelect(Sel.EntryAmountEdit);
qdef.addSelect(Sel.GuestEntryAmountEdit);
// Filter
qdef.addFilter(Fil.ProductId, pageBase.getId());
// Sort
qdef.addSort(Sel.EventName);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
boolean rulesEmpty = ds.isEmpty();

request.setAttribute("product", product);
%>

<v:dialog id="product-refund-dialog" width="800" height="600" title="@Product.RefundPolicy">
  <style>
    .fees-block-value {
      display: flex;
    }
    #product\.TicketVoidFeeProductId {margin-right:10px}
  </style>

  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:db-checkbox field="product.Refundable" value="true" caption="@Product.Refundable"/>
    </v:widget-block>
  </v:widget>
  <v:widget id="widget-options" caption="@Common.Options">
    <v:widget-block id="refund-advance-days-block">
      <v:form-field caption="@Product.TicketVoidAdvanceDays" hint="@Product.TicketVoidAdvanceDaysHint">
        <v:input-text field="product.TicketVoidAdvanceDays" placeholder="@Common.Always" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block id="partial-refund-block">
      <v:form-field caption="@Product.PartiallyRefundable" checkBoxField="product.PartiallyRefundable">
        <div id="product-refund-grid">
          <v:grid>
            <thead>
              <tr>
                <td><v:grid-checkbox header="true"/></td>
                <td width="50%"><v:itl key="@Event.Event"/></td>
                <td width="25%"><v:itl key="@Product.RefundEntry"/></td>
                <td width="25%"><v:itl key="@Product.RefundGuestEntry"/></td>
              </tr>
            </thead>
            <tbody id="refund-event-body">
            </tbody>
            <tbody>
              <tr>
                <td colspan="100%">
                  <v:button caption="@Common.Add" fa="plus" href="javascript:showEventPickupDialog()" enabled="<%=canEdit%>"/>
                  <v:button caption="@Common.Remove" fa="minus" href="javascript:removeRefundEvents()" enabled="<%=canEdit%>"/>
                </td>
              </tr>
            </tbody>
          </v:grid>
        </div>
      </v:form-field>
    </v:widget-block>
    <v:widget-block id="fees-block" >
      <v:form-field caption="@Common.Fees" mandatory="false" hint="@Product.TicketVoidAdvanceFeeDaysHint" checkBoxField="feesCB">
        <div class="fees-block-value">
          <% JvDataSet dsFee = pageBase.getBL(BLBO_Product.class).getFeeLookupDS(pageBase.getId()); %>
          <v:combobox field="product.TicketVoidFeeProductId" lookupDataSet="<%=dsFee%>" idFieldName="ProductId" captionFieldName="ProductName" enabled="<%=canEdit%>" allowNull="false"/>
          <span>post&nbsp;&nbsp;</span>
          <v:input-text field="product.TicketVoidAdvanceFeeDays" placeholder="@Common.Always" enabled="<%=canEdit%>"/>
        </div>
      </v:form-field>
    </v:widget-block>
  </v:widget>
<script>

$(document).ready(function() {
  refreshVisibility();

  <% if (!product.TicketVoidFeeProductId.isNull()) { %>
    $("input[name='feesCB']").click();
  <% } %>
});

function refreshVisibility() {
  var refundable = $("[name='product\\.Refundable']").isChecked();
  var partiallyRefundable = $("[name='product\\.PartiallyRefundable']").isChecked();
  $("#widget-options").setClass("v-hidden", !refundable);
  $("#partial-refund-block").setClass("v-hidden", !refundable);
  $("#product-refund-grid").setClass("v-hidden", !partiallyRefundable);
}

var dlg = $("#product-refund-dialog");
dlg.on("snapp-dialog", function(event, params) {
  params.buttons = {
  		Save : {
  			text: <v:itl key="@Common.Save" encode="JS"/>,
  			click: doSaveRefunds,
  			disabled: <%=!canEdit%>
  		},
  		Cancel : {
  			text: <v:itl key="@Common.Cancel" encode="JS"/>,
  			click: doCloseDialog
  		}
  };
});

function encodeAmount(type, value) {
  value = parseFloat(value);
  var result = "";
  if (!isNaN(value)) {
    result = value;
    if (type == <%=LkSNPriceValueType.Percentage.getCode()%>)
      result += "%";
  }
  return result;
}

function decodeAmount(text) {
  var result = {
    type: <%=LkSNPriceValueType.Absolute.getCode()%>,
    value: null
  };
  
  if (text) {
    if (text.indexOf("%") >= 0) 
      result.type = <%=LkSNPriceValueType.Percentage.getCode()%>;
    result.value = parseFloat(text.replace("%", "").replace(",", "."));
    if (isNaN(result.value))
      result.value = 0;
  }
  
  return result;
}

function addRefundEvent(eventId, eventName, entryAmountType, entryAmountValue, guestEntryAmountType, guestEntryAmountValue) {
  var tr = $("<tr data-EventId='" + ((eventId) ? eventId : "") + "'/>").appendTo("#refund-event-body");
  var tdCB = $("<td/>").appendTo(tr);
  if (eventId)
    tdCB.append("<input type='checkbox' class='cblist'/>");
  
  var tdEvent = $("<td/>").appendTo(tr);
  if (eventId) 
    $("<a href='<v:config key="site_url"/>/admin?page=event&id=" + eventId + "'/>").appendTo(tdEvent).text(eventName);
  else
    tdEvent.text(<v:itl key="@Common.Default" encode="JS"/>);
  
  $("<input type='text' class='entry-amount form-control'/>").appendTo($("<td/>").appendTo(tr)).val(encodeAmount(entryAmountType, entryAmountValue));
  $("<input type='text' class='guest-entry-amount form-control'/>").appendTo($("<td/>").appendTo(tr)).val(encodeAmount(guestEntryAmountType, guestEntryAmountValue));
  
  var placeholder = (eventId) ? <v:itl key="@Common.Inherit" encode="JS"/> : "0";
  tr.find("[type='text']").attr("placeholder", placeholder);
}

function showEventPickupDialog() {
  showLookupDialog({
    EntityType: <%=LkSNEntityType.Event.getCode()%>,
    onPickup: function(item) {
      if ($("#produpgrade-grid tr[data-ProductId='" + item.ItemId + "']").length > 0) 
        showMessage(<v:itl key="@Product.ProductAlreadyExistsError" encode="JS"/>);
      else if (item.ItemId == "<%=pageBase.getId()%>")
        showMessage(<v:itl key="@Product.ProductSelfReferenceError" encode="JS"/>); 
      else 
        addRefundEvent(item.ItemId, item.ItemName);
    }
  });
}

function removeRefundEvents() {
  $("#product-refund-dialog .cblist:checked").not(".header").closest("tr").remove();
}

 function doSaveRefunds() {
   var refundable = $("[name='product\\.Refundable']").isChecked();
   var fees = $("[name='feesCB']").isChecked();
   var reqDO = {
     Command: "SaveProduct",
     SaveProduct: {
       Product: {  
         ProductId: <%=JvString.jsString(pageBase.getId())%>,
         Refundable: refundable,
         PartiallyRefundable: $("[name='product\\.PartiallyRefundable']").isChecked(),
         TicketVoidAdvanceDays: refundable ? $("#product\\.TicketVoidAdvanceDays").val() : null,
         TicketVoidAdvanceFeeDays: (refundable && fees) ? $("#product\\.TicketVoidAdvanceFeeDays").val() : null,
         TicketVoidFeeProductId: (refundable && fees) ? $("#product\\.TicketVoidFeeProductId").val() : null,
         ProductRefundEventList: []
       }
     }
   };
   
   var trs = $("#refund-event-body tr");
   for (var i=0; i<trs.length; i++) {
     var entry = decodeAmount($(trs[i]).find(".entry-amount").val());
     var gstentry = decodeAmount($(trs[i]).find(".guest-entry-amount").val());
     reqDO.SaveProduct.Product.ProductRefundEventList.push({
       EventId: $(trs[i]).attr("data-EventId"),
       EntryAmountType: entry.type,
       EntryAmountValue: entry.value,
       GuestEntryAmountType: gstentry.type,
       GuestEntryAmountValue: gstentry.value
     });
   }
   
   vgsService("Product", reqDO, false, function(ansDO) {
     $("#product-refund-dialog").dialog("close");
   });
 }

<% boolean defaultFound = pageBase.getBL(BLBO_Product.class).productRefundHasDefault(pageBase.getId());%>
<% if (!defaultFound) { %>
  addRefundEvent();
<% } %>

<% ds = pageBase.execQuery(qdef); %>
<v:ds-loop dataset="<%=ds%>">
<% if (ds.getField(Sel.EventId).isNull()) { %>
  defaultFound = true;
<% } %>
addRefundEvent(
    <%=JvString.jsString(ds.getField(Sel.EventId).getString())%>,
    <%=JvString.jsString(ds.getField(Sel.EventName).getString())%>,
    <%=ds.getField(Sel.EntryAmountType).getInt()%>,
    <%=ds.getField(Sel.EntryAmountValue).getString()%>,
    <%=ds.getField(Sel.GuestEntryAmountType).getInt()%>,
    <%=ds.getField(Sel.GuestEntryAmountValue).getString()%>
);
</v:ds-loop>

<% ds.dispose(); %>

$("[name='product.\\Refundable']").change(refreshVisibility);
$("[name='product.\\PartiallyRefundable']").change(refreshVisibility);

refreshVisibility();
</script>  

</v:dialog>