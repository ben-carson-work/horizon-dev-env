$(document).on("mousedown", ".v-switch", function() {
  $(this).not("[disabled='disabled']").toggleClass("v-switch-on");
});
