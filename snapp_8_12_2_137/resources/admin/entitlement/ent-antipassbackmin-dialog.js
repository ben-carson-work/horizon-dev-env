entDialog("ent-antipassbackmin-dialog", function($dlg) {
  var obj = null;
  var callback = null;
  var $txtQuantity = $dlg.find("#minutes-qty-edit");
  $txtQuantity.keypressNumOnly();
  
  return {
    "onShow": function(aObj, aCallback) {
      obj = aObj;
      callback = aCallback;
  
      $txtQuantity.val(obj.AntiPassBackMinutes);
      $txtQuantity.select();
    },
    
    "onSave": function() {
      obj.AntiPassBackMinutes = parseInt($txtQuantity.val());
      callback();
    }
  };
});
