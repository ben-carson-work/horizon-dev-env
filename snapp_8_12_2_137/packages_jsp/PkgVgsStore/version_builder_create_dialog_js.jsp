<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.snapp.lookup.LkSN"%>
<%@page import="com.vgs.cl.lookup.LookupItem"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request" />
<script>

$(document).ready(function() {
  var dlg = $("#version_builder_create_dialog");

  dlg.bind("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        "text": "Create",
        "id": "create-version-btn-create",
        "click": generateVersion,
        "disabled": true
      },
      {
        "text": <v:itl key="@Common.Close" encode="JS"/>,
        "id": "create-version-btn-close",
        "click": function() {
          var msg = "Are you sure you want to close the wizard?";          
          confirmDialog(msg, function() {
            dlg.dialog("close");            
          });
        },
        "disabled": false
      }
    ];
  });
  loadProjects();
});

function loadProjects() {
  var reqDO = {
    Command: "GetVersions",
    GetVersions: {}
  };
  
  vgsService("VersionBuilder", reqDO, false, function(ansDO) {
    $(".wizard").removeClass("waiting");
     
    if ((ansDO.Answer) && (ansDO.Answer.GetVersions) && (ansDO.Answer.GetVersions.DOVersionBuilder))
      renderProject(ansDO.Answer.GetVersions.DOVersionBuilder.ProjectList);
   });
}

function renderProject(projectList) {
  for (var i=0; i<projectList.length; i++) {
    var project = projectList[i];
    var container = $("#project-widget .widget-block");
    var projectItem = $("<div class='project-row'>" + project.ProjectName + "</div>");
    
    projectItem.data("selectedProject", project.ProjectName);
    projectItem.data("versions", project.VersionList);
    
    var ele = projectItem.appendTo(container);
    ele.click(clickProject);
  }
}

function renderVersions(versionList) {
  for (var i=0; i<versionList.length; i++) {
    var baseVersion = versionList[i].BaseVersion;
    var container = $("#version-widget .widget-block");
    var versionItem = $("<div class='version-row'>" + baseVersion + "</div>");
  
    versionItem.data("recap", versionList[i]);
    versionItem.data("releaseVersionId", versionList[i].ReleaseVersionId);
    
    var ele = versionItem.appendTo(container);
    ele.click(clickVersion);
  }
}

function renderRecap(versionRecap) {
  var container = $("#recap-widget .widget-block");
  
  recapNew = $(".recap-version-block").clone().removeClass("hidden");
  recapRelease = $(".recap-version-block").clone().removeClass("hidden");
  recapArchive = $(".recap-version-block").clone().removeClass("hidden");
  
  $(recapNew).find(".recap-description").html("<span class='span-desc label-new'>CREATE</span> &rarr; <span class='span-desc label-unreleased'>UNRELEASED</span>");
  $(recapRelease).find(".recap-description").html("<span class='span-desc label-unreleased'>UNRELEASED</span> &rarr; <span class='span-desc label-released'>RELEASED</span>");
  $(recapArchive).find(".recap-description").html("<span class='span-desc label-released'>RELEASED</span> &rarr; <span class='span-desc label-archived'>ARCHIVED</span>");
  
  $(recapNew).find(".recap-version").addClass("new").text(selectedProject + " " + versionRecap.NewVersion);
  $(recapRelease).find(".recap-version").addClass("release").text(selectedProject + " " + versionRecap.ReleaseVersion);
  $(recapArchive).find(".recap-version").addClass("archive").text(selectedProject + " " + versionRecap.ArchiveVersion);
  
  recapNew.appendTo(container);
  recapRelease.appendTo(container);
  recapArchive.appendTo(container);
}

function clickProject() {
  $(".version-row").remove();
  $(".widget-block .recap-version-block").remove();
  $("#project-widget .project-row").removeClass("selected");
  $(this).addClass("selected");

  selectedProject = $(this).data("selectedProject");
  versionList = $(this).data("versions");
  
  renderVersions(versionList);
  updateButtonsVisibility();
}

function clickVersion() {
  $(".widget-block .recap-version-block").remove();
  $("#version-widget .version-row").removeClass("selected");
  $(this).addClass("selected");

  versionRecap = $(this).data("recap");
  releaseVersionId = $(this).data("releaseVersionId");
  
  renderRecap(versionRecap);
  
  updateButtonsVisibility();
}

function updateButtonsVisibility() {
  if ($(".recap-version-block").length > 1)
    $("#create-version-btn-create").prop("disabled", false);
  else
    $("#create-version-btn-create").prop("disabled", true);
}

function generateVersion() {
  var dlg = $("#version_builder_create_dialog");
  var reqDO = {
    Command: "StartGeneration",
    StartGeneration: {
      "ProjectName": selectedProject,
      "ArchiveVersion": versionRecap.ArchiveVersion,
      "NewVersion": versionRecap.NewVersion,
      "ReleaseVersion": versionRecap.ReleaseVersion,
      "ReleaseVersionId":releaseVersionId
    }
  };
  	  
  showWaitGlass();
  vgsService("VersionBuilder", reqDO, false, function(ansDO) {
      hideWaitGlass();
      dlg.dialog("close");
      
      showMessage("Version \"" + selectedProject + " " + versionRecap.NewVersion + "\" created succesfully!");
   });
  
}
</script>