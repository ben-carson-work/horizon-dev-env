<%@page import="java.net.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.web.mob.page.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="errorMsg" class="java.lang.String" scope="request"/>
<% PageMOB_Base<?> pageBase = (PageMOB_Base<?>)request.getAttribute("pageBase"); %>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0" />

    <title>SnApp</title>
    
    <link rel='stylesheet' id='open-sans-css'  href='<v:config key="site_url"/>/fonts/fonts.css' type='text/css' media='all' />
    <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/bootstrap_3.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/font-awesome-6.4.2/css/fontawesome.min.css"> 
    <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/font-awesome-6.4.2/css/solid.min.css"> 
    <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/font-awesome-6.4.2/css/brands.min.css"> 
    <script type="text/javascript" src="<v:config key="site_url"/>/libraries/jquery/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="<v:config key="site_url"/>/libraries/jquery-ui-1.14.1/jquery-ui.min.js"></script>
    <% String ver = URLEncoder.encode(BLBO_DBInfo.getWebInit().getWarVersion(), "UTF-8"); %>
    <script type="text/javascript" src="?page=lksn&ver=<%=ver%>"></script>

    <jsp:include page="common/mob-common-css.jsp"/>
    <jsp:include page="common/mob-common-js.jsp"/>
    
    <script><jsp:include page="common/mob-native.js"/></script>
    <script><jsp:include page="common/mob-api.js"/></script>
    <script><jsp:include page="common/mob-websocket.js"/></script>
    <script><jsp:include page="common/mob-bl.js"/></script>
    <script><jsp:include page="common/mob-ui.js"/></script>
    <script><jsp:include page="common/mob-dlg-mediapickup.js"/></script>
    <script><jsp:include page="common/mob-dlg-datetime.js"/></script>
    <script><jsp:include page="common/mob-ui-maskedit.js"/></script>
      
    <script>
      <% if (JvString.getNull(errorMsg) == null) { %>
        $(document).ready(function() {
          BLMob.handShake();
        });
      <% } %>
    </script>
  </head>
  
  <body>
    <div id="mobile-main">
    <% if (JvString.getNull(errorMsg) != null) { %>
      <h1 style="text-align:center; margin-top:20vw"><%=JvString.escapeHtml(errorMsg)%></h1>
    <% } %>
    </div>
    
    <div id="common-templates" class="templates">
      <div class="pref-item">
        <div class="pref-item-caption"></div>
        <div class="pref-item-value"></div>
        <div class="pref-item-arrowicon"><i class="fa fa-chevron-right"></i></div>
      </div>

      <div class="main-spinner">
        <i class="fa fa-spin fa-circle-notch"></i>
      </div>
      
      <div class="mobile-dialog dlg-message">
        <div class="mobile-dialog-title"></div>
        <div class="mobile-dialog-body"></div>
        <div class="mobile-dialog-footer"></div>
      </div>
      
      <div class="mobile-dialog dlg-mediapickup">
        <div class="mobile-dialog-title"><span class="snp-itl" data-key="@Common.MediaLookup"/></div>
        <div class="mobile-dialog-body dlg-idle-mode">
          <div><input type="text"/></div>
          <div class="error-box dlg-error-mode"></div>
        </div>
        <div class="mobile-dialog-footer dlg-idle-mode">
          <div class="mobile-dialog-button btn-last"><span class="snp-itl" data-key="@Common.LastMedia"/></div>
          <div class="mobile-dialog-button btn-camera"><span class="snp-itl" data-key="@Common.Camera"/></div>
          <div class="mobile-dialog-button btn-nfc"><span class="snp-itl" data-key="@Common.NFC"/></div>
          <div class="mobile-dialog-button btn-ok"><span class="snp-itl" data-key="@Common.Ok"/></div>
          <div class="mobile-dialog-button btn-cancel"><span class="snp-itl" data-key="@Common.Cancel"/></div>
        </div>
        <div class="dlg-spinner-mode">
          <div class="spinner-icon"><i class="fa fa-spin fa-circle-notch"></i></div>
        </div>
      </div>
      
      <div class="mobile-dialog dlg-datetime">
        <div class="mobile-dialog-title"><span class="snp-itl" data-key="Date/Time picker"/></div>
        <div class="mobile-dialog-body">
          <div class="dtpick-list dtpick-year"></div>
          <div class="dtpick-list dtpick-month"></div>
          <div class="dtpick-list dtpick-day"></div>
          <div class="dtpick-list dtpick-hour"></div>
          <div class="dtpick-list dtpick-minute"></div>
        </div>
        <div class="mobile-dialog-footer dlg-idle-mode">
          <div class="mobile-dialog-button btn-ok"><span class="snp-itl" data-key="@Common.Ok"/></div>
          <div class="mobile-dialog-button btn-cancel"><span class="snp-itl" data-key="@Common.Cancel"/></div>
        </div>
      </div>
      
      <div class="mobile-popup">
        <div class="mobile-popup-inner">
          <div class="mobile-popup-item">
            <div class="mobile-popup-item-inner">
              <div class="mobile-popup-item-icon"></div>
              <div class="mobile-popup-item-caption mobile-ellipsis"></div>
              <div class="mobile-popup-item-hint mobile-ellipsis"></div>
            </div>
          </div>
        </div>
      </div>

      <div class="btn-catalog btn-catalog-folder noselect">
        <div class="btn-catalog-body">
          <div class="btn-catalog-name mobile-ellipsis"></div>
        </div>
      </div>

      <div class="btn-catalog btn-catalog-event noselect">
        <div class="btn-catalog-body">
          <div class="btn-catalog-name mobile-ellipsis"></div>
        </div>
      </div>

      <div class="btn-catalog btn-catalog-prodtype noselect">
        <div class="btn-catalog-body">
          <div class="btn-catalog-name mobile-ellipsis"></div>
          <div class="btn-catalog-price mobile-ellipsis"></div>
          <div class="btn-catalog-qty mobile-ellipsis"></div>
        </div>
      </div>
      

<%--   
    <div class="mob-widget">
      <div class="mob-widget-header"/>
    </div>

    <div class="mob-widget-block">
      <div class="mob-widget-icon"/>
      <div class="mob-widget-content">
        <div class="mob-widget-title"></div>
          <div class="mob-widget-data">
            <div class="mob-widget-data-icon"/>
            <div class="mob-widget-data-text"/>
          </div>
      </div>
    </div>
--%>    
      
    </div>
  </body>
</html>
