<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileAdmission" scope="request"/>

<script>
//# sourceURL=mob-adm-tab-redeem-js.jsp

const WARN_VALIDATE_RESULTS = [4/*re-entry*/, 10/*crossover*/, 14/*group-re-entry*/, 71/*re-exit*/];
const MORE_INFO_RESULTS = [324/*NeedBiometricEnrollment*/, 325/*NeedBiometricCheck*/, 342/*NeedIDVerification*/, 354/*NeedGroupQuantity*/];
const RIGHTS_OVERRIDE_TYPES = [<%=JvArray.arrayToString(pageBase.getRights().PermittedOverrides.getArray(), ",")%>];
var redeemRootContent = null;
var redeemActiveContent = null;
var redeemContentHistory = [];
var lastMediaRead_Time = null;
var lastMediaRead_Code = null;

$(document).ready(function() {
  redeemRootContent = $("#redeem-main-tab-content");
  redeemActiveContent = redeemRootContent;
  redeemContentHistory.push(redeemActiveContent);
  
  if (apt.AptEntryControl == <%=LkSNAccessPointControl.Controlled.getCode()%>)
    setScanType("entry");
  else if (apt.AptExitControl == <%=LkSNAccessPointControl.Controlled.getCode()%>)
    setScanType("exit");
  else if (apt.AptEntryControl == <%=LkSNAccessPointControl.Free.getCode()%>)
    setScanType("simulate");
  else
    setScanType("lookup");
      
  if (apt.ServerBiometricLookupType == null)
    $("#tab-header-redeem-idle .btn-face").remove();
  else
    $("#tab-header-redeem-idle .tab-header-title").remove();
  
  var inputTypeDefault = <%=pageBase.getRights().RedemptionInputTypeDefault.isNull() ? LkSNRedemptionInputType.MediaCode.getCode() : pageBase.getRights().RedemptionInputTypeDefault.getInt()%>;
  var inputTypeSwitch = <%=pageBase.getRights().RedemptionInputTypeSwitch.getBoolean()%>;
  
  setManualInputType(inputTypeDefault);
  if (inputTypeSwitch === true) 
    $("#tab-header-redeem-manual .btn-keyboard").remove();
  else
    $("#tab-header-redeem-manual .btn-inputtype").remove();
  
  $("#tab-header-redeem-idle .btn-keyboard").on("click", function() {
    setActiveRedeemHeaderPane("#tab-header-redeem-manual");
    setTimeout(function() {$("#tab-header-redeem-manual input").focus()}, 200);
  });  
  
  $("#tab-header-redeem-manual .btn-keyboard").on("click", function() {
    setActiveRedeemHeaderPane("#tab-header-redeem-idle");
  });  
  
  $("#tab-header-redeem-manual .btn-media").on("click", function() {
    setManualInputType(<%=LkSNRedemptionInputType.DocumentNumber.getCode()%>);
  });  
  
  $("#tab-header-redeem-manual .btn-document").on("click", function() {
    setManualInputType(<%=LkSNRedemptionInputType.MediaCode.getCode()%>);
  });  
  
  function setManualInputType(inputType) {
    var hint = (inputType == <%=LkSNRedemptionInputType.DocumentNumber.getCode()%>) ? itl("@Account.DocumentNumber") : itl("@Common.InsertBarcode");
    var $header = $("#tab-header-redeem-manual");
    $header.attr("data-inputtype", inputType);
    $header.find("input").attr("placeholder", hint).focus();
  }
  
  $(".tab-body").on("<%=pageBase.getEventMouseDown()%>", function() {
    setActiveRedeemHeaderPane("#tab-header-redeem-idle");
  });  
  
  $("#tab-header-redeem-idle .btn-camera").on("<%=pageBase.getEventMouseDown()%>", function() {
    sendCommand("StartBarcodeCamera");
  });  
  
  $("#tab-header-redeem-idle .btn-face").on("<%=pageBase.getEventMouseDown()%>", function() {
    NativeBridge.call("CaptureImageForRedemption", ["doBiometricTemplateRead"], null);
  }); 
  
  $("#tab-header-redeem-idle .btn-usagetype").on("<%=pageBase.getEventMouseDown()%>", function() {
    var scantypes = ["entry", "simulate", "exit", "lookup"];
    var buttons = [
        itl("@Entitlement.Entry"), 
        itl("@AccessPoint.SimulatedEntry"), 
        itl("@Common.Exit"), 
        itl("@Common.Lookup"),
        itl("@Common.Cancel")
    ];
    showMobileQueryDialog(itl("@Ticket.UsageType"), null, buttons, function(index) {
      if (index < scantypes.length) 
        setScanType(scantypes[index]);
    });
  });  
  
  $("#tab-header-redeem-manual input").keydown(function(e) {
    if (event.keyCode == KEY_ENTER) {
      var mediaCode = $(this).val();
      $(this).val("");
      doMediaRead(mediaCode, parseInt($("#tab-header-redeem-manual").attr("data-inputtype")));
      setTimeout(function() {$("input").blur()}, 200);
      event.stopPropagation();
    } 
  });
});

function doMediaRead(mediaCode, inputType) {
  sendCommand("StopRFID");
   
  if ($(".tab-content-container.active-tab").attr("data-tabcode") == "redeem") {
    if (redeemActiveContent == redeemRootContent) {
      if ($(".btn-usagetype").attr("data-scantype") == "lookup") 
        _doPortfolioLookup();
      else {
        doValidate({
          "mediaCode": mediaCode, 
          "inputType": inputType 
        });
      }
    }
    else {
      redeemBackToRootContent();
      _doPortfolioLookup();
    }
  }
  
  function _doPortfolioLookup() {
    var reqDO = {
      Portfolio: {},
      DefaultMedia: {MediaCode: mediaCode},
      DefaultTicket: {SmartCode: mediaCode}
    };
    if (inputType == <%=LkSNRedemptionInputType.DocumentNumber.getCode()%>) 
      reqDO.Portfolio = {Account: {DocumentNumber: mediaCode}};
    else 
      reqDO.Portfolio = {Ticket: {SmartCode: mediaCode}};
    doPortfolioLookup(reqDO);
  }
}

function doBiometricTemplateRead(biometricTemplate) {
  if ($(".tab-content-container.active-tab").attr("data-tabcode") == "redeem") {
    if (redeemActiveContent == redeemRootContent) {
      doValidate({
        "biometricTemplate": unescape(biometricTemplate).replace(/[\n\r]+/g, "").replace(/\s{2,10}/g, " ")
      });
    }
  }
}

function redeemContentSlideCallback(eventType, content) {
  if (eventType == "init") {
    redeemActiveContent = content;
    redeemContentHistory.push(content);
  }
  else if (eventType == "back") {
    redeemContentHistory.pop();
    if (redeemContentHistory.length > 1)
      redeemActiveContent = redeemContentHistory[redeemContentHistory.length - 1];
    else {
      redeemActiveContent = redeemRootContent;
      redeemContentHistory = [redeemRootContent];
    }
  }
}

function redeemBackToRootContent() {
  while (redeemContentHistory.length > 1) 
    redeemContentHistory.pop().remove();
  redeemActiveContent = redeemRootContent;
  redeemRootContent.css({
    "position": "",
    "left": "",
    "right": "",
    "top": "",
    "bottom": ""
  });
}

$(document).on("tabchange", function(event, data) {
  if ((data.newTabCode == "redeem") && (data.newTabCode == data.oldTabCode))
    redeemBackToRootContent();
});

function setActiveRedeemHeaderPane(selector) {
  $("#redeem-main-tab-content .tab-header").addClass("hidden");
  $(selector).removeClass("hidden");
}

var idleTimerTS = 0;
function idleTimer(ts) {
  if (ts == idleTimerTS) 
    setActiveRedeemHeaderPane("#tab-header-redeem-idle");
}

function startIdleTimer() {
  var thisTimeTS = (new Date()).getTime();
  idleTimerTS = thisTimeTS;
  setTimeout(function() {
    idleTimer(thisTimeTS);
  }, 2000);
}

var validateRequestLocked = false;

// params: mediaCode, inputType, biometricTemplate, overrideTypes, skipManualVerification
function doValidate(params) {
  if (validateRequestLocked == true)
    return;
  
  validateRequestLocked = true;
  params = params || {};
  params.overrideTypes = params.overrideTypes || [];
  
  var now = (new Date()).getTime();
  
  if ((lastMediaRead_Code == params.mediaCode) && (now - lastMediaRead_Time < rights.SameMediaReadDelay * 1000) && (params.overrideTypes.length <= 0) && (params.skipManualVerification !== true)) {
    setActiveRedeemHeaderPane("#tab-header-redeem-result");
    $("#tab-header-redeem-result").removeClass("good-result").addClass("bad-result").find(".tab-header-title").text("Same media read delay");
    startIdleTimer();
    validateRequestLocked = false
    sendCommand("StartRFID");
  }  
  else {
    lastMediaRead_Code = params.mediaCode;
    lastMediaRead_Time = now;

    setActiveRedeemHeaderPane("#tab-header-redeem-wait");
    idleTimerTS = 0;
    
    var scanType = $(".btn-usagetype").attr("data-scantype");
    
    reqDO = {
      MediaCodeType : 0,
      SkipBiometricCheck: true,
      SkipManualVerification: params.skipManualVerification,
      BiometricTemplate: params.biometricTemplate,
      RedemptionPoint : {
        AccessPointId : apt.AccessPointId,
        UsageType : (scanType == "exit") ? <%=LkSNTicketUsageType.Exit.getCode()%> : <%=LkSNTicketUsageType.Entry.getCode()%>,
        OperatorCmd : ((scanType == "simulate") || (scanType == "lookup")) ? <%=LkSNAccessPointOperatorCmd.None.getCode()%> : <%=LkSNAccessPointOperatorCmd.UseTicket.getCode()%>,
        OverrideTypes: params.overrideTypes,
        Quantity: params.quantity
      }
    };
    
    var inputTypeField = (params.inputType == <%=LkSNRedemptionInputType.DocumentNumber.getCode()%>) ? "DocumentNumber" : "MediaCode";
    reqDO[inputTypeField] = params.mediaCode;
    
    vgsService("VALIDATE", reqDO, true, function(ansDO) {
      try {
        var errorMsg = getVgsServiceError(ansDO);
        if (isUnauthorizedAnswer(ansDO))
          doLogout();
        else if (errorMsg != null)
          showIconMessage("warning", errorMsg);
        else {
          var ansDO = ansDO.Answer || {};
          var portfolio = ansDO.Match || {};
          var ticket = ansDO.Ticket || {};
          var media = ansDO.Media || {};
          var perf = ansDO.Performance || {};
          var perfTime = ((perf.DateTimeFrom) && (perf.DateTimeFrom.length > 16)) ? perf.DateTimeFrom.substring(11, 16) : "";
          
          $(".valres-item.latest").removeClass("latest need-more-info");
          
          var maxItems = 3;
          var selector = "#redeem-main-tab-content #valres-list .valres-item";
          while ($(selector).length >= maxItems)
            $($(selector)[$(selector).length - 1]).remove();
          
          var item = $("<div class='valres-item latest'/>").prependTo("#redeem-main-tab-content #valres-list").html($("#valres-item-template").html());
          var status = _calcResultStatus(ansDO);
          var rotText = _calcRotText(ansDO);
          
          item.attr("data-status", status);
          item.attr("data-mediacode", params.mediaCode);
          item.attr("data-ticketid", ticket.TicketId);
          item.attr("data-overridetype", ansDO.ResultOverrideType);
          item.attr("data-usedoverridetypes", ansDO.UsedOverrideTypes);
          item.find(".valres-opmsg").text(ansDO.OperatorMsg);
          item.find(".valres-rot").text(rotText);
          item.find(".valres-datetime").text(formatDate(new Date()) + " " + formatTime(new Date()));
          item.find(".valres-mediacode").text(params.mediaCode);
          
          if (portfolio.ProfilePictureId)
            item.addClass("has-profile-picture");
          
          if (ansDO.ResultCode == <%=LkSNValidateResult.MediaNotFound.getCode()%>) {
            var itembody = item.find(".valres-body"); 
            itembody.empty();
            $("<div class='valres-detail-item'/>").appendTo(itembody).text(params.mediaCode);        
          }
          else {
            if (portfolio.ProfilePictureId)
              item.find(".valres-pic").css("background-image", "url(<v:config key="site_url"/>/repository?type=small&id=" + portfolio.ProfilePictureId + ")");
            else 
              item.find(".valres-pic").text(rotText);
            
            item.find(".valres-detail-item-account").text(portfolio.AccountDisplayName);
            item.find(".valres-detail-item-product").text(ticket.ProductName);
            if (ticket.SeatInfo)
              item.find(".valres-detail-item-seat").text(ticket.SeatInfo.SeatName);
            item.find(".valres-detail-item-message").text(ansDO.SpecialMsg);
            item.click(function() {
              doPortfolioLookup({
                Portfolio: {PortfolioId: portfolio.PortfolioId},
                DefaultMedia: {MediaId: media.MediaId},
                DefaultTicket: {TicketId: ticket.TicketId}
              });
            });
          }
          
          setActiveRedeemHeaderPane("#tab-header-redeem-result");
          $("#tab-header-redeem-result").removeClass("good-result bad-result").addClass(status + "-result").find(".tab-header-title").text(ansDO.OperatorMsg);
          
          var notesShown = _showNotesWarnIfNeeded(item, ansDO);
          
          if (ansDO.ResultOverrideType && (RIGHTS_OVERRIDE_TYPES.indexOf(ansDO.ResultOverrideType) >= 0))
            _handleOverride(item, ansDO, notesShown);
          else if (ansDO.ResultCode == <%=LkSNValidateResult.NeedManualVerification.getCode()%>) 
            _handleManualVerification(item, ansDO, notesShown);
          else if (ansDO.ResultCode == <%=LkSNValidateResult.NeedGroupQuantity.getCode()%>)
            _handleGroupQuantity(item, ansDO, notesShown);

          startIdleTimer();
        }
      }
      finally {
        validateRequestLocked = false;
        sendCommand("StartRFID");
      }
    });
  }
  
  function _calcResultStatus(ansDO) {
    if ((WARN_VALIDATE_RESULTS.indexOf(ansDO.ResultCode) >= 0))
      return "warn";
    
    if ((MORE_INFO_RESULTS.indexOf(ansDO.ResultCode) >= 0))
      return "moreinfo";
    
    if (ansDO.ResultCode < 100)
      return "good";
    
    return "bad";
  }
  
  function _calcRotText(ansDO) {
    var rotText = "";
    var ticket = ansDO.Ticket || {};
    
    if ((ansDO.RotationsAllowed || 1) > 1)
      rotText = "#" + ansDO.RotationsAllowed;
    else if (ticket.GroupQuantity > 1) {
      rotText = ticket.GroupQuantity;
      if (getNull(ansDO.GroupEntryCount) != null)
        rotText = ansDO.GroupEntryCount + "/" + rotText;
      rotText = "#" + rotText;
    }
    
    return rotText;
  }
  
  function _handleOverride($item, ansDO, notesShown) {
    $item.addClass("override-allowed");
    $item.find(".btn-override").click(function() {
      showMobileQueryDialog(null, itl("@AccessPoint.OverrideConfMsg", ansDO.ResultOverrideTypeDesc), [itl("@Common.Yes"), itl("Common.No")], function(index) {
        if (index == 0) {
          params.overrideTypes = [ansDO.ResultOverrideType];
          if (ansDO.UsedOverrideTypes)
            params.overrideTypes.push(ansDO.UsedOverrideTypes);
          
          doValidate(params);
          $item.removeClass("override-allowed");
        }
      });
      
      event.stopPropagation();
    });
  }
  
  function _handleManualVerification($item, ansDO, notesShown) {
    var message = ansDO.OperatorMsg || itl("@AccessPoint.IdentityVerified");
    
    if (notesShown !== true)
      __showManualVerificationWarn();
    else {
      $item.addClass("need-more-info");
      $item.find(".btn-question").click(function() {
        __showManualVerificationWarn();
        $item.removeClass("need-more-info");
        event.stopPropagation();
      });
    }
    
    function __showManualVerificationWarn() {
      showMobileQueryDialog(itl("@Product.ManualVerification"), message, [itl("@Common.Yes"), itl("Common.No")], function(index) {
        if (index == 1)
          _logFailedManualVerification(ansDO);
        else if (index == 0) {
          params.skipManualVerification = true;
          doValidate(params);
        }
      });
    }
  }
  
  function _logFailedManualVerification(validateAnsDO) {
    var performance     = validateAnsDO.Performance     || {};
    var ticket          = validateAnsDO.Ticket          || {};
    var media           = validateAnsDO.Media           || {};
    var redemptionPoint = validateAnsDO.RedemptionPoint || {};
    
    vgsService("MEDIA", {
      Command: "LogUsage",
      LogUsage: {
        PerformanceId       : performance.PerformanceId,
        TicketId            : ticket.TicketId,
        MediaId             : media.MediaId,
        AccessPointId       : redemptionPoint.AccessPointId,
        AccessAreaAccountId : redemptionPoint.AccessAreaAccountId,
        UsageType           : validateAnsDO.UsageType || <%=LkSNTicketUsageType.Entry.getCode()%>,
        ValidateResult      : <%=LkSNValidateResult.ManualVerificationFailed.getCode()%>
      }
    });
  }

  function _handleGroupQuantity($item, ansDO, notesShown) {
    $item.addClass("need-more-info");
    $item.find(".btn-question").click(function() {
      showMobileInputDialog(itl("@Common.Quantity"), ansDO.Ticket.GroupQuantity, [itl("@Common.Confirm"), itl("Common.Cancel")], function(index, value) {
        if (index == 0) {
          var quantity = strToIntDef(value, 0);
          if (quantity <= 0)
            throw itl("@Common.InvalidValueError", value);
          else {
            params.quantity = quantity;
            doValidate(params);
            $item.removeClass("need-more-info");
          }
        }
      });
      
      event.stopPropagation();
    });
  }

  // Return TRUE in case notes ARE shown
  function _showNotesWarnIfNeeded($item, ansDO) {
    var match = ansDO.Match || {};
    var notes = match.NoteList || [];
    
    if (notes.length <= 0)
      return false;
    else {
      showMobileQueryDialog(itl("@Common.Notes"), itl("@Common.ShowNotesPrompt"), [itl("@Common.Yes"), itl("Common.No")], function(index) {
        if (index == 0) {
          var newDiv = $("#frm-portfoliolookup-notes-template").clone().appendTo(redeemRootContent.parent());
          var tabBody = newDiv.find(".tab-body");
          mobileSlide(redeemActiveContent, newDiv, "R2L", redeemContentSlideCallback);
          doSearchNotes(newDiv, match.AccountId);
        }
      });
      
      return true;
    }
  }
}

function setScanType(scanType) {
  $(".btn-usagetype").attr("data-scantype", scanType);
  if (scanType == "entry") {
    apt.AptEntryControl = <%=LkSNAccessPointControl.Controlled.getCode()%>;
    apt.AptExitControl = <%=LkSNAccessPointControl.Closed.getCode()%>;
  }
  else if (scanType == "simulate") {
    apt.AptEntryControl = <%=LkSNAccessPointControl.Free.getCode()%>;
    apt.AptExitControl = <%=LkSNAccessPointControl.Closed.getCode()%>;
  }
  else if (scanType == "exit") {
    apt.AptEntryControl = <%=LkSNAccessPointControl.Closed.getCode()%>;
    apt.AptExitControl = <%=LkSNAccessPointControl.Controlled.getCode()%>;
  }
  else {
    apt.AptEntryControl = <%=LkSNAccessPointControl.Closed.getCode()%>;
    apt.AptExitControl = <%=LkSNAccessPointControl.Closed.getCode()%>;
  }
}

</script>