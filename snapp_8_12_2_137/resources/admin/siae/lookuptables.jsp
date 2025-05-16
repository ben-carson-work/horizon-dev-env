<%@page import="com.vgs.web.library.BLBO_Siae"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSiaeLookupTables" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
BLBO_Siae bl = pageBase.getBLDef();
%>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<div id="main-container">
<div class="tab-toolbar">
  <jsp:include page="/resources/admin/siae/siae_alert.jsp" />
 </div> 
  
 <v:tab-group name="tab" main="true">
    <v:tab-item caption="Tipo evento" tab="eventTypes" jsp="lookuptable_tab.jsp" params="lookuptableid=1" default="true" />
    <v:tab-item caption="Ordini di posto" tab="placeOrders" jsp="lookuptable_tab.jsp" params="lookuptableid=2" />
    <v:tab-item caption="Tipo titolo" tab="titleType" jsp="lookuptable_tab.jsp" params="lookuptableid=3" />
    <!-- v:tab-item caption="Altri proventi" tab="otherIncome" jsp="lookuptable_tab.jsp" params="lookuptableid=4" / -->
    <v:tab-item caption="Identificativo supporto" tab="supportId" jsp="lookuptable_tab.jsp" params="lookuptableid=5" />
    <v:tab-item caption="Stato del titolo" tab="stateTitle" jsp="lookuptable_tab.jsp" params="lookuptableid=6" />
    <v:tab-item caption="Spettacolo / Intrattenimento" tab="entartainment" jsp="lookuptable_tab.jsp" params="lookuptableid=7" />
    <v:tab-item caption="Causale annullamento" tab="voidReason" jsp="lookuptable_tab.jsp" params="lookuptableid=8" />
  </v:tab-group>
</div>

