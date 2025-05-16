<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%> 
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
  <rgt:section caption="@Common.General">
    <rgt:bool rightType="<%=LkSNRightType.MatchSerialAndFiscalDates%>"/>
    <rgt:text rightType="<%=LkSNRightType.ExtPaymentTerminalId%>"/>
    <rgt:lookup-combo rightType="<%=LkSNRightType.UpgradeTaxCalcType%>" lookupTable="<%=LkSN.UpgradeTaxCalcType%>"/>
    <rgt:bool rightType="<%=LkSNRightType.EmptySaleChannelUpgradeOnFacePrice%>"/>
    <rgt:text rightType="<%=LkSNRightType.HighlightPaymentDataKeys%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ReconcileCreditOnSaleVoid%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ReverseCommission%>"/>
  </rgt:section>

  <rgt:section caption="@Payment.Change">
    <rgt:combo rightType="<%=LkSNRightType.ChangePaymentMethodId%>"/>
    <rgt:multi rightType="<%=LkSNRightType.AlternativeChangePaymentMethods%>"/>
    <rgt:text rightType="<%=LkSNRightType.AlternativeChangeThreshold%>"/>
    <rgt:bool rightType="<%=LkSNRightType.TipOnPayment%>"/>
  </rgt:section>

  <rgt:section caption="@Box.BoxMaintenance">
    <rgt:text rightType="<%=LkSNRightType.BoxClosureMaxRetries%>"/>
    <rgt:text rightType="<%=LkSNRightType.BoxClosureOvershortTolerance%>"/>
    <rgt:text rightType="<%=LkSNRightType.BoxStartingFund%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ConfirmBoxStartingFund%>"/>
    <rgt:text rightType="<%=LkSNRightType.MinOverrideBoxStartingFund%>"/>
    <rgt:text rightType="<%=LkSNRightType.MaxOverrideBoxStartingFund%>"/>
    <rgt:text rightType="<%=LkSNRightType.BoxCashLimitAlert%>"/>
    <rgt:bool rightType="<%=LkSNRightType.SkipFinalCloseDetails%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ShowAutofillPayments%>"/>
    <rgt:bool rightType="<%=LkSNRightType.RequireBagNumberOnFinalClose%>"/>
    <rgt:bool rightType="<%=LkSNRightType.RequireBagNumberOnDeposit%>"/>
    <rgt:bool rightType="<%=LkSNRightType.RequireBagNumberOnWithdraw%>"/>
    <rgt:bool rightType="<%=LkSNRightType.RequireBagNumberOnShiftOpening%>"/>
    <rgt:bool rightType="<%=LkSNRightType.UniqueBagNumber%>"/>
    <rgt:lookup-combo rightType="<%=LkSNRightType.BagNumberFormat%>" lookupTable="<%=LkSN.BagNumberFormat%>"/>
    <rgt:text rightType="<%=LkSNRightType.BagNumberMinLength%>"/>
    <rgt:text rightType="<%=LkSNRightType.BagNumberMaxLength%>"/>
    <rgt:lookup-combo rightType="<%=LkSNRightType.BoxLevel%>" lookupTable="<%=LkSN.BoxLevel%>"/>
    <rgt:bool rightType="<%=LkSNRightType.BoxByWorkstation%>"/>
  </rgt:section>

  <rgt:section caption="@Common.EWallet">
    <rgt:text rightType="<%=LkSNRightType.WalletCreditLimitDefault%>"/>
    <rgt:text rightType="<%=LkSNRightType.WalletCap%>"/>
    <rgt:text rightType="<%=LkSNRightType.WalletMinimumTopup%>"/>
    <rgt:text rightType="<%=LkSNRightType.WalletExpiration%>"/>
    <rgt:dyn-combo rightType="<%=LkSNRightType.ProductId_ExtPay%>" entityType="<%=LkSNEntityType.ProductType%>"/>
  </rgt:section>

  <rgt:section caption="@GiftCard.GiftCard">
    <rgt:text rightType="<%=LkSNRightType.GiftCardTotalAmountCap%>"/>
    <rgt:text rightType="<%=LkSNRightType.GiftCardMinActivationAmount%>"/>
    <rgt:text rightType="<%=LkSNRightType.GiftCardMaxActivationAmount%>"/>
    <rgt:text rightType="<%=LkSNRightType.GiftCardMinReloadAmount%>"/>
  </rgt:section>

  <rgt:section caption="@Lookup.PaymentType.Installment">
    <rgt:text rightType="<%=LkSNRightType.InstallmentContractCodeLength%>"/>
    <rgt:text rightType="<%=LkSNRightType.InstallmentContractCodePrefix%>"/>
    <rgt:bool rightType="<%=LkSNRightType.InstallmentDocAutoSave%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ShowInstallmentScheduleDates%>"/>
  </rgt:section>
  
  <rgt:section caption="@Ledger.Ledger">
    <rgt:lookup-combo rightType="<%=LkSNRightType.LedgerTaxTriggerType%>" lookupTable="<%=LkSN.LedgerTaxTriggerType%>"/>
  </rgt:section>

  <rgt:section caption="@Invoice.Invoice">
    <rgt:text rightType="<%=LkSNRightType.InvoiceCodeFormat%>"/>
    <rgt:bool rightType="<%=LkSNRightType.InvoiceIssueOnPaidOrders%>"/>
  </rgt:section>
  
  <rgt:section caption="@Common.Voucher">
    <rgt:bool rightType="<%=LkSNRightType.VoucherRedeemMultipleOrgs%>"/>
    <rgt:multi rightType="<%=LkSNRightType.MembershipPlanIDs%>"/>
  </rgt:section>
  
</rgt:menu-content>
