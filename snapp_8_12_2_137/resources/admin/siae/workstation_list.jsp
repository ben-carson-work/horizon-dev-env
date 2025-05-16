<%@page import="com.vgs.web.library.BLBO_Siae"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSiaeWorkstationList" scope="request"/>
<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>
<%
BLBO_Siae bl = pageBase.getBLDef();
%>

<div class="mainlist-container">
  <jsp:include page="/resources/admin/siae/siae_alert.jsp" />
  <div class="form-toolbar">
  <v:pagebox gridId="workstation-grid"/>
  </div>
  
  <div>
    <v:last-error/>
    <v:async-grid id="workstation-grid" jsp="siae/workstation_grid.jsp" />
  </div>
</div>
<script>
</script>
<jsp:include page="/resources/common/footer.jsp"/>