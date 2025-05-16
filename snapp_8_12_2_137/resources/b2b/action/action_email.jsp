<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.b2b.page.PageB2B_Action" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<v:tab-group name="tab" main="true">
  <%-- PROFILE --%>
  <v:tab-item caption="@Common.Recap" icon="profile.png" jsp="action_email_tab_main.jsp" tab="main" default="true"/>
</v:tab-group>

<jsp:include page="/resources/common/footer.jsp"/>
