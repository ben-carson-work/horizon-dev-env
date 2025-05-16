<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>
<% BOSessionBean boSession = (pageBase == null) ? null : pageBase.getSession(); %>


<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<jsp:include page="shopcart_css.jsp"/>

<div id="page-shopcart" class="mainlist-container">
  <div id="catalog-block">
    <div class="block-inner">
      <div class="block-title"><div class="title-caption"><v:itl key="@Product.Catalogs"/></div></div>
      <div class="block-body">
         <div id="catalog-container">
           <div class="item-container waiting"></div>
         </div>
      </div>
    </div>
  </div>
  <div id="event-block">
    <div class="block-inner">
       <div class="block-title">
         <div class="title-image"></div>
         <div class="title-caption"><v:itl key="@Event.Events"/></div>
         <div class="subtitle-caption"><v:itl key="@Event.Events"/></div>
       </div>
       <div class="block-body">
        <div id="event-container">
           <div class="item-container"></div>
        </div>
        <div id="perf-container" class="v-hidden">
          <div id="perf-filters">
             <input id="txt-perf-filter" type="text" disabled="disabled" data-DateFrom="<%=JvDateTime.date().getXMLDate()%>" placeholder="Date / Time / Availability filter..."/>
             <div id="btn-perf-filter" class="v-button icon-button float-right v-tooltip v-tooltip-click" data-jsp="../common/shopcart/perf_filter_tooltip"><img src="<v:image-link name="bkoact-calendar.png" size="24"/>"/></div>
          </div>
          <div class="item-container"></div>
        </div>
      </div>
    </div>
  </div>
  <div id="product-block">
    <div class="block-inner">
       <div class="block-title">
         <div class="title-image"></div>
         <div class="title-caption"><v:itl key="@Product.ProductTypes"/></div>
         <div class="subtitle-caption"><v:itl key="@Product.ProductTypes"/></div>
       </div>
       <div class="block-body">
         <div id="product-container">
           <div class="item-container"></div>
         </div>
       </div>
    </div>
  </div>
  <div id="cart-block" class="empty-cart">
    <div class="block-inner">
       <div class="block-title">
         <div id="cart-total-container">
           <div id="cart-total-subtotal" class="cart-field">
             <div class="field-caption"><v:itl key="@Common.SubTotal"/></div>
             <div class="field-value"></div>
           </div>
           <div id="cart-total-tax" class="cart-field">
             <div class="field-caption"><v:itl key="@Product.Taxes"/></div>
             <div class="field-value"></div>
           </div>
           <div id="cart-total-paid" class="cart-field">
             <div class="field-caption"><v:itl key="@Payment.PaidAmount"/></div>
             <div class="field-value"></div>
           </div>
           <div id="cart-total-due" class="cart-field">
             <div class="field-caption"><v:itl key="@Payment.TotalDue"/></div>
             <div class="field-value"></div>
           </div>
         </div>
         <div id="cart-tools">
           <div class="full-cart-tools">
             <div id="btn-emptycart" class="v-button float-left hl-red"><v:itl key="@Common.EmptyShopCart"/><span id="shopcart-timer"></span></div>
             <div id="btn-checkout" class="v-button float-right hl-green"><v:itl key="@Common.Checkout"/></div>
             <div id="btn-promo" class="v-button float-right hl-green v-hidden"><v:itl key="@Common.Promo"/></div>
           </div>
           <div class="empty-cart-tools">
             <input id="txt-search" class="two-button" type="text" placeholder="PNR" maxlength="8"/>
             <div id="btn-handover" class="v-button icon-button float-right disabled" onclick="onShopCartHandover(this)" title="<v:itl key="@Common.InventoryGetFrom"/>"><i class="fa fa-cubes"></i></div>             
             <div id="btn-account" class="v-button icon-button float-right disabled" onclick="onShopCartAccount(this)" title="<v:itl key="@Account.Account"/>"><i class="fa fa-user"></i></div>
             <div id="btn-lastres" class="v-button icon-button float-right disabled" onclick="onShopCartLastRes(this)" title="<v:itl key="@Reservation.LastReservation"/>"><i class="fa fa-clock"></i></div>
           </div>
         </div>
       </div>
       <div class="block-body">
         <div class="trntype-container"><span class="trntype-desc"></span></div>
         <div class="item-container"></div>
       </div>
       <div class="block-footer">
         <div id="btn-salemenu" class="v-button icon-button" onclick="onShowCartMenu(this)"><i class="fa fa-bars"></i></div>
         <div id="cart-pnr-field" class="cart-field">
           <div class="field-caption"><v:itl key="@Sale.PNR"/></div>
           <div class="field-value"></div>
         </div>
         <div id="cart-status-field" class="cart-field">
           <div class="field-caption"><v:itl key="@Common.Status"/></div>
           <div class="field-value"></div>
         </div>
         <div id="cart-guest-field" class="cart-field">
           <div class="field-caption"><v:itl key="@Lookup.SaleAccountType.Guest"/></div>
           <div class="field-value"></div>
         </div>
       </div>
     </div>
  </div>
</div>

<div class="v-hidden">
  <div id="folder-template">
    <div class="catalog-item">
      <div class="item-indent">
        <div class="folder-collapse"><i class="fa fa-minus"></i></div>
        <div class="folder-explode"><i class="fa fa-plus"></i></div>
        <img class="item-img"/>
        <div class="item-caption v-tooltip-overflow">text</div>
      </div>
    </div>
  </div>
</div>

<div id="cart-menu" class="v-hidden">
  <div class="menu-item" onclick="onAddCoupon(this)">
    <i class="item-img fa fa-lg fa-badge-percent"></i>
    <div class="item-caption"><v:itl key="@Product.AddCoupon"/></div>
  </div>
  <% if (pageBase.isVgsContext("CLC")) { %>
    <div class="menu-item" onclick="onSaleVoid(this)">
      <i class="item-img fa fa-lg fa-trash-alt"></i>
      <div class="item-caption"><v:itl key="@Common.Void"/></div>
    </div>
  <% } %>
</div>

<jsp:include page="shopcart_js.jsp"/>

<jsp:include page="/resources/common/footer.jsp"/>

