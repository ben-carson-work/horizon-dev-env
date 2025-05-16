<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_TransactionItem.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTooltip" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_TransactionItem.class);
// select
qdef.addSelect(Sel.MainSaleItemId);
qdef.addSelect(Sel.ProductId);
qdef.addSelect(Sel.ProductName);
qdef.addSelect(Sel.Quantity);
qdef.addSelect(Sel.QtyPaid);
qdef.addSelect(Sel.StatAmount);
// Filter
qdef.addFilter(Fil.TransactionId, pageBase.getNullParameter("TransactionId"));
qdef.addFilter(Fil.StatSaleItemId, pageBase.getNullParameter("SaleItemId"));
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
%>

<style>

.tax-ref-grid {
  width: 100%;
  border-collapse: collapse;
}

.tax-ref-grid td {
  padding: 3px;
}

.tax-ref-items td {
  border-top: 1px #efefef solid;
  font-weight: bold;
}

.tax-ref-footer td {
  border-top: 1px #aaaaaa solid;
}

</style>

<div style="min-width:400px; max-height:200px; overflow-y:auto">

<div class="tooltip-title"><v:itl key="@Sale.StatBreakdown"/></div>

<table class="tax-ref-grid">
  <thead>
    <tr>
      <td><v:itl key="@Product.ProductType"/></td>
      <td nowrap align="right"><v:itl key="@Common.Quantity"/></td>
      <td nowrap align="right"><v:itl key="@Reservation.Flag_Paid"/></td>
      <td nowrap align="right"><v:itl key="@Reservation.UnitAmount"/></td>
    </tr>
  </thead>
  <tbody class="tax-ref-items">
  <v:ds-loop dataset="<%=ds%>">
    <tr>
      <td nowrap><snp:entity-link entityId="<%=ds.getField(Sel.ProductId).getString()%>" entityType="<%=LkSNEntityType.ProductType%>"><%=ds.getField(Sel.ProductName).getHtmlString()%></snp:entity-link></td>
      <td nowrap align="right"><%=ds.getField(Sel.Quantity).getInt()%></td>
      <td nowrap align="right"><%=ds.getField(Sel.QtyPaid).getInt()%></td>
      <td nowrap align="right"><%=pageBase.formatCurrHtml(ds.getField(Sel.StatAmount))%></td>
    </tr>
  </v:ds-loop>
  </tbody>
</table>

</div>