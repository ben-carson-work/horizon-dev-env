$(document).ready(function() {
  $("#txt-username").keydown(loginKeypress);
  $("#txt-password").keydown(loginKeypress);
  $("#btn-login").click(doLogin);
  
  var username = getLocalStorage("username");
  $("#txt-username").val(username);
  $("#txt-password").val("");
  
  if ((username) && (username.length > 0))
    $("#txt-password").focus();
  else
    $("#txt-username").focus();

  function doLogin(event, mediaCode) {
    $("#btn-login").addClass("hidden");
    $("#login-error").addClass("hidden");
    $("#txt-username").attr("disabled", "disabled");
    $("#txt-password").attr("disabled", "disabled");
    
    setLocalStorage("username", $("#txt-username").val(), 30);
    
    var reqDO = {
      WorkstationId: workstationId,
      ReturnDetails: true,
      ReturnRights: true
    };
    
    if (mediaCode)
      reqDO.MediaCode = mediaCode;
    else {
      reqDO.UserName = $("#txt-username").val();
      reqDO.Password = $("#txt-password").val();
    }
    
    $("#txt-password").val("");

    UIMob.showWaitGlass();
    snpAPI("Login", "Login", reqDO)
      .finally(function() {
        UIMob.hideWaitGlass();
      })
      .then(function(ansDO) {
        BLMob.afterLogin(ansDO.Workstation, ansDO.User, ansDO.Rights);
      })
      .catch(function(error) {
        $("#btn-login").removeClass("hidden");
        $("#txt-username").removeAttr("disabled");
        $("#txt-password").removeAttr("disabled");
        $("#login-error").removeClass("hidden");
        $("#login-error").text(error.message);
        if (!(mediaCode))
          $("#txt-password").focus();
      });
  }

  function loginKeypress() {
    $("#login-error").addClass("hidden");
    if (event.keyCode == KEY_ENTER) 
      doLogin();
  }

  $(document).von("#login-box", EVENT_InputRead, function(event, data) {
    data = data || {};
    doLogin(null, data.MediaCode);
  });
});
