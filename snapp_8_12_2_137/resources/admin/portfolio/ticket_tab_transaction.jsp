<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTicket" scope="request"/>

<div class="tab-toolbar">
  <v:pagebox gridId="trn-grid"/>
</div>

<div class="tab-content">
  <% String params = "TicketId=" + pageBase.getId(); %>
  <v:async-grid id="trn-grid" jsp="transaction/transaction_grid.jsp" params="<%=params%>"/>
</div>

