$(document).ready(function() {
  const CLASSNAME = "task-progress-container";
  const INITIALIZED = "task-progress-container-initialized"; 
  
  const taskStatus_Active = 1;
  const taskStatus_Disabled = 2;
  const taskStatus_Deleted = 3;
  const taskStatus_Completed = 4;

  var refreshScheduled = false;
  _refreshTaskProgressBars(false);
  
  snpObserver.registerListener(CLASSNAME, INITIALIZED, function($container) {
    _refreshTaskProgressBars(false);
  });

  function _refreshTaskProgressBars(fromTimeout) {
    if (fromTimeout === true)
      refreshScheduled = false;
    
    var reqDO = {
      Command: "GetTaskProgress",
      GetTaskProgress: {
        TaskIDs: []
      }
    };

    $(".task-progress-container").each(function(index, elem) {
      var $container = $(elem);
      var taskId = getNull($container.attr("data-taskid"));
      var taskStatus = parseInt($container.attr("data-taskstatus"));
      if ((taskId !== null) && (taskStatus != taskStatus_Deleted) && (taskStatus != taskStatus_Completed))
        reqDO.GetTaskProgress.TaskIDs.push(taskId);      
    });
    
    if (reqDO.GetTaskProgress.TaskIDs.length > 0) {
      vgsService("Task", reqDO, true, function(ansDO) {
        var list = (((ansDO || {}).Answer || {}).GetTaskProgress || {}).TaskList || [];
        for (const task of list) {
          var $container = $(".task-progress-container[data-taskid='" + task.TaskId + "']");
          _refreshBar($container, task);
        }
        
        if (refreshScheduled === false) {
          refreshScheduled = true;
          setTimeout(function() {_refreshTaskProgressBars(true)}, 10000);
        }
      });
    }
  }

  function _refreshBar($container, task) {
    var perc = 100 * (task.ExecPosition / Math.max(1, task.ExecTotal));
    var progress = formatAmount(task.ExecPosition, 0) + " / " + formatAmount(task.ExecTotal, 0);
    
    var now = (new Date()).getTime();
    var lastCheck = strToIntDef($container.attr("data-check"), 0);
    var processed = task.ExecPosition - strToIntDef($container.attr("data-position"), 0);
    var msPerItem = (processed === 0) ? 0 : ((now - lastCheck) / processed);
    var msETA = (lastCheck === 0) ? null : ((task.ExecTotal - task.ExecPosition) * msPerItem);
    
    $container.find(".progress-bar").remove();
    $container.attr("data-taskstatus", task.TaskStatus);
    $container.attr("data-position", task.ExecPosition);
    $container.attr("data-total", task.ExecTotal);
    $container.attr("data-check", now);

    var $progress = $container.find(".progress");
    var $bar = $("<div class=\"progress-bar\"></div>").appendTo($progress);
    $bar.css("width", perc + "%");
    
    var $labels = $container.find(".task-progress-labels");

    $progress.addClass("hidden");
    if (task.TaskStatus === taskStatus_Disabled) {
      $labels.text(itl("@Task.MaintenanceDisabled"));
    }
    else if (task.TaskStatus === taskStatus_Completed) {
      $labels.text(itl("@Task.MaintenanceCompleted") + " " + CHAR_MDASH + " " + formatAmount(task.ExecTotal, 0)); 
    }
    else {
      $progress.removeClass("hidden");
      if (task.Running === true) {
        $bar.addClass("progress-bar-snp-success");
        var label = itl("@Task.MaintenanceRunning") + " " + CHAR_MDASH + " " + progress;
        if (msETA !== null)
          label += " " + CHAR_MDASH + " ETA: " + getSmoothTime(msETA);
        $labels.text(label); 
      }
      else {
        $bar.addClass("progress-bar-snp-warn");
        $labels.text(itl("@Task.MaintenancePaused") + " " + CHAR_MDASH + " " + progress); 
      }
    }
  }
});
