<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.bko.page.PageBO_InstallmentContract" scope="request"/>

<v:tab-toolbar>
  <v:pagebox gridId="ticket-grid"/>
</v:tab-toolbar>

<v:tab-content>
  <% String params = "InstallmentContractId=" + pageBase.getId(); %>
  <v:async-grid id="ticket-grid" jsp="portfolio/ticket_grid.jsp" params="<%=params%>"/>
</v:tab-content>

