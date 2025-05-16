<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.library.BLBO_DocTemplate"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:dialog id="voucher_issue_dialog" icon="voucher.png" title="@Lookup.TransactionType.VoucherIssue" autofocus="false" width="800" height="700">

<% 
String accountId = pageBase.getNullParameter("AccountId");
boolean outstanding = false;
long totalAvailable = 0;
if (accountId == null)
  throw new RuntimeException("Parameter AccountId must be specified");

QueryDef qdef = new QueryDef(QryBO_Account.class);
qdef.addSelect(QryBO_Account.Sel.FinanceOutstandingDebt);
qdef.addSelect(QryBO_Account.Sel.FinanceTotalAvailable);
qdef.addFilter(QryBO_Account.Fil.AccountId, accountId);
JvDataSet ds = pageBase.execQuery(qdef);
if (ds.isEmpty())
  throw new RuntimeException("Unable to find AccountId=" + accountId);

outstanding = ds.getField(QryBO_Account.Sel.FinanceOutstandingDebt).getBoolean();
totalAvailable = ds.getField(QryBO_Account.Sel.FinanceTotalAvailable).getMoney();
%>

<v:widget caption="@Common.Profile">
  <v:widget-block>
    <v:form-field caption="@Common.Quantity">
      <v:input-text type="text" field="voucher.Quantity"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="@Common.Name">
      <v:input-text field="voucher.VoucherName" placeholder="@Common.Name"/>
    </v:form-field>
    <v:form-field caption="@Common.Description">
      <v:input-text field="voucher.VoucherDescription" placeholder="@Common.Description"/>
    </v:form-field>
    <v:form-field caption="@Common.ValidFrom">
      <v:input-text type="datepicker" field="voucher.ValidFrom"/>
    </v:form-field>
    <v:form-field caption="@Common.ValidTo">
      <v:input-text type="datepicker" field="voucher.ValidTo"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="@Common.Template">
      <% JvDataSet dsVoucherTemplate = pageBase.getBL(BLBO_DocTemplate.class).getDocTemplateDS(LkSNDocTemplateType.Voucher); %>
      <v:combobox field="voucher.DocTemplateId" idFieldName="DocTemplateId" captionFieldName="DocTemplateName" lookupDataSet="<%=dsVoucherTemplate%>" allowNull="true"/>
    </v:form-field>
    <v:form-field>
      <label class="checkbox-label"><input type="radio" name="voucher.GeneratePDF" value="1" checked="checked"/> <v:itl key="@Account.Credit.VoucherGeneratePDF"/></label>
      &nbsp;
      <label class="checkbox-label"><input type="radio" name="voucher.GeneratePDF" value="2"/> <v:itl key="@Account.Credit.VoucherPrintAtPOS"/></label>
      &nbsp;
      <label class="checkbox-label"><input type="radio" name="voucher.GeneratePDF" value="3"/> <v:itl key="@Account.Credit.VoucherGenerateCsv"/></label>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:db-checkbox caption="@Lookup.PaymentType.Consignment" value="true" field="voucher.CommitPayment" checked="false" enabled="true"/>
    <div id="consignment-options" class="v-hidden">
      <v:db-checkbox caption="@Voucher.PartiallyRedeemable" value="true" field="voucher.PartiallyRedeemable" checked="true" enabled="true"/>
      <v:form-field caption="@Common.QuantityMax" hint="@Voucher.QuantityMaxHint">
        <v:input-text type="text" field="voucher.ProdQuantityMax" placeholder="@Common.Unlimited"/>
      </v:form-field>
      <v:form-field caption="@Common.AmountMax" hint="@Voucher.AmountMaxHint">
        <v:input-text type="text" field="voucher.ProdAmountMax" placeholder="@Common.Unlimited"/>
      </v:form-field>
    </div>
  </v:widget-block>
</v:widget>

<v:grid id="voucher-item-grid">
  <thead>
  <v:grid-title caption="@Common.Items"/>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
<!--       <td></td> -->
      <td width="40%"><v:itl key="@Product.ProductType"/></td>
      <td width="20%" id="item-min-qty" class="v-hidden"><v:itl key="@Common.QuantityMin"/></td>
      <td width="20%" id="item-max-qty" class="v-hidden"><v:itl key="@Common.QuantityMax"/></td>
      <td width="40%" id="item-qty"><v:itl key="@Common.Quantity"/></td>
      <td width="20%"><v:itl key="@Reservation.UnitAmount"/></td>
    </tr>
  </thead>
  <tbody id="voucher-item-body">
  </tbody>
  <tbody>
    <tr>
      <td colspan="100%">
        <v:button caption="@Common.Add" fa="plus" href="javascript:doAddVoucherItem()"/>
        <v:button caption="@Common.Remove" fa="minus" href="javascript:removeEntityTabs()"/>
      </td>
    </tr>
  </tbody>
</v:grid>

<script>
var dlg = $("#voucher_issue_dialog");
dlg.on("snapp-dialog", function(event, params) {
  params.buttons = [
    {
      text: itl("@Common.Generate"),
      click: doGenerate
    }, 
    {
      text: itl("@Common.Cancel"),
      click: doCloseDialog
    }                     
  ];
});

$(document).ready(function() {
  $("#voucher\\.CommitPayment").click(refreshItems);
  
  var dtFrom = $("#voucher\\.ValidFrom-picker").datepicker("setDate", new Date());
  var dtTo = $("#voucher\\.ValidTo-picker").datepicker("setDate", new Date());
  $("#voucher\\.Quantity").val("1");

  dtFrom.change(function() {
    var xmlFrom = dtFrom.getXMLDate();
    var xmlTo = dtTo.getXMLDate();
    if (xmlFrom > xmlTo)
      dtTo.datepicker("setDate", dtFrom.datepicker("getDate"));
  });

  dtTo.change(function() {
    var xmlFrom = dtFrom.getXMLDate();
    var xmlTo = dtTo.getXMLDate();
    if (xmlFrom > xmlTo)
      dtFrom.datepicker("setDate", dtTo.datepicker("getDate"));
  });
});

function doAddVoucherItem() {
  showLookupDialog({
    EntityType: <%=LkSNEntityType.ProductType.getCode()%>,
    onPickup: function(item) {
      var tr = $("<tr/>").appendTo("#voucher-item-body");
      var tdCB = $("<td/>").appendTo(tr);
//       var tdIcon = $("<td/>").appendTo(tr);
      var tdPrd = $("<td/>").appendTo(tr);
      var tdMin = $("<td id='item-min-qty'/>").appendTo(tr);
      var tdMax = $("<td id='item-max-qty'/>").appendTo(tr);
      var tdQty = $("<td id='item-qty'/>").appendTo(tr);
      var tdPrice = $("<td/>").appendTo(tr);
      
      checked = $("#voucher\\.CommitPayment").isChecked();
      
      tdCB.append("<input id='" + item.ItemId + "' type='checkbox' class='cblist'>");

      tdPrd.append(item.ItemName);
      
      tdMin.append("<input type='text' class='form-control' name='QuantityMin' value='1'/>");
      tdMax.append("<input type='text' class='form-control' name='QuantityMax' value='1'/>");
      tdQty.append("<input type='text' class='form-control' name='GenQuantity' value='1'/>");
      
      var txtPrice = $("<input type='text' class='form-control' name='UnitPrice'/>").appendTo(tdPrice);
      findProductPrice((item == null) ? null : item.ItemId, txtPrice);
      
      refreshItems();
    }
  });
}

function removeEntityTabs() {
  $("#voucher_issue_dialog .cblist:checked").not(".header").closest("tr").remove();
}

function refreshItems() {
  checked = $("#voucher\\.CommitPayment").isChecked();
  $("#consignment-options").setClass("v-hidden", !checked);
  $("#item-min-qty").setClass("v-hidden", !checked);
  $("#item-max-qty").setClass("v-hidden", !checked);
  $("#item-qty").setClass("v-hidden", checked);
  var items = $("#voucher-item-body tr");
  for (var i=0; i<items.length; i++) {
    $(items[i]).find("#item-min-qty").setClass("v-hidden", !checked);
    $(items[i]).find("#item-max-qty").setClass("v-hidden", !checked);
    $(items[i]).find("#item-qty").setClass("v-hidden", checked);
  }
}

function findProductPrice(productId, txt) {
  if (productId == null)
    txt.val("");
  else {
    var reqDO = {
      Command: "GetProductPrice",
      GetProductPrice: {
        ProductId: productId,
        AccountId: <%=JvString.jsString(accountId)%>
      }
    };
    
    vgsService("Product", reqDO, false, function(ansDO) {
      if ((ansDO.Answer) && (ansDO.Answer.GetProductPrice) && (ansDO.Answer.GetProductPrice.UnitPrice))
        txt.val(ansDO.Answer.GetProductPrice.UnitPrice);
      else
        txt.val("");
    });
  }
}

var in_generate = false;

function doGenerate() {
  var minimumProdMaxQty = 0;
  var minimumProdMaxAmount = 0;
  
  if (in_generate) 
    showMessage("Already posted");
  else {
    commitPaym = !$("#voucher\\.CommitPayment").isChecked();

    var qty = parseInt($("#voucher\\.Quantity").val());
    var qtyProdMax = parseInt($("#voucher\\.ProdQuantityMax").val());
    if (commitPaym || (qtyProdMax == 0))
      qtyProdMax = null;
    
    var amtProdMax = parseInt($("#voucher\\.ProdAmountMax").val());
    if (commitPaym || (amtProdMax == 0))
      amtProdMax = null;
    
    var partiallyRedeemable = !commitPaym && $("#voucher\\.PartiallyRedeemable").isChecked(); 
    
    var reqDO = {
      Command: "VoucherIssue",
      VoucherIssue: {
        AccountId: <%=JvString.jsString(accountId)%>,
        VoucherName: $("#voucher\\.VoucherName").val(),
        VoucherDescription: $("#voucher\\.VoucherDescription").val(),
        ValidDateFrom: $("#voucher\\.ValidFrom-picker").getXMLDate(),
        ValidDateTo: $("#voucher\\.ValidTo-picker").getXMLDate(),
        DocTemplateId: $("#voucher\\.DocTemplateId").val(),
        Quantity: isNaN(qty) ? 1 : qty,
        PartiallyRedeemable: partiallyRedeemable,
        CommitPayment: commitPaym,
        Active: true,
        ItemList: []
      }
    };
    
    var totalAmount = 0;
    var items = $("#voucher-item-body tr");
    for (var i=0; i<items.length; i++) {
      var qtyMin = parseInt($(items[i]).find("[name='QuantityMin']").val());
      var qtyMax = parseInt($(items[i]).find("[name='QuantityMax']").val());
      var qtyGen = parseInt($(items[i]).find("[name='GenQuantity']").val());
      if (!commitPaym) {
        qtyMin = isNaN(qtyMin) ? 1 : qtyMin;
        qtyMax = isNaN(qtyMax) ? 1 : qtyMax;
      }
      else {
        qtyMin = isNaN(qtyGen) ? 1 : qtyGen;
        qtyMax = isNaN(qtyGen) ? 1 : qtyGen;
//         qtyProdMax = qtyProdMax + qtyGen;
      }
      
      var price = parseFloat($(items[i]).find("[name='UnitPrice']").val());
      var item = {
        ProductId: $(items[i]).find("input").attr("id"),
        QuantityMin: qtyMin,
        QuantityMax: qtyMax,
        UnitPrice: isNaN(price) ? 0 : price
      };
      reqDO.VoucherIssue.ItemList.push(item);
      minimumProdMaxQty = minimumProdMaxQty + item.QuantityMin;
      minimumProdMaxAmount = minimumProdMaxAmount + (item.QuantityMin * item.UnitPrice);
      
      totalAmount += (item.UnitPrice * item.QuantityMin);
    }
    totalAmount = totalAmount * reqDO.VoucherIssue.Quantity;
    
    reqDO.VoucherIssue.QuantityMax = qtyProdMax;
    reqDO.VoucherIssue.AmountMax = amtProdMax;
    
    var doPost = true;
    if (reqDO.VoucherIssue.ItemList.length <= 0)
      showMessage(itl("@Voucher.VoucherItemEmpty"));
    else {
      if (reqDO.VoucherIssue.CommitPayment) {
        doPost = false;
        if (<%=outstanding%>)
          showMessage(itl("@Account.Credit.ErrorOutstandingDebts"));
        else if (totalAmount > <%=FtCurrency.decodeMoney(totalAvailable)%>) {
          var amount = <%=JvString.jsString(pageBase.formatCurr(totalAvailable))%>;
          showMessage(itl("@Account.Credit.ErrorDepositInsufficient", amount));
        }
        else
          doPost = true;
      }
      else {
        if (!isNaN(amtProdMax) && (amtProdMax > <%=FtCurrency.decodeMoney(totalAvailable)%>)) {
          doPost = false;
          var amount = <%=JvString.jsString(pageBase.formatCurr(totalAvailable))%>;
          showMessage(itl("@Account.Credit.ErrorDepositInsufficient", amount));
        }
        else
          doPost = true;
        if (doPost)
          doPost = checkMax(minimumProdMaxQty, minimumProdMaxAmount, qtyProdMax, amtProdMax);
      }
      
      var generatePDF = (dlg.find("[name='voucher\\.GeneratePDF']:checked").val());
      if (doPost && (generatePDF != 3/*CSV*/) && (getNull(reqDO.VoucherIssue.DocTemplateId) == null)) { 
        doPost = false;
        showMessage(itl("@Common.MandatoryFieldMissingError", itl("@DocTemplate.DocTemplate")));
      }
      
      if (doPost) {
        vgsService("Voucher", reqDO, false, function(ansDO) {
          var transactionId = ansDO.Answer.VoucherIssue.TransactionId;
          if (generatePDF == 1) {
            var urlo = BASE_URL + "/voucherpdf?TransactionId=" + transactionId + "&DocTemplateId=" + $("#voucher\\.DocTemplateId").val();
            window.open(urlo, '_blank');
          }
          else if (generatePDF == 3) { //Generate and download CSV file
            window.location = BASE_URL + "/admin?page=account&action=csv-download&TransactionId=" + transactionId;
            changeGridPage("#voucher-item-grid", "first");
          }
          else {
            var saleId = ansDO.Answer.VoucherIssue.SaleId;
            var saleCode = ansDO.Answer.VoucherIssue.SaleCode;
            showMessage(itl("@Common.SaveSuccessMsg"), function() {
              window.open("<%=pageBase.getContextURL()%>?page=sale&id=" + saleId, "_blank");
            });
          }
          dlg.dialog("close");
          triggerEntityChange(<%=LkSNEntityType.Voucher.getCode()%>);
        });
      }
    } 
  }
}

function checkMax(minQty, minAmount, qty, amt) {
  if (qty)
    if (minQty > qty) {
      showMessage(itl("@Voucher.VoucherMaxQuantityMinimumError"));
      return false;
    }

  if (amt)
    if (minAmount > amt) {
      showMessage(itl("@Voucher.VoucherMaxAmountMinimumError"));
      return false;
    }
  
  return true;
}  
  

</script>

</v:dialog>