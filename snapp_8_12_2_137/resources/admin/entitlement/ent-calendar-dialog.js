entDialog("ent-calendar-dialog", function($dlg) {
  var obj = null;
  var callback = null;
  var $calendar = $dlg.find("#cal-id-combo");
  
  return {
    "width": 400,
    
    "onShow": function(aObj, aCallback) {
      obj = aObj;
      callback = aCallback;
  
      $calendar.val(obj.CalendarId);
      $calendar.focus();
    },
    
    "onSave": function() {
      obj.CalendarId = $calendar.val();
      obj.CalendarName = $calendar.find("option:selected").text();
      
      callback();
    }
  };
});
