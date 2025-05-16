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

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.b2b.page.PageB2B_Invoice" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="invoice" class="com.vgs.snapp.dataobject.DOInvoice" scope="request"/>

<div class="tab-toolbar">
  <snp:notes-btn entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.Invoice%>"/>
  <v:button id="btn-download" caption="@Common.Download" fa="file-pdf" target="_new" href="<%=ConfigTag.getValue(\"site_url\") + \"/repository?entityId=\" + pageBase.getId() + \"&entityType=\" + LkSNEntityType.Invoice.getCode() + \"&repositoryCode=\" + invoice.InvoiceCode.getHtmlString()%>"/>
</div>

<div class="tab-content">

  <div class="profile-pic-div">    
    <v:widget caption="@Common.Profile">
      <v:widget-block>
        <v:recap-item caption="@Common.Code"><%=invoice.InvoiceCode.getHtmlString()%></v:recap-item>
        <% if (!invoice.InvoiceStatus.isLookup(LkSNInvoiceStatus.AutoSettled)) { %>
          <v:recap-item caption="@Common.Status" valueColor="<%=invoice.InvoiceStatus.isLookup(LkSNInvoiceStatus.Voided) ? \"red\" : \"\"%>"><%=invoice.InvoiceStatus.getHtmlLookupDesc(pageBase.getLang())%></v:recap-item>
        <% } %>
        <v:recap-item caption="@Invoice.DueDate"><%=invoice.DueDate.formatHtml(pageBase.getShortDateFormat())%></v:recap-item>

        <% if (invoice.NegativePaymentCount.getInt() > 0) { %>
          <v:recap-item valueColor="red"><v:itl key="@Invoice.OrdersWithNegativePayments"/></v:recap-item>
        <%} %>      
      </v:widget-block>
      
      <v:widget-block>
        <v:recap-item caption="@Invoice.IssueDate"><%=invoice.IssueFiscalDate.formatHtml(pageBase.getShortDateFormat())%></v:recap-item>
        <v:recap-item caption="@Invoice.IssueDateTime"><snp:datetime timestamp="<%=invoice.IssueDateTime%>" format="shortdatetime" timezone="local"/></v:recap-item>
      </v:widget-block>
           
      
      <v:widget-block>
        <% String voidStrikeThroughStyle = LkSNInvoiceStatus.isGroup(invoice.InvoiceStatus.getLkValue(), LkSNInvoiceStatus.NInvoiceStatusGroup.VOIDED) ? "text-decoration:line-through" : ""; %>
        <v:recap-item caption="@Common.Items"><%=invoice.ItemCount.getHtmlString()%></v:recap-item>
        <v:recap-item caption="@Invoice.TotalAmount"><%=pageBase.formatCurrHtml(invoice.TotalAmount)%></v:recap-item>
        <v:recap-item caption="@Invoice.TotalTax"><%=pageBase.formatCurrHtml(invoice.TotalTax)%></v:recap-item>
        <v:recap-item caption="@Invoice.SettledAmount"><%=pageBase.formatCurrHtml(invoice.SettledAmount)%></v:recap-item>
        <v:recap-item caption="@Invoice.UnsettledAmount" valueStyle="<%=voidStrikeThroughStyle%>"><%=pageBase.formatCurrHtml(invoice.UnsettledAmount)%></v:recap-item>
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
            [<%=item.ProductCode.getHtmlString()%>] <%=item.ProductName.getHtmlString()%>
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
              <%=item.DepositAccountName.getHtmlString()%>
            <% } else if (!item.PerformanceId.isNull()) { %>
              <%=item.EventName.getHtmlString()%> &raquo;
              <% if (!item.AdmLocationId.isNull()) { %>
                <%=item.AdmLocationName.getHtmlString()%> &raquo;
              <% } %>
              <%=item.PerformanceDateTime.formatHtml(pageBase.getShortDateTimeFormat())%>
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
    
    
    <v:grid>
      <thead>
        <v:grid-title caption="@Payment.Payments"/>
        <tr>
          <td>&nbsp;</td>
          <td width="30%">
            <v:itl key="@Payment.PaymentMethod"/><br/>
            <v:itl key="@Common.Description"/>
          </td>
          <td width="30%" valign="top">
            <v:itl key="@Common.Status"/><br/>
            <v:itl key="@Payment.AuthorizationCode"/>
          </td>
          <td width="40%" align="right">
            <v:itl key="@Common.Amount"/>
          </td>
        </tr>
      </thead>
      
      <tbody>
      <% String lastGroup = null; %>
      <% for (DOInvoice.DOInvoicePayment invoicePaymentDO : invoice.PaymentList) { %>
        <% 
        DOPaymentRef pay = invoicePaymentDO.Payment;
        if (!invoicePaymentDO.GroupDesc.isSameString(lastGroup)) {
          lastGroup = invoicePaymentDO.GroupDesc.getString();
          %><v:grid-group><v:itl key="<%=lastGroup%>"/></v:grid-group><%
        }
        %>
        <tr>
          <td style="<v:common-status-style status="<%=pay.CommonStatus%>"/>">
            <v:grid-icon name="<%=pay.IconName.getString()%>" iconAlias="<%=pay.IconAlias.getString()%>" foregroundColor="<%=pay.ForegroundColor.getString()%>" backgroundColor="<%=pay.BackgroundColor.getString()%>"/>
          </td>
          <td>
            <div class="list-title"><%=pay.PaymentMethodName.getHtmlString()%></div>
            <div class="list-subtitle"><%=pay.PaymentDesc.getHtmlString()%></div>
          </td>
          <td>
            <div><%=pay.PaymentStatusDesc.getHtmlString()%></div>
            <% if (pay.CreditCard.AuthorizationCode.isNull()) { %>
              &mdash;
            <% } else { %>
              <div class="list-subtitle"><%=pay.CreditCard.AuthorizationCode.getHtmlString()%></div>
            <% } %>
          </td>
          <td align="right">
            <div>
              <% if (pay.Change.getBoolean()) { %>
                <span class="list-subtitle">(<v:itl key="@Payment.Change" transform="lowercase"/>)</span>
              <% } %>
            
              <% String style = pay.PaymentAmountStrikethrough.getBoolean() ? "text-decoration:line-through" : "";  %>
              <span style="<%=style%>"><%=pageBase.formatCurrHtml(pay.PaymentAmount)%></span>
            </div>
            <div class="list-subtitle"><%=pay.PaymentAmountExt.getHtmlString()%></div>
          </td>
        </tr>
      <% } %>
      </tbody>
    </v:grid>

  </div>    
</div>

<script>
//# sourceURL=invoice_tab_main.jsp
 
  function showSeats(saleItemId) {
    asyncDialogEasy("seat/seat_list_dialog", "SaleItemId=" + saleItemId);
  }

  function showDiscounts(saleItemId) {
    asyncDialogEasy("product/discount_list_dialog", "SaleItemId=" + saleItemId);
  }

</script>
