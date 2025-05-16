$(document).ready(function() {
  
  $(document).on("click", ".v-cfgform-field-select", function() {
    let $checkbox = $(this);
    $checkbox.closest(".v-cfgform-field").setClass("selected", $checkbox.isChecked());
  });

});