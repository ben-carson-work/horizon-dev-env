<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="apt" class="com.vgs.snapp.dataobject.DOAccessPointRef" scope="request"/>
<% PageMobileSales pageBase = (PageMobileSales)request.getAttribute("pageBase"); %>

<jsp:include page="form-medialookup-css.jsp"/>
<jsp:include page="form-medialookup-js.jsp"/>

<div id="frm-medialookup-template" class="tab-content">

  
</div>

<div id="pref-medialookup-template">
  <div class="pref-section account-section">
    <div class="pref-item-list">
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
  </div>

  <div class="pref-section">
    <div class="pref-item-list">
    
      <div class="pref-item menu-media pref-item-arrow" data-TemplateSelector="#frm-medialookup-media-template">
        <div class="pref-item-caption"><v:itl key="@Common.Media"/></div>
        <div class="pref-item-value"></div>
      </div>
      <div class="pref-item menu-ticket pref-item-arrow" data-TemplateSelector="#frm-medialookup-ticket-template">
        <div class="pref-item-caption"><v:itl key="@Ticket.Ticket"/></div>
        <div class="pref-item-value"></div>
      </div>
      <div class="pref-item menu-usages pref-item-arrow" data-TemplateSelector="#frm-medialookup-usages-template">
        <div class="pref-item-caption"><v:itl key="@Ticket.Usages"/></div>
        <div class="pref-item-value"></div>
      </div>
      <div class="pref-item menu-medias pref-item-arrow" data-TemplateSelector="#frm-medialookup-medias-template">
        <div class="pref-item-caption"><v:itl key="@Common.PortfolioMedias"/></div>
        <div class="pref-item-value"></div>
      </div>
      <div class="pref-item menu-tickets pref-item-arrow" data-TemplateSelector="#frm-medialookup-tickets-template">
        <div class="pref-item-caption"><v:itl key="@Common.PortfolioTickets"/></div>
        <div class="pref-item-value"></div>
      </div>
    </div>
  </div>

</div>


<div id="frm-medialookup-media-template" class="tab-content">
  
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
  
    <div class="pref-section" style='margin-bottom:140px;'>
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


<div id="frm-medialookup-ticket-template" class="tab-content">

  
    <div class="pref-section product-section">
      <div class="pref-item-list">
        <div class="product-pic glyicon" data-glyicon="product"></div>
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
    
    <div class="pref-section performance-section" style='margin-bottom:140px;'>
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


<div id="frm-medialookup-usages-template" class="tab-content">
  
  <div class="tab-body">
  </div>
</div>


<div id="frm-medialookup-medias-template" class="tab-content">
  
  <div class="tab-body">
  </div>
</div>


<div id="frm-medialookup-tickets-template" class="tab-content">
  
  <div class="tab-body">
  </div>
</div>

<div id="rec-medialookup-usage-template" class="medialookup-rec-item">
  <div class="mobile-ellipsis usage-datetime rec-title"><span class="medialookup-rec-text"></span></div>
  <div class="mobile-ellipsis usage-valresult"><span class="medialookup-rec-text"></span></div>
  <div class="mobile-ellipsis usage-location"><span class="medialookup-rec-icon" data-glyicon="location"></span><span class="medialookup-rec-text"></span></div>
  <div class="mobile-ellipsis usage-product"><span class="medialookup-rec-icon" data-glyicon="product"></span><span class="medialookup-rec-text"></span></div>
</div>

<div id="rec-medialookup-pmedia-template" class="medialookup-rec-item">
  <div class="mobile-ellipsis pmedia-tdssn rec-title"><span class="medialookup-rec-text"></span></div>
  <div class="mobile-ellipsis pmedia-status"><span class="medialookup-rec-text"></span></div>
  <div class="mobile-ellipsis pmedia-print rec-small"><span class="medialookup-rec-icon" data-glyicon="print"></span><span class="medialookup-rec-text"></span></div>
</div>

<div id="rec-medialookup-pticket-template" class="medialookup-rec-item">
  <div class="mobile-ellipsis pticket-tdssn rec-title"><span class="medialookup-rec-text"></span></div>
  <div class="mobile-ellipsis pticket-status"><span class="medialookup-rec-icon" data-glyicon="status"></span><span class="medialookup-rec-text"></span></div>
  <div class="mobile-ellipsis pticket-product"><span class="medialookup-rec-icon" data-glyicon="product"></span><span class="medialookup-rec-text"></span></div>
  <div class="mobile-ellipsis pticket-event"><span class="medialookup-rec-icon" data-glyicon="event"></span><span class="medialookup-rec-text"></span></div>
  <div class="mobile-ellipsis pticket-perf"><span class="medialookup-rec-icon" data-glyicon="performance"></span><span class="medialookup-rec-text"></span></div>
  <div class="mobile-ellipsis pticket-price"><span class="medialookup-rec-icon" data-glyicon="payment"></span><span class="medialookup-rec-text"></span></div>
</div>
