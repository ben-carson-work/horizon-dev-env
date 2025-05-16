<%@page import="com.vgs.vcl.fontawesome.JvFA"%>
<%@page import="com.vgs.snapp.lookup.LkSNRightLevel"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" scope="request" class="com.vgs.web.page.PageAccount"/>
<jsp:useBean id="rights" scope="request" class="com.vgs.snapp.dataobject.DORightRoot"/>
<jsp:useBean id="account" scope="request" class="com.vgs.snapp.dataobject.DOAccount"/>

<%
boolean canReadFinance = rights.CreditLine.canRead();
boolean canReadSales = rights.SalesTerms.canRead();
boolean canRead = canReadFinance && canReadSales;
boolean canSearchInvoices = rights.InvoiceSearch.getBoolean();
%>

<v:tab-content>
  <v:alert-box type="warning" include="<%=!canRead%>">
    <strong><v:itl key="@Common.Warning"/></strong>
    <br/>&nbsp;<br/>
    <v:itl key="@Common.PermissionDenied"/>
  </v:alert-box>

  <v:tab-group name="tab_finance" include="<%=canRead%>">
    <v:tab-item caption="@Common.Recap" icon="coins.png" tab="recap" default="true" jsp="account_tab_finance_recap.jsp" />
    <v:tab-item caption="@Account.Credit.Credit" icon="credit.png" tab="credit" jsp="account_tab_finance_credit.jsp" include="<%=canReadFinance%>"/>
    <v:tab-item caption="@Account.Credit.DepositLog" icon="calendar.png" tab="depositlog" jsp="account_tab_finance_depositlog.jsp" include="<%=canReadFinance%>"/>
    <v:tab-item caption="@Account.Credit.OpenOrderLogs" icon="calendar.png" tab="openorderlog" jsp="account_tab_finance_openorderlog.jsp" include="<%=canReadFinance%>"/>
    <v:tab-item caption="@Common.Vouchers" icon="voucher.png" tab="voucher" jsp="account_tab_finance_voucher.jsp"/>
    <v:tab-item caption="@Commission.Commissions" icon="fee.png" tab="commission" jsp="account_tab_finance_commission.jsp" include="<%=account.CommissionCount.getInt() > 0%>"/>
    <v:tab-item caption="@Common.Inventory" fa="cubes" tab="prod_inventory" jsp="account_tab_finance_inventory_product.jsp" include="<%=account.InventoryCount.getInt() > 0%>"/>
  
    <% String jsp_invoice = pageBase.getContextURI() + "?page=invoice_list&widget=true&AccountId=" + pageBase.getId(); %>
    <v:tab-item caption="@Invoice.Invoices" icon="invoice.png" tab="invoice" jsp="<%=jsp_invoice%>" include="<%=canSearchInvoices && (account.InvoiceCount.getInt() > 0)%>"/>
    
    <v:tab-item caption="@Common.PaymentTokens" fa="credit-card" tab="payment_token" jsp="account_tab_finance_payment_token.jsp" include="<%=account.PaymentTokenCount.getInt() > 0%>"/>
  </v:tab-group>
</v:tab-content>
