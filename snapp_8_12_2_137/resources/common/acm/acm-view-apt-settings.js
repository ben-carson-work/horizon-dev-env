$(document).ready(function() {
  "use strict";

  $(document).on("view-create", ".apt-view[data-view='settings']", _onViewCreate);
  $(document).on("view-refresh", ".apt-view[data-view='settings']", _onViewRefresh);
  
  function _onViewCreate() {
    var $view = $(this);
    
    ACM.addClickHandler($view.find(".apt-tool-close"), _onToolClick_Close);
    ACM.addClickHandler($view.find(".apt-tool-exits"), _onToolClick_Exits);
    ACM.addClickHandler($view.find(".apt-tool-config"), _onToolClick_Config);
    ACM.addClickHandler($view.find(".apt-tool-restart"), _onToolClick_Restart);
  }
    
  function _onViewRefresh() {
    let $view = $(this);
    
    $view.find(".apt-tool-exits").setClass("disabled", !rights.ExitQtyManualInput);
    $view.find(".apt-tool-config").setClass("disabled", !rights.AccessPointConfigurationChange); 
  }
    
  function _onToolClick_Close(event, ui) {
    ACM.activateDefaultView(ui.$apt);
  }
  
  function _onToolClick_Exits(event, ui) {
    inputDialog(itl("@AccessPoint.ExitsManualInput"), itl("@AccessPoint.NumberOfExits"), null, 0, false, function(value) {
      var intValue = parseInt(value);
      if (isNaN(intValue))
        showIconMessage("warning", itl("@AccessPoint.InsertValidNumber"));
      else {
        vgsBroadcastCommand(true, ui.apt.ControllerWorkstationId, "AccessPoint", {
          Command: "InsertManualRotation",
          InsertManualRotation: {
            AccessPointId: ui.apt.AccessPointId,
            ForceUserAccountId: loggedUserAccountId,
            ExitCount: intValue
          }
        });
        ACM.activateDefaultView(ui.$apt);
      }
    });
  }
  
  function _onToolClick_Config(event, ui) {
    var $dlg = $("#dlg-apt-changestatus");
    var $entryControl = $dlg.find("#EntryControl");
    var $reentryControl = $dlg.find("#ReentryControl");
    var $exitControl = $dlg.find("#ExitControl");
    var $bioCheckLevel = $dlg.find("#BiometricCheckLevel");
    var $bioRedemptionTrigger = $dlg.find("#BiometricRedemptionTrigger");
    
    var status = ui.$apt.data("status");
    $entryControl.val(status.EntryControl);
    $reentryControl.val(status.ReentryControl);
    $exitControl.val(status.ExitControl);
    $bioCheckLevel.val(status.BiometricCheckLevel);
    $bioRedemptionTrigger.val(status.BiometricRedemptionTrigger);
    
    $dlg.dialog({
      title: itl("@Common.Status"),
      width: 640,
      buttons: [
        {
          text: itl("@Common.Ok"),
          click: function() {
            resetSupervisor();
            vgsBroadcastCommand(true, ui.apt.ControllerWorkstationId, "AccessPoint", {
              Command: "ChangeConfig",
              ChangeConfig: {
                AccessPointIDs: ui.apt.AccessPointId,
                ForceUserAccountId: loggedUserAccountId,
                EntryControl: $entryControl.val(),
                ReentryControl: $reentryControl.val(),
                ExitControl: $exitControl.val(),
                BiometricCheckLevel: $bioCheckLevel.val(),
                BiometricRedemptionTrigger: $bioRedemptionTrigger.val()
              }
            });
            $dlg.dialog("close");
            ACM.activateDefaultView(ui.$apt);
          }
        },
        {
          text: itl("@Common.Cancel"),
          click: doCloseDialog
        }
      ]
    });
  }
  
  function _onToolClick_Restart(event, ui) {
    confirmDialog(null, function() {
      vgsBroadcastCommand(false, ui.apt.ControllerWorkstationId, "Workstation", {Command: "RestartApplication"});
      ACM.activateDefaultView(ui.$apt);
    }); 
  }
});