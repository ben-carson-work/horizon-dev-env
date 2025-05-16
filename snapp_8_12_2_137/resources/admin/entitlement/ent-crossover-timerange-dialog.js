entDialog("ent-crossover-timerange-dialog", function($dlg) {
  var obj = null;
  var callback = null;
  var $timeFrom = $dlg.find(".ent-crossover-from-time");
  var $timeTo = $dlg.find(".ent-crossover-to-time");
  
  return {
    "width": 600,
    
    "onShow": function(aObj, aCallback) {
      obj = aObj;
      callback = aCallback;
  
      $timeFrom.setXMLTime(obj.CrossoverFromTime);
      $timeTo.setXMLTime(obj.CrossoverToTime);
    },
    
    "onSave": function() {
      obj.CrossoverFromTime = getNull($timeFrom.getXMLTime());
      obj.CrossoverToTime = getNull($timeTo.getXMLTime());
  
      callback();
    }
  };
});
