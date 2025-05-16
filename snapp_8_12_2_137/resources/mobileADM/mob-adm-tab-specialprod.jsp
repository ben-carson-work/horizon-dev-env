<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileAdmission" scope="request"/>

<script><%@ include file="mob-adm-tab-specialprod.js"%></script>
<style><%@ include file="mob-adm-tab-specialprod.css"%></style>

<div id="specialprod-main-tab-content" class="tab-content">
  <div class="tab-header"><div class="tab-header-title"><v:itl key="@Product.SpecialProducts"/></div></div>
  <div class="tab-body"></div>

  <div id="specialprod-templates" class="hidden">
    <div class="specialprod">
      <div class="specialprod-pic"><i class="fa"></i></div>
      <div class="specialprod-detail">
        <div class="specialprod-name mobile-ellipsis"></div>
        <div class="specialprod-code mobile-ellipsis"></div>
      </div>
    </div>
  </div>
</div>

