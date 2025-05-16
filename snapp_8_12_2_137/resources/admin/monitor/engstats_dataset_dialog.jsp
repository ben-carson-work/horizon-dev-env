<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
List<JvDBDataSet> list = JvDBDataSet.getActiveDataSetList();
%>

<v:dialog id="engstats_dataset_dialog" title="Active datasets" width="800" height="600">

<div style="margin-bottom:10px">Active count: <strong><%=list.size()%></strong></div>

<% for (int i=0; i<Math.min(50, list.size()); i++) { %>
 <snp:datetime timezone="local" timestamp="<%=list.get(i).getCreateDateTime()%>" format="longdatetime"/>
 <pre><%=JvString.escapeHtml(list.get(i).getStackTrace())%></pre>
<% } %>

</v:dialog>