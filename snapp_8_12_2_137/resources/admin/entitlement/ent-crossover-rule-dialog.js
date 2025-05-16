entDialog("ent-crossover-rule-dialog", function($dlg) {
  var obj = null;
  var callback = null;
  var $hint = $dlg.find("#crossover-rule-hint");
  var $radio = $dlg.find("input[name='crossover-rule-radio']");
  $radio.click(_refreshHint);
  
  function _refreshHint() {
    $hint.find(".alert-content").text(itl($radio.filter(":checked").attr("data-rawhint")));
  }
  
  return {
    "width": 600,
    
    "onShow": function(aObj, aCallback) {
      obj = aObj;
      callback = aCallback;
  
      setRadioChecked($radio, (obj.CrossoverRule == null) ? 1/*LkSNCrossoverRule.SameDay*/ : obj.CrossoverRule);
      _refreshHint();
    },
    
    "onSave": function() {
      obj.CrossoverRule = parseInt($radio.filter(":checked").val());
      callback();
    }
  };
});
