<%@page import="com.vgs.web.library.product.NSystemProduct"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.search.dataobject.*"%>
<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Ticket.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
DOTicketSearchRequest reqDO = new DOTicketSearchRequest();

if (pageBase.getNullParameter("TicketCode") != null) 
  reqDO.TicketCode.setString(pageBase.getNullParameter("TicketCode"));
else if (pageBase.getNullParameter("TicketId") != null) 
  reqDO.TicketId.setString(pageBase.getNullParameter("TicketId"));
else if (pageBase.getNullParameter("PackageTicketId") != null) 
  reqDO.PackageTicketId.setString(pageBase.getNullParameter("PackageTicketId"));
else {
  reqDO.SaleId.setString(pageBase.getNullParameter("SaleId"));
  reqDO.TransactionId.setString(pageBase.getNullParameter("TransactionId"));
  reqDO.MediaId.setString(pageBase.getNullParameter("MediaId"));
  reqDO.AccountId.setString(pageBase.getNullParameter("AccountId"));
  reqDO.PortfolioId.setString(pageBase.getNullParameter("PortfolioId"));
  reqDO.ProductId.setString(pageBase.getNullParameter("ProductId"));
  reqDO.SaleItemDetailId.setString(pageBase.getNullParameter("SaleItemDetailId"));
  reqDO.MainSaleItemId.setString(pageBase.getNullParameter("MainSaleItemId"));
  reqDO.InstallmentContractId.setString(pageBase.getNullParameter("InstallmentContractId"));
  reqDO.HostTicketId.setString(pageBase.getNullParameter("HostTicketId"));
  reqDO.ActivationGroupTicketId.setString(pageBase.getNullParameter("ActivationGroupTicketId"));
  reqDO.StationSerial.setString(pageBase.getNullParameter("StationSerial"));
  if (!reqDO.StationSerial.isNull())
    reqDO.LicenseId.setInt(pageBase.getSession().getLicenseId());
  reqDO.EncodeFiscalDate.setXMLValue(pageBase.getNullParameter("EncodeFiscalDate"));
  reqDO.TicketStatusGroups.setXMLValue(pageBase.getNullParameter("TicketStatus"));
}

boolean prioritizeMode = pageBase.isParameter("PrioritizeMode", "true");
boolean sortAllowed = pageBase.hasParameter("PortfolioId") || pageBase.hasParameter("MediaId");
if (sortAllowed)
  reqDO.SearchRecap.addSortField(Sel.PriorityOrder, false);
else {
  reqDO.SearchRecap.addSortField(Sel.EncodeFiscalDate, true);
  reqDO.SearchRecap.addSortField(Sel.EncodeDateTime, true);
  reqDO.SearchRecap.addSortField(Sel.TicketSerial, true);
}

reqDO.SearchRecap.PagePos.setInt(pageBase.getQP());
reqDO.SearchRecap.RecordPerPage.setInt(prioritizeMode ? 1000 : QueryDef.recordPerPageDefault);

DOTicketSearchAnswer ansDO = pageBase.getBL(BLBO_Ticket.class).searchTicket(reqDO);

boolean multiPage = true;
if (pageBase.getNullParameter("MultiPage") != null)
  multiPage = pageBase.findBoolParameter("MultiPage");
%>

<style>
#ticket-grid-inner .grid-sort-column {
  display: none
}
#ticket-grid-inner.show-sort-handle .grid-sort-column {
  display: table-cell;
  cursor: move;
}
</style>


<script>

$(document).ready(function() {
  $("#ticket-grid-inner tbody").sortable({
    handle: ".grid-move-handle",
    helper: fixHelper,
    stop: function(event, ui) {
      var portfolioId = null;
      var ticketIDs = [];
      
      $("#ticket-grid-inner .grid-row").each(function(index, elem) {
        var $handle = $(elem).find(".grid-move-handle");
        portfolioId = $handle.attr("data-portfolioid"); 
        ticketIDs.push($handle.attr("data-ticketid"));
      });
      
      doTicketChangePriority(portfolioId, ticketIDs);
    }
  });
});
</script>

<% String clazzPrioritizeMode = prioritizeMode ? "show-sort-handle" : ""; %>
<v:grid id="ticket-grid-inner" clazz="<%=clazzPrioritizeMode%>" search="<%=ansDO%>" entityType="<%=LkSNEntityType.Ticket%>">
  <tr class="header">
    <td><v:grid-checkbox header="true" multipage="<%=multiPage%>"/></td>
    <td>&nbsp;</td>
    <td width="120px" nowrap>
      <v:itl key="@Common.Code"/><br/>
      <v:itl key="@Common.Status"/>
    </td>
    <td width="150px" nowrap>
      <v:itl key="@Ticket.EncodeDateTime"/><br/>
      <v:itl key="@Ticket.ValidateDateTime"/> 
    </td>
    <td width="100px" nowrap>
      <v:itl key="@Common.ValidFrom"/><br/>
      <v:itl key="@Common.ValidTo"/> 
    </td>
    <td width="150px" nowrap>
      <v:itl key="@Ticket.FirstUsageDateTime"/><br/>
      <v:itl key="@Entitlement.Entries"/> / <v:itl key="@Entitlement.ReEntries"/> / <v:itl key="@Entitlement.Crossovers"/> / <v:itl key="@Ticket.Exits"/> 
    </td>
    <td width="100%">
      <v:itl key="@Product.ProductType"/><br/>
      <v:itl key="@Performance.Performance"/> (<v:itl key="@Seat.Seat"/>)
    </td>
    <td width="170px" nowrap>
      <v:itl key="@Common.Quantity"/> / <v:itl key="@Product.GroupTicketOption"/><br/>
      <v:itl key="@Installment.InstallmentContract"/>
    </td>
    <td width="120px" align="right" nowrap>
      <v:itl key="@Reservation.TotalAmount"/><br/>
      <v:itl key="@Reservation.TotalTax"/>
    </td>
    <td class="grid-sort-column"></td>
  </tr>
  <tbody>
    <v:grid-row search="<%=ansDO%>" dateGroupFieldName="<%=sortAllowed ? null : Sel.EncodeFiscalDate.name()%>" archivedFieldName="ArchivedPurged">
      <%
      DOTicketRef ticketDO = ansDO.getRecord();
      boolean isSystemProductGiftCard = ticketDO.ProductId.isSameString(NSystemProduct.GiftCard.getProductId()); 
      %>
      
      <td style="<v:common-status-style status="<%=ticketDO.CommonStatus%>"/>" data-ticketactive="<%=ticketDO.TicketStatus.isLookup(LkSNTicketStatus.Active)%>">
        <v:grid-checkbox name="TicketId" fieldname="TicketId" value="<%=ticketDO.TicketId.getString()%>"/>
        <snp:grid-note entityType="<%=LkSNEntityType.Ticket%>" entityId="<%=ticketDO.TicketId.getString()%>" noteCountField="<%=ticketDO.NoteCount%>"/>
      </td>
      <td><v:grid-icon name="<%=ticketDO.IconName.getString()%>"/></td>
      <td>
        <snp:entity-link entityId="<%=ticketDO.TicketId%>" entityType="<%=LkSNEntityType.Ticket%>" clazz="list-title" entityTooltip="false">
          <%=ticketDO.TicketCode.getHtmlString()%>
        </snp:entity-link><br/>
        <span class="list-subtitle"><%=ticketDO.TicketStatus.getHtmlLookupDesc(pageBase.getLang())%></span>
      </td>
      <td>
        <snp:datetime timestamp="<%=ticketDO.EncodeDateTime%>" format="shortdatetime" timezone="local"/><br/>
        <span class="list-subtitle">
        <% if (ticketDO.ValidateDateTime.isNull()) { %>
          <v:itl key="@Ticket.NotValidated"/>
          <% if (!ticketDO.Paid.getBoolean()) { %>
            / <v:itl key="@Ticket.NotPaid"/>
          <% } %>
        <% } else { %>
          <snp:datetime timestamp="<%=ticketDO.ValidateDateTime%>" format="shortdatetime" timezone="local"/>
        <% } %>
        </span>
      </td>
      <td>
        <% if (ticketDO.NeedRecalc.getBoolean()) { %>
          <div style="color:var(--base-orange-color); text-align:center"><v:itl key="@Ticket.VersionRecalcNeeded"/> <v:hint-handle hint="@Ticket.VersionRecalcNeededHint"/></div>
        <% } else { %>
          <div class="list-subtitle"><%=ticketDO.ValidDateFrom.isNull() ? "&mdash;" : pageBase.format(ticketDO.ValidDateFrom, pageBase.getShortDateFormat())%></div>
          <div class="list-subtitle"><%=ticketDO.ValidDateTo.isNull() ? "&mdash;" : pageBase.format(ticketDO.ValidDateTo, pageBase.getShortDateFormat())%></div>
        <% } %>
      </td>
      <td>
        <% if (ticketDO.FirstUsageDateTime.isNull()) { %>
          <span class="list-subtitle"><v:itl key="@Ticket.NotUsed"/></span>
        <% } else { %>
          <snp:datetime timestamp="<%=ticketDO.FirstUsageDateTime%>" format="shortdatetime" timezone="local"/><br/>
          <span class="list-subtitle">
            <%=ticketDO.EntryCount.getHtmlString()%> /
            <%=ticketDO.ReentryCount.getHtmlString()%> / 
            <%=ticketDO.CrossoverCount.getHtmlString()%> / 
            <%=ticketDO.ExitCount.getHtmlString()%>
          </span>
        <% } %>
      </td>
      <td>
        <snp:entity-link entityId="<%=ticketDO.ProductId%>" entityType="<%=LkSNEntityType.ProductType%>">
          [<%=ticketDO.ProductCode.getHtmlString()%>] <%=ticketDO.ProductName.getHtmlString()%>
        </snp:entity-link>
        <% if (ticketDO.GiftCardNumber.getEmptyString().length() > 0) { %>
          &mdash; <%=ticketDO.GiftCardNumber.getHtmlString()%>
        <% } %>

        <div class="list-subtitle">
        <% if (ticketDO.PerformanceList.isEmpty() && !ticketDO.PerformanceBeforeUsage.getBoolean()) { %>
          <v:itl key="@Common.None"/>
        <% } else { %>
          <%=ticketDO.PerformanceDesc.getHtmlString()%>
        <% } %>
        </div>
      </td>
      <td>
        <div>
          <%=ticketDO.GroupQuantity.getHtmlString()%> / 
          <span class="list-subtitle"><%=ticketDO.GroupTicketOption.getHtmlLookupDesc(pageBase.getLang()) %></span>
        </div>
        <div>
          <% if (ticketDO.InstallmentContractId.isNull()) { %>
            &mdash;
          <% } else { %>
            <snp:entity-link entityId="<%=ticketDO.InstallmentContractId%>" entityType="<%=LkSNEntityType.InstallmentContract%>"><%=ticketDO.InstallmentContractCode.getHtmlString()%></snp:entity-link>
          <% } %>
        </div>
      </td>
      <td align="right">
        <span style="white-space:nowrap">
        <% if (ticketDO.BindWalletRewardToProduct.getBoolean()) { %>
          <% String params = "PortfolioId=" + ticketDO.MainPortfolioId.getHtmlString() + "&TicketId=" + ticketDO.TicketId.getHtmlString(); %>
          <a href="javascript:asyncDialogEasy('portfolio/portfolio_binded_product_wallet_reward_dialog', '<%=params%>')">(<i class="fa-solid fa-wallet"></i>&nbsp;<%=pageBase.formatCurr(ticketDO.PortfolioBindedBalance.getMoney())%>)</a>&nbsp;<%=pageBase.formatCurr(ticketDO.UnitAmount.getMoney() * ticketDO.GroupQuantity.getInt())%>
        <% } else { %>
          <%=pageBase.formatCurr(ticketDO.UnitAmount.getMoney() * ticketDO.GroupQuantity.getInt())%>
        <% } %>
        </span><br/>
        <span class="list-subtitle"><%=pageBase.formatCurrHtml(ticketDO.UnitTax.getMoney() * ticketDO.GroupQuantity.getInt())%></span>
      </td>
      <td class="grid-sort-column">
        <span class="grid-move-handle" data-ticketid="<%=ticketDO.TicketId.getHtmlString()%>" data-portfolioid="<%=ticketDO.PortfolioId.getHtmlString()%>"></span>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>
