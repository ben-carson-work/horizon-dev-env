entDialog("ent-period-constraint-dialog", function($dlg) {
  var obj = null;
  var callback = null;
  var $radio = $dlg.find("input[name='period-constraint-radio']");
  var $txtQuantity = $dlg.find("#period-constraint-qty-edit");
  
  return {
    "width": 600,
    
    "onShow": function(aObj, aCallback) {
      obj = aObj;
      callback = aCallback;
  
      setRadioChecked($radio, (obj.PeriodType == null) ? 1/*LkSNPeriodType.Day*/ : obj.PeriodType);
      $txtQuantity.val(obj.PeriodQty);
    },
    
    "onSave": function() {
      var value = $txtQuantity.val();
      var qty = (value == "") ? null : parseInt(value);
    
      if ((qty != null) && isNaN(qty)) {
        showMessage(itl("@Common.InvalidValueError", $txtQuantity.val()), function() {
          $txtQuantity.select();
        });
      } 
      else {
        obj.PeriodType = parseInt($radio.filter(":checked").val());
        obj.PeriodQty = $txtQuantity.val();
        
        callback();
      }
    }
  };
});
