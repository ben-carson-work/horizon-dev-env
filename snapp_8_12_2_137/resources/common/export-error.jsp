<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageExportError" scope="request"/>

<% 
LookupItem entityType = LkSN.EntityType.getItemByCode(JvString.strToIntDef(pageBase.getParameter("EntityType"), 0));
String errorMessage = pageBase.getParameter("ErrorMessage");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <title>SnApp Payment Authorization</title>
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
      #error-widget {
        width: 400px;
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
<v:page-form id="error-form">
  <v:widget id="error-widget" caption="SnApp export error">
    <v:widget-block>
      Something happened exporting <b><%=entityType.getHtmlDescription()%></b>
      <br/><br/>
      <%=errorMessage%>
    </v:widget-block>
  </v:widget>
</v:page-form>

</body>

</html>
