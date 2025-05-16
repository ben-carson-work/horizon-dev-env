entDialog("ent-override-dialog", function($dlg) {
  var obj = null;
  var callback = null;
  var $txtQuantity = $dlg.find("#override-qty-edit");
  $txtQuantity.keypressNumOnly();
  
  return {
    "onShow": function(aObj, aCallback) {
      obj = aObj;
      callback = aCallback;
  
      $txtQuantity.val(obj.OverrideQty);
      $txtQuantity.select();
    },
    
    "onSave": function() {
      obj.OverrideType = 1; // LkSNEntOverrideType.Permitted
      obj.OverrideQty = parseInt($txtQuantity.val());
  
      callback();
    }
  };
});
