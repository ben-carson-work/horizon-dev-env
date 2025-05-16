entDialog("ent-daterange-dialog", function($dlg) {
  var obj = null;
  var callback = null;
  var $radio = $dlg.find("input[name='date-range-validity-group-radio']");
  var $dtFrom = $dlg.find(".from-date-picker");
  var $dtTo = $dlg.find(".to-date-picker");

  function _decodeDate(str) {
    return (getNull(str) == null) ? null : new Date(str.replace("-", "/"));
  }
  
  return {
    "width": 400,
    
    "onShow": function(aObj, aCallback) {
      obj = aObj;
      callback = aCallback;
  
      setRadioChecked($radio, (obj.DateRangeValidityType == null) ? 10/*LkSNDateRangeValidityType.Valid*/ : obj.DateRangeValidityType);
      $dtFrom.datepicker("setDate", _decodeDate(obj.ValidFromDate));
      $dtTo.datepicker("setDate", _decodeDate(obj.ValidToDate));
    },
    
    "onSave": function() {
      obj.DateRangeValidityType = parseInt($radio.filter(":checked").val());
      obj.ValidFromDate = getNull($dtFrom.getXMLDate()); 
      obj.ValidToDate = getNull($dtTo.getXMLDate()); 
      
      callback();
    }
  };
});
