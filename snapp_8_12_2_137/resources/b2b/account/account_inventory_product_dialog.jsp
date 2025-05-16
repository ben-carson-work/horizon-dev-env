<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.search.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%

BOSessionBean sessionBean = pageBase.getSession();

DOAccountInventoryBalanceSearchRequest reqDO = new DOAccountInventoryBalanceSearchRequest();

reqDO.SearchRecapRequest.PagePos.setInt(pageBase.getQP());
reqDO.SearchRecapRequest.RecordPerPage.setInt(QueryDef.recordPerPageDefault);

//Filter
reqDO.AccountId.setString(sessionBean.getOrgAccountId());
reqDO.ExcludeZeroQty.setBoolean(true);

DOAccountInventoryBalanceSearchAnswer ansDO = pageBase.getBL(BLBO_AccountInventory.class).searchAccountInventoryBalance(reqDO);
%>

<v:dialog id="product_inventory_dialog" title="@Common.InventoryGetFrom" width="1024" height="768" autofocus="false">

<style>
  table#handover-list-grid {
    width: 100%;
    border: 0;
    margin: 0;
    border: 0;
  }
  
  table#handover-list-grid td {
    font-size: 1.3em;
    padding: 8px;
  }
  
  table#handover-list-grid .handover-total-row td {
    border-top: 2px solid rgba(0,0,0,0.2);
    font-size: 1.5em;
    font-weight: bold;
  }
</style>

  <table id="handover-list-grid">
  <% for (DOAccountInventoryBalanceRef record : ansDO.AccountInventoryBalanceList) { %>
    <% String performanceId = record.PerformanceIDs.isEmpty()? "" : record.PerformanceIDs.getArray()[0];%>
    <% String prodDesc = record.ProductName.getHtmlString();%>
    <% if (!record.OptionDesc.isNull() && !record.OptionDesc.getString().isEmpty())
        prodDesc += " - " + record.OptionDesc.getString(); 
    %>
    <tr class="handover-row" 
        data-productid="<%=record.ProductId.getHtmlString()%>" 
        data-optionids="<%=record.OptionIDs.getHtmlString()%>" 
        data-performanceid="<%=performanceId%>" 
        data-invqty="<%=record.Quantity.getInt()%>" 
        data-unitamount="<%=record.UnitAmount.getFloat()%>" 
        data-prodqtymin="<%=record.ProductQuantityMin.getInt()%>"
        data-prodqtymax="<%=JvString.coalesce(record.ProductQuantityMax.getInteger(), Integer.MAX_VALUE)%>"
        data-prodqtystep="<%=record.ProductQuantityStep.getInt()%>">
      <td width="40%" nowrap>
        <%=prodDesc%>
        <% if (!record.PerformanceDesc.isNull() && !record.PerformanceDesc.getString().isEmpty()) { %>
          <br/><%=record.PerformanceDesc.getHtmlString()%>
        <% } %>
      </td>
      <td width="60%" nowrap align="right"><%=record.Quantity.getHtmlString()%> x <%=pageBase.formatCurrHtml(record.UnitAmount.getMoney())%></td>
      <td nowrap>
        <div class="v-button btn-min hl-green">
          <i class="fa fa-minus"></i>
        </div>
      </td>
      <td width="100px" nowrap align="center" class="handover-quantity">0</td>
      <td nowrap>
        <div class="v-button btn-pls hl-green">
          <i class="fa fa-plus"></i>
        </div>
      </td>
    </tr>  
  <% } %>
    <tr class="handover-total-row">
      <td class="handover-total-quantity" colspan="2" align="right">0</td>
      <td class="handover-total-amount" colspan="3" align="right">$0</td>
    </tr>
  </table>
  
  <div class="toolbar-block">
    <div id="btn-confirm" class="v-button hl-green"><v:itl key="@Common.Confirm"/></div>
    <div id="btn-stepback" class="v-button hl-green"><v:itl key="@Common.Back"/></div>
  </div>  

<script>
$(document).ready(function() {
  var dlg = $("#product_inventory_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    dlg.find("#btn-confirm").click(doHandover);
    dlg.find("#btn-stepback").click(doCloseDialog);
    
    $(".handover-quantity").click(editQuantity);
    $(".btn-min").click(recalculateItems);
    $(".btn-pls").click(recalculateItems);
  });
  
  function recalculateItems() {
    var $btn = $(this);
    var $tr = $(this).closest("tr");
    var $tdSelected = $tr.find(".handover-quantity");
    var maxRowQty = Math.min(parseInt($tr.attr("data-invqty")), parseInt($tr.attr("data-prodqtymax")));
    var minRowQty = Math.max(0, parseInt($tr.attr("data-prodqtymin")));
    var multiplier = $btn.hasClass("btn-pls") ? +1 : -1;
    var delta = parseInt($tr.attr("data-prodqtystep")) * multiplier;

    var rowQty = parseInt($tdSelected.text());
    if ((rowQty <= minRowQty) && (multiplier < 0))
      rowQty = 0;
    else {
      rowQty += delta;
      rowQty = Math.max(rowQty, minRowQty);
      rowQty = Math.min(rowQty, maxRowQty);
    }
      
    $tdSelected.text(rowQty);
    recalculateTotals();
  };
  
  function recalculateTotals() {
    var totAmount = 0;
    var totQty = 0;
    $trs = $(".handover-row");
    for (var i=0; i<$trs.length; i++) {
      var $tr = $($trs[i]);
      var unitAmount = $tr.attr("data-unitamount");
      var selQty = parseInt($tr.find(".handover-quantity").html());
      
      totQty = totQty + selQty;
      totAmount = totAmount + (selQty * unitAmount);
    }
    $(".handover-total-quantity").html(totQty);
    $(".handover-total-amount").html(formatCurr(totAmount));
  }
  
  function editQuantity() {
    var $tdSelected = $(this);
    var $trSelected = $tdSelected.closest("tr");
    var maxRowQty = parseInt($trSelected.attr("data-invqty"));
    
    var dlg = $("<div/>");
    var lbl = $("<span/>").appendTo(dlg);
    var txt = $("<input type='number' value='0' min='0' max='" + maxRowQty + "'/>").appendTo(dlg);
    lbl.text(itl("@Common.Quantity"));
      
    function btnQuantityEditOk() {
      var qty = parseInt(txt.val());
      qty = Math.max(0, Math.min(maxRowQty, qty));
      if (!isNaN(qty)) {
        $tdSelected.html(qty);
        recalculateTotals();
        dlg.dialog("close");            
      }
    }
    
    txt.keyup(function(event) {
      if (event.keyCode == KEY_ENTER)
        btnQuantityEditOk();
    })
    
    dlg.dialog({
      modal: true,
      title: itl("@Common.EditQuantity"),
      close: function() {
        dlg.remove();
      },
      buttons: [
        {
          text: itl("@Common.Ok"),
          click: btnQuantityEditOk
        },
        {
          text: itl("@Common.Cancel"),
          click: doCloseDialog
        }
      ] 
    });
  }
  
  function getItemList() {
    var list = [];
    
    $trs = $(".handover-row");
    for (var i=0; i<$trs.length; i++) {
      var $tr = $($trs[i]);
      var qty = parseInt($tr.find(".handover-quantity").html());
      if (qty > 0) {
        list.push({
          Product: {
            ProductId: $tr.attr("data-productid"),  
          },
          OptionIDs: $tr.attr("data-optionids"),
          PerformanceIDs: $tr.attr("data-performanceId"),
          QuantityDelta: qty,
          QuantityUnit: 1,
          QuantityMax: $tr.attr("data-invqty"),
          Price: $tr.attr("data-unitamount")
        });
      }
    }
    
    return list;
  }
  
  function noItemSelected() {
    $trs = $(".handover-row");
    for (var i=0; i<$trs.length; i++) {
      var $tr = $($trs[i]);
      var qty = parseInt($tr.find(".handover-quantity").html());
      if (qty > 0)
        return false;
    }
    return true;
  }
  
  function doHandover() {
    if (noItemSelected()) 
      showMessage(itl("@Voucher.VoucherItemEmpty"));
    else {
      showWaitGlass();
      var reqDO = {  
        Command: "PrepareHandoverTransaction",
        PrepareHandoverTransaction: {
          Account: {
            AccountId: <%=JvString.jsString(sessionBean.getOrgAccountId())%>,
            AccountCode: <%=JvString.jsString(sessionBean.getOrgAccountCode())%>,
            DisplayName: <%=JvString.jsString(sessionBean.getOrgAccountName())%>,
            AccountStatus: <%=LkSNAccountStatus.Active.getCode()%>
          },
          ItemList: getItemList()
        }
      };
  
      if (reqDO.PrepareHandoverTransaction.ItemList.length == 0)
        hideWaitGlass();
      else {
        vgsService("ShopCart", reqDO, false, function(ansDO) {
          shopCart = ansDO.Answer.ShopCart;
          applicablePromoRules = ansDO.Answer.ApplicablePromoRuleList;
          renderCart(shopCart);
          dlg.dialog("close");
          $("#btn-checkout").click();
          hideWaitGlass();
        });
      }
    }
  }
  
});
</script>

</v:dialog>



