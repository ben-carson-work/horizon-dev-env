entDialog("ent-incprodvalue-dialog", function($dlg) {
  const PriceValueType_Absolute = 1;
  const PriceValueType_Percentage = 2;
  var obj = null;
  var callback = null;
  var $txtAmount = $dlg.find("#incprod-value-edit");
  
  return {
    "onShow": function(aObj, aCallback) {
      obj = aObj;
      callback = aCallback;
  
      var value = obj.IncProdValue;
      if (value) {
        if (obj.IncProdValueType == PriceValueType_Percentage)
          value = value + "%";
        $txtAmount.val(value);
      }
      
      $txtAmount.select();
    },
    
    "onSave": function() {
      var value = $txtAmount.val();
      var isPerc = value.indexOf("%") !== -1;
      value = value.replace("%", "");
      value = value.replace(",", ".");
      
      obj.IncProdValue = parseFloat(value);
      obj.IncProdValueType = (isPerc) ? PriceValueType_Percentage : PriceValueType_Absolute;
    
      callback();
    }
  };
});
