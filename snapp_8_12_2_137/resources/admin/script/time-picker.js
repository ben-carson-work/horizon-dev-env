$(document).ready(function() {
  const CLASSNAME = "v-timepicker";
  const INITIALIZED = "v-timepicker-initialized"; 

  snpObserver.registerListener(CLASSNAME, INITIALIZED, function($comp) {
  });
  
  let _function_val = $.fn.val;
  $.fn.val = function(value) {
    let $comp = $(this);
    if (!$comp.hasClass(CLASSNAME))
      return _function_val.call(this, value);
    else if (value === undefined) 
      return _getValue($comp);
    else {
      _setValue($comp, value);
      return $comp;
    }
  }
  
  function _getValue($comp) {
    let hh = _parseValue($comp.find(".v-timepicker-hh"));
    let mm = _parseValue($comp.find(".v-timepicker-mm"));
     
    if ((hh == null) && (mm == null))
      return "";
    else
      return (hh || "00") + ":" + (mm || "00");
  }
  
  function _setValue($comp, value) {
    let splits = [];
    if (getNull(value) != null)
      splits = value.split(":");
    $comp.find(".v-timepicker-hh").val((splits.length < 1) ? "HH" : splits[0]);
    $comp.find(".v-timepicker-mm").val((splits.length < 2) ? "MM" : splits[1]);
  }
  
  function _parseValue($subcomp) {
    let val = $subcomp.val();
    let result = parseInt(val);
    return isNaN(result) ? null : val;
  }
});