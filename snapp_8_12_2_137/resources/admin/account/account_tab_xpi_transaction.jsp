<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>

<div class="tab-toolbar">
  <v:pagebox gridId="transaction-xpi-grid"/>
</div>

<div class="tab-content">
  <v:last-error/>

  <% String params = "CrossPlatformId=" + pageBase.getId(); %>
  <v:async-grid id="transaction-xpi-grid" jsp="transaction/transaction_xpi_grid.jsp" params="<%=params%>"/>
</div>

