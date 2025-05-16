<%@page import="com.vgs.snapp.jwt.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="java.net.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% 
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); 
BOSessionBean boSession = (pageBase == null) ? null : (BOSessionBean)pageBase.getSession();
%>
<head>
  <title><%= JvString.escapeHtml(JvMultiLang.translate(pageBase.getLang(), pageBase.getPageTitle())) %> &lsaquo; SnApp</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <link rel="shortcut icon" href="<v:config key="resources_url"/>/admin/images/favicon.ico">

  <link rel='stylesheet' id='open-sans-css'  href='<v:config key="site_url"/>/fonts/fonts.css' type='text/css' media='all' />

  <link type="text/css" href="<v:config key="site_url"/>/libraries/jquery-ui-1.14.1/jquery-ui.min.css" rel="stylesheet" />

  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/jquery/jquery-3.6.0.min.js"></script>
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/jquery-ui-1.14.1/jquery-ui.min.js"></script>
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/selectize/selectize.min.js"></script>
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/jquery-mousewheel-master/jquery.mousewheel.min.js"></script>
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/commonmark-0.29/commonmark.min.js"></script>
  
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/bootstrap_3.4.1/js/bootstrap.min.js"></script>
  <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/bootstrap_3.4.1/css/bootstrap.min.css">
  <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/bootstrap_3.4.1/css/bootstrap-theme.min.css">
  
  <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/font-awesome-6.4.2/css/fontawesome.min.css"> 
  <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/font-awesome-6.4.2/css/solid.min.css"> 
  <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/font-awesome-6.4.2/css/brands.min.css"> 

  <link rel="stylesheet" media="screen" type="text/css" href="<v:config key="site_url"/>/libraries/colorpicker/css/colorpicker.css" />
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/colorpicker/js/colorpicker.js"></script>

  <% String ver = URLEncoder.encode(BLBO_DBInfo.getWebInit().getWarVersion(), "UTF-8"); %>
  <link type="text/css" href="<%=pageBase.getContextURL()%>?page=admin-css&ver=<%=ver%>" rel="stylesheet" media="all" />
  <script type="text/javascript" src="<%=pageBase.getContextURL()%>?page=admin-js&ver=<%=ver%>"></script>
  <script type="text/javascript" src="<%=pageBase.getContextURL()%>?page=itl&ver=<%=ver%>&LangISO=<%=pageBase.getLangISO()%>"></script> 

  <meta name="apple-mobile-web-app-capable" content="yes" />
  <link rel="apple-touch-icon-precomposed" href="<v:image-link name="vgs-mobile-logo.png" size="57"/>" />
  <link rel="apple-touch-icon-precomposed" <%="sizes=\"72x72\""%> href="<v:image-link name="vgs-mobile-logo.png" size="72"/>" />
  <link rel="apple-touch-icon-precomposed" <%="sizes=\"114x114\""%> href="<v:image-link name="vgs-mobile-logo.png" size="114"/>" />
  <link rel="apple-touch-icon-precomposed" <%="sizes=\"144x144\""%> href="<v:image-link name="vgs-mobile-logo.png" size="144"/>" />
  
  <script>
    vgsSession = <%=JvString.jsString(boSession.getSessionId())%>;
    loggedWorkstationId = <%=JvString.jsString(boSession.getWorkstationId())%>; 
    loggedUserAccountId = <%=JvString.jsString(boSession.getUserAccountId())%>; 
    vgsContext = <%=JvString.jsString(pageBase.getVgsContext())%>; 
    vgsContextURL = <%=JvString.jsString(pageBase.getContextURL())%>; 
    <% JvCurrency curr = pageBase.getCurrFormatter(); %>
    mainCurrencyFormat = <%=curr.getCurrencyFormat().getCode()%>;
    mainCurrencySymbol = <%=JvString.jsString(curr.getSymbol())%>;
    mainCurrencyISO = <%=JvString.jsString(curr.getIsoCode())%>;
    thousandSeparator = <%=rights.ThousandSeparator.getJsString()%>;
    decimalSeparator = <%=rights.DecimalSeparator.getJsString()%>;
    snpShortDateFormat = <%=rights.ShortDateFormat.getInt()%>;
    snpShortTimeFormat = <%=rights.ShortTimeFormat.getInt()%>;
    snpFirstDayOfWeek = <%=rights.FirstDayOfWeek.getInt() - 1%>;
    uploadBannedExtensions = <%=pageBase.getRights().BannedFileExtensions.getJsString()%>;
    uploadFileSizeLimit = <%=pageBase.getRights().FileSizeUploadLimit.getJsString()%>;

    $.datepicker.setDefaults({
      changeMonth: true,
      changeYear: true,
      showOtherMonths: true,
      selectOtherMonths: true,
      yearRange: "-200:+200",
      dateFormat: <%=JvString.jsString(pageBase.isAmericanDateFormat() ? "mm/dd/yy" : "dd/mm/yy")%>
    });
  </script>
</head>
