<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSiaeConfig" scope="request"/>
<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>
<%
BLBO_Siae bl = pageBase.getBLDef();
%>

<div class="mainlist-container">
  <jsp:include page="/resources/admin/siae/siae_alert.jsp" />
  <v:tab-group name="tab">
    <v:tab-item caption="@Common.Settings" icon="<%=JvImageCache.ICON_SETTINGS%>" tab="Settings" jsp="config_tab_main.jsp" default="true" />
  </v:tab-group>
</div>
<jsp:include page="/resources/common/footer.jsp"/>