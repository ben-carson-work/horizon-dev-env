<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>

<div class="tab-content">
  <v:last-error/>
  <% String params = "AccountId=" + pageBase.getId(); %>
  <v:async-grid id="ext-product-type-grid-container" jsp="account/ext_product_type_grid.jsp" params="<%=params%>" />
</div>

