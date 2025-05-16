entDialog("ent-reentry-dialog", function($dlg) {
  var obj = null;
  var callback = null;
  var $txtQuantity = $dlg.find("#reentry-qty-edit");
  $txtQuantity.keypressNumOnly();
  
  
  return {
    "onShow": function(aObj, aCallback) {
      obj = aObj;
      callback = aCallback;
  
      $txtQuantity.val(obj.ReEntryQty);
      $txtQuantity.select();
    },
    
    "onSave": function() {
      obj.ReEntryType = 1; // LkSNReEntryType.Permitted
      obj.ReEntryQty = $txtQuantity.val();
    
      callback();
    }
  };
});
