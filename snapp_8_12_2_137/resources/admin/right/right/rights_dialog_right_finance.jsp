<%@page import="com.vgs.snapp.exception.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="rgt-tags" prefix="rgt" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rightsEnt" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="rightsDef" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="rightsUI" class="com.vgs.snapp.dataobject.DORightDialogUI" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<rgt:menu-content id="rights-menu-finance">
  <rgt:section>
    <rgt:multi rightType="<%=LkSNRightType.PaymentMethodsIDs%>"/>
    <rgt:multi rightType="<%=LkSNRightType.ForeignCurrencyISOs%>"/>
    <rgt:multi rightType="<%=LkSNRightType.IntercompanyCostCenters%>"/>
    <rgt:multi rightType="<%=LkSNRightType.MembershipPointIDs%>"/>
  </rgt:section>
  
  <rgt:section>
    <% if (rightsEnt.EntityType.isLookup(rightsUI.UsrEntities.getLkArray())) { %>
      <rgt:bool rightType="<%=LkSNRightType.OverrideOriginalPaymentsRestriction%>"/>
    <% } %>
    <rgt:bool rightType="<%=LkSNRightType.RefundOnDifferentCard%>"/>
    <rgt:bool rightType="<%=LkSNRightType.IssueForRefund%>"/>
  </rgt:section>
  
  <rgt:section>
    <rgt:bool rightType="<%=LkSNRightType.ForeignCurrencyExchange%>"/>
  </rgt:section>

  <rgt:section caption="@Box.BoxMaintenance">
    <% if (rightsEnt.EntityType.isLookup(rightsUI.UsrEntities.getLkArray())) { %>
      <rgt:level-group rightType="<%=LkSNRightType.BoxMaintenance%>" lookupTable="<%=LkSN.RightBoxMaintenance%>"/>
      <rgt:bool rightType="<%=LkSNRightType.CloseDifferentBox%>"/>
      <rgt:bool rightType="<%=LkSNRightType.BoxReceiptReprint%>"/>
      <rgt:bool rightType="<%=LkSNRightType.OverrideBoxStartingFund%>"/>
      <rgt:bool rightType="<%=LkSNRightType.AllowShowExpectedAmountOnFinalClose%>"/>
      <rgt:bool rightType="<%=LkSNRightType.AlwaysAllowFinalClose%>"/>
    <% } %>
    <rgt:bool rightType="<%=LkSNRightType.IgnoreBoxStartingFund%>"/>
    <rgt:bool rightType="<%=LkSNRightType.MultipleBoxesInDifferentLocations%>"/>
  </rgt:section>
  
 <% if (rightsEnt.EntityType.isLookup(rightsUI.UsrEntities.getLkArray())) { %> 
  <rgt:section caption="@Ledger.Ledger">
      <rgt:bool rightType="<%=LkSNRightType.AuditLedger%>"/>
      <rgt:bool rightType="<%=LkSNRightType.LedgerRegenerate%>"/>
      <rgt:lookup-combo rightType="<%=LkSNRightType.LedgerManualEntry%>" lookupTable="<%=LkSN.RightLedgerManualEntry%>"/>
        <rgt:subset>
          <rgt:text rightType="<%=LkSNRightType.LedgerManualEntryPastDays%>"/>
        </rgt:subset>
      <rgt:crud rightType="<%=LkSNRightType.SettingsLedgerAccounts%>"/>
  </rgt:section>   

  <rgt:section caption="@Common.EWallet">
    <rgt:bool rightType="<%=LkSNRightType.ModifyCreditLimit%>"/>
  </rgt:section>
 <% } %>
    
  <rgt:section caption="@Common.Coupons">
    <rgt:crud-group rightType="<%=LkSNRightType.Coupons%>"/>
  </rgt:section>

  <rgt:section caption="@Common.Vouchers">
    <rgt:bool rightType="<%=LkSNRightType.VoucherIssue%>"/>
    <rgt:bool rightType="<%=LkSNRightType.VoucherRedeem%>"/>
    <rgt:bool rightType="<%=LkSNRightType.VoucherPrint%>"/>
    <rgt:bool rightType="<%=LkSNRightType.VoucherBlock%>"/>
    <rgt:bool rightType="<%=LkSNRightType.VoucherReissue%>"/>
    <rgt:bool rightType="<%=LkSNRightType.VoucherVoid%>"/>
    <rgt:bool rightType="<%=LkSNRightType.VoucherExpDate%>"/>
  </rgt:section>
</rgt:menu-content>
