<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileAdmission" scope="request"/>
<jsp:useBean id="wks" class="com.vgs.entity.dataobject.DOEnt_Workstation" scope="request"/>
<%
DOEnt_Workstation.DOWorkstation.DOAccessPoint apt = (DOEnt_Workstation.DOWorkstation.DOAccessPoint)request.getAttribute("apt");
%>

<jsp:include page="mob-adm-form-portfoliolookup-css.jsp"/>
<jsp:include page="mob-adm-form-portfoliolookup-js.jsp"/>

<div id="frm-portfoliolookup-template" class="tab-content">
  <div class="tab-header">
    <div class="toolbar-button btn-toolbar-back"></div>
    <div class="tab-header-title"><v:itl key="@Common.Portfolio"/></div>
  </div>
  <div class="tab-body waiting"></div>
</div>

<div id="pref-portfoliolookup-template">
  <div class="pref-section account-section">
    <div class="pref-item-list">
      <div class="account-pic"><i class="fa fa-user nopic"></i></div>
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
  </div>

  <div class="pref-section">
    <div class="pref-item-list">
    
      <div class="pref-item menu-notes pref-item-arrow" data-TemplateSelector="#frm-portfoliolookup-notes-template">
        <div class="pref-item-caption"><v:itl key="@Common.Notes"/></div>
        <div class="pref-item-value"></div>
      </div>
      <div class="pref-item menu-media pref-item-arrow" data-TemplateSelector="#frm-portfoliolookup-media-template">
        <div class="pref-item-caption"><v:itl key="@Common.Media"/></div>
        <div class="pref-item-value"></div>
      </div>
      <div class="pref-item menu-ticket pref-item-arrow" data-TemplateSelector="#frm-portfoliolookup-ticket-template">
        <div class="pref-item-caption"><v:itl key="@Ticket.Ticket"/></div>
        <div class="pref-item-value"></div>
      </div>
      <div class="pref-item menu-usages pref-item-arrow" data-TemplateSelector="#frm-portfoliolookup-usages-template">
        <div class="pref-item-caption"><v:itl key="@Ticket.Usages"/></div>
        <div class="pref-item-value"></div>
      </div>
      <div class="pref-item menu-medias pref-item-arrow" data-TemplateSelector="#frm-portfoliolookup-medias-template">
        <div class="pref-item-caption"><v:itl key="@Common.PortfolioMedias"/></div>
        <div class="pref-item-value"></div>
      </div>
      <div class="pref-item menu-tickets pref-item-arrow" data-TemplateSelector="#frm-portfoliolookup-tickets-template">
        <div class="pref-item-caption"><v:itl key="@Common.PortfolioTickets"/></div>
        <div class="pref-item-value"></div>
      </div>
    </div>
  </div>

</div>


<div id="frm-portfoliolookup-media-template" class="tab-content">
  <div class="tab-header">
    <div class="toolbar-button btn-toolbar-back"></div>
    <div class="tab-header-title"><v:itl key="@Common.Media"/></div>
  </div>
  <div class="tab-body">
    <div class="pref-section-spacer"></div>
    
    <div class="pref-section">
      <div class="pref-item-list">
        <div class="pref-item media-status">
          <div class="pref-item-caption"><v:itl key="@Common.Status"/></div>
          <div class="pref-item-value"></div>
        </div>
        <div class="pref-item media-tdssn">
          <div class="pref-item-caption"><v:itl key="@Common.TDSSN"/></div>
          <div class="pref-item-value"></div>
        </div>
        <div class="pref-item media-printed">
          <div class="pref-item-caption"><v:itl key="@Reservation.Flag_Printed"/></div>
          <div class="pref-item-value"></div>
        </div>
        <div class="pref-item media-exclusive">
          <div class="pref-item-caption"><v:itl key="@Common.ExclusiveUse"/></div>
          <div class="pref-item-value"></div>
        </div>
        <div class="pref-item media-pah">
          <div class="pref-item-caption"><v:itl key="@Common.PrintAtHome"/></div>
          <div class="pref-item-value"></div>
        </div>
      </div>
    </div>
  
    <div class="pref-section">
      <div class="pref-item-list">
        <div class="pref-item trn-tdssn">
          <div class="pref-item-caption"><v:itl key="@Common.Transaction"/></div>
          <div class="pref-item-value"></div>
        </div>
        <div class="pref-item trn-location">
          <div class="pref-item-caption"><v:itl key="@Account.Location"/></div>
          <div class="pref-item-value"></div>
        </div>
        <div class="pref-item trn-oparea">
          <div class="pref-item-caption"><v:itl key="@Account.OpArea"/></div>
          <div class="pref-item-value"></div>
        </div>
        <div class="pref-item trn-wks">
          <div class="pref-item-caption"><v:itl key="@Common.Workstation"/></div>
          <div class="pref-item-value"></div>
        </div>
      </div>
    </div>
  </div>
</div>


<div id="frm-portfoliolookup-ticket-template" class="tab-content">
  <div class="tab-header">
    <div class="toolbar-button btn-toolbar-back"></div>
    <div class="tab-header-title"><v:itl key="@Ticket.Ticket"/></div>
  </div>
  <div class="tab-body">
    <div class="pref-section product-section">
      <div class="pref-item-list">
        <div class="product-pic v-fa-icon" data-iconalias="tag"></div>
        <div class="product-detail">
          <div class="product-name"></div>
          <div class="product-code"></div>
        </div>
      </div>
    </div>
    
    <div class="pref-section">
      <div class="pref-item-list">
        <div class="pref-item tck-status">
          <div class="pref-item-caption"><v:itl key="@Common.Status"/></div>
          <div class="pref-item-value"></div>
        </div>
        <div class="pref-item tck-tdssn">
          <div class="pref-item-caption"><v:itl key="@Common.TDSSN"/></div>
          <div class="pref-item-value"></div>
        </div>
        <div class="pref-item tck-price">
          <div class="pref-item-caption"><v:itl key="@Product.Price"/></div>
          <div class="pref-item-value"></div>
        </div>
        <div class="pref-item tck-quantity">
          <div class="pref-item-caption"><v:itl key="@Common.Quantity"/></div>
          <div class="pref-item-value"></div>
        </div>
      </div>
    </div>
    
    <div class="pref-section performance-section">
      <div class="pref-item-list">
        <div class="pref-item performance-datetime">
          <div class="pref-item-caption"><v:itl key="@Common.DateTime"/></div>
          <div class="pref-item-value"></div>
        </div>
        <div class="pref-item performance-event">
          <div class="pref-item-caption"><v:itl key="@Event.Event"/></div>
          <div class="pref-item-value"></div>
        </div>
        <div class="pref-item performance-location">
          <div class="pref-item-caption"><v:itl key="@Account.Location"/></div>
          <div class="pref-item-value"></div>
        </div>
        <div class="pref-item performance-seat">
          <div class="pref-item-caption"><v:itl key="@Seat.Seat"/></div>
          <div class="pref-item-value"></div>
        </div>
      </div>
    </div>
  </div>
</div>


<div id="frm-portfoliolookup-notes-template" class="tab-content">
  <div class="tab-header">
    <div class="toolbar-button btn-toolbar-back"></div>
    <div class="tab-header-title"><v:itl key="@Common.Notes"/></div>
    <div class="toolbar-button btn-toolbar-highlight"><i class="fa fa-triangle-exclamation"></i></div>
  </div>
  <div class="tab-body">
  </div>
</div>


<div id="frm-portfoliolookup-usages-template" class="tab-content">
  <div class="tab-header">
    <div class="toolbar-button btn-toolbar-back"></div>
    <div class="tab-header-title"></div>
  </div>
  <div class="tab-body">
  </div>
</div>


<div id="frm-portfoliolookup-medias-template" class="tab-content">
  <div class="tab-header">
    <div class="toolbar-button btn-toolbar-back"></div>
    <div class="tab-header-title"></div>
  </div>
  <div class="tab-body">
  </div>
</div>


<div id="frm-portfoliolookup-tickets-template" class="tab-content">
  <div class="tab-header">
    <div class="toolbar-button btn-toolbar-back"></div>
    <div class="tab-header-title"></div>
  </div>
  <div class="tab-body">
  </div>
</div>

<div id="rec-portfoliolookup-note-template" class="portfoliolookup-rec-item status-border status-border-draft">
  <div class="note-userpic"><i class="fa fa-user nopic"></i></div>
  <div class="note-body">
    <div class="note-user"></div>
    <div class="note-datetime"></div>
    <div class="note-text"></div>
  </div>
</div>

<div id="rec-portfoliolookup-usage-template" class="portfoliolookup-rec-item">
  <div class="mobile-ellipsis usage-datetime rec-title"><span class="portfoliolookup-rec-text"></span></div>
  <div class="mobile-ellipsis usage-valresult"><span class="portfoliolookup-rec-text"></span></div>
  <div class="mobile-ellipsis usage-location"><span class="portfoliolookup-rec-icon v-fa-icon" data-iconalias="map-marker"></span><span class="portfoliolookup-rec-text"></span></div>
  <div class="mobile-ellipsis usage-product"><span class="portfoliolookup-rec-icon v-fa-icon" data-iconalias="tag"></span><span class="portfoliolookup-rec-text"></span></div>
</div>

<div id="rec-portfoliolookup-pmedia-template" class="portfoliolookup-rec-item">
  <div class="mobile-ellipsis pmedia-tdssn rec-title"><span class="portfoliolookup-rec-text"></span></div>
  <div class="mobile-ellipsis pmedia-status"><span class="portfoliolookup-rec-text"></span></div>
  <div class="mobile-ellipsis pmedia-print rec-small"><span class="portfoliolookup-rec-icon v-fa-icon" data-iconalias="print"></span><span class="portfoliolookup-rec-text"></span></div>
</div>

<div id="rec-portfoliolookup-pticket-template" class="portfoliolookup-rec-item">
  <div class="mobile-ellipsis pticket-tdssn rec-title"><span class="portfoliolookup-rec-text"></span></div>
  <div class="mobile-ellipsis pticket-status"><span class="portfoliolookup-rec-icon v-fa-icon" data-iconalias="flag"></span><span class="portfoliolookup-rec-text"></span></div>
  <div class="mobile-ellipsis pticket-product"><span class="portfoliolookup-rec-icon v-fa-icon" data-iconalias="tag"></span><span class="portfoliolookup-rec-text"></span></div>
  <div class="mobile-ellipsis pticket-event"><span class="portfoliolookup-rec-icon v-fa-icon" data-iconalias="masks-theater"></span><span class="portfoliolookup-rec-text"></span></div>
  <div class="mobile-ellipsis pticket-perf"><span class="portfoliolookup-rec-icon v-fa-icon" data-iconalias="calendar-alt"></span><span class="portfoliolookup-rec-text"></span></div>
  <div class="mobile-ellipsis pticket-price"><span class="portfoliolookup-rec-icon v-fa-icon" data-iconalias="money-bill"></span><span class="portfoliolookup-rec-text"></span></div>
</div>
