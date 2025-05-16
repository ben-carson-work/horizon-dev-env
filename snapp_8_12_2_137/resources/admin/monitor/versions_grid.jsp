<%@page import="com.vgs.web.tag.ConfigTag"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>
<jsp:useBean id="rights" scope="request" class="com.vgs.snapp.dataobject.DORightRoot"/>

<%
DOSoftwareUpdateVersions versions = pageBase.getBL(BLBO_Server.class).getVersions();
String lastMinor = "";
%>

<style>
#swupd_versions_dialog [data-status='download'] .progress,
#swupd_versions_dialog [data-status='download'] .install-btn,
#swupd_versions_dialog [data-status='download'] .remove-btn {
  display: none;
}

#swupd_versions_dialog [data-status='progress'] .install-btn,
#swupd_versions_dialog [data-status='progress'] .remove-btn,
#swupd_versions_dialog [data-status='progress'] .download-btn {
  display: none;
}

#swupd_versions_dialog [data-status='install'] .progress,
#swupd_versions_dialog [data-status='install'] .download-btn {
  display: none;
}

#swupd_versions_dialog .progress {
  margin: 6px 0;
}

#swupd_versions_dialog .grid-row .icon {
  width: 32px;
  text-align: center;
  font-size: 2em;
}

#swupd_versions_dialog .grid-row .icon-download {
  opacity: 0.4;
}

#swupd_versions_dialog [data-status='download'] .icon-progress, 
#swupd_versions_dialog [data-status='download'] .icon-install,
#swupd_versions_dialog [data-status='progress'] .icon-download, 
#swupd_versions_dialog [data-status='progress'] .icon-install,
#swupd_versions_dialog [data-status='install'] .icon-progress, 
#swupd_versions_dialog [data-status='install'] .icon-download {
  display: none;
}

</style>

<v:grid clazz="hide-on-action">
  <thead>
    <tr class="header">
      <td></td>
      <td width="33%"><v:itl key="@Common.Version"/></td>
      <td width="33%"><v:itl key="@Common.Size"/></td>
      <td width="34%"></td>
    </tr>
  </thead>
  <tbody>
    <% for (int i = 0; i < versions.UpdateList.getSize(); ++i) {
      DOSoftwareUpdateItem item = versions.UpdateList.getItem(i);
      String minor = SnappUtils.getMinorVersionText(item.Version.getString());
      if (!lastMinor.equals(minor)) {
        lastMinor = minor;
        %><tr class="group"><td colspan="100%"><%=lastMinor%></td></tr><%
      } 
    %>
      <tr class="grid-row" data-version="<%=item.Version.getHtmlString()%>" data-status="<%=item.Downloaded.getBoolean()?"install":"download"%>">
        <td>
          <i class="icon icon-download fa fa-cloud"></i>
          <i class="icon icon-progress fa fa fa-cog fa-spin fa-fw"></i>
          <i class="icon icon-install fa fa-database"></i>
        </td>
        <td><%=item.Version%></td>
        <td><span class="list-subtitle file-size"><%=item.Downloaded.getBoolean()?JvString.getSmoothSize(item.FileSize.getLong()):""%></span></td>
        <td align="right">
          <div class="progress"><div class="progress-bar progress-bar-success"></div></div>
          <v:button caption="@System.Install" onclick="doInstallWar(this)" clazz="install-btn row-hover-visible" />
          <v:button fa="trash" title="@Common.Delete" onclick="doRemoveWar(this)" clazz="remove-btn row-hover-visible" />
          <v:button fa="cloud-download" title="@System.Download" onclick="doDownloadWar(this)" clazz="download-btn row-hover-visible" />
        </td>
      </tr>
    <% } %>
  </tbody>
</v:grid>
<div id="update-wait" class="spinner32-bg v-hidden" style="height:100px"></div>

<script>
function calcWarFileName(version) {
  return "snapp_" + version.replaceAll(".","_") + ".war"
}

function doDownloadWar(elem) {
  var $tr = $(elem).closest("tr").attr("data-status", "progress");
  var version = $tr.attr("data-version");
  var urlo = "https://repository.vgs.com/install/" + calcWarFileName(version);
  console.log(urlo);  

  var $bar = $tr.find(".progress");
  $bar.find(".progress-bar").css("width", "0").empty();

  var reqDO = {
    Command: "DownloadWarToDB",
    DownloadWarToDB: {
      DownloadURL: urlo
    }
  };
  
  vgsService("System", reqDO, false, function(ansDO) {
    $bar.asyncProcessProgressBar({
      AsyncProcessId: ansDO.Answer.DownloadWarToDB.AsyncProcessId,
      onProgress: function(process) {
        $tr.find(".file-size").text(getSmoothSize(process.QuantityPos));
      },
      onComplete: function(process) {
        $tr.attr("data-status", "install");
        $tr.find(".file-size").text(getSmoothSize(process.QuantityTot));
      },
      onError: function(process) {
        $tr.attr("data-status", "download");
        $tr.find(".file-size").empty();
      }
    });
  });
}

function doInstallWar(elem) {
  var $tr = $(elem).closest("tr");
  var warFileName = calcWarFileName($tr.attr("data-version"));
  var msg = <v:itl key="@System.ConfirmUpgradeSoftware" encode="JS" param1="%1"/>.replace("%1", warFileName);
  
  confirmDialog(msg, function() { 
    $(".hide-on-action").addClass("v-hidden");
    $("#update-wait").removeClass("v-hidden");
    
    var reqDO = {
      Command: "InstallWarFromDB",
      InstallWarFromDB: {
        WarFileName: warFileName
      }
    };
    
    vgsService("System", reqDO, false, function(ansDO) {
      setTimeout(doCheckServer, 10000);
    }); 
  });
  
  function doCheckServer() {
    vgsService("Watchdog", {}, true, function(ansDO) {
      
      if (ansDO && ansDO.Header && ((ansDO.Header.StatusCode == 200) || (ansDO.Header.StatusCode == <%=LkSNErrorCode.DatabaseUpdateNeeded.getCode()%>))) {
        $("#swupd_versions_dialog").dialog("close");
        showMessage("<v:itl key="@System.UpgradeSuccessMessage" encode="UTF-8"/>", function() { 
          window.location.reload();
        });
      }
      else
        setTimeout(doCheckServer, 1000);
    });
  }
}

function doRemoveWar(elem) {
  var $tr = $(elem).closest("tr");
  var warFileName = calcWarFileName($tr.attr("data-version"));
  
  var reqDO = {
    Command: "DeleteWar",
    DeleteWar: {
      WarFileName: warFileName
    }
  };
  
  showWaitGlass();
  vgsService("System", reqDO, false, function(ansDO) {
    hideWaitGlass();
    $tr.attr("data-status", "download");
    $tr.find(".file-size").empty();
  });
}
</script>