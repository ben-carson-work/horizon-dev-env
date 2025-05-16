
$(document).on("click", ".v-icon-alias", function(e) {
  var $this = $(this)
  if (!$this.is(".disabled")) {
    var handlerId = newStrUUID();
    $this.attr("data-handlerid", handlerId);  
    asyncDialogEasy("../common/iconalias_dialog", "HandlerId=" + handlerId);    
  }
});

$(document).on("change", ".icon-color-block .color-line-picker", function(event, data) {
  console.log(data);
  var $picker = $(this);
  var $iconAlias = $picker.closest(".icon-color-block").find(".v-icon-alias");
  
  if ($picker.is(".color-line-picker-foreground"))
    $iconAlias.css("color", data.selectedColor);

  if ($picker.is(".color-line-picker-background"))
    $iconAlias.css("background-color", data.selectedColor);
});
