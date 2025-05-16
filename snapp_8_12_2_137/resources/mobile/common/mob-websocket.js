//# sourceURL=mob-websocket.js

var EVENT_WebSocketConnectionChange = "WebSocketConnectionChange";
var EVENT_WebSocketMessage = "WebSocketMessage";

var BcstStatus_AccessPoint = "APT-STATUS";
var BcstStatus_WksConnection = "WKS-CONN";

$(document).ready(function() {
  window.BLWebSocket = {
    // Methods
    "isConnected": isConnected,
    "sendCommand": sendCommand,
    "broadcastCommand": broadcastCommand
  };
  
  var webSocket = null;
  var connected = false;
  var debugging = false;
  
  connectLoop();
  
  function mylog(msg) {
    if (debugging)
      console.log("WebSocket: " + msg);
  }
  
  function connectLoop() {
    if (!connected) {
      mylog("Trying connect...");
      webSocket = new WebSocket(calcWebSocketURL()); 
      webSocket.onopen = function() {
        mylog("OPEN");
        setConnected(true);
      };
      webSocket.onclose = function(event) {
        mylog("CLOSE");
        setConnected(false);
        setTimeout(connectLoop, 1000);
      };
      webSocket.onerror = function(event) {
        mylog("ERROR");
      };
      webSocket.onmessage = function(event) {
        mylog("MESSAGE: " + event.data);
        var status = JSON.parse(event.data);
        if (status.Header)
          $(document).trigger(EVENT_WebSocketMessage, status);
      };
    }
  }
  
  function setConnected(value) {
    if (connected != value) {
      connected = value;
      $(document).trigger(EVENT_WebSocketConnectionChange);
    }
  }
  
  function isConnected() {
    return connected;
  }
  
  function sendCommand(requestCode, command, params) {
    return new Promise(function(resolve, reject) {
      var reqDO = params;
      if (command) {
        reqDO = {"Command": command};
        reqDO[command] = params;
      }
      
      var req = {
        "Header": {
          "RequestCode": requestCode,
          "WorkstationId": workstationId
        },
        "Request": reqDO
      }

      webSocket.send(JSON.stringify(req));
      resolve();
    });
  }

  function broadcastCommand(dstWorkstationId, broadcastName, broacastData) {
    broacastData = JSON.stringify({
      "Header": {
        "RequestCode": broadcastName
      }, 
      "Request": broacastData
    });

    snpAPI("Broadcast", "AppendCommand", {
      "SrcWorkstationId": workstationId,
      "DstWorkstationId": dstWorkstationId,
      "ValidityMin": 1,
      "BroadcastName": broadcastName,
      "BroadcastData": broacastData
    }).catch(function(error) {
      console.log(error);
    });
  }
  
});