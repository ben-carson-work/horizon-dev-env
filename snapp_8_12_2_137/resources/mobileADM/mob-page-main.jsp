<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileAdmission" scope="request"/>
<jsp:include page="../mobileCommon/mob-common-header.jsp"/>

<jsp:include page="mob-common-css.jsp" />

<link rel="stylesheet" href="<v:config key="site_url"/>/libraries/bootstrap_3.4.1/css/bootstrap-theme.min.css">
  <div id="page-main" class="page-main-adm" data-activetab="redeem">
    <div class="main-tab-body-list">
      <div class="tab-content-container" data-tabcode="redeem"><jsp:include page="mob-adm-tab-redeem.jsp"/></div>
      <div class="tab-content-container" data-tabcode="specialprod"><jsp:include page="mob-adm-tab-specialprod.jsp"/></div>
      <div class="tab-content-container" data-tabcode="attendance"><jsp:include page="mob-adm-tab-attendance.jsp"/></div>
      <div class="tab-content-container" data-tabcode="info"><jsp:include page="mob-adm-tab-info.jsp"/></div>
    </div>
  
    <div class="tab-button-list">
      <div class="tab-button" data-tabcode="redeem">
        <div class="tab-button-icon"><i class="fa fa-rectangle-barcode"></i></div>
        <div class="tab-button-caption"><v:itl key="@AccessPoint.Redemption"/></div>
      </div>
      <div class="tab-button" data-tabcode="specialprod">
        <div class="tab-button-icon"><i class="fa fa-star"></i></div>
        <div class="tab-button-caption"><v:itl key="@Product.SpecialProducts"/></div>
      </div>
      <div class="tab-button" data-tabcode="attendance">
        <div class="tab-button-icon"><i class="fa fa-chart-user"></i></div>
        <div class="tab-button-caption"><v:itl key="@AccessPoint.Attendance"/></div>
      </div>
      <div class="tab-button" data-tabcode="info">
        <div class="tab-button-icon"><i class="fa fa-circle-info"></i></div>
        <div class="tab-button-caption"><v:itl key="@Common.Info"/></div>
      </div>
    </div>
  </div>

  <div class="hidden">
    <jsp:include page="mob-adm-form-portfoliolookup.jsp"/>    
  </div>
  
<jsp:include page="mob-common-footer.jsp"/>
