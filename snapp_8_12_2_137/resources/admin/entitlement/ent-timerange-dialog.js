entDialog("ent-timerange-dialog", function($dlg) {
  var obj = null;
  var callback = null;
  var $timeFrom = $dlg.find(".ent-from-time");
  var $timeTo = $dlg.find(".ent-to-time");
  var $timeFirstFrom = $dlg.find(".ent-firstday-from-time");
  var $timeFirstTo = $dlg.find(".ent-firstday-to-time");
  var $timeSelFrom = $dlg.find(".ent-selection-from-time");
  var $timeSelTo = $dlg.find(".ent-selection-to-time");
  
  return {
    "width": 600,
    
    "onShow": function(aObj, aCallback) {
      obj = aObj;
      callback = aCallback;
  
      $timeFrom.setXMLTime(obj.ValidFromTime);
      $timeTo.setXMLTime(obj.ValidToTime);
      $timeFirstFrom.setXMLTime(obj.FirstDayValidFromTime);
      $timeFirstTo.setXMLTime(obj.FirstDayValidToTime);
      $timeSelFrom.setXMLTime(obj.SelectionFromTime);
      $timeSelTo.setXMLTime(obj.SelectionToTime);
    },
    
    "onSave": function() {
      obj.ValidFromTime = getNull($timeFrom.getXMLTime());
      obj.ValidToTime = getNull($timeTo.getXMLTime());
      obj.FirstDayValidFromTime = getNull($timeFirstFrom.getXMLTime());
      obj.FirstDayValidToTime = getNull($timeFirstTo.getXMLTime());
      obj.SelectionFromTime = getNull($timeSelFrom.getXMLTime());
      obj.SelectionToTime = getNull($timeSelTo.getXMLTime());
  
      callback();
    }
  };
});
