entDialog("ent-aptsingleusemin-dialog", function($dlg) {
  var obj = null;
  var callback = null;
  var $txtQuantity = $dlg.find("#single-use-min-edit");
  $txtQuantity.keypressNumOnly();
  
  return {
    "onShow": function(aObj, aCallback) {
      obj = aObj;
      callback = aCallback;
  
      $txtQuantity.val(obj.AptSingleUseMinutes);
      $txtQuantity.select();
    },
    
    "onSave": function() {
      obj.AptSingleUseMinutes = parseInt($txtQuantity.val());
      callback();
    }
  };
});
