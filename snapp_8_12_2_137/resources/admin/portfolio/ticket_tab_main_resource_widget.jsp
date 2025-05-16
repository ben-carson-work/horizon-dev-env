<%@page import="com.vgs.snapp.web.search.*"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.web.servlet.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTicket" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="ticket" class="com.vgs.snapp.dataobject.DOTicket" scope="request"/>

<% if (!ticket.ResourceList.isEmpty() || !ticket.ResourcePerformanceId.isNull()) { %>
  <v:widget caption="@Resource.Resources">
    <% if (!ticket.ResourcePerformanceId.isNull()) { %>
      <v:widget-block>
        <i class="fa fa-calendar"></i>
        <snp:entity-link entityId="<%=ticket.ResourcePerformanceEventId%>" entityType="<%=LkSNEntityType.Event%>"><%=ticket.ResourcePerformanceEventName.getHtmlString()%></snp:entity-link>
        &raquo;
        <snp:entity-link entityId="<%=ticket.ResourcePerformanceId%>" entityType="<%=LkSNEntityType.Performance%>"><snp:datetime timestamp="<%=ticket.ResourcePerformanceDateTimeFrom%>" timezone="location" convert="false" format="shortdatetime"/> </snp:entity-link>
      </v:widget-block>
    <% } %>
    
    <% request.setAttribute("ResourceList", ticket.ResourceList.getItems()); %>
    <jsp:include page="../resource/resource_list_widget.jsp">
      <jsp:param name="ParentEntityType" value="<%=LkSNEntityType.Ticket.getCode()%>" />    
    </jsp:include>
      
  </v:widget>
<% } %>
