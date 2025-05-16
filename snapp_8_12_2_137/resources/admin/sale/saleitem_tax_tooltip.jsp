<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_LedgerRef.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTooltip" scope="request"/>

<% JvDataSet ds = pageBase.getBL(BLBO_Tax.class).getSaleItemTaxDS(pageBase.getNullParameter("SaleItemId")); %>

<style>

.tax-ref-grid {
  width: 100%;
  border-collapse: collapse;
}

.tax-ref-grid td {
  padding: 3px;
}

.tax-ref-items td {
  border-bottom: 1px #efefef solid;
  font-weight: bold;
}

.tax-ref-items tr:last-child td {
  border-bottom: none;
}

.tax-ref-footer td {
  border-top: 1px #aaaaaa solid;
}

</style>

<div style="min-width:270px; max-height:200px; overflow-y:auto">

<div class="tooltip-title"><v:itl key="@Product.Taxes"/></div>

<table class="tax-ref-grid">
  <tbody class="tax-ref-items">
  <v:ds-loop dataset="<%=ds%>">
    <tr>
      <td nowrap><snp:entity-link entityId="<%=ds.getField(\"TaxId\").getString()%>" entityType="<%=LkSNEntityType.Tax%>"><%=ds.getField("TaxName").getHtmlString()%></snp:entity-link></td>
      <td nowrap align="right"><%=pageBase.formatCurrHtml(ds.getField("TaxAmount"))%></td>
    </tr>
  </v:ds-loop>
  </tbody>
</table>

</div>