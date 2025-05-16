<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTransaction" scope="request"/>
<jsp:useBean id="transaction" class="com.vgs.snapp.dataobject.transaction.DOTransaction" scope="request"/>

<div class="tab-toolbar">
  <% String onclickCreate = "asyncDialogEasy('sale/create_order_confirmation_dialog', 'SaleId=" + transaction.SaleId.getHtmlString() + "&FilterTransactionId=" + JvString.escapeHtml(pageBase.getId()) + "')"; %>
  <v:button caption="@Common.Create" fa="envelope" onclick="<%=onclickCreate%>"/>
  <v:pagebox gridId="action-grid"/>
</div>

<div class="tab-content">
  <% String params = "LinkEntityId=" + pageBase.getId(); %>
  <v:async-grid id="action-grid" jsp="action/action_grid.jsp" params="<%=params%>"/>
</div>
