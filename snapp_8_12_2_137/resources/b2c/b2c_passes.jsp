<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="com.vgs.web.library.BLBO_Ticket"%>
<%@page import="com.vgs.web.library.BLBO_Sale"%>
<%@page import="com.vgs.web.library.BLBO_DBInfo"%>
<%@page import="com.vgs.snapp.web.b2c.page.*"%>
<%@page import="com.vgs.snapp.web.b2c.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Ticket.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.b2c.page.PageB2C_MobileWallet" scope="request"/>
<jsp:include page="/resources/common/header-head.jsp"/>
<%
QueryDef qdef = new QueryDef(QryBO_Ticket.class);
// Select
qdef.addSelect(
    Sel.SaleCode,
    Sel.IconName,
    Sel.CommonStatus,
    Sel.TicketId,
    Sel.TicketCode,
    Sel.TicketStatus,
    Sel.ProductId,
    Sel.ProductCode,
    Sel.ProductName,
    Sel.TotalAmount,
    Sel.TotalTax,
    Sel.LicenseId,
    Sel.StationSerial,
    Sel.TicketSerial,
    Sel.EncodeDateTime,
    Sel.EncodeFiscalDate,
    Sel.WorkstationId,
    Sel.WorkstationCode,
    Sel.WorkstationName,
    Sel.PerformanceCount,
    Sel.PerformanceId,
    Sel.PerformanceDateTime,
    Sel.EventId,
    Sel.EventCode,
    Sel.EventName,
    Sel.AdmLocationId,
    Sel.AdmLocationCode,
    Sel.AdmLocationName,
    Sel.SeatName,
    Sel.GroupTicketOption,
    Sel.GroupQuantity,
    Sel.Paid,
    Sel.ValidateDateTime,
    Sel.ValidDateFrom,
    Sel.ValidDateTo,
    Sel.FirstUsageDateTime,
    Sel.EntryCount,
    Sel.ReentryCount,
    Sel.CrossoverCount,
    Sel.ExitCount,
    Sel.PortfolioId,
    Sel.GiftCardNumber,
    Sel.NoteCount,
    Sel.InstallmentContractId,
    Sel.InstallmentContractCode,
    Sel.NeedEntitlementReplace);

boolean prioritizeMode = pageBase.isParameter("PrioritizeMode", "true");

String ticketId = pageBase.getNullParameter("TicketId");
String ticketCode = pageBase.getNullParameter("TicketCode");
String saleId = pageBase.getParameter("SaleId");

if (ticketCode != null) 
  qdef.addFilter(Fil.TicketCode, ticketCode);
else if (ticketId != null) 
  qdef.addFilter(Fil.TicketId, ticketId);
else {
  if (pageBase.hasParameter("SaleId"))
    qdef.addFilter(Fil.SaleId, pageBase.getNullParameter("SaleId"));
  
  if (pageBase.hasParameter("TransactionId"))
    qdef.addFilter(Fil.TransactionId, pageBase.getNullParameter("TransactionId"));
  
  if (pageBase.hasParameter("MediaId"))
    qdef.addFilter(Fil.MediaId, pageBase.getNullParameter("MediaId"));
  
  if (pageBase.hasParameter("AccountId"))
    qdef.addFilter(Fil.AccountId, pageBase.getNullParameter("AccountId"));
}

// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = prioritizeMode ? 1000 : QueryDef.recordPerPageDefault;
// Sort
boolean sortAllowed = pageBase.hasParameter("MediaId");
if (sortAllowed)
  qdef.addSort(Sel.PriorityOrder);
else {
  qdef.addSort(Sel.EncodeFiscalDate, false);
  qdef.addSort(Sel.EncodeDateTime, false);
  qdef.addSort(Sel.TicketSerial, false);
}
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
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
      
    }
  });
});

function addToGPay(ticketId) {
	alert(ticketId)
	
}

function addToApplePay(ticketId) {
	alert(ticketId)
}

</script>




<% String clazzPrioritizeMode = prioritizeMode ? "show-sort-handle" : ""; %>
<v:grid id="ticket-grid-inner" clazz="<%=clazzPrioritizeMode%>" dataset="<%=ds%>" qdef="<%=qdef%>">
  <% LookupItem ticketStatus = LkSN.TicketStatus.getItemByCode(ds.getField(Sel.TicketStatus)); %>
  <tr class="header">
    <td width="120px" nowrap>
      <v:itl key="@Common.Sale"/>
    </td>
    <td width="120px" nowrap>
      <v:itl key="@Common.Code"/>
    </td>
    <td width="100px" nowrap>
      <v:itl key="@Common.ValidFrom"/><br>
      <v:itl key="@Common.ValidTo"/> 
    </td>
    <td width="300px">
      <v:itl key="@Product.ProductType"/><br/>
      <v:itl key="@Performance.Performance"/> (<v:itl key="@Seat.Seat"/>)
    </td>
    <td width="100px" nowrap>
      <v:itl key="@Common.Quantity"/>
    </td>
    <td width="120px" align="right" nowrap>
      <v:itl key="@Reservation.TotalAmount"/><br/>
      <v:itl key="@Reservation.TotalTax"/>
    </td>    
    <td width="100px" nowrap>
      <v:itl key="Add to Wallet"/>
    </td>
  </tr>
  <tbody>
  	  <td>
		<%=ds.getField(Sel.SaleCode).getString()%>
      </td>
	  <td>
		<%=ds.getField(Sel.TicketCode).getString()%>
      </td>
      <td>
        <snp:datetime timestamp="<%=ds.getField(Sel.EncodeDateTime)%>" format="shortdatetime" timezone="local"/><br/>
        <span class="list-subtitle">
        <% if (ds.getField(Sel.ValidateDateTime).isNull()) { %>
          <v:itl key="@Ticket.NotValidated"/>
          <% if (!ds.getField(Sel.Paid).getBoolean()) { %>
            / <v:itl key="@Ticket.NotPaid"/>
          <% } %>
        <% } else { %>
          <snp:datetime timestamp="<%=ds.getField(Sel.ValidateDateTime)%>" format="shortdatetime" timezone="local"/>
        <% } %>
        </span>
      </td>
      <td>
        <% if (ds.getField(Sel.ProductId).isNull()) { %>
          &nbsp;
        <% } else { %>
        	<%=ds.getField(Sel.ProductCode).getHtmlString()%><br>
			<%=ds.getField(Sel.ProductName).getHtmlString()%>
          <% if (ds.getField(Sel.GiftCardNumber).getEmptyString().length() > 0) { %>
            &mdash; <%=ds.getField(Sel.GiftCardNumber).getHtmlString()%>
          <% } %>
        <% } %>
        <br/>
        <span class="list-subtitle">
        <% if (ds.getField(Sel.PerformanceCount).getInt() == 0) { %>
          <v:itl key="@Common.None"/>
        <% } else if (ds.getField(Sel.PerformanceCount).getInt() > 1) { %>
          <v:itl key="@Performance.MultiplePerformance"/>
        <% } else { %>
          <snp:entity-link entityId="<%=ds.getField(Sel.EventId).getString()%>" entityType="<%=LkSNEntityType.Event%>">
            <%=ds.getField(Sel.EventName).getHtmlString()%>
          </snp:entity-link>
          &raquo;
          <% if (!ds.getField(Sel.AdmLocationId).isNull()) { %>
            <snp:entity-link entityId="<%=ds.getField(Sel.AdmLocationId).getString()%>" entityType="<%=LkSNEntityType.Location%>">
              <%=ds.getField(Sel.AdmLocationName).getHtmlString()%>
            </snp:entity-link>
            &raquo;
          <% } %>
          <% ds.getField(Sel.PerformanceDateTime).setDisplayFormat(pageBase.getShortDateTimeFormat()); %>
          <snp:entity-link entityId="<%=ds.getField(Sel.PerformanceId).getString()%>" entityType="<%=LkSNEntityType.Performance%>">
            <%=ds.getField(Sel.PerformanceDateTime).getHtmlString()%>
          </snp:entity-link>
          <% if (!ds.getField(Sel.SeatName).isNull()) { %>
            (<%=ds.getField(Sel.SeatName).getHtmlString()%>)
          <% } %>
        <% } %>
        </span>
      </td>
      <td>
        <div>
          <%=ds.getField(Sel.GroupQuantity).getHtmlString()%> / 
          <% LookupItem groupTicketOption = LkSN.GroupTicketOption.getItemByCode(ds.getField(Sel.GroupTicketOption)); %>
          <span class="list-subtitle"><%=groupTicketOption.getDescription(pageBase.getLang()) %></span>
        </div>
      </td>
      <td align="right">
        <%=pageBase.formatCurrHtml(ds.getField(Sel.TotalAmount))%><br/>
        <span class="list-subtitle"><%=pageBase.formatCurrHtml(ds.getField(Sel.TotalTax))%></span>
      </td>
      <td>
      <% String hrefGoogle = "javascript:addToApplePay('"+ ds.getField(Sel.TicketId).getHtmlString() +"')"; %>
      	<v:button caption="@Common.Add" fa="plus" href="<%=hrefGoogle%>"/> 
      </td>
      <td>
      <% String hrefApple = "javascript:addToApplePay('"+ ds.getField(Sel.TicketId).getHtmlString() +"')"; %>
      	<v:button caption="@Common.Add" fa="plus" href="<%=hrefApple%>"/> 
      </td>
  </tbody>
</v:grid>

<jsp:include
	page="<%=pageBase.getFragmentInclude(PageB2C_Base.FRAGMENT_Footer)%>"></jsp:include>