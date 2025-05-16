<%@page import="com.vgs.broadcast.dataobject.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="java.net.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageDocketDisplay" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% BOSessionBean boSession = (pageBase == null) ? null : (BOSessionBean)pageBase.getSession(); %>

<script>

$(document).ready(function() {
  var webSocketURL = <%=JvString.jsString(SnappUtils.calcWebSocketURL(pageBase.getBackofficeURL()))%>;
  var connected = false;
  var webSocket = null;

  var docketStatus_Waiting = <%=LkSNDocketStatus.Waiting.getCode()%>;   
  var docketStatus_InPrep = <%=LkSNDocketStatus.InPreparation.getCode()%>;   
  var docketStatus_Ready = <%=LkSNDocketStatus.Ready.getCode()%>;   
  var docketStatus_Delivered = <%=LkSNDocketStatus.Delivered.getCode()%>;   
  
  
  
  

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
        //console.log("wesocket message: " + event.data);
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

  
  
  
  
  <%
  String[] transactionIDs = pageBase.getBLDef().getDisplayTransactionIDs(pageBase.getId());
  for (String transactionId : transactionIDs) {
    DODocket docket = pageBase.getBLDef().loadDocket(transactionId);
    %>addDocket(<%=docket.getJSONString()%>, "#docket-list"); <%
  }
  %>

  refreshElapsedTime();

  
  function addDocket(docket, container) {
console.log(docket);
    var title = docket.SaleTableName || "";
    if (docket.Owner) {
      if (title.length > 0)
        title += " - ";
      title += docket.Owner;
    }
  
    var $docket = $("#docket-templates .docket-container").clone().appendTo(container);
    $docket.attr("data-transactionid", docket.TransactionId);
    $docket.attr("data-ordertime", docket.SerialDateTime);
    $docket.attr("data-status", docket.DocketStatus);
    $docket.find(".docket-title").text(title);
    $docket.find(".docket-serial").text(docket.OpentabSerial);
    $docket.find(".docket-waiter").text(docket.WaiterAccountName || "-");
    $docket.find(".docket-order-time").text("@ " + formatTime(xmlToDate(docket.SerialDateTime), <%=rights.ShortTimeFormat.getInt()%>));
    
    $docket.find(".start-btn").setClass("hidden", docket.DocketStatus > docketStatus_Waiting).click(docketStart);
    $docket.find(".ready-btn").setClass("hidden", docket.DocketStatus != docketStatus_InPrep).click(docketInPrep);
    $docket.find(".delivered-btn").setClass("hidden", docket.DocketStatus != docketStatus_Ready).click(docketDelivered);
    $docket.find(".undo-btn").setClass("hidden", docket.DocketStatus == docketStatus_Waiting).click(docketUndo);
    
    if (docket.DocketItemList) {
      var $body = $docket.find(".docket-body");
      for (var i=0; i<docket.DocketItemList.length; i++) {
        var item = docket.DocketItemList[i];
        var $item = $("#docket-templates .docket-item").clone().appendTo($body);
        $item.find(".docket-item-title").text(item.Quantity + " X " + item.ProductName);
        
        var bom = [];
        if (item.SelectedMaterialList)
          for (var k=0; k<item.SelectedMaterialList.length; k++)
            bom.push(item.SelectedMaterialList[k].MaterialProductName);
        $item.find(".docket-item-bom").text(bom.join(", "));
      }
    }
  }
  
  function refreshElapsedTime() {
    $("#docket-list .docket-container").each(function(index, item) {
      var $docket = $(item);
      var orderDT = xmlToDate($docket.attr("data-ordertime"));
      var elapsedSecs = Math.trunc((((new Date()).getTime()) - orderDT.getTime()) / 1000);
      var elapsedHourPart = Math.trunc(elapsedSecs / (60 * 60));
      var elapsedMinPart = Math.trunc((elapsedSecs - elapsedHourPart*60*60) / 60);
      var elapsedSecPart = elapsedSecs - elapsedHourPart*60*60 - elapsedMinPart*60;
      var elapsedTime = leadZero(elapsedHourPart, 2) + ":" + leadZero(elapsedMinPart, 2) + ":" + leadZero(elapsedSecPart, 2) 
      $docket.find(".docket-elapsed-time").text("+ " + elapsedTime);
    });
    setTimeout(refreshElapsedTime, 1000);
  }
  
  function changeDocketStatus(transactionId, docketStatus, callback) {
    vgsSession = newStrUUID();  
  
    var reqDO = {
      ForceWorkstationId: <%=JvString.jsString(pageBase.getParameter("WorkstationId"))%>,
      Command: "ChangeDocketStatus",
      ChangeDocketStatus: {
        TransactionId: transactionId,
        DocketStatus: docketStatus
      }
    };
    
    vgsService("DocketDevice", reqDO, false, callback);
  }
  
  function docketStart() {
    changeDocketStatus($(this).closest(".docket-container").attr("data-transactionid"), docketStatus_InPrep);
  }
  
  function docketInPrep() {
    changeDocketStatus($(this).closest(".docket-container").attr("data-transactionid"), docketStatus_Ready);
  }
  
  function docketDelivered() {
    changeDocketStatus($(this).closest(".docket-container").attr("data-transactionid"), docketStatus_Delivered);
  }
  
  function docketUndo() {
    var $this = $(this);
    var transactionId = $this.closest(".docket-container").attr("data-transactionid");
    var status = parseInt($this.closest(".docket-container").attr("data-status"));
    var statusNew = null;
    if (status == docketStatus_InPrep)
      statusNew = docketStatus_Waiting;
    else if (status == docketStatus_Ready)
      statusNew = docketStatus_InPrep;
    else if (status == docketStatus_Delivered)
      statusNew = docketStatus_Ready;

    if (statusNew != null)
      changeDocketStatus(transactionId, statusNew);
  }
});

</script>