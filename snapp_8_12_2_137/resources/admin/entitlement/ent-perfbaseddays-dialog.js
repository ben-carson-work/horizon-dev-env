entDialog("ent-perfbaseddays-dialog", function($dlg) {
  let obj = null;
  let callback = null;
  let $cbMatch = $dlg.find("#perfmatch");
  let $txtStart = $dlg.find("#perfstartdays-qty-edit");
  let $txtExp = $dlg.find("#perfexpdays-qty-edit");
  let $widgetPerfDays = $dlg.find("#perfdays-widget");
  
  $cbMatch.change(_refreshVisibility);
  
  function _decodeDays(value) {
    return (value == "") ? null : parseInt(value);
  }
  
  function _showError($txt) {
    showMessage(itl("@Common.InvalidValueError", $txt.val()), function() {
      $txt.select();
    });
  }
  
  function _refreshVisibility() {
    $widgetPerfDays.setClass("hidden", $cbMatch.isChecked());
  }

  return {
    "onShow": function(aObj, aCallback) {
      obj = aObj;
      callback = aCallback;
  
      $cbMatch.setChecked(obj.PerfMatch);
      $txtStart.val(obj.PerfStartDays);
      $txtExp.val(obj.PerfExpDays);
      _refreshVisibility();
    },
    
    "onSave": function() {
      if ($cbMatch.isChecked()) {
        obj.PerfMatch     = true;
        obj.PerfStartDays = null;
        obj.PerfExpDays   = null;
        callback();
      }
      else {
        let start = _decodeDays($txtStart.val());
        let exp = _decodeDays($txtExp.val());
      
        if ((start != null) && isNaN(start)) 
          _showError($txtStart);
        else if ((exp != null) && isNaN(exp)) 
          _showError($txtExp);
        else {
          obj.PerfMatch     = null;
          obj.PerfStartDays = start;
          obj.PerfExpDays   = exp;
    
          callback();
        }
      }
    }
  };
});
