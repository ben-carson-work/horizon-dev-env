<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:include page="accesspointlist-css.jsp" />
<jsp:include page="accesspointlist-js.jsp" />
<div id="accesspointlist"  class="status-select">
	<%-- HEADER --%>
	<div class="toolbar">
		
		<div id="adm-title" class="title wrap">Access Point List</div>
		<div id="accesspointlistback-btn" class="toolbar-btn ftleft img-back button hidden">Back</div>
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
	<div class="body ">
		<div class="infobar">
			Select an access point
		</div>
		<div class="wrap srolling">
			<div class="body-panel scrolling">
				<ul class="ios-list" id="ULaccesspoinlist">
     		  </ul>
			</div>
		</div>
	</div>
</div>
<script>


</script>
