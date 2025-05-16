$(document).on("click", ".v-color-item-box", function(e) {
  var $this = $(this);
  var $picker = $this.closest(".v-color-picker");
  var color = $this.attr("data-color");
  $picker.ColorPicker_SetColor(color);
});

$(document).on("click", ".v-colorpicker-none", function(e) {
  var $picker = $(this).closest(".v-color-picker"); 
  $picker.ColorPicker_SetColor(null);
});

$(document).on("click", ".v-colorpicker-custom", function(e) {
  var $picker = $(this).closest(".v-color-picker"); 
  var $btn = $picker.find(".btn").first();
  
  var $dlg = $("<div/>");
  var $dlgpicker = $("<div/>").appendTo($dlg);
  $dlgpicker.ColorPicker({flat: true});
  $dlgpicker.find(".colorpicker").css("margin", "auto");
  
  $dlg.dialog({
    modal: true,
    width: 400,
    title: itl("@Common.Colors"),
    buttons: [
      {
        text: itl("@Common.Ok"),
        click: _doSelectColor
      },
      {
        text: itl("@Common.Cancel"),
        click: doCloseDialog
      }
    ]
  });

  function _doSelectColor() {
    var c = $dlgpicker.find(".colorpicker_hex input").val();
    $picker.ColorPicker_SetColor(c);
    $dlg.dialog("close");
  }
});

jQuery.fn.ColorPicker_SetColor = function(c) {
  var $picker = $(this);
  var hex = (getNull(c) == null) ? "" : "#" + c;
  $picker.find(".v-color-preview").css("background-color", hex);
  $picker.find("input[type='hidden']").val(c || "");
  $picker.trigger("change", {"selectedColor": hex});
};
