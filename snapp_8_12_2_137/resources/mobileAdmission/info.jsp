<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@page import="com.vgs.web.tag.ConfigTag"%>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileAdmission" scope="request"/>

<jsp:include page="info-css.jsp" />
<jsp:include page="info-js.jsp" />
<div id="info" class="status-select">
  <%-- HEADER --%>
  <div class="toolbar">
    <div id="adm-title" class="title wrap">Info</div>
    <div class="access-point-name">
			No access point
		</div>
  </div>
  
  <%-- BODY --%>
  <div class="body">
  	<div class="infobar">
			Info Access point
		</div>
		
	  <!-- <div class="actionbar scrolling">
		<div id="accesspointlist-btn" class="actionbar-btn ftright img-accessctrl button">Bar Code</div>
	</div>
	-->
    <div class="wrap">
      <div class="ios-list-title">Login information</div>
      <ul id="info-list" class="ios-list">
        <li>Apt Name<div id="aptName" class="caption"></div></li>
        <li>Apt Code<div id="aptCode" class="caption"></div></li>
        <li>Apt Location<div id="aptLocation" class="caption"></div></li>
      </ul>
      <div class="ios-list-title">Backend application</div>
      <ul id="info-list" class="ios-list">
        <li>Version<div class="caption"><v:config key="display-version"/></div></li>
      </ul>
	  </div>
  </div>
</div>
<script>
	$("#info-tab").bind("<%=pageBase.getEventClick()%>", function() {
    NativeBridge.call("StopBarcodeCamera", [], null);
//    sendCommand("StopRFID");
//    sendCommand("StopBarcode");
//    sendCommand("StopCreditCard");
    refreshInfo();
	});
   
  function refreshInfo() {
    $("#device-serial").html("Reading...");
    NativeBridge.call("getDeviceId", ["firstArgument"], function (serial) {
      $("#device-serial").html(serial);
    });
  }

  $("#info .logout-btn").bind("<%=pageBase.getEventClick()%>", function() {
	  window.location = '<%=ConfigTag.getValue("site_url") %>/mobile?page=logout';
  });
  
</script>


