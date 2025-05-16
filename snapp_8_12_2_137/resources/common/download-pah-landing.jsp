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
<% 
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); 

String licenseeName = "SnApp";
String licenseeProfilePictureId = null;
String bkgColor = null;
String bkgRepositoryId = null;
LookupItem bkgStyle = LkSNBackgroundStyle.Center;
if (!BLBO_DBInfo.isDatabaseEmpty() && !BLBO_DBInfo.isDatabaseUpdateNeeded()) {
  String masterAccountId = BLBO_DBInfo.getMasterAccountId();
  DORightRoot rights = pageBase.getBL(BLBO_Right.class).loadRights(LkSNEntityType.Licensee, masterAccountId);
  licenseeProfilePictureId = pageBase.getBL(BLBO_Repository.class).findProfilePictureId(masterAccountId);
  licenseeName = pageBase.getBL(BLBO_Account.class).getAccountName(masterAccountId);
  bkgColor = rights.PahBkgColor.getString();
  bkgRepositoryId = rights.PahBkgRepositoryId.getString();
  if (!rights.PahBkgStyle.isNull())
    bkgStyle = rights.PahBkgStyle.getLkValue(); 
}

String saleId = pageBase.getId();
String saleCode = null;
boolean validOrder = false;
JvDataSet ds = pageBase.getDB().executeQuery("select SaleStatus, SaleCode, Paid from tbSale where SaleId=" + JvString.sqlStr(saleId));
try {
  if (!ds.isEmpty()) {
    saleCode = ds.getField("SaleCode").getString();
    if (ds.getField("Paid").getBoolean()) {
      String[] mediaIDs = pageBase.getBL(BLBO_Sale.class).getPahPrintableMediaIDs(saleId, false);
      validOrder = (mediaIDs.length > 0);
    }
  }
}
finally {
  ds.dispose();
}
%>
<!DOCTYPE html>
<html>

<head>
  <title><%=JvString.escapeHtml(licenseeName)%></title>
  <link rel="shortcut icon" href="<v:config key="resources_url"/>/admin/images/favicon.ico"/>
  <link rel='stylesheet' id='open-sans-css'  href='<v:config key="site_url"/>/fonts/fonts.css' type='text/css' media='all' />
  <link type="text/css" href="<v:config key="site_url"/>/admin?page=admin-css&newstyle=true" rel="stylesheet" media="all" />
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/jquery/jquery-3.6.0.min.js"></script>
  
  <style>
    body {
      min-width: 600px;
      <% if (bkgColor != null) { %>
        background-color: <%=bkgColor%>;
      <% } %>
      <% if (bkgRepositoryId != null) { %>
        background-image: url(<v:config key="site_url"/>/repository?id=<%=bkgRepositoryId%>);
        background-position: center center;
        background-attachment: fixed;
        <% if (!bkgStyle.isLookup(LkSNBackgroundStyle.Repeat)) { %>
          background-repeat: no-repeat;
        <% } %>
        <% if (bkgStyle.isLookup(LkSNBackgroundStyle.Extend)) { %>
          background-size: 100% 100%;
        <% } else if (bkgStyle.isLookup(LkSNBackgroundStyle.Cover)) { %>
          background-size: cover;
        <% } else if (bkgStyle.isLookup(LkSNBackgroundStyle.Contain)) { %>
          background-size: contain;
        <% } %>
      <% } %>
    }
    
    #body-box {
      padding: 10px;
      margin: auto;
      margin-top: 100px;
      margin-bottom: 50px;
      width: 780px;
      
      height: 420px;
      border-radius: 10px;
      box-shadow: 0 0 20px rgba(0,0,0,0.075);
      <% if (bkgRepositoryId != null) { %>
        box-shadow: 0 0 20px rgba(0,0,0,0.25);
      <% } %>
      background-color: white;
    }
    
    #body-box-title {
      overflow: hidden;
      padding: 10px;
      border-bottom: 1px solid rgba(0,0,0,0.1);
    }
    
    #body-box-content {
      padding: 10px;
    }
  
    #licensee-pic {
      width: 100px;
      height: 100px;
      float: left;
      <% if (licenseeProfilePictureId == null) { %>
        background-image: url(<v:image-link name="snapp-icon-round.png" size="128"/>);
      <% } else { %>
        background-image: url(<v:config key="site_url"/>/repository?type=small&id=<%=licenseeProfilePictureId%>);
      <% } %>
      background-size: cover;
    }
    
    #licensee-name {
      margin-left: 110px;
      line-height: 100px;
      font-size: 46px;
      color: rgba(0,0,0,0.5);
      text-align: center;
      margin-right: 110px;
    }
    
    .error-message {
      text-align: center;
      font-size: 20px;
      line-height: 36px;
      color: rgba(0,0,0,0.5);
    }
    
    #download-box {
      background-image: url(<v:image-link name="rpt-pdf.png" size="128"/>);
      background-repeat: no-repeat;
      background-position: center 10px;
      width: 170px;
      height: 25px;
      margin: 50px auto;
      padding-top: 145px;
      text-align: center;
      font-size: 16px;
      font-weight: bold;
      cursor: pointer;
      opacity: 0.8;
    }
    
    #download-box:hover {
      opacity: 1;
      background-color: var(--highlight-color);
      border-radius: 10px;
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
  </style>

  <script>
    function doStartDownload() {
      $("#download-box").addClass("v-hidden");
      $("#thanks-box").removeClass("v-hidden");
      window.location = "<%=pageBase.buildURL_DownloadPah(saleId)%>";
    }
  </script>
</head>

<body>

<%
String msgDown = 
    "System is down for maintenance<br/>" +
    "Sistema está cerrado por mantenimiento<br/>" +
    "Le système est en cours de maintenance<br/>" +
    "System ist zurzeit im Wartungs<br/>" +
    "Il sistema è fuori servizio per manutenzione<br/>" +
    "النظام هو أسفل للصيانة<br/>" +
    "系统正在维护中<br/>" + 
    "システムは、メンテナンスのためにダウンしています<br/>";
    
String msgNotFound = 
    "Order not found<br/>" +
    "Ordenar que no se encuentra<br/>" +
    "Commander not found<br/>" +
    "Bestellen Sie nicht gefunden<br/>" +
    "Ordine non trovato<br/>" +
    "النظام لم يتم العثور<br/>" +
    "订单未找到<br/>" + 
    "ご注文が見つかりません<br/>";
        
String msgInvalid = 
    "Download not allowed<br/>" +
    "Descarga no permitida<br/>" +
    "Télécharger ne sont pas autorisés<br/>" +
    "Laden Sie nicht erlaubt<br/>" +
    "Download non consentito<br/>" +
    "تحميل غير مسموح<br/>" +
    "下载不准<br/>" + 
    "ダウンロード許可されていません<br/>";
        
String msgThanks = 
    "Thank you<br/>" +
    "Gracias<br/>" +
    "Je vous remercie<br/>" +
    "Vielen Dank<br/>" +
    "Grazie<br/>" +
    "شكرا<br/>" +
    "谢谢<br/>" + 
    "ありがとうございました<br/>";
%>

<div id="body-box">
  <% if (BLBO_DBInfo.isDatabaseEmpty() || BLBO_DBInfo.isDatabaseUpdateNeeded()) { %>
    <div class="error-message" style="margin-top:60px"><%=msgDown%></div>
  <% } else { %>
    <div id="body-box-title">
      <div id="licensee-pic"></div>
      <div id="licensee-name"><%=JvString.escapeHtml(licenseeName)%></div>
    </div>
    <div id="body-box-content">
      <% if (saleCode == null) { %>
        <div class="error-message"><%=msgNotFound%></div>
      <% } else if (!validOrder) { %>
        <div class="error-message"><%=msgInvalid%></div>
      <% } else { %>
        <div id="download-box" onclick="doStartDownload()">DOWNLOAD</div>
        <div id="thanks-box" class="error-message v-hidden"><%=msgThanks%></div>
      <% } %>
    </div>
  <% } %>
</div>


<div id="login-footer">
  <a id="login-footer-vgslogo" href="https://www.accesso.com/solutions/ticketing/ticketing-visitor-management" target="_blank"></a>
  <div id="login-footer-center">Horizon by VGS &mdash; &copy; 2023 accesso Technology Group, plc</div>
  <div id="login-footer-right">Version <v:config key="display-version"/></div>
</div>

<div id="password-change-dialog" title="<v:itl key="@Common.PasswordExpired" encode="UTF-8"/>" class="v-hidden">
  <table style="width:100%">
    <tr><th><v:itl key="@Common.PasswordNew"/></th><td><input type="password" id="newpwd"/></td></tr>
    <tr><th><v:itl key="@Common.PasswordConfirmation"/></th><td><input type="password" id="newpwd-check"/></td></tr>
  </table>
  <div id="password-change-error"></div>
</div>
  
</body>

</html>