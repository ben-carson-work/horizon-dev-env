/**
 * attribute "data-limit-extension" to enlist the only acceptable comma separated file extensions.
 */

$(document).ready(function() {
  const CLASSNAME = "v-upload-tile";
  const INITIALIZED = "v-upload-tile-initialized"; 
    
  $.fn.uploadTile_SetData = _uploadTile_SetData;
  $.fn.uploadTile_GetData = _uploadTile_GetData;

  snpObserver.registerListener(CLASSNAME, INITIALIZED, function($comp) {
    let $empty = $("<div class='v-upload-tile-empty'><i class='fa fa-cloud-plus'></i></div>").appendTo($comp);
    let $loading = $("<div class='v-upload-tile-loading'><i class='fa fa-circle-notch fa-spin fa-fw'></i>").appendTo($comp);
    let $preview = $("<div class='v-upload-tile-preview'></div>").appendTo($comp);
    let $info = $("<div class='v-upload-tile-info'><div class='v-upload-tile-info-filename'></div><div class='v-upload-tile-info-filesize'></div></div>").appendTo($comp);
    let $topbar = $("<div class='v-upload-tile-topbar'></div>").appendTo($comp);
    let $btnClear = $("<div class='v-upload-tile-topbar-item v-upload-tile-topbar-item-clear'><i class='fa fa-xmark'></i></div>").appendTo($topbar);
    let $btnDownload = $("<div class='v-upload-tile-topbar-item v-upload-tile-topbar-item-download'><i class='fa fa-cloud-arrow-down'></i></div>").appendTo($topbar);

    $empty.click(_onUploadClick);
    $btnClear.click(_onClearClick);
    $btnClear.attr("title", itl("@Common.Clear"));
    $btnDownload.click(_onDownloadClick);
    $btnDownload.attr("title", itl("@Common.Download"));
    
    $comp.fileDrop({
      dragOverClassName: "v-upload-tile-dragover",
      onDrop: function(files) {
        $comp.uploadTile_SetData(files[0]);
      }
    });
    
    let dataValue = $comp.attr("data-value");
    if (dataValue) {
      $comp.uploadTile_SetData(JSON.parse(dataValue));
      $comp.removeAttr("data-value");
    }
    else {
      $comp.uploadTile_SetData({
        "iconAlias": $comp.attr("data-iconalias"),
        "iconColor": $comp.attr("data-iconcolor"),
        "content": $comp.attr("data-content") 
      });
    }
  });
  
  function _onClearClick() {
    $(this).closest(".v-upload-tile").uploadTile_SetData(null);
  }
  
  function _onUploadClick() {
    const $comp = $(this).closest(".v-upload-tile");
    $comp.addClass("v-upload-status-loading");

    asyncUploadFile(_buildFilePickerOptions($comp))
        .then(docEditorFiles => $comp.uploadTile_SetData(docEditorFiles[0]))
        .catch(error => {
          _loadingDone($comp);
          if (!isAbortError(error))
            showIconMessage("warning", error);
        });
  }
  
  function _buildFilePickerOptions(comp) {
    const $comp = $(comp);

    let result = {
      id: $comp.attr("id")
    };

    const limitExt = $comp.attr("data-limit-extension");
    if (limitExt) {
      result.types = [{
        accept: {
          "*/*": limitExt.split(",")
        }
      }];
    }   
    
    return result; 
  }
  
  function _onDownloadClick() {
    const $comp = $(this).closest(".v-upload-tile");
    const docEditorFile = $comp.uploadTile_GetData();
    const blob = _createBlob(docEditorFile.Content, docEditorFile.ContentType);
    const a = document.createElement("a");
    a.href = URL.createObjectURL(blob);
    a.download = docEditorFile.FileName;
    document.body.appendChild(a);
    try {
      a.click();
    }
    finally {
      document.body.removeChild(a);
    }
  }
  
  function _createBlob(contentBase64, contentType) {
    const byteCharacters = atob(contentBase64);

    const byteNumbers = new Array(byteCharacters.length);
    for (let i = 0; i < byteCharacters.length; i++)
      byteNumbers[i] = byteCharacters.charCodeAt(i);

    const byteArray = new Uint8Array(byteNumbers);
    
    return new Blob([byteArray], {type: contentType});
  }
  
  function _loadingDone(comp) {
    $(comp).removeClass("v-upload-status-loading");
  }

  /**
   * data = com.vgs.snapp.dataobject.DODocEditorFile
   */
  function _uploadTile_SetData(docEditorFile) {
    let $comp = $(this);
    _loadingDone($comp);
    
    _assertValidFile($comp, docEditorFile, function() {
      $comp.data("docEditorFile", docEditorFile);
      
      docEditorFile = docEditorFile || {};
      
      $comp.setClass("v-upload-status-empty", !(docEditorFile.Content));
  
      let icon = _calcIcon(docEditorFile.FileName);    
      $comp.attr("title", docEditorFile.FileName);
      $comp.find(".v-upload-tile-preview").html("<i class='fa fa-" + icon.iconAlias + "' style='color:" + icon.iconColor + "'></i>");
      $comp.find(".v-upload-tile-info-filename").text(docEditorFile.FileName);
      $comp.find(".v-upload-tile-info-filesize").text(getSmoothSize(docEditorFile.FileSize));
    }); 
  }

  function _uploadTile_GetData() {
    let docEditorFile = $(this).data("docEditorFile");
    if ((docEditorFile) && (docEditorFile.Content))
      return docEditorFile;
    else
      return null;
  }
  
  function _assertValidFile(comp, docEditorFile, callback) {
    let $comp = $(comp);
    let result = true;
    
    if ((docEditorFile) && (docEditorFile.Content)) {
      let limitExt = $comp.attr("data-limit-extension");
      if (limitExt) {
        let ext = "." + extractFileExtension(docEditorFile.FileName);
        if (limitExt.split(",").indexOf(ext) < 0) {
          result = false;
          showIconMessage("warning", "Unsupported file extension: " + ext)
        }
      }
    }
    
    if (result)
      callback();   
  }
  
  function _calcIcon(fileName) {
    const MAP_ICON = {
      "doc":  {iconAlias:"file-word",  iconColor:"var(--base-blue-color)"},
      "docx": {iconAlias:"file-word",  iconColor:"var(--base-blue-color)"},
      "xls":  {iconAlias:"file-excel", iconColor:"var(--base-green-color)"},
      "xlsx": {iconAlias:"file-excel", iconColor:"var(--base-green-color)"},
      "ppt":  {iconAlias:"file-ppt",   iconColor:"var(--base-red-color)"},
      "pdf":  {iconAlias:"file-pdf",   iconColor:"var(--base-red-color)"}
    };
    
    let ext = extractFileExtension(fileName);
    return MAP_ICON[ext] || {iconAlias:"file", iconColor:"var(--base-gray-color)"};
  }
});