<%@page import="com.vgs.web.tag.ConfigTag"%>
<%@page import="com.vgs.snapp.query.*"%>
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
<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>
<!DOCTYPE html>
<html>

<head>
  <title>Call Center &lsaquo; <v:config key="site_title"/></title>
  <link rel="shortcut icon" href="<v:config key="resources_url"/>/admin/images/favicon.ico"/>
  <link rel='stylesheet' id='open-sans-css'  href='<v:config key="site_url"/>/fonts/fonts.css' type='text/css' media='all' />
  <link type="text/css" href="<v:config key="site_url"/>/admin?page=admin-css&newstyle=true" rel="stylesheet" media="all" />
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/jquery/jquery-3.6.0.min.js"></script>
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/jquery-ui-1.14.1/jquery-ui.min.js"></script>
  <script type="text/javascript" src="<v:config key="site_url"/>/admin?page=admin-js"></script>
  
  <style>
    h1 {
      text-align: center;
      font-weight: normal;
      font-style: italic;
      font-size: 80px;
      line-height: 100px;
      color: rgba(0,0,0,0.4);
    }
  
    #wks-box-container {
      padding: 0 20 0 20px;
      text-align: center;
    }
  
    .wks-box {
      position: relative;
      width: 180px;
      height: 180px;
      display: inline-block;
      margin: 20px;
      border: 1px solid var(--border-color);
      cursor: pointer;
      background-position: center center;
      background-size: cover;
    }
    
    .wks-box.icon {
      background-size: 64px 64px;
      background-repeat: no-repeat;
      background-color: rgba(255,255,255,0.4);
      background-position: center 40px;
    }
    
    .wks-box:hover {
      margin: 15px;
      border: 6px solid var(--highlight-color);
      border-radius: 4px;
      box-shadow: 0 0 10px rgba(0,0,0,0.4);
    }

    .wks-box.icon:hover {
      background-color: rgba(255,255,255,0.8);
    }
    
    .wks-box-name {
      position: absolute;
      bottom: 0;
      left: 0;
      right: 0;
      font-size: 20px;
      line-height: 24px;
      padding: 10px 10px 5px 10px;
    }
    
    .wks-box:hover .wks-box-name {
      font-size: 24px;
    }
    
    .wks-box.profile-pic .wks-box-name {
      background-image: linear-gradient(rgba(0,0,0,0), rgba(0,0,0,0.6));
      color: white;
      text-shadow: 0 0 4px black;
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
      background-color: rgba(0,0,0,0.04);
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
  </style>
</head>

<body>

<h1>Call Center</h1>

<div id="wks-box-container">
<% 


QueryDef qdef = new QueryDef(QryBO_Workstation.class);
qdef.addSelect(QryBO_Workstation.Sel.WorkstationURI);
qdef.addSelect(QryBO_Workstation.Sel.WorkstationName);
qdef.addSelect(QryBO_Workstation.Sel.ProfilePictureId);
qdef.addFilter(QryBO_Workstation.Fil.WorkstationType, LkSNWorkstationType.CLC.getCode());
JvDataSet ds = pageBase.execQuery(qdef);
if (ds.isEmpty()) {
  %>No workstation configured as call center<%
}
else if (ds.getRecordCount() == 1) {
  String uri = ds.getField(QryBO_Workstation.Sel.WorkstationURI).getHtmlString();
  %><script>window.location = "<v:config key="site_url"/>/cc/<%=uri%>"</script><%
}
else {
  while (!ds.isEof()) {
    String uri = ds.getField(QryBO_Workstation.Sel.WorkstationURI).getHtmlString();
    String name = ds.getField(QryBO_Workstation.Sel.WorkstationName).getHtmlString();
    String profilePictureId = ds.getField(QryBO_Workstation.Sel.ProfilePictureId).getString();
    String url = ConfigTag.getValue("site_url") + "/cc/" + uri;
    String style = ConfigTag.getValue("site_url") + "/imagecache?name=menu_callcenter_black.png&size=128";
    String clazz = "icon";
    if (profilePictureId != null) {
      style = ConfigTag.getValue("site_url") + "/repository?type=large&id=" + profilePictureId;
      clazz = "profile-pic";
    }
    %>
      <div class="wks-box <%=clazz%>" style="background-image:url(<%=style%>)" onclick="window.location='<%=url%>'">
        <div class="wks-box-name"><%=name%></div>
      </div>
    <%
    ds.next();
  }
}
%>
</div>

<div id="login-footer">
  <a id="login-footer-vgslogo" href="https://www.accesso.com/solutions/ticketing/ticketing-visitor-management" target="_blank"></a>
  <div id="login-footer-center">Horizon by VGS &mdash; &copy; 2023<br/>accesso Technology Group, plc</div>
  <div id="login-footer-right">Version <v:config key="display-version"/></div>
</div>

  
</body>

</html>