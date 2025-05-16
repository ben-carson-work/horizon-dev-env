<%@page import="com.vgs.snapp.dataobject.common.DOExtLoginButtonInfo"%>
<%@page import="com.vgs.snapp.web.gencache.SrvBO_Cache_SystemPlugin"%>
<%@page import="com.vgs.snapp.web.plugin.PlgExtLoginWebSelectableBase"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");

String workstationId = pageBase.getId();

String profilePictureId = null;
if (!BLBO_DBInfo.isDatabaseEmpty() && !BLBO_DBInfo.isDatabaseUpdateNeeded()) 
  profilePictureId = pageBase.getBL(BLBO_Repository.class).findProfilePictureId(BLBO_DBInfo.getMasterAccountId());
%>
  <jsp:include page="../mobileCommon/mob-common-header.jsp"/>
  <jsp:include page="../mobileCommon/functions.jsp" />

  <style id="mob-page-login.jsp_style">
  
    body[data-page='login'] {
      background-color: var(--pagetitle-bg-color);
    }
    
    #login-title {
      margin-top: 6vw;
      margin-bottom: 3vw;
    }
    
    #login-logo {
      width: 35vw;
      height: 35vw;
      margin: auto;
      border-radius: 3vw;
      box-shadow: 0 0 1.5vh rgba(0,0,0,0.2);
      background-color: white;
      background-size: cover;
      <% if (profilePictureId == null) { %>
        background-image: url(<v:image-link name="snapp-icon-round.png" size="128"/>);
      <% } else { %>
        background-image: url(<v:config key="site_url"/>/repository?type=small&id=<%=profilePictureId%>);
      <% } %>
    }
    
    #login-box {
      padding: 1.5vw;
      font-size: 6vw;
    }
    
    #login-box .login-item {
      padding: 1.5vw;
    }
    
    #login-box input {
      width: 100%;
      margin: 0;
      border: none;
      border-radius: 1.5vw;
      padding: 2vw;
    }
    
    #login-box input[disabled='disabled'] {
      background-color: white;
      opacity: 0.5;
    }
    
    .login-button {
      background-color: var(--base-gray-color);
      padding: 2vw;
      font-size: 6.75vw;
      text-align: center;
      border-radius: 1.5vw;
      color: white;
      text-shadow: 0 0 1.5vw rgba(0,0,0,0.2);
      cursor: pointer;
    }
    
    #li-btn-login .login-button,
    #li-btn-pwdchange-ok .login-button {
      background-color: var(--highlight-color);
    }
    
    #li-spinner {
      height: 9vw;
      text-align: center;
    }
    
    #li-error {
      color: var(--base-red-color);
      text-align: center;
    }
    
    .login-item {
      display: none;
    }
    
    #login-box[data-mode='login'] #li-username {display: block;}
    #login-box[data-mode='login'] #li-password {display: block;}
    #login-box[data-mode='login'][data-spinner='false'] #li-btn-login {display: block;}
    #login-box[data-mode='login'][data-spinner='false'] .ext-login {display: block;}
    
    #login-box[data-mode='pwdchange'] #li-pwdchange-title {display: block;}
    #login-box[data-mode='pwdchange'] #li-pwdchange-password {display: block;}
    #login-box[data-mode='pwdchange'] #li-pwdchange-confirm {display: block;}
    #login-box[data-mode='pwdchange'] #li-btn-pwdchange-ok {display: block;}
    #login-box[data-mode='pwdchange'] #li-btn-pwdchange-cancel {display: block;}
    
    #login-box[data-spinner='true'] #li-spinner {display: block;}
    #login-box[data-spinner='false'] #li-error {display: block;}

  
  </style>
  
  
<script type="text/javascript" id="mob-page-login.jsp_script" >
//# sourceURL=mob-page-login.jsp
  function getCookieName() {
    return "vgs-mobile-login";
  }
  
  function doLogin(event, mediaCode) {
    $("#login-box").attr("data-spinner", "true");
    $("#txt-username").attr("disabled", "disabled");
    $("#txt-password").attr("disabled", "disabled");
    
    setCookie(getCookieName(), $("#txt-username").val(), 30);
  
    var reqDO = {
      Command: "Login",
      Login: {
        WorkstationId: <%=JvString.jsString(pageBase.getId())%>,
        ReturnDetails: true
      }
    };
    
    if (mediaCode)
      reqDO.Login.MediaCode = mediaCode;
    else {
      reqDO.Login.UserName = $("#txt-username").val();
      reqDO.Login.Password = $("#txt-password").val();
    }
    
    vgsService("Login", reqDO, true, function(ansDO) {
      $("#login-box").attr("data-spinner", "false");
      $("#txt-username").removeAttr("disabled");
      $("#txt-password").removeAttr("disabled");

      var statusCode = ((ansDO || {}).Header || {}).StatusCode;
      if (statusCode == <%=LkSNErrorCode.LoginExpired.getCode()%>) {
        $("#login-box").attr("data-mode", "pwdchange");
        $("#txt-pwdchange-password").focus();
      }
      else {
        var errorMsg = getVgsServiceError(ansDO);
        if (errorMsg != null) {
          $("#txt-password").val("");
          $("#li-error").text(errorMsg);
          if (!(mediaCode))
            $("#txt-password").focus();
        }
        else {
          if (ansDO.Answer.Login.Workstation.PluginList)
            activatePlugins(ansDO.Answer.Login.Workstation.PluginList);
          window.location.reload();
        }
      }
    });
  }
  
  function doChangePassword() {
    var $password = $("#txt-pwdchange-password");
    var $confirm = $("#txt-pwdchange-confirm");
    if ($password.val() != $confirm.val()) {
      $("#li-error").text(<v:itl key="@Common.PasswordMismatch" encode="JS"/>);
      $confirm.focus();
    }
    else {
      $("#login-box").attr("data-spinner", "true");
      $password.attr("disabled", "disabled");
      $confirm.attr("disabled", "disabled");
      
      var reqDO = {
        Command: "Login",
        Login: {
          WorkstationId: <%=JvString.jsString(workstationId)%>,
          UserName: $("#txt-username").val(),
          Password: $("#txt-password").val(),
          NewPassword: $password.val(),
          ReturnDetails: true
        }
      };
      
      vgsService("Login", reqDO, true, function(ansDO) {
        $("#login-box").attr("data-spinner", "false");
        $password.removeAttr("disabled");
        $confirm.removeAttr("disabled");

        var errorMsg = getVgsServiceError(ansDO);
        if (errorMsg != null) 
          handleLoginError(errorMsg);
        else {
          if (ansDO.Answer.Login.Workstation.PluginList)
            activatePlugins(ansDO.Answer.Login.Workstation.PluginList);
          window.location.reload();
        }
      });
    }
  }
  
  function handleLoginError(errorMsg) {
    $("#txt-password").val("");
    $("#li-error").text(errorMsg);
    $("#txt-pwdchange-confirm").focus();
  }
  
  function doBackToLoginMode() {
    window.location.reload();
    //$("#login-box").attr("data-mode", "login");
  }
  
  function loginKeypress() {
    $("#li-error").text("");
    if (event.keyCode == KEY_ENTER) 
      doLogin();
  }
  
  function pwdchangeKeypress() {
    $("#li-error").text("");
    if (event.keyCode == KEY_ENTER) 
      doChangePassword();
  }

  function doMediaRead(mediaCode) {
    doLogin(null, mediaCode);
  }

  $(document).ready(function() {
    sendCommand("StartRFID");

    $("#txt-username").keydown(loginKeypress);
    $("#txt-password").keydown(loginKeypress);
    $("#li-btn-login .login-button").click(doLogin);
    
    $("#txt-pwdchange-password").keydown(pwdchangeKeypress);
    $("#txt-pwdchange-confirm").keydown(pwdchangeKeypress);
    $("#li-btn-pwdchange-ok .login-button").click(doChangePassword);
    $("#li-btn-pwdchange-cancel .login-button").click(doBackToLoginMode);
    
    $("#txt-username").val(getCookie(getCookieName()));
    $("#txt-password").val("");
    $("#li-error").text("");
     
    // Get the query string from the URL
    const url = new URL(window.location.href);
    const PARAM_ERRORMESSAGE = "ErrorMessage";

    // Check if a ErrorMessage exists
    if (url.searchParams.has(PARAM_ERRORMESSAGE)) {
      handleLoginError(url.searchParams.get(PARAM_ERRORMESSAGE));
      url.searchParams.delete(PARAM_ERRORMESSAGE);
      window.history.pushState({}, "", url.toString());       
    }
  });
  
</script>
  
  <div id="login-title"><div id="login-logo"></div></div>
  <div id="login-box" data-mode="login" data-spinner="false">
    <% if (rights.SnAppLoginEnabled.getBoolean()) { %>
      <div class="login-item" id="li-username"><input type="text" id="txt-username" placeholder="<v:itl key="@Common.UserName"/>" autocomplete="off" autocorrect="off" autocapitalize="none"/></div>
      <div class="login-item" id="li-password"><input type="password" id="txt-password" placeholder="<v:itl key="@Common.Password"/>"/></div>
      <div class="login-item" id="li-pwdchange-title"><center><v:itl key="@Common.ChangePassword"/></center></div>
      <div class="login-item" id="li-pwdchange-password"><input type="password" id="txt-pwdchange-password" placeholder="<v:itl key="@Common.Password"/>"/></div>
      <div class="login-item" id="li-pwdchange-confirm"><input type="password" id="txt-pwdchange-confirm" placeholder="<v:itl key="@Common.PasswordConfirmation"/>"/></div>
      <div class="login-item" id="li-error"></div>
      <div class="login-item" id="li-spinner"><i class="fa fa-circle-notch fa-spin"></i></div>
      <div class="login-item" id="li-btn-login"><div class="login-button"><v:itl key="@Common.Login"/></div></div>
      <div class="login-item" id="li-btn-pwdchange-ok"><div class="login-button"><v:itl key="@Common.Confirm"/></div></div>
      <div class="login-item" id="li-btn-pwdchange-cancel"><div class="login-button"><v:itl key="@Common.Cancel"/></div></div>
    <% } %>

    <% for (DOExtLoginButtonInfo btnInfo : pageBase.getExtLoginWebButtons(workstationId)) { %>
      <div class="login-item ext-login" onclick="<%=btnInfo.OnClickJS.getString()%>"><div class="login-button"><%=btnInfo.Caption.getHtmlString()%></div></div>
    <% } %>
  </div>

