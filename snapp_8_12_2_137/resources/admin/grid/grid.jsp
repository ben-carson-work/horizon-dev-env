<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageGrid" scope="request"/>
<jsp:useBean id="grid" class="com.vgs.snapp.dataobject.DOGrid" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<v:page-form id="grid-form">
	<div id="main-container"> 
	  <v:tab-group name="tab" main="true">
	    <%-- PROFILE --%>
	    <v:tab-item caption="@Common.Profile" icon="profile.png" jsp="grid_tab_main.jsp" tab="main" default="true"/>
	  </v:tab-group>
	</div>
</v:page-form>

<jsp:include page="/resources/common/footer.jsp"/>
