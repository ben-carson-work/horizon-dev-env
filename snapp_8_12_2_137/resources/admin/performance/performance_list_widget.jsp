<%@page import="com.vgs.web.library.BLBO_Event"%>
<%@page import="com.vgs.web.library.BLBO_Performance"%>
<%@page import="com.vgs.snapp.library.FtCRUD"%>
<%@page import="java.text.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PagePerformanceListWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
int[] defaultStatusFilter = LookupManager.getIntArray(LkSNPerformanceStatus.Draft, LkSNPerformanceStatus.OnSale, LkSNPerformanceStatus.Suspended, LkSNPerformanceStatus.Completed, LkSNPerformanceStatus.Interrupted);
boolean xpiEvent = pageBase.isParameter("XPI", "true");
String eventId = pageBase.getEmptyParameter("EventId");
String[] rightTagIDs = rights.PerformanceEdit_Tags.getArray();
boolean canEdit = (rights.PerformanceEdit_All.getBoolean() || pageBase.getBL(BLBO_Event.class).eventHasSharedTagsWithRight(eventId, null, rightTagIDs)) && !xpiEvent;
boolean canCreate = canEdit; 
%>

<script>
function showPerfCreate() {
  asyncDialogEasy("performance/performance_create_dialog", "EventId=<%=pageBase.getEmptyParameter("EventId")%>");
}

function search() {
  setGridUrlParam("#perf-grid", "FromDateTime", $("#FromDateTime-picker").getXMLDateTime());
  setGridUrlParam("#perf-grid", "ToDateTime", $("#ToDateTime-picker").getXMLDateTime());

  setGridUrlParam("#perf-grid", "FromTime", $("#FromTime").getXMLTime());
  setGridUrlParam("#perf-grid", "ToTime", $("#ToTime").getXMLTime());

  setGridUrlParam("#perf-grid", "WeekDays", $("[name='WeekDays']").getCheckedValues());
  
  var status = $("input[name='Status']:checked").map(function () {return this.value;}).get().join(",");
  setGridUrlParam("#perf-grid", "Status", status);
  
  var filterAvail = $("[name='FilterAvail']:checked").val();
  if (filterAvail == "max")
    setGridUrlParam("#perf-grid", "SeatMinQuantity", "100000");
  else if (filterAvail == "min")
    setGridUrlParam("#perf-grid", "SeatMinQuantity", $("#FilterAvailQuantity").val());
  else
    setGridUrlParam("#perf-grid", "SeatMinQuantity", "");
    
  setGridUrlParam("#perf-grid", "LocationId", $("#LocationId").val());
  setGridUrlParam("#perf-grid", "PerformanceTypeId", $("#PerformanceTypeId").val());
  setGridUrlParam("#perf-grid", "TagId", $("#TagId").getStringArray(), true);
}

function showPerfMultiEditDialog() {
  var perfIDs = $("[name='cbPerformanceId']").getCheckedValues();
  var queryBase64 = null;
  if ($("#perf-grid-table").hasClass("multipage-selected")) {
    perfIDs = "";            
    queryBase64 = $("#perf-grid-table").attr("data-QueryBase64");
  }

  asyncDialogEasy("performance/performance_multiedit_dialog", "PerformanceIDs=" + perfIDs, {"QueryBase64": queryBase64});
}

</script>


<v:page-form id="perflist-form">
<input type="hidden" name="EventId" value="<%=pageBase.getEmptyParameter("EventId")%>"/>
<input type="hidden" name="NewPerformanceStatus"/>

<div class="tab-toolbar">
  <v:button caption="@Common.Search" fa="search" onclick="search()" />
  <span class="divider"></span>

  <div class="btn-group">
    <v:button caption="@Common.New" fa="plus" bindGrid="perf-grid" bindGridEmpty="true" onclick="showPerfCreate()" enabled="<%=canCreate%>"/>
    <v:button caption="@Common.Edit" fa="pencil" onclick="showPerfMultiEditDialog()" bindGrid="perf-grid" enabled="<%=canEdit%>"/>
  </div>

  <% String clickImport = "asyncDialogEasy('performance/performance_import_dialog', 'id=" + pageBase.getId() + "')"; %>
  <v:button caption="@Common.Import" fa="sign-in" onclick="<%=clickImport%>" enabled="<%=canEdit%>"/>
  
  <% if (rights.History.getBoolean()) { %>
    <span class="divider"></span>
    <% String onclick="showHistoryLog(" + LkSNEntityType.Performance.getCode() + ")";%>
    <v:button caption="@Common.History" fa="history" onclick="<%=onclick%>"/>
  <% } %>
  
  <v:pagebox gridId="perf-grid"/>
</div>

<div class="tab-content">
  <v:last-error/>
  
  <div id="main-container">
    <div id="filter-column" class="profile-pic-div">
      <v:widget caption="@Common.DateRange">
        <v:widget-block>
          <v:itl key="@Common.From"/><br/>
          <v:input-text type="datetimepicker" field="FromDateTime" clazz="perf-date-range" style="width:120px"/>
          
          <div class="divider"></div>
  
          <v:itl key="@Common.To"/><br/>
          <v:input-text type="datetimepicker" field="ToDateTime" clazz="perf-date-range" style="width:120px"/>
        </v:widget-block>

        <v:widget-block>
          <v:itl key="@Common.FromTime"/><br/>
          <v:input-text type="timepicker" field="FromTime"/>
          <br/>
          <v:itl key="@Common.ToTime"/><br/>
          <v:input-text type="timepicker" field="ToTime"/>
        </v:widget-block>

        <v:widget-block>
          <% DateFormatSymbols symbols = new DateFormatSymbols(pageBase.getLocale()); %>
          <% String[] dayNames = symbols.getShortWeekdays(); %>
          <table style="width:100%">
            <tr>
              <td><v:db-checkbox field="WeekDays" caption="<%=dayNames[2]%>" value="mon"/></td>
              <td><v:db-checkbox field="WeekDays" caption="<%=dayNames[3]%>" value="tue"/></td>
              <td><v:db-checkbox field="WeekDays" caption="<%=dayNames[4]%>" value="wed"/></td>
              <td><v:db-checkbox field="WeekDays" caption="<%=dayNames[5]%>" value="thu"/></td>
              <td><v:db-checkbox field="WeekDays" caption="<%=dayNames[6]%>" value="fri"/></td>
            </tr>
            <tr>
              <td><v:db-checkbox field="WeekDays" caption="<%=dayNames[7]%>" value="sat"/></td>
              <td><v:db-checkbox field="WeekDays" caption="<%=dayNames[1]%>" value="sun"/></td>
              <td></td>
              <td></td>
              <td></td>
            </tr>
          </table>
        </v:widget-block>
      </v:widget>

      <v:widget caption="@Common.Status">
        <v:widget-block>
        <% for (LookupItem status : LkSN.PerformanceStatus.getItems()) { %>
          <v:db-checkbox field="Status" caption="<%=status.getDescription(pageBase.getLang())%>" value="<%=String.valueOf(status.getCode())%>" checked="<%=JvArray.contains(status.getCode(), defaultStatusFilter)%>" /><br/>
        <% } %>
        </v:widget-block>
      </v:widget>

      <v:widget caption="@Performance.FilterAvail">
        <v:widget-block>
          <label class="checkbox-label"><input type="radio" name="FilterAvail" value="all" checked/> <v:itl key="@Performance.FilterAvailAll"/></label><br/>
          <label class="checkbox-label"><input type="radio" name="FilterAvail" value="max"/> <v:itl key="@Performance.FilterAvailMax"/></label><br/>
          <label class="checkbox-label"><input type="radio" name="FilterAvail" value="min"/> <v:itl key="@Performance.FilterAvailMin"/></label>
          <input type="text" id="FilterAvailQuantity" value="1" style="width:100px">
          
          <script>
            function refreshFilterAvail() {
              $("#FilterAvailQuantity").setClass("v-hidden", $("[name='FilterAvail']:checked").val() != "min");
            }
            refreshFilterAvail();
            $("[name='FilterAvail']").change(refreshFilterAvail);
          </script>
        </v:widget-block>
      </v:widget>

      <v:widget caption="@Common.Filters">
        <v:widget-block>
          <v:itl key="@Account.Location"/><br/>
          <snp:dyncombo id="LocationId" entityType="<%=LkSNEntityType.Location%>" auditLocationFilter="true" allowNull="true"/>
          
          <div class="filter-divider"></div>
          
          <v:itl key="@Performance.PerformanceType"/><br/>
          <v:combobox field="PerformanceTypeId" lookupDataSetName="dsPerfTypeAll" idFieldName="PerformanceTypeId" captionFieldName="PerformanceTypeName"/>
          
          <div class="filter-divider"></div>

          <v:itl key="@Common.Tags"/><br/>
          <v:multibox field="TagId" lookupDataSetName="dsPerfTags" idFieldName="TagId" captionFieldName="TagName"/>            
        </v:widget-block>
      </v:widget>
    </div>
    
    <div class="profile-cont-div">
      <% String params = "EventId=" + pageBase.getParameter("EventId") + "&readonly=" + !canEdit + "&XPI=" + xpiEvent + "&FromDateTime=" + pageBase.getEmptyParameter("FromDateTime") + "&Status=" + JvArray.arrayToString(defaultStatusFilter, ","); %>
      <v:async-grid id="perf-grid" jsp="performance/performance_grid.jsp" params="<%=params%>" />   
    </div>
  </div>
</div>


</v:page-form>