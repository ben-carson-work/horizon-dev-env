entDialog("ent-ttrule-dialog", function($dlg) {
  var obj = null;
  var callback = null;
  var $comboRuleId = $dlg.find("#rule-id-combo");
  
  return {
    "width": 600,
    
    "onShow": function(aObj, aCallback) {
      obj = aObj;
      callback = aCallback;
  
      $comboRuleId.val(obj.TimedTicketRuleId);
    },
    
    "onSave": function() {
      obj.TimedTicketRuleId = $comboRuleId.val();
      obj.RuleName = $comboRuleId.find("option:selected").text();
      callback();
    }
  };
});
