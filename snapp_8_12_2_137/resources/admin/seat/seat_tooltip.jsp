<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Account.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTooltip" scope="request"/>

<%
String performanceId = pageBase.getNullParameter("PerformanceId");
String seatId = pageBase.getNullParameter("SeatId");
String ticketId = pageBase.getBL(BLBO_Seat.class).findSeatLinkEntityId(performanceId, seatId, LkSNEntityType.Ticket);
String saleId = null;
JvDataSet dsSeat = null;
JvDataSet dsHold = null;
JvDataSet dsTicket = null;
JvDataSet dsSale = null;

{
  QueryDef qdef = new QueryDef(QryBO_SeatPerformance.class);
  // Select
  qdef.addSelect(QryBO_SeatPerformance.Sel.SeatCategoryName);
  qdef.addSelect(QryBO_SeatPerformance.Sel.SeatSectorName);
  qdef.addSelect(QryBO_SeatPerformance.Sel.SeatEnvelopeName);
  qdef.addSelect(QryBO_SeatPerformance.Sel.SeatName);
  qdef.addSelect(QryBO_SeatPerformance.Sel.QuantityHeld);
  qdef.addSelect(QryBO_SeatPerformance.Sel.QuantityReserved);
  qdef.addSelect(QryBO_SeatPerformance.Sel.QuantityPaid);
  qdef.addSelect(QryBO_SeatPerformance.Sel.QuantityFree);
  qdef.addSelect(QryBO_SeatPerformance.Sel.ManualPick);
  // Filter
  qdef.addFilter(QryBO_SeatPerformance.Fil.PerformanceId, performanceId);
  qdef.addFilter(QryBO_SeatPerformance.Fil.SeatId, seatId);
  // Exec
  dsSeat = pageBase.execQuery(qdef);
}

if (!dsSeat.isEmpty() && (dsSeat.getField(QryBO_SeatPerformance.Sel.QuantityHeld).getInt() > 0)) {
  dsHold = pageBase.getDB().executeQuery(
      "select" + JvString.CRLF +
      "  SH.SeatHoldId," + JvString.CRLF +
      "  SH.HoldStatus," + JvString.CRLF +
      "  SH.HoldDateTime," + JvString.CRLF +
      "  SH.ExpireDateTime," + JvString.CRLF +
      "  SH.UserAccountId," + JvString.CRLF +
      "  UA.DisplayName as UserAccountName," + JvString.CRLF +
      "  W.WorkstationId," + JvString.CRLF +
      "  W.WorkstationName," + JvString.CRLF +
      "  OA.AccountId as OpAreaId," + JvString.CRLF +
      "  OA.DisplayName as OpAreaName," + JvString.CRLF +
      "  L.AccountId as LocationId," + JvString.CRLF +
      "  L.DisplayName as LocationName" + JvString.CRLF +
      "from" + JvString.CRLF +
      "  tbSeatPerformanceLink SPL inner join" + JvString.CRLF +
      "  tbSeatHold SH on SH.SeatHoldId=SPL.EntityId left join" + JvString.CRLF +
      "  tbAccount UA on UA.AccountId=SH.UserAccountId left join" + JvString.CRLF +
      "  tbWorkstation W on W.WorkstationId=SH.WorkstationId left join" + JvString.CRLF +
      "  tbAccount OA on OA.AccountId=W.OpAreaAccountId left join" + JvString.CRLF +
      "  tbAccount L on L.AccountId=W.LocationAccountId" + JvString.CRLF +
      "where" + JvString.CRLF +
      "  SPL.PerformanceId=" + JvString.sqlStr(performanceId) + " and" + JvString.CRLF +
      "  SPL.SeatId=" + JvString.sqlStr(seatId) + " and" + JvString.CRLF +
      "  SPL.EntityType=" + LkSNEntityType.SeatHold2.getCode());
}

if (ticketId != null) {
  QueryDef qdef = new QueryDef(QryBO_Ticket.class);
  // Select
  qdef.addSelect(QryBO_Ticket.Sel.TicketCode);
  qdef.addSelect(QryBO_Ticket.Sel.ProductId);
  qdef.addSelect(QryBO_Ticket.Sel.ProductCode);
  qdef.addSelect(QryBO_Ticket.Sel.ProductName);
  qdef.addSelect(QryBO_Ticket.Sel.SaleId);
  qdef.addSelect(QryBO_Ticket.Sel.PortfolioAccountId);
  qdef.addSelect(QryBO_Ticket.Sel.PortfolioAccountNameMasked);
  qdef.addSelect(QryBO_Ticket.Sel.PortfolioAccountIconName);
  qdef.addSelect(QryBO_Ticket.Sel.PortfolioAccountProfilePictureId);
  qdef.addSelect(QryBO_Ticket.Sel.PortfolioAccountEntityType);
  // Filter
  qdef.addFilter(QryBO_Ticket.Fil.TicketId, ticketId);
  // Exec
  JvDataSet ds = pageBase.execQuery(qdef); 
  if (!ds.isEmpty()) {
    dsTicket = ds;
    saleId = ds.getField(QryBO_Ticket.Sel.SaleId).getString();
  }
}

if (saleId == null) 
  saleId = pageBase.getBL(BLBO_Seat.class).findSeatSaleId(performanceId, seatId);

if (saleId != null) {
  QueryDef qdef = new QueryDef(QryBO_Sale.class);
  // Select
  qdef.addSelect(QryBO_Sale.Sel.SaleCalcStatus);
  qdef.addSelect(QryBO_Sale.Sel.SaleCode);
  qdef.addSelect(QryBO_Sale.Sel.AccountId);
  qdef.addSelect(QryBO_Sale.Sel.AccountName);
  qdef.addSelect(QryBO_Sale.Sel.AccountEntityType);
  qdef.addSelect(QryBO_Sale.Sel.AccountProfilePictureId);
  qdef.addSelect(QryBO_Sale.Sel.ShipAccountId);
  qdef.addSelect(QryBO_Sale.Sel.ShipAccountName);
  qdef.addSelect(QryBO_Sale.Sel.ShipAccountEntityType);
  qdef.addSelect(QryBO_Sale.Sel.ShipAccountProfilePictureId);
  // Filter
  qdef.addFilter(QryBO_Sale.Fil.SaleId, saleId);
  // Exec
  JvDataSet ds = pageBase.execQuery(qdef);
  if (!ds.isEmpty()) {
    dsSale = ds;
  }
}
%>

<%!
private String getProfilePicURL(String repositoryId) {
  return ConfigTag.getValue("site_url") + "/repository?id=" + repositoryId + "&type=thumb";
}
%>

<style>
.recap-block {
  line-height: 18px;
  border-bottom: 1px solid rgba(0,0,0,0.2);
  padding-bottom: 10px;
  margin-bottom: 10px;
}
.recap-block:last-child {
  border: none;
  padding-bottom: 0;
  margin-bottom: 0;
}
.recap-item {
  overflow: hidden;
}
.recap-item-caption {
  float: left;
}
.recap-item-value {
  float: right;
  font-weight: bold;
}
.profile-pic {
  width: 50px;
  height: 50px;
  margin-top: 2px;
  margin-bottom: 2px;
}
</style>

<div style="width:300px">

<%-- SEAT --%>
<div class="recap-block">
  <div class="recap-item">
    <div class="recap-item-caption"><v:itl key="@Common.Name"/></div>
    <div class="recap-item-value"><%=dsSeat.getField(QryBO_SeatPerformance.Sel.SeatName).getHtmlString()%></div>
  </div>
  <div class="recap-item">
    <div class="recap-item-caption"><v:itl key="@Seat.Category"/></div>
    <div class="recap-item-value"><%=dsSeat.getField(QryBO_SeatPerformance.Sel.SeatCategoryName).getHtmlString()%></div>
  </div>
  <div class="recap-item">
    <div class="recap-item-caption"><v:itl key="@Seat.Sector"/></div>
    <div class="recap-item-value"><%=dsSeat.getField(QryBO_SeatPerformance.Sel.SeatSectorName).getHtmlString()%></div>
  </div>
  <div class="recap-item">
    <div class="recap-item-caption"><v:itl key="@Seat.Envelope"/></div>
    <div class="recap-item-value"><%=dsSeat.getField(QryBO_SeatPerformance.Sel.SeatEnvelopeName).getHtmlString()%></div>
  </div>
  <div class="recap-item">
    <div class="recap-item-caption"><v:itl key="@Seat.SeatPick"/></div>
    <div class="recap-item-value">
    <% if (dsSeat.getField(QryBO_SeatPerformance.Sel.ManualPick).getBoolean()) { %>
      <v:itl key="@Seat.SeatPickManual"/>
    <% } else { %>
      <v:itl key="@Seat.SeatPickAuto"/>
    <% } %>
    </div>
  </div>
</div>
  
<%-- HOLD --%>
<% if ((dsHold != null) && ! dsHold.isEmpty()) { %>
  <% LookupItem holdStatus = LkSN.SeatHoldStatus.getItemByCode(dsHold.getField("HoldStatus")); %>
  <div class="recap-block">
    <div class="recap-item">
      <div class="recap-item-caption"><v:itl key="@Common.Status"/></div>
      <div class="recap-item-value"><%=holdStatus.getHtmlDescription(pageBase.getLang())%></div>
    </div>
    <div class="recap-item">
      <div class="recap-item-caption"><v:itl key="@Common.DateTime"/></div>
      <div class="recap-item-value"><snp:datetime timestamp="<%=dsHold.getField(\"HoldDateTime\")%>" timezone="local" format="shortdatetime"/></div>
    </div>
    <div class="recap-item">
      <div class="recap-item-caption"><v:itl key="@Common.Expiration"/></div>
      <div class="recap-item-value">
        <%
          JvDateTime expiration = dsHold.getField("ExpireDateTime").getDateTime();
        %>
        <% if (expiration == null) { %>
          <v:itl key="@Common.NoExpiration"/>
        <% } else { %>
          <snp:datetime timestamp="<%=expiration%>" timezone="local" format="shortdatetime"/>
        <% } %>
      </div>
    </div>
    <div class="recap-item">
      <div class="recap-item-caption"><v:itl key="@Account.Location"/></div>
      <div class="recap-item-value">
        <snp:entity-link entityId="<%=dsHold.getField(\"LocationId\")%>" entityType="<%=LkSNEntityType.Location%>">
          <%=dsHold.getField("LocationName").getHtmlString()%>
        </snp:entity-link>
      </div>
    </div>
    <div class="recap-item">
      <div class="recap-item-caption"><v:itl key="@Account.OpArea"/></div>
      <div class="recap-item-value">
        <snp:entity-link entityId="<%=dsHold.getField(\"OpAreaId\")%>" entityType="<%=LkSNEntityType.OperatingArea%>">
          <%=dsHold.getField("OpAreaName").getHtmlString()%>
        </snp:entity-link>
      </div>
    </div>
    <div class="recap-item">
      <div class="recap-item-caption"><v:itl key="@Common.Workstation"/></div>
      <div class="recap-item-value">
        <snp:entity-link entityId="<%=dsHold.getField(\"WorkstationId\")%>" entityType="<%=LkSNEntityType.Workstation%>">
          <%=dsHold.getField("WorkstationName").getHtmlString()%>
        </snp:entity-link>
      </div>
    </div>
    <div class="recap-item">
      <div class="recap-item-caption"><v:itl key="@Common.User"/></div>
      <div class="recap-item-value">
        <snp:entity-link entityId="<%=dsHold.getField(\"UserAccountId\")%>" entityType="<%=LkSNEntityType.Workstation%>">
          <%=dsHold.getField("UserAccountName").getHtmlString()%>
        </snp:entity-link>
      </div>
    </div>
  </div>
  <div class="recap-block">
    <div class="recap-item" style="text-align:center">
      <strong><a href="javascript:asyncDialogEasy('seat/seat_hold_dialog', 'id=<%=dsHold.getField("SeatHoldId").getHtmlString()%>')"><v:itl key="@Seat.Release"/></a></strong>
    </div>
  </div>
<% } %>

<%-- TICKET --%>
<% if (dsTicket != null) { %>
  <div class="recap-block">
	  <div class="recap-item">
	    <div class="recap-item-caption"><v:itl key="@Ticket.Ticket"/></div>
	    <snp:entity-link clazz="recap-item-value" entityId="<%=ticketId%>" entityType="<%=LkSNEntityType.Ticket%>" entityTooltip="false" openOnNewTab="true">
	      <%=dsTicket.getField(QryBO_Ticket.Sel.TicketCode).getHtmlString()%>
	    </snp:entity-link>
	  </div>
	  <div class="recap-item">
	    <div class="recap-item-caption"><v:itl key="@Common.Name"/></div>
	    <div class="recap-item-value">
	      <%=dsTicket.getField(QryBO_Ticket.Sel.ProductName).getHtmlString()%>
	    </div>
	  </div>
	  <div class="recap-item">
	    <div class="recap-item-caption"><v:itl key="@Common.Code"/></div>
	    <div class="recap-item-value">
	      <%=dsTicket.getField(QryBO_Ticket.Sel.ProductCode).getHtmlString()%>
	    </div>
	  </div>
	  <% String accountId = dsTicket.getField(QryBO_Ticket.Sel.PortfolioAccountId).getString(); %>
	  <% if (accountId != null) { %>
      <div class="recap-item">
        <div class="recap-item-caption"><v:itl key="@Account.Account"/></div>
        <snp:entity-link clazz="recap-item-value" entityId="<%=accountId%>" entityType="<%=dsTicket.getField(QryBO_Ticket.Sel.PortfolioAccountEntityType)%>" entityTooltip="false" openOnNewTab="true">
          <%=dsTicket.getField(QryBO_Ticket.Sel.PortfolioAccountNameMasked).getHtmlString()%>
        </snp:entity-link>
      </div>
      <% String profilePictureId = dsTicket.getField(QryBO_Ticket.Sel.PortfolioAccountProfilePictureId).getString(); %>
      <% if (profilePictureId != null) { %>
	      <div class="recap-item">
          <div class="recap-item-value profile-pic" style="background-image:url('<%=getProfilePicURL(profilePictureId)%>')"></div>	        
	      </div>
      <% } %>
	  <% } %>
	</div>
<% } %>

<%-- SALE --%>
<% if (dsSale != null) { %>
  <div class="recap-block">
    <div class="recap-item">
      <div class="recap-item-caption"><v:itl key="@Sale.PNR"/></div>
      <snp:entity-link clazz="recap-item-value" entityId="<%=saleId%>" entityType="<%=LkSNEntityType.Sale%>" entityTooltip="false" openOnNewTab="true">
        <%=dsSale.getField(QryBO_Sale.Sel.SaleCode).getHtmlString()%>
      </snp:entity-link>
    </div>
    <div class="recap-item">
      <div class="recap-item-caption"><v:itl key="@Common.Status"/></div>
      <% LookupItem saleCalcStatus = LkSN.SaleCalcStatus.getItemByCode(dsSale.getField(QryBO_Sale.Sel.SaleCalcStatus)); %>
      <div class="recap-item-value"><%=saleCalcStatus.getHtmlDescription(pageBase.getLang())%></div>
    </div>
    <% String ownerAccountId = dsSale.getField(QryBO_Sale.Sel.AccountId).getString(); %>
    <% String shipAccountId = dsSale.getField(QryBO_Sale.Sel.ShipAccountId).getString(); %>
    <% if (ownerAccountId != null) { %>
      <div class="recap-item">
        <div class="recap-item-caption"><v:itl key="@Lookup.SaleAccountType.Owner"/></div>
        <snp:entity-link clazz="recap-item-value" entityId="<%=ownerAccountId%>" entityType="<%=dsSale.getField(QryBO_Sale.Sel.AccountEntityType)%>" entityTooltip="false" openOnNewTab="true">
          <%=dsSale.getField(QryBO_Sale.Sel.AccountName).getHtmlString()%>
        </snp:entity-link>
      </div>
      <% String profilePictureId = dsSale.getField(QryBO_Sale.Sel.AccountProfilePictureId).getString(); %>
      <% if ((profilePictureId != null) && (shipAccountId == null)) { %>
        <div class="recap-item">
          <div class="recap-item-value profile-pic" style="background-image:url('<%=getProfilePicURL(profilePictureId)%>')"></div>          
        </div>
      <% } %>
    <% } %>
    <% if (shipAccountId != null) { %>
      <div class="recap-item">
        <div class="recap-item-caption"><v:itl key="@Lookup.SaleAccountType.Guest"/></div>
        <snp:entity-link clazz="recap-item-value" entityId="<%=shipAccountId%>" entityType="<%=dsSale.getField(QryBO_Sale.Sel.ShipAccountEntityType)%>" entityTooltip="false" openOnNewTab="true">
          <%=dsSale.getField(QryBO_Sale.Sel.ShipAccountName).getHtmlString()%>
        </snp:entity-link>
      </div>
      <% String profilePictureId = dsSale.getField(QryBO_Sale.Sel.ShipAccountProfilePictureId).getString(); %>
      <% if (profilePictureId != null) { %>
        <div class="recap-item">
          <div class="recap-item-value profile-pic" style="background-image:url('<%=getProfilePicURL(profilePictureId)%>')"></div>          
        </div>
      <% } %>
    <% } %>
  </div>
<% } %>

</div>