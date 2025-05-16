$(document).ready(function() {
  const CLASSNAME = "v-datepicker2";
  const INITIALIZED = "v-datepicker2-initialized"; 

  snpObserver.registerListener(CLASSNAME, INITIALIZED, function($comp) {
    if ($comp.attr("data-template") !== "true")
      initDatePicker($comp);
    else {
      $comp.removeAttr("data-template");
      return false;
    }
  });

});