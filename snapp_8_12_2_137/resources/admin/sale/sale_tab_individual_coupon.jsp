<%@page import="com.vgs.web.tag.ConfigTag"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSale" scope="request"/>

<div class="tab-toolbar">
  <v:pagebox gridId="coupon-grid"/>
</div>

<div class="tab-content">
  <v:last-error/>

  <% String params = "SaleId=" + pageBase.getId(); %>
  <v:async-grid id="coupon-grid" jsp="product/coupon/individual_coupon_grid.jsp" params="<%=params%>"/>
</div>

