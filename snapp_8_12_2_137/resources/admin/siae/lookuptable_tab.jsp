<%@page import="com.vgs.web.library.BLBO_Siae"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSiaeLookupTables" scope="request"/>

<% 
BLBO_Siae bl = pageBase.getBLDef();
String id = pageBase.getEmptyParameter("LookupTableId");
String tab = pageBase.getEmptyParameter("tab");
if (id.isEmpty()) {
  id = "1";
}
if (tab.isEmpty()) {
  tab = "eventTypes";
}
%>

<div class="tab-toolbar">
  <v:pagebox gridId="lookupitem-grid"/>
</div>

<div class="tab-content">
  <v:last-error/>
  <% String params = "lookuptableid=" + id; %>
  <v:async-grid id="lookupitem-grid" jsp="siae/lookupitem_grid.jsp" params="<%=params%>"/>
</div>
