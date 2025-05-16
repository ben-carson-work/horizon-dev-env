entDialog("ent-incprod-dialog", function($dlg) {
  var obj = null;
  var callback = null;
  var $txtQuantity = $dlg.find("#incprod-qty-edit");
  $txtQuantity.keypressNumOnly();
  
  return {
    "onShow": function(aObj, aCallback) {
      obj = aObj;
      callback = aCallback;
  
      $txtQuantity.val(obj.IncProdQty);
      $txtQuantity.select();
    },
    
    "onSave": function() {
      obj.IncProdQty = parseInt($txtQuantity.val());
      callback();
    }
  };
});
