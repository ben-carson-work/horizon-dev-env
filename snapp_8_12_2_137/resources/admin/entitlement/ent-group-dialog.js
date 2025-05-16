entDialog("ent-group-dialog", function($dlg) {
  var obj = null;
  var callback = null;
  var $txtGroupCode = $dlg.find("#group-code-edit");
  
  return {
    "onShow": function(aObj, aCallback) {
      obj = aObj;
      callback = aCallback;
  
      $txtGroupCode.val(obj.GroupCode);
      $txtGroupCode.select();
    },
    
    "onSave": function() {
      obj.GroupCode = $txtGroupCode.val().trim();
      callback();
    }
  };
});
