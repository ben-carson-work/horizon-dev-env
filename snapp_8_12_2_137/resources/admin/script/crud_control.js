$(document).ready(function() {
  
  var _function_val = $.fn.val;
  $.fn.val = function(value) {
    var $this = $(this);

    if ($this.is(".v-crud-group-control")) {
      var $controls = $this.find(".v-crud-control");
      var result = "";
      for (var i=0; i<$controls.length; i++) {
        if (i > 0)
          result += "/";
        result += $($controls[i]).val();
      }
      return result;
    }

    if ($this.is(".v-crud-control")) {
      var c = _encodeItem($this.find(".v-crud-item[data-crud-value='create']"), "C");
      var r = _encodeItem($this.find(".v-crud-item[data-crud-value='read']"),   "R");
      var u = _encodeItem($this.find(".v-crud-item[data-crud-value='update']"), "U");
      var d = _encodeItem($this.find(".v-crud-item[data-crud-value='delete']"), "D");
      return c + r + u + d;
    }

    return _function_val.call(this, value);
  };
  
  function _encodeItem($item, ch) {
    return ($item.attr("data-selected") == "true") ? ch : "_";
  }

  $(document).on("click", ".v-crud-item", function() {
    var $item = $(this);
    var sel = !($item.attr("data-selected") === "true");
    $item.attr("data-selected", sel);
  });
});
