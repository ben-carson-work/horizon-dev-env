$(document).ready(function() {
  snpObserver.registerListener("[data-visibilitycontroller]", "visibilitycontroller-initialized", function($comps) {
    $comps.each(function() {
      var $comp = $(this);
      var $controller = $($comp.attr("data-visibilitycontroller"));
      $controller.click(() => _refreshEnabled($comp));
      $controller.on("checked-changed", () => _refreshEnabled($comp))
      _refreshEnabled($comp);
    });
  });

  function _refreshEnabled(comp) {
    var $comp = $(comp);
    var $controller = $($comp.attr("data-visibilitycontroller"));
    $comp.setClass("hidden", !$controller.isChecked());
  }
  
  var _function_clone = jQuery.fn.clone;
  jQuery.fn.clone = function() {
    var result = _function_clone.call(this);
    $(result).find(".visibilitycontroller-initialized").removeClass("visibilitycontroller-initialized");
    return result;
  }  

});