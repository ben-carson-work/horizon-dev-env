//# sourceURL=mob-api-js.jsp


class CodeError extends Error {
  constructor(code, message) {
    super(message);
    this.code = code;
  }
}

$(document).ready(function() {
  window.snpAPI = doSnpAPI;
  

  function getVgsServiceError(ans) {
    ans = (ans) ? ans : {};
    
    if ((ans.status != null) && (ans.status != 200)) 
      return new CodeError(-1, ans.status + ": " + ans.statusText);

    if (ans.Header == null)
      return new CodeError(-1, "Unreadable response");
    
    if (ans.Header.StatusCode != 200)
      return new CodeError(ans.Header.StatusCode, ans.Header.ErrorMessage || "unknown error");

    return null;
  }

  function doSnpAPI(cmd, command, reqDO) {
    return new Promise(function (resolve, reject) {
      if (command) {
        var tmp = {};
        tmp["Command"] = command;
        tmp[command] = reqDO;
        reqDO = tmp;
      }
      
      reqDO = {
        "Header": {
          "WorkstationId": workstationId,
          /*
          "Session": vgsSession,
          "Token": vgsSessionToken
          */
        },
        "Request": reqDO
      };
      
      $.ajax({
        url: BASE_URL + "/service?cmd=" + cmd + "&format=json&ts=" + (new Date()).getTime(),
        type: "POST",
        data: "message=" + encodeURIComponent(JSON.stringify(reqDO)),
        dataType: "json"
      }).always(function(ans) {
        var error = getVgsServiceError(ans);
        if (error)
          reject(error);
        else {
          if (command) {
            if ((ans) && (ans.Answer))  
              ans = ans.Answer[command];
            ans = (ans) ? ans : {};
          }
          resolve(ans);
        }
      });
    });
  }

});
