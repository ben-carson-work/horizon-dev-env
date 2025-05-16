<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTicket" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="ticket" class="com.vgs.snapp.dataobject.DOTicket" scope="request"/>

<v:tab-content>
  <v:profile-recap>
    <v:widget caption="@Common.Filters">
      <v:widget-block>
        <div><v:db-checkbox field="cbRedeemed" value="true" checked="true" caption="@Performance.Redeemed" onclick="applyFilters()"/></div>
        <div><v:db-checkbox field="cbNotRedeemed" value="true" checked="true" caption="@Performance.NotRedeemed" onclick="applyFilters()"/></div>
        <div><v:db-checkbox field="cbPastDate" value="true" checked="false" caption="@Performance.PastPerformances" onclick="applyFilters()"/></div>
      </v:widget-block>
    </v:widget>

    <% List<DOEventSmallRef> events = SnappUtils.getSmallEventList(ticket.TicketPerformanceList.getItems(), true); %>
    <v:widget caption="@Event.Events" include="<%=!events.isEmpty()%>">
      <v:widget-block>
        <div><v:radio name="EventFilter" value="ALL" caption="@Common.All" checked="true" onclick="applyFilters()"/></div>
        <% for (DOEventSmallRef event : events) { %>
          <div><v:radio name="EventFilter" value="<%=event.EventId.getString()%>" caption="<%=event.EventName.getString()%>" onclick="applyFilters()"/></div>
        <% } %>
      </v:widget-block>
    </v:widget>
  </v:profile-recap>

  <v:profile-main>
    <v:grid>
      <thead>
        <tr>
          <td></td>
          <td width="25%">
            <div><v:itl key="@Common.DateTime"/></div>
            <div><v:itl key="@Ticket.FirstUsageDateTime"/></div>
          </td>
          <td width="25%">
            <div><v:itl key="@Event.Event"/></div>
            <div><v:itl key="@Account.Location"/></div>
          </td>
          <td width="50%">
            <div><v:itl key="@Performance.Exceptions"/></div>
            <div><v:itl key="@Seat.Seat"/></div>
          </td>
        </tr>
      </thead>
      <tbody id="ticketperf-tbody">
      <% String lastMonth = null; %>
      <% for (DOTicketRef.DOTicketPerformanceRef ticketPerf : ticket.TicketPerformanceList.filter(x -> x.ValidForAdmission.getBoolean())) { %>
        <%
        DOPerformanceRef perf = ticketPerf.Performance;
        JvDateTime locationFiscalDate = pageBase.getBLDef().getLocationFiscalDate(perf.LocationId.getString());
        JvDateTime perfFiscalDate = pageBase.getFiscalDate(perf.DateTimeFrom.getDateTime());
        String format = perf.EventType.isLookup(LkSNEventType.GenAdm, LkSNEventType.DatedEvent) ? pageBase.getMonthDateFormat() : pageBase.getShortDateTimeFormat();
        String thisMonth = perf.DateTimeFrom.getDateTime().format("MMMM yyyy");
        boolean pastDate = perfFiscalDate.getDatePart().isBefore(locationFiscalDate);
        if (!JvString.isSameText(thisMonth, lastMonth)) {
          lastMonth = thisMonth;
          %><tr class="group"><td colspan="100%"><%=JvString.htmlEncode(thisMonth)%></td></tr><% 
        }
        %>
        <tr class="grid-row" data-redeemed="<%=!ticketPerf.FirstUsageDateTime.isNull()%>" data-pastdate="<%=pastDate%>" data-eventId="<%=perf.EventId.getString()%>">
          <td><v:grid-icon name="<%=LkSNEntityType.Event.getIconName()%>" repositoryId="<%=perf.EventProfilePictureId%>"/></td>
          <td>
            <div class="list-title">
              <snp:entity-link entityType="<%=LkSNEntityType.Performance%>" entityId="<%=perf.PerformanceId%>">
                <%=JvString.htmlEncode(perf.DateTimeFrom.getDateTime().format(format))%>
              </snp:entity-link>
            </div>
            <div class="list-subtitle">
              <% if (ticketPerf.FirstUsageDateTime.isNull()) { %>
                <v:itl key="@Ticket.NotUsed"/>
              <% } else { %>
                <snp:datetime timestamp="<%=ticketPerf.FirstUsageDateTime%>" format="shortdatetime" timezone="location" location="<%=ticketPerf.Performance.LocationId%>"/>
              <% } %>
            </div>
          </td>
          <td>
            <div class="list-title">
              <snp:entity-link entityType="<%=LkSNEntityType.Event%>" entityId="<%=perf.EventId%>">
                <%=perf.EventName.getHtmlString()%>
              </snp:entity-link>
            </div>
            <div class="list-subtitle">
              <% if (perf.LocationId.isNull()) { %>
                &mdash;
              <% } else { %>
                <snp:entity-link entityType="<%=LkSNEntityType.Location%>" entityId="<%=perf.LocationId%>">
                  <%=perf.EventName.getHtmlString()%>
                </snp:entity-link>
              <% } %>
            </div>
          </td>
          <td>
            <div class="list-title">
              <% String exceptions = SnappUtils.calcTicketPerformanceExceptionsLabel(ticketPerf.Exception, pageBase.getLang(), pageBase.getShortTimeFormat()); %>
              <v:itl key="<%=exceptions%>"/>
            </div>
            <div class="list-subtitle">
              <%=ticketPerf.SeatName.getHtmlString()%>
            </div>
          </td>
        </tr>
      <% } %>
      </tbody>
    </v:grid>
  </v:profile-main>
</v:tab-content>
  
<script>
$(document).ready(applyFilters);

function applyFilters() {
  $("#ticketperf-tbody .grid-row").each(function(index, elem) {
    var $tr = $(elem);
    var redeemed = $tr.attr("data-redeemed") == "true";
    var pastDate = $tr.attr("data-pastdate") == "true";
    var eventId = $tr.attr("data-eventid");
    var eventFilter = $("[name='EventFilter']:checked").val();
    var visible = ($("#cbRedeemed").isChecked() && redeemed) || ($("#cbNotRedeemed").isChecked() && !redeemed);
    visible = visible && ($("#cbPastDate").isChecked() || !pastDate);
    visible = visible && ((eventFilter == "ALL") || (eventFilter == eventId));
    $tr.setClass("hidden", !visible)
  });  

  $("#ticketperf-tbody tr.group").each(function(index, elem) {
    var $group = $(elem);
    var $next = $group.next(":not(.hidden)");
    $group.setClass("hidden", ($next.length == 0) || $next.is(".group"));
  });  
}
</script>
