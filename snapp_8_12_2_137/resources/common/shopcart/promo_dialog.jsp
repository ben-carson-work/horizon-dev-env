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

<v:dialog id="promo_dialog" title="@Common.Promo" icon="promorule.png" width="900" height="700" resizable="false">

<div id="app-promo-list"></div>

<div id="promo-item-template" class="v-hidden">
  <table style="width:100%; border-spacing:10px;">
    <tr>
      <td width="70%" class="promo-item-name"></td>
      <td width="30%" align="right" class="promo-item-saving"></td>
      <td align="right" rowspan="2"><div class="btn-promo-apply v-button hl-green"><v:itl key="@Common.Apply"/></div></td>
    </tr>
    <tr>
      <td class="promo-item-combinable"></td>
      <td align="right" class="promo-item-quantity"><v:itl key="@Common.Quantity"/>: <span class="value"></span></td>
    </tr>
  </table>
</div>

<div class="toolbar-block">
  <% if (pageBase.isParameter("step-to-checkout", "true")) { %> 
    <div id="btn-stepnext" class="v-button hl-green"><v:itl key="@Common.Next"/></div>
    <div id="btn-stepback" class="v-button hl-green"><v:itl key="@Common.Back"/></div>
  <% } else { %>
    <div id="btn-close" class="v-button hl-red"><v:itl key="@Common.Close"/></div>
  <% } %>
</div>


<style>
  #promo_dialog.ui-dialog-content {
    padding: 0;
  }

  .promo-item {
    background: white;
    border-bottom: 1px var(--border-color) solid;
  }
  
  .promo-item-name,
  .promo-item-combinable,
  .promo-item-saving,
  .promo-item-quantity {
    font-size: 1.3em;
  }

  .promo-item-combinable,
  .promo-item-quantity {
    color: rgba(0,0,0,0.5);
  }
  
</style>


<script>


var dlg = $("#promo_dialog");
  
$(document).ready(function() {
  dlg.find("#btn-stepnext").click(function() {
    dlg.dialog("close");
    stepCallBack(Step_Promo, StepDir_Next);
  });
  dlg.find("#btn-stepback").click(function() {
    dlg.dialog("close");
    stepCallBack(Step_Promo, StepDir_Back);
  });
  dlg.find("#btn-close").click(doCloseDialog);
      
  renderApplicablePromos();
});


function renderApplicablePromos() {
  var combinableTrue = "<v:itl key="@Product.PromoCombinable" encode="UTF-8"/>"; 
  var combinableFalse = "<v:itl key="@Product.PromoNotCombinable" encode="UTF-8"/>";
  
  $("#app-promo-list").empty();
  
  if (applicablePromoRules) {
    var list = applicablePromoRules;
    for (var i=0; i<list.length; i++) {
      if (list[i].PromoSelectionType == <%=LkSNPromoSelectionType.Optional.getCode()%>) {
        var divItem = $("<div class='promo-item'/>").appendTo("#app-promo-list");
        divItem.attr("data-ProductId", list[i].ProductId);
        divItem.attr("data-Quantity", list[i].Quantity);
        divItem.html($("#promo-item-template").html());
        divItem.find(".promo-item-name").text(list[i].ProductName);
        divItem.find(".promo-item-combinable").text((list[i].Combinable) ? combinableTrue : combinableFalse);
        divItem.find(".promo-item-saving").html(formatCurr(list[i].Saving));
        divItem.find(".promo-item-quantity .value").text(list[i].Quantity);
        divItem.find(".btn-promo-apply").click(promoApplyClick);
      }
    }
  }
  else {
    dlg.dialog("close");
    <% if (pageBase.isParameter("step-to-checkout", "true")) { %>
      stepCallBack(Step_Promo, StepDir_Next);
    <% } %>
  }
}

function promoApplyClick() {
  var divItem = $(this).closest(".promo-item");
  var reqDO = {
    Command: "AddPromoToCart",
    AddPromoToCart: {
      ProductId: divItem.attr("data-ProductId"),
      Quantity: parseInt(divItem.attr("data-Quantity"))
    }
  };
  
  doCmdShopCart(reqDO, renderApplicablePromos);
}


</script>

</v:dialog>