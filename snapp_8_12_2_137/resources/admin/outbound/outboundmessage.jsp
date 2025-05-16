<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageOutboundMessage" scope="request" />

<jsp:include page="/resources/common/header.jsp" />

<v:page-title-box />

<v:tab-group name="tab" main="true">
  <v:tab-item caption="Schema" fa="code" jsp="outboundmessage_tab_main.jsp" tab="main" default="true"/>
</v:tab-group>


<jsp:include page="/resources/common/footer.jsp" />
