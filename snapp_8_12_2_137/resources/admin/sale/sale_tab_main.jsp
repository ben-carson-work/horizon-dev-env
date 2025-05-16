<%@page import="com.vgs.snapp.web.query.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="java.util.stream.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.dataobject.transaction.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSale" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="sale" class="com.vgs.snapp.dataobject.transaction.DOSale" scope="request"/>
<jsp:useBean id="rightCRUD" class="com.vgs.snapp.library.FtCRUD" scope="request"/>

<% 
boolean canDelete = rightCRUD.canDelete();
boolean hasDiscounts = sale.TotalDiscount.getMoney() > 0;
boolean hasOverPayment = sale.OverPaymentAmount.getMoney() > 0;
boolean clc = pageBase.isVgsContext("CLC");
boolean bko = pageBase.isVgsContext("BKO");
boolean showEditButton = 
    clc && 
    sale.SaleStatus.isLookup(LkSNSaleStatus.Normal) && 
    !sale.Validated.getBoolean() && 
    rightCRUD.canUpdate();
boolean showSaleCancelButton =
    bko && 
    rights.SaleCancellation.getBoolean() &&
    sale.SaleStatus.isLookup(LkSNSaleStatus.Normal) && 
    pageBase.getRights().TicketCancellation.getBoolean() && 
    canDelete;
boolean showPahButton = pageBase.getBLDef().canDownloadPrintAtHome(pageBase.getId(), sale.SaleStatus.getLkValue());
boolean showReportButton = sale.Paid.getBoolean();
boolean invoiceEnabled =
    rights.InvoiceIssue.getBoolean() && 
    !sale.OwnerAccount.isEmpty() &&
    ((sale.OpenedCreditCount.getInt() > 0) || rights.InvoiceIssueOnPaidOrders.getBoolean()) && 
    !sale.Invoiced.getBoolean() && 
    sale.Paid.getBoolean();

String statusButtonIcon = "";
String statusButtonCaption = "";

if (((sale.SaleStatus.getInt() > LkSNSaleStatus.BlockLimitStart) && (sale.SaleStatus.getInt() < LkSNSaleStatus.BlockLimitEnd)) || sale.SaleStatus.isLookup(LkSNSaleStatus.WaitingForPayment)) { 
  statusButtonIcon = "unlock";
  statusButtonCaption = "@Common.Unblock";
}
else if (!sale.SaleStatus.isLookup(LkSNSaleStatus.Deleted)) {
  statusButtonIcon = "lock";
  statusButtonCaption = "@Common.Block";
} 
boolean showBlockUnblockButton = (pageBase.getRights().OrderBlockUnblock.getBoolean() && !statusButtonCaption.isEmpty() && sale.Validated.getBoolean()) || (sale.SaleStatus.isLookup(LkSNSaleStatus.WaitingForPayment) && pageBase.getRights().ManualUnlockPayByLink.getBoolean());
%>
<style>

.recap-table .postbox {
  min-height: 130px;
}

</style>

<v:tab-toolbar>
  <snp:notes-btn entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.Sale%>"/>
  
  <% String hrefEdit = pageBase.getContextURL() + "?page=shopcart#" + pageBase.getId(); %>
  <v:button caption="@Common.Edit" href="<%=hrefEdit%>" include="<%=showEditButton%>"/>

  <v:button-group>
    <v:button id="btn-download-pah" caption="@Common.PrintAtHome" fa="file-pdf" target="_new" href="<%=pageBase.buildURL_DownloadPah(pageBase.getId())%>" include="<%=showPahButton%>"/>
    <snp:btn-report docContext="<%=LkSNContextType.Sale_Invoice%>" caption="@DocTemplate.Reports" include="<%=showReportButton%>"/>
  </v:button-group>

  <v:button-group>
    <% String clickStatus = "asyncDialogEasy('sale/sale_change_status_dialog', 'SaleId=" + pageBase.getId() + "&SaleStatus=" + sale.SaleStatus.getInt() + "')"; %>
    <v:button caption="<%=statusButtonCaption%>" fa="<%=statusButtonIcon%>" onclick="<%=clickStatus%>" include="<%=showBlockUnblockButton%>"/>
    <v:button caption="@Lookup.TransactionType.SaleCancellation" fa="trash-alt" onclick="showSaleCancellationDialog()" include="<%=showSaleCancelButton%>"/>
  </v:button-group>
</v:tab-toolbar>
  

<v:tab-content>

  <v:profile-recap>
    <v:widget caption="@Common.PayByLink" include="<%=sale.WaitForPaymentPayByLink.getBoolean()%>">
      <v:widget-block>
        <v:itl key="@Sale.SaleTokenLockMessage"/>
        <snp:datetime timezone="local" timestamp="<%=sale.SaleTokenExpireDateTime%>" format="shortdatetime"/>
      </v:widget-block>
    </v:widget>
 
    <v:widget caption="@Common.LockInfo" include="<%=sale.LockCount.getInt() > 0%>">
      <div id="lock-widget2"></div>
      <script>asyncLoad("#lock-widget2", "<%=pageBase.getContextURL()%>?page=lock_widget&id=<%=pageBase.getId()%>&EntityType=<%=LkSNEntityType.Sale.getCode()%>");</script>
    </v:widget>
    
    <% String lineThrough = sale.SaleStatus.isLookup(LkSNSaleStatus.Deleted) ? "line-through" : ""; %>
    <v:widget caption="@Common.Profile">
      <v:widget-block>
        <v:recap-item caption="@Sale.PNR"><%=sale.SaleCodeDisplay.getHtmlString()%></v:recap-item>
        <v:recap-item caption="@Sale.SequenceNumber" include="<%=!sale.SaleSequence.isNull()%>"><%=sale.SaleSequence.getHtmlString()%></v:recap-item>
        <v:recap-item caption="@Reservation.Flags"><%=sale.Flags.getHtmlString()%></v:recap-item>
        <v:recap-item caption="@Common.Status" valueColor="<%=sale.SaleStatusColor.getString()%>"><%=sale.SaleStatusCalcDesc.getHtmlString()%></v:recap-item>
        <v:recap-item caption="@Common.ArchivedOn" valueColor="red" include="<%=!sale.ArchivedOnDateTime.isNull()%>"><snp:datetime timestamp="<%=sale.ArchivedOnDateTime%>" format="shortdatetime" timezone="local"/></v:recap-item>
        <v:recap-item caption="@Common.Archivable" valueColor="orange" include="<%=!sale.ArchivableOnDateTime.isNull()%>"><snp:datetime timestamp="<%=sale.ArchivableOnDateTime%>" format="shortdatetime" timezone="local"/></v:recap-item>

        <v:recap-item caption="@SaleChannel.SaleChannel">
          <% if (sale.SaleChannelId.isNull()) { %>
            <v:itl key="@Common.Default"/>
          <% } else { %>
            <snp:entity-link entityId="<%=sale.SaleChannelId%>" entityType="<%=LkSNEntityType.SaleChannel %>"><%=sale.SaleChannelName.getHtmlString()%></snp:entity-link>
          <% } %>
        </v:recap-item>

        <v:recap-item caption="@Common.Membership" include="<%=!sale.MembershipTicket.isEmpty()%>">
          <snp:entity-link entityId="<%=sale.MembershipTicket.TicketId%>" entityType="<%=LkSNEntityType.Ticket%>"><%=sale.MembershipTicket.ProductName.getHtmlString()%></snp:entity-link>
        </v:recap-item>

        <v:recap-item valueColor="orange" include="<%=sale.TaxExempt.getBoolean()%>"><v:itl key="@Sale.TaxExempt"/></v:recap-item>
      </v:widget-block>
             
      <v:widget-block include="<%=!sale.AccountList.isEmpty()%>">
        <% for (DOSaleAccountRef saleAccount : sale.AccountList) { %>
          <% 
          String accountName = saleAccount.AccountName.getEmptyString();
          if (accountName.trim().length() == 0)
            accountName = pageBase.getLang().Account.AnonymousAccount.getText();
          %>
          <v:recap-item caption="<%=saleAccount.SaleAccountType.getLkValue().getRawDescription()%>">
            <snp:entity-link entityId="<%=saleAccount.AccountId%>" entityType="<%=saleAccount.EntityType%>"><%=JvString.escapeHtml(accountName)%></snp:entity-link>
          </v:recap-item>
        <% } %>
      </v:widget-block>

      <v:widget-block include="<%=!sale.BatchDate.isNull()%>">
        <v:recap-item caption="@Reservation.BatchPrinting"></v:recap-item>
        <v:recap-item caption="@Common.Date"><%=pageBase.format(sale.BatchDate, pageBase.getShortDateFormat())%></v:recap-item>
        <v:recap-item caption="@Common.Number"><%=sale.BatchNumber.getInt()%></v:recap-item>
        <% if (!sale.FulfilmentAreaTagName.isNull()) { %>
          <v:recap-item caption="@Common.FulfilmentArea"><%=sale.FulfilmentAreaTagName.getHtmlString()%></v:recap-item>
        <% } %>
      </v:widget-block>

      <v:widget-block include="<%=!sale.AutoPurge.getBoolean()%>">
        <v:recap-item><v:itl key="@Reservation.PurgeLock"/></v:recap-item>
      </v:widget-block>
      
      <v:widget-block>
        <v:recap-item caption="@Common.FiscalDate"><%=pageBase.format(sale.SaleFiscalDate, pageBase.getShortDateFormat())%></v:recap-item>
        <v:recap-item caption="@Common.DateTime"><snp:datetime timestamp="<%=sale.SaleDateTime%>" format="shortdatetime" timezone="local"/></v:recap-item>
        <v:recap-item caption="@Account.Location"><snp:entity-link entityId="<%=sale.LocationId%>" entityType="<%=LkSNEntityType.Location%>"><%=sale.LocationName.getHtmlString()%></snp:entity-link></v:recap-item>
        <v:recap-item caption="@Common.Workstation"><snp:entity-link entityId="<%=sale.WorkstationId%>" entityType="<%=LkSNEntityType.Workstation%>"><%=sale.WorkstationName.getHtmlString()%></snp:entity-link></v:recap-item>
      </v:widget-block>
           
      <v:widget-block include="<%=!sale.LinkedTransactionList.isEmpty()%>">
        <v:recap-item caption="@Sale.LinkedTransactions">
          <% for (DOTransactionRef link : sale.LinkedTransactionList) { %>
            <div><snp:entity-link entityId="<%=link.TransactionId%>" entityType="<%=LkSNEntityType.Transaction%>"><%=link.TransactionCode.getHtmlString()%></snp:entity-link></div>
          <% } %>
          <% if (sale.LinkedTransactionCount.getInt() > sale.LinkedTransactionList.getSize()) { %>
            <div>
              <a href="javascript:asyncDialogEasy('transaction/linked_transactions_dialog' , 'LinkedSaleId=' + <%=JvString.sqlStr(pageBase.getId())%>);">
                <v:itl key="@Common.ShowMore" param1="<%=sale.LinkedTransactionCount.getHtmlString()%>"/>
              </a>
            </div>
          <% } %>
        </v:recap-item>
      </v:widget-block>
                
      <v:widget-block>
        <v:recap-item caption="@Invoice.Invoice">
          <% if (sale.Invoiced.getBoolean()) { %>
            <snp:entity-link entityId="<%=sale.Invoice.InvoiceId%>" entityType="<%=LkSNEntityType.Invoice%>"><%=sale.Invoice.InvoiceCode.getHtmlString()%></snp:entity-link>
          <% } else { %>
            <v:button caption="@Invoice.Issue" fa="plus" id="invoice-issue-btn" onclick="showInvoiceIssueDialog()" enabled="<%=invoiceEnabled%>"/>
          <% } %>
        </v:recap-item>
      </v:widget-block>
      
      <v:widget-block>
        <v:recap-item caption="@Common.RelatedLocations">
          <% for (DOLocationOwner location : sale.LocationList) { %>
            <div>       
              <snp:entity-link entityId="<%=location.LocationAccountId%>" entityType="<%=LkSNEntityType.Location%>" clazz="list-title">
                <%=location.LocationName.getHtmlString()%>
              </snp:entity-link>
            </div>
          <% } %>
        </v:recap-item>
      </v:widget-block>
      
      <v:widget-block include="<%=!sale.VisitDateMin.isNull()%>">
        <v:recap-item caption="@Sale.VisitDate">
          <%=pageBase.format(sale.VisitDateMin, pageBase.getShortDateFormat()) %>
          <% if (!sale.VisitDateMax.isNull() && !sale.VisitDateMax.isSameDay(sale.VisitDateMin)) { %>
            &mdash; <%=pageBase.format(sale.VisitDateMax, pageBase.getShortDateFormat()) %>
          <% } %>
        </v:recap-item>
      </v:widget-block>

      <v:widget-block include="<%=!sale.ScheduledPaymentDate.isNull()%>">
        <v:recap-item caption="@Sale.ScheduledPaymentDate">
          <%=pageBase.format(sale.ScheduledPaymentDate, pageBase.getShortDateFormat())%>
          <v:hint-handle hint="@Sale.ScheduledPaymentDateHint"/>
        </v:recap-item>
      </v:widget-block>
      
      <v:widget-block include="<%=!sale.GroupResourceList.isEmpty()%>">
        <v:recap-item caption="@Resource.GroupResources">
          <% for (DOGroupResourceRef res : sale.GroupResourceList) { %>
            <%=res.ExtResourceDesc.getHtmlString()%> (<%=res.ExtResourceHold.getHtmlString()%>)<br/>
          <% } %>
        </v:recap-item>
      </v:widget-block>

      <v:widget-block include="<%=!sale.SaleStatus.isLookup(LkSNSaleStatus.Completed)%>">
        <% String sTickets = pageBase.getLang().Ticket.Tickets.getText() + " (" + pageBase.getLang().Common.Used.getText().toLowerCase() + " / " + pageBase.getLang().Common.Total.getText().toLowerCase() + ")"; %>
        <v:recap-item caption="<%=sTickets%>">
          <%=sale.UsedTicketCount.getInt()%> / <%=sale.TicketCount.getInt()%>
        </v:recap-item>
      
        <v:recap-item caption="@Common.SerialRange" include="<%=!sale.TicketSerialMin.isNull()%>">
          <%=sale.TicketSerialMin.getHtmlString()%> &ndash; <%=sale.TicketSerialMax.getHtmlString()%>
        </v:recap-item>
      </v:widget-block>
      
      <v:widget-block>
        <v:recap-item caption="@Common.Items" valueClazz="<%=lineThrough%>"><%=sale.ItemCount.getHtmlString()%></v:recap-item>
        <v:recap-item caption="@Reservation.TotalAmount" valueClazz="<%=lineThrough%>"><%=pageBase.formatCurrHtml(sale.TotalAmount)%></v:recap-item>
        <v:recap-item caption="@Reservation.TotalDiscount" valueClazz="<%=lineThrough%>" include="<%=hasDiscounts%>">(<%=pageBase.formatCurrHtml(sale.TotalDiscount)%>)</v:recap-item>
        <v:recap-item caption="@Reservation.TotalOverPayment" valueClazz="<%=lineThrough%>" include="<%=hasOverPayment%>"><%=pageBase.formatCurrHtml(sale.OverPaymentAmount)%></v:recap-item>
        <v:recap-item caption="@Reservation.PaidAmount" valueClazz="<%=lineThrough%>"><%=pageBase.formatCurrHtml(sale.PaidAmount)%></v:recap-item>
      </v:widget-block>
      
      <v:widget-block include="<%=!sale.LinkedSaleList.isEmpty()%>">
      <% for (DOLinkedSaleRef lnk : sale.LinkedSaleList) { %>
        <v:recap-item caption="<%=lnk.LinkType.getLkValue().getRawDescription()%>">
          <snp:entity-link entityId="<%=lnk.SaleRef.SaleId%>" entityType="<%=LkSNEntityType.Sale%>"><%=lnk.SaleRef.SaleCode.getHtmlString()%></snp:entity-link>
        </v:recap-item>
      <% } %>
      </v:widget-block>
    </v:widget>
  </v:profile-recap>
  
  <v:profile-main>
    <jsp:include page="saleitem_grid_static.jsp"></jsp:include>
    <jsp:include page="sale_discount_grid_static.jsp"></jsp:include>
    
    <% request.setAttribute("listPayment", sale.PaymentList.filter(it -> it.PaymentAmount.getMoney() >= 0)); %>
    <jsp:include page="../payment/payment_grid_static.jsp"><jsp:param name="title" value="@Payment.Payments"/></jsp:include>
    
    <% request.setAttribute("listPayment", sale.PaymentList.filter(it -> it.PaymentAmount.getMoney() < 0)); %>
    <jsp:include page="../payment/payment_grid_static.jsp"><jsp:param name="title" value="@Sale.Refunds"/></jsp:include>
  </v:profile-main>
  
</v:tab-content>


<script>

$(document).ready(function() {
  
  <% if (rights.PahDownloadOption.isLookup(LkSNPahDownloadOption.FirstTimeOnly)) { %>
  $("#btn-download-pah").click(function() {
    setTimeout(function() {
      $("#btn-download-pah").remove();
      if ($(".tab-toolbar .btn").length == 0)
        $(".tab-toolbar").remove();
    }, 0);
  });
  <% } %>
  
});

function showInvoiceIssueDialog() {
  var params = "SaleId=" + <%=JvString.jsString(pageBase.getId())%> + "&AccountId=" + <%=sale.OwnerAccount.AccountId.getJsString()%>;
  asyncDialogEasy("invoice/invoice_issue_dialog", params);
}

function showSaleCancellationDialog() {
  asyncDialog({url:"<%=pageBase.getContextURL()%>?page=sale_cancellation_dialog&SaleId=<%=pageBase.getId()%>"});
}

function showSeats(saleItemId) {
  asyncDialogEasy("seat/seat_list_dialog", "SaleItemId=" + saleItemId);
}

function showDiscounts(saleItemId) {
  asyncDialogEasy("product/discount_list_dialog", "SaleItemId=" + saleItemId);
}

function getDocExecParams() {
  return "lock_in_params=true&p_SaleId=<%=pageBase.getId()%>";
}
  
</script>