<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<div id="override_versions_dialog">

	<v:form-field caption="New WIP version" hint="You need to insert the base version (EX. 8.7.6)">
	  <v:input-text field="newWipBaseVersion"/>
	</v:form-field>
	<v:form-field caption="New Release version" hint="You need to insert the base version (EX. 8.7.6)">
	  <v:input-text field="newCompileBaseVersion"/>
	</v:form-field> 

<script>

$(document).ready(function() {
  var dlg = $("#override_versions_dialog");
  dlg.dialog({
    title: "Override versions",
    modal: true,
    width: 400,
    height: 200,
    close: function() {
      dlg.remove();
    },
    buttons: {
      Apply : function() {
        overrideVersions();
        dlg.dialog("close");
      }
    }
  });
});

function overrideVersions() {
  
  var projectList = $("#code_freeze_generation_dialog").data("projectListData");
  var newWipBaseVersion = $("#newWipBaseVersion").val();
  var newCompileBaseVersion = $("#newCompileBaseVersion").val();
  
  try{
    checkVersions(newWipBaseVersion, newCompileBaseVersion)
    
    if (newWipBaseVersion!="") {
      var newWipReleaseVersion = newWipBaseVersion + ".0";
      var newWipUnreleaseVersion = newWipBaseVersion + ".1";
    }
      
    if (newCompileBaseVersion!="") {
      var newCompileReleseVersion = newCompileBaseVersion + ".0";
      var newCompileUnreleseVersion = newCompileBaseVersion + ".1";
    }
    
    projectList.forEach(function(project) {
      if (newWipBaseVersion!="") {
        project.WIPReleaseVersion = newWipReleaseVersion;
        project.WIPUnreleaseVersion = newWipUnreleaseVersion;
      }

      if (newCompileBaseVersion!="") {
        project.CompileReleaseVersion = newCompileReleseVersion;
        project.CompileUnreleaseVersion = newCompileUnreleseVersion;
      }
    })
    
    $("#code_freeze_generation_dialog").data("projectListData", projectList);
    renderProjects(projectList);
  }
  catch (errorMsg) {
    showMessage(errorMsg);
  }
}

function checkVersions(newWipBaseVersion, newCompileBaseVersion) {
  if (newWipBaseVersion=="" && newCompileBaseVersion=="")
    throw ("Insert at least one version");
  
  if (newWipBaseVersion!="") {
    splitVersion = newWipBaseVersion.split(".");
    if (splitVersion.length != 3)
      throw ("You need to insert the base version. [" + newWipBaseVersion + "]");
    
    if (splitVersion[splitVersion.length-1] % 2 != 0)
      throw ("You cannot use an odd number for the WIP minor version number. [" + newWipBaseVersion + "]");
  }
  
  if (newCompileBaseVersion!="") {
    splitVersion = newCompileBaseVersion.split(".");
    if (splitVersion.length != 3)
      throw ("You need to insert the base version. [" + newCompileBaseVersion + "]");
    
    if (splitVersion[splitVersion.length-1] % 2 == 0)
      throw ("You cannot use an even number for the RELEASE minor version number. [" + newCompileBaseVersion + "]");
  }

}

</script>

</div>


