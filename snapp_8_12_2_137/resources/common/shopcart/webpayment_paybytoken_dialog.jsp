<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.web.gencache.*"%>
<%@page import="com.vgs.snapp.web.plugin.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="java.util.*"%>
<%@page import="java.net.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
String accountId = pageBase.getNullParameter("AccountId");
String saleId = pageBase.getNullParameter("SaleId");
String amount = pageBase.getNullParameter("Amount");
String data = pageBase.getNullParameter("Data");
%>

<v:dialog id="webpayment_paybytoken_dialog" title="@Sale.PayByToken" width="800" height="700" autofocus="false">
  <style>
  #webpayment_dialog {
    padding:0;
  }
  </style>
  
  <div id="payment-method-container">
	  <v:widget caption="@Payment.PaymentMethods">
	    <v:widget-block>
        <% List<DOPaymentMethodRef> payMethods = pageBase.getBL(BLBO_PayMethod.class).getWebEnabledPaymentMethods(LkSNTransactionType.Normal, accountId, LkSNPaymentTokenType.PayByToken, LkSNPaymentTokenType.PayByTokenReadOnly); %>
        <% boolean first = true; %>
        <% for (DOPaymentMethodRef payMethod : payMethods) { %>
          <% if (payMethod.PaymentType.isLookup(LkSNPaymentType.WebPayment)) { %>
            <% TagAttributeBuilder attributes = TagAttributeBuilder.builder().put("data-paymenttype", payMethod.PaymentType.getInt()).put("data-supportiframe", payMethod.WebPayment.SupportIFrame.getBoolean()); %> 
            <div><v:radio name="payment-method" value="<%=payMethod.PaymentMethodId.getString()%>" caption="<%=payMethod.PaymentMethodName.getString()%>" checked="<%=first%>" attributes="<%=attributes%>"/></div>
            <% for (DOPaymentToken token : payMethod.WebPayment.TokenList) { %> 
              <% attributes.put("data-paymenttokenid", token.PaymentTokenId.getString()); %>
              <div><v:radio name="payment-method" value="<%=payMethod.PaymentMethodId.getString()%>" caption="<%=token.CommonDesc.getString()%>" attributes="<%=attributes%>"/></div>
            <% } %>
            <% first = false; %>
         <% } %>
			  <% } %>
		  </v:widget-block>
	  </v:widget>
  </div>

	<div class="toolbar-block">
	  <div id="btn-confirm" class="v-button hl-green"><v:itl key="@Common.Confirm"/></div>
	  <div id="btn-cancel" class="v-button hl-green"><v:itl key="@Common.Cancel"/></div>
	</div>  
  
  <script>
  $(document).ready(function() {
	  var $dlg = $("#webpayment_paybytoken_dialog");
	  $dlg.on("snapp-dialog", function(event, params) {
      $dlg.find("#btn-confirm").click(function() {
    	  $dlg.dialog("close");
    	  doConfirm();
      }),
      $dlg.find("#btn-cancel").click(function() {
        $dlg.dialog("close");
      });
    });
    
    function doConfirm() {
    	var data = JSON.parse(<%=JvString.jsString(data)%>);
    	
      var paymentRadio = $dlg.find("#payment-method-container input:checked");
      data.PaymentMethod = paymentRadio.val();
      data.PaymentTokenId = paymentRadio.attr("data-paymenttokenid"); 

    	if (typeof data.PaymentTokenId=='undefined') 
    		doWebPayment(<%=JvString.jsString(saleId)%>, data); 
    	else
     		doPayByToken(<%=JvString.jsString(accountId)%>, <%=JvString.jsString(saleId)%>, <%=amount%>, data);    	
	  }
	});
    
    
  </script>
  
  
</v:dialog>
