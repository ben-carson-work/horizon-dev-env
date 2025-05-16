<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="view-shopcart" data-transactiontype="1" data-reservation="false">
  <div class="tab-header">
    <div class="toolbar-button btn-toolbar-back"></div>
    <div class="cartdisplay-container"/>
    <div class="resdisplay-container">
      <div class="resdisplay-line">
        <div class="resdisplay-icon"><i class="fa fa-book"></i></div>
        <div class="order-pnr mobile-ellipsis"></div>
      </div>
      <div class="resdisplay-line mobile-ellipsis owner-account">
      </div>
    </div>
    <div class="toolbar-button btn-toolbar-checkout btn-float-right"><i class="fa fa-check"></i></div>
    <div class="toolbar-button btn-toolbar-emptycart btn-float-right"><i class="fas fa-times"></i></div>
  </div>
  
  <div class="tab-body">
    <div class="transaction-type"></div>
    
    <div class="reservation-section mob-widget">
      <div class="mob-widget-block">
        <div class="mob-card">
          <div class="mob-card-icon mob-card-icon-small"><i class='fa fa-book'></i></div>
          <div class="mob-card-body">
            <div class="order-status mobile-ellipsis"></div>
            <div class="sale-channel mobile-ellipsis"></div>
          </div>
          <div class="mob-card-body resbtn-list">
            <div class="resbtn resbtn-app">
              <i class="fa fa-handshake"></i>
            </div>
            <div class="resbtn resbtn-pay">
              <i class="fa fa-money-bill"></i>
            </div>
            <div class="resbtn resbtn-prn">
              <i class="fa fa-print"></i>
            </div>
            <div class="resbtn resbtn-val">
              <i class="fa fa-stamp"></i>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <div class="privilege-card mob-widget">
      <div class="mob-widget-block">
        <div class="mob-card">
          <div class="mob-card-icon mob-card-icon-small"><i class='fa fa-award'></i></div>
          <div class="mob-card-body">
            <div class="privcard-line">
              <div class="product-name mobile-ellipsis"></div>
              <div class="account-name mobile-ellipsis"></div>
            </div>
            <div class="privcard-line">
              <div class="ticket-code mobile-ellipsis"></div>
              <div class="ticket-validity mobile-ellipsis"></div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="sc-group-list"/>
  </div>
  
  <div class="templates">
    <div class="shopcart-item">
      <div class="shopcart-item-data">
        <div class="shopcart-item-topleft"></div>
        <div class="shopcart-item-topright"></div>
        <div class="shopcart-item-bottomleft"></div>
        <div class="shopcart-item-bottomright"></div>
      </div>
    </div>
    
    <div class="sc-group">
      <div class="sc-group-title">
        <div class="sc-group-title-caption"/>
      </div>
      <div class="sc-group-body">
      </div>
    </div>
    
    <div class="sc-item">
      <div class="sc-item-data">
        <div class="sc-item-data-line line1">
          <div class="sc-item-data-value data-value-l1"></div>
          <div class="sc-item-data-value data-value-r1"></div>
        </div>
        <div class="sc-item-data-line line2">
          <div class="sc-item-data-value data-value-l2"></div>
          <div class="sc-item-data-value data-value-r2"></div>
        </div>
      </div>
      <div class="sc-item-btns">
      </div>
    </div>
    
  </div>
  
</div>
