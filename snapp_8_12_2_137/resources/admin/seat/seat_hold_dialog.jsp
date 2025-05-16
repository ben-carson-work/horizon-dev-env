<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
QueryDef qdefHold = new QueryDef(QryBO_SeatHold.class);
// Select
qdefHold.addSelect(QryBO_SeatHold.Sel.SeatHoldId);
qdefHold.addSelect(QryBO_SeatHold.Sel.LocationId);
qdefHold.addSelect(QryBO_SeatHold.Sel.LocationName);
qdefHold.addSelect(QryBO_SeatHold.Sel.OpAreaId);
qdefHold.addSelect(QryBO_SeatHold.Sel.OpAreaName);
qdefHold.addSelect(QryBO_SeatHold.Sel.WorkstationId);
qdefHold.addSelect(QryBO_SeatHold.Sel.WorkstationName);
qdefHold.addSelect(QryBO_SeatHold.Sel.UserAccountId);
qdefHold.addSelect(QryBO_SeatHold.Sel.UserAccountName);
qdefHold.addSelect(QryBO_SeatHold.Sel.HoldStatusDesc);
qdefHold.addSelect(QryBO_SeatHold.Sel.HoldDateTime);
qdefHold.addSelect(QryBO_SeatHold.Sel.ExpireDateTime);
qdefHold.addSelect(QryBO_SeatHold.Sel.TotNumSeats);
// Where
qdefHold.addFilter(QryBO_SeatHold.Fil.SeatHoldId, pageBase.getId());
// Sort
qdefHold.addSort(QryBO_SeatHold.Sel.HoldDateTime);
// Exec
JvDataSet dsHold = pageBase.execQuery(qdefHold);


JvDataSet dsSeat = pageBase.getDB().executeQuery(
    "select" + JvString.CRLF +
    "  P.PerformanceId," + JvString.CRLF +
    "  P.DateTimeFrom as PerformanceDateTime," + JvString.CRLF +
    "  P.EventId," +   JvString.CRLF +
    "  E.EventName," + JvString.CRLF +
    "  SP.AttributeItemId as SeatCategoryId," + JvString.CRLF +
    "  AI.AttributeItemName as SeatCategoryName," + JvString.CRLF +
    "  SP.SeatSectorId," + JvString.CRLF +
    "  SS.SeatSectorName," + JvString.CRLF +
    "  Coalesce(ParentSS.SeatSectorType, SS.SeatSectorType) as RootSectorType," + JvString.CRLF +
    "  SI.ColLabel," + JvString.CRLF +
    "  SI.RowLabel," + JvString.CRLF +
    "  SPL.Quantity" + JvString.CRLF +
    "from" + JvString.CRLF +
    "  tbSeatPerformanceLink SPL left join" + JvString.CRLF +
    "  tbSeatPerformance SP on SP.PerformanceId=SPL.PerformanceId and SP.SeatId=SPL.SeatId left join" + JvString.CRLF +
    "  tbPerformance P on P.PerformanceId=SP.PerformanceId left join" + JvString.CRLF +
    "  tbEvent E on E.EventId=P.EventId left join" + JvString.CRLF +
    "  tbSeatSector SS on SS.SeatSectorId=SP.SeatSectorId left join" + JvString.CRLF +
    "  tbSeatSector ParentSS on ParentSS.SeatSectorId=SS.ParentSectorId left join" + JvString.CRLF +
    "  tbAttributeItem AI on AI.AttributeItemId=SP.AttributeItemId left join" + JvString.CRLF +
    "  tbSeatInfo SI on SI.SeatId=SP.SeatId" + JvString.CRLF +
    "where" + JvString.CRLF +
    "  SPL.EntityId=" + JvString.sqlStr(pageBase.getId()) + JvString.CRLF +
    "order by" + JvString.CRLF +
    "  P.DateTimeFrom," + JvString.CRLF +
    "  P.PerformanceId");
%>

<v:dialog id="seat_hold_dialog" title="@Common.Details" width="600" height="500" autofocus="false">

<table style="width:100%; border-spacing:0px">
  <tr>
    <td width="50%" valign="top">
      <v:widget caption="@Common.Status">
        <v:widget-block>
          <v:itl key="@Common.Status"/>
          <span class="recap-value"><%=dsHold.getField(QryBO_SeatHold.Sel.HoldStatusDesc).getHtmlString()%></span>
          <br/>
          <v:itl key="@Common.Quantity"/>
          <span class="recap-value"><%=dsHold.getField(QryBO_SeatHold.Sel.TotNumSeats).getHtmlString()%></span>
        </v:widget-block>
        <v:widget-block>
          <v:itl key="@Common.DateTime"/>
          <snp:datetime timestamp="<%=dsHold.getField(QryBO_SeatHold.Sel.HoldDateTime)%>" format="shortdatetime" timezone="local" clazz="recap-value"/>
          <br/>
          <v:itl key="@Common.Expiration"/>
          <snp:datetime timestamp="<%=dsHold.getField(QryBO_SeatHold.Sel.ExpireDateTime)%>" format="shortdatetime" timezone="local" clazz="recap-value"/>
        </v:widget-block>
      </v:widget>
    </td>
    <td>&nbsp;&nbsp;</td>
    <td width="50%" valign="top">
      <v:widget caption="@Common.Source">
        <v:widget-block>
          <v:itl key="@Account.Location"/>
          <span class="recap-value">
            <snp:entity-link entityId="<%=dsHold.getField(QryBO_SeatHold.Sel.LocationId)%>" entityType="<%=LkSNEntityType.Location%>">
              <%=dsHold.getField(QryBO_SeatHold.Sel.LocationName).getHtmlString()%>
            </snp:entity-link>
          </span>
          <br/>
          <v:itl key="@Account.OpArea"/>
          <span class="recap-value">
            <snp:entity-link entityId="<%=dsHold.getField(QryBO_SeatHold.Sel.OpAreaId)%>" entityType="<%=LkSNEntityType.OperatingArea%>">
              <%=dsHold.getField(QryBO_SeatHold.Sel.OpAreaName).getHtmlString()%>
            </snp:entity-link>
          </span>
          <br/>
          <v:itl key="@Common.Workstation"/>
          <span class="recap-value">
            <snp:entity-link entityId="<%=dsHold.getField(QryBO_SeatHold.Sel.WorkstationId)%>" entityType="<%=LkSNEntityType.Workstation%>">
              <%=dsHold.getField(QryBO_SeatHold.Sel.WorkstationName).getHtmlString()%>
            </snp:entity-link>
          </span>
        </v:widget-block>
        <v:widget-block>
          <v:itl key="@Common.User"/>
          <span class="recap-value">
            <snp:entity-link entityId="<%=dsHold.getField(QryBO_SeatHold.Sel.UserAccountId)%>" entityType="<%=LkSNEntityType.Person%>">
              <%=dsHold.getField(QryBO_SeatHold.Sel.UserAccountName).getHtmlString()%>
            </snp:entity-link>
          </span>
        </v:widget-block>
      </v:widget>
    </td>
  </tr>
</table>

<v:grid>
  <thead>
    <tr>
      <td><v:itl key="@Seat.Sector"/></td>
      <td><v:itl key="@Seat.Category"/></td>
      <td align="right"><v:itl key="@Common.Quantity"/></td>
    </tr>
  </thead>
  <tbody>
    <% String lastPerformanceId = null; %>
    <v:ds-loop dataset="<%=dsSeat%>">
      <%
      if (!dsSeat.getField("PerformanceId").isSameString(lastPerformanceId)) {
        lastPerformanceId = dsSeat.getField("PerformanceId").getString(); 
        %>
        <tr class="group">
          <td colspan="100%">
            <snp:entity-link entityId="<%=dsSeat.getField(\"EventId\")%>" entityType="<%=LkSNEntityType.Event%>">
              <%=dsSeat.getField("EventName").getHtmlString()%>
            </snp:entity-link>
            &mdash;
            <snp:entity-link entityId="<%=dsSeat.getField(\"PerformanceId\")%>" entityType="<%=LkSNEntityType.Performance%>">
              <snp:datetime timestamp="<%=dsSeat.getField(\"PerformanceDateTime\")%>" format="shortdatetime" timezone="location" convert="false"/>
            </snp:entity-link>
          </td>
        </tr>
        <%
          }
          
          LookupItem sectorType = LkSN.SeatSectorType.getItemByCode(dsSeat.getField("RootSectorType"));
        %>
      <tr>
        <td><%=dsSeat.getField("SeatSectorName").getHtmlString()%></td>
        <td><%=dsSeat.getField("SeatCategoryName").getHtmlString()%></td>
        <td align="right">
          <%
            if (sectorType.isLookup(LkSNSeatSectorType.Capacity)) {
          %>
            <%=dsSeat.getField("Quantity").getInt()%>
          <% } else { %>
            <%=dsSeat.getField("RowLabel").getHtmlString()%>-<%=dsSeat.getField("ColLabel").getHtmlString()%>
          <% } %>
        </td>
      </tr>
    </v:ds-loop>
  </tbody>
<%-- 
  <tbody>
    <% String performanceId = null; %>
    <v:ds-loop dataset="<%=dsHoldItem%>">
      <% if (!dsHoldItem.getField(QryBO_SeatHoldItem.Sel.PerformanceId).isSameString(performanceId)) { %>
        <% performanceId = dsHoldItem.getField(QryBO_SeatHoldItem.Sel.PerformanceId).getString(); %>
        <tr class="group">
          <td colspan="100%">
            <a href="<v:config key="site_url"/>/admin?page=event&id=<%=dsHoldItem.getField(QryBO_SeatHoldItem.Sel.EventId).getEmptyString()%>">
              <%=dsHoldItem.getField(QryBO_SeatHoldItem.Sel.EventName).getHtmlString()%>
            </a>
            &raquo;
            <a href="<v:config key="site_url"/>/admin?page=performance&id=<%=dsHoldItem.getField(QryBO_SeatHoldItem.Sel.PerformanceId).getEmptyString()%>">
              <% dsHoldItem.getField(QryBO_SeatHoldItem.Sel.PerformanceDateTime).setDisplayFormat(pageBase.getShortDateTimeFormat()); %>
              <%=dsHoldItem.getField(QryBO_SeatHoldItem.Sel.PerformanceDateTime).getHtmlString()%>
            </a>
          </td>
        </tr>
      <% } %>
      <tr class="grid-row">
        <td><%=dsHoldItem.getField(QryBO_SeatHoldItem.Sel.SeatSectorName).getHtmlString()%></td>
        <td><%=dsHoldItem.getField(QryBO_SeatHoldItem.Sel.AttributeItemName).getHtmlString()%></td>
        <td align="right"><%=dsHoldItem.getField(QryBO_SeatHoldItem.Sel.NumSeats).getHtmlString()%></td>
      </tr>
    </v:ds-loop>
  </tbody>
--%>  
</v:grid>

<script>
var dlg = $("#seat_hold_dialog");
dlg.on("snapp-dialog", function(event, params) {
  params.buttons = {
    <v:itl key="@Common.Remove" encode="JS"/>: doRemoveHold,
    <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
  };
});

function doRemoveHold() {
  var reqDO = {
    Command: "ReleaseHold",
    ReleaseHold: {
      SeatHoldId: <%=JvString.jsString(pageBase.getId())%>
    }
  };
  
  vgsService("Seat", reqDO, false, function(ansDO) {
    triggerEntityChange(<%=LkSNEntityType.Performance.getCode()%>)
    $("#seat_hold_dialog").dialog("close");
  });
}
</script>

</v:dialog>