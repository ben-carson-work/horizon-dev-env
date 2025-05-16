<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>

<div class="tab-toolbar">
  <v:pagebox gridId="action-grid"/>
</div>

<div class="tab-content">
  <v:last-error/>

  <% String params = "LinkEntityId=" + pageBase.getId(); %>
  <v:async-grid id="action-grid" jsp="action/action_grid.jsp" params="<%=params%>"/>
</div>
