<%@page import="com.vgs.snapp.library.BarcodeUtils"%>
<%@ taglib uri="ksk-tags" prefix="ksk" %>

<ksk:step-screen id="step-checkout" clazz="vert-flex" stepCode="CHECKOUT" controller="StepCheckoutController">
  
  <jsp:include page="../../common/kiosk-header.jsp"></jsp:include>
  
  <ksk:center-pane>

    <div id="checkout-message-payment-working" class="checkout-message active">
      <h2>Authorizing payment <span id="remaining-time"></span></h2>
      <div class="message-image"><img src="plugins/pkg-kiosk-js/kiosk/status-transaction/images/payment-working.jpg"/></div>
    </div>
  
    <div id="checkout-message-payment-failed" class="checkout-message">
      <h2></h2>
      <div class="message-image"><img src="plugins/pkg-kiosk-js/kiosk/status-transaction/images/payment-failed.png"/></div>
      <button id="btn-checkout-payment-failed-dismiss" class="btn btn-danger" type="button">Dismiss</button>
      <button id="btn-checkout-payment-failed-retry" class="btn btn-success" type="button">Try again</button>
    </div>
  
    <div id="checkout-message-payment-success" class="checkout-message">
      <h2>Payment success</h2>
      <div class="message-image"><img src="plugins/pkg-kiosk-js/kiosk/status-transaction/images/payment-success.png"/></div>
    </div>
    
    <div id="checkout-message-post-transaction" class="checkout-message">
      <h2>We are processing your order</h2>
      <div class="message-image"><img src="plugins/pkg-kiosk-js/kiosk/status-transaction/images/post-transaction.png"/></div>
    </div>
  
    <div id="checkout-message-print-ticket" class="checkout-message">
      <h2>Printing ticket <span id="ticket-no"></span> of <span id="ticket-count"></span></h2>
      <div class="message-image"><img src="plugins/pkg-kiosk-js/kiosk/status-transaction/images/print-ticket.png"/></div>
    </div>
  
    <div id="checkout-message-print-receipt" class="checkout-message">
      <h2>Printing receipt</h2>
      <div class="message-image"><img src="plugins/pkg-kiosk-js/kiosk/status-transaction/images/print-receipt.png"/></div>
    </div>
  
    <div id="checkout-message-change" class="checkout-message">
      <h2>Dispensing change</h2>
      <div class="message-image"><img src="plugins/pkg-kiosk-js/kiosk/status-transaction/images/change.png"/></div>
    </div>
  
    <div id="checkout-message-transaction-success" class="checkout-message">
      <h2>Collect your tickets.<br/>Thank You!</h2>
      <div class="message-image"><img src="plugins/pkg-kiosk-js/kiosk/status-transaction/images/transaction-success.png"/></div>
      <ksk:pane-item id="btn-checkout-end-transaction" clazz="" caption="DONE" fa="check"/>
    </div>
  
    <div id="checkout-message-transaction-failed" class="checkout-message">
      <h2>Something went wrong</h2>
      <div class="message-image"><img src="plugins/pkg-kiosk-js/kiosk/status-transaction/images/transaction-failed.png"/></div>
    </div>
    
    <div id="checkout-message-print-selection" class="checkout-message">
      <h2>Select a print option</h2>
	    <div id="print-option-list"></div>
    </div>
    
    <div id="checkout-message-virtual-print" class="checkout-message">
      <h2></h2>
	    <div id="virtual-ticket-list"></div>
        <div id="qr-mobile-wallet-add" class="d-flex justify-content-center"></div>
    	<ksk:pane-item id="btn-print-done" clazz="btn-print-done" caption="DONE" fa="check"/>
        <ksk:pane-item id="btn-print-back" clazz="" caption="BACK" fa="arrow-rotate-left"/>
    </div>
 
  </ksk:center-pane>
  
  <div id="checkout-templates" class="hidden">
    <ksk:pane-item clazz="btn-print-option" caption="CAPTION" fa="DUMMY"/>
    <ksk:pane-item clazz="virtual-ticket" caption="CAPTION" fa="qrcode"/>
  </div>
  

</ksk:step-screen>
