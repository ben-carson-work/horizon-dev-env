<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTransaction" scope="request"/>

<div class="tab-toolbar">
  <v:pagebox gridId="activationgroupactivity-grid"/>
</div>

<div class="tab-content">
  <% String params = "TransactionId=" + pageBase.getId(); %>
  <v:async-grid id="activationgroupactivity-grid" jsp="portfolio/activationgroupactivity_grid.jsp" params="<%=params%>"/>
</div>

