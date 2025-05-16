entDialog("ent-resourcebaseddays-dialog", function($dlg) {
  var obj = null;
  var callback = null;
  var $txtStart = $dlg.find("#resourcestartdays-qty-edit");
  var $txtExp = $dlg.find("#resourceexpdays-qty-edit");
    
  function _decodeDays(value) {
    return (value == "") ? null : parseInt(value);
  }
  
  function _showError($txt) {
    showMessage(itl("@Common.InvalidValueError", $txt.val()), function() {
      $txt.select();
    });
  }

  return {
    "onShow": function(aObj, aCallback) {
      obj = aObj;
      callback = aCallback;
  
      $txtStart.val(obj.ResourceStartDays);
      $txtExp.val(obj.ResourceExpDays);
    },
    
    "onSave": function() {
      var start = _decodeDays($txtStart.val());
      var exp = _decodeDays($txtExp.val());
    
      if ((start != null) && isNaN(start)) 
        _showError($txtStart);
      else if ((exp != null) && isNaN(exp)) 
        _showError($txtExp);
      else {
        obj.ResourceStartDays = start;
        obj.ResourceExpDays = exp;
  
        callback();
      }
    }
  };
});
