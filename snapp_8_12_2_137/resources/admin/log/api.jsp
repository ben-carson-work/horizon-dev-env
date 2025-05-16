<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageApi" scope="request" />

<jsp:include page="/resources/common/header.jsp" />

<v:page-title-box />

<div id="main-container">
  <v:tab-group name="tab" main="true">
    
    <%-- GENERAL --%>
    <v:tab-item caption="@Common.General" icon="profile.png" jsp="api_tab_general.jsp" tab="main" default="true"/>
    
    <%-- REQUEST --%>
    <v:tab-item caption="@Upload.RequestMessage" icon="xml.png" tab="request" jsp="api_tab_request.jsp" />
    
    <%-- ANSWER --%>
    <v:tab-item caption="@Upload.AnswerMessage" icon="xml.png" tab="answer" jsp="api_tab_answer.jsp" />
        
  </v:tab-group>
</div>

<jsp:include page="/resources/common/footer.jsp" />