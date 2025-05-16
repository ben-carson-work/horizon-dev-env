<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.snapp.lookup.LkSN"%>
<%@page import="com.vgs.cl.lookup.LookupItem"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request" />
<script>
  
  $(document).ready(function() {
    $dlg = $("#code_freeze_generation_dialog");
    $wizard = $dlg.find(".wizard");
    $stepCalcVersions = $wizard.find(".wizard-step-calc-versions");
    $stepRecap = $wizard.find(".wizard-step-recap");
    
    $dlg.on("snapp-dialog", function(event, params) {
      params.open = _enableDisable;
      params.buttons = [
        {
          id: "btn-back",
          text: itl("@Common.Back"),
          click: _previousStep
        },
        {
          id: "btn-continue",
          text: itl("@Common.Continue"),
          click: _nextStep
        },
        {
          id: "btn-confirm",
          text: itl("@Common.Confirm"),
          click: _confirm
        },
        {
          id: "btn-close",
          text: itl("@Common.Close"),
          click: doCloseDialog
        }
      ]; 
    });
    
    $wizard.vWizard({
      onStepChanged: _enableDisable
    });
    
    loadProjects();
  });
  
  function _enableDisable() {
    var confirm = ($wizard.vWizard("activeIndex") == $wizard.vWizard("length") - 2);
    var lastStep = ($wizard.vWizard("activeIndex") == $wizard.vWizard("length") - 1);
    var firstStep = ($wizard.vWizard("activeIndex") == 0);
    var $buttonPane = $dlg.siblings(".ui-dialog-buttonpane");
    $buttonPane.find("#btn-continue").setClass("hidden", confirm || lastStep);
    $buttonPane.find("#btn-confirm").setClass("hidden", !confirm);
    $buttonPane.find("#btn-back").setClass("hidden", firstStep || lastStep);
  }
  
  function _nextStep() {
    if ($stepCalcVersions.is(".active")) {
      updateVersions();
      renderRecapProjects();
      $wizard.vWizard("next");
    }
    else
      $wizard.vWizard("next");
  }
  
  function _previousStep() {
    $wizard.vWizard("prior");
  }
  
  function _confirm() {
    $wizard.vWizard("next");
    startCodeFreeze();
  }
  
	function loadProjects() {
	  var reqDO = {
	    Command: "GetCodeFreezeVersions",
	    GetCodeFreezeVersions: {}
	  };
	  
	  $(".wizard").addClass("waiting");
	  vgsService("VersionBuilder", reqDO, false, function(ansDO) {
	    $(".wizard").removeClass("waiting");
	     
	    if ((ansDO.Answer) && (ansDO.Answer.GetCodeFreezeVersions) && (ansDO.Answer.GetCodeFreezeVersions.DOCodeFreezeBuilder))
	      fillProjectsVersions(ansDO.Answer.GetCodeFreezeVersions.DOCodeFreezeBuilder);
	   });
	}

	function fillProjectsVersions(codeFreezeBuilder) {
	  $("#oldWIPVersion").val(codeFreezeBuilder.OldWIPVersionBase);
	  $("#newWIPVersion").val(codeFreezeBuilder.NewWIPVersionBase);
	  $("#releaseVersion").val(codeFreezeBuilder.ReleaseVersionBase);

	  $("#code_freeze_generation_dialog").data("codeFreezeBuilder", codeFreezeBuilder);
	}
	
	function updateVersions() {
	  var codeFreezeBuilder = $("#code_freeze_generation_dialog").data("codeFreezeBuilder");
	  var oldWIPVersionBase = $("#oldWIPVersion").val();
	  var newWIPVersionBase = $("#newWIPVersion").val();
	  var releaseVersionBase = $("#releaseVersion").val();
	    
	  var projectList = codeFreezeBuilder.ProjectList;
	  for (var i=0; i<projectList.length; i++) {
	    var project = projectList[i];
	    var targetVersion = "";
	    
	    checkExistingVersions(project);
	    
	    targetVersion = getBaseVersion(project.OldWIPReleaseVersion);
	    if ((targetVersion != null) && (targetVersion != oldWIPVersionBase))
	      project.OldWIPReleaseVersion = updateBaseVersion(project.OldWIPReleaseVersion, oldWIPVersionBase);
	    
      targetVersion = getBaseVersion(project.OldWIPUnreleaseVersion);
      if ((targetVersion != null) && (targetVersion != oldWIPVersionBase))	    
	      project.OldWIPUnreleaseVersion = updateBaseVersion(project.OldWIPUnreleaseVersion, oldWIPVersionBase);
	      
      targetVersion = getBaseVersion(project.NewWIPReleaseVersion);
      if ((targetVersion != null) && (targetVersion != oldWIPVersionBase))   
	      project.NewWIPReleaseVersion = updateBaseVersion(project.NewWIPReleaseVersion, newWIPVersionBase);
      
      targetVersion = getBaseVersion(project.NewWIPUnreleaseVersion);
      if ((targetVersion != null) && (targetVersion != oldWIPVersionBase))   
	      project.NewWIPUnreleaseVersion = updateBaseVersion(project.NewWIPUnreleaseVersion, newWIPVersionBase);
	      
      targetVersion = getBaseVersion(project.CompileReleaseVersion);
      if ((targetVersion != null) && (targetVersion != oldWIPVersionBase))   
	      project.CompileReleaseVersion = updateBaseVersion(project.CompileReleaseVersion, releaseVersionBase);
      
      targetVersion = getBaseVersion(project.CompileUnreleaseVersion);
      if ((targetVersion != null) && (targetVersion != oldWIPVersionBase))   
	      project.CompileUnreleaseVersion = updateBaseVersion(project.CompileUnreleaseVersion, releaseVersionBase);
	  }  
	}
	
	function checkExistingVersions(project) {
	  var errorMsg = '';
	  if (!project.OldWIPReleaseVersion)
	    errorMsg = "Missing old WIP released version on Jira for: " + project.ProjectName;
    else if (!project.OldWIPUnreleaseVersion)
      errorMsg = "Missing old WIP unreleased version on Jira for: " + project.ProjectName;
    else if (!project.NewWIPReleaseVersion)
      errorMsg = "Missing new WIP release version on Jira for: " + project.ProjectName;
    else if (!project.NewWIPUnreleaseVersion)
      errorMsg = "Missing new WIP unreleased version on Jira for: " + project.ProjectName;
    else if (!project.CompileReleaseVersion)
      errorMsg = "Missing compile released version on Jira for: " + project.ProjectName;
    else if (!project.CompileUnreleaseVersion)
      errorMsg = "Missing compile unreleased version on Jira for: " + project.ProjectName;
    
    if (errorMsg != '')
      showMessage(errorMsg);
	}
	
	function getBaseVersion(version) {
	  var splitVersion = version.split(".");
	  if (splitVersion.length == 4) {
	    splitVersion.pop();
	    return splitVersion.join(".");
	  }
	  
	  return null;
	}
	
	/*
	* If a valid base version is provided, return the updated version otherwise return the version
	*/
	function updateBaseVersion(version, targetBaseVersion) {
	  var splitVersion = version.split(".");
	  
	  if (splitVersion.length > 0)
	    return targetBaseVersion + "." + splitVersion[splitVersion.length - 1];
	  
	  return version;
	}
	
	function renderRecapProjects() {
	  var codeFreezeBuilder = $("#code_freeze_generation_dialog").data("codeFreezeBuilder");
	  var projectList = codeFreezeBuilder.ProjectList;
	  
	  var archiveVersionContainer = $("#old-wip-version-recap-widget .widget-block");
	  var wipVersionContainer = $("#new-wip-version-recap-widget .widget-block");
	  var compileVersionContainer = $("#release-version-recap-widget .widget-block");
	  
	  compileVersionContainer.empty();
	  wipVersionContainer.empty();
	  archiveVersionContainer.empty();
	  
	  for (var i=0; i<projectList.length; i++) {
	    var project = projectList[i];
	
	    var oldWIPReleasedVersionItem = $(".recap-version-block.template").clone().removeClass("hidden").removeClass("template");
	    $(oldWIPReleasedVersionItem).find(".recap-version").addClass("archive").text(project.ProjectName + " " + project.OldWIPReleaseVersion);
	    $(oldWIPReleasedVersionItem).find(".recap-description").html("<span class='span-desc label-archived'>ARCHIVED</span>");
	    oldWIPReleasedVersionItem.appendTo(archiveVersionContainer);
	    
	    var oldWIPUnreleasedVersionItem = $(".recap-version-block.template").clone().removeClass("hidden").removeClass("template");
	    $(oldWIPUnreleasedVersionItem).find(".recap-version").addClass("archive").text(project.ProjectName + " " + project.OldWIPUnreleaseVersion);
	    $(oldWIPUnreleasedVersionItem).find(".recap-description").html("<span class='span-desc label-archived'>ARCHIVED</span>");
	    oldWIPUnreleasedVersionItem.appendTo(archiveVersionContainer);
	    
	    var compileReleaseVersionItem = $(".recap-version-block.template").clone().removeClass("hidden").removeClass("template");
	    $(compileReleaseVersionItem).find(".recap-version").addClass("release").text(project.ProjectName + " " + project.CompileReleaseVersion);
	    $(compileReleaseVersionItem).find(".recap-description").html("<span class='span-desc label-released'>RELEASED</span>");
	    compileReleaseVersionItem.appendTo(compileVersionContainer);
	    
	    var compileUnreleaseVersionItem = $(".recap-version-block.template").clone().removeClass("hidden").removeClass("template");
	    $(compileUnreleaseVersionItem).find(".recap-version").addClass("new").text(project.ProjectName + " " + project.CompileUnreleaseVersion);
	    $(compileUnreleaseVersionItem).find(".recap-description").html("<span class='span-desc label-unreleased'>UNRELEASED</span>");
	    compileUnreleaseVersionItem.appendTo(compileVersionContainer);
	    
	    var wipReleaseVersionItem = $(".recap-version-block.template").clone().removeClass("hidden").removeClass("template");
	    $(wipReleaseVersionItem).find(".recap-version").addClass("release").text(project.ProjectName + " " + project.NewWIPReleaseVersion);
	    $(wipReleaseVersionItem).find(".recap-description").html("<span class='span-desc label-released'>RELEASED</span>");
	    wipReleaseVersionItem.appendTo(wipVersionContainer);
	    
	    var wipUnreleaseVersionItem = $(".recap-version-block.template").clone().removeClass("hidden").removeClass("template");
	    $(wipUnreleaseVersionItem).find(".recap-version").addClass("new").text(project.ProjectName + " " + project.NewWIPUnreleaseVersion);
	    $(wipUnreleaseVersionItem).find(".recap-description").html("<span class='span-desc label-unreleased'>UNRELEASED</span>");
	    wipUnreleaseVersionItem.appendTo(wipVersionContainer);
	  }
	}

	function startCodeFreeze() {
	  //createSVNBranch();
	  createJiraVersions()
	  
	  var $buttonPane = $dlg.siblings(".ui-dialog-buttonpane");
    $buttonPane.find("#btn-confirm").setClass("hidden", true);
    $buttonPane.find("#btn-back").setClass("hidden", true);
	}
	
	function createSVNBranch() {
	  var dlg = $("#code_freeze_generation_dialog");
	  var codeFreezeBuilder = $("#code_freeze_generation_dialog").data("codeFreezeBuilder");
	  var projectList = codeFreezeBuilder.ProjectList;
	  
    var reqDO = {
      Command: "CreateSvnBranch",
      CreateSvnBranch: {
        ReleaseVersion: projectList[0].CompileReleaseVersion,
        WIPVersion: projectList[0].NewWIPReleaseVersion
      }
    };
	        
    $(".create-branch-step").find(".spinner-step").addClass("visible");
    vgsService("VersionBuilder", reqDO, false, function(ansDO) {
      $(".create-branch-step").find(".spinner-step").removeClass("visible"); 
      
      if (ansDO.Header.StatusCode == 200) {
        $(".create-branch-step").find(".check-step").addClass("visible");
        createJiraVersions();
      }
      else
        $(".create-branch-step").find(".failed-step").addClass("visible");
    });
	}
	
	function createJiraVersions() {
    var $buttonPane = $dlg.siblings(".ui-dialog-buttonpane");
    $buttonPane.find("#btn-close").setClass("hidden", true);
    var dlg = $("#code_freeze_generation_dialog");
    var codeFreezeBuilder = $("#code_freeze_generation_dialog").data("codeFreezeBuilder");
    var projectList = codeFreezeBuilder.ProjectList;
    
    var reqDO = {
      Command: "CreateCodeFreezeJiraVersions",
      CreateCodeFreezeJiraVersions: {
        CodeFreezeBuilder: {
          ProjectList: projectList
        }
      }
    };
        
    $(".create-jira-versions-step").find(".spinner-step").addClass("visible");  
    vgsService("VersionBuilder", reqDO, false, function(ansDO) {
      $(".create-jira-versions-step").find(".spinner-step").removeClass("visible");   
      
      if (ansDO.Header.StatusCode == 200) {
        var asyncProcessId = ansDO.Answer.CreateCodeFreezeJiraVersions.AsyncProcessId;
        doGetProcess(asyncProcessId, null, function(proc) {
  	      if ((proc.AsyncProcessStatus == <%=LkSNAsyncProcessStatus.Failed.getCode()%>) || 
	          (proc.AsyncProcessStatus == <%=LkSNAsyncProcessStatus.Aborted.getCode()%>)) {
 	          showMessage("SVN branch and Jira versions failed with status: " + proc.AsyncProcessStatus);
 	         	$(".create-branch-step").find(".failed-step").addClass("visible");
  	      }
  	      else {
 	          showMessage("SVN branch and Jira versions succesfully created!");
 	          $buttonPane.find("#btn-close").setClass("hidden", false);
  	      }
        });

      }
      else
        $(".create-branch-step").find(".failed-step").addClass("visible");
     });
	}
	
	function doGetProcess(asyncProcessId, progressCallback, finishCallBack) {
	  setTimeout(function() {
	    var reqDO = {
	      Command: "GetProcess",
	      GetProcess: {
	        AsyncProcessId: asyncProcessId
	      }
	    };
	    
	    vgsService("AsyncProcess", reqDO, false, function(ansDO) {
	      var proc = ansDO.Answer.GetProcess;
	      var sSkip = "";
	      if (proc.QuantitySkip != 0) 
	        sSkip = " - skipped " + proc.QuantitySkip;
	      
	      var pbar = $("#pb-execute");
	      pbar.find(".progressbar-status").text(proc.AsyncProcessName + ": " + proc.PercComplete + "% completed (" + proc.QuantityPos + " / " + proc.QuantityTot + sSkip + ")");
	      pbar.find(".progress-bar").css("width", proc.PercComplete+"%");
	      
	      if (progressCallback)
	        progressCallback(proc);
	      
	      if ((proc.AsyncProcessStatus != <%=LkSNAsyncProcessStatus.Finished.getCode()%>) && 
	    		  (proc.AsyncProcessStatus != <%=LkSNAsyncProcessStatus.Failed.getCode()%>) && 
	          (proc.AsyncProcessStatus != <%=LkSNAsyncProcessStatus.Aborted.getCode()%>)) {
	        doGetProcess(asyncProcessId, progressCallback, finishCallBack);
	      }
	      else if (finishCallBack)
	        finishCallBack(proc);
	    });
	  }, 1000);
	}
</script>