//# sourceURL=mob-step-payment.js

$(document).ready(function() {

  window.StepPayment = {
    // Properties
    "Active": false,
    // Methods
    "execute": execute,
    "registerPaymentHandler": registerPaymentHandler,
    "getPaymentHandler": getPaymentHandler,
    "getPaymentMethods": getPaymentMethods, // return an array of Plugin objects
    "isTenderedEnough": isTenderedEnough,
    "addSplit": addSplit,
    "stepConfirm": stepConfirm,
    "stepCancel": stepCancel
  };
  
  // Map<PaymentType, PaymentTypeHandler>
  var paymentHandlers = {};
  var promises = [];
  
  function execute(params) {
    return new Promise(function (resolve, reject) {
      if (params.Refund === true)
        resolve();
      else if (strToFloatDef(shopCart.TotalDue, 0) === 0)
        resolve();
      else {
        promises.push({"resolve":resolve, "reject":reject});
        
        UIMob.tabSlideView({
          "container": "#mobile-main",
          "packageName": PKG_CAS,
          "viewName": "step-payment"   
        });
      }
    });
  }
  
  function triggerPaymentDataChange() {
    $(document).trigger("PaymentDataChange", shopCart.Payments || {});
  }
  
  function registerPaymentHandler(handler) {
    paymentHandlers[handler.PaymentType.code] = handler;
  }
  
  function getPaymentHandler(paymentType) {
    var handler = paymentHandlers[paymentType];
    if (handler)
      return handler;
    else
      throw Error("Unable to find handler for PaymentType=" + paymentType);
  }
  
  function getPaymentMethods() {
    var result = [];
    var list = BLMob.Workstation.PaymentMethodList || [];

    var allowedPluginIDs = (window.BLMob.Rights.PaymentMethodIDs || "").split(",");
    
    var hiddenPTs = [
      LkSN.PaymentType.ReservationSplit.code, 
      LkSN.PaymentType.Consignment.code, 
      LkSN.PaymentType.Voucher.code, 
      LkSN.PaymentType.Installment.code, 
      LkSN.PaymentType.DepositOnOrder.code,
      LkSN.PaymentType.AdvancedPayment.code
    ];
    
    for (var i=0; i<list.length; i++) {
      var plugin = list[i];
      var paymentType = plugin.PaymentMethodDetails.PaymentType;

      var allowed = (hiddenPTs.indexOf(paymentType) < 0);
      
      if (allowed)
        allowed = (allowedPluginIDs.indexOf(plugin.PluginId) >= 0);
      
      if ((allowed) && (false /* TransactionType==CreditSettlement*/) && (paymentType == LkSN.PaymentType.Credit.code)) 
        allowed = false;
      
      if (allowed) {
        var handler = paymentHandlers[paymentType];
        if (handler == null) {
          console.error("Missing handler for PaymentType: [" + paymentType + "] " + getLookupDesc(LkSN.PaymentType, paymentType));
          allowed = false;
        }
      }
      
      if (allowed) 
        result.push(plugin);
    }
    
    return result;
  }
  
  function isTenderedEnough() {
    var pd = shopCart.Payments || {};
    return Math.abs(pd.Due) <= Math.abs(pd.Tendered);
  }
  
  function doAddSplit(plugin, amount, detail) {
    UIMob.showWaitGlass();
    snpAPI("ShopCart", null, {
      "Command": "AddPaymentSplit",
      "ShopCartId": shopCart.ShopCartId,
      "AddPaymentSplit": {
        "PaymentMethodId": plugin.PluginId,
        "Amount": amount,
        "Detail": detail
      }
    })
    .finally(function() {
      UIMob.hideWaitGlass();
    })
    .then(function(ans) {
      shopCart = ans.Answer.ShopCart;
      triggerPaymentDataChange();
    });
  }
  
  function addSplit(plugin, amount) {
    var handler = getPaymentHandler(plugin.PaymentMethodDetails.PaymentType);
    handler.approve(plugin, amount)
      .then(function(data) {
        data = data || {};
        doAddSplit(plugin, (data.ChargedAmount || amount), data.PaymentDetail);
      })
      .catch(function(error) {
        if (error)
          UIMob.showError(error);
      });
  }
  
  function stepConfirm() {
    UIMob.tabNavBack("#mobile-main");
    promises.pop().resolve();
  }
  
  function stepCancel() {
    UIMob.tabNavBack("#mobile-main");
    promises.pop().reject();
  }
});