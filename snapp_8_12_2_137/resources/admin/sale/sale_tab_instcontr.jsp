<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSale" scope="request"/>

<v:tab-toolbar>
  <v:pagebox gridId="instcontr-grid"/>
</v:tab-toolbar>

<v:tab-content>
  <% String params = "SaleId=" + pageBase.getId(); %>
  <v:async-grid id="instcontr-grid" jsp="installment/contract_grid.jsp" params="<%=params%>"/>
</v:tab-content>

