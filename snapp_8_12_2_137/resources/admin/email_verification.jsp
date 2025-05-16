<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.library.VgsWebInit"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="pageBase" class="com.vgs.web.page.PageEmailVerification" scope="request"/>

<% String successMessageId = pageBase.getNullParameter("successmsg"); %>
<% boolean accountFound = JvString.isSameString(pageBase.getNullParameter("accountFound"), "true") && (successMessageId == null); %>
<% boolean b2bAgent = JvString.isSameString(pageBase.getNullParameter("b2bAgent"), "true"); %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <title>SnApp email verification</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <link rel="shortcut icon" href="<v:config key="resources_url"/>/admin/images/favicon.ico"/>
  <link type="text/css" href="<v:config key="site_url"/>/libraries/jquery-ui-1.14.1/jquery-ui.min.css" rel="stylesheet" />
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/jquery/jquery-3.6.0.min.js"></script>
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/jquery-ui-1.14.1/jquery-ui.min.js"></script>
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
      #email-verification-widget {
        width: 600px;
        height: 170px;
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
<v:page-form id="email-verification-form">
    <v:widget id="email-verification-widget" caption="Horizon Email Verification">
    <% if (accountFound) { %>
    <div id="success-box">
      <v:widget-block>
        Congratulations, your email address has been validated.&nbsp;
        <% if (b2bAgent) { %>
          <a href="<v:config key="site_url"/>/b2b">Go to Login page.</a>
        <% } else { %>
          <a href="<v:config key="site_url"/>/admin">Go to Login page.</a>
        <% } %>
      </v:widget-block>
    </div>
    <% } else { %>
    <div id="error-box">
      <v:widget-block>
        Unable to validate verification code.
      </v:widget-block>
    </div>
    <% } %>
  </v:widget>
</v:page-form>

</body>


</html>


