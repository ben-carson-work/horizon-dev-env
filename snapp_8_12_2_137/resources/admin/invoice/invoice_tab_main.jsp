<%@page import="com.vgs.web.library.product.NSystemProduct"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.database.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="java.util.stream.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
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

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageInvoice" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="invoice" class="com.vgs.snapp.dataobject.DOInvoice" scope="request"/>

<%
boolean bko = pageBase.isVgsContext("BKO");
boolean voidButtonEnabled = bko && InvoiceUtils.isEnabled_Void(invoice, rights);
boolean writeOffButtonEnabled = bko && InvoiceUtils.isEnabled_WriteOff(invoice, rights);
boolean restoreButtonEnabled = bko && InvoiceUtils.isEnabled_Restore(invoice, rights); 
boolean downloadButtonEnabled = bko && InvoiceUtils.isEnabled_Download(invoice, rights); 
boolean changeDueDateButtonEnabled = 
    bko && 
    invoice.InvoiceStatus.isLookup(LkSNInvoiceStatus.Issued, LkSNInvoiceStatus.PartiallySettled) && 
    pageBase.getRights().InvoiceChangeDueDate.getBoolean() && 
    (invoice.UnsettledPaymentCount.getInt() > 0);
%>

<div class="tab-toolbar">
  <snp:notes-btn entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.Invoice%>"/>
  <v:button 
    id="btn-download" 
    caption="@Common.Download" fa="file-pdf" target="_new" href="<%=ConfigTag.getValue(\"site_url\") + \"/repository?entityId=\" + pageBase.getId() + \"&entityType=\" + LkSNEntityType.Invoice.getCode() + \"&repositoryCode=\" + invoice.InvoiceCode.getHtmlString()%>"
    enabled="<%=downloadButtonEnabled%>"
  />

  <div class="btn-group">
    <v:button caption="@Common.Actions" dropdown="true" fa="flag"/>
    <v:popup-menu bootstrap="true">
      <% String hrefWriteOff = "javascript:showInvoiceTransactionDialog(" + LkSNTransactionType.InvoiceWriteOff.getCode() + ")";%>     
      <v:popup-item caption="@Invoice.InvoiceWriteOff" fa="handshake-slash" onclick="<%=hrefWriteOff%>" enabled="<%=writeOffButtonEnabled%>"/>
      <% String hrefRestore = "javascript:showInvoiceTransactionDialog(" + LkSNTransactionType.InvoiceRestore.getCode() + ")";%>     
      <v:popup-item caption="@Invoice.InvoiceRestore" fa="history" onclick="<%=hrefRestore%>" enabled="<%=restoreButtonEnabled%>"/>
      <% String hrefVoid = "javascript:showInvoiceTransactionDialog(" + LkSNTransactionType.InvoiceVoid.getCode() + ")";%>     
      <v:popup-item caption="@Common.Void" fa="times" onclick="<%=hrefVoid%>" enabled="<%=voidButtonEnabled%>"/>
      <% String hrefDueDate = "javascript:showInvoiceTransactionDialog(" + LkSNTransactionType.InvoiceDueDateChange.getCode() + ")";%>     
      <v:popup-item caption="@Invoice.DueDate" fa="calendar" onclick="<%=hrefDueDate%>" enabled="<%=changeDueDateButtonEnabled%>"/>
    </v:popup-menu>
  </div>
</div>
<div class="tab-content">
<v:last-error/>

  <div class="profile-pic-div">    
    <v:widget caption="@Common.Profile">
      <v:widget-block>
        <div class="recap-value-item">
          <v:itl key="@Common.Code"/> 
          <span class="recap-value"><%=invoice.InvoiceCode.getHtmlString()%></span>
        </div>

        <div class="recap-value-item">
          <% String sStatusStyle = invoice.InvoiceStatus.isLookup(LkSNInvoiceStatus.Voided) ? "style=\"color:var(--base-red-color)\"" : ""; %>
          <v:itl key="@Common.Status"/>
          <span class="recap-value" <%=sStatusStyle%>><%=invoice.InvoiceStatus.getHtmlLookupDesc(pageBase.getLang())%></span>
        </div>
        
        <div class="recap-value-item">
          <v:itl key="@Invoice.DueDate"/>
          <span class="recap-value"><%=invoice.DueDate.formatHtml(pageBase.getShortDateFormat())%></span>
        </div>

        <% if (invoice.NegativePaymentCount.getInt() > 0) { %>
        <br/>
        <div class="recap-value-item">
          <span class="recap-value" style="color:var(--base-red-color)"><v:itl key="@Invoice.OrdersWithNegativePayments"/></span>
        </div>  
        <%} %>      
      </v:widget-block>
             
      <v:widget-block>
        <div class="recap-value-item">
          <v:itl key="@Account.Account"/>
          <span class="recap-value">
            <snp:entity-link entityId="<%=invoice.AccountId%>" entityType="<%=invoice.AccountEntityType%>"><%=invoice.AccountName.getHtmlString()%></snp:entity-link>
          </span>
        </div>
      </v:widget-block>
      
      <v:widget-block>
        <div class="recap-value-item">
          <v:itl key="@Invoice.IssueDate"/>
          <span class="recap-value"><%=invoice.IssueFiscalDate.formatHtml(pageBase.getShortDateFormat())%></span>
        </div>
        <div class="recap-value-item">
          <v:itl key="@Invoice.IssueDateTime"/>
          <span class="recap-value"><snp:datetime timestamp="<%=invoice.IssueDateTime%>" format="shortdatetime" timezone="local"/></span>
        </div>
        <div class="recap-value-item">
          <v:itl key="@Account.Location"/>
          <span class="recap-value"><snp:entity-link entityId="<%=invoice.LocationId%>" entityType="<%=LkSNEntityType.Location%>"><%=invoice.LocationName.getHtmlString()%></snp:entity-link></span>
        </div>
        <div class="recap-value-item">
          <v:itl key="@Account.OpArea"/>
          <span class="recap-value"><snp:entity-link entityId="<%=invoice.OpAreaId%>" entityType="<%=LkSNEntityType.OperatingArea%>"><%=invoice.OpAreaName.getHtmlString()%></snp:entity-link></span>
        </div>
        <div class="recap-value-item">
          <v:itl key="@Common.Workstation"/>
          <span class="recap-value"><snp:entity-link entityId="<%=invoice.WorkstationId%>" entityType="<%=LkSNEntityType.Workstation%>"><%=invoice.WorkstationName.getHtmlString()%></snp:entity-link></span>
        </div>
      </v:widget-block>
           
      
      <v:widget-block>
        <div class="recap-value-item">
          <v:itl key="@Common.Items"/>
          <span class="recap-value"><%=invoice.ItemCount.getHtmlString() %></span>
        </div>
        <div class="recap-value-item">
          <v:itl key="@Invoice.TotalAmount"/>
          <span class="recap-value"><%=pageBase.formatCurrHtml(invoice.TotalAmount)%></span>
        </div>
        <div class="recap-value-item">
          <v:itl key="@Invoice.TotalTax"/>
          <span class="recap-value"><%=pageBase.formatCurrHtml(invoice.TotalTax)%></span>
        </div>
        <div class="recap-value-item">
          <v:itl key="@Invoice.SettledAmount"/>
          <span class="recap-value"><%=pageBase.formatCurrHtml(invoice.SettledAmount)%></span>
        </div>
        <div class="recap-value-item">
          <v:itl key="@Invoice.UnsettledAmount"/>
          <% String style = LkSNInvoiceStatus.isGroup(invoice.InvoiceStatus.getLkValue(), LkSNInvoiceStatus.NInvoiceStatusGroup.VOIDED) ? "text-decoration:line-through" : ""; %>          
          <span class="recap-value" style="<%=style%>"><%=pageBase.formatCurrHtml(invoice.UnsettledAmount)%></span>
        </div>

      </v:widget-block>

    </v:widget>
  </div>
  <div class="profile-cont-div">
    <v:grid>
      <thead>
        <v:grid-title caption="@Common.Items"/>
        <tr>
          <td>&nbsp;</td>
          <td width="40%">
            <v:itl key="@Product.ProductType"/> &mdash; <v:itl key="@Common.Options"/><br/>
            <v:itl key="@Performance.Performance"/>
          </td>
          <td width="20%">
            <v:itl key="@Reservation.Discount"/>
          </td>
          <td width="10%" align="right">
            <v:itl key="@Common.Deposit"/>
          </td>
          <td width="10%" align="right">
            <v:itl key="@Invoice.UnitAmount"/><br/>
            <v:itl key="@Invoice.UnitTax"/>
          </td>
          <td width="10%" align="right">
            <v:itl key="@Common.Quantity"/>
          </td>
          <td width="10%" align="right">
            <v:itl key="@Invoice.TotalAmount"/><br/>
            <v:itl key="@Invoice.TotalTax"/>
          </td>
        </tr>
      </thead>
      <tbody>
      <% String lastSaleId = null; %>
      <% for (DOInvoice.DOInvoiceItem item : invoice.ItemList) { %>
        <% if (!item.SaleId.isSameString(lastSaleId)) { %>
          <% lastSaleId = item.SaleId.getString(); %>
          <tr class="group" data-entitytype="" data-entityid="">
            <td colspan="100%">
              <v:itl key="@Sale.PNR"/>&nbsp;
              <snp:entity-link entityId="<%=item.SaleId%>" entityType="<%=LkSNEntityType.Sale%>">
                <%=item.SaleCode.getHtmlString()%>
              </snp:entity-link>
            </td>
          </tr>
        <% } %>      
        <tr class="grid-row">
          <td><v:grid-icon name="<%=item.IconName.getString()%>" repositoryId="<%=item.ProductProfilePictureId.getString()%>"/></td>
          <td>
            <snp:entity-link entityId="<%=item.ProductId%>" entityType="<%=item.ProductEntityType%>">
              [<%=item.ProductCode.getHtmlString()%>] <%=item.ProductName.getHtmlString()%>
            </snp:entity-link>
            <% if (item.OptionsDesc.getEmptyString().length() > 0) { %>
              &mdash; <%=item.OptionsDesc.getHtmlString()%>
            <% } %>
            <% if (item.SlaveItemCount.getInt() != 0) { %>
              <% String jspSaleItemStats = "sale/saleitem_stat_tooltip&SaleItemId=" + item.SaleItemId.getHtmlString(); %>
              &mdash; <span class="infoicon-stats v-tooltip" data-jsp="<%=jspSaleItemStats %>"></span>
            <% } %>
            <br/>
            <span class="list-subtitle">
            <% if (!item.DepositAccountId.isNull()) { %>
              <snp:entity-link entityId="<%=item.DepositAccountId%>" entityType="<%=LkSNEntityType.Organization%>">
                <%=item.DepositAccountName.getHtmlString()%>
              </snp:entity-link>
            <% } else if (!item.PerformanceId.isNull()) { %>
              <snp:entity-link entityId="<%=item.EventId%>" entityType="<%=LkSNEntityType.Event%>"><%=item.EventName.getHtmlString()%></snp:entity-link> &raquo;
              <% if (!item.AdmLocationId.isNull()) { %>
                <snp:entity-link entityId="<%=item.AdmLocationId%>" entityType="<%=LkSNEntityType.Location%>"><%=item.AdmLocationName.getHtmlString()%></snp:entity-link> &raquo;
              <% } %>
              <snp:entity-link entityId="<%=item.PerformanceId%>" entityType="<%=LkSNEntityType.Performance%>"><%=item.PerformanceDateTime.formatHtml(pageBase.getShortDateTimeFormat())%></snp:entity-link>
              <% if (item.SeatHoldItemCount.getInt() > 0) { %>
                <a href="javascript:showSeats('<%=item.SaleItemId.getEmptyString()%>')">(<v:itl key="@Seat.Seats"/>)</a>
              <% } %>
            <% } else if (!item.ResourceHoldId.isNull()) { %>
              <%=item.ResourceDateTimeFrom.formatHtml(pageBase.getShortDateTimeFormat())%> -
              <%=item.ResourceDateTimeTo.formatHtml(pageBase.getShortDateTimeFormat())%> 
            <% } else { %>
              <v:itl key="@Common.None"/>
            <% } %>
            </span>
          </td>
          <td>
            <% if (item.DiscountCount.getInt() > 0) { %>
              <a href="javascript:showDiscounts('<%=item.SaleItemId.getEmptyString()%>')"><%=pageBase.formatCurrHtml(item.TotalDiscount)%></a>
            <% } %>
          </td>
          <td align="right">
            <%=pageBase.formatCurrHtml(item.WalletDeposit)%>
          </td>
          <td align="right">
            <%=pageBase.formatCurrHtml(item.UnitAmount)%><br/>
            <%
            boolean hasTaxes = (item.TaxCount.getInt() != 0); 
            String taxTooltipClass = hasTaxes ? " v-tooltip" : "";
            String dataJsp = hasTaxes ? " data-jsp=\"sale/saleitem_tax_tooltip&SaleItemId=" + item.SaleItemId.getHtmlString() + "\"" : "";
            %>
            <span class="list-subtitle <%=taxTooltipClass%>" <%=dataJsp%>><%=pageBase.formatCurrHtml(item.UnitTax)%></span>
          </td>
          <td align="right">
            <%=item.Quantity.getEmptyString()%>
          </td>
          <% boolean isExtraTime = (item.ProductCode.isSameString(NSystemProduct.ExtraTime.getProductCode())); %>
          <td align="right">
            <% if (isExtraTime) { %>
              <% String jspTimedTicket = "product/timedticket/timedticketstatement_tooltip&SaleItemId=" + item.SaleItemId.getHtmlString(); %>
              <span class="v-tooltip" data-jsp="<%=jspTimedTicket%>">
                <%=pageBase.formatCurrHtml(item.TotalAmount)%><br/>
              </span>
            <% } else {%>
            <%=pageBase.formatCurrHtml(item.TotalAmount.getMoney() + item.WalletDeposit.getMoney())%><br/>
            <% }%>
            <span class="list-subtitle"><%=pageBase.formatCurrHtml(item.TotalTax)%></span>
          </td>
        </tr>
      <% } %>
        
      </tbody>
    </v:grid>
    
    <% request.setAttribute("listPayment", invoice.PaymentList.filter(it -> it.Settled.getBoolean()).stream().map(it -> it.Payment).collect(Collectors.toList())); %>
    <jsp:include page="../payment/payment_grid_static.jsp"><jsp:param name="title" value="@Payment.SettledPayments"/></jsp:include>
    
    <% request.setAttribute("listPayment", invoice.PaymentList.filter(it -> it.Payment.CreditLine.CreditStatus.isLookup(LkSNCreditStatus.WrittenOff)).stream().map(it -> it.Payment).collect(Collectors.toList())); %>
    <jsp:include page="../payment/payment_grid_static.jsp"><jsp:param name="title" value="@CreditStatus.WrittenOff"/></jsp:include>
    
    <% request.setAttribute("listPayment", invoice.PaymentList.filter(it -> it.Payment.CreditLine.CreditStatus.isLookup(LkSNCreditStatus.Opened, LkSNCreditStatus.Invoiced)).stream().map(it -> it.Payment).collect(Collectors.toList())); %>
    <jsp:include page="../payment/payment_grid_static.jsp"><jsp:param name="title" value="@Payment.UnsettledPayments"/></jsp:include>
    
  </div>    
</div>

<script>
//# sourceURL=invoice_tab_main.jsp

  function showInvoiceTransactionDialog(transactionType) {
    var params = "invoiceIDs=" + <%=JvString.jsString(pageBase.getId())%> + "&transactionType=" + transactionType;
    asyncDialogEasy("invoice/invoice_action_dialog", params);
  }
  
  function showSeats(saleItemId) {
    asyncDialogEasy("seat/seat_list_dialog", "SaleItemId=" + saleItemId);
  }

  function showDiscounts(saleItemId) {
    asyncDialogEasy("product/discount_list_dialog", "SaleItemId=" + saleItemId);
  }

</script>
