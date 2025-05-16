<%@page import="com.vgs.web.library.seat.*"%>
<%@page import="com.vgs.snapp.dataobject.performance.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
String performanceId = pageBase.getNullParameter("PerformanceId");
String seatSectorId = pageBase.getNullParameter("SeatSectorId");
String seatCategoryId = pageBase.getNullParameter("SeatCategoryId");
LookupItem seatHoldBreakdownFilter = LkSNSeatHoldBreakdownFilter.getByDescription(pageBase.getNullParameter("status"));
DOSeatHoldBreakdown data = pageBase.getBL(BLBO_SeatHoldBreakdown.class).loadSeatHoldBreakdown(performanceId, seatSectorId, seatCategoryId, seatHoldBreakdownFilter);
%>

<div id="seathold-grid" class="grid-widget-container" data-jsp="seat/seat_hold_widget_grid.jsp">

<style>

table.hold-sub-list tr.grid-row .hold-row-hover-visible {
  visibility: hidden;
}

table.hold-sub-list tr.grid-row:hover .hold-row-hover-visible {
  visibility: visible;
}

</style>

<div class="form-toolbar v-hidden">
  <v:button caption="@Common.Remove" fa="minus"/>
</div>

<v:grid clazz="hold-sub-list">
  <thead>
    <tr>
      <td width="120px" valign="top">
        <v:itl key="@Common.Quantity"/><br/>
        <v:itl key="@Common.Status"/>
      </td>
      <td width="180px">
        <v:itl key="@Common.DateTime"/><br/>
        <v:itl key="@Common.Expiration"/>
      </td>
      <td>
        <v:itl key="@Common.Workstation"/><br/>
        <v:itl key="@Common.User"/>
      </td>
      <td colspan="2" nowrap>
      </td>
    </tr>
  </thead>
  <tbody>
    <% for (DOSeatHoldBreakdown.DOSeatHoldBreakdownItem item : data.ItemList) { %>
      <tr class="grid-row">
        <td valign="top">
          <strong><%=item.Quantity.getHtmlString()%></strong>
          <br/>
          <span class="list-subtitle"><%=item.HoldStatus.getHtmlLookupDesc(pageBase.getLang())%></span>    
        </td>
        <td valign="top" nowrap>
          <snp:datetime timestamp="<%=item.HoldDateTime%>" format="shortdatetime" timezone="local"/>
          <br/>
          <% if (item.ExpireDateTime.isNull()) { %>
            <span class="list-subtitle"><v:itl key="@Common.NoExpiration"/></span>
          <% } else { %>
            <snp:datetime timestamp="<%=item.ExpireDateTime%>" format="shortdatetime" timezone="local" clazz="list-subtitle"/>
          <% } %>
        </td>
        <td colspan="2" width="100%">
          <snp:entity-link entityId="<%=item.LocationId%>" entityType="<%=LkSNEntityType.Location%>">
            <%=item.LocationName.getHtmlString()%>
          </snp:entity-link>
          &raquo;
          <snp:entity-link entityId="<%=item.OpAreaId%>" entityType="<%=LkSNEntityType.OperatingArea%>">
            <%=item.OpAreaName.getHtmlString()%>
          </snp:entity-link>
          &raquo;
          <snp:entity-link entityId="<%=item.WorkstationId%>" entityType="<%=LkSNEntityType.Workstation%>">
            <%=item.WorkstationName.getHtmlString()%>
          </snp:entity-link>
          
          <br/>
          
          <snp:entity-link entityId="<%=item.UserAccountId%>" entityType="<%=LkSNEntityType.Person%>">
            <%=item.UserAccountName.getHtmlString()%>
          </snp:entity-link>
        </td>
        <td align="right" width="100px">
          <% if (item.SaleId.isNull()) { %>
            <%=item.SaleCode.getHtmlString()%>
          <% } else { %>
  	        <snp:entity-link entityId="<%=item.SaleId%>" entityType="<%=LkSNEntityType.Sale%>">
              <%=item.SaleCode.getHtmlString()%>
  	        </snp:entity-link>
          <% } %>
          <br/>
          <% if (item.HoldStatus.isLookup(LkSNSeatHoldStatus.Hold, LkSNSeatHoldStatus.Freeze)) { %>
            <span class="hold-row-hover-visible"><a href="javascript:asyncDialogEasy('seat/seat_hold_dialog', 'id=<%=item.SeatHoldId.getEmptyString()%>')"><v:itl key="@Common.Remove"/></a></span>
          <% } %>    
        </td>
      </tr>
    <% } %>
  </tbody>
</v:grid>
</div>

