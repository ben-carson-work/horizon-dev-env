<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.document.*"%>
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
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
String saleId = pageBase.getId();
DOShopCart shopCart = new DOShopCart();
pageBase.getBL(BLBO_ShopCart.class).fillShopCart(shopCart, saleId, true, LkSNTransactionReason.SaleVoid_RefundableOnly_UnusedOnly, true);
%>

<v:dialog id="salevoid_dialog" title="@Lookup.TransactionType.SaleVoid" width="900" height="700" resizable="false" autofocus="false">

<v:widget id="salevoid_recap" caption="@Common.Recap">
  <v:widget-block>
    <v:form-field caption="@Sale.PNR"><%=shopCart.Reservation.SaleCode.getHtmlString()%></v:form-field>
    <v:form-field caption="@Ticket.Tickets"><%=pageBase.formatCurrHtml((-shopCart.TotalAmount.getMoney()) - shopCart.Reservation.FeesAmount.getMoney())%></v:form-field>
    <v:form-field caption="@Common.Fees"><%=pageBase.formatCurrHtml(shopCart.Reservation.FeesAmount)%></v:form-field>
    <v:form-field caption="@Common.Total"><%=pageBase.formatCurrHtml(shopCart.TotalAmount)%></v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="@Common.Settled"><%=pageBase.formatCurrHtml(shopCart.Reservation.SettledAmount)%></v:form-field>
    <v:form-field caption="@Reservation.AlreadyRefunded"><%=pageBase.formatCurrHtml(shopCart.Reservation.VoidedTicketAmount)%></v:form-field>
    <v:form-field caption="@Reservation.NotRefundable"><%=pageBase.formatCurrHtml(shopCart.Reservation.UsedAmount.getMoney() + shopCart.Reservation.ActiveNotRefTicketAmount.getMoney())%></v:form-field>
  </v:widget-block>
  <v:widget-block>
    <%
      if ((shopCart.Reservation.FeesAmount.getMoney() > 0) && (shopCart.Reservation.FeesAmount.getMoney() <= shopCart.Reservation.SettledAmount.getMoney())) {
    %>
      <v:form-field><label class="checkbox-label"><input id="salevoid-include-fees" type="checkbox"/> <v:itl key="@Reservation.IncludeFees"/></label></v:form-field>
    <%
      }
    %>
    <v:form-field caption="@Reservation.MaxRefundableAmount"><span id="salevoid-total"></span></v:form-field>
  </v:widget-block>
</v:widget>

<v:widget id="salevoid-payment-widget" caption="@Payment.PaymentMethod">
  <v:widget-block>
    <%
      boolean first = true;
    %>
    <%
      for (DOPaymentMethodRef payMethod : pageBase.getBL(BLBO_PayMethod.class).getRightsPaymentMethods(LkSNTransactionType.SaleVoid)) {
    %>
      <label class="checkbox-label"><input type="radio" name="payment-method" <%=first?"checked":""%> value="<%=payMethod.PaymentMethodId.getHtmlString()%>" data-PaymentType="<%=payMethod.PaymentType.getInt()%>"/> <%=payMethod.PaymentMethodName.getHtmlString()%></label><br/>
      <%
        first = false;
      %>  
    <%
        }
      %>
  </v:widget-block>
</v:widget>


<style>
#salevoid_dialog {
  font-size: 1.3em;
}

#salevoid_recap .form-field-caption {
  width: 50%;
}

#salevoid_recap .form-field-value {
  margin-left: 50%;
  text-align: right;
  font-weight: bold;
}
</style>

  
<script>

var maxRefundableAmount = 0;

$(document).ready(function() {
  var dlg = $("#salevoid_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        "text": <v:itl key="@Common.Cancel" encode="JS"/>,
        "class": "hl-green",
         "click":  doCloseDialog
      },                     
      {
        "text": <v:itl key="@Common.Confirm" encode="JS"/>,
        "class": "hl-red",
        "click": doInitSaleVoid,
        "id": "btn-salevoid-void"
      }
    ];
    params.open = recalcMaxRefundableAmount;
  });
});

function recalcMaxRefundableAmount() {
  maxRefundableAmount = <%=FtCurrency.decodeMoney(shopCart.Reservation.SettledAmount.getMoney() - shopCart.Reservation.UsedAmount.getMoney() - shopCart.Reservation.ActiveNotRefTicketAmount.getMoney() - shopCart.Reservation.VoidedTicketAmount.getMoney())%>;
  var feesAmount = <%=shopCart.Reservation.FeesAmount.getFloat()%>;
  if (!$("#salevoid-include-fees").isChecked())
    maxRefundableAmount -= feesAmount;
  maxRefundableAmount = Math.max(maxRefundableAmount, 0);
  $("#salevoid-total").html(formatCurr(maxRefundableAmount));
  
  var paymentMethodId = $("[name='payment-method']:checked").val();
  $("#btn-salevoid-void").setClass("disabled", ((maxRefundableAmount != 0) && (!paymentMethodId)));
  $("#salevoid-payment-widget").setClass("hidden", (maxRefundableAmount == 0));
}

$("#salevoid-include-fees").click(recalcMaxRefundableAmount);

function doInitSaleVoid() {
  if (!$("#btn-salevoid-void").is(".disabled")) {
    var paymentMethodId = $("[name='payment-method']:checked").val();
  
    var reqDO = {
      SaleId: <%=JvString.jsString(pageBase.getId())%>,
      TransactionType: <%=LkSNTransactionType.SaleVoid.getCode()%>,
      SaleVoidIncludeFees: $("#salevoid-include-fees").isChecked(),
      PaymentList: []
    };
    
    if (maxRefundableAmount != 0)
      reqDO.PaymentList.push({
        PaymentMethodId: paymentMethodId,
        PaymentAmount: -maxRefundableAmount
      })
    
    $("#salevoid_dialog").dialog("close");
    doPostTransaction(reqDO, showTransactionRecapDialog);
  }
}

</script>
  
</v:dialog>