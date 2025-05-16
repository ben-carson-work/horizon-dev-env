<%@page import="com.vgs.web.tag.ConfigTag"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTransaction" scope="request"/>
<jsp:useBean id="transaction" class="com.vgs.snapp.dataobject.transaction.DOTransaction" scope="request"/>

<jsp:include page="/resources/admin/product/coupon/individual_coupon_js.jsp"/>

<%
QueryDef qdef = new QueryDef(QryBO_Transaction.class);
//Select
qdef.addSelect(QryBO_Transaction.Sel.TransactionType);
//Where
qdef.addFilter(QryBO_Transaction.Fil.TransactionId, pageBase.getId());
//Exec
JvDataSet transactionDS = pageBase.execQuery(qdef);
request.setAttribute("transactionDS", transactionDS);
%>

<div id="expdate-dialog" class="v-hidden" title="<v:itl key="@Coupon.IndividualCouponChangeExpDate"/>">
  <v:input-text type="datepicker" field="NewExpDatePicker" style="width:105px"/>
</div>

<div class="tab-toolbar">
  <v:pagebox gridId="coupon-grid"/>
  <% String hrefDownaload = "javascript:window.open('" + ConfigTag.getValue("site_url") + "/admin?page=individual_coupon_list&action=csv-download&TransactionId=" + pageBase.getId() + "&SaleCode=" + transaction.SaleCode.getHtmlString() + "')";%>  
  <v:button caption="@Common.Export" fa="sign-out" href="<%=hrefDownaload%>"/>
  <% if (LkSNTransactionType.IndividualCouponIssue.isLookup(transactionDS.getField(QryBO_Transaction.Sel.TransactionType).getInt())) { %>  
    <div class="btn-group">
      <v:button id="action-btn" caption="@Common.Actions" fa="flag" dropdown="true"/>
      <v:popup-menu bootstrap="true">
        <v:popup-item id="blockStatus-btn" caption="@Common.Block"/>
        <v:popup-item id="unblockStatus-btn" caption="@Common.Unblock"/>
        <v:popup-item id="voidStatus-btn" caption="@Common.Void"/>
        <v:popup-item id="expdate-btn" caption="@Account.Credit.ExptDate"/>
      </v:popup-menu>
    </div>
  <% } %>
</div>

<div class="tab-content">
  <v:last-error/>

  <% String params = "TransactionId=" + pageBase.getId(); %>
  <v:async-grid id="coupon-grid" jsp="product/coupon/individual_coupon_grid.jsp" params="<%=params%>"/>
</div>