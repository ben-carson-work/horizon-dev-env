<%@page import="com.vgs.snapp.library.archive.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSale" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="sale" class="com.vgs.snapp.dataobject.transaction.DOSale" scope="request"/>

<%
String paramMD = sale.MaskList.isEmpty() ? "FlatMetaData=true" : "";
String jsp_repository = pageBase.getContextURI() + "?page=repositorylist_widget&id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Sale.getCode();
boolean manualArchive = BLBO_Archive.hasPkgArchive() && BLBO_DBInfo.isTestMode() && rights.ManualArchiving.getBoolean() && pageBase.getBL(BLBO_Sale.class).existsSaleId(pageBase.getId());
%>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<div id="main-container">
  <v:tab-group name="tab" main="true">
    <v:tab-item tab="main" caption="@Common.Recap" icon="profile.png" jsp="sale_tab_main.jsp" default="true"/>
    <v:tab-item tab="transaction" caption="@Common.Transactions" icon="transaction.png" jsp="sale_tab_transaction.jsp"/>
    <v:tab-item tab="action" caption="@Action.Communications" fa="envelope" jsp="sale_tab_action.jsp" include="<%=!sale.ActionList.isEmpty()%>"/>
    <v:tab-item tab="ticket" caption="@Ticket.Tickets" icon="ticket-new.png" jsp="sale_tab_ticket.jsp" include="<%=sale.TicketCount.getInt() > 0 %>"/>
    <v:tab-item tab="media" caption="@Common.Medias" icon="media.png" jsp="sale_tab_media.jsp" include="<%=sale.MediaCount.getInt() > 0%>"/>
    <v:tab-item tab="xpi" caption="@XPI.CrossTransactions" icon="crossplatform.png" jsp="sale_tab_xpi_transaction.jsp" include="<%=rights.SystemSetupCrossPlatform.canRead() && (sale.XPITransactionCount.getInt() > 0)%>"/>
    <v:tab-item tab="coupons" caption="@Common.Coupons" icon="coupon.png" jsp="sale_tab_individual_coupon.jsp" include="<%=sale.CouponCount.getInt() > 0%>"/>
    <v:tab-item tab="instcontr" caption="@Installment.InstallmentContracts" icon="installment.png" jsp="sale_tab_instcontr.jsp" include="<%=sale.InstallmentContractCount.getInt() > 0%>"/>
    <v:tab-item tab="voucher" caption="@Common.Vouchers" icon="voucher.png" jsp="sale_tab_voucher.jsp" include="<%=sale.VoucherCount.getInt() > 0%>"/>
    <v:tab-item tab="link" caption="@Common.Sales" icon="order.png" jsp="sale_tab_link.jsp" include="<%=sale.LinkedSaleList.getSize() > 0%>"/>
    <v:tab-item tab="commmission" caption="@Commission.Commissions" icon="fee.png" jsp="sale_tab_commissions.jsp" include="<%=sale.CommissionCount.getInt() > 0%>"/>
    <v:tab-item tab="invoice" caption="@Invoice.Invoices" icon="invoice.png" jsp="sale_tab_invoices.jsp" include="<%=!sale.LinkedInvoiceList.isEmpty()%>"/>
    <v:tab-item tab="metadata" caption="@Common.Forms" icon="mask.png" jsp="sale_tab_metadata.jsp" params="<%=paramMD%>" include="<%=!sale.MaskList.isEmpty() || !sale.MetaDataList.isEmpty()%>"/>  
    <v:tab-item tab="repository" caption="@Common.Documents" icon="attachment.png" jsp="<%=jsp_repository%>" include="<%=!sale.RepositoryList.isEmpty() || pageBase.isTab(\"tab\", \"repository\")%>"/>
    <v:tab-item tab="logs" caption="@Common.Logs" icon="<%=LkSNEntityType.Log.getIconName()%>" jsp="../log/log_tab_widget.jsp" include="<%=sale.LogCount.getInt() > 0%>"/>

    <%-- ADD --%>
    <v:tab-plus>
      <%-- UPLOAD --%>
      <% String hrefUpload = "javascript:showUploadDialog(" + LkSNEntityType.Sale.getCode() + ", '" + pageBase.getId() + "', " + (sale.RepositoryList.getSize() == 0) + ");"; %>
      <v:popup-item caption="@Common.UploadFile" title="@Common.UploadFileHint" fa="upload" href="<%=hrefUpload%>"/>
      <%-- CODE ALIASES--%>
      <% String hrefCodeAlias = "javascript:asyncDialogEasy('code_alias_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Sale.getCode() + "')"; %>
      <v:popup-item caption="@Common.CodeAliases" fa="barcode" href="<%=hrefCodeAlias%>"/>
      <%-- NOTES --%>
      <% String hrefNotes = "javascript:asyncDialogEasy('common/notes_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Sale.getCode() + "');"; %>
      <v:popup-item caption="@Common.Notes" fa="comments" href="<%=hrefNotes%>"/>
      <%-- ORDER CONFIRMATION --%>
      <% String onclickOrderConfirmation = "asyncDialogEasy('sale/create_order_confirmation_dialog', 'SaleId=" + pageBase.getId() + "');"; %>
      <v:popup-item caption="@Sale.CreateOrderConfirmation" fa="envelope" onclick="<%=onclickOrderConfirmation%>"/>
      <%-- MANUAL ARCHIVE --%>
      <% String hrefManualArchive = "javascript:asyncDialogEasy('code_alias_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Sale.getCode() + "')"; %>
      <% if (manualArchive) { %>
        <v:popup-item id="menu-manual-archive" caption="Manual archive" fa="box-archive"/>
      <% } %>
      <%-- HISTORY --%>
      <% if (rights.History.getBoolean()) { %>
        <% String hrefHistory = "javascript:asyncDialogEasy('common/history_detail_dialog', 'id=" + pageBase.getId() + "');"; %>
        <v:popup-item caption="@Common.History" fa="history" href="<%=hrefHistory%>"/>
      <% } %>      
    </v:tab-plus>
  </v:tab-group>
</div>

<% if (manualArchive) { %>
<script>
$(document).ready(function() {
  $("#menu-manual-archive").click(function() {
    confirmDialog("Are you sure you want to manually archive this order?\n\n*** THE OPERATION IS NOT REVERTIBLE ***", function() {
      var saleId = <%=sale.SaleId.getJsString()%>;
      var entityType = <%=LkSNEntityType.Sale.getCode()%>;
      snpAPI.cmd("ARCHIVE", "SaleManualArchive", {
        "SaleList": [{"SaleId":saleId}]
      }).then(ansDO => entitySaveNotification(entityType, saleId));
    });
  });
});
</script>
<% } %>

<jsp:include page="/resources/common/footer.jsp"/>
