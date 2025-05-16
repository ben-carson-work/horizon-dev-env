
/**
 * params = {
 *   AccessPointId: string,
 *   AccessPointCode: string,
 *   AccessPointName: string,
 *   ControllerWorkstationId: string,
 *   Status: {}                        // Last broadcasted message
 * }
 */
UIMob.init("apt-monitor-detail", function($view, params) {
  $(document).von($view, EVENT_WebSocketMessage, onWebSocketMessage);
  $(document).von($view, EVENT_InputRead, onInputRead);
  
  $view.find(".tab-header-title").text(params.AccessPointName);
  $view.find(".btn-toolbar-menu").click(onMenuClick);
  
  var $statusEntry = $view.find(".apt-status-item.status-entry").click(onEntryClick);
  var $statusReentry = $view.find(".apt-status-item.status-reentry").click(onReentryClick);
  var $statusExit = $view.find(".apt-status-item.status-exit").click(onExitClick);
  var lastUsage = null;

  if (params.Status)
    renderAccessPointStatus(params.Status);
  updateUsagesThread();
  
  function onWebSocketMessage(e, status) {
    if (status.Header.RequestCode == BcstStatus_AccessPoint) {
      var msg = status.Message;
      if (msg.AccessPointId == params.AccessPointId)
        renderAccessPointStatus(msg);
    }
  }
  
  function onInputRead(e, data) {
    if (UIMob.isActiveContent($view)) 
      doExternalScan(data.MediaCode);
  }

  function renderAccessPointStatus(msg) {
    var entryColor = (msg.ReentryControl == LkSN.AccessPointReentryControl.ReentryOnly.code) ? "red" : (APT_CONTROL_COLORS[msg.EntryControl] || "gray");
    var reentryColor = (msg.ReentryControl == LkSN.AccessPointReentryControl.FirstEntryOnly.code) ? "red" : (APT_CONTROL_COLORS[msg.EntryControl] || "gray");
    var exitColor = APT_CONTROL_COLORS[msg.ExitControl] || "gray";

    $statusEntry.find(".apt-status-icon").css("color", "var(--base-" + entryColor + "-color)");
    $statusEntry.find(".apt-status-value").text(getLookupDesc(LkSN.AccessPointControl, msg.EntryControl));
    
    $statusReentry.find(".apt-status-icon").css("color", "var(--base-" + reentryColor + "-color)");
    $statusReentry.find(".apt-status-value").text(getLookupDesc(LkSN.AccessPointReentryControl, msg.ReentryControl));

    $statusExit.find(".apt-status-icon").css("color", "var(--base-" + exitColor + "-color)");
    $statusExit.find(".apt-status-value").text(getLookupDesc(LkSN.AccessPointControl, msg.ExitControl));
    
    $view.find(".apt-counter-in-wait .apt-counter-value").text(msg.WaitingRotationsIn);
    $view.find(".apt-counter-in-tot .apt-counter-value").text(msg.TotalEntries);
    $view.find(".apt-counter-out-wait .apt-counter-value").text(msg.WaitingRotationsOut);
    $view.find(".apt-counter-out-tot .apt-counter-value").text(msg.TotalExits);
    
    var lastvr = msg.LastValidateResult || {};
    if ((lastUsage == null) || (lastvr.UsageDateTime != lastUsage)) {
      lastUsage = lastvr.UsageDateTime;
      refreshUsages(lastUsage);
    } 
  }
  
  function refreshUsages(ref) {
    var $list = $view.find(".usage-list");
    var $spinner = $list.find(".main-spinner");
    if ($spinner.length == 0)
      $spinner = UIMob.createSpinnerClone().prependTo($list);
    
    snpAPI("Portfolio", "SearchTicketUsage", {
      "PagePos": 1,
      "RecordPerPage": 3,
      "AccessPointId": params.AccessPointId
    }).then(function(ansDO) {
      if (lastUsage == ref) {
        $spinner.remove();
        $list.empty();
        
        var list = ansDO.TicketUsageList || [];
        for (var i=0; i<list.length; i++) 
          renderUsage(list[i], $list);
      }
    });
  }
  
  function renderUsage(usage, container) {
    var $usage = $view.find(".templates .usage-item").clone().appendTo(container);
    $usage.data("usage", usage);
    $usage.find(".mob-widget-header .valres-desc").text(usage.ValidateResultDesc);
    $usage.addClass((usage.ValidateResult < LkSN.ValidateResult.GoodTicketLimit.code) ? "good-result" : "bad-result");
    
    if (usage.AccountProfilePictureId)
      $usage.find(".mob-card-icon").css("background-image", "url(" + calcRepositoryURL(usage.AccountProfilePictureId) + ")");
    else 
      $usage.find(".mob-card-icon").html("<i class='fa fa-" + (usage.AccountIconAlias || "user-slash") + "'></i>");
    $usage.find(".mob-card-title").text(usage.AccountName);
    
    var $cardbody = $usage.find(".mob-card-body");

    if ((usage.ValidateResult == LkSN.ValidateResult.MediaNotFound.code) && (usage.MissingMediaCode != null))
      UIMob.addCardData($cardbody, usage.MissingMediaCode, "barcode-alt");  
    
    UIMob.addCardData($cardbody, usage.ProductName, "tag");
    if (usage.PerformanceId)
      UIMob.addCardData($cardbody, usage.EventName + " " + CHAR_RAQUO + " " + formatShortDateTimeFromXML(usage.PerfDateTimeFrom), "masks-theater");
    
    $usage.click(function() {
      var usage = $(this).data("usage");
      UIMob.tabSlideView({
        container: $view.closest(".tab-content"),
        packageName: PKG_CAS,
        viewName: "account",
        params: {
          "AccountId": usage.AccountId,
          "MediaId": usage.MediaId,
          "TicketId": usage.TicketId
        }
      });
    });
  }
  
  function updateUsagesThread() {
    if ($.contains(document.body, $view[0])) {
      $view.find(".usage-list .usage-item").each(function(index, elem) {
        var $usage = $(elem);
        var usage = $usage.data("usage");
        var usageTS = xmlToDate(usage.UsageDateTime).getTime();
        var nowTS = (new Date()).getTime();
        var secs = Math.round((nowTS - usageTS) / 1000);
        var mins = Math.round(secs / 60);
        var hours = Math.round(mins / 60);
        
        var text = formatShortDateTimeFromXML(usage.UsageDateTime);
        if (secs < 60)
          text = secs + " seconds ago";
        else if (mins < 60)
          text = mins + " minutes ago";
        else if (hours < 24)
          text = hours + " hours ago";
        
        $usage.find(".mob-widget-header .usage-datetime").text(text);
      });
      
      setTimeout(updateUsagesThread, 1000);
    }
  }
  
  function pickLookup(title, table, cmdProperty) {
    var items = [];
    var labels = [];
    var keys = Object.keys(table);
    for (var i=0; i<keys.length; i++) {
      var item = table[keys[i]];
      items.push(item);
      labels.push(itl(item.description));
    }
    
    labels.push(itl("@Common.Cancel"));
    
    UIMob.showMessage(title, "", labels, function(index) {
      if (index < items.length) {
        var reqDO = {"AccessPointIDs": params.AccessPointId};
        reqDO[cmdProperty] = items[index].code;
        
        BLWebSocket.broadcastCommand(params.ControllerWorkstationId, "AccessPoint", {
          "Command": "ChangeConfig",
          "ChangeConfig": reqDO
        });
      }
    });
  }

  function onEntryClick() {
    pickLookup(itl("@AccessPoint.EntryControl"), LkSN.AccessPointControl, "EntryControl");
  }
  
  function onReentryClick() {
    pickLookup(itl("@AccessPoint.ReentryControl"), LkSN.AccessPointReentryControl, "ReentryControl");
  }
  
  function onExitClick() {
    pickLookup(itl("@AccessPoint.ExitControl"), LkSN.AccessPointControl, "ExitControl");
  }
  
  function onMenuClick() {
    var aExtScan = {
      "IconAlias": "barcode-scan",
      "Caption": itl("Scan media"), // TODO: ITL
      "Hint": itl("Scan media on turnstyle behalf"), // TODO: ITL
      "execute": onExtScanClick
    };
      
    var aSkipRot = {
        "IconAlias": "sync-alt",
        "Caption": itl("@AccessPoint.SkipRotation"),
        "Hint": itl("@AccessPoint.SkipRotationHint"),
        "execute": onSkipRotClick
      };
      
    var aDropArm = {
        "IconAlias": "exclamation-triangle",
        "Caption": itl("@AccessPoint.DropArm"),
        "Hint": itl("@AccessPoint.DropArmHint"),
        "execute": onDropArmClick
      };
      
    var aRestartApp = {
      "IconAlias": "power-off",
      "Caption": itl("@AccessPoint.RestartApplication"),
      "Hint": itl("@AccessPoint.RestartApplicationHint"),
      "execute": onRestartAppClick
    };
      
    UIMob.popupMenu({
      "Target": this,
      "Items": [aExtScan, aSkipRot, aDropArm, aRestartApp]
    });
  }
  
  function onExtScanClick() {
    BLMob.showMediaPickupDialog({
      "AllowExisting": true,
      "AllowNew": true,
      "AllowVoided": true
    }, function(mediaRead, media) {
      doExternalScan(mediaRead.MediaCode);
    });
  }
    
  function onSkipRotClick() {
    BLWebSocket.broadcastCommand(params.ControllerWorkstationId, "AccessPoint", {
      "Command": "SkipRotation",
      "SkipRotation": {
        "AccessPointIDs": params.AccessPointId
      }
    });
  }
  
  function onDropArmClick() {
    BLWebSocket.broadcastCommand(params.ControllerWorkstationId, "AccessPoint", {
      "Command": "DropArm",
      "DropArm": {
        "AccessPointIDs": params.AccessPointId
      }
    });
  }
  
  function onRestartAppClick() {
    UIMob.showMessage(itl("@Common.Warning"), itl("@Common.ConfirmSelWorkstationRestart"), [itl("@Common.Ok"), itl("@Common.Cancel")], function(index) {
      if (index == 0) {
        BLWebSocket.broadcastCommand(params.ControllerWorkstationId, "Workstation", {
          "Command": "RestartApplication"
        });
      }
    });
  }
  
  function doExternalScan(mediaCode) {
    BLWebSocket.broadcastCommand(params.ControllerWorkstationId, "AccessPoint", {
      "Command": "ExternalScan",
      "ExternalScan": {
        "AccessPointId": params.AccessPointId,
        "MediaCode": mediaCode
      }
    });
  }

});
