<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:include page="event-css.jsp" />
<jsp:include page="event-js.jsp" />

<div id="EventContent">
  <div style="display: flex; margin-bottom: 20px; align-items: center;">
    <div id="eventImage" class="col-md-2 col-xs-2"></div>
    <div id="eventTitle" class="col-md-8 col-xs-8"></div>
    <div id="calendar" class="col-md-2 col-xs-2 text-right"><input type="hidden" id="datepicker" /></div>
  </div>
  <div id="dateChoosen" style="background-color:#fff; padding:10px; font-weight:bold;">
  </div>
  
  <div id="PerformancesContainer" class="" style="background-color:#fff;"></div>
  <div id="ProductContainer" class="scrolling">
      <div id="performanceCapacity" class="row capacitycategorycontainer"></div>
      <div id="productList"></div>
  </div>
 
  <input type="hidden" id="eventId" />
  <input type="hidden" id="PagePos" />
  <input type="hidden" id="SellableDateTimeFrom" />
</div>
