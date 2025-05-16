<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.b2b.page.PageB2B_InventoryProductList" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<div class="tab-toolbar">
  <v:pagebox gridId="inventory-product-grid"/>
</div>


<div class="tab-content">    
  <v:last-error/>
  <% String params = "AccountId=" + pageBase.getSession().getOrgAccountId();%>
  <v:async-grid id="inventory-product-grid" jsp="inventory/inventory_product_grid.jsp" params="<%=params%>" />
</div>

<jsp:include page="/resources/common/footer.jsp"/>