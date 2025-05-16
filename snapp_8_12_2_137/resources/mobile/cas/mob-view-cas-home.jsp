<%@page import="com.vgs.snapp.web.mob.page.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<% PageMOB_Base<?> pageBase = (PageMOB_Base<?>)request.getAttribute("pageBase"); %>

<div id="page-main" data-activetab="catalog">
  
  <script><jsp:include page="mob-blcart.js"/></script>
  <script><jsp:include page="mob-blcatalog.js"/></script>
  <script><jsp:include page="flow/mob-step-portfolio.js"/></script>
  <script><jsp:include page="flow/mob-step-payment.js"/></script>
  <script><jsp:include page="flow/mob-step-ticket.js"/></script>
  <script><jsp:include page="flow/mob-step-upload.js"/></script>
  <script><jsp:include page="flow/mob-blflow.js"/></script>
  <script><jsp:include page="flow/pay/mob-payhandler-cash.js"/></script>
  <script><jsp:include page="flow/pay/mob-payhandler-wallet.js"/></script>

  <div class="tab-button-list">
    <div class="tab-button" data-packagename="AppMOB_SalesOperator" data-viewname="shopcart">
      <div class="tab-button-icon"><i class="fa fa-shopping-basket"></i></div>
      <div class="tab-button-caption"><div class="snp-itl" data-key="@Common.ShopCart"/></div>
    </div>
    <div class="tab-button tab-button-default" data-packagename="AppMOB_SalesOperator" data-viewname="catalog">
      <div class="tab-button-icon"><i class="fa fa-book-open"></i></div>
      <div class="tab-button-caption"><div class="snp-itl" data-key="@Product.Catalog"/></div>
    </div>
    <div class="tab-button" data-packagename="AppMOB_SalesOperator" data-viewname="account-list">
      <div class="tab-button-icon"><i class="fa fa-user"></i></div>
      <div class="tab-button-caption"><div class="snp-itl" data-key="@Account.Accounts"/></div>
    </div>
    <div class="tab-button" data-packagename="AppMOB_Admission" data-viewname="redeem">
      <div class="tab-button-icon"><i class="fa fa-barcode-scan"></i></div>
      <div class="tab-button-caption"><div class="snp-itl" data-key="@AccessPoint.Redemption"/></div>
    </div>
    <div class="tab-button" data-packagename="AppMOB_SalesOperator" data-viewname="apt-monitor">
      <div class="tab-button-icon"><i class="fa fa-archway"></i></div>
      <div class="tab-button-caption"><div class="snp-itl" data-key="@Common.Monitor"/></div>
    </div>
    <div class="tab-button" data-packagename="COMMON" data-viewname="info">
      <div class="tab-button-icon"><i class="fa fa-info"></i></div>
      <div class="tab-button-caption"><div class="snp-itl" data-key="@Common.Info"/></div>
    </div>
  </div>
</div>

<script>
UIMob.init("cas-home", function($view, params) {
  if (!BLMob.isAppAvailable(PKG_ADM) || (BLMob.AccessPoint == null))
    $view.find(".tab-button[data-viewname='redeem']").remove();
  UIMob.initTabsContent($view);
});
</script>

