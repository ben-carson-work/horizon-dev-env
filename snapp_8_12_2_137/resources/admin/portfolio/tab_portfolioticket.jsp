<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>

<div class="tab-toolbar">
  <v:button id="btn-ticket-prioritize" caption="@Ticket.Prioritize" fa="sort-numeric-up"/>
  <v:button id="btn-hide-inactive" clazz="hidden" caption="@Ticket.HideInactiveTickets" fa="eye-slash"/>
  
  <v:pagebox gridId="ticket-grid"/>
</div>

<div class="tab-content">
  <% String params = "PortfolioId=" + pageBase.getEmptyParameter("PortfolioId"); %>
  <v:async-grid id="ticket-grid" jsp="portfolio/ticket_grid.jsp" params="<%=params%>"/>
</div>

<script>
$(document).ready(function() {
  var prioritizeMode = false;
  var hideInactive = false;
  
  var $btnPrioritize = $("#btn-ticket-prioritize");
  var $btnHide = $("#btn-hide-inactive");
  
  $btnPrioritize.click(function() {
    prioritizeMode = !prioritizeMode;
    $btnHide.setClass("hidden", !prioritizeMode);
    
    setGridUrlParam("#ticket-grid", "PrioritizeMode", prioritizeMode);
    changeGridPage("#ticket-grid", "first");
  });
  
  $btnHide.click(function() {
    hideInactive = !hideInactive;
    $btnHide.setClass("active", hideInactive);
    
    $("#ticket-grid td[data-ticketactive='false']").parents("tr").setClass("hidden", hideInactive);
  });
});
</script>

