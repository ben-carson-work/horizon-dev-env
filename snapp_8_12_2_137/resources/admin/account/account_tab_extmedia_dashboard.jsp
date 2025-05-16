<%@page import="com.vgs.web.tag.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>

<div class="tab-content">
  <v:last-error/>
  <% String params = "AccountId=" + pageBase.getId(); %>
  <v:async-grid id="extmediagroup_grid" jsp="account/account_extmediagroup_grid.jsp" params="<%=params%>"/>
</div>