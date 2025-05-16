<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@ taglib uri="ksk-tags" prefix="ksk" %>

<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>

<ksk:step-screen id="step-catalog" stepCode="CATALOG" controller="StepCatalogController">
  <jsp:include page="../../common/kiosk-header.jsp"></jsp:include>
  <jsp:include page="../../common/spinner.jsp"></jsp:include>
<%--     <jsp:include page="../common/performance.jsp"></jsp:include> --%>
  
  <div id="catalog-container" class="hide-loading">
    <div id="catalog-tab"></div>
    <div id="catalog-body"></div>
  </div>
  
  <div id="catalog-templates" class="hidden">
    <jsp:include page="catalog-button.jsp"></jsp:include>

    <div class="catalog-body">
      <div class="catalog-body-content">
        <div class="event-body">
          <div class="event-body-performances"></div>
        </div>
        <div class="catalog-body-performance-title"></div>
      </div>
    </div>
    
    <div class="catalog-tab user-select-none">
      <div class="catalog-tab-title"></div>
    </div>
    
  </div>
</ksk:step-screen>
