$(document).ready(function() {
  const CLASSNAME = "input-upload-drop";
  const INITIALIZED = "input-upload-drop-initialized"; 
  
  snpObserver.registerListener(CLASSNAME, INITIALIZED, function($node) {
    let initConfig = getNull($node.attr("data-value"));
    if (initConfig != null)
      $node.val(initConfig);
    $node.removeAttr("data-value");
  });

  let _function_valObject = $.fn.valObject;
  $.fn.valObject = function(value) {
    let $comp = $(this);
    if (!$comp.is(".input-upload-drop")) 
      return _function_valObject.call(this, value);
    else {
      if (typeof value == "undefined") { 
        let fileContentBase64 = $comp.data("data-file");
        if (fileContentBase64 == null)
          return null;
        else {
          return { 
            "FileName": $comp.find(".input-upload-drop-filename").val(),
            "FileContentBase64": fileContentBase64
          };
        }
      }
      else if (typeof value == "string") 
        $comp.val(JSON.parse(value));
      else {
        let fileName = (value === null) ? "" : value.FileName;
        let fileContentBase64 = (value === null) ? null : value.FileContentBase64;
        let $txtFileName = $comp.find(".input-upload-drop-filename"); 
        $txtFileName.val(fileName);
        $txtFileName.change();
        $comp.data("data-file", fileContentBase64);
      }
    }
  };

  let _function_val = $.fn.val;
  $.fn.val = function(value) {
    let $comp = $(this);
    if (!$comp.is(".input-upload-drop")) 
      return _function_val.call(this, value);
    else {
      if (typeof value == "undefined") {
        let obj = $comp.valObject();
        return (obj == null) ? "" : JSON.stringify(obj);
      }
      else 
        $comp.valObject(value);  
    }
  };

  function _getFileBase64(file, callback) {
    const reader = new FileReader();
    reader.readAsBinaryString(file);
    reader.onload = function(event) {
      callback(btoa(event.target.result));
    };
  }
  
  function _getDragCounter(comp) {
    return strToIntDef($(comp).attr("data-dragcounter"), 0);
  }
  
  function _setDragCounter(comp, value) {
    $(comp).attr("data-dragcounter", value);
  }
  
  function _setUploadFile(comp, file) {
    let $comp = $(comp);
    $comp.find(".input-upload-drop-filename").val(file.name).change();
    $comp.addClass("drop-spinner");
    
    _getFileBase64(file, function(base64) {
      $comp.data("data-file", base64);
      $comp.removeClass("drop-spinner");
    });
  }
    
  $(document).on("dragenter", ".input-upload-drop", function(e) {
    let $comp = $(this); 
    _setDragCounter($comp, _getDragCounter($comp) + 1);
    $comp.addClass("drag-over");
  });

  $(document).on("dragleave", ".input-upload-drop", function(e) {
    let $comp = $(this);
    let counter = _getDragCounter($comp) - 1;
    _setDragCounter($comp, counter);
    if (counter == 0) 
      $comp.removeClass("drag-over");
  });
  
  $(document).on("dragover", ".input-upload-drop", function(e) {
    e.stopPropagation();
    e.preventDefault();
  });
  
  $(document).on("drop", ".input-upload-drop", function(e) {
    e.stopPropagation();
    e.preventDefault();
    let $comp = $(this);
    _setDragCounter($comp, 0);
    $comp.removeClass("drag-over");
      
    let files = e.originalEvent.dataTransfer.files;
    if (files.length > 0) 
      _setUploadFile($comp, files[0]);
  });
   
  $(document).on("click", ".input-upload-drop-browse-button", function() {
    let $comp = $(this).closest(".input-upload-drop");
    $("<input type='file'/>").trigger("click").change(function() {
      _setUploadFile($comp, this.files[0]);
    }); 
  });

  $(document).on("click", ".input-upload-drop-clear-button", function() {
    let $comp = $(this).closest(".input-upload-drop");
    $comp.find(".input-upload-drop-filename").val('').change();
    $comp.data("data-file", null);
    $comp.attr("data-dragcounter", 0);
  });
  
  $(document).on("change", ".input-upload-drop-filename", function() {
    let $comp = $(this);
    let $btn = $comp.closest(".input-group").find(".input-upload-drop-clear-button");
    if ($comp.val()) 
      $btn.prop("disabled", false);      
    else 
      $btn.prop("disabled", true);
  });  
});

