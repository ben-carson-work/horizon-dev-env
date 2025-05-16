<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");

String dateFromDefault = pageBase.getFiscalDate().getXMLDate();
String dateToDefault = pageBase.getFiscalDate().getXMLDate();
pageBase.setDefaultParameter("DateFrom", dateFromDefault);
pageBase.setDefaultParameter("DateTo", dateToDefault);

String[] graphs = JvArray.stringToArray(JvUtils.getServletParameter(request, "amchart-graphs"), ",");
%>

<script src="<v:config key="site_url"/>/libraries/amcharts/amcharts.js"></script>
<% for (String graph : graphs) { %>
  <script src="<v:config key="site_url"/>/libraries/amcharts/<%=graph%>.js"></script>
<% } %>
<script src="<v:config key="site_url"/>/libraries/amcharts/plugins/export/export.min.js"></script>
<link rel="stylesheet" href="<v:config key="site_url"/>/libraries/amcharts/plugins/export/export.css" type="text/css" media="all" />
<script src="<v:config key="site_url"/>/libraries/amcharts/themes/light.js"></script>

<script>var graphLang = "en";</script>
<% if (!rights.LangISO.isNull() && !rights.LangISO.isSameString("en")) { %>
  <script src="<v:config key="site_url"/>/libraries/amcharts/lang/<%=rights.LangISO.getEmptyString().toLowerCase()%>.js"></script>
  <script>graphLang = <%=JvString.jsString(rights.LangISO.getEmptyString().toLowerCase())%>;</script>
<% } %>

<jsp:include page="../admin/stats/stats_all_css.jsp" />
<jsp:include page="../admin/stats/stats_all_js.jsp" />
