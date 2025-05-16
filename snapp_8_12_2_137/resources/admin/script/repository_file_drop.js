$(document).ready(function(){
  $(document).on("dragenter", ".repository-file-drop", function(e) {
    e.stopPropagation(); 
    e.preventDefault();
    let $this = $(this);
    $this.addClass("drag-over");
    
    let $hint = $this.find(".drag-over-hint");
    if ($hint.length == 0)
      $this.prepend("<div class='drag-over-hint'/>");
  });
  $(document).on("dragover", ".repository-file-drop", function(e) {
    e.stopPropagation();
    e.preventDefault();
  });
  $(document).on("dragleave", ".repository-file-drop", function(e) {
    e.stopPropagation();
    e.preventDefault();
    $(this).removeClass("drag-over");
  });
  $(document).on("drop", ".repository-file-drop", function(e) {
    e.stopPropagation();
    e.preventDefault();
    $(this).removeClass("drag-over");
    
    let $dlg = $("<div class='upload-progress-dialog'><div class='upload-item-list'/></div>");
    
    for (let i=0; i<e.originalEvent.dataTransfer.files.length; i++) 
      doUploadFile(e.originalEvent.dataTransfer.files[i], $("#templates .upload-item-template").clone().appendTo($dlg.find(".upload-item-list")), $(this).attr("data-entityid"), $(this).attr("data-entitytype"));

    $dlg.dialog({
      title: "Uploading...",
      modal: true,
      width: 400,
      close: function() {
        $dlg.remove();
        if ($(".ui-tabs-anchor[data-tabcode='repository']").length == 0)
          window.location.reload();
      }
    });
  });



  function doUploadFile(file, $div, entityId, entityType) {
    let fd = new FormData();
    fd.append('file', file);
    
    $div.find(".txt-name").text(file.name);
    $div.find(".txt-size").text(getSmoothSize(file.size));
    
    $.ajax({
      url: BASE_URL + "/FileUploadServlet?EntityType=" + entityType + "&EntityId=" + entityId,
      type: "POST",
      data: fd,
      cache: false,
      contentType: false,
      processData: false,

      xhr: function() {
        let xhr = new window.XMLHttpRequest();
        xhr.upload.addEventListener("progress", function (evt) {
          if (evt.lengthComputable) {
            let percentComplete = evt.loaded / evt.total;            
            $div.find(".progress-bar").css("width", Math.round(percentComplete * 100) + "%");
          }
        }, false);
        return xhr;
      },

      complete: function() {
        triggerEntityChange(2/*repository*/);
        $div.addClass("upload-completed");
        
        let all = true;
        $div.siblings().each(function(idx, item) {
          if (!$(item).hasClass("upload-completed"))
            all = false;
        });
        
        if (all){
          $div.closest(".ui-dialog").find(".ui-dialog-title").text("Upload completed");
          setTimeout(function(){
            $('.upload-progress-dialog').fadeOut( 2000, function() {
              $('.upload-progress-dialog').dialog('close');
            });
          },3000)
        }
      },
      success: function(data) {
        $div.find(".progress-bar").css("background", "var(--base-green-color)");
      },
      error: function(jqXHR, textStatus, errorThrown) {
        console.log(textStatus + " : " + errorThrown);
        $div.find(".progress-bar").css({"width":"100%", "background":"var(--base-orange-color)"}).text("Unable to upload file");
      }
    });
  }
});
