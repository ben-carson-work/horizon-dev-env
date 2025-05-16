$(document).ready(function() {
  "use strict";

  var viewManualInputSelector = ".apt-view[data-view='manual-input']";
  $(document).on("view-create", viewManualInputSelector, _onViewCreate);
  $(document).on("view-activate", viewManualInputSelector, _onViewActivate);
  
  function _onViewCreate() {
    var $view = $(this);
    ACM.addClickHandler($view.find(".apt-tool-close"), _onToolClick_Close);
    ACM.addClickHandler($view.find(".apt-tool-confirm"), _onToolClick_Confirm);
    ACM.addClickHandler($view.find(".apt-tool-inputtype-media"), _onToolClick_InputType_Media);
    ACM.addClickHandler($view.find(".apt-tool-inputtype-document"), _onToolClick_InputType_Document);
    
    $view.find("#txt-input").keyup(_onInputKeyUp);
    
    $view.find(".apt-tool-inputtype").setClass("disabled", !rights.RedemptionInputTypeSwitch);
    // Selecting default input-type
    var $btnInputType = $view.find(".apt-tool-inputtype[data-lookup='" + rights.RedemptionInputTypeDefault + "']");
    if ($btnInputType.length == 0)
      $btnInputType = $view.find(".apt-tool-inputtype-media");
    $btnInputType.addClass("selected")
  }
  
  function _onViewActivate() {
    var $view = $(this);
    $view.find(".apt-tool-confirm").addClass("disabled");
    
    var $input = $view.find("#txt-input");
    $input.val("");
    $input.focus();
  }
  
  function _onInputKeyUp() {
    var $input = $(this);
    var $view = $input.closest(viewManualInputSelector);
    var disabled = ($input.val().length < BARCODE_MIN_LENGTH);
    
    $view.find(".apt-tool-confirm").setClass("disabled", disabled)
    
    if (!disabled && (event.keyCode == KEY_ENTER)) 
      _validate($input.closest(".apt"));
  }
  
  function _onToolClick_Close(event, ui) {
    ACM.activateDefaultView(ui.$apt);
  }
  
  function _onToolClick_Confirm(event, ui) {
    _validate(ui.$apt);
  }
  
  function _onToolClick_InputType_Media(event, ui) {
    var $view = ui.$apt.find(viewManualInputSelector);
    $view.find(".apt-tool-inputtype-media").addClass("selected");
    $view.find(".apt-tool-inputtype-document").removeClass("selected");
  }
  
  function _onToolClick_InputType_Document(event, ui) {
    var $view = ui.$apt.find(viewManualInputSelector);
    $view.find(".apt-tool-inputtype-media").removeClass("selected");
    $view.find(".apt-tool-inputtype-document").addClass("selected");
  }
  
  function _validate($apt) {
    var $view = $apt.find(viewManualInputSelector);
    var apt = $apt.data("apt");
    var inputText = $view.find("#txt-input").val();
    
    var mediaRead = {};
    if ($view.find(".apt-tool-inputtype-document").is(".selected"))
      mediaRead["Document"] = {"DocumentNumber":inputText};
    else
      mediaRead["MediaCode"] = inputText;
    
    ACM.activateDefaultView($apt);
    
    resetSupervisor();
    vgsBroadcastCommand(true, apt.ControllerWorkstationId, "AccessPoint", {
      "Command": "ExternalScan",
      "ExternalScan": {
        "AccessPointId": apt.AccessPointId,
        "MediaRead": mediaRead
      }
    });
  }
});