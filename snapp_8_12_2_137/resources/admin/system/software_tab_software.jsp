<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.library.SnappUtils"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.service.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.store.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSoftware" scope="request"/>
<jsp:useBean id="rights" scope="request" class="com.vgs.snapp.dataobject.DORightRoot"/>
<jsp:useBean id="pageSoftware" scope="request" class="com.vgs.snapp.dataobject.DOPageSoftware"/>

<v:tab-content>
<div page-status="loading">
  
  <v:widget clazz="swupdates-spinner">
    <v:widget-block clazz="swupdates-spinner-div"><i class='fa fa-circle-notch fa-spin fa-fw'></i></v:widget-block>
  </v:widget>
  
  <v:grid id="snappupdate" clazz="hide-on-action">
    <thead><v:grid-title caption="Core modules"/></thead>
    <tbody>
      <tr class="header">
        <td width="2%"/>
        <td/>
        <td width="50%"><v:itl key="@Common.Module"/></td> 
        <td width="16%"><v:itl key="@Common.Installed"/></td>
        <td width="16%"><v:itl key="@Common.Available"/></td>
        <td width="16%"/>
      </tr>
      
      <tr class="group"><td colspan="100%"><v:itl key="@Common.BackOffice"/></td></tr>
      <tr id="bko-suggested" class="grid-row" data-status="null" downloadurl="">
        <td/>
        <td><v:grid-icon name="<%=LkSNEntityType.Server.getIconName()%>"/></td>
        <td class="minorvers">
          <div class="list-title"><%=SnappUtils.getMinorVersionText(BLBO_DBInfo.getWebInit().getWarVersion())%></div>
          <div class="list-subtitle"><v:itl key="@System.SuggestedVersion" /></div>
        </td>
        <td>
          <div><%=BLBO_DBInfo.getWebInit().getWarVersion()%></div>
          <div>&nbsp;</div>
        </td>
        <td>
          <div class="avaiable-vers"></div>
          <div class="list-subtitle"><span class="file-size"></span></div>
        </td>
        <td>
          <div id="suggwar-progress" class="progress"><div class="progress-bar progress-bar-success"></div></div>
          <v:button fa="download" caption="@System.Install" onclick="doInstallWar(1)" clazz="install-btn" />
          <v:button fa="cloud-download" caption="@System.Download" onclick="doDownloadWar(this)" clazz="download-btn" />
          <div class="textLastCol uptodate-div"><span class="badge uptodate-badge"><v:itl key="@System.UpToDate"/></span></div>
          <div class="textLastCol loading-div"><span class="badge loading-badge"><v:itl key="@Common.Loading"/></span></div>
        </td>
      </tr>
      <tr id="bko-latrelease" class="grid-row v-hidden" data-status="null" downloadurl="">
        <td/>
        <td><v:grid-icon name="<%=LkSNEntityType.Server.getIconName()%>"/></td>
        <td class="minorvers">
          <div class="list-title"></div>
          <div class="list-subtitle"><v:itl key="@System.LatestRelease" /></div>
        </td>
        <td>
          <div><%=BLBO_DBInfo.getWebInit().getWarVersion()%></div>
          <div>&nbsp;</div>
        </td>
        <td>
          <div class="avaiable-vers"></div>
          <div class="list-subtitle"><span class="file-size"></span></div>
        </td>
        <td>
          <div id="suggwar-progress" class="progress"><div class="progress-bar progress-bar-success"></div></div>
          <v:button fa="download" caption="@System.Install" onclick="doInstallWar(2)" clazz="install-btn" />
          <v:button fa="cloud-download" caption="@System.Download" onclick="doDownloadWar(this)" clazz="download-btn" />
          <div class="textLastCol uptodate-div"><span class="badge uptodate-badge"><v:itl key="@System.UpToDate"/></span></div>
          <div class="textLastCol loading-div"><span class="badge loading-badge"><v:itl key="@Common.Loading"/></span></div>
        </td>
      </tr>
      <% if (rights.VGSSupport.getBoolean()) { %>
        <tr id="bko-wip" class="grid-row v-hidden" data-status="null" downloadurl="">
          <td/>
          <td><v:grid-icon name="<%=LkSNEntityType.Server.getIconName()%>"/></td>
          <td class="minorvers">
            <div class="list-title"></div>
            <div class="list-subtitle"><v:itl key="@System.LatestBeta" /></div>
          </td>
          <td>
            <div><%=BLBO_DBInfo.getWebInit().getWarVersion()%></div>
            <div>&nbsp;</div>
          </td>
          <td>
            <div class="avaiable-vers"></div>
            <div class="list-subtitle"><span class="file-size"></span></div>
          </td>
          <td>
            <div id="suggwar-progress" class="progress"><div class="progress-bar progress-bar-success"></div></div>
            <v:button fa="download" caption="@System.Install" onclick="doInstallWar(3)" clazz="install-btn" />
            <v:button fa="cloud-download" caption="@System.Download" onclick="doDownloadWar(this)" clazz="download-btn" />
            <div class="textLastCol uptodate-div"><span class="badge uptodate-badge"><v:itl key="@System.UpToDate"/></span></div>
            <div class="textLastCol loading-div"><span class="badge loading-badge"><v:itl key="@Common.Loading"/></span></div>
          </td>
        </tr>
      <% } %>
      <tr>
        <td/>
        <td colspan="6">
          <span id="bko-otheropt" class="v-hidden"><a class="bko-hide" href="javscript:void(0)" onclick="showHideOptions(this)"><v:itl key="@System.ShowOtherOptions"/></a> - </span> 
          <a href="javascript:showWarVersionsDialog()"><v:itl key="@System.AllVersions"/></a>
        </td>
      </tr>
    
      <tr class="group"><td colspan="100%"><v:itl key="@Lookup.WorkstationType.POS"/></td></tr>
        <tr id="pos-suggested" class="grid-row" data-status="null">
          <td/>
          <td><v:grid-icon name="station.png"/></td>
          <td>
            <div class="list-title"><%=SnappUtils.getMinorVersionText(BLBO_DBInfo.getWebInit().getWarVersion()) %></div>
            <div class="list-subtitle"><v:itl key="@System.SuggestedVersion" /></div>
          </td>
          <td>
            <div class="installed-vers"><%=pageSoftware.PosInstalledVersion.getHtmlString()%></div>
            <div>&nbsp;</div>
          </td>
          <td>
            <div class="avaiable-vers"></div>
            <div class="list-subtitle"><span class="file-size"></span></div>
          </td>
          <td>
            <v:button clazz="install-btn" fa="download" caption="@Common.Update" onclick="doUpdateClient(this)" />
            <div class="textLastCol uptodate-div"><span class="badge uptodate-badge"><v:itl key="@System.UpToDate"/></span></div>
            <div class="textLastCol loading-div"><span class="badge loading-badge"><v:itl key="@Common.Loading"/></span></div>
          </td>
        </tr>
      <tr>
        <td/>
        <td colspan="5"><a href="javascript:showClientVersionsDialog()"><v:itl key="@System.AllVersions"/></a></td>
      </tr>
    </tbody>
  </v:grid>
  
  <jsp:include page="software_tab_software_extpackage.jsp"></jsp:include>
</div>

<style>
.install-btn,
.download-btn {
  width: 150px;
}

.textLastCol {
  width: 150px;
  text-align: center;
}

.uptodate-badge {
  background-color: var(--base-green-color);
}

.loading-badge {
  background-color: var(--base-gray-color);
}

.swupdates-spinner-div {
  text-align: center;
  font-size: 32px;
}

#snappupdate .progress {
  margin: 6px 0;
}

#snappupdate .grid-row .icon {
  width: 32px;
  text-align: center;
  font-size: 2em;
}

#snappupdate [data-status='download'] .progress,
#snappupdate [data-status='download'] .install-btn, 
#snappupdate [data-status='download'] .uptodate-div,
#snappupdate [data-status='download'] .loading-div {
  display: none;
}

#snappupdate [data-status='progress'] .install-btn,
#snappupdate [data-status='progress'] .download-btn,
#snappupdate [data-status='progress'] .uptodate-div,
#snappupdate [data-status='progress'] .loading-div {
  display: none;
}

#snappupdate [data-status='install'] .progress,
#snappupdate [data-status='install'] .download-btn,
#snappupdate [data-status='install'] .uptodate-div,
#snappupdate [data-status='install'] .loading-div {
  display: none;
}

#snappupdate [data-status='null'] .progress,
#snappupdate [data-status='null'] .download-btn,
#snappupdate [data-status='null'] .install-btn,
#snappupdate [data-status='null'] .uptodate-div {
  display: none;
}

#snappupdate [data-status='uptodate'] .progress,
#snappupdate [data-status='uptodate'] .download-btn,
#snappupdate [data-status='uptodate'] .install-btn,
#snappupdate [data-status='uptodate'] .loading-div {
  display: none;
}

[page-status='loaded'] .swupdates-spinner {
  display: none;
}

[page-status='installwar'] .hide-on-action {
  display: none;
}

</style>

<script>
$(document).ready(function() {
  // Call the VSG-Store API
  var reqDO = {
    Command: "SoftwareUpdateInfo"
  };
  
  vgsService("System", reqDO, false, function(ansDO) {
    // BKO
    var suggVersion = "";
    var activateOthOptions = false;
    
    if (ansDO.Answer.SoftwareUpdateInfo.BKO_Suggested != undefined) { 
      doHandleBKO(ansDO.Answer.SoftwareUpdateInfo.BKO_Suggested, $('#bko-suggested'));
      suggVersion = ansDO.Answer.SoftwareUpdateInfo.BKO_Suggested.Version;
    }
    else 
      $('#bko-suggested').attr("data-status", "uptodate");
      
    if (ansDO.Answer.SoftwareUpdateInfo.BKO_LatestRelease != undefined) {
      $('#bko-latrelease').addClass('bko-showhide');
      activateOthOptions = true;
      doHandleBKO(ansDO.Answer.SoftwareUpdateInfo.BKO_LatestRelease, $('#bko-latrelease'));
    }
    else
      $('#bko-latrelease').addClass('v-hidden');
    
    <% if (rights.VGSSupport.getBoolean()) { %>
        if (ansDO.Answer.SoftwareUpdateInfo.BKO_LatestWIP != undefined) {
          if (ansDO.Answer.SoftwareUpdateInfo.BKO_LatestWIP.Version != undefined 
              && ansDO.Answer.SoftwareUpdateInfo.BKO_LatestWIP.Version != suggVersion) {
            $('#bko-wip').addClass('bko-showhide');
            activateOthOptions = true;
            doHandleBKO(ansDO.Answer.SoftwareUpdateInfo.BKO_LatestWIP, $('#bko-wip'));
          }
        }
        else
          $('#bko-wip').addClass('v-hidden');
    <% } %>
    
    if (activateOthOptions)
     $('#bko-otheropt').removeClass('v-hidden');
    
    // POS
    doHandlePOS(ansDO.Answer.SoftwareUpdateInfo.POS_Suggested, $('#pos-suggested'));
    
    // Package
    $(document).trigger("software-update", ansDO.Answer.SoftwareUpdateInfo);
    
    $('.tab-content').attr("page-status","loaded");
  });
});

function doHandlePOS (obj, $tr) {
  if (obj != undefined && obj.VgsBoardVersion != <%=pageSoftware.PosInstalledVersion.getJsString()%>) {
      $('#pos-suggested').attr("data-status", "install");
      $('#pos-suggested').find('.file-size').text(getSmoothSize(obj.FileSize));
      $('#pos-suggested').find('.avaiable-vers').text(obj.VgsBoardVersion);
    } 
  else
    $('#pos-suggested').attr("data-status", "uptodate");
}
 
function doHandleBKO (obj, $tr) {
  if (obj.Downloaded)
    $tr.attr("data-status", "install");
  else
    $tr.attr("data-status", "download");
  
  var minVersion = obj.Version.substring(0, obj.Version.lastIndexOf('.')) + '.X';
  $tr.find('.minorvers > .list-title').text(minVersion);
  
  $tr.find('.avaiable-vers').text(obj.Version);
  $tr.find('.file-size').text(getSmoothSize(obj.FileSize));
  
  $tr.attr("downloadurl", obj.DownloadURL);
}

function doDownloadWar(elem) {
  var $tr = $(elem).closest("tr").attr("data-status", "progress");  
  var $bar = $(elem).closest("tr");
  var urlo = $tr.attr('downloadurl');
  
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
        $tr.find(".war-file-size").text(getSmoothSize(process.QuantityPos));
      },
      onComplete: function(process) {
        $tr.attr("data-status", "install");
        $tr.find(".war-file-size").text(getSmoothSize(process.QuantityTot));
      },
      onError: function(process) {
        $tr.attr("data-status", "download");
        $tr.find(".war-file-size").empty();
      }
    });
  });
}

function doInstallWar(type) {
  var msg = "";
  var warFileName = "";
  if (type == 1) {
    warFileName = $('#bko-suggested').find('.avaiable-vers').text();
    msg = itl("@System.ConfirmUpgradeSoftware", warFileName);
  }
  else {
    if (type == 2)
      warFileName = $('#bko-latrelease').find('.avaiable-vers').text();
    else
      warFileName = $('#bko-wip').find('.avaiable-vers').text();
    msg = itl("@System.ConfirmUpgradeRelWIP", warFileName);
  }

  warFileName = 'snapp_' + warFileName.replaceAll('.','_') + '.war';
  
  confirmDialog(msg, function() {
    $('.tab-content').attr("page-status","installwar")
    
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
        showMessage(itl("@System.UpgradeSuccessMessage"), function() { 
          location.reload();
        });
      }
      else
        setTimeout(doCheckServer, 1000);
    });
  }
}

function showWarVersionsDialog() {
  asyncDialogEasy('monitor/versions_dialog');
}

function showClientVersionsDialog() {
  asyncDialogEasy('system/posversions_dialog');
}

function doUpdateClient(elem) {
  var reqDO = {
    Command: "SaveAccount",
    SaveAccount: {
      AccountId                : <%=JvString.jsString(pageBase.getSession().getMasterAccountId())%>,
      EntityType               : <%=LkSNEntityType.Licensee.getCode()%>,
      LicenseId                : <%=BLBO_DBInfo.getLicenseId()%>,
      ClientRequiredVersion    : $(elem).closest("tr").find('.avaiable-vers').text()
    }
  };

  showWaitGlass();
  vgsService("Account", reqDO, false, function(ansDO) {
    hideWaitGlass();
    location.reload();
  });
}

function showHideOptions(elem) {
  if ($(elem).hasClass('bko-hide')) {
    $(elem).removeClass('bko-hide');
    $(elem).addClass('bko-show');
    $(elem).text(itl("@System.HideOtherOptions"));
    $('.bko-showhide').removeClass('v-hidden');
  }
  else {
    $(elem).removeClass('bko-show');
    $(elem).addClass('bko-hide');
    $(elem).text(itl("@System.ShowOtherOptions"));
    $('.bko-showhide').addClass('v-hidden');
  }
}
</script>
</v:tab-content>
