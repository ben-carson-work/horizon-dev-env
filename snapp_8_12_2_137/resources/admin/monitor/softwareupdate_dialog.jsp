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

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" scope="request" class="com.vgs.snapp.dataobject.DORightRoot"/>

<%
DOSoftwareUpdateVersions versions = pageBase.getBL(BLBO_Server.class).getVersions();
%>

<style>

  .snp-toggle {
    padding: 10px 0 20px 0;
    display: inline-block;
  }
  
  .noupdates-title {
    font-size: 1.5em;
    line-height: 1.5em;
    margin-top: 50px;
    text-align: center;
  }
  
  .noupdates-title a {
    font-size: 14px;
  }
  
</style>

<v:dialog id="swupd_dialog" title="@Common.SoftwareUpdate" width="640" height="480" autofocus="false">
  <% if (versions.CurrentMinorLatestBuild.Version.isNull() && 
      versions.LatestRelease.Version.isNull() &&
      (!rights.VGSSupport.getBoolean() || versions.LatestBeta.Version.isNull())) {%>
    <div class="noupdates-title">
      <i>Horizon <v:config key="version"/>
      <p>
        <v:itl key="@System.SoftwareUpToDate"/>
      </p>
      <p>
        <a href="javascript:showVersionsSoftwareUpdateDialog()" class="snp-toggle"><v:itl key="@System.AllOptions"/></a>
      </p>
    </div>
  <% } else { %>
    <div class="hide-on-action">
      <% if (!versions.CurrentMinorLatestBuild.Version.isNull()) {%>
      <v:widget caption="@System.SuggestedVersion">
        <v:widget-block>
          <v:itl key="@System.NewVersionIsAvailable" param1="<%=versions.CurrentMinorLatestBuild.Version.getString() %>"/>
          <% if (versions.CurrentMinorLatestBuild.Downloaded.getBoolean()) {%>
            <% String href= "javascript:doInstall('" + versions.CurrentMinorLatestBuild.FileName + "')"; %>
            <v:button caption="@System.Install" href="<%=href%>" />
          <% } else { %>
            <% String href= "javascript:doDownload('" + versions.CurrentMinorLatestBuild.DownloadURL.toString() + "')"; %>
            <v:button caption="@System.Download" href="<%=href%>" />
          <% } %>
        </v:widget-block>
      </v:widget>
      <% } %>
      <% if (!versions.LatestRelease.Version.isNull() && !versions.LatestRelease.Version.equals(versions.CurrentMinorLatestBuild.Version)) {%>
        <v:widget caption="@System.LatestRelease">
          <v:widget-block>
            <v:itl key="@System.NewReleaseIsAvailable" param1="<%=versions.LatestRelease.Version.getString() %>"/>
            <% if (versions.LatestRelease.Downloaded.getBoolean()) { %>
              <% String href= "javascript:doInstall('" + versions.LatestRelease.FileName + "')"; %>
              <v:button caption="@System.Install" href="<%=href%>" />
            <% } else { %>
              <% String href= "javascript:doDownload('" + versions.LatestRelease.DownloadURL.toString() + "')"; %>
              <v:button caption="@System.Download" href="<%=href%>" />
            <% } %>
          </v:widget-block>
        </v:widget>
      <% } %>
      <% if (rights.VGSSupport.getBoolean() && !versions.LatestBeta.Version.equals(versions.CurrentMinorLatestBuild.Version)) { %>
        <v:widget caption="@System.LatestBeta">
          <v:widget-block>
            <v:itl key="@System.NewBetaIsAvailable" param1="<%=versions.LatestBeta.Version.getString() %>"/>
            <% if (versions.LatestBeta.Downloaded.getBoolean()) { %>
            <% String href= "javascript:doInstall('" + versions.LatestBeta.FileName + "')"; %>
            <v:button caption="@System.Install" href="<%=href%>" />
            <% } else { %>
              <% String href= "javascript:doDownload('" + versions.LatestBeta.DownloadURL + "')"; %>
              <v:button caption="@System.Download" href="<%=href%>" />
            <% } %>
          </v:widget-block>
        </v:widget>
      <% } %>
    </div>
    <a href="javascript:showVersionsSoftwareUpdateDialog()" class="snp-toggle hide-on-action"><v:itl key="@System.AllOptions"/></a>
  <% } %>

  <div id="update-wait" class="spinner32-bg v-hidden" style="height:100px"></div>

  <script>
  
    function showVersionsSoftwareUpdateDialog() {
      $("#swupd_dialog").dialog("close");
      asyncDialogEasy('monitor/versions_dialog');
    }
    
    function doDownload(url) {
      var reqDO = {
        Command: "DownloadWarToDB",
        DownloadWarToDB: {
          DownloadURL: url
        }
      };
      
      vgsService("System", reqDO, false, function(ansDO) {
        $("#swupd_dialog").dialog("close");
        showAsyncProcessDialog(ansDO.Answer.DownloadWarToDB.AsyncProcessId, function() {
          asyncDialogEasy("monitor/softwareupdate_dialog");
        }, true);
      });
    }
    
    function doInstall(warFileName) {
      var msg = <v:itl key="@System.ConfirmUpgradeSoftware" encode="JS" param1="%1"/>.replace("%1", warFileName);
      
      confirmDialog(msg, function() { 
        $(".hide-on-action").hide();
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
            $("#swupd_dialog").dialog("close");
            showMessage(<v:itl key="@System.UpgradeSuccessMessage" encode="JS"/>, function() { 
              window.location.reload();
            });
          }
          else
            setTimeout(doCheckServer, 1000);
        });
      }
    }
    
    function doDelete(warFileName) {
      var reqDO = {
        Command: "DeleteWar",
        DeleteWar: {
          WarFileName: warFileName
        }
      };
      
      vgsService("System", reqDO, false, function(ansDO) {
        $("#swupd_dialog").dialog("close");
        asyncDialogEasy("monitor/softwareupdate_dialog");
      });
    }
  </script>

</v:dialog>
