UIMob.init("redeem", function($view, params) { 
  if (BLMob.AccessPoint.AptEntryControl == LkSN.AccessPointControl.Controlled.code)
    setScanType("entry");
  else if (BLMob.AccessPoint.AptExitControl == LkSN.AccessPointControl.Controlled.code)
    setScanType("exit");
  else if (BLMob.AccessPoint.AptEntryControl == LkSN.AccessPointControl.Free.code)
    setScanType("simulate");
  else
    setScanType("lookup");
  
  $view.find("#tab-header-manual input").attr("placeholder", itl("@Common.InsertBarcode"));

  
  $view.find("#tab-header-idle .btn-camera").on(MOUSE_DOWN_EVENT, function() {
    snpNative("openCamera", {"OutputType": "barcode"});
  });  
  
  $view.find("#tab-header-idle .btn-keyboard").on(MOUSE_DOWN_EVENT, function() {
    setActiveRedeemHeaderPane($view.find("#tab-header-manual"));
    setTimeout(function() {$view.find("#tab-header-manual input").focus()}, 200);
  });  
  
  $view.find("#tab-header-manual .btn-keyboard").on(MOUSE_DOWN_EVENT, function() {
    setActiveRedeemHeaderPane($view.find("#tab-header-idle"));
  });  
  
  $view.find("#tab-header-idle .btn-scantype").on(MOUSE_DOWN_EVENT, function() {
    var scantypes = ["entry", "simulate", "exit", "lookup"];
    var buttons = [
        itl("@Entitlement.Entry"), 
        itl("@AccessPoint.SimulatedEntry"), 
        itl("@Common.Exit"), 
        itl("@Common.Lookup"),
        itl("@Common.Cancel")
    ];
    UIMob.showMessage(itl("@Ticket.UsageType"), null, buttons, function(index) {
      if (index < scantypes.length) 
        setScanType(scantypes[index]);
    });
  });  
  
  $view.find("#tab-header-manual input").keydown(function(e) {
    if (event.keyCode == KEY_ENTER) {
      var mediaCode = $(this).val();
      $(this).val("");
      $(document).trigger(EVENT_InputRead, {
        "ReaderType": "manual",
        "MediaCode": mediaCode
      });
      setTimeout(function() {$("input").blur()}, 200);
      event.stopPropagation();
    } 
  });

  $(document).von($view, EVENT_InputRead, function(event, data) {
    var mediaCode = data.MediaCode;
    if ($view.is(".hidden-nav-content")) {
      redeemBackToRootContent();
      doMediaLookup(mediaCode);
    }
    else {
     if (getScanType() == "lookup")
       doMediaLookup(mediaCode);
     else
       doValidate(mediaCode);
    }
  });

  $(document).von($view, "tabchange", function(event, data) {
    if ((data.newTabCode == $view.closest(".tab-content").attr("data-tabcode")) && (data.NewTabCode == data.NldTabCode))
      redeemBackToRootContent();
  });

  function redeemBackToRootContent() {
    $view.removeClass("hidden-nav-content").siblings(".mob-view").remove();
  }

  function setActiveRedeemHeaderPane(selector) {
    $view.find(".tab-header").addClass("hidden");
    $(selector).removeClass("hidden");
  }

  var idleTimerTS = 0;
  function idleTimer(ts) {
    if (ts == idleTimerTS) 
      setActiveRedeemHeaderPane($view.find("#tab-header-idle"));
  }
  
  function startIdleTimer() {
    var thisTimeTS = (new Date()).getTime();
    idleTimerTS = thisTimeTS;
    setTimeout(function() {
      idleTimer(thisTimeTS);
    }, 2000);
  }
  
  function doMediaLookup(code) {
    setActiveRedeemHeaderPane($view.find("#tab-header-wait"));
    idleTimerTS = 0;

    snpAPI("Media", "Search", {"MediaCode":code})
      .then(function(ansDO) {
        var list = (ansDO.MediaList || []);
        if (list.length == 0) {
          var $headerResult = $view.find("#tab-header-result");
          setActiveRedeemHeaderPane($headerResult);
          $headerResult.removeClass("good-result").addClass("bad-result").find(".tab-header-title").text(itl("@Common.MediaNotFound"));

          startIdleTimer();
        }
        else {
          setActiveRedeemHeaderPane($view.find("#tab-header-idle"));
          UIMob.tabSlideView({
            container: $view.closest(".tab-content"),
            packageName: PKG_ADM,
            viewName: "medialookup",
            dir: "R2L",
            params: {
              MediaRef: list[0]
            }
          });
        }
      });
  }

  function doValidate(mediaCode) {
    setActiveRedeemHeaderPane($view.find("#tab-header-wait"));
    idleTimerTS = 0;
    
    var scanType = getScanType();
    
    snpAPI("VALIDATE", null, {
      MediaCode : mediaCode,
      MediaCodeType : 0,
      SkipBiometricCheck: true,
      RedemptionPoint : {
        AccessPointId : BLMob.AccessPoint.AccessPointId,
        UsageType : (scanType == "exit") ? LkSN.TicketUsageType.Exit.code : LkSN.TicketUsageType.Entry.code,
        OperatorCmd : ((scanType == "simulate") || (scanType == "lookup")) ? LkSN.AccessPointOperatorCmd.None.code : LkSN.AccessPointOperatorCmd.UseTicket.code
      }
    })
    .then(function(ansDO) {
      var ansDO = (ansDO.Answer) ? ansDO.Answer : {};
      var portfolio = (ansDO.Match) ? ansDO.Match : {};
      var ticket = (ansDO.Ticket) ? ansDO.Ticket : {};
      var perf = (ansDO.Performance) ? ansDO.Performance : {};
      var perfTime = ((perf.DateTimeFrom) && (perf.DateTimeFrom.length > 16)) ? perf.DateTimeFrom.substring(11, 16) : "";
      
      $view.find(".valres-item.latest").removeClass("latest");
      
      var maxItems = 3;
      var $items = $view.find(".tab-body .valres-item");
      for (var i=maxItems-1; i<$items.length; i++)
        $($items[i]).remove();
      
      var status = (ansDO.ResultCode < goodTicketLimit) ? "good" : "bad";
      var $item = $view.find(".templates .valres-item").clone().prependTo($view.find(".tab-body"));
      $item.addClass("latest");
      $item.attr("data-status", status);
      $item.attr("data-mediacode", mediaCode);
      $item.attr("data-ticketid", ticket.TicketId);
      $item.find(".valres-opmsg").text(ansDO.OperatorMsg);
      $item.find(".valres-rot").text(ansDO.RotationsAllowed || "");
      
      if (ansDO.ResultCode == LkSN.ValidateResult.MediaNotFound.code) 
        $("<div class='valres-detail-item'/>").appendTo($item.find(".valres-body").empty()).text(mediaCode);        
      else {
        $item.find(".valres-pic").css("background-image", "url(" + calcRepositoryURL(portfolio.ProfilePictureId, "small") + ")");
        $item.find(".valres-detail-item-account").text(portfolio.AccountDisplayName);
        $item.find(".valres-detail-item-product").text(ticket.ProductName);
        $item.find(".valres-detail-item-message").text(ansDO.SpecialMsg);
        $item.click(function() {
          doMediaLookup(mediaCode, ticket.TicketId);
        });
      }
      
      var $headerResult = $view.find("#tab-header-result");
      setActiveRedeemHeaderPane($headerResult);
      $headerResult.removeClass("good-result bad-result").addClass(status + "-result").find(".tab-header-title").text(ansDO.OperatorMsg);
      
      /*
      var audio = new Audio(BASE_URL + "/repository?id=" + ansDO.SoundRepositoryId);
      audio.play();
      */
      
      startIdleTimer();
    });
  }
  
  function getScanType() {
    return $view.find(".btn-scantype-active").attr("data-scantype");
  }

  function setScanType(scanType) {
    $view.find(".btn-scantype").removeClass("btn-scantype-active");
    $view.find(".btn-scantype[data-scantype='" + scanType + "']").addClass("btn-scantype-active");

    if (scanType == "entry") {
      BLMob.AccessPoint.AptEntryControl = LkSN.AccessPointControl.Controlled.code;
      BLMob.AccessPoint.AptExitControl = LkSN.AccessPointControl.Closed.code;
    }
    else if (scanType == "simulate") {
      BLMob.AccessPoint.AptEntryControl = LkSN.AccessPointControl.Free.code;
      BLMob.AccessPoint.AptExitControl = LkSN.AccessPointControl.Closed.code;
    }
    else if (scanType == "exit") {
      BLMob.AccessPoint.AptEntryControl = LkSN.AccessPointControl.Closed.code;
      BLMob.AccessPoint.AptExitControl = LkSN.AccessPointControl.Controlled.code;
    }
    else {
      BLMob.AccessPoint.AptEntryControl = LkSN.AccessPointControl.Closed.code;
      BLMob.AccessPoint.AptExitControl = LkSN.AccessPointControl.Closed.code;
    }
  }
});
