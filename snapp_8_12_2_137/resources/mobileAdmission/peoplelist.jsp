<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:include page="peoplelist-css.jsp" />
<jsp:include page="peoplelist-js.jsp" />

<div id="peoplelist"  class="status-select">
	<%-- HEADER --%>
	<div class="toolbar">
		<div id="adm-title" class="title wrap">People Entered</div>
		<%-- Back BUTTON --%>
		<!-- <div class="back-btn img-undo button v-click">
			<div class="caption">Back</div>
		</div>
		
		<%-- test BUTTON 
			<div id="adm-test-btn" class="adm-test-btn button v-click enabled" >
			  <div class="caption">Sim. Read</div>
			</div> --%>
		<%-- TckNote BUTTON --%>
		<div class="manual-input-btn img-keyboard button v-click enabled">
			<div class="caption">Input</div>
		</div>-->
		<div class="access-point-name">
			No access point
		</div>
	</div>
	<%-- BODY --%>
	<div class="body">
		<div class="infobar">
			People
		</div>
		<div class="actionbar">
			<div id="closeperf-btn" class="actionbar-btn ftright img-close button">Close</div>
		</div>
		<div class="wrap srolling">
			<div class="body-panel scrolling">
				<ul class="ios-list" id="ULpeoplelist">
				  </ul>
			</div>
		</div>
	</div>
	<div id="alertmsgbg" style="display:none;">
		<div id="alertmsg">
			<div id="alertmsgHeader">Close Performance?</div>
			<div id="alertmsgBody">
				<div id="alertmsgBtnCancel" class="alertmsgBtn">Cancel</div>
				<div id="alertmsgBtnYes"class="alertmsgBtn">OK</div>
			</div>
		</div>
	</div>
	
</div>
