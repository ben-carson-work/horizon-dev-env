<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_IndividualCoupon.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%

QueryDef qdef = new QueryDef(QryBO_IndividualCoupon.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.IndividualCouponId);
qdef.addSelect(Sel.IndividualCouponCode);
qdef.addSelect(Sel.IndividualCouponStatus);
qdef.addSelect(Sel.IndividualCouponStatusDesc);
qdef.addSelect(Sel.CommonStatus);
qdef.addSelect(Sel.ProductId);
qdef.addSelect(Sel.ProductName);
qdef.addSelect(Sel.ProductCode);
qdef.addSelect(Sel.IssueTransactionId);
qdef.addSelect(Sel.IssueFiscalDate);
qdef.addSelect(Sel.IssueDateTime);
qdef.addSelect(Sel.IssueTransactionCode);
qdef.addSelect(Sel.SettleTransactionId);
qdef.addSelect(Sel.SettleTransactionCode);
qdef.addSelect(Sel.ValidDateFrom);
qdef.addSelect(Sel.ValidDateTo);
qdef.addSelect(Sel.CampaignCode);
qdef.addSelect(Sel.AccountId);
qdef.addSelect(Sel.AccountName);
qdef.addSelect(Sel.MembershipPlanProductId);
qdef.addSelect(Sel.MembershipPlanProductName);
// Where
if (pageBase.getNullParameter("SaleId") != null)
  qdef.addFilter(Fil.SaleId, pageBase.getNullParameter("SaleId"));
if (pageBase.getNullParameter("TransactionId") != null)
  qdef.addFilter(Fil.TransactionId, pageBase.getNullParameter("TransactionId"));
if (pageBase.getNullParameter("ProductId") != null)
  qdef.addFilter(Fil.ProductId, pageBase.getNullParameter("ProductId"));
if (pageBase.getNullParameter("CouponCode") != null)
  qdef.addFilter(Fil.IndividualCouponCode, pageBase.getNullParameter("CouponCode"));
if (pageBase.getNullParameter("FromDate") != null)
  qdef.addFilter(Fil.FromFiscalDate, pageBase.getParameter("FromDate"));
if (pageBase.getNullParameter("ToDate") != null)
  qdef.addFilter(Fil.ToFiscalDate, pageBase.getParameter("ToDate"));
if (pageBase.getNullParameter("LocationId") != null)
  qdef.addFilter(Fil.LocationId, pageBase.getNullParameter("LocationId"));
if (pageBase.getNullParameter("CouponStatus") != null)
  qdef.addFilter(Fil.IndividualCouponStatus, pageBase.getNullParameter("CouponStatus"));
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
//Sort
qdef.addSort(Sel.IssueDateTime, false);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid id="ind-coupon-grid-table" dataset="<%=ds%>" qdef="<%=qdef%>">
  <tr class="header">
    <td><v:grid-checkbox header="true" multipage="true"/></td>
    <td>&nbsp;</td>
    <td width="15%">
      <v:itl key="@Common.Code"/><br/>
      <v:itl key="@Common.Status"/>
    </td>
    <td width="20%">
      <v:itl key="@Coupon.IssueTransaction"/><br/>
      <v:itl key="@Coupon.SettleTransaction"/>
    </td>
    <td width="20%">
      <v:itl key="@Product.PromoRule"/> 
    </td>
    <td width="10%">
      <v:itl key="@Common.ValidFrom"/><br/>
      <v:itl key="@Common.ValidTo"/> 
    </td>
    <td width="25%">
      <v:itl key="@Coupon.IssuedBy"/><br/>
      <v:itl key="@Coupon.CampaignCode"/> 
    </td>
    <td width="10%">
      <v:itl key="@Product.MembershipPlan"/> 
    </td>

  </tr>
  <v:grid-row dataset="ds" dateGroupFieldName="<%=Sel.IssueFiscalDate.name()%>">
    <% LookupItem couponStatus = LkSN.IndividualCouponStatus.getItemByCode(ds.getField(Sel.IndividualCouponStatus)); %>
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>">
      <v:grid-checkbox name="IndividualCouponId" dataset="ds" fieldname="IndividualCouponId"/>
    </td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.IndividualCouponId)%>" entityType="<%=LkSNEntityType.IndividualCoupon%>" clazz="list-title">
        <%= ds.getField(Sel.IndividualCouponCode).getHtmlString() %>
      </snp:entity-link>
      <br/>
      <span class="list-subtitle"><%= ds.getField(Sel.IndividualCouponStatusDesc).getHtmlString() %></span>
    </td>
    <td>
      <% if (!ds.getField(Sel.IssueTransactionId).isNull()) { %>
        <snp:entity-link entityId="<%=ds.getField(Sel.IssueTransactionId).getString()%>" entityType="<%=LkSNEntityType.Transaction%>">
        <%=ds.getField(Sel.IssueTransactionCode).getHtmlString()%>
        </snp:entity-link>
      <% } %><br/>
      <span class="list-subtitle">
      <% if (!ds.getField(Sel.SettleTransactionId).isNull()) { %>
        <snp:entity-link entityId="<%=ds.getField(Sel.SettleTransactionId).getString()%>" entityType="<%=LkSNEntityType.Transaction%>">
        <%=ds.getField(Sel.SettleTransactionCode).getHtmlString()%>
        </snp:entity-link>
      <% } else { %>
        <v:itl key="@Common.Unsettled"/>
      <% } %>
      </span>
    </td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.ProductId).getString()%>" entityType="<%=LkSNEntityType.PromoRule.getCode()%>"><%=ds.getField(Sel.ProductName).getHtmlString()%></snp:entity-link><br/>
      <span class="list-subtitle"><%=ds.getField(Sel.ProductCode).getHtmlString()%></span>
    </td>
    <td>
      <span class="list-subtitle"><%=ds.getField(Sel.ValidDateFrom).isNull() ? "&mdash;" : pageBase.format(ds.getField(Sel.ValidDateFrom), pageBase.getShortDateFormat())%></span><br/>
      <span class="list-subtitle"><%=ds.getField(Sel.ValidDateTo).isNull() ? "&mdash;" : pageBase.format(ds.getField(Sel.ValidDateTo), pageBase.getShortDateFormat())%></span>
    </td>
    <td>
      <% if (ds.getField(Sel.AccountId).isNull()) { %>
        &mdash;
      <% } else { %>
        <snp:entity-link entityId="<%=ds.getField(Sel.AccountId).getString()%>" entityType="<%=LkSNEntityType.Organization%>"><%=ds.getField(Sel.AccountName).getHtmlString()%></snp:entity-link>
      <% }%>
      <br/>
      <span class="list-subtitle"><%=ds.getField(Sel.CampaignCode).isNull() ? "&mdash;" : ds.getField(Sel.CampaignCode).getHtmlString()%></span>
    </td>
    <td>
    <% if (ds.getField(Sel.MembershipPlanProductId).isNull()) { %>
        &mdash;
      <% } else { %>
        <snp:entity-link entityId="<%=ds.getField(Sel.MembershipPlanProductId).getString()%>" entityType="<%=LkSNEntityType.ProductType.getCode()%>"><%=ds.getField(Sel.MembershipPlanProductName).getHtmlString()%></snp:entity-link>
      <% }%>
    </td>
  </v:grid-row>
</v:grid>