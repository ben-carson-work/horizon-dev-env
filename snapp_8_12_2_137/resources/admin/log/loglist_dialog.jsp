<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.vcl.*"%>
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

<v:dialog id="loglist_dialog" title="@Common.Log" width="900" height="700" autofocus="false">

	<div class="form-toolbar" style="overflow:hidden">
	  <v:pagebox gridId="log-grid"/>
	</div>
	
	<% String params = "EntityId=" + pageBase.getEmptyParameter("EntityId"); %>
	<v:async-grid id="log-grid" jsp="log/log_grid.jsp" params="<%=params%>"/>

</v:dialog>


