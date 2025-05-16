<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTicket" scope="request"/>
<jsp:useBean id="ticket" class="com.vgs.snapp.dataobject.DOTicket" scope="request"/>

<%
String mainSaleItemId = pageBase.getBL(BLBO_Ticket.class).getSaleItemId(pageBase.getId());
%>

<div class="tab-toolbar">
  <v:pagebox gridId="ticket-grid"/>
</div>

<div class="tab-content">
  <v:last-error/>
  <% String params = "PackageTicketId=" + ticket.TicketId.getString(); %>
  <v:async-grid id="ticket-grid" jsp="portfolio/ticket_grid.jsp" params="<%=params%>"/>
</div>

