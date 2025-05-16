<%@page import="com.vgs.web.library.product.NSystemProduct"%>
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
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.b2b.page.PageB2B_Sale" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
QueryDef qdefSale = new QueryDef(QryBO_Sale.class);
// Select
qdefSale.addSelect(QryBO_Sale.Sel.SaleId);
qdefSale.addSelect(QryBO_Sale.Sel.SaleCode);
qdefSale.addSelect(QryBO_Sale.Sel.Flags);
qdefSale.addSelect(QryBO_Sale.Sel.SaleB2BStatus);
qdefSale.addSelect(QryBO_Sale.Sel.ShipAccountId);
qdefSale.addSelect(QryBO_Sale.Sel.ShipAccountName);
qdefSale.addSelect(QryBO_Sale.Sel.SaleCalcStatus);
qdefSale.addSelect(QryBO_Sale.Sel.SaleFiscalDate);
qdefSale.addSelect(QryBO_Sale.Sel.SaleDateTime);
qdefSale.addSelect(QryBO_Sale.Sel.UserAccountName);
qdefSale.addSelect(QryBO_Sale.Sel.UserAccountParentId);
qdefSale.addSelect(QryBO_Sale.Sel.ItemCount);
qdefSale.addSelect(QryBO_Sale.Sel.TotalAmount);
qdefSale.addSelect(QryBO_Sale.Sel.PaidAmount);
// Filter
qdefSale.addFilter(QryBO_Sale.Fil.SaleId, pageBase.getId());
// Exec
JvDataSet dsSale = pageBase.execQuery(qdefSale);

LookupItem saleStatus = LkSN.SaleStatus.getItemByCode(dsSale.getField(QryBO_Sale.Sel.SaleStatus));
LookupItem saleB2BStatus = LkSN.SaleB2BStatus.getItemByCode(dsSale.getField(QryBO_Sale.Sel.SaleB2BStatus));
String lineThrough = saleStatus.isLookup(LkSNSaleStatus.Deleted) ? "line-through" : "";


QueryDef qdefSI = new QueryDef(QryBO_SaleItem.class);
//Select
qdefSI.addSelect(QryBO_SaleItem.Sel.IconName);
qdefSI.addSelect(QryBO_SaleItem.Sel.SaleItemId);
qdefSI.addSelect(QryBO_SaleItem.Sel.ProductId);
qdefSI.addSelect(QryBO_SaleItem.Sel.ProductCode);
qdefSI.addSelect(QryBO_SaleItem.Sel.ProductName);
qdefSI.addSelect(QryBO_SaleItem.Sel.PromoProductId);
qdefSI.addSelect(QryBO_SaleItem.Sel.PromoProductCode);
qdefSI.addSelect(QryBO_SaleItem.Sel.PromoProductName);
qdefSI.addSelect(QryBO_SaleItem.Sel.Quantity);
qdefSI.addSelect(QryBO_SaleItem.Sel.UnitAmount);
qdefSI.addSelect(QryBO_SaleItem.Sel.UnitTax);
qdefSI.addSelect(QryBO_SaleItem.Sel.TotalAmount);
qdefSI.addSelect(QryBO_SaleItem.Sel.TotalTax);
qdefSI.addSelect(QryBO_SaleItem.Sel.WalletDeposit);
qdefSI.addSelect(QryBO_SaleItem.Sel.PerformanceCount);
qdefSI.addSelect(QryBO_SaleItem.Sel.PerformanceId);
qdefSI.addSelect(QryBO_SaleItem.Sel.PerformanceDateTime);
qdefSI.addSelect(QryBO_SaleItem.Sel.EventId);
qdefSI.addSelect(QryBO_SaleItem.Sel.EventName);
qdefSI.addSelect(QryBO_SaleItem.Sel.AdmLocationId);
qdefSI.addSelect(QryBO_SaleItem.Sel.AdmLocationName);
qdefSI.addSelect(QryBO_SaleItem.Sel.SeatHoldItemCount);
qdefSI.addSelect(QryBO_SaleItem.Sel.OptionsDesc);
qdefSI.addSelect(QryBO_SaleItem.Sel.ResourceHoldId);
qdefSI.addSelect(QryBO_SaleItem.Sel.ResourceDateTimeFrom);
qdefSI.addSelect(QryBO_SaleItem.Sel.ResourceDateTimeTo);
//Where
qdefSI.addFilter(QryBO_SaleItem.Fil.SaleId, pageBase.getId());
qdefSI.addFilter(QryBO_SaleItem.Fil.NonStatOnly, "true");
qdefSI.addFilter(QryBO_SaleItem.Fil.ExcludeDepositProductId, "true");
qdefSI.addFilter(QryBO_SaleItem.Fil.ExcludeOverPayProductId, "true");
qdefSI.addFilter(QryBO_SaleItem.Fil.ExcludeWalletDepositProductId, "true");
//Exec
JvDataSet dsItem = pageBase.execQuery(qdefSI);


QueryDef qdefPay = new QueryDef(QryBO_Payment.class);
// Select
qdefPay.addSelect(QryBO_Payment.Sel.IconName);
qdefPay.addSelect(QryBO_Payment.Sel.PaymentStatus);
qdefPay.addSelect(QryBO_Payment.Sel.TransactionId);
qdefPay.addSelect(QryBO_Payment.Sel.TransactionCode);
qdefPay.addSelect(QryBO_Payment.Sel.PaymentMethodName);
qdefPay.addSelect(QryBO_Payment.Sel.PaymentDesc);
qdefPay.addSelect(QryBO_Payment.Sel.PaymentAmount);
qdefPay.addSelect(QryBO_Payment.Sel.CurrencyISO);
qdefPay.addSelect(QryBO_Payment.Sel.CurrencyAmount);
// Filter
qdefPay.addFilter(QryBO_Payment.Fil.SaleId, pageBase.getId());
qdefPay.addFilter(QryBO_Payment.Fil.ExcludeDepositPaymentId, "true");
// Sort
qdefPay.addSort(QryBO_Payment.Sel.TransactionDateTime);
// Exec
JvDataSet dsPay = pageBase.execQuery(qdefPay);


QueryDef qdefTrn = new QueryDef(QryBO_Transaction.class);
// Select
qdefTrn.addSelect(QryBO_Transaction.Sel.IconName);
qdefTrn.addSelect(QryBO_Transaction.Sel.TransactionId);
qdefTrn.addSelect(QryBO_Transaction.Sel.TransactionDateTime);
qdefTrn.addSelect(QryBO_Transaction.Sel.TransactionCode);
qdefTrn.addSelect(QryBO_Transaction.Sel.TransactionType);
qdefTrn.addSelect(QryBO_Transaction.Sel.WorkstationId);
qdefTrn.addSelect(QryBO_Transaction.Sel.WorkstationType);
qdefTrn.addSelect(QryBO_Transaction.Sel.LocationAccountName);
qdefTrn.addSelect(QryBO_Transaction.Sel.UserAccountName);
// Filter
qdefTrn.addFilter(QryBO_Transaction.Fil.SaleId, pageBase.getId());
// Sort
qdefTrn.addSort(QryBO_Transaction.Sel.TransactionFiscalDate, false);
qdefTrn.addSort(QryBO_Transaction.Sel.TransactionDateTime, false);
// Exec
JvDataSet dsTrn = pageBase.execQuery(qdefTrn);
%>

<script>
var shipAccountId = <%=JvString.jsString(dsSale.getField(QryBO_Sale.Sel.ShipAccountId).getString())%>;
function doShowShipAccountDialog() {
  asyncDialogEasy("account/account_dialog", "CallbackId=account-saved&id=" + ((shipAccountId == null) ? "new" : shipAccountId));
}

$(document).on("account-saved", function(event, data) {
  if (shipAccountId == null) {
    vgsService("Sale", {
      Command: "AddAccount",
      AddAccount: {
        SaleId: <%=JvString.jsString(pageBase.getId())%>,
        AccountId: data.AccountId,
        SaleAccountType: <%=LkSNSaleAccountType.Guest.getCode()%>
      }
    });
  }
  shipAccountId = data.AccountId;  
  $("#ship-account").text(data.AccountName);
});

$(document).ready(function() {
  <% if (rights.B2BAgent_PahDownloadOption.isLookup(LkSNPahDownloadOption.FirstTimeOnly)) { %>
  $("#btn-download-pah").click(function() {
    setTimeout(function() {
      $("#btn-download-pah").remove();
      if ($(".tab-toolbar .btn").length == 0)
        $(".tab-toolbar").remove();
    }, 0);
  });
  <% } %>
});

function getDocExecParams() {
  return "lock_in_params=true&p_SaleId=<%=pageBase.getId()%>";
}
</script>

<%
boolean showEditButton = saleStatus.isLookup(LkSNSaleStatus.Normal) && !dsSale.getField(QryBO_Sale.Sel.Validated).getBoolean();
boolean showPahButton = pageBase.getBLDef().canDownloadPrintAtHome(pageBase.getId(), saleStatus);
boolean showInvoiceButton = saleStatus.isLookup(LkSNSaleStatus.Normal) && dsSale.getField(QryBO_Sale.Sel.Paid).getBoolean();
%>

<% if (showEditButton || showPahButton || showInvoiceButton) { %>
  <div class="tab-toolbar">
    <% if (showEditButton) { %>
      <% String hrefEdit = pageBase.getContextURL() + "?page=shopcart#" + pageBase.getId(); %>
      <v:button caption="@Common.Edit" href="<%=hrefEdit%>"/>
    <% } %>

    <% if (showPahButton) { %>
      <v:button id="btn-download-pah" clazz="no-ajax" caption="@Common.PrintAtHome" fa="file-pdf" target="_new" href="<%=pageBase.buildURL_DownloadPah(pageBase.getId())%>"/>
    <% } %>

    <% if (showInvoiceButton) { %>
      <snp:btn-report docContext="<%=LkSNContextType.Sale_Invoice%>" caption="@Payment.Invoice"/>
    <% } %>
  </div>
<% } %>

<div class="tab-content">
  <v:last-error/>
  <div class="profile-pic-div">
    <v:widget caption="@Common.Profile">
      <v:widget-block>
        <v:itl key="@Sale.PNR"/> <span class="recap-value"><%=dsSale.getField(QryBO_Sale.Sel.SaleCode).getHtmlString()%></span><br/>
        <v:itl key="@Reservation.Flags"/><span class="recap-value"><%= dsSale.getField(QryBO_Sale.Sel.Flags).getHtmlString() %></span><br/>
        <v:itl key="@Common.Status"/><span class="recap-value"><%=saleB2BStatus.getHtmlDescription(pageBase.getLang())%></span><br/>
        <v:itl key="@Lookup.SaleAccountType.Guest"/>
        <span class="recap-value">
          <a id="ship-account" href="javascript:doShowShipAccountDialog()">
            <% if (dsSale.getField(QryBO_Sale.Sel.ShipAccountId).isNull()) { %>
              <v:itl key="@Account.AnonymousAccount"/>
            <% } else { %>
              <%=dsSale.getField(QryBO_Sale.Sel.ShipAccountName).getHtmlString()%>
            <% } %>
          </a>
        </span>
      </v:widget-block>
      <v:widget-block>
        <v:itl key="@Common.FiscalDate"/><span class="recap-value"><%=pageBase.format(dsSale.getField(QryBO_Sale.Sel.SaleFiscalDate), pageBase.getShortDateFormat())%></span><br/>
        <v:itl key="@Common.DateTime"/><span class="recap-value"><snp:datetime timestamp="<%=dsSale.getField(QryBO_Sale.Sel.SaleDateTime)%>" format="shortdatetime" timezone="local"/></span><br/>
        <% if (dsSale.getField(QryBO_Sale.Sel.UserAccountParentId).isSameString(pageBase.getSession().getOrgAccountId())) { %>
          <v:itl key="@Common.User"/><span class="recap-value"><%=dsSale.getField(QryBO_Sale.Sel.UserAccountName).getHtmlString()%></span><br/>
        <% } %>
      </v:widget-block>
      <v:widget-block>
        <v:itl key="@Common.Items"/><span class="recap-value <%=lineThrough%>"><%= dsSale.getField(QryBO_Sale.Sel.ItemCount).getHtmlString() %></span><br/>
        <v:itl key="@Reservation.TotalAmount"/><span class="recap-value <%=lineThrough%>"><%=pageBase.formatCurrHtml(dsSale.getField(QryBO_Sale.Sel.TotalAmount))%></span><br/>
        <v:itl key="@Reservation.PaidAmount"/><span class="recap-value <%=lineThrough%>"><%=pageBase.formatCurrHtml(dsSale.getField(QryBO_Sale.Sel.PaidAmount))%></span><br/>
      </v:widget-block>
    </v:widget>
    
    <v:grid>
      <v:grid-title caption="@Common.Transactions"/>
      <v:grid-row dataset="<%=dsTrn%>">
        <td><v:grid-icon name="<%=dsTrn.getField(QryBO_Transaction.Sel.IconName).getString()%>"/></td>
        <td width="100%">
          <snp:datetime timestamp="<%=dsTrn.getField(QryBO_Transaction.Sel.TransactionDateTime)%>" format="shortdatetime" timezone="local"/><br/>
          <span class="list-subtitle">
          <% LookupItem wksType = LkSN.WorkstationType.findItemByCode(dsTrn.getField(QryBO_Transaction.Sel.WorkstationType)); %>
          <% if ((wksType != null) && wksType.isLookup(LkSNWorkstationType.B2B)) { %>
            <%=dsTrn.getField(QryBO_Transaction.Sel.UserAccountName).getHtmlString()%>
          <% } else { %>
            <%=dsTrn.getField(QryBO_Transaction.Sel.LocationAccountName).getHtmlString()%>
          <% } %>
          </span>
        </td>
      </v:grid-row>
    </v:grid>
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
            <v:itl key="@Product.PromoRule"/><br/>
            &nbsp;
          </td>
          <td width="10%" align="right">
            <v:itl key="@Common.Deposit"/>
          </td>
          <td width="10%" align="right">
            <v:itl key="@Reservation.UnitAmount"/><br/>
            <v:itl key="@Reservation.UnitTax"/>
          </td>
          <td width="10%" align="right">
            <v:itl key="@Common.Quantity"/>
          </td>
          <td width="10%" align="right">
            <v:itl key="@Reservation.TotalAmount"/><br/>
            <v:itl key="@Reservation.TotalTax"/>
          </td>
        </tr>
      </thead>
      <tbody>
        <v:grid-row dataset="<%=dsItem%>">
          <td><v:grid-icon name="<%=dsItem.getField(QryBO_Sale.Sel.IconName).getString()%>"/></td>
          <td>
            <%=dsItem.getField(QryBO_SaleItem.Sel.ProductName).getHtmlString()%>
            <% if (dsItem.getField(QryBO_SaleItem.Sel.OptionsDesc).getEmptyString().length() > 0) { %>
              &mdash; <%=dsItem.getField(QryBO_SaleItem.Sel.OptionsDesc).getHtmlString()%>
            <% } %>
            <br/>
            <span class="list-subtitle">
            <% if (!dsItem.getField(QryBO_SaleItem.Sel.PerformanceId).isNull()) { %>
              <%=dsItem.getField(QryBO_SaleItem.Sel.EventName).getHtmlString()%> &raquo;
              <% if (!dsItem.getField(QryBO_SaleItem.Sel.AdmLocationId).isNull()) { %>
                <%=dsItem.getField(QryBO_SaleItem.Sel.AdmLocationName).getHtmlString()%> &raquo;
              <% } %>
              <snp:datetime timestamp="<%=dsItem.getField(QryBO_SaleItem.Sel.PerformanceDateTime)%>" format="shortdatetime" timezone="location" convert="false"/><br/>
              <%-- 
              <% if (dsItem.getField(QryBO_SaleItem.Sel.SeatHoldItemCount).getInt() > 0) { %>
                <a href="javascript:showSeats('<%=dsItem.getField(QryBO_SaleItem.Sel.SaleItemId).getEmptyString()%>')">(<v:itl key="@Seat.Seats"/>)</a>
              <% } %>
              --%>
            <% } else if (!dsItem.getField(QryBO_SaleItem.Sel.ResourceHoldId).isNull()) { %>
              <% dsItem.getField(QryBO_SaleItem.Sel.ResourceDateTimeFrom).setDisplayFormat(pageBase.getShortDateTimeFormat()); %>
              <% dsItem.getField(QryBO_SaleItem.Sel.ResourceDateTimeTo).setDisplayFormat(pageBase.getShortDateTimeFormat()); %>
              <%=dsItem.getField(QryBO_SaleItem.Sel.ResourceDateTimeFrom).getHtmlString()%> -
              <%=dsItem.getField(QryBO_SaleItem.Sel.ResourceDateTimeTo).getHtmlString()%> 
            <% } else { %>
              <v:itl key="@Common.None"/>
            <% } %>
            </span>
          </td>
          <td>
            <% if (!dsItem.getField(QryBO_SaleItem.Sel.PromoProductId).isNull()) { %>
              <%=dsItem.getField(QryBO_SaleItem.Sel.PromoProductName).getHtmlString()%>
            <% } %>
            <br/>
            &nbsp;
          </td>
          <td align="right">
            <%=pageBase.formatCurrHtml(dsItem.getField(QryBO_SaleItem.Sel.WalletDeposit))%>
          </td>
          <td align="right">
            <%=pageBase.formatCurrHtml(dsItem.getField(QryBO_SaleItem.Sel.UnitAmount))%><br/>
            <span class="list-subtitle tax-tooltip" data-SaleItemId="<%=dsItem.getField(QryBO_SaleItem.Sel.SaleItemId).getHtmlString()%>"><%=pageBase.formatCurrHtml(dsItem.getField(QryBO_SaleItem.Sel.UnitTax))%></span>
          </td>
          <td align="right">
            <%=dsItem.getField(QryBO_SaleItem.Sel.Quantity).getEmptyString()%>
          </td>
          <% boolean isExtraTime = (dsItem.getField(QryBO_SaleItem.Sel.ProductCode).isSameString(NSystemProduct.ExtraTime.getProductCode())); %>
          <td align="right">
            <% if (isExtraTime) { %>
              <span class="timedticketstatement-tooltip" data-SaleItemId="<%=dsItem.getField(QryBO_SaleItem.Sel.SaleItemId).getHtmlString()%>">
                <%=pageBase.formatCurrHtml(dsItem.getField(QryBO_SaleItem.Sel.TotalAmount))%><br/>
              </span>
            <% } else {%>
            <%=pageBase.formatCurrHtml(dsItem.getField(QryBO_SaleItem.Sel.TotalAmount))%><br/>
            <% }%>
            <span class="list-subtitle"><%=pageBase.formatCurrHtml(dsItem.getField(QryBO_SaleItem.Sel.TotalTax))%></span>
          </td>
        </v:grid-row>
      </tbody>
    </v:grid>
    
    <% if (!dsPay.isEmpty()) { %>
    <br/>
    <v:grid>
      <thead>
        <v:grid-title caption="@Payment.Payments"/>
        <tr>
          <td></td>
          <td width="20%">
            <v:itl key="@Common.Transaction"/><br/>
            <v:itl key="@Common.Status"/>
          </td>
          <td width="20%">
            <v:itl key="@Payment.PaymentMethod"/><br/>
            <v:itl key="@Common.Description"/>
          </td>
          <td width="60%" align="right">
            <v:itl key="@Common.Amount"/>
          </td>
        </tr>
      </thead>
      <tbody>
        <v:grid-row dataset="<%=dsPay%>">
          <% LookupItem paymentStatus = LkSN.PaymentStatus.getItemByCode(dsPay.getField(QryBO_Payment.Sel.PaymentStatus)); %>
          <td><v:grid-icon name="<%=dsPay.getField(QryBO_Payment.Sel.IconName).getString()%>"/></td>
          <td>
            <%=dsPay.getField(QryBO_Payment.Sel.TransactionCode).getHtmlString()%><br/>
            <span class="list-subtitle"><%=paymentStatus.getHtmlDescription(pageBase.getLang())%></span>&nbsp;
          </td>
          <td>
            <%=dsPay.getField(QryBO_Payment.Sel.PaymentMethodName).getHtmlString()%><br/>
            <span class="list-subtitle"><%=dsPay.getField(QryBO_Payment.Sel.PaymentDesc).getHtmlString()%></span>&nbsp;
          </td>
          <td align="right" valign="top">
            <% String style = paymentStatus.isLookup(LkSNPaymentStatus.Approved) ? "" : "text-decoration:line-through"; %>
            <span style="<%=style%>"><%=pageBase.formatCurrHtml(dsPay.getField(QryBO_Payment.Sel.PaymentAmount))%></span>
            <br/>
            <span class="list-subtitle">
            <% String currencyISO = dsPay.getField(QryBO_Payment.Sel.CurrencyISO).getString(); %>
            <% long currencyAmount = dsPay.getField(QryBO_Payment.Sel.CurrencyAmount).getMoney(); %>
            <% if (currencyISO != null) { %>
              <%=pageBase.getBL(BLBO_Currency.class).formatCurrencyAmount(currencyISO, currencyAmount)%>
            <% } %>
            </span>
          </td>
        </v:grid-row>
      </tbody>
    </v:grid>
    <% } %>
  </div>
</div>