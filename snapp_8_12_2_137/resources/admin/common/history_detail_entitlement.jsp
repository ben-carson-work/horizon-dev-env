<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageHistoryDetailEntitlement" scope="request"/>
<jsp:include page="/resources/common/header-head.jsp"/>

<%
  String historyLogDetailId = pageBase.getParameter("historylog_detail_id");
  String oldValue = pageBase.getParameter("old_value");
  DOEntitlement entitlement = (oldValue == null) || (historyLogDetailId == null) ? new DOEntitlement() : pageBase.getBL(BLBO_HistoryLog.class).findHistoryDetailEntitlement(historyLogDetailId, oldValue.equalsIgnoreCase("true"));
%>

<v:page-form id="history-detail-entitlement-form">

<div class="tab-content">
  <% request.setAttribute("entitlement-widget-caption", null); %>
  <% request.setAttribute("entitlement-readonly", "true"); %>
  <% request.setAttribute("entitlement", entitlement);%>
  <jsp:include page="/resources/admin/entitlement/entitlement_widget.jsp"/>
</div>
                                                                                                                                                                                                                     
</v:page-form>                                                     



