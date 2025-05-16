//# sourceURL=mob-payhandler-cash.js

$(document).ready(function() {
  
  var cashHandler = {
    // Properties 
    "PaymentType": LkSN.PaymentType.Cash,
    // Methods
    "approve": approve
  };
  
  StepPayment.registerPaymentHandler(cashHandler);
  
  function approve(plugin, amount) {
    return new Promise(function (resolve, reject) {
      resolve();
    });
  }
});