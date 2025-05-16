//# sourceURL=mob-dlg-mediapickup.js

$(document).ready(function() {
  window.BLMob.showMediaPickupDialog = showMediaPickupDialog; 
  
  /**
   * params = {
   *   AllowExisting:        boolean, 
   *   AllowNew:             boolean, 
   *   AllowLastMedia:       boolean, // TBI 
   *   AllowVoided:          boolean, 
   *   AlreadyAssignedCodes: String[] 
   * }
   */
  function showMediaPickupDialog(params, callback) {
    params = (params || {});
    params.AlreadyAssignedCodes = (params.AlreadyAssignedCodes || []);

    var $dlg = $("#common-templates .dlg-mediapickup").clone();
    var $input = $dlg.find("input");
    $input.attr("placeholder", itl("@Common.InsertMediaCode")).focus();
    $input.keyup(_onInputKeyUp);
    
    $(document).von($dlg, EVENT_InputRead, function(event, data) {
      _startSearch(data.MediaCode);
    });
    
    if (params.AllowLastMedia !== true)
      $dlg.find(".btn-last").remove();
    
    if (BLMob.DeviceInfo.BarcodeCamera !== true)
      $dlg.find(".btn-camera").remove();
    else {
      $dlg.find(".btn-camera").click(function() {
        snpNative("openCamera", {"OutputType": "barcode"});
      });
    }
    
    var nfcStatus = BLMob.findHardwareStatus("nfc");
    if ((nfcStatus == null) || (nfcStatus.Available !== true) || (nfcStatus.Active === true))
      $dlg.find(".btn-nfc").remove();
    else {
      $dlg.find(".btn-nfc").click(function() {
        snpNative("startHardware", {"HardwareType": "nfc"});
      });
    }
    
    UIMob.showDialog($dlg);
    $input.focus();
    
    $dlg.find(".btn-cancel").click(_doCancel);
    
    $dlg.find(".btn-ok").click(function() {
      _startSearch($input.val());
    });
    
    function _onInputKeyUp(e) {
      $dlg.removeClass("error-mode");
      if (e.keyCode == KEY_ENTER) 
        _startSearch($input.val());
      else if (e.keyCode == KEY_ESC)
        _doCancel();
    }
    
    function _doCancel() {
      UIMob.hideDialog($dlg);
      if (callback)
        callback();
    }
    
    function _showError(msg) {
      $dlg.find(".error-box").text(msg);
      $dlg.addClass("error-mode");
    }
    
    function _mediaCodeAccepted(mediaCode, media) {
      UIMob.hideDialog($dlg);
      if (callback)
        callback({"MediaCode":mediaCode}, media);
    }
    
    function _startSearch(mediaCode) {
      mediaCode = mediaCode || "";
      if (mediaCode.length < 2)
        _showError(itl("@Common.PleaseEnterBarcodeOrTDSSN")); 
      else if (params.AlreadyAssignedCodes.indexOf(mediaCode) >= 0) 
        showError(itl("@Account.MediaLinkedToAnotherAccountError")); 
      else {
        $dlg.addClass("spinner-mode").removeClass("error-mode");
        snpAPI("Media", "Search", {
          "MediaCode": mediaCode
        })
        .finally(function() {
          $dlg.removeClass("spinner-mode");
          $input.val("").focus();
        })
        .then(function(ansDO) {
          var list = ansDO.MediaList || [];
          if (list.length == 0) {
            if (params.AllowNew === true)
              _mediaCodeAccepted(mediaCode, null); 
            else
              _showError(itl("@Common.MediaNotFound"));
          }
          else {
            var media = list[0];
            if (params.AllowExisting !== true)
              _showError(itl("@Common.MediaAlreadyExists")); 
            else if ((params.AllowVoided !== true) && (media.MediaStatus > goodTicketLimit))
              _showError(itl("@Common.MediaIsVoided")); 
            else
              _mediaCodeAccepted(mediaCode, media);
          }
          
        })
        .catch(function(error) {
          _showError(error);
        });
      }
    }
  }

});
