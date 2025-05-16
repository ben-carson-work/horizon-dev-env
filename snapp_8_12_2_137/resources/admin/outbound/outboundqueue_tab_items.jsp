<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>

<div class="tab-toolbar">
  <v:pagebox gridId="log-grid"/>
</div>

<div class="tab-content">

  <% String params = "OutboundQueueId=" + JvString.escapeHtml(pageBase.getId()); %>
  <v:async-grid id="log-grid" jsp="outbound/outboundqueueitem_grid.jsp" params="<%=params%>"/>
    
</div>