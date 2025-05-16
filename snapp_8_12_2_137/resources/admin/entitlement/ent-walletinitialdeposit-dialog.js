entDialog("ent-walletinitialdeposit-dialog", function($dlg) {
  var obj = null;
  var callback = null;
  var $cbInherit = $dlg.find("#wallet-inherit-from-price");
  var $txtAmount = $dlg.find("#wallet-initial-deposit-edit");

  $cbInherit.change(_refreshWallet);
  
  function _refreshWallet() {
    $dlg.find("#block-wallet-deposit-amount").setClass("hidden", $cbInherit.isChecked());
  }

  return {
    "width": 400,
    
    "onShow": function(aObj, aCallback) {
      obj = aObj;
      callback = aCallback;
  
      $cbInherit.prop("checked", obj.WalletInheritFromSalePrice); 
      $txtAmount.val(obj.WalletInitialDeposit);
      $txtAmount.select();
      
      _refreshWallet();
    },
    
    "onSave": function() {
      obj.WalletInheritFromSalePrice = $cbInherit.isChecked();
      obj.WalletInitialDeposit = $txtAmount.val();
    
      callback();
    }
  };
});
