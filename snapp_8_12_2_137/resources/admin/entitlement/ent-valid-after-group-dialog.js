entDialog("ent-valid-after-group-dialog", function($dlg) {
  var obj = null;
  var callback = null;
  var $txtGroupCode = $dlg.find("#valid-after-group-edit");
  
  return {
    "onShow": function(aObj, aCallback) {
      obj = aObj;
      callback = aCallback;
  
      $txtGroupCode.val(obj.ValidAfterGroup);
      $txtGroupCode.select();
    },
    
    "onSave": function() {
      obj.ValidAfterGroup = $txtGroupCode.val().trim();
      callback();
    }
  };
});
