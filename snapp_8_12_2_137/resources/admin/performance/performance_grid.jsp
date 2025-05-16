<%@page import="com.vgs.snapp.library.SnappUtils"%>
<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="java.io.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Performance.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>
<% 
boolean xpiEvent = pageBase.isParameter("XPI", "true");
%>

<%
QueryDef qdef = new QueryDef(QryBO_Performance.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.CommonStatus);
qdef.addSelect(Sel.PerformanceId);
qdef.addSelect(Sel.PerformanceStatus);
qdef.addSelect(Sel.DateTimeFrom);
qdef.addSelect(Sel.DateTimeTo);
qdef.addSelect(Sel.PerformanceDesc);
qdef.addSelect(Sel.EventName);
qdef.addSelect(Sel.PerformanceTypeFromCalendar);
qdef.addSelect(Sel.CalcPerformanceTypeId);
qdef.addSelect(Sel.CalcPerformanceTypeName);
qdef.addSelect(Sel.CalcRateCodeId);
qdef.addSelect(Sel.CalcRateCodeCode);
qdef.addSelect(Sel.CalcRateCodeName);
qdef.addSelect(Sel.CalcRateCodeSymbol);
qdef.addSelect(Sel.LocationAccountId);
qdef.addSelect(Sel.LocationName);
qdef.addSelect(Sel.AccessAreaAccountId);
qdef.addSelect(Sel.AccessAreaName);
qdef.addSelect(Sel.MainResourceEntityType);
qdef.addSelect(Sel.MainResourceEntityId);
qdef.addSelect(Sel.MainResourceEntityName);
qdef.addSelect(Sel.SeatAllocation);
qdef.addSelect(Sel.QuantityFree);
qdef.addSelect(Sel.QuantityMax);
qdef.addSelect(Sel.SeatMapCount);
qdef.addSelect(Sel.SeatMapId);
qdef.addSelect(Sel.SoldOutWarnLimit);
qdef.addSelect(Sel.TagNames);
qdef.addSelect(Sel.CalcCalendarId);
qdef.addSelect(Sel.CalcCalendarCode);
qdef.addSelect(Sel.CalcCalendarName);

// Where
qdef.addFilter(Fil.EventId, pageBase.getNullParameter("EventId"));

if (pageBase.getNullParameter("Status") != null)
  qdef.addFilter(Fil.PerformanceStatus, JvArray.stringToIntArray(pageBase.getNullParameter("Status"), ","));

if (pageBase.getNullParameter("FromDate") != null) 
  qdef.addFilter(Fil.FromDate, pageBase.getNullParameter("FromDate"));

if (pageBase.getNullParameter("ToDate") != null)
  qdef.addFilter(Fil.ToDate, pageBase.getNullParameter("ToDate"));

if (pageBase.getNullParameter("FromDateTime") != null)
  qdef.addFilter(Fil.FromDateTime, pageBase.getNullParameter("FromDateTime"));

if (pageBase.getNullParameter("ToDateTime") != null)
  qdef.addFilter(Fil.ToDateTime, pageBase.getNullParameter("ToDateTime"));

if (pageBase.getNullParameter("FromTime") != null)
  qdef.addFilter(Fil.FromTime, pageBase.getNullParameter("FromTime"));

if (pageBase.getNullParameter("ToTime") != null)
  qdef.addFilter(Fil.ToTime, pageBase.getNullParameter("ToTime"));

if (pageBase.getNullParameter("WeekDays") != null)
  qdef.addFilter(Fil.WeekDays, JvArray.stringToArray(pageBase.getNullParameter("WeekDays"), ","));

if (pageBase.getNullParameter("LocationId") != null)
  qdef.addFilter(Fil.LocationAccountId, pageBase.getNullParameter("LocationId"));

if (pageBase.getNullParameter("PerformanceTypeId") != null)
  qdef.addFilter(Fil.CalcPerformanceTypeId, pageBase.getNullParameter("PerformanceTypeId"));

if (pageBase.getNullParameter("SeatSold") != null)
  qdef.addFilter(Fil.SeatSold, pageBase.getNullParameter("SeatSold"));

if (pageBase.getNullParameter("SeatMinQuantity") != null)
  qdef.addFilter(Fil.SeatMinQuantity, pageBase.getNullParameter("SeatMinQuantity"));

if (pageBase.getNullParameter("TagId") != null)
  qdef.addFilter(Fil.TagId, JvArray.stringToArray(pageBase.getNullParameter("TagId"), ","));

qdef.addFilter(Fil.ApplyFutureDaysRestriction, "true");

// Sort
qdef.addSort(Sel.DateTimeFrom);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);

//ds.setDisplayFormat(Sel.DateTimeFrom, pageBase.getShortDateTimeFormat());
//ds.setDisplayFormat(Sel.DateTimeTo, pageBase.getShortDateTimeFormat());

request.setAttribute("ds", ds);
%>

<style>
.prgbar-lbl {
  width: 100px;
  text-align: center;
  font-weight: bold; 
}
.prgbar-ext {
  width: 100px;
  height: 6px;
}
.prgbar-ext-gray {
  background-color: var(--base-gray-color);
}
.prgbar-ext-red {
  background-color: var(--base-red-color);
}
.prgbar-int {
  float: left;
  height: 6px;
}
.prgbar-int-green {
  background-color: var(--base-green-color);
}
.prgbar-int-orange {
  background-color: var(--base-orange-color);
}
</style>

<v:grid id="perf-grid-table" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Performance%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true" multipage="true"/></td>
      <td>&nbsp;</td>
      <td width="20%">
        <v:itl key="@Common.DateTime"/><br/>
        <v:itl key="@Common.Status"/>
      </td>
      <td width="20%">
        <v:itl key="@Event.Event"/><br/>
        <v:itl key="@Performance.PerformanceType"/>
      </td>
      <td width="20%">
        <v:itl key="@Account.Location"/><br/>
        <v:itl key="@Account.AccessArea"/>
      </td>
      <td width="20%">
        <v:itl key="@Resource.Resource"/><br/>
        <v:itl key="@Common.Description"/>
      </td>
      <td width="20%">
        <v:itl key="@Common.Tags"/><br/>
        <v:itl key="@Common.Calendar"/>
      </td>
      <td width="100px" align="center">
        <v:itl key="@Performance.Availability"/>
      </td>
    </tr>
  </thead>
  <tbody>
  <v:grid-row dataset="ds" dateGroupFieldName="DateTimeFrom">
    <% LookupItem commonStatus = LkSN.CommonStatus.getItemByCode(ds.getField(Sel.CommonStatus)); %>
    <% LookupItem performanceStatus = LkSN.PerformanceStatus.getItemByCode(ds.getField(Sel.PerformanceStatus)); %>
    <td style="<v:common-status-style status="<%=commonStatus%>"/>"><v:grid-checkbox name="cbPerformanceId" dataset="ds" fieldname="PerformanceId"/></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
    <td>
      <% String perfParam = xpiEvent ? "XPI=true" : "XPI=false"; %>
      <snp:entity-link entityId="<%=ds.getField(Sel.PerformanceId).getString()%>" entityType="<%=LkSNEntityType.Performance%>" clazz="list-title" params="<%=perfParam%>">
        <snp:datetime timestamp="<%=ds.getField(Sel.DateTimeFrom)%>" format="shortdatetime" timezone="location" convert="false"/>
      </snp:entity-link>
      <br/>
      <span class="list-subtitle"><%=performanceStatus.getHtmlDescription(pageBase.getLang())%><%if(commonStatus.isLookup(LkCommonStatus.FatalError)){%>&nbsp;(calendar mismatch)<%}%></span>
    </td>
    <td>
      <%=ds.getField(Sel.EventName).getHtmlString()%><br/>
      <span class="list-subtitle">
        <% String performanceTypeId = ds.getField(Sel.CalcPerformanceTypeId).getString(); %>
        <% if (performanceTypeId == null) { %>
          <v:itl key="@Common.Default"/>
        <% } else { %>
          <%=ds.getField(Sel.CalcPerformanceTypeName).getHtmlString()%>
        <% } %>
        
        <% String rcSymbol = ds.getField(Sel.CalcRateCodeSymbol).getString(); %>
        <% if (rcSymbol != null) { %>
          <span title="[<%=ds.getField(Sel.CalcRateCodeCode).getHtmlString()%>] <%=ds.getField(Sel.CalcRateCodeName).getHtmlString()%>"><i class="fa fa-<%=rcSymbol%>"></i></span>
        <% } %>
      </span>
    </td>
    <td>
      <% if (!ds.getField(Sel.LocationAccountId).isNull()) { %>
        <snp:entity-link entityId="<%=ds.getField(Sel.LocationAccountId)%>" entityType="<%=LkSNEntityType.Location%>">
          <%=ds.getField(Sel.LocationName).getHtmlString()%>
        </snp:entity-link>
      <% } %>
      &nbsp;<br/>
      <% if (!ds.getField(Sel.AccessAreaAccountId).isNull()) { %>
        <snp:entity-link entityId="<%=ds.getField(Sel.AccessAreaAccountId)%>" entityType="<%=LkSNEntityType.AccessArea%>">
          <%=ds.getField(Sel.AccessAreaName).getHtmlString()%>
        </snp:entity-link>
      <% } %>
    </td>
    <td>
      <% if (!ds.getField(Sel.MainResourceEntityId).isNull()) { %>
        <a href="<v:config key="site_url"/>/admin?page=account&id=<%=ds.getField(Sel.MainResourceEntityId).getHtmlString()%>"><%=ds.getField(Sel.MainResourceEntityName).getHtmlString()%></a>
      <% } %>&nbsp;<br/>
      <span class="list-subtitle"><%=ds.getField(Sel.PerformanceDesc).getHtmlString()%></span>
    </td>
    <td align="left">
      <span class="list-subtitle"><%=ds.getField(Sel.TagNames).getHtmlString()%></span>
      &nbsp;<br/>
      <% if (!ds.getField(Sel.CalcCalendarId).isNull()) { %>
        <snp:entity-link entityId="<%=ds.getField(Sel.CalcCalendarId).getString()%>" entityType="<%=LkSNEntityType.Calendar%>">
        <%=SnappUtils.calcEntityDesc(ds.getField(Sel.CalcCalendarCode).getString(), ds.getField(Sel.CalcCalendarName).getString())%>
        </snp:entity-link>
      <% } %>
    </td>
    <td align="center">
      <% if (ds.getField(Sel.SeatAllocation).getBoolean()) { %>
        <% 
        float percFree = (ds.getField(Sel.QuantityFree).getFloat() * 100.0f) / ds.getField(Sel.QuantityMax).getFloat();
        String clsext = (ds.getField(Sel.QuantityFree).getInt() > 0) ? "prgbar-ext-gray" : "prgbar-ext-red";
        String clsint = (percFree < ds.getField(Sel.SoldOutWarnLimit).getInt()) ? "prgbar-int-orange" : "prgbar-int-green";
        int seatMapCount = ds.getField(Sel.SeatMapCount).getInt();
        %>
        <% if (seatMapCount == 1) {%><a href="javascript:asyncDialogEasy('seat/seat_map_dialog', 'id=<%=ds.getField(Sel.SeatMapId).getHtmlString()%>')"><%}%>
        <div class="prgbar-lbl">
          <% if (ds.getField(Sel.QuantityFree).getInt() == 0) { %>
            <v:itl key="@Seat.SoldOut" transform="uppercase"/>
          <% } else { %>
            <%=ds.getField(Sel.QuantityFree).getInt()%> &nbsp; (<%=Math.round(percFree)%>%)
          <% } %>
        </div>
        <div class="prgbar-ext <%=clsext%>"><div class="prgbar-int <%=clsint%>" style="width:<%=percFree%>%"/></div></div>
        <% if (seatMapCount == 1) {%></a><%}%>
      <% } %>
    </td>
  </v:grid-row>
  </tbody>
</v:grid>