<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="java.util.List"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_SaleItem.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTooltip" scope="request"/>

<%
String ticketId = pageBase.getNullParameter("TicketId");
String performanceId = pageBase.getNullParameter("PerformanceId");

DOTicketRef.DOTicketPerformanceRef ticketPerf = JvUtils.findFirst(pageBase.getBL(BLBO_Ticket.class).getTicketPerformanceList(ticketId), x -> x.Performance.PerformanceId.isSameString(performanceId));
DOPerformanceRef perf = ticketPerf.Performance;

%>

<style>
.list-item-icon {width:32px; margin-left:10px; text-align:center}
</style>


<div class="entity-tooltip-baloon">
  <div class="tooltip-title"><i class="fa fa-calendar"></i> <%=JvString.escapeHtml(pageBase.format(perf.DateTimeFrom.getDateTime(), pageBase.getShortDateTimeFormat()))%></div>

  <v:recap-item caption="@Event.Event"><i class="fa fa-masks-theater"></i> <%=ticketPerf.Performance.EventName.getHtmlString()%></v:recap-item>
  <v:recap-item caption="@Account.Location"><i class="fa fa-map-marker"></i> <%=perf.LocationName.getHtmlString()%></v:recap-item>
  
  <% if (!ticketPerf.SeatId.isNull()) { %>
    <div>&nbsp;</div>
    <div class="tooltip-title"><i class="fa fa-loveseat"></i> <v:itl key="@Seat.LimitedCapacity"/></div>
    
    <v:recap-item caption="@Seat.Category"><%=ticketPerf.SeatCategoryName.getHtmlString()%></v:recap-item>
    <v:recap-item caption="@Seat.Sector"><%=ticketPerf.SeatSectorName.getHtmlString()%></v:recap-item>
    
    <% if (!ticketPerf.SeatRow.isNull()) { %>
      <v:recap-item caption="@Seat.Row"><%=ticketPerf.SeatRow.getHtmlString()%></v:recap-item>
    <% } %>
    
    <% if (!ticketPerf.SeatCol.isNull()) { %>
      <v:recap-item caption="@Seat.Col"><%=ticketPerf.SeatCol.getHtmlString()%></v:recap-item>
    <% } %>
  <% } %>
  
  <% if (!ticketPerf.Exception.isEmpty()) { %>
    <div>&nbsp;</div>
    <div class="tooltip-title"><i class="fa fa-exclamation-circle"></i> <v:itl key="@Performance.Exceptions"/></div>
    
    <% if (!ticketPerf.Exception.TimeFrom.isNull()) { %>
      <v:recap-item caption="@Common.FromTime"><%=JvString.escapeHtml(pageBase.format(ticketPerf.Exception.TimeFrom.getDateTime(), pageBase.getShortTimeFormat()))%></v:recap-item>
    <% } %>
  <% } %>
  
</div>