<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.broadcast.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="java.sql.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageWorkstationMonitor" scope="request"/>

<script type="text/javascript">  
var webSocketURL = <%=JvString.jsString(SnappUtils.calcWebSocketURL(pageBase.getBackofficeURL()))%>;
var connected = false;
var webSocket = null;

var lkAptPassage = {};
<% for (LookupItem item : LkSN.AccessPointControl.getItems()) { %>
  lkAptPassage["<%=item.getCode()%>"] = <%=JvString.jsString(item.getDescription(pageBase.getLang()))%>;
<% } %>

var lkAptReentry = {};
<% for (LookupItem item : LkSN.AccessPointReentryControl.getItems()) { %>
  lkAptReentry["<%=item.getCode()%>"] = <%=JvString.jsString(item.getDescription(pageBase.getLang()))%>;
<% } %>
      
$(document).ready(function() {
  reconnectLoop();
  $("#btn-select-all").click(onClick_SelectAll);
  $("#btn-unselect-all").click(onClick_UnselectAll);
  $("#btn-actions").click(onClick_Actions);
  $("#menu-config").click(onClick_Config);
  $("#menu-droparm").click(onClick_DropArm);
  $("#menu-skip-rotation").click(onClick_SkipRotation);
  $("#menu-restart").click(onClick_Restart);
  doEnableDisable();
});

function reconnectLoop() {
  if (!connected) {
    //console.log("trying reconnect");
    webSocket = new WebSocket(webSocketURL); 
    webSocket.onopen = function() {
      connected = true;
      $("#wks-monitor-tab").attr("data-Status", "online");
      sendHandShake();
    };
    webSocket.onclose = function(event) {
      //console.log("websocket CLOSE");
      connected = false;
      $("#wks-monitor-tab").attr("data-Status", "offline");
      $(".apt-container").attr("data-Status", "");
      setTimeout(reconnectLoop, 1000);
    };
    webSocket.onerror = function(event) {
      //console.log("websocket ERROR");
    };
    webSocket.onmessage = function(event) {
      console.log("wesocket message: " + event.data);
      var status = JSON.parse(event.data);
      if (status.Header) {
        if (status.Header.RequestCode == <%=JvString.jsString(DOBcstStatus_AccessPoint.CMD)%>)
          renderAccessPointStatus(status.Message);
        else if (status.Header.RequestCode == <%=JvString.jsString(DOBcstStatus_WksConnection.CMD)%>) 
          handleWorkstationConnection(status.Header.WorkstationId, status.Message.Open);
      }
    };
  }
}

function sendHandShake(event) {
  //console.log("wesocket opened: sending handshake...");
  var reqDO = {
    Header: {
      RequestCode: <%=JvString.jsString(DOBcst_Handshake.CMD)%>,
      WorkstationId: <%=JvString.jsString(pageBase.getSession().getWorkstationId())%>
    },
    Request: {
      StatusList: []
    }
  };

  $(".apt-container").each(function(index, elem) {
    reqDO.Request.StatusList.push({
      SrcWorkstationId: $(elem).attr("data-WorkstationId"),
      BroadcastNames: [<%=JvString.jsString(DOBcstStatus_WksConnection.CMD)%>, <%=JvString.jsString(DOBcstStatus_AccessPoint.CMD)%>]
    });
  });
  console.log(reqDO);
  webSocket.send(JSON.stringify(reqDO));
  
  aptKeepAliveLoop(webSocket, true);
}

function aptKeepAliveLoop(activeWebSocket, immediateStatus) {
  if (connected) {
    $(".apt-container").each(function(index, elem) {
      var workstationId = $(elem).attr("data-WorkstationId");
      var accessPointId = $(elem).attr("id");
      doActivateStatusDispatch(workstationId, accessPointId, immediateStatus);
    });
  }

  // Keeps polling only if connection has not been reset, because in that case a new keep-alive-loop will be enstablished
  if (webSocket == activeWebSocket) {
    setTimeout(function() {
      aptKeepAliveLoop(activeWebSocket, false);
    }, 60000);
  }
}

function renderAccessPointStatus(message) {
//  console.log(message);
  
  function _getPassageIconName(prefix, passageStatus) {
    var iconName = "adm_" + prefix + "_";
    if (passageStatus == <%=LkSNAccessPointControl.Closed.getCode()%>)
      iconName += "red";
    else if (passageStatus == <%=LkSNAccessPointControl.Controlled.getCode()%>)
      iconName += "blue";
    else if (passageStatus == <%=LkSNAccessPointControl.Free.getCode()%>)
      iconName += "green";
    else if (passageStatus == <%=LkSNAccessPointControl.SimRotation.getCode()%>)
      iconName += "orange";
    return iconName + ".png";
  }
  
  function _getPassageIcon(iconName, active, title) {
    var result = $("<img class='apt-icon " + (active ? "active" : "") + "' src='<v:config key="site_url"/>/imagecache?size=32&name=" + iconName + "'/>");
    result.attr("title", title);
    return result;
  }

  var apt = $("#" + message.AccessPointId);
  apt.attr("data-Status", message.Status);
  apt.attr("data-EntryControl", message.EntryControl);
  apt.attr("data-ReentryControl", message.ReentryControl);
  apt.attr("data-ExitControl", message.ExitControl);
 
  if (message.Status == "<%=LkSNAccessPointStatus.Error.getCode()%>") {
    apt.find(".apt-body-error").text(message.ErrorMessage);    
  }
  else {
    var divOpMsg = apt.find(".apt-op-message");
    var divOpMsgText = divOpMsg.find(".apt-op-message-text");
    divOpMsgText.text(message.OperatorMessage);
    divOpMsgText.html(divOpMsg.html().replace("\n", "<br/>"));
    
    // Vertically centering operator message
    var oh = divOpMsg.height();
    var ih = divOpMsgText.height();
    var m = 0;
    if (oh > ih)
      m = (oh - ih) / 2;
    divOpMsgText.css("margin-top", m + "px");
    
    var imgEntry = _getPassageIconName("entry", message.EntryControl);
    var imgReentry = _getPassageIconName("reentry", message.EntryControl);
    var imgExit = _getPassageIconName("exit", message.ExitControl);
    if (message.ReentryControl == <%=LkSNAccessPointReentryControl.FirstEntryOnly.getCode()%>) 
      imgReentry = "adm_reentry_red.png";
    else if (message.ReentryControl == <%=LkSNAccessPointReentryControl.ReentryOnly.getCode()%>) 
      imgEntry = "adm_entry_red.png";

    var divPassage = apt.find(".apt-passage-status").empty();
    var hintReader = <v:itl key="@AccessPoint.Reader" encode="JS"/> + ": " + (message.ReaderActive ? <v:itl key="@Common.Active" encode="JS"/> : <v:itl key="@Common.Inactive" encode="JS"/>);
    divPassage.append(_getPassageIcon("adm_reader_green.png", message.ReaderActive, hintReader));
    divPassage.append(" ");
    divPassage.append(_getPassageIcon(imgEntry, true, <v:itl key="@AccessPoint.EntryControl" encode="JS"/> + ": " + lkAptPassage[message.EntryControl]));
    divPassage.append(" ");
    divPassage.append(_getPassageIcon(imgReentry, true, <v:itl key="@AccessPoint.ReentryControl" encode="JS"/> + ": " + lkAptReentry[message.ReentryControl]));
    divPassage.append(" ");
    divPassage.append(_getPassageIcon(imgExit, true, <v:itl key="@AccessPoint.ExitControl" encode="JS"/> + ": " + lkAptPassage[message.ExitControl]));
    
    apt.find(".apt-icon-good").setClass("active", message.GoodLight);
    apt.find(".apt-icon-bad").setClass("active", message.BadLight);
    apt.find(".apt-icon-reentry").setClass("active", message.ReentryLight);
    apt.find(".apt-icon-flash").setClass("active", message.FlashLight);
    
    apt.find(".apt-rotin .apt-rot-wait").text(strToIntDef(message.WaitingRotationsIn, 0));
    apt.find(".apt-rotin .apt-rot-total").text(strToIntDef(message.TotalEntries, 0));
    apt.find(".apt-rotout .apt-rot-wait").text(strToIntDef(message.WaitingRotationsOut, 0));
    apt.find(".apt-rotout .apt-rot-total").text(strToIntDef(message.TotalExits, 0));
    apt.find(".apt-user .apt-value").text((message.LoggedUserAccountName) ? message.LoggedUserAccountName : "- unmanned -");
  }
}

function handleWorkstationConnection(workstationId, open) {
  $(".apt-container[data-WorkstationId='" + workstationId + "']").each(function(index, elem) {
    var wks = $(elem);
    if (open)
      doActivateStatusDispatch(wks.attr("data-WorkstationId"), wks.attr("id"), true);
    else 
      wks.attr("data-Status", "");      
  });
}

function doActivateStatusDispatch(workstationId, accessPointId, immediateStatus) {
//console.log("doActivateStatusDispatch - " + workstationId + " " + accessPointId + " - " + immediateStatus);
  vgsBroadcastCommand(false, workstationId, "AccessPoint", {
    Command: "ActivateStatusDispatch",
    ActivateStatusDispatch: {
      AccessPointIDs: accessPointId,
      ValidityMin: 2,
      ImmediateStatus: immediateStatus
    }
  });
}

function doDropArm(workstationId, accessPointIDs) {
  
}

function doEnableDisable() {
  var totApts = $(".apt-container");
  var selApts = totApts.filter(".selected");
  $("#btn-select-all").setClass("v-hidden", totApts.length == selApts.length);
  $("#btn-unselect-all").setClass("v-hidden", totApts.length != selApts.length);
  
  $("#btn-actions").setClass("v-hidden", false);
  $("#btn-actions").setEnabled(selApts.length > 0);
}

/**
 * Return an object having ControllerWorkstationId as keys, and AccessPointIDs as values
 */
function getSelectedAccessPoints() {
  var result = {};
  $(".apt-container.selected").each(function(index, elem) {
    var accessPointId = $(elem).attr("id");
    var workstationId = $(elem).attr("data-WorkstationId");
    if (!(result[workstationId]))
      result[workstationId]= [];
    result[workstationId].push(accessPointId);
  });
  return result;
}
    
function onAccessPointClick(elem) {
  if (!event.ctrlKey)
    $(".apt-container.selected").removeClass("selected");
  $(elem).toggleClass("selected");
  doEnableDisable();
}

function onAccessPointMenu(elem) {
  if (!$(elem).hasClass("selected")) {
    $(".apt-container.selected").removeClass("selected");
    $(elem).addClass("selected");
  }
  
  doEnableDisable();
  popupMenu("#actions-menu", null, event);

  event.preventDefault();
}

function onClick_SelectAll() {
  if ($(this).isEnabled()) {
    $(".apt-container").addClass("selected");
    doEnableDisable();
  }  
}

function onClick_UnselectAll() {
  if ($(this).isEnabled()) {
    $(".apt-container").removeClass("selected");
    doEnableDisable();
  }  
}

function onClick_Actions() {
  if ($(this).isEnabled()) {
    popupMenu("#actions-menu", this, event);
  }  
}

function onClick_Config() {
  function _chooseStatus(overallStatus, thisStatus) {
    if ((overallStatus != null) && !isNaN(thisStatus)) 
      return (overallStatus == -1) ? thisStatus : null;
    return overallStatus;
  }
  
  if ($(this).isEnabled()) {
    var dlg = $("#dlg-apt-changestatus");
    var entryControl = -1;
    var reentryControl = -1;
    var exitControl = -1;
    $(".apt-container.selected").each(function(index, elem) {
      entryControl = _chooseStatus(entryControl, parseInt($(elem).attr("data-EntryControl")));
      reentryControl = _chooseStatus(reentryControl, parseInt($(elem).attr("data-ReentryControl")));
      exitControl = _chooseStatus(exitControl, parseInt($(elem).attr("data-ExitControl")));
    });

    dlg.find("[name='EntryControl']").val(entryControl);
    dlg.find("[name='ReentryControl']").val(reentryControl);
    dlg.find("[name='ExitControl']").val(exitControl);
    
    dlg.dialog({
      modal: true,
      title: <v:itl key="@Common.Status" encode="JS"/>,
      buttons: {
        <v:itl key="@Common.Ok" encode="JS"/>: function() {
          var apts = getSelectedAccessPoints();
          for (var workstationId in apts) {
            if (apts.hasOwnProperty(workstationId)) {
              vgsBroadcastCommand(true, workstationId, "AccessPoint", {
                Command: "ChangeConfig",
                ChangeConfig: {
                  AccessPointIDs: apts[workstationId],
                  EntryControl: dlg.find("[name='EntryControl']").val(),
                  ReentryControl: dlg.find("[name='ReentryControl']").val(),
                  ExitControl: dlg.find("[name='ExitControl']").val()
                }
              });
            }
          }
          dlg.dialog("close");
        },
        <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
      }
    });
  }  
}

function onClick_DropArm() {
  if ($(this).isEnabled()) {
    var apts = getSelectedAccessPoints();
    for (var workstationId in apts) {
      if (apts.hasOwnProperty(workstationId)) {
        vgsBroadcastCommand(true, workstationId, "AccessPoint", {
          Command: "DropArm",
          DropArm: {
            AccessPointIDs: apts[workstationId]
          }
        });
      }
    }
  }  
}

function onClick_SkipRotation() {
  if ($(this).isEnabled()) {
    var apts = getSelectedAccessPoints();
    for (var workstationId in apts) {
      if (apts.hasOwnProperty(workstationId)) {
        vgsBroadcastCommand(true, workstationId, "AccessPoint", {
          Command: "SkipRotation",
          SkipRotation: {
            AccessPointIDs: apts[workstationId]
          }
        });
      }
    }
  }  
}

function onClick_Restart() {
  if ($(this).isEnabled()) {
    confirmDialog(<v:itl key="@Common.ConfirmSelWorkstationRestart" encode="JS"/>, function() {
      var apts = getSelectedAccessPoints();
      for (var workstationId in apts) {
        if (apts.hasOwnProperty(workstationId)) {
          vgsBroadcastCommand(true, workstationId, "Workstation", {Command:"RestartApplication"});
        }
      }
    });
  }  
}
      
</script>
