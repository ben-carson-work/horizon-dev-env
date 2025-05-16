entDialog("ent-perfqty-dialog", function($dlg) {
  var obj = null;
  var callback = null;
  var $txtQuantity = $dlg.find("#perfqty-edit");
  
  function _decodeDays(value) {
    return (value == "") ? null : parseInt(value);
  }

  return {
    "onShow": function(aObj, aCallback) {
      obj = aObj;
      callback = aCallback;
  
      $txtQuantity.val(obj.PerfQty);
      $txtQuantity.select();
    },
    
    "onSave": function() {
      var qty = _decodeDays($txtQuantity.val());
    
      if ((qty != null) && isNaN(qty)) {
        showMessage(itl("@Common.InvalidValueError", $txtQuantity.val()), function() {
          $txtQuantity.select();
        });
      } 
      else {
        obj.PerfQty = qty;
        callback();
      }
    }
  };
});
