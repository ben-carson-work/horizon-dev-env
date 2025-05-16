<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="java.net.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.tag.ConfigTag"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
<!DOCTYPE html>
<html>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageDocketDisplay" scope="request"/>

<head>
  <title>SnApp Docket Display</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <link rel="shortcut icon" href="<v:config key="resources_url"/>/admin/images/favicon.ico">

  <link rel='stylesheet' id='open-sans-css'  href='<v:config key="site_url"/>/fonts/fonts.css' type='text/css' media='all' />

  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/jquery/jquery-3.6.0.min.js"></script>
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/jquery-ui-1.14.1/jquery-ui.min.js"></script>
  
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/bootstrap_3.4.1/js/bootstrap.min.js"></script>
  <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/bootstrap_3.4.1/css/bootstrap.min.css">
  <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/bootstrap_3.4.1/css/bootstrap-theme.min.css">
  <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/font-awesome-6.4.2/css/fontawesome.min.css"> 
  <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/font-awesome-6.4.2/css/solid.min.css"> 
  <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/font-awesome-6.4.2/css/brands.min.css"> 

  <% String ver = URLEncoder.encode(BLBO_DBInfo.getWebInit().getWarVersion(), "UTF-8"); %>
  <link type="text/css" href="<%=pageBase.getContextURL()%>?page=admin-css&ver=<%=ver%><%=pageBase.isNewStyle()?"&newstyle=true":""%>" rel="stylesheet" media="all" />
  <script type="text/javascript" src="<%=pageBase.getContextURL()%>?page=admin-js&ver=<%=ver%>"></script>
  
  
  <jsp:include page="docket_display-css.jsp"/>
  <jsp:include page="docket_display-js.jsp"/>
  
</head>

<body>

<div id="docket-templates" class="hidden">

  <div class="docket-container">
    <div class="docket">
      <div class="docket-header">
        <div class="row">
          <div class="col-sm-9"><div class="docket-title"></div></div>
          <div class="col-sm-3"><div class="docket-serial"></div></div>
        </div>
        <div class="docket-waiter"></div>
        <div class="row">
          <div class="col-sm-6"><div class="docket-order-time"></div></div>
          <div class="col-sm-6"><div class="docket-elapsed-time"></div></div>
        </div>
      </div>
      <div class="docket-body">
      </div>
      <div class="docket-footer">
        <v:button caption="@OpenTab.DocketStart" clazz="start-btn"/>
        <v:button caption="@OpenTab.DocketReady" clazz="ready-btn"/>
        <v:button caption="@OpenTab.DocketDelivered" clazz="delivered-btn"/>
        <v:button caption="@OpenTab.DocketUndo" clazz="undo-btn"/>
      </div>
    </div>
  </div>

  <div class="docket-item">
    <div class="docket-item-title"></div>
    <div class="docket-item-bom"></div>
  </div>

</div>

<div id="docket-list"></div>

</body>

</html>