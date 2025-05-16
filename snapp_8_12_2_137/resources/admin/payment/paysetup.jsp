<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PagePaymentSetup" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>
  
<v:tab-group name="tab" main="true">
  <% boolean first = true; %>
  <% if (rights.SettingsPayments.getBoolean()) { %>
    <v:tab-item caption="@Payment.PaymentMethods" icon="pay_cash.png" tab="paymethod" jsp="paysetup_tab_paymethod.jsp" default="<%=first%>"/>
    <v:tab-item caption="@Payment.PaymentProfiles" icon="pay_cash.png" tab="paymentprofile" jsp="paysetup_tab_paymentprofile.jsp"/> 
    <% first = false; %>
  <% } %>
  <% if (rights.InstallmentPlans.canRead()) { %>
    <v:tab-item caption="@Installment.InstallmentPlans" icon="installment.png" tab="instplan" jsp="paysetup_tab_instplan.jsp" default="<%=first%>"/>
    <% first = false; %>
  <% } %>
  <% if (rights.SettingsCurrencies.getBoolean()) { %>
    <v:tab-item caption="@Currency.Currencies" icon="currency.png" tab="currency" jsp="paysetup_tab_currency.jsp" default="<%=first%>"/>
    <% first = false; %>
  <% } %>
  <% if (rights.SettingsPayments.getBoolean()) { %>
    <v:tab-item caption="@Common.Merchants" icon="merchant.png" tab="merchant" jsp="paysetup_tab_merchant.jsp" default="<%=first%>"/>
    <v:tab-item caption="@Payment.CardTypes" fa="credit-card" tab="cardtype" jsp="paysetup_tab_cardtype.jsp"/>
    <v:tab-item caption="@Payment.IntercompanyCostCenter" fa="dot-circle" tab="intercompany_costcenter" jsp="paysetup_tab_intercompany_costcenter.jsp" /> 
    <% first = false; %>
  <% } %>
  
</v:tab-group>
 
<jsp:include page="/resources/common/footer.jsp"/>
