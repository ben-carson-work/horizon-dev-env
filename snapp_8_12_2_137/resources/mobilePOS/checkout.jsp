<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:include page="checkout-css.jsp" />
<jsp:include page="checkout-js.jsp" />

<div id="checkoutContent">
  <div class="scrolling checkoutRowsContainer pref-section" >
    <div class="" style="background-color:#fff;">
      <table style="width:100%" class="">
      <thead class="cartHeader">
        <tr class="">
          <th class="productImage"></th>
          <th class="checkoutProductName">Product Name</th>
          <th class="checkoutItemUnitPrice">Unit Price</th>
          <th class="quantity">#</th>
          <th class="checkoutItemPrice">Price</th>
        </tr>
      </thead>
      <tbody  class="checkoutRows">
      </tbody>
      </table>
    </div>
  </div>
  <div class="paymentMethodList col-md-12 col-xs-12 scrolling-wrapper scrolling-wrapper-flexbox">
    
  </div>
</div>