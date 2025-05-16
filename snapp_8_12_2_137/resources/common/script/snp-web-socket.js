
// Currently used by mobile app. To be included in SnpWebSocket
function calcWebSocketURL() {
  var href = window.location.href;
  if (href.indexOf("http:") == 0)
    href = "ws:" + href.substr(5);
  else if (href.indexOf("https:") == 0)
    href = "wss:" + href.substr(6);
  else
    console.error("Unable to calculate WebSocket URL from \"" + href + "\"");
  
  href = href.substr(0, href.lastIndexOf("/"));
  return href + "/broadcast";
}

/* params = {
 *   onHandShake: function(),
 *   onMessage: {
 *     "RequestCode": function(event, header, message),
 *     "RequestCode": function(event, header, message),
 *     ...
 *     "RequestCode": function(event, header, message)
 *   }
 * };
 */
function SnpWebSocket(params) {
  // Public properties
  // Private properties
  params = params || {};
  var ws = null;
  var connected = false;
  var handShakeReq = {};
  
  
  //--- PUBLIC METHODS ---//
  
  this.sendHandShake = _sendHandShake;
  this.send          = _send;
  this.isConnected   = _isConnected;
  _init();
  
  
  //--- PRIVATE METHODS ---//

  function _init() {
    if (!connected) {
      var urlo = calcWebSocketURL();
      console.log("trying reconnect to: " + urlo);
      ws = new WebSocket(urlo); 
      ws.onopen = function() {
        console.log("websocket OPEN");
        connected = true;
        _sendHandShake(handShakeReq);
      };
      ws.onclose = function(event) {
        console.log("websocket CLOSE");
        connected = false;
        setTimeout(function() {_init()}, 1000);
      };
      ws.onerror = function(event) {
        console.log("websocket ERROR");
      };
      ws.onmessage = function(event) {
        console.log("wesocket message: " + event.data);
        var message = JSON.parse(event.data);
        if ((message.Header) && (params.onMessage)) {
          var handler = params.onMessage[message.Header.RequestCode];
          if (handler)
            handler(event, message.Header, message.Message);
        }
      };
    }
  }
  
  function _send(cmd, reqDO) {
    var req = {
      "Header": {
        "RequestCode": cmd,
        "WorkstationId": (reqDO) ? (reqDO.ForceWorkstationId || loggedWorkstationId) : loggedWorkstationId
      },
      "Request": (reqDO || {})
    };

    console.log("Sending...");
    console.log(req);
    ws.send(JSON.stringify(req));
  }

  function _sendHandShake(handShake) {
    handShakeReq = handShake;
    _send("HandShake", handShake);
    if (params.onHandShake)
      params.onHandShake();
  }
  
  function _isConnected() {
    return connected;
  }
}