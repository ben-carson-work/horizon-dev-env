$(document).ready(function() {
  function _renewToken() {
    var reqDO = {
      DontKeepSessionAlive: true,
      Command: "RenewToken"
    };
     
   vgsService("SESSION", reqDO, true, function(ansDO) {
     try {
console.log("Token renew")        
       if (isUnauthorizedAnswer(ansDO) || ansDO.Answer.RenewToken.Renewed == false) {
         console.log("Token renewal failed. Forcing logout.")
         doLogout();
       }
     } 
     catch(error) {
       console.error(error);
     }
   });
  }   

  function _renewTokenIfNeeded() {
    let tokenExpirationName = "snapp-token-exp";
    if ((typeof vgsContext !== 'undefined') && (vgsContext !== "BKO")) 
      tokenExpirationName += "-" + vgsContext;
    
    let tokenExpiration = getCookie(tokenExpirationName);
    if (tokenExpiration) {
      let now = Date.now();
      let diff = tokenExpiration - now;
//console.log('diff:' + diff);
      if (diff <= 10000) {
        _renewToken();
      }
    }
  }
  
  setInterval(_renewTokenIfNeeded, 1000);
});
