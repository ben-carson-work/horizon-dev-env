<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.snapp.dataobject.common.*"%>
<%@page import="com.vgs.snapp.web.gencache.*"%>
<%@page import="com.vgs.snapp.web.plugin.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="java.net.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="java.text.*"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="extLoginInfo" class="com.vgs.snapp.dataobject.DOExtLoginInfo" scope="request"/>
<jsp:useBean id="customFields" class="com.vgs.snapp.dataobject.DOCustomFieldsBean" scope="request"/>
<%
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); 

String workstationId = pageBase.getParameter("WorkstationId");
if ((workstationId == null) && pageBase.isVgsContext("BKO"))
  workstationId = BLBO_DBInfo.getWorkstationId_BKO();

String loginWorkstationId = workstationId;
if ((workstationId == null) || pageBase.isVgsContext("B2B"))
  loginWorkstationId = pageBase.getVgsContext();

DORightRoot licRights = null;
String bkgColor = null;
String bkgRepositoryId = null;
boolean captchaRight = false;
LookupItem bkgStyle = LkSNBackgroundStyle.Center;
if (!BLBO_DBInfo.isDatabaseEmpty() && !BLBO_DBInfo.isDatabaseUpdateNeeded()) {
  if (workstationId != null)
    licRights = pageBase.getBL(BLBO_Right.class).getFinalRights(workstationId, null);
  else {
    licRights = pageBase.getBL(BLBO_Right.class).loadRights(LkSNEntityType.Licensee, BLBO_DBInfo.getMasterAccountId());
    RightUtils.setRightsDefaults(licRights);
  }
  bkgColor = licRights.LoginBkgColor.getString();
  bkgRepositoryId = licRights.LoginBkgRepositoryId.getString();
  if (!licRights.LoginBkgStyle.isNull())
    bkgStyle = licRights.LoginBkgStyle.getLkValue(); 
  
  pageBase.getSession().setUserLang(licRights.LangISO.isNull("en"));
  captchaRight = licRights.Captcha.getBoolean();
}

String ver = URLEncoder.encode(BLBO_DBInfo.getWebInit().getWarVersion(), "UTF-8");
String captchaId = null;
if (captchaRight)
  captchaId = pageBase.getBL(BLBO_Captcha.class).generateCaptchaCode();

%>
<!DOCTYPE html>
<html>

<head>
  <title><%= pageBase.getPageTitle() %> &lsaquo; <v:config key="site_title"/></title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <link rel="shortcut icon" href="<v:config key="resources_url"/>/admin/images/favicon.ico"/>
  <link rel='stylesheet' id='open-sans-css'  href='<v:config key="site_url"/>/fonts/fonts.css' type='text/css' media='all' />
  
  <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/bootstrap_3.4.1/css/bootstrap.min.css">
  <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/bootstrap_3.4.1/css/bootstrap-theme.min.css">
  
  <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/font-awesome-6.4.2/css/fontawesome.min.css"> 
  <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/font-awesome-6.4.2/css/solid.min.css"> 
  <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/font-awesome-6.4.2/css/brands.min.css"> 

  <link type="text/css" href="<%=pageBase.getContextURL()%>?page=admin-css&newstyle=true&ver=<%=ver%>" rel="stylesheet" media="all" />

  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/jquery/jquery-3.6.0.min.js"></script>
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/jquery-ui-1.14.1/jquery-ui.min.js"></script>
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/bootstrap_3.4.1/js/bootstrap.min.js"></script>
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/commonmark-0.29/commonmark.min.js"></script>
  <script type="text/javascript" src="<%=pageBase.getContextURL()%>?page=admin-js&ver=<%=ver%>"></script>
  <script type="text/javascript" src="<%=pageBase.getContextURL()%>?page=itl&ver=<%=ver%>&LangISO=<%=pageBase.getLangISO()%>"></script> 
  
  <style>
    body {
      min-width: 400px;
      <%=pageBase.formatBackgroundCSS(bkgColor, bkgRepositoryId, bkgStyle)%>
    }
    
    <%float heightCustomFields = 0.5f;
      if(customFields != null)
        heightCustomFields = customFields.customFields.getSize() * 50.5f;%>
    #login-box {
      position: relative;
      overflow: hidden;
      margin: auto;
      <% if ( heightCustomFields/2 < 190 ) { %>
      margin-top: <%=200 - heightCustomFields / 2%>px;
      <% } else { %>
      margin-top: 10px;
      <% } %>
      margin-bottom: 50px;
      width: 360px;
      border-radius: 40px;
      box-shadow: 0 0 20px rgba(0,0,0,0.075);
      <% if (bkgRepositoryId != null) { %>
        box-shadow: 0 0 20px rgba(0,0,0,0.25);
      <% } %>
      background-color: white;
      padding-bottom: 18px;
    }
    
    .img-captcha-field {
      text-align: center;
      margin-top: 30px;
    }
  
    #pic-licensee {
      margin: auto;
      margin-top: 30px;
      width: 150px;
      height: 150px;
      background-image: url(<%=pageBase.getBL(BLBO_Account.class).getLicenseeLogoURL()%>);
      background-size: cover;
    }
    
    #pic-test {
      display: none;
      position: absolute;
      top: 0;
      left: 0; 
      right: 0;
      background-color: var(--base-red-color);
      color: white;
      padding: 8px; 
      font-size: 18px;
      text-align: center;
      font-weight: bold;
    }
    .test-system #pic-test {
      display: block;
    }

    #module-name {
      font-size: 35px;
      text-align: center;
      margin-top: 20px;
      margin-bottom: 20px;
      color: #909090;
    }
    
    .login-field {
      position: relative;
      margin-top: 5px;
      margin-left: 35px;
      margin-right: 35px;
      padding: 8px;
      border-bottom: 1px #dadada solid;
    }
    
    .login-field input {
      font-size: 20px;
      margin: 0;
      padding: 0;
      border: 0;
      width: 100%;
      background: none;
    }
    
    .login-field input::-webkit-input-placeholder {color:#b9b9b9}
    .login-field input::-moz-placeholder {color:#b9b9b9}
    .login-field input:-ms-input-placeholder {color:#b9b9b9}
    .login-field input:-moz-placeholder {color:#b9b9b9}
    input:-webkit-autofill {
      -webkit-box-shadow: 0 0 0px 1000px white inset;
    } 
    .login-field input:focus {
      outline-width: 0;
    }
    
    #login-box .v-button {
      width: 120px;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }
    
    .capslock-icon {
      position: absolute;
      font-size: 30px;
      top: 4px;
      right: 0;
      color: var(--base-orange-color);
      visibility: hidden;
    }
    
    .login-field.capslock .capslock-icon {
      visibility: visible;
    }
    
    .login-button-container {
      text-align: center;
      margin-top: 23px;
      min-height: 40px;
    }

    .login-selectable-button-container {
      text-align: center;
    }
    
    .ext-login-button {
      min-width: 100px;
    }
    
    #login-spinner {
      display: none;
    }
    
    #login-box.loading #login-spinner {
      display: block;
      color: rgba(0,0,0,0.25);
    }
    
    #login-box.loading #login-buttons,
    #login-box.error #login-buttons {
      display: none;
    }
    
    #login-box.loading #forgot-password,
    #login-box.error #forgot-password {
      display: none;
    }
    
    #forgot-password {
      margin-top: 5px;
    }
    
    #forgot-password a {
      color: rgba(0,0,0,0.5);
    }
    
    #forgot-password a:hover {
      color: var(--base-blue-color);
    }
    
    #error-msg {
      display: none;
      font-size: 15px;
      font-weight: bold;
      color: red;
      margin-left: 30px;
      margin-right: 30px;
    }

    #login-box.error #error-msg {
      display: block;
    }
  
    #login-footer {
      position: fixed;
      left: 0px;
      right: 0px;
      bottom: 0px;
      border-top: 1px rgba(0,0,0,0.08) solid; 
      color: rgba(0,0,0,0.5);
      line-height: 36px;
      height: 36px;
      <% if ((bkgColor == null) && (bkgRepositoryId == null)) { %>
        background-color: rgba(0,0,0,0.04);
      <% } else { %>
        background-color: white;
      <% } %>
    }
    
    #login-footer-vgslogo {
      position: absolute;
      left: 0;
      top: 0;
      bottom: 0;
      width: 50px;
      background-image: url("<v:config key="resources_url"/>/admin/images/vgs-logo-login2.png");
      background-repeat: no-repeat;
      background-position: 6px -3px;
      opacity: 0.3;
      z-index: 100;
    }
    
    #login-footer-vgslogo:hover {
      opacity: 0.5;
    }
    
    #login-footer-center {
      position: absolute;
      left: 0;
      top: 0;
      right: 0;
      bottom: 0;
      text-align: center;
    }
    
    #login-footer-right {
      position: absolute;
      left: 0;
      top: 0;
      right: 10px;
      bottom: 0;
      text-align: right;
    }
    
    #install-message {
      text-align: center;
      font-size: initial;
      padding: 20px;
      padding-top: 0;
      margin-top: 0;
    }
    
    #password-change-error {
      font-weight: bold;
      color: var(--base-red-color);
      text-align: center;
      margin-top: 10px;
    }

    #progressbar-ext {
      margin-top: 6px;
      height: 4px;
      background-color: #CECECE;
    }
    
    #progressbar-int {
      float: left; 
      background-color: var(--base-green-color); 
      height: 4px;
    }
    
    #dbupdate-spinner {
      padding: 30px;
      font-size: 40px;
      text-align: center;
      color: rgba(0, 0, 0, 0.25); 
    }
     
    #password-change-dialog #newpwd-check {
      margin-top: 10px;
    }
    
    .ui-dialog-buttonpane {
      padding: 10px;
    }
    
    #login-selection-container {
      padding: 20px 35px 15px 35px;
    }
    
    #login-selection-container .v-button {
      display: block;
      width: auto;
      margin-bottom: 6px;
      text-align: left;
    }
   
    #login-selection-container .v-button .v-icon-alias {
      display: inline-block;
      width: 24px;
      line-height: 24px;
      font-size: 18px;
      margin-right: 10px;
    }
    
    #login-selection-container .v-button .button-caption {
      display: inline-block;
      font-size: 16px;
    }
    
    #login-box[view="snapp-login"] #login-selection-container {
      display:none;
    }
    
    #login-box[view="other-options"] #snapp-login {
      display:none;
    }
    
    #login-buttons {
      padding:0 40px 0 40px;
      display:flex;
      justify-content:space-evenly;
    }
  </style>
  
  <script>
//# sourceURL=login.jsp
    vgsSession = <%=JvString.jsString(pageBase.getSession().getSessionId())%>;

    var userName = null;
    var password = null;
  
    function getCookieName() {
      return "snapp-<%=pageBase.getVgsContext()%>-uid";
    }
  
    function initUID() {
      var extLoginName = <%=extLoginInfo.ExtLoginNameMasked.getJsString()%>;

      if (extLoginName) {
        $("#uid").val(extLoginName);
        $("#uid").prop("disabled", true);
      }
      else {
        $("#uid").val(getCookie(getCookieName())); 
        $("#uid").prop("disabled", false);
      }
    }

    $(document).ready(function(e) {
      initUID();
      $("#pwd").val("");
      if ($("#uid").val() == "")
        $("#uid").focus();
      else
        $("#pwd").focus();
      
      refreshButtonsVisibility();
      
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
  
    var capsinit = false;
    var capslock = false;
    function setCapsLock(value) {
      capsinit = true;
      capslock = value;
      $("#pwd").parent().setClass("capslock", capslock);
    }
    
    window.addEventListener('keydown', detectCapsLock);
    window.addEventListener('keyup', detectCapsLock);
    window.addEventListener('click', detectCapsLock);

    function detectCapsLock(e) {
      $("#pwd").parent().setClass("capslock", e.getModifierState('CapsLock'));
    }
    
    $(window).keypress(function(e) {
      var code = (e.keyCode ? e.keyCode : e.which);
      if (code == KEY_ENTER) {
        if ($("#uid").is(":focus") || $("#pwd").is(":focus") || $('#captcha').is(":focus") || $('.custom-field').is(":focus")) 
          doLogin();
        else if ($("#newpwd").is(":focus") || $("#newpwd-check").is(":focus"))
          doChangePassword();
      }
    });
    
    var errorId = null;
    function handleLoginError(msg) {
      var thisErrorId = new Date().getTime();
      errorId = thisErrorId;
      
      $("#login-box").effect("bounce", {direction:'left', times:5, distance:50}, 100);
      $("#login-box").removeClass("loading");
      $("#login-box").addClass("error");
      $("#error-msg").text(msg);
      setTimeout(function() {
        if (thisErrorId == errorId) {
          $("#login-box").removeClass("error");
        }
      }, 2000);
    }
  
    function doLogin() {
      $("#login-box").addClass("loading");
      $("#login-box").removeClass("error");
      userName = <%=extLoginInfo.ExtLoginName.getJsString()%>;
      if (userName == null)
        userName = $("#uid").val();
      password = $("#pwd").val();
      captchaCode = $("#captcha").val();
      
      varLoginAdapter = [];
      
      $('input[class=custom-field]').each(function() {
        var item = {};
        item ['key'] = this.id;
        item ['value'] = $(this).val();
        
        varLoginAdapter.push(item);
      });
      
      var reqDO = {
        Command: "Login",
        ForceWorkstationId: <%=JvString.jsString(BLBO_DBInfo.getWorkstationId_BKO())%>,
        Login: {
          WorkstationId: <%=JvString.jsString(loginWorkstationId)%>,
          UserName: userName,
          Password: password,
          ReturnDetails: false,
          CaptchaId: <%=JvString.jsString(captchaId)%>,
          CaptchaCode: captchaCode,
          ExtUserName: <%=extLoginInfo.ExtLoginName.getJsString()%>,
          ExtPluginId: <%=extLoginInfo.PluginId.getJsString()%>,
          LoginCustomFields: varLoginAdapter
        }
      };
      $("#pwd").val("");
      $("#captcha").val("");
      vgsService("Login", reqDO, true, function(ansDO) {
        if ((ansDO) && (ansDO.Header)) {
          if (ansDO.Header.StatusCode == 200) {
            <% if (extLoginInfo.ExtLoginName.isNull()) { %>
            setCookie(getCookieName(), $("#uid").val(), 30);
            <% } %>
            
            setCookie("browserTabId", browserTabId);
            
            <% if (extLoginInfo.RequestedURL.isNull()) { %>
            window.location.reload();
            if (window.opener)
              window.opener.postMessage({ eventName: 'loginSuccessFull'}, window.location.origin);
            <% } else {%>
            window.location.replace(<%=extLoginInfo.RequestedURL.getJsString()%>);
            <% } %>
            
          }
          else if (ansDO.Header.StatusCode == <%=LkSNErrorCode.LoginExpired.getCode()%>) 
            showChangePasswordDialog();
          else if (ansDO.Header.StatusCode == <%=LkSNErrorCode.CaptchaExpired.getCode()%>) {
            handleLoginError(ansDO.Header.ErrorMessage);
            window.location.reload(); 
          } 
          else
            handleLoginError(ansDO.Header.ErrorMessage);
        }
        else
          handleLoginError(<v:itl key="@Common.ConnectionError" encode="JS"/>);
      });
    }
    
    function showChangePasswordDialog() {
      $("#login-box").removeClass("loading");
      var dlg = $("#password-change-dialog");
      
      dlg.find("#newpwd").val("");
      dlg.find("#newpwd-check").val("");
      dlg.find("#password-change-error").addClass("v-hidden");
      
      dlg.dialog({
        modal: true,
        title: <v:itl key="@Common.PasswordExpired" encode="JS"/>,
        width: 300,
        buttons: {
          <v:itl key="@Common.Ok" encode="JS"/>: doChangePassword,
          <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
        }
      });
    }
    
    function showPasswordChangeError(msg) {
      $("#password-change-error").text(msg).removeClass("v-hidden");
    }
    
    function doChangePassword() {
      var newPassword = $("#newpwd").val();
      var newPasswordCheck = $("#newpwd-check").val();
      if (newPassword != newPasswordCheck)
        showPasswordChangeError(<v:itl key="@Common.PasswordMismatch" encode="JS"/>);
      else {
        var reqDO = {
          Command: "Login",
          ForceWorkstationId: <%=JvString.jsString(BLBO_DBInfo.getWorkstationId_BKO())%>,
          Login: {
            WorkstationId: <%=JvString.jsString(loginWorkstationId)%>,
            UserName: userName,
            Password: password,
            NewPassword: newPassword,
            ReturnDetails: false
          }
        };
        vgsService("Login", reqDO, true, function(ansDO) {
          if ((ansDO) && (ansDO.Header)) {
            if (ansDO.Header.StatusCode == 200) {
              setCookie(getCookieName(), userName, 30);
              window.location.reload();
            }
            else
              showPasswordChangeError(ansDO.Header.ErrorMessage);
          }
          else
            showPasswordChangeError(<v:itl key="@Common.ConnectionError" encode="JS"/>);
        });
      }
    }
    
    var databaseUpdateId = null; 
    function startDatabaseUpdate() {
      vgsService("InitDatabase", {Command:"StartDatabaseUpdate"}, false, function(ansDO) {
        databaseUpdateId = ansDO.Answer.StartDatabaseUpdate.DatabaseUpdateId;
        databaseUpdateStatus();
      });
    }
    
    function databaseUpdateStatus() {
      var reqDO = {
        Command: "DatabaseUpdateStatus",
        DatabaseUpdateStatus: {
          DatabaseUpdateId: databaseUpdateId
        }
      };
      
      vgsService("InitDatabase", reqDO, false, function(ansDO) {
        ansDO = ansDO.Answer.DatabaseUpdateStatus;
        renderDatabaseUpdateStatus(ansDO);

        if (ansDO.UpdateStatus == <%=LkSNDatabaseUpdateStatus.Working.getCode()%>)
          setTimeout(databaseUpdateStatus, 100);
        else if (ansDO.UpdateStatus == <%=LkSNDatabaseUpdateStatus.Failed.getCode()%>)
          showMessage("There was an error executing patch " + ansDO.ProgressPatch + " #" + ansDO.ProgressScript);
        else if (ansDO.UpdateStatus == <%=LkSNDatabaseUpdateStatus.Succeded.getCode()%>) {
          $("#install-message").html("Database successfully updated!<br/>&nbsp;<br/>Please wait a few moments<br/>for application to start...<div id='dbupdate-spinner'><i class='fa fa-circle-notch fa-spin fa-fw'></i></div>");
          setTimeout(function() {
            window.location.reload();
          }, 10000);
        }
      });      
    }
    
    function renderDatabaseUpdateStatus(ansDO) {
      var cont = $("#install-message"); 
      cont.empty();
      
      $("<div>Executing patch " + ansDO.ProgressPatch + " #" + ansDO.ProgressScript + "</div>").appendTo(cont);

      var perc = ansDO.ProgressPos / Math.max(1, ansDO.ProgressTot) * 100;
      var divExt = $("<div id='progressbar-ext'/>").appendTo(cont);
      var divInt = $("<div id='progressbar-int'/>").appendTo(divExt);
      divInt.css("width", perc+"%");
    }
    
    function doForgotPassword() {
      asyncDialogEasy("../common/forgot_password_dialog_anonymous");
    }
    
    function refreshButtonsVisibility() {
      var snappLoginEnabled = <%=(licRights != null) && licRights.SnAppLoginEnabled.getBoolean()%>;
      var hasSelectableOptions = $("#login-selection-container .v-button:not(#back-to-snapp-button)").length > 0;
      
      if (hasSelectableOptions && !snappLoginEnabled)
        setView("other-options");
      
      if (hasSelectableOptions)
        $("#other-button").removeClass("hidden");        
    }
    
    function setView(view) {
      $("#login-box").attr("view", view);
      if (view == "snapp-login") {
        $("#pwd").val("");
        if ($("#uid").val() == "")
          $("#uid").focus();
        else
          $("#pwd").focus();
      }
    }

  </script>
</head>

<%
String sBodyClass = BLBO_DBInfo.isTestMode() ? "test-system" : "";
%>
<body class="<%=sBodyClass%>">

<div id="login-box" view="snapp-login">
  <div id="pic-test"><%=JvString.escapeHtml(BLBO_DBInfo.getTestModeLabel())%></div>
  <div id="pic-licensee"></div>
  <div id="module-name">
    <%
    String itl = "@Common.VgsContext" + JvString.getEmpty(pageBase.getVgsContext()).toUpperCase();
    %>
    <v:itl key="<%=itl%>"/>
  </div>

  <% if (BLBO_DBInfo.isDatabaseEmpty()) { %>
    <div id="install-message" style="padding-top:40px"> Database is not initialized. <br/> Please go to <a class="no-ajax" href='<v:config key="site_url"/>/admin?page=install'>install page.</a></div>
  <% } else if (BLBO_DBInfo.isDatabaseUpdateNeeded()) { %>
    <% if (pageBase.isVgsContext("BKO")) { %>
      <div id="install-message">
        <% String databaseUpdateId = BLBO_DatabaseUpdate.findWorkingDatabaseUpdateId(pageBase.getDB());%>
        <% if (databaseUpdateId == null) { %>
          <div><v:itl key="@Common.DBVersionUpdateNeeded" param1="<%=BLBO_DBInfo.getDatabaseVersion()%>" param2="<%=DODB.getVersion()%>"/></div> 
          &nbsp;<br/>
          <div style="color:var(--base-red-color)"><i>It is highly recommended to backup the database before proceeding.</i></div> 
          &nbsp;<br/> 
          <div><a href="javascript:startDatabaseUpdate()">Click here</a> to start database update process.</div>
        <% } else { %>
          <i class="fa fa-circle-notch fa-spin"></i>
          <script>
            databaseUpdateId = <%=JvString.jsString(databaseUpdateId)%>;
            databaseUpdateStatus();
          </script>
        <% } %>
      </div>
    <% } else { %>
      <div id="install-message" style="padding-top:40px">System down for quick maintenance</div>
    <% } %>
  <% } else { %>
    <div id="snapp-login">
      <% if (pageBase.isVgsContext("ACC")) { %>
        <div class="login-field"><input type="text" id="wks" placeholder="<v:itl key="@Common.WorkstationCode"/>"/></div>
      <% } %>
      <div class="login-field"><input type="text" id="uid" placeholder="<v:itl key="@Common.UserName"/>"/></div>
      <div class="login-field"><input type="password" id="pwd" placeholder="Password"/><i class="capslock-icon fa fa-arrow-alt-square-up"></i></div>
      <% for (DOCustomFieldsBean.DOCustomFieldBean customField : customFields.customFields) { %>
        <div class="login-field"><input class="custom-field" type="<%=customField.type%>" id="<%=customField.code%>" placeholder="<%=customField.placeholder%>"/><i class="capslock-icon fa fa-arrow-alt-square-up"></i></div>
      <% } %>
      <% if(captchaRight) { %>    
        <div class="img-captcha-field"><img src="<%=pageBase.getContextURL()%>?page=login&action=captcha-image&CaptchaId=<%=captchaId%>"></div>
        <div class="login-field"><input type="text" id="captcha" placeholder="Type the word"/></div>
      <% } %>
      <div class="login-button-container">
        <div id="login-buttons">
          <div id="other-button" class="v-button hidden" onclick="setView('other-options')"><v:itl key="@Login.OtherButton"/></div>
          <div id="login-button" class="v-button" onclick="doLogin()"><v:itl key="@Login.LoginButton"/></div>
        </div>
        <div id="login-spinner"><i class="fa fa-circle-notch fa-spin fa-3x fa-fw"></i></div>
        <div id="forgot-password">
          <a href="javascript:doForgotPassword()"><v:itl key="@Login.ForgotPwdMsg"/></a>
          <% if (!extLoginInfo.PluginId.isNull()) { %>
            <% if (!extLoginInfo.IsOnline.getBoolean()) { %>
              &mdash;&nbsp;<span style="font-weight:bold; color:var(--base-red-color)"><%=extLoginInfo.SSOServiceName.getHtmlString()%>&nbsp;OFFLINE</span>
            <% } else if (Objects.isNull(extLoginInfo.ExtLogoutURL.getNullString())) { %>
              &mdash;&nbsp;<%=extLoginInfo.SSOServiceName.getHtmlString()%>&nbsp;online
            <% } else { %>
              &mdash;&nbsp;<a href="<%=extLoginInfo.ExtLogoutURL.getHtmlString()%>"><%=extLoginInfo.SSOServiceName.getHtmlString()%>&nbsp;<v:itl key="@Common.Logout"/></a>
            <% } %>
          <% } %>
        </div>
        <div id="error-msg"></div>
      </div>
    </div>
    
    <div id="login-selection-container">
      <% for (DOExtLoginButtonInfo btnInfo : pageBase.getExtLoginWebButtons(workstationId)) { %>
        <div class="v-button" onclick="<%=btnInfo.OnClickJS.getString()%>"> 
          <v:icon-alias value="<%=btnInfo.IconClass.getString()%>"/><div class="button-caption"><%=btnInfo.Caption.getHtmlString()%></div>
        </div>
      <% } %>
      
      <% if (licRights.SnAppLoginEnabled.getBoolean()) { %>
        <div id="back-to-snapp-button" class="v-button" onclick="setView('snapp-login')">
          <img src="<v:image-link name="snapp-icon-round.png" size="18"/>" style="margin-left:3px"/>
          <div class="button-caption" style="vertical-align:middle; margin-left:9px">SnApp</div>
        </div>
      <% } %>
    </div>

  <% } %>
  
</div>

<div id="login-footer">
  <a id="login-footer-vgslogo" href="https://www.accesso.com/solutions/ticketing/ticketing-visitor-management" target="_blank"></a>
  <div id="login-footer-center">Horizon by VGS &mdash; &copy; 2011 - <%=JvDateTime.date().format("yyyy")%> accesso Technology Group, plc</div>
  <div id="login-footer-right">Version <v:config key="display-version"/></div>
</div>

<div id="password-change-dialog" class="v-hidden">
  <v:input-text type="password" field="newpwd" placeholder="@Common.PasswordNew"/>
  <v:input-text type="password" field="newpwd-check" placeholder="@Common.PasswordConfirmation"/>
  <div id="password-change-error" class="v-hidden"></div>
</div>
  
</body>

</html>