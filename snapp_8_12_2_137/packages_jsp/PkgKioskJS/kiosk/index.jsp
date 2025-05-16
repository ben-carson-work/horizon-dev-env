<%@page import="com.vgs.snapp.dataobject.DOPlugin"%>
<%@page import="com.vgs.snapp.dataobject.DODriver"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.net.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="kiosk" class="com.vgs.snapp.dataobject.DOKioskUI" scope="request"/>
<% 
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");
String packageCode = "pkg-kiosk-js";
    
String ver = pageBase.getBL(BLBO_Plugin.class).findExtensionPackageVersion(packageCode);
String workstationId = pageBase.getSession().getWorkstationId();
String kioskControllerSrc = "/plugins/" + packageCode + "/kiosk-controller.js";

%> 
<!DOCTYPE html>

<head>
  <title>SnApp KIOSK</title>

  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/jquery/jquery-3.6.0.min.js"></script>
  <script type="text/javascript" src="<v:config key="site_url"/>/plugins/pkg-kiosk-js/kiosk/libraries/qrcodejs-1.0.0/qrcode.min.js"></script>
  
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/bootstrap-5.2.2/js/bootstrap.min.js"></script>
  <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/bootstrap-5.2.2/css/bootstrap.min.css">
  
  <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/font-awesome-6.4.2/css/fontawesome.min.css"> 
  <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/font-awesome-6.4.2/css/solid.min.css"> 
  <link rel="stylesheet" href="<v:config key="site_url"/>/libraries/font-awesome-6.4.2/css/brands.min.css"> 

  <link type="text/css" href="<%=pageBase.getContextURL()%>?page=kiosk&action=css&ver=<%=ver%>" rel="stylesheet" media="all" />

	<script type="text/javascript" src="<v:config key="site_url"/>/rest/v1/workstations/<%=workstationId%>/devicemanager?ver=<%=ver%>"></script>
<%--   <script type="text/javascript" src="<v:config key="site_url"/>/libraries/face-api/js/face-api.min.js"></script> --%>
	<script type="text/javascript" src="<v:config key="site_url"/><%=kioskControllerSrc%>?ver=<%=ver%>"></script>
  
  <style>
    .blurred-background {background-image:url(<%=kiosk.BackgroundImageURL.getString()%>)}
  </style>
  
  <script>//# sourceURL=common-js.jsp
    <jsp:include page="..\..\..\resources\common\script\common-js.jsp"></jsp:include>
  </script>
  
  
  <%=(String)request.getAttribute("kiosk-scripts")%>
  
  <script>
    const RIGHTS = <%=rights.getJSONString()%>;
    const SNAPP_API = KIOSK_CONTROLLER.snappAPI;
    var KIOSK_UI_CONTROLLER = null;

    <% JvCurrency curr = pageBase.getCurrFormatter(); %>
    mainCurrencyFormat = <%=curr.getCurrencyFormat().getCode()%>;
    mainCurrencySymbol = <%=JvString.jsString(curr.getSymbol())%>;
    mainCurrencyISO = <%=JvString.jsString(curr.getIsoCode())%>;
    thousandSeparator = <%=rights.ThousandSeparator.getJsString()%>;
    decimalSeparator = <%=rights.DecimalSeparator.getJsString()%>;
    snpShortDateFormat = <%=rights.ShortDateFormat.getInt()%>;
    snpShortTimeFormat = <%=rights.ShortTimeFormat.getInt()%>;
    snpFirstDayOfWeek = <%=rights.FirstDayOfWeek.getInt() - 1%>;

    $(document).ready(function() {
      KIOSK_UI_CONTROLLER = new KioskUIController({"apiUrl":"<v:config key="site_url"/>", "workstationId":<%=JvString.jsString(workstationId)%>, "kiosk":<%=kiosk.getJSONString()%>});
    });
  </script>
</head>

<body>
 
  <div class="blurred-background"></div> 
 
  <div id="status-screens">
    <div class="status-screen active" data-kiosk-status="INIT" data-controller="StatusInitController">
      <jsp:include page="status-init/status-init.jsp"></jsp:include>
    </div>
    <div class="status-screen" data-kiosk-status="ERROR">
      <jsp:include page="status-error/status-error.jsp"></jsp:include>
    </div>
    <div class="status-screen" data-kiosk-status="TRANSACTION" data-controller="StatusTransactionController">
      <jsp:include page="status-transaction/status-transaction.jsp"></jsp:include>
    </div>
    <div class="status-screen" data-kiosk-status="IDLE" data-controller="StatusIdleController">
      <jsp:include page="status-idle/status-idle.jsp"></jsp:include>
    </div>
    <div class="status-screen" data-kiosk-status="MAINTENANCE" data-controller="StatusMaintenanceController">
      <jsp:include page="status-maintenance/status-maintenance.jsp"></jsp:include>
    </div>
  </div>

  <!-- video is needed for webcamera activation -->    
  <video id="video" width="720" height="576" class="hidden" autoplay muted></video>
  

  <div id="kiosk-templates" class="hidden">
    <jsp:include page="common/dlg-confirm.jsp"></jsp:include>
    <jsp:include page="common/dlg-error.jsp"></jsp:include>
    <jsp:include page="common/dlg-input.jsp"></jsp:include>
    <jsp:include page="common/dlg-info.jsp"></jsp:include>
    <jsp:include page="common/dlg-pin-login.jsp"></jsp:include>
    <jsp:include page="common/spinner.jsp"></jsp:include>
  </div>
    
</body>
</html>