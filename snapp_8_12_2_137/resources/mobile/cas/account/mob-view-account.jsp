<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="view-account">
  <div class="tab-header">
    <div class="toolbar-button btn-toolbar-back"></div>
    <div class="toolbar-button btn-toolbar-menu btn-float-right"><i class="fa fa-bars"></i></div>
    <div class="toolbar-button btn-toolbar-sup btn-float-right"><i class="fa fa-user-tie"></i></div>
    <div class="tab-header-title"><span class="snp-itl" data-key="@Account.Account"/></div>
  </div>
  
  <div class="tab-body">
    <div class="lookup-content hidden">
      <div class="account-section">
        <div class="mob-card">
          <div class="mob-card-icon account-pic"></div>
          <div class="mob-card-body account-detail">
            <div class="mob-card-title">
              <span class="account-name mobile-ellipsis"></span>
              <span class="account-status"></span>
            </div>
          </div>
          <div class="mob-card-body account-arrow"><i class="fa fa-chevron-right"></i></div>
        </div>
      </div>

      <div class="portfolio-container"></div>

      <div class="media-container"></div>
    </div>
  </div>
  
  <div class="templates">
      
    <div class="mob-widget portfolio-section">
      <div class="mob-widget-block">
        <v:mob-pref-simple id="pref-item-balance" caption="@Common.Balance" arrow="true"/>
        <v:mob-pref-simple id="pref-item-portfolios" caption="@Common.Portfolios" arrow="true"/>
      </div>
    </div>

    <div class="mob-widget media-section">
      <div class="mob-widget-header">Portfolio content</div>
      <div class="mob-widget-block ticket-block">
        <div class="mob-card ticket-card">
          <div class="mob-card-icon"><i class='fa fa-ticket-alt'></i></div>
          <div class="mob-card-body">
            <div class="mob-card-title">
              <span class="text-productname mobile-ellipsis"></span>
              <span class="text-price"></span>
            </div>
          </div>
        </div>
      </div>
      <div class="mob-widget-block">
        <v:mob-pref-simple id="pref-item-usages" caption="@Ticket.Usages" arrow="true"/>
        <v:mob-pref-simple id="pref-item-tickets" caption="@Ticket.AllTickets" arrow="true"/>
        <v:mob-pref-simple id="pref-item-media" caption="@Common.Media" arrow="true"/>
        <v:mob-pref-simple id="pref-item-medias" caption="@Media.AllMedias" arrow="true"/>
      </div>
    </div>
    
  </div>
</div>
