<%@page import="com.vgs.vcl.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="perf" class="com.vgs.snapp.dataobject.DOPerformance" scope="request"/>

<div class="tab-toolbar">
  <v:button caption="@Common.Search" fa="search" href="javascript:doSearch()"/>
  <v:db-checkbox caption="@Common.InPark" value="true" field="InsideOnly" checked="true"/>
  
  <v:pagebox gridId="portfolio-inside-grid"/>
</div>

<div class="tab-content">
  <% String params = "PerformanceId=" + perf.PerformanceId.getString() + "&InsideOnly=true"; %>
  <v:async-grid id="portfolio-inside-grid" jsp="portfolio/portfolio_in_perf_grid.jsp" params="<%=params%>" />   
</div>

<script>
function doSearch() {
  setGridUrlParam("#portfolio-inside-grid", "InsideOnly", $("#InsideOnly").isChecked(), true);
}

$("#InsideOnly").click(doSearch);
</script>