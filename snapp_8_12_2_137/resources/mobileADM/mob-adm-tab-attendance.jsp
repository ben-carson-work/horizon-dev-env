<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileAdmission" scope="request"/>

<jsp:include page="mob-adm-tab-attendance-css.jsp"/>
<jsp:include page="mob-adm-tab-attendance-js.jsp"/>

<div id="attendance-main-tab-content" class="tab-content">
  <div class="tab-header"><div class="tab-header-title"><v:itl key="@AccessPoint.Attendance"/></div></div>
  <div class="tab-body"></div>

  <div class="hidden">
    <div id="attendance-item-template" class="attendance-item">
      <div class="attendance-item-pic"></div>
      <div class="attendance-item-detail">
        <div class="attendance-item-line">
          <div class="attendance-item-time mobile-ellipsis"></div>
          <div class="attendance-item-quantity mobile-ellipsis"></div>
        </div>
        <div class="attendance-item-line">
          <div class="attendance-item-event mobile-ellipsis"></div>
          <div class="attendance-item-pbout"><div class="attendance-item-pbin"></div></div>
        </div>
      </div>
    </div>
  </div>
</div>

