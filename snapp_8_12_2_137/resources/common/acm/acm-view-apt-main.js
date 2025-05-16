$(document).ready(function() {
  "use strict";
  
  const valres_MediaNotFound = 102;
  const valres_BiometricCheckFailed = 326;
  const valres_BiometricNotEnrolled = 335;
  const valres_BiometricCheckDisabled = 341;
  const valres_NeedIDVerification = 342;
  const valres_NeedManualVerification = 344;

  const overrideType_BioOverride = 70;
  const overrideType_BioManualEnrollmentReEnrollment = 80;
  
  const bioFunction_Override = 10;
  const bioFunction_Enroll = 20;
  const bioFunction_ReEnroll = 30;

  var overrideDialog = null;
  var overrideBioDialog = null;
  
  var viewSelector_Main = ".apt-view[data-view='main']";
  $(document).on("view-create", viewSelector_Main, _onViewCreate);  
  $(document).on("view-refresh", viewSelector_Main, _onViewRefresh);
  
  function _onViewCreate() {
    var $view = $(this);
    var $apt = $view.closest(".apt");
    var apt = $apt.data("apt") || {};
    var listSpecialProduct = apt.SpecialProductList || [];
    
    ACM.addClickHandler($view.find(".apt-pic"), _onClick_Picture);

    ACM.addClickHandler($view.find(".apt-tool-info"), _onToolClick_Info);
    ACM.addClickHandler($view.find(".apt-tool-manualinput"), _onToolClick_ManualInput);
    ACM.addClickHandler($view.find(".apt-tool-override"), _onToolClick_Override);
    ACM.addClickHandler($view.find(".apt-tool-bio"), _onToolClick_Biometric);
    ACM.addClickHandler($view.find(".apt-tool-manual-verification-ok"), _onToolClick_ManualVerificationOk);
    ACM.addClickHandler($view.find(".apt-tool-manual-verification-fail"), _onToolClick_ManualVerificationFail);
    ACM.addClickHandler($view.find(".apt-tool-rot"), _onToolClick_SkipRotation);
    ACM.addClickHandler($view.find(".apt-tool-settings"), _onToolClick_Settings);
    
    var $btnSpecial = $view.find(".apt-tool-special").setClass("disabled", listSpecialProduct.length == 0);
    ACM.addClickHandler($btnSpecial, _onToolClick_SpecialProduct);
  }
  
  function isAdmissionOverridable(overrideType, valres) {
    let res =
        (rights.PermittedOverrides != undefined) &&
        (rights.PermittedOverrides.includes(overrideType)) && 
        (valres.ResultCode != valres_BiometricCheckFailed) &&
        (valres.ResultCode != valres_BiometricNotEnrolled) &&
        (valres.ResultCode != valres_BiometricCheckDisabled);
    return res;
  }
    
  function isBiometricOverridable(overridableType, valres, bioFunctions) {
    let valresOk = 
      (valres.ResultCode == valres_BiometricCheckFailed) ||
      (valres.ResultCode == valres_BiometricNotEnrolled) ||
      (valres.ResultCode == valres_BiometricCheckDisabled);
    
    let res = 
      ((rights.PermittedOverrides != undefined) && (rights.PermittedOverrides.includes(overrideType_BioOverride))) && (overridableType == overrideType_BioOverride) && (bioFunctions.includes(bioFunction_Override)) ||
      (valresOk && (rights.PermittedOverrides != undefined) && (rights.PermittedOverrides.includes(overrideType_BioOverride)) && (bioFunctions.includes(bioFunction_Override))) ||
      (valresOk && (bioFunctions.includes(bioFunction_Enroll))   && rights.AllowManualEnrollOnInvalidBioEnrollmen) ||
      (valresOk && (bioFunctions.includes(bioFunction_ReEnroll)) && rights.AllowManualReEnrollOnFailedBioCheck);
    return res;
  }
  
  function _onViewRefresh() {
    var $view = $(this);
    var $apt = $view.closest(".apt");
    var status = $apt.data("status") || {};
    var valres = status.LastValidateResult || {};
    var overridableType = status.LastResOverrideType;
    
    var match = valres.Match || {};
    var ticket = valres.Ticket || {};
    var lastGoodUsage = ticket.LastUsage || {};
    let resultStatus = _decodeResultStatus(status);
    let biometricFunctions = filterBiometricFunctionsByRights(status.BiometricFunctions ? status.BiometricFunctions.split(",").map(Number) : []);

    $view.find(".apt-line-result").attr("data-resultstatus", resultStatus).text(valres.OperatorMsg || "");
    $view.find(".apt-line-action").attr("data-resultstatus", (resultStatus == "more-info") ? "more-info" : "").text(status.ActionMessage || "");
    $view.find(".apt-line-account").text(match.AccountDisplayName || "");
    $view.find(".apt-line-product").text(ticket.ProductName || "");
    
    let overrideEnabled = !status.OverrideTimeExpired && isAdmissionOverridable(overridableType, valres);
    let bioOverrideEnabled = rights.Biometric && isBiometricOverridable(overridableType, valres, biometricFunctions) && !status.OverrideTimeExpired
    let changePerf = (status.LastValidateResult > 100) && rights.ChangeToCurrentPerformance && ticket.TicketId;
    let manualVerification = (valres.ResultCode == valres_NeedIDVerification) || (valres.ResultCode == valres_NeedManualVerification);
    
    if (!overrideEnabled && (overrideDialog != null)) {
      overrideDialog.dialog("close");
      overrideDialog = null;
    }
    
    if (!bioOverrideEnabled && (overrideBioDialog != null)) {
      overrideBioDialog.dialog("close");
      overrideBioDialog = null;
    }
    
    let overrideMenu = (status.ResultStatus != 10/*good*/) && (overrideEnabled || changePerf) && !bioOverrideEnabled;

    $view.find(".apt-tool-manual-verification-ok").setClass("hidden", !manualVerification).setClass("disabled", false); 
    $view.find(".apt-tool-manual-verification-fail").setClass("hidden", !manualVerification).setClass("disabled", false);
    $view.find(".apt-tool-override").setClass("hidden", manualVerification).setClass("disabled", !overrideMenu); 
    $view.find(".apt-tool-bio").setClass("hidden", manualVerification).setClass("disabled", !bioOverrideEnabled);
    $view.find(".apt-tool-rot").setClass("disabled", !status.RotationEnabled);
    $view.find(".apt-tool-info").setClass("disabled", ticket.TicketId == null);
    
    var perfDesc = "";
    if (valres.ResultCode == valres_MediaNotFound)
      perfDesc = "";
    else { 
      if (lastGoodUsage.UsageDateTime)
        perfDesc = formatDate(lastGoodUsage.UsageDateTime) + " - " + formatTime(lastGoodUsage.UsageDateTime) + " | " + lastGoodUsage.EventName;
      else   
        perfDesc = itl("@Entitlement.FirstUsage");
    }

    $view.find(".apt-line-performance").text(perfDesc);
    
    var bkgImg = (match.ProfilePictureId) ? "url('" + calcRepositoryURL(match.ProfilePictureId, "small")  + "')" : "";
    $view.find(".apt-pic").css("background-image", bkgImg);    
  }
  
  function _decodeResultStatus(status) {
    if (status.ResultStatus == 10)  
      return "good";
    if (status.ResultStatus == 20) 
      return "bad";
    if (status.ResultStatus == 30) 
      return "reentry";
    if (status.ResultStatus == 40) 
      return "more-info";
    return "";
  }
  
  function _sendManualVerification(ui, approved) {
    let loggetSupAccountId = supAccountId;
    resetSupervisor();
    vgsBroadcastCommand(true, ui.apt.ControllerWorkstationId, "AccessPoint", {
      Command: "ManualVerification",
      ManualVerification: {
        AccessPointId: ui.apt.AccessPointId,
        ForceUserAccountId: loggedUserAccountId,
        ForceSupAccountId: loggetSupAccountId,
        Approved: approved
      }
    });
  }
  
  function _doOperatorOverride($apt, apt) {
    let loggetSupAccountId = supAccountId;
    resetSupervisor();
    vgsBroadcastCommand(true, apt.ControllerWorkstationId, "AccessPoint", {
      Command: "OperatorOverride",
      OperatorOverride: {
        AccessPointId: apt.AccessPointId,
        ForceUserAccountId: loggedUserAccountId,
        ForceSupAccountId: loggetSupAccountId
      }
    });
  }
  
  function _doOperatorReEnrollment($apt, apt) {
    let loggetSupAccountId = supAccountId;
    resetSupervisor();
    vgsBroadcastCommand(true, apt.ControllerWorkstationId, "AccessPoint", {
      Command: "OperatorReEnrollment",
      OperatorReEnrollment: {
        AccessPointId: apt.AccessPointId,
        ForceUserAccountId: loggedUserAccountId,
        ForceSupAccountId: loggetSupAccountId
      }
    });
  }  
  
  function _doOperatorEnrollment($apt, apt) {
    let loggetSupAccountId = supAccountId;
    resetSupervisor();
    vgsBroadcastCommand(true, apt.ControllerWorkstationId, "AccessPoint", {
      Command: "OperatorEnrollment",
      OperatorEnrollment: {
        AccessPointId: apt.AccessPointId,
        ForceUserAccountId: loggedUserAccountId,
        ForceSupAccountId: loggetSupAccountId
      }
    });
  }   
  
  function _operatorOverride($apt, apt, bio) {
    if (rights.AskConfirmationOnOverride) {
      let status = $apt.data("status") || {};
      let overrideTypeDesc = status.LastResOverrideTypeDesc || "";
      
      if (!bio) {
        overrideDialog = confirmDialog(itl("@AccessPoint.OverrideConfMsg", overrideTypeDesc), 
          function() {
            overrideDialog = null;   
            _doOperatorOverride($apt, apt);
          }, 
          function() {
            overrideDialog = null
          }
        );
      }
      else {
        overrideBioDialog = confirmDialog(itl("@AccessPoint.OverrideConfMsg", overrideTypeDesc), 
          function() {
            overrideBioDialog = null;   
            _doOperatorOverride($apt, apt);
          }, 
          function() {
            overrideBioDialog = null
          }
        );
      }
    }
    else
      _doOperatorOverride($apt, apt);
  }
  
  function _changeToCurrentPerformance($apt, apt) {
    let loggetSupAccountId = supAccountId;
    resetSupervisor();
    vgsBroadcastCommand(true, apt.ControllerWorkstationId, "AccessPoint", {
      Command: "ChangeToCurrentPerformance",
      ChangeToCurrentPerformance: {
        AccessPointId: apt.AccessPointId,
        ForceUserAccountId: loggedUserAccountId,
        ForceSupAccountId: loggetSupAccountId
      }
    });
  }
  
  function _onClick_Picture(event, ui) {
    if (hasDocReader) {
      var status = ui.$apt.data("status") || {};
      var valres = status.LastValidateResult || {};
      var match = valres.Match || {};
      
      if (match.AccountId) {
        confirmDialog(itl("@Account.UpdateAccountDataQuestion"), function() {
          var reqDO = {
            Command: "DocReaderExecute",
            DocReaderExecute: {
              Account: {AccountId: match.AccountId}
            }
          };
          
          showWaitGlass();
          vgsService("Plugin", reqDO, false, function(ansDO) {
            ui.$apt.find(".apt-pic").css("background-image", "url(data:image/" + ansDO.Answer.DocReaderExecute.DocumentRead.PictureFormat + ";base64," + ansDO.Answer.DocReaderExecute.DocumentRead.ProfilePicture + ")");
            if (ansDO.Answer.DocReaderExecute.DocumentRead.StorablePicture) {
              let reqAccDO = {
                Command: "SaveAccount",
                SaveAccount: {
                  AccountId: match.AccountId, 
                  NewProfilePicture: ansDO.Answer.DocReaderExecute.DocumentRead.ProfilePicture
                }
              };
              vgsService("Account", reqAccDO, false, function() {
                hideWaitGlass();
              }); 
            }
            else
              hideWaitGlass();
          });
        });
      }
    }
  }
  
  function _onToolClick_Info(event, ui) {
    ACM.setActiveView(ui.$apt, "info");
  }
  
  function _onToolClick_ManualInput(event, ui) {
    ACM.setActiveView(ui.$apt, "manual-input");
  }
  
  function _onToolClick_SpecialProduct(event, ui) {
    var list = ui.apt.SpecialProductList || [];
    
    if (list.length == 1) 
      ACM.useSpecialProduct(ui.$apt, list[0]);
    else if (list.length > 1) 
      ACM.setActiveView(ui.$apt, "special-product");
  }
  
  function _onToolClick_Override(event, ui) {
    ui.$apt.find(".apt-tool-override").setClass("disabled", true);
    let status = ui.$apt.data("status") || {};
    let valres = status.LastValidateResult || {};
    var ticket = valres.Ticket || {};
    let overridableType = status.LastResOverrideType || {};
    let overrideTypeDesc = status.LastResOverrideTypeDesc || "";
    let biometricFunctions = filterBiometricFunctionsByRights(status.BiometricFunctions ? status.BiometricFunctions.split(",").map(Number) : []);
    var overrideEnabled = isAdmissionOverridable(overridableType, valres) && !isBiometricOverridable(overridableType, valres, biometricFunctions);
    
    var options = [];
    
    if (overrideEnabled) { 
      options.push({
        "key": "override",
        "title": itl("@Lookup.TicketUsageUserType.OperatorOverride") + " - " + overrideTypeDesc,
        "iconAlias": "arrow-circle-up"
      });
    }
    if (rights.ChangeToCurrentPerformance && ticket.TicketId) { 
      options.push({
        "key": "change-performance",
        "title": itl("@Ticket.ChangeToCurrentPerformance"),
        "iconAlias": "calendar-alt"
      });
    }
    options.push({
      "title": itl("@Common.Cancel"),
      "iconAlias": "times"
    });
    
    ACM.showOptionDialog(itl("@Common.Options"), options, function(index, option) {
      if (option.key == "override") 
        _operatorOverride(ui.$apt, ui.apt, false);
      else if (option.key == "change-performance") 
        _changeToCurrentPerformance(ui.$apt, ui.apt);
      else {
        ui.$apt.find(".apt-view").trigger("view-refresh");
      }
    });
  }

  function filterBiometricFunctionsByRights(functions) {
    let result = []
    if (functions.includes(bioFunction_Enroll) && rights.AllowManualEnrollOnInvalidBioEnrollmen)
      result.push(bioFunction_Enroll);
      
    if (functions.includes(bioFunction_ReEnroll) && rights.AllowManualReEnrollOnFailedBioCheck)
      result.push(bioFunction_ReEnroll);
    
    if (functions.includes(bioFunction_Override)&& ((rights.PermittedOverrides != undefined) && (rights.PermittedOverrides.includes(overrideType_BioOverride))))
      result.push(bioFunction_Override);
    
    return result;
  }  
  
  function _onToolClick_Biometric(event, ui) {
    ui.$apt.find(".apt-tool-bio").setClass("disabled", true);
    let status = ui.$apt.data("status") || {};
    let biometricFunctions = filterBiometricFunctionsByRights(status.BiometricFunctions ? status.BiometricFunctions.split(",").map(Number) : []);
		_showOperationPopupIfNeeded(biometricFunctions, status, ui)
  }
  
  function _showOperationPopupIfNeeded(biometricFunctions, status, ui) {
		let overrideTypeDesc = status.LastResOverrideTypeDesc || "";
		var options = [];
		if (biometricFunctions.includes(bioFunction_Override)) {
			options.push({
	        "key": bioFunction_Override,
    	    "title": itl("@Lookup.TicketUsageUserType.OperatorOverride") + " - " + overrideTypeDesc,
	        "iconAlias": "arrow-circle-up"
    	});
		}	
		
  	if (biometricFunctions.includes(bioFunction_ReEnroll)) {
  		options.push({
          "key": bioFunction_ReEnroll,
          "title": itl("@Lookup.TicketUsageUserType.BiometricManualReEnroll") + " - " + overrideTypeDesc,
          "iconAlias": "face-viewfinder"
        });
    }
       
    if (biometricFunctions.includes(bioFunction_Enroll)) {
      options.push({
          "key": bioFunction_Enroll,
          "title": itl("@Lookup.TicketUsageUserType.BiometricManualEnroll") + " - " + overrideTypeDesc,
          "iconAlias": "face-viewfinder"
        });        
  	}
		
  	if(biometricFunctions.length == 1) {
        let action = biometricFunctions[0];
        executeDialogAction(action, ui)
    }
  	else {
      ACM.showOptionDialog(itl("@Common.Options"), options, function(index, option) {
        executeDialogAction(option.key, ui)
      });      
     }			
	}
	
	function executeDialogAction(action, ui) {
    if (action == bioFunction_Override) 
      _operatorOverride(ui.$apt, ui.apt, false);
    else if (action == bioFunction_ReEnroll) 
      _doOperatorReEnrollment(ui.$apt, ui.apt);
    else if (action == bioFunction_Enroll) 
      _doOperatorEnrollment(ui.$apt, ui.apt);      
    else {
      ui.$apt.find(".apt-view").trigger("view-refresh");
    }
  }
  
  function _onToolClick_ManualVerificationOk(event, ui) {
    ui.$apt.find(".apt-tool-manual-verification-ok").setClass("disabled", true);
    ui.$apt.find(".apt-tool-manual-verification-fail").setClass("disabled", true);
    _sendManualVerification(ui, true);
  }
  
  function _onToolClick_ManualVerificationFail(event, ui) {
    ui.$apt.find(".apt-tool-manual-verification-fail").setClass("disabled", true);
    ui.$apt.find(".apt-tool-manual-verification-ok").setClass("disabled", true);
    _sendManualVerification(ui, false);
  }
  
  function _onToolClick_SkipRotation(event, ui) {
    ui.$apt.find(".apt-tool-rot").setClass("disabled", true);
    vgsBroadcastCommand(true, ui.apt.ControllerWorkstationId, "AccessPoint", {
      Command: "SkipRotation",
      SkipRotation: {
        AccessPointIDs: [ui.apt.AccessPointId]
      }
    });
  }
  
  function _onToolClick_Settings(event, ui) {
    ACM.setActiveView(ui.$apt, "settings");
  }

});