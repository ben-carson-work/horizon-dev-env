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

<rgt:menu-content id="rights-menu-tools">
  <rgt:section caption="@Common.Transaction">
    <rgt:bool rightType="<%=LkSNRightType.SaleVoidWithVoidedTickets%>"/>
    <rgt:bool rightType="<%=LkSNRightType.IgnoreCommission%>"/>
    <rgt:bool rightType="<%=LkSNRightType.GoodsReturn%>"/>
    <rgt:bool rightType="<%=LkSNRightType.TransactionSearch%>"/>
    <rgt:bool rightType="<%=LkSNRightType.POS_SearchTransactionsByWorkstation%>"/>
    <rgt:bool rightType="<%=LkSNRightType.POS_SearchTransactionsByUser%>"/>
    <rgt:bool rightType="<%=LkSNRightType.TrnReceiptReprint%>"/>
    <rgt:bool rightType="<%=LkSNRightType.TaxInInvoice%>"/>
    <rgt:bool rightType="<%=LkSNRightType.InventoryAddTo%>"/>
    <rgt:bool rightType="<%=LkSNRightType.InventoryGetFrom%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ViewAllTransactionTypes%>"/>
    <rgt:multi rightType="<%=LkSNRightType.TransactionOverrideTypes%>"/>
  </rgt:section>
  
  <rgt:section caption="@Ticket.Ticket">
    <rgt:crud-group rightType="<%=LkSNRightType.Products%>"/>
    <rgt:bool rightType="<%=LkSNRightType.AllowProductSearchesByDSSN%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ShowProductPrice%>"/>
  </rgt:section>  
      
  <rgt:section>
    <rgt:lookup-combo rightType="<%=LkSNRightType.TicketVoid%>" lookupTable="<%=LkSN.RightTicketVoidLevel%>"/>
    <rgt:subset>
      <rgt:bool rightType="<%=LkSNRightType.PastProductRefund%>"/>
      <rgt:lookup-combo rightType="<%=LkSNRightType.ProductRefundUsed%>" lookupTable="<%=LkSN.ProductRefundUsed%>"/>
      <rgt:bool rightType="<%=LkSNRightType.ProductRefundExpired%>"/>
      <rgt:bool rightType="<%=LkSNRightType.ProductRefundInstallment%>"/>
      <rgt:bool rightType="<%=LkSNRightType.TicketCancellation%>"/>
      <rgt:bool rightType="<%=LkSNRightType.OverrideRefundRestrictions%>"/>
    </rgt:subset>
  </rgt:section>
  
  <rgt:section>
    <rgt:bool rightType="<%=LkSNRightType.ProductUpgrade%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ProductDowngrade%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ProductDowngradeInstallment%>"/>
    <rgt:bool rightType="<%=LkSNRightType.IgnoreProductSaleRightsOnQuickUpgrade%>"/>
    <rgt:bool rightType="<%=LkSNRightType.AllowUpgradeToAnyProduct%>"/>    
    <rgt:lookup-combo rightType="<%=LkSNRightType.OverrideUpgradeRestrictions%>" lookupTable="<%=LkSN.OverrideUpgradeRestrictions%>"/>
    <rgt:text rightType="<%=LkSNRightType.DatedProductsAllowedPastDays%>"/>
  </rgt:section>
  
  <rgt:section>
    <rgt:lookup-combo rightType="<%=LkSNRightType.TicketAssignLevel%>" lookupTable="<%=LkSN.RightTicketAssignLevel%>"/>
    <rgt:lookup-combo rightType="<%=LkSNRightType.TicketTransfer%>" lookupTable="<%=LkSN.RightTicketTransfer%>"/>
    <rgt:subset>
      <rgt:lookup-combo rightType="<%=LkSNRightType.TicketTransferStatus%>" lookupTable="<%=LkSN.TicketStatusLevel%>"/>
      <rgt:text rightType="<%=LkSNRightType.MaxTicketTransfer%>"/>
    </rgt:subset>
  </rgt:section>
  
  <rgt:section>
    <rgt:lookup-combo rightType="<%=LkSNRightType.ChangeStartValidity%>" lookupTable="<%=LkSN.ChangeProductValidities%>"/>
    <rgt:lookup-combo rightType="<%=LkSNRightType.ProductExpDate%>" lookupTable="<%=LkSN.ChangeProductValidities%>"/>
    <rgt:subset>
      <rgt:text rightType="<%=LkSNRightType.MaxProductExpirationDays%>"/>
    </rgt:subset>
    <rgt:bool rightType="<%=LkSNRightType.TicketManualBlockUnblock%>"/>
    <rgt:bool rightType="<%=LkSNRightType.TicketSupervisorBlockUnblock%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ProductRenew%>"/>
    <rgt:bool rightType="<%=LkSNRightType.TicketReissue%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ProductRevalidate%>"/>
    <rgt:bool rightType="<%=LkSNRightType.TicketMetaDataEdit%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ChangePerformance%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ChangePerformanceDifferentPrice%>"/>
    <rgt:text rightType="<%=LkSNRightType.ChangePerformanceTimes%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ChangePerformanceOnBlockedTickets%>"/>
    <rgt:bool rightType="<%=LkSNRightType.OverrideChangePerformanceRestrictions%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ChangePerformanceExt%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ActivationGroupLinks%>"/>
    <rgt:bool rightType="<%=LkSNRightType.UpdateIgnoreCrossoverTimeRestrictions%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ProductSuspension%>"/>
  </rgt:section>  

  <rgt:section caption="@Common.Media">
    <rgt:crud-group rightType="<%=LkSNRightType.Media%>"/>
    <rgt:bool rightType="<%=LkSNRightType.AllowMediaSearchesByDSSN%>"/>
    <rgt:bool rightType="<%=LkSNRightType.MediaReissue%>"/>
    <rgt:bool rightType="<%=LkSNRightType.MediaRecycle%>"/>
    <rgt:bool rightType="<%=LkSNRightType.MediaBlock%>"/>
    <rgt:bool rightType="<%=LkSNRightType.MediaTopup%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ExternalMediaImport%>"/>
    <rgt:lookup-combo rightType="<%=LkSNRightType.ExtMediaBatchLevel%>" lookupTable="<%=LkSN.ExtMediaBatchLevel%>"/>
    <rgt:bool rightType="<%=LkSNRightType.MediaValidation%>"/>
    <rgt:bool rightType="<%=LkSNRightType.MediaStatusDamagedRevert%>"/>
    <rgt:lookup-combo rightType="<%=LkSNRightType.MediaAssignLevel%>" lookupTable="<%=LkSN.MediaAssignLevel%>"/>
    <rgt:subset>
      <rgt:lookup-combo rightType="<%=LkSNRightType.MediaAssignStatus%>" lookupTable="<%=LkSN.MediaStatusLevel%>"/>
      <rgt:bool rightType="<%=LkSNRightType.AssignMediaOffline%>"/>
    </rgt:subset>
  </rgt:section>
  
  <rgt:section caption="@Common.Portfolio">
    <rgt:bool rightType="<%=LkSNRightType.PortfolioMerge%>"/>
    <rgt:bool rightType="<%=LkSNRightType.PortfolioSettlement%>"/>
  </rgt:section>
      
  <rgt:section caption="@Common.Admission">
    <rgt:lookup-combo rightType="<%=LkSNRightType.ProductRedemption%>" lookupTable="<%=LkSN.RightProductRedemption%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ManualRedemption%>"/>
    <rgt:text rightType="<%=LkSNRightType.ManualRedemptionPastDays%>"/>
    <rgt:bool rightType="<%=LkSNRightType.SimulateRotations%>"/>
    <rgt:bool rightType="<%=LkSNRightType.RedemptionVoid%>"/>
    <rgt:subset>
      <rgt:multi rightType="<%=LkSNRightType.RedemptionVoidLocationIDs%>" inline="false"/>
    </rgt:subset>
    <rgt:bool rightType="<%=LkSNRightType.AccessControlMonitor%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ChangeToCurrentPerformance%>"/>
    <% if (rightsEnt.EntityType.isLookup(rightsUI.UsrEntities.getLkArray())) { %>
      <rgt:bool rightType="<%=LkSNRightType.ExitQtyManualInput%>"/>
    <% } %>
    <rgt:bool rightType="<%=LkSNRightType.AccessPointConfigurationChange%>"/>
  </rgt:section>
  
  <rgt:section caption="@GiftCard.GiftCard">
    <rgt:bool rightType="<%=LkSNRightType.GiftCardQuery%>"/>
    <rgt:subset>
      <rgt:bool rightType="<%=LkSNRightType.GiftCardActivate%>"/>
      <rgt:bool rightType="<%=LkSNRightType.GiftCardReload%>"/>
      <rgt:bool rightType="<%=LkSNRightType.GiftCardCashout%>"/>
    </rgt:subset>
  </rgt:section>
  
  <rgt:section caption="@Biometric.Biometric">
    <rgt:bool rightType="<%=LkSNRightType.Biometric%>"/>
    <rgt:lookup-combo rightType="<%=LkSNRightType.BiometricOverrideLevel%>" lookupTable="<%=LkSN.BiometricOverrideLevel%>"/>
  </rgt:section>
  
  <rgt:section caption="Wallet/Reward point">
    <rgt:bool rightType="<%=LkSNRightType.ManualRewardPoint%>"/>
    <rgt:bool rightType="<%=LkSNRightType.WalletDeposit%>"/>
    <rgt:lookup-combo rightType="<%=LkSNRightType.ExpirationManualChangeType%>" lookupTable="<%=LkSN.ExpirationManualChangeType%>"/>
  </rgt:section>
  
  <rgt:section>
    <rgt:bool rightType="<%=LkSNRightType.POS_ResetTimestampError%>"/>
    <rgt:bool rightType="<%=LkSNRightType.MediaLookupManualInput%>"/>
    <rgt:bool rightType="<%=LkSNRightType.MediaCreateManualInput%>"/>
    <rgt:bool rightType="<%=LkSNRightType.TrainingMode%>"/>
    <rgt:bool rightType="<%=LkSNRightType.PresaleSelection%>"/>
    <rgt:bool rightType="<%=LkSNRightType.TaxExemptSelection%>"/>
    <rgt:bool rightType="<%=LkSNRightType.POS_OverAllDiscount%>"/>
    <rgt:bool rightType="<%=LkSNRightType.POS_FunctionsButtonEnabled%>"/>
    <rgt:bool rightType="<%=LkSNRightType.POS_ToggleOfflineMode%>"/>
    <% if (rightsEnt.EntityType.isLookup(rightsUI.UsrEntities.getLkArray())) { %>
      <rgt:bool rightType="<%=LkSNRightType.UnlockOtherUserScreenSaver%>"/>
    <% } %>          
    <rgt:bool rightType="<%=LkSNRightType.PricingSimulationSelection%>"/>
  </rgt:section>
  
  <rgt:section caption="@Right.PrintFailureReconciliation">
    <rgt:bool rightType="<%=LkSNRightType.PrintFailureFullRefund%>"/>
  </rgt:section>

  <rgt:section caption="UI">
    <rgt:bool rightType="<%=LkSNRightType.POS_Browser%>"/>
    <rgt:bool rightType="<%=LkSNRightType.POS_ToolbarEdit%>"/>
    <rgt:bool rightType="<%=LkSNRightType.POS_Minimize%>"/>
    <% if (rightsEnt.EntityType.isLookup(rightsUI.WksEntities.getLkArray())) { %>
      <rgt:multi rightType="<%=LkSNRightType.HidePricesTransactionTypes%>"/>
    <% } %>
    <rgt:bool rightType="<%=LkSNRightType.ShowPerformanceAvailability%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ShowAllMediaCodes%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ShowHiddenProducts%>"/>
    <rgt:lookup-combo rightType="<%=LkSNRightType.PNRVisibility%>" lookupTable="<%=LkSN.PNRVisibility%>"/>
    <rgt:bool rightType="<%=LkSNRightType.GridDownload%>"/>
    <rgt:text rightType="<%=LkSNRightType.POS_MaxRecordsReturnedBySearch%>"/>
    <rgt:bool rightType="<%=LkSNRightType.SeatEnvelopeExtra%>"/>
  </rgt:section>
  
  <rgt:section caption="@Invoice.Invoice">
    <rgt:bool rightType="<%=LkSNRightType.InvoiceSearch%>"/>
    <rgt:bool rightType="<%=LkSNRightType.InvoiceDownload%>"/>
    <rgt:bool rightType="<%=LkSNRightType.InvoiceIssue%>"/>
    <rgt:bool rightType="<%=LkSNRightType.InvoiceSettle%>"/>
    <rgt:bool rightType="<%=LkSNRightType.InvoiceVoid%>"/>
    <rgt:bool rightType="<%=LkSNRightType.InvoiceWriteOff%>"/>
    <rgt:bool rightType="<%=LkSNRightType.InvoiceRestore%>"/>
    <rgt:bool rightType="<%=LkSNRightType.InvoiceChangeDueDate%>"/>
  </rgt:section>

  <rgt:section caption="@Payment.Installment">
    <rgt:crud rightType="<%=LkSNRightType.InstallmentPlans%>"/>
    
    <rgt:bool rightType="<%=LkSNRightType.InstallmentContractRead%>"/>
    <rgt:subset>
      <rgt:lookup-combo rightType="<%=LkSNRightType.BlockUnblockContracts%>" lookupTable="<%=LkSN.ContractBlockUnblock%>"/>
      <rgt:bool rightType="<%=LkSNRightType.InstallmentContractDocument%>"/>
      <rgt:bool rightType="<%=LkSNRightType.InstallmentContractCancel%>"/>
      <rgt:bool rightType="<%=LkSNRightType.InstallmentContractVoid%>"/>
      <rgt:bool rightType="<%=LkSNRightType.ManualExportInstallmentContract%>"/>
    </rgt:subset>
    
    <rgt:bool rightType="<%=LkSNRightType.InstallmentContractVoidOtherDay%>"/>
    <rgt:bool rightType="<%=LkSNRightType.InstallmentContractVoidUsed%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ReschedulePayments%>"/>
    <rgt:bool rightType="<%=LkSNRightType.InstallmentSettlement%>"/>
  </rgt:section>
  
  <rgt:section caption="@Common.Warehouse">
    <rgt:bool rightType="<%=LkSNRightType.WarehouseLoad%>"/>
    <rgt:bool rightType="<%=LkSNRightType.WarehouseStocks%>"/>
  </rgt:section>
  
  <% if (rightsEnt.EntityType.isLookup(rightsUI.UsrEntities.getLkArray())) { %>
    <rgt:section caption="@Right.AuditLocation">
      <rgt:lookup-combo rightType="<%=LkSNRightType.AuditLocationFilter%>" lookupTable="<%=LkSN.AuditLocationFilter%>"/>
    </rgt:section>
  <% } %>

  <rgt:section caption="@Common.CashDrawer">
    <rgt:bool rightType="<%=LkSNRightType.CashDrawerManual%>"/>
    <rgt:lookup-combo rightType="<%=LkSNRightType.BoxCashDrawer%>" lookupTable="<%=LkSN.BoxCashDrawer%>"/>
  </rgt:section>
  
  <rgt:section caption="@Common.Others">
    <rgt:text rightType="<%=LkSNRightType.SearchesMaxDateRange%>"/>
    <rgt:text rightType="<%=LkSNRightType.SearchesMaxPastDays%>"/>
    <rgt:text rightType="<%=LkSNRightType.SearchesMinDate%>"/>
    <rgt:text rightType="<%=LkSNRightType.SearchesMaxResults%>"/>
    <rgt:bool rightType="<%=LkSNRightType.CodeAliasEdit%>"/>
    <rgt:lookup-combo rightType="<%=LkSNRightType.HighlightedNote%>" lookupTable="<%=LkSN.HighlightedNoteRightLevel%>"/>
    <rgt:bool rightType="<%=LkSNRightType.NoteDelete%>"/>
    <rgt:bool rightType="<%=LkSNRightType.AdjustAdmissionsCount%>"/>
    <rgt:subset>
      <rgt:text rightType="<%=LkSNRightType.MaxAdjustAdmissionsDays%>"/>
    </rgt:subset>
    <rgt:bool rightType="<%=LkSNRightType.History%>"/>
    <rgt:bool rightType="<%=LkSNRightType.PortfolioHistory%>"/>
    <rgt:bool rightType="<%=LkSNRightType.UnregisterMobile%>"/>
    <rgt:crud rightType="<%=LkSNRightType.Repository%>"/>
  </rgt:section>
</rgt:menu-content>
