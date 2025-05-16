$(document).ready(function() {
  const CLASSNAME = "metafield-picture";
  const INITIALIZED = "metafield-picture-initialized"; 
  
  snpObserver.registerListener(CLASSNAME, INITIALIZED, function($mf) {
    _refreshEnabled($mf);
    $mf.find(".metafield-picture-view-button").click(_onView);
    $mf.find(".metafield-picture-change-button").click(_onChange);
    $mf.find(".metafield-picture-clear-button").click(_onClear);
    $mf.addClass("metafield-picture-initialized");
  });

  var _function_val = $.fn.val;
  $.fn.val = function(value) {
    var $comp = $(this);
    if (!$comp.hasClass(CLASSNAME)) 
      return _function_val.call(this, value);
    else {
      if (typeof value == 'undefined') { 
        value = $comp.data("base64");
        return (value) ? value : "";
      }
      else {
        $comp.data("base64", value);
        _refreshEnabled($comp);
      }
    }
  };

  function _refreshEnabled(comp) {
    var $comp = $(comp);
    var value = $comp.val();
    var readOnly = $comp.attr("readonly") == "readonly";
    $comp.find(".metafield-picture-view-button").setEnabled(!readOnly && (value != ""));
    $comp.find(".metafield-picture-change-button").setEnabled(!readOnly);
    $comp.find(".metafield-picture-clear-button").setEnabled(!readOnly && (value != ""));
  }
  
  function _onView() {
    var $comp = $(this).closest(".metafield-picture");
    var $dlg = $("<div/>").appendTo("body");
    $dlg.css({
      "width": "800px",
      "height": "600px",
      "background-image": "url(data:image/jpg;base64," + $comp.val() + ")",
      "background-repeat": "no-repeat",
      "background-size": "contain",
      "background-position": "center"
    });
    
    $dlg.dialog({
      title: itl("@Common.Preview"),
      resizable: false,
      modal: true,
      width: 800,
      height: 600,
      close: function() {
        $dlg.remove();
      }
    });
  }
  
  function _onChange() {
    var $comp = $(this).closest(".metafield-picture");
    $("<input type='file' accept='image/*'/>").trigger("click").change(function() {
      const file = this.files[0];
      const reader = new FileReader();
      reader.readAsBinaryString(file);
      reader.onload = function(event) {
        $comp.val(btoa(event.target.result));
        $comp.trigger("change");
      };
    });
  }
  
  function _onClear() {
    console.log(this);
    $(this).closest(".metafield-picture").val("");
  }

});