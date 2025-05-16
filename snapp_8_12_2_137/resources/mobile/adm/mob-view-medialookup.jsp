<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="view-medialookup">
  <div class="tab-header">
    <div class="toolbar-button btn-toolbar-back"></div>
    <div class="toolbar-button btn-toolbar-menu btn-float-right"><i class="fa fa-bars"></i></div>
    <div class="toolbar-button btn-toolbar-sup btn-float-right"><i class="fa fa-user-tie"></i></div>
    <div class="tab-header-title"><span class="snp-itl" data-key="@Common.Media"/></div>
    
    
    
  </div>
  <div class="tab-body">
    <div class="lookup-content hidden">
      <div class="account-section">
        <div class="account-pic"></div>
        <div class="account-detail">
          <div class="account-value account-name"></div>
          <div class="account-caption"><v:itl key="@Common.Balance"/></div>
          <div class="account-value wallet-balance"></div>
          <div class="account-caption"><v:itl key="@Common.CreditLimit"/></div>
          <div class="account-value wallet-credit"></div>
          <div class="account-caption"><v:itl key="@Common.Expiration"/></div>
          <div class="account-value wallet-expiration"></div>
        </div>
      </div>
      
      <div class="pref-section">
        <div class="pref-item-list">
          <v:mob-pref-simple id="pref-item-media" caption="@Common.Media" arrow="true"/>
          <v:mob-pref-simple id="pref-item-tickets" caption="@Ticket.Tickets" arrow="true"/>
          <v:mob-pref-simple id="pref-item-medias" caption="@Media.LinkedMedias" arrow="true"/>
          <v:mob-pref-simple id="pref-item-usages" caption="@Ticket.Usages" arrow="true"/>
        </div>
      </div>
    </div>
  </div>
</div>
