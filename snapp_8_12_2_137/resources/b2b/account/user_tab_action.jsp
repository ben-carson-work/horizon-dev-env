<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.b2b.page.PageB2B_User" scope="request"/>

<div class="tab-toolbar">
  <v:pagebox gridId="action-grid"/>
</div>

<div class="tab-content">
  <v:last-error/>

  <% String params = "LinkEntityId=" + pageBase.getId(); %>
  <v:async-grid id="action-grid" jsp="action/action_grid.jsp" params="<%=params%>"/>
</div>

