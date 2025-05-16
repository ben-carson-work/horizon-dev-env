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

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.b2b.page.PageB2B_Invoice" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="invoice" class="com.vgs.snapp.dataobject.DOInvoice" scope="request"/>

<jsp:include page="../../common/header.jsp"/>

<v:page-title-box/>

<div id="main-container">
  <v:tab-group name="tab" main="true">
    <%-- PROFILE --%>
    <v:tab-item caption="@Common.Recap" icon="profile.png" jsp="invoice_tab_main.jsp" tab="main" default="true"/>
  </v:tab-group>
</div>

<jsp:include page="../../common/footer.jsp"/>
