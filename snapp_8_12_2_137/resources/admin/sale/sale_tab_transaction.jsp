<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSale" scope="request"/>

<div class="tab-toolbar">
  <v:pagebox gridId="transaction-grid"/>
</div>

<div class="tab-content">
  <v:last-error/>

  <% String params = "SaleId=" + pageBase.getId(); %>
  <v:async-grid id="transaction-grid" jsp="transaction/transaction_grid.jsp" params="<%=params%>"/>
</div>

