<%@page import="com.vgs.snapp.dataobject.DOExternalIdentifier"%>
<%@page import="com.vgs.cl.document.FtList"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTransaction" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="transaction" class="com.vgs.snapp.dataobject.transaction.DOTransaction" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<div id="main-container">
  <v:tab-group name="tab" main="true">
    <v:tab-item tab="main" default="true" caption="@Common.Recap" icon="profile.png" jsp="transaction_tab_main.jsp"/>
    <v:tab-item tab="payments" caption="@Payment.Payments" icon="pay_cash.png" jsp="transaction_tab_payment.jsp" include="<%=transaction.PaymentCount.getInt() > 0%>"/>
    <v:tab-item tab="settlecredit" caption="@Account.Credit.SettledCredits" icon="credit.png" jsp="transaction_tab_settlecredit.jsp" include="<%=transaction.SettleCreditCount.getInt() > 0%>"/>
    <v:tab-item tab="tickets" caption="@Ticket.Tickets" icon="ticket.png" jsp="transaction_tab_ticket.jsp" include="<%=transaction.TicketCount.getInt() > 0%>"/>
    <v:tab-item tab="voidedExtTickets" caption="@Ticket.VoidedExternalTickets" icon="ticket.png" jsp="transaction_tab_voided_external_tickets.jsp" include="<%=transaction.ExtVoidedTicketCount.getInt() > 0%>"/>
    <v:tab-item tab="medias" caption="@Common.Medias" icon="media.png" jsp="transaction_tab_media.jsp" include="<%=transaction.MediaCount.getInt() > 0%>"/>
    <v:tab-item tab="media-transfers" caption="@Media.MediaTransfer" icon="media.png" jsp="transaction_tab_mediatransfer.jsp" include="<%=transaction.MediaTransferCount.getInt() > 0%>"/>
    <v:tab-item tab="xpi" caption="@XPI.CrossTransactions" icon="crossplatform.png" jsp="transaction_tab_xpi_transaction.jsp" include="<%=rights.SystemSetupCrossPlatform.canRead() && (transaction.XPITransactionCount.getInt() > 0)%>"/>
    <v:tab-item tab="coupons" caption="@Common.Coupons" icon="coupon.png" jsp="transaction_tab_individual_coupon.jsp" include="<%=transaction.CouponCount.getInt() > 0%>"/>
    <v:tab-item tab="voucher" caption="@Common.Vouchers" icon="voucher.png" jsp="transaction_tab_voucher.jsp" include="<%=transaction.VoucherCount.getInt() > 0%>"/>
    <v:tab-item tab="stock" caption="@Common.Inventory" icon="warehouse.png" jsp="transaction_tab_stock.jsp" include="<%=transaction.StockCount.getInt() > 0%>"/>
    <v:tab-item tab="commission" caption="@Commission.Commissions" icon="fee.png" jsp="transaction_tab_commission.jsp" include="<%=transaction.CommissionRecap.CommissionQuantity.getInt() > 0%>"/> 
    <v:tab-item tab="openorderlog" caption="@Account.Credit.OpenOrderLogs" icon="fee.png" jsp="transaction_tab_openorderlog.jsp" include="<%=!transaction.OpenOrderLogList.isEmpty()%>"/> 
    <v:tab-item tab="upsell" caption="@Product.Upsells" fa="arrow-alt-to-top" jsp="transaction_tab_upsell.jsp" include="<%=!transaction.UpsellStatList.isEmpty()%>"/> 
    <v:tab-item tab="invoice" caption="@Invoice.Invoices" icon="invoice.png" jsp="transaction_tab_invoices.jsp" include="<%=!transaction.LinkedInvoiceList.isEmpty()%>"/>
    <v:tab-item tab="wallet" caption="@Portfolio.WalletActivity" icon="wallet.png" jsp="transaction_tab_walletactivity.jsp" include="<%=transaction.WalletActivityCount.getInt() > 0%>"/>
    <v:tab-item tab="membershippoint" caption="@Portfolio.MembershipPointActivity" icon="membershippoint.png" jsp="transaction_tab_membershippointactivity.jsp" include="<%=transaction.MembershipPointActivityCount.getInt() > 0%>"/>
    <v:tab-item tab="activationgroup" caption="@ActivationGroup.ActivationGroup" fa="users" jsp="transaction_tab_activationgroupactivity.jsp" include="<%=transaction.ActivationGroupActivityCount.getInt() > 0%>"/>
    <v:tab-item tab="ticketusage" caption="@Ticket.Usages" fa="arrow-circle-up" jsp="transaction_tab_ticketusage.jsp" include="<%=transaction.TicketUsageCount.getInt() > 0%>"/>
    <v:tab-item tab="action" caption="@Common.Email" fa="envelope" jsp="transaction_tab_action.jsp" include="<%=transaction.ActionCount.getInt() > 0%>"/>
    <v:tab-item tab="metadata" caption="@Common.Forms" icon="mask.png" jsp="transaction_tab_metadata.jsp" include="<%=!transaction.MetaDataList.isEmpty() || !transaction.TransactionSurveyMaskIDs.isEmpty()%>"/>  
    <v:tab-item tab="jobs" caption="@Task.Jobs" icon="<%=LkSNEntityType.Log.getIconName()%>" jsp="transaction_list_jobs.jsp" include="<%=transaction.TransactionType.isLookup(LkSNTransactionType.TaskEntryLedger)%>"/>
    <v:tab-item tab="log" caption="@Common.Logs" icon="<%=LkSNEntityType.Log.getIconName()%>" jsp="../common/page_tab_logs.jsp" include="<%=transaction.LogCount.getInt() > 0%>"/>

    
    <%-- ADD --%>
    <v:tab-plus>
      <%-- CODE ALIASES--%>
      <% String onclickCodeAlias = "asyncDialogEasy('code_alias_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Transaction.getCode() + "')"; %>
      <v:popup-item caption="@Common.CodeAliases" fa="barcode" onclick="<%=onclickCodeAlias%>"/>
      
      <%-- EXTERNAL IDENTIFIERS--%>
      <%
        String tdssn = pageBase.getBL(BLBO_Transaction.class).getTDSSNFromTransactionId(pageBase.getId());
        String onclickExternalIdentifiers = "asyncDialogEasy('external_identifiers_dialog', 'EntityTDSSN=" + tdssn + "&EntityType=" + LkSNEntityType.Transaction.getCode() + "&TransactionType=" + transaction.TransactionType.getInt() + "')"; 
        FtList<DOExternalIdentifier> externalIdentifierList = new FtList<>(null, DOExternalIdentifier.class);
        pageBase.getBL(BLBO_Plugin.class).fillExternalIdentifierList(externalIdentifierList, LkSNEntityType.Transaction, tdssn, transaction.TransactionType.getLkValue());
      %>
      <% if (!externalIdentifierList.isEmpty()) { %>
        <v:popup-item caption="@Common.ExternalIdentifiers" fa="external-link" onclick="<%=onclickExternalIdentifiers%>"/>
      <% } %>
            
      <%-- ORDER CONFIRMATION --%>
      <% String onclickOrderConfirmation = "asyncDialogEasy('sale/create_order_confirmation_dialog', 'SaleId=" + transaction.SaleId.getHtmlString() + "&FilterTransactionId=" + pageBase.getId() + "');"; %>
      <v:popup-item caption="@Sale.CreateOrderConfirmation" fa="envelope" onclick="<%=onclickOrderConfirmation%>"/>
      
      <%-- HISTORY --%>
      <% if (rights.History.getBoolean()) {%>
	      <% String onclickHistory = "asyncDialogEasy('common/history_detail_dialog', 'id=" + pageBase.getId() + "');"; %>
	      <v:popup-item caption="@Common.History" fa="history" onclick="<%=onclickHistory%>"/>
	    <% } %>  
    </v:tab-plus>
    
  </v:tab-group>
</div>

<jsp:include page="/resources/common/footer.jsp"/>
