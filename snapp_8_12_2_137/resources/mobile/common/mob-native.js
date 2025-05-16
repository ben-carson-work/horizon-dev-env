//# sourceURL=mob-native.js

var EVENT_InputRead     = "VGS_InputRead";
var EVENT_AppClose      = "VGS_OnClose";
var EVENT_AppBackground = "VGS_OnBackground";
var EVENT_AppForeground = "VGS_OnForeground";

$(document).ready(function() {
  window.isNativeAvailable = isNativeAvailable; 
  window.snpNative = snpNative;
  window.snpNativeCallback = snpNativeCallback;
  
  var android = (eval("typeof JSInterface") != "undefined");
  var iOS = (eval("typeof webkit") != "undefined");
  var promises = {};
  

  
  if (isNativeAvailable()) {
    window.onerror = function myErrorHandler(errorMsg, url, lineNumber) {
      alert("Unhandled exception at " + url + ":" + lineNumber + ":\n\n" + errorMsg);
      return false;
    }
  }
  
  function isNativeAvailable() {
    return android || iOS;
  }

  function snpNative(methodName, params) {
    return new Promise(function(resolve, reject) {
      var promiseId = newStrUUID();
      promises[promiseId] = {
        "resolve": resolve, 
        "reject": reject
      };
      
      params = params || {};
      params["PromiseId"] = promiseId;
      
      var escapedParams = JSON.stringify(params).replace(/\\([\s\S])|(")/g,"\\$1$2");

      if (android) 
        eval("JSInterface." + methodName + "(\"" + escapedParams + "\");");
      else if (iOS) 
        eval("webkit.messageHandlers." + methodName + ".postMessage(\"" + escapedParams + "\")");
      else {
        delete promises[promiseId];
        reject("Native interface not available");
      }
    });
  }

  function snpNativeCallback(promiseId, data, error) {
    if (error) 
      promises[promiseId].reject(error);
    else        
      promises[promiseId].resolve(JSON.parse(data));
    
    delete promises[promiseId];
  }
});
