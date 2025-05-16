$(document).ready(function() {
  var _refresh = function(e) {
    var $this = $(this);
    var $container = $this.closest(".v-filter-container");
    var hasCode = ($this.val() || "") != "";
    var applyAll = $container.find(".v-filter-applyall input[type='checkbox']").isChecked();
    $container.setClass("v-filter-hascode", hasCode);
    $container.setClass("v-filter-hidecond", hasCode && !applyAll);
  };
  
  $(document).on("keyup", ".v-filter-code", _refresh);
  $(document).on("click", ".v-filter-applyall input[type='checkbox']", _refresh);
});