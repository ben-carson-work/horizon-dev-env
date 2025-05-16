<%@page import="com.vgs.snapp.library.FtCRUD"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="perf" class="com.vgs.snapp.dataobject.DOPerformance" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%
boolean canEdit = pageBase.getBL(BLBO_Performance.class).checkRightsNoExceptions(perf.EventId.getString(), perf.PerformanceId.getString());
boolean autoCreated = perf.AutoCreated.getBoolean();

JvDataSet dsCalendar = pageBase.getBL(BLBO_Calendar.class).getCalendarDS(perf.CalendarId.getString());
JvDataSet dsPerfType = pageBase.getBL(BLBO_PerformanceType.class).getDS(perf.EventId.getString());
JvDataSet dsRateCode = pageBase.getBL(BLBO_RateCode.class).getDS();
%>

<div class="tab-content">
  <v:widget caption="@Performance.Schedule">
    <v:widget-block>
      <v:form-field caption="@Common.Status">
        <v:lk-combobox lookup="<%=LkSN.PerformanceStatus%>" field="perf.PerformanceStatus" enabled="<%=canEdit && !autoCreated%>"/>
      </v:form-field>
      <v:form-field caption="@Performance.StartTime">
        <v:input-text type="datetimepicker" field="perf.DateTimeFrom" enabled="<%=canEdit && !autoCreated%>"/>
      </v:form-field>
      <v:form-field caption="@Performance.EndTime">
        <v:input-text type="datetimepicker" field="perf.DateTimeTo" enabled="<%=canEdit && !autoCreated%>"/>
      </v:form-field>
      <v:form-field caption="@Common.Description">
        <v:input-text field="perf.PerformanceName" enabled="<%=canEdit%>"/>
      </v:form-field>
      <% String hrefTag = "javascript:showTagPickupDialog_OLD(" + LkSNEntityType.Performance.getCode() + ",'perf.TagIDs')"; %>
      <v:form-field caption="@Common.Tags" href="<%=hrefTag%>">
        <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.Performance); %>
        <v:multibox field="perf.TagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName" enabled="<%=canEdit%>"/>
      </v:form-field>
      
    </v:widget-block>
  </v:widget>
  
  <v:widget caption="@Performance.Sale">
    <v:widget-block>
      <v:form-field caption="@Lookup.PerformanceStatus.OnSale">
        <v:input-text type="datepicker" field="perf.OnSaleFrom" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
        &nbsp;&nbsp;&nbsp;
        <v:itl transform="lowercase" key="@Common.To"/>
        &nbsp;&nbsp;&nbsp;
        <v:input-text type="datepicker" field="perf.OnSaleTo" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <div><v:db-checkbox field="perf.RestrictOpenOrder" caption="@Common.RestrictOpenOrder" hint="@Common.RestrictOpenOrderHint" value="true"/></div>
      <div><v:db-checkbox field="perf.DynRateCode" caption="@Performance.DynRateCode" hint="@Performance.DynRateCodeHint" value="true"/></div>
      <div><v:db-checkbox field="perf.PerformanceTypeFromCalendar" value="true" caption="@Performance.PerformanceTypeFromCalendar"/></div>
    </v:widget-block>
    <v:widget-block id="calendar-block">
      <v:form-field caption="@Common.Calendar" hint="@Performance.CalendarHint">
        <v:combobox field="perf.CalendarId" lookupDataSet="<%=dsCalendar%>" idFieldName="CalendarId" captionFieldName="CalendarName" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block id="perftype-block">
      <v:form-field caption="@Performance.PerformanceType">
        <v:combobox field="perf.PerformanceTypeId" lookupDataSet="<%=dsPerfType%>" idFieldName="PerformanceTypeId" captionFieldName="PerformanceTypeName" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Common.RateCode">
        <v:combobox field="perf.RateCodeId" lookupDataSet="<%=dsRateCode%>" idFieldName="RateCodeId" captionFieldName="RateCodeName" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
</div>


<style>

select.time {
  width: 50px;
}

</style>


<script>
var oldDateTimeFrom = new Date(<%=perf.DateTimeFrom.getDateTime().getGMTInMills()%>);
var oldDateTimeTo = new Date(<%=perf.DateTimeTo.getDateTime().getGMTInMills()%>);

function dateTimeFromChanged() {
  duration = oldDateTimeTo.getTime() - oldDateTimeFrom.getTime();
  var newDateTimeFrom = xmlToDate($("#perf\\.DateTimeFrom-picker").getXMLDateTime());
  var newDateTimeTo = new Date(newDateTimeFrom.getTime() + duration);
  $("#perf\\.DateTimeTo-picker").datepicker("setDate", newDateTimeTo);
  $("#perf\\.DateTimeTo-HH").val(leadZero(newDateTimeTo.getHours(), 2));
  $("#perf\\.DateTimeTo-MM").val(leadZero(newDateTimeTo.getMinutes(), 2));
  oldDateTimeFrom = newDateTimeFrom;
  oldDateTimeTo = newDateTimeTo;
}

function dateTimeToChanged() {
  oldDateTimeTo = xmlToDate($("#perf\\.DateTimeTo-picker").getXMLDateTime());
}

function perfTypeFromCalChanged() {
  var checked = $("#perf\\.PerformanceTypeFromCalendar").isChecked();
  $("#perftype-block").setClass("hidden", checked);  
  $("#calendar-block").setClass("hidden", !checked);  
}

$("#perf\\.DateTimeFrom-picker").change(dateTimeFromChanged);
$("#perf\\.DateTimeFrom-HH").change(dateTimeFromChanged);
$("#perf\\.DateTimeFrom-MM").change(dateTimeFromChanged);
$("#perf\\.DateTimeTo-picker").change(dateTimeToChanged);
$("#perf\\.DateTimeTo-HH").change(dateTimeToChanged);
$("#perf\\.DateTimeTo-MM").change(dateTimeToChanged);
$("#perf\\.PerformanceTypeFromCalendar").change(perfTypeFromCalChanged);
perfTypeFromCalChanged();

</script>



