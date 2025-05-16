<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTransaction" scope="request"/>

<div class="tab-toolbar">
  <v:pagebox gridId="portfolioslotlog-grid"/>
</div>

<div class="tab-content">
  <% String portfolioSlotLogParams = "EntityId=" + pageBase.getId() + "&WalletOnly=true" + "&IncludeSubEntity=true"; %>
  <v:async-grid jsp="portfolio/portfolioslotlog_grid.jsp" id="portfolioslotlog-grid" params="<%=portfolioSlotLogParams%>"></v:async-grid>
</div>
