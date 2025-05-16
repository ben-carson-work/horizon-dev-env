<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<%
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");

String       sessionData    	= pageBase.getParameter("sessionData");
String       sessionId      	= pageBase.getParameter("sessionId");
String       clientKey      	= pageBase.getParameter("clientKey");
String       environment    	= pageBase.getParameter("environment");
String 			 saleCode       	= pageBase.getParameter("saleCode");
String			 timeOut			  	=  pageBase.getParameter("timeOut");
String			 transactionType	=  pageBase.getParameter("transactionType");

%>

<link rel="stylesheet"
     href="https://checkoutshopper-live.adyen.com/checkoutshopper/sdk/5.48.0/adyen.css"
     integrity="sha384-qnBE7PYKjoczkCnsKztuq5/oFKUqP98X25aVmTb5YpMCci4yqktWu7PTu0pdcW2G"
     crossorigin="anonymous">
     
<div id="ie-warn-box" class="test-warn-box v-hidden">If you are using an older version of Internet Explorer, please ensure that your cookies are enabled before proceeding with your payment</div>

<div id="dropin-container"></div>

<script>
$(document).ready(function() {
  var ie = detectIE();
  if ((ie == 10) || (ie == 11))
    $("#ie-warn-box").removeClass("v-hidden");
  else{
    loadDropIn();
  }
  
  async function loadDropIn() {
    const script = document.createElement("script");
    script.src = "https://checkoutshopper-live.adyen.com/checkoutshopper/sdk/5.48.0/adyen.js";
    script.integrity = "sha384-wvwpOBTCI7TDOWLqwmi5LAsI998q3l9ELPrDe9mHNnAkCHyErgsKqTfMedQga84B";
		script.setAttribute("crossorigin", "anonymous");
		script.setAttribute("onload", "javascript:createCheckout()"); // Wait until the script is loaded before initiating AdyenCheckout
    document.body.appendChild(script);
  }  
});
async function createCheckout(){
  const configuration = {
      environment: "<%=environment%>", // Change to 'live' for the live environment.
      clientKey: "<%=clientKey%>", // Public key used for client-side authentication: https://docs.adyen.com/development-resources/client-side-authentication
      analytics: {
        enabled: true // Set to false to not send analytics data to Adyen.
      },
      session: {
        id: "<%=sessionId%>", // Unique identifier for the payment session.
        sessionData: "<%=sessionData%>" // The payment session data.
      },
      onPaymentCompleted: (result, component) => {
				<%if (transactionType.equalsIgnoreCase(LkSNTransactionType.CreditCardVerification.getCode()+"")) {%>
					showMessage(itl("@Payment.TokenWillBeShownLater"));
					$("#payment_token_webpayment_dialog").dialog("close")
				<%}else{%>
	      	verifySaleStatus();
				<%}%>
      },
      onError: (error, component) => {
          showMessage(error.message);
      },
    };
	// Create an instance of AdyenCheckout using the configuration object.
  const checkout = await AdyenCheckout(configuration);
  // Create an instance of Drop-in and mount it to the container you created.
  const dropinComponent = checkout.create('dropin').mount('#dropin-container');
}

function verifySaleStatus(){
  timeOutTime = Date.now() + <%=timeOut%>;
  showWaitGlass();
  setTimeout(getSaleStatus, 1500, timeOutTime);
}

function getSaleStatus(timeOutTime){
	var reqDO = {
				Sale:{SaleCode: "<%=saleCode%>"}
   		};
	snpAPI.cmd("Sale", "GetSaleStatus", reqDO)
	  .then(ansDO => {
	    if (ansDO.SaleStatus == <%=LkSNSaleStatus.WaitingForPayment.getCode()%>){
	      if (Date.now() < timeOutTime)
	      	setTimeout(getSaleStatus, 1500, timeOutTime);
	      else
	        processTiemout(ansDO);
	    }
	    else
	      processStatusChanged(ansDO);
	  });
}

function processTiemout(trxStatusAnswer) {
  hideWaitGlass();
  authResponse = createAuthResponse(trxStatusAnswer);
  trnRecap = createTransactionRecap(trxStatusAnswer);
  authResponse.ErrorMessage = 'Waiting for payment timeout error';
  WebPayment_CallBack(trnRecap, authResponse);
}

function processStatusChanged(trxStatusAnswer){
	hideWaitGlass();
	authResponse = createAuthResponse(trxStatusAnswer);
  trnRecap = createTransactionRecap(trxStatusAnswer);
  WebPayment_CallBack(trnRecap, authResponse);
}


function createAuthResponse(trxStatusAnswer){
  return {
    	//if payment failed, status remain waiting for payment(200)
    	//so if sale status changed it means payment have been approved
      PaymentStatus: <%=LkSNPaymentStatus.Approved.getCode()%>,
      AuthorizationCode: trxStatusAnswer.WebAuthAuthorizationCode,
      ErrorMessage: ''
  };
}

function createTransactionRecap(trxStatusAnswer){
  return {
    SaleId: trxStatusAnswer.SaleId,
		SaleCode: trxStatusAnswer.SaleCode,
		PahRelativeDownloadUrl: trxStatusAnswer.PahRelativeDownloadUrl
  };
}

</script>
