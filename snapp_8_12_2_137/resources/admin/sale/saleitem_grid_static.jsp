<%@page import="com.vgs.web.library.product.NSystemProduct"%>
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

<v:grid>
  <thead>
    <v:grid-title caption="@Common.Items"/>
    <tr>
      <td>&nbsp;</td>
      <% if (sale.FirstTransactionType.isLookup(LkSNTransactionType.UpgradeDowngrade)) { %>
      <td width="30%">
        <v:itl key="@Product.ProductType"/> &mdash; <v:itl key="@Common.Options"/><br/>
        <v:itl key="@Performance.Performance"/>
      </td>
      <td width="15%">
        <v:itl key="@Product.SourceProduct"/>
      </td>
      <td width="15%">
        <v:itl key="@Reservation.Discount"/><br/>
        &nbsp;
      </td>
      <% } else { %>      
      <td width="40%">
        <v:itl key="@Product.ProductType"/> &mdash; <v:itl key="@Common.Options"/><br/>
        <v:itl key="@Performance.Performance"/>
      </td>
      <td width="20%">
        <v:itl key="@Reservation.Discount"/><br/>
        &nbsp;
      </td>
      <% } %>
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
    <% for (DOSale.DOSaleItem item : sale.ItemList) { %>
    <tr class="grid-row">
      <td><v:grid-icon name="<%=item.IconName.getString()%>" repositoryId="<%=item.ProductProfilePictureId.getString()%>"/></td>
      <td>
        <snp:entity-link entityId="<%=item.ProductId%>" entityType="<%=item.ProductEntityType%>">
          [<%=item.ProductCode.getHtmlString()%>] <%=item.ProductName.getHtmlString()%>
        </snp:entity-link>
        <% if (item.GiftCardCardNumber.getEmptyString().length() > 0) { %>
          &mdash; <%=item.GiftCardCardNumber.getHtmlString()%>
        <% } %>
        <% if (item.OptionsDesc.getEmptyString().length() > 0) { %>
          &mdash; <%=item.OptionsDesc.getHtmlString()%>
        <% } %>
        <% if (!item.SettleInstallmentContractId.isNull()) { %>
          &mdash; 
          <snp:entity-link entityId="<%=item.SettleInstallmentContractId%>" entityType="<%=LkSNEntityType.InstallmentContract%>">
            <%=item.SettleInstallmentContractCode.getHtmlString()%>
            #<%=item.SettleInstallmentNumber.getHtmlString()%>
          </snp:entity-link>
        <% } %>
        <% if (!item.StatList.isEmpty()) { %>
          <% 
          String itemStatId = "itemstat_" + item.SaleItemId.getHtmlString(); 
          request.setAttribute("listStat", item.StatList.getItems());
          %>
          <jsp:include page="saleitem_stat_tooltip.jsp"><jsp:param name="id" value="<%=itemStatId%>"/></jsp:include>
          &mdash; <span class="infoicon-stats v-tooltip" <%-- data-jsp="<%=jspSaleItemStats %>"--%> data-content-id="<%=JvString.urlEncode(itemStatId)%>"></span>
        <% } %>

        <% if (!item.DepositAccountId.isNull()) { %>
          <div class="list-subtitle">
            <snp:entity-link entityId="<%=item.DepositAccountId.getString()%>" entityType="<%=LkSNEntityType.Organization%>">
              <%=item.DepositAccountName.getHtmlString()%>
            </snp:entity-link>
          </div>
        <% } %>
        
        <div class="list-subtitle">
          <% if (item.PerformanceList.isEmpty()) { %>
            <v:itl key="@Common.None"/>
          <% } else { %>
            <% for (DOSaleItemPerformanceRef perf : item.PerformanceList) { %>
              <div style="white-space:nowrap">
                <% if (item.PerformanceList.getSize() > 1) { %>
                  &bull;
                <% } %>
                <snp:entity-link entityId="<%=perf.EventId%>" entityType="<%=LkSNEntityType.Event%>"><%=perf.EventName.getHtmlString()%></snp:entity-link> &raquo;
                <snp:entity-link entityId="<%=perf.LocationId%>" entityType="<%=LkSNEntityType.Location%>"><%=perf.LocationName.getHtmlString()%></snp:entity-link> &raquo;
                <snp:entity-link entityId="<%=perf.PerformanceId%>" entityType="<%=LkSNEntityType.Performance%>"><%=pageBase.format(perf.DateTimeFrom, pageBase.getShortDateTimeFormat())%></snp:entity-link>
                <% if (item.SeatHoldItemCount.getInt() > 0) { %>
                  <a href="javascript:showSeats('<%=JvString.coalesce(item.PackageIndividualComponentSaleItemId.getString(), item.SaleItemId.getEmptyString())%>')">(<v:itl key="@Seat.Seats"/>)</a>
                <% } %>
              </div>
            <% } %>
          <% } %>
        </div>
        
        <% for (DOSaleItemResourceScheduleRef rsDO : item.ResourceScheduleList) { %>
          <div class="list-subtitle">
            <% if (!rsDO.ResourceTypeName.isNull()) { %><%=rsDO.ResourceTypeName.getHtmlString()%>:<% } %>
            <% if (rsDO.ExtResourceHold.isNull()) { %>
              <%=pageBase.format(rsDO.DateTimeFrom, pageBase.getShortDateTimeFormat())%> - <%=pageBase.format(rsDO.DateTimeTo, pageBase.getShortDateTimeFormat())%>
            <% } else { %>
              <%=rsDO.ExtResourceDesc.getHtmlString()%> (<%=rsDO.ExtResourceHold.getHtmlString()%>)
            <% } %>
          </div>
        <% } %>
      </td>
      <% if (!item.TicketId.isNull()) { %>
        <td>
          <snp:entity-link entityId="<%=item.TicketId%>" entityType="<%=LkSNEntityType.Ticket%>" clazz="list-title" entityTooltip="false">
            <%=item.TicketCode.getHtmlString()%>
          </snp:entity-link><br/>
        </td>
      <% } %>
      <td>
        <% if (!item.DiscountList.isEmpty()) { %>
          <a href="javascript:showDiscounts('<%=item.SaleItemId.getEmptyString()%>')"><%=pageBase.formatCurrHtml(item.TotalDiscount)%></a>
        <% } %>
        <br/>
        &nbsp;
      </td>
      <td align="right">
        <%=pageBase.formatCurrHtml(item.WalletDeposit)%>
      </td>
      <td align="right">
        <%=pageBase.formatCurrHtml(item.UnitAmount)%><br/>
        <%
        String taxTooltipClass = item.TaxList.isEmpty() ? "" : " v-tooltip";
        String dataJsp = item.TaxList.isEmpty() ? "" : " data-jsp=\"sale/saleitem_tax_tooltip&SaleId=" + sale.SaleId.getHtmlString() + "&SaleItemId=" + item.SaleItemId.getHtmlString() + "\"";
        %>
        <span class="list-subtitle <%=taxTooltipClass%>" <%=dataJsp%>><%=pageBase.formatCurrHtml(item.UnitTax)%></span>
      </td>
      <td align="right">
        <%=item.Quantity.getHtmlString()%>
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
