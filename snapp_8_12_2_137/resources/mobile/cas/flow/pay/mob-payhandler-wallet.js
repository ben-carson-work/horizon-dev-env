//# sourceURL=mob-payhandler-wallet.js

$(document).ready(function() {
  
  var walletHandler = {
    // Properties 
    "PaymentType": LkSN.PaymentType.Wallet,
    // Methods
    "approve": approve
  };
  
  StepPayment.registerPaymentHandler(walletHandler);
  
  function approve(plugin, amount) {
    return new Promise(function (resolve, reject) {
      BLMob.showMediaPickupDialog({
        "AllowExisting": true
      }, function(mediaRead, media) {
        if (media == null)
          reject();
        else {
          var availCredit = media.WalletBalance + media.WalletCreditLimit;
          
          if (availCredit <= 0)
            UIMob.showError(itl("Payment.WalletBalanceTooShort", formatCurr(availCredit)));
          else if (availCredit < amount) {
            var msg = itl("Payment.WalletBalanceTooShort", formatCurr(availCredit)) + "\n" + itl("Payment.WalletUseResidual");
            UIMob.showMessage(itl("@Common.Warning"), msg, [itl("@Common.Ok"), itl("@Common.Cancel")], function(index) {
              if (index == 0)
                _doApplyHold(media, availCredit);
              else
                reject();
            });
          }
          else
            _doApplyHold(media, amount);
        }
      });
      
      function _doApplyHold(media, amount) {
        UIMob.showWaitGlass();
        snpAPI("Portfolio", "HoldWalletPayment", {
          "PortfolioId": media.PortfolioId,
          "Amount": amount
        })
        .finally(function() {
          UIMob.hideWaitGlass();
        })
        .then(function(holdData) {
          resolve({
            "ChargedAmount": amount,
            "PaymentDetail": {
              "Wallet": {
                "PortfolioId": media.PortfolioId,
                "PortfolioSlotHoldId": holdData.PortfolioSlotHoldId
              }
            }
          });
        })
        .catch(function(holdError) {
          reject(holdError)
        });
      }
    });
  }
  
});