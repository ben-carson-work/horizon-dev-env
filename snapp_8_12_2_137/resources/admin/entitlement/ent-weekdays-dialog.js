entDialog("ent-weekdays-dialog", function($dlg) {
  var obj = null;
  var callback = null;
  var $weekdays = $dlg.find("input[name='weekdays-cb']");
  
  return {
    "width": 400,
    
    "onShow": function(aObj, aCallback) {
      obj = aObj;
      callback = aCallback;
  
      setChecked($weekdays, false);
      if (obj.WeekDays != null) {
        for (var i=0; i<obj.WeekDays.length; i++) 
          setChecked($weekdays.filter("[value='" + obj.WeekDays[i] + "']"), true);
      }
    },
    
    "onSave": function() {
      var str = getNull($weekdays.getCheckedValues());
      obj.WeekDays = (str == null) ? null : str.split(",");
      callback();
    }
  };
});
