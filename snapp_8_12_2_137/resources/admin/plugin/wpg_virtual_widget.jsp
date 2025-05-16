<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<%
PageBO_Base<?> pageBase  = (PageBO_Base<?>)request.getAttribute("pageBase");
String   approveURL      = pageBase.getEmptyParameter("ApproveURL");
String   denyURL         = pageBase.getEmptyParameter("DenyURL");
String   abortURL        = pageBase.getEmptyParameter("AbortURL");
boolean  supportWebFrame = pageBase.isParameter("SupportWebFrame", "true");
%>

<iframe id="iframe-virtual-wpg" class="hidden"></iframe>

<v:tab-content style="max-width:500px; margin:auto">
  <v:alert-box type="warning"><strong>*** TEST - VIRTUAL WEB PAYMENT GATEWAY - TEST ***</strong></v:alert-box>
  
  <v:widget>
    <v:widget-block>
      <v:form-field caption="@Payment.Cardholder">
        <v:input-text type="text" field="authResponse.CardHolderName"/>
      </v:form-field>
      <v:form-field caption="@Payment.CardNumber" hint="@Payment.LastFourDigits">
        <v:input-text type="text" field="authResponse.CardNumber" maxLength="4"/>
      </v:form-field>
      <v:form-field caption="@Payment.ExpiryDate" hint="Insert a past date to simulate authorization denial">
        <v:input-text field="authResponse.CardExpDate" placeholder="MM/YY" maxLength="5"/> 
      </v:form-field>
      <v:form-field caption="@Installment.CardType">
        <v:radio name="card-type" value="VISA" caption="VISA" checked="true"/> &nbsp;
        <v:radio name="card-type" value="MASTERCARD" caption="MASTERCARD"/> &nbsp;
        <v:radio name="card-type" value="AMEX" caption="AMEX"/>
      </v:form-field>
    </v:widget-block>
    
    <v:widget-block>
        <v:db-checkbox field="cbCallback" value="true" checked="true" caption="Authorization callback" hint="When not selected, it simulates the scenario where the bank approved the payment, but was unable to notify us back."/> 
    </v:widget-block>
    
    <v:widget-block>
      <center>
        <v:button id="btn-approve" caption="@Common.Approve" fa="thumbs-up"/>
      </center>
    </v:widget-block>
  </v:widget>
</v:tab-content>

<script>
$(document).ready(function() {
  var wpgtrn = <%=request.getAttribute("wpgtrn")%>;
  var supportWebFrame = <%=supportWebFrame%>;
  var paymentStatus_Approved = 2;
  var paymentStatus_Failed   = 3;
  
  $("#authResponse\\.CardHolderName").focus();
  $("#authResponse\\.CardExpDate").keypress(_inputExpDate);
  $("#btn-approve").click(_approve);

  function _approve() {
    snpAPI.cmd("VirtualAuth", "Authorize", _getParams()).then(ansDO => {
      var message = (ansDO.Approved === true) ? ("Payment Authorized - " + ansDO.AuthorizationCode) : ("DENIED - " + ansDO.DenyMessage);
      var skipCallback = !$("#cbCallback").isChecked();
      
      showMessage(message, function() {
        if (skipCallback)
          window.location = BASE_URL; // Redirect anywhere, but don't call PageWebPaymentCallback
        else {
          var callbackURL = BASE_URL + "/admin?page=wpg&WebAuthId=" + encodeURIComponent(wpgtrn.WebAuthId) + "&PluginId=" + encodeURIComponent(wpgtrn.PluginId);
          if (supportWebFrame)
            $("#iframe-virtual-wpg").attr("src", callbackURL);
          else
            window.location = callbackURL;
        }
      });
    });
  }
  
  function _getParams() {
    var exp = $("#authResponse\\.CardExpDate").val();
    if (exp.length >= 5)
      exp = exp.substr(0, 2) + exp.substr(3, 5);
    
    return {
      WebAuthId        : wpgtrn.WebAuthId,
      PaymentAmount    : wpgtrn.PaymentAmount,
      CreditCard: {
        CardHolderName : $("#authResponse\\.CardHolderName").val(),
        CardType       : $("[name='card-type']:checked").val(),
        CardNumber     : "************" + $("#authResponse\\.CardNumber").val(),
        ExpirationDate : exp
      }
    }
  }
  
  /*
  function _callback(ansDO) {
    var trnRecap = {
      SaleId: wpgtrn.SaleId,
      SaleCode: wpgtrn.SaleCode
    };
    
    var data = {
      PaymentStatus: (ansDO.Approved === true) ? paymentStatus_Approved : paymentStatus_Failed,
      AuthorizationCode: ansDO.AuthorizationCode,
      ErrorMessage: ansDO.DenyMessage,
    };
    
    WebPayment_CallBack(trnRecap, data);
  }
  */

  function _inputExpDate(e) {
    var input = e.target.value;
    if (input.length === 2 && e.inputType !== 'deleteContentBackward') {
      e.target.value += '/';
    }
  }
});
</script>
