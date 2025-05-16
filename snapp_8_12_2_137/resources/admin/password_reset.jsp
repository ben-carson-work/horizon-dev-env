<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="pageBase" class="com.vgs.web.page.PagePasswordReset" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%BOSessionBean boSession = (pageBase == null) ? null : (BOSessionBean)pageBase.getSession();%>

<% String successMessageId = pageBase.getNullParameter("successmsg"); %>
<% boolean accountFound = JvString.isSameString(pageBase.getNullParameter("accountFound"), "true") && (successMessageId == null); %>
<%String passwordRuleInfo = rights.PwdRulesInfo.getHtmlString(); %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <title>SnApp Password Reset</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <link rel="shortcut icon" href="<v:config key="resources_url"/>/admin/images/favicon.ico"/>
  <link type="text/css" href="<v:config key="site_url"/>/libraries/jquery-ui-1.14.1/jquery-ui.min.css" rel="stylesheet" />
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/jquery/jquery-3.6.0.min.js"></script>
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/jquery-ui-1.14.1/jquery-ui.min.js"></script>
    
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/bootstrap_3.4.1/js/bootstrap.min.js"></script>
  <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/bootstrap_3.4.1/css/bootstrap.min.css">
  <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/bootstrap_3.4.1/css/bootstrap-theme.min.css">
  <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/font-awesome-6.4.2/css/fontawesome.min.css"> 
  <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/font-awesome-6.4.2/css/solid.min.css"> 
  <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/font-awesome-6.4.2/css/brands.min.css"> 

  <link type="text/css" href="<v:config key="site_url"/>/admin?page=admin-css" rel="stylesheet" media="all" />
  <script type="text/javascript" src="<v:config key="site_url"/>/admin?page=admin-js"></script>
  
  <style type="text/css">
    .form-field {
      margin:4px auto;
    }
    .form-field-caption {
      width: 200px;
    }
    .form-field-value {
      margin-left: 203px;
    }
    #password-reset-widget {
      width: 600px;
      margin: 100px auto;
    }
    .margin-10 {
      margin: 10px;
    }
    .float-right {
      float:right;
    }
  </style>

</head>

<body>
<v:page-form id="password-reset-form">
    <v:widget id="password-reset-widget" caption="Horizon Password Reset">
    <% if (accountFound) { %>
        <v:widget-block>
          <% if (!passwordRuleInfo.isEmpty()) { %>
            <v:alert-box type="info"><%=passwordRuleInfo%></v:alert-box>
          <% } %>
          <v:form-field caption="@Common.PasswordNew">
            <input type="password" id="password" class="form-control" value="">
          </v:form-field>
          <v:form-field caption="@Common.PasswordConfPassword">
            <input type="password" id="passwordConfirm" class="form-control" value="">
          </v:form-field>
        </v:widget-block>
        <v:widget-block style="text-align:right">
          <v:button id="confirm-button" caption="Confirm" href="javascript:doResetPassword()" clazz=""/>
        </v:widget-block>
    <% } else { %>
      <v:widget-block>
        Unable to validate verification code.&nbsp;
        <a class="no-ajax" href="<v:config key="site_url"/>/admin">Go to Login page.</a>
      </v:widget-block>
    <% } %>
  </v:widget>
</v:page-form>

<script>
vgsSession = <%=JvString.jsString(boSession.getSessionId())%>;
loggedWorkstationId = <%=JvString.jsString(BLBO_DBInfo.getWorkstationId_BKO())%>;

function doResetPassword() {
  pwd = $("#password").val();
  pwdConf = $("#passwordConfirm").val();
  
  if (pwd) {
    if (pwd === pwdConf) {
      var reqDO = {
        Command: "ResetPassword",
        ResetPassword: {
          VerifyCode: <%=JvString.jsString(pageBase.getNullParameter("VerifyCode"))%>,
          Password: pwd
        }
      };

      vgsService("Login", reqDO, false, function(ansDO) {
        showMessage(<v:itl key="@Common.SaveSuccessMsg" encode="JS"/>, function () {
          if (ansDO.Answer.ResetPassword.B2BAgent)
            window.location = "<v:config key="site_url"/>/b2b";
          else
            window.location = "<v:config key="site_url"/>/admin";
            
        });
      });
    }
    else {
      $("#passwordConfirm").focus();
      showMessage(<v:itl key="@Common.PasswordMismatch" encode="JS"/>)
    }
  }
  else {
    $("#password").focus();
    showMessage(<v:itl key="@Common.PasswordSpecification" encode="JS"/>)
  }
  
}

</script>

</body>


</html>


