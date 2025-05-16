<%@page import="com.vgs.web.library.*"%>
<%@page import="java.net.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% 
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); 
BOSessionBean boSession = (pageBase == null) ? null : (BOSessionBean)pageBase.getSession();
%>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>SnApp</title>
    
    <link rel='stylesheet' id='open-sans-css'  href='<v:config key="site_url"/>/fonts/fonts.css' type='text/css' media='all' />
    <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/bootstrap_3.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/font-awesome-6.4.2/css/fontawesome.min.css"> 
    <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/font-awesome-6.4.2/css/solid.min.css"> 
    <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/font-awesome-6.4.2/css/brands.min.css"> 
    
    <script type="text/javascript" src="<v:config key="site_url"/>/libraries/jquery/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="<v:config key="site_url"/>/libraries/jquery-ui-1.14.1/jquery-ui.min.js"></script>
    <script type="text/javascript" charset="utf-8" src="<v:config key="site_url"/>/libraries/bootstrap_3.4.1/js/bootstrap.min.js"></script>

    <jsp:include page="../mobileCommon/mob-common-css.jsp" /> 
    <jsp:include page="../mobileCommon/mob-common-js.jsp" />
    
    <% String ver = URLEncoder.encode(BLBO_DBInfo.getWebInit().getWarVersion(), "UTF-8"); %>
    <script type="text/javascript" src="<%=pageBase.getContextURL()%>?page=itl&ver=<%=ver%>&LangISO=<%=pageBase.getLangISO()%>"></script>
    
    <script>
      vgsSession = <%=JvString.jsString(boSession.getSessionId())%>;
      loggedWorkstationId = <%=JvString.jsString(boSession.getWorkstationId())%>; 
      loggedUserAccountId = <%=JvString.jsString(boSession.getUserAccountId())%>; 
      <% JvCurrency curr = pageBase.getCurrFormatter(); %>
      mainCurrencyFormat = <%=curr.getCurrencyFormat().getCode()%>;
      mainCurrencySymbol = <%=JvString.jsString(curr.getSymbol())%>;
      mainCurrencyISO = <%=JvString.jsString(curr.getIsoCode())%>;
      thousandSeparator = <%=rights.ThousandSeparator.getJsString()%>;
      decimalSeparator = <%=rights.DecimalSeparator.getJsString()%>;
      snpShortDateFormat = <%=rights.ShortDateFormat.getInt()%>;
      snpShortTimeFormat = <%=rights.ShortTimeFormat.getInt()%>;
      snpFirstDayOfWeek = <%=rights.FirstDayOfWeek.getInt() - 1%>;
    </script>
  </head>
  
  <body>
  
