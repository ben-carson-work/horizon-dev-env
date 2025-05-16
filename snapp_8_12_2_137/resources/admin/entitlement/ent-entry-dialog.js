entDialog("ent-entry-dialog", function($dlg) {
  var obj = null;
  var callback = null;
  var $radios = $dlg.find("input[name='entry-type-radio']");
  var $txtQuantity = $dlg.find("#entry-qty-edit");
  $txtQuantity.keypressNumOnly();
  
  
  return {
    "width": 400,
    
    "onShow": function(aObj, aCallback) {
      obj = aObj;
      callback = aCallback;
  
      setRadioChecked($radios, (obj.EntryType == null) ? 1/*LkSN.EntryType_Automatic*/ : obj.EntryType);
      $txtQuantity.val(obj.EntryQty);
      $txtQuantity.select();
    },
    
    "onSave": function() {
      obj.EntryType = $radios.filter(":checked").val();
      obj.EntryQty = $txtQuantity.val();
      
      callback();
    }
  };
});
