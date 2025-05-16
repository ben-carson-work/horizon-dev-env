function showAsyncProcessDialog(processId, completedCallback, hideAbort) {
  let $dlg = $("#templates .async-process-dialog-template").clone();
  let hrefLogs = "task/asyncproc_loglist_dialog";
  let paramsLogs = "AsyncProcessId=" + processId ;
    
  $dlg.dialog({
    modal: true,
    width: 350,
    height: 220,
    close: function() {
      $dlg.remove();
      $dlg = null;
    },
    buttons: [
      {
        "id": "async-process-abort-button",
        "text": itl("@Common.Abort"), 
        "click": doAbortClick
      },
      {
        "id": "async-process-changelogs-button",
        "text": itl("@Common.Logs"), 
        "click": doChangeLogsClick
      },
      {
        "id": "async-process-background-button",
        "text": itl("@Task.RunInBackground"), 
        "click": doBackgroundClick
      }
    ]
  });
  
  let completed = false;
  let refEntityType = null;
  let refEntityId = null;

  let $buttonPane = $dlg.siblings(".ui-dialog-buttonpane");
  let $btnAbort = $buttonPane.find("#async-process-abort-button");
  let $btnChangeLog = $buttonPane.find("#async-process-changelogs-button");
  let $btnBackground = $buttonPane.find("#async-process-background-button");
  
  $btnAbort.setClass("hidden", (hideAbort || true));
  $btnChangeLog.addClass("hidden");
  
  function setCompleteMessage(type, msg, error, hasLogs) {
    completed = true;
    let $bar = $dlg.find(".progress-bar");
    $bar.removeClass("progress-bar-info").addClass(error ? "progress-bar-error" : "progress-bar-success").text(msg);
    if (!error)
      $bar.css("width", "100%");
    
    $btnAbort.addClass("hidden");
    if (hasLogs)
      $btnChangeLog.removeClass("hidden");
    $btnBackground.text(itl("@Common.Close"));
    
    triggerEntityChange(type, null);
  }
  
  function doAbortClick() {
    $dlg.dialog("close");
    vgsService("AsyncProcess", {
      Command: "AbortProcess",
      AbortProcess: {
        AsyncProcessIDs: processId 
      }
    });
  }
  
  function doChangeLogsClick() {
    asyncDialogEasy(hrefLogs, paramsLogs);
  }
  
  function doBackgroundClick() {
    $dlg.dialog("close");
    if (completed && completedCallback)
      completedCallback({
        RefEntityType: refEntityType,
        RefEntityId: refEntityId
    });
  }

  function doGetProcess() {
    if (($dlg != null) && !completed) {
      let reqDO = {
        Command: "GetProcess",
        GetProcess: {
          AsyncProcessId: processId
        }
      };
      
      vgsService("AsyncProcess", reqDO, false, function(ansDO) {
        $dlg.dialog({title:ansDO.Answer.GetProcess.AsyncProcessName});
        $dlg.find(".qtytot").text(formatAmount(ansDO.Answer.GetProcess.QuantityTot, 0));
        $dlg.find(".qtypos").text(formatAmount(ansDO.Answer.GetProcess.QuantityPos, 0));
        $dlg.find(".qtyskip").text(formatAmount(ansDO.Answer.GetProcess.QuantitySkip, 0));
        refEntityType = ansDO.Answer.GetProcess.RefEntityType;
        refEntityId = ansDO.Answer.GetProcess.RefEntityId;
        let hasLogs = ansDO.Answer.GetProcess.LogCount > 0;
        
        let AsyncProcessStatus_Finished = 3;
        let AsyncProcessStatus_Aborted = 4;
        let AsyncProcessStatus_Failed = 5;
        
        if (ansDO.Answer.GetProcess.AsyncProcessStatus == AsyncProcessStatus_Finished)
          setCompleteMessage(ansDO.Answer.GetProcess.EntityType, itl("@Common.Completed"), false, hasLogs);
        else if (ansDO.Answer.GetProcess.AsyncProcessStatus == AsyncProcessStatus_Aborted)
          setCompleteMessage(ansDO.Answer.GetProcess.EntityType, itl("@Common.Aborted"), true, hasLogs);
        else if (ansDO.Answer.GetProcess.AsyncProcessStatus == AsyncProcessStatus_Failed)
          setCompleteMessage(ansDO.Answer.GetProcess.EntityType, itl("@Common.Failed"), true, hasLogs);
        else {
          let sperc = ansDO.Answer.GetProcess.PercComplete + "%";
          $dlg.find(".progress-bar").css("width", sperc).text(sperc);
          setTimeout(doGetProcess, 500);
        }
      });
    }
  }
  doGetProcess();
}
