<%@page import="java.text.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" scope="request" class="com.vgs.snapp.web.common.page.PageCommonWidget"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="task" class="com.vgs.snapp.dataobject.DOTask" scope="request"/>
<jsp:useBean id="cfg" class="com.vgs.snapp.dataobject.task.DOTask_DataExport" scope="request"/>

<div class="tab-content">
  
  <v:widget caption="@Common.Schedule">
    <v:widget-block>
      <v:form-field caption="@Task.Frequency">
        <select id="task.TaskFrequency" class="form-control"></select>
      </v:form-field>
    </v:widget-block>
    
    <v:widget-block id="freq-monthly" clazz="v-hidden">
      <v:form-field caption="@Task.DayOfMonth">
        <v:input-text field="task.DayOfMonth"/>
      </v:form-field>
      <v:form-field caption="@Common.Time">
        <v:input-text type="timepicker" field="task.MonthlyTime"/>
      </v:form-field>
      <v:form-field caption="@Common.TimeZone">
        <v:lk-combobox field="task.MonthlyTimeZone" lookup="<%=LkSN.TimeZone%>" allowNull="false"/>
      </v:form-field>
    </v:widget-block>
    
    <v:widget-block id="freq-daily" clazz="v-hidden">
      <v:form-field caption="@Common.Time">
        <v:input-text type="timepicker" field="task.DailyTime"/>
      </v:form-field>
      <v:form-field caption="@Common.TimeZone">
        <v:lk-combobox field="task.DailyTimeZone" lookup="<%=LkSN.TimeZone%>" allowNull="false"/>
      </v:form-field>
    </v:widget-block>
    
    <v:widget-block id="freq-recurrent" clazz="v-hidden">
      <v:form-field caption="@Common.FromTime">
        <v:input-text type="timepicker" field="task.TimeFrom"/>
      </v:form-field>
      <v:form-field caption="@Common.ToTime">
        <v:input-text type="timepicker" field="task.TimeTo"/>
      </v:form-field>
      <v:form-field caption="@Task.IntervalMins">
        <v:input-text field="task.Interval"/>
      </v:form-field>
      <v:form-field caption="@Common.TimeZone">
        <v:lk-combobox field="task.TimeZone" lookup="<%=LkSN.TimeZone%>" allowNull="false"/>
      </v:form-field>
    </v:widget-block>
    
    <v:widget-block id="schedule-dow" clazz="v-hidden">
      <v:form-field caption="@Task.DaysOfWeek">
        <% DateFormatSymbols symbols = new DateFormatSymbols(pageBase.getLocale()); %>
        <v:db-checkbox field="task.ActiveMon" caption="<%=JvString.getPascalCase(symbols.getShortWeekdays()[2])%>" value="true"/>&nbsp;&nbsp;
        <v:db-checkbox field="task.ActiveTue" caption="<%=JvString.getPascalCase(symbols.getShortWeekdays()[3])%>" value="true"/>&nbsp;&nbsp;
        <v:db-checkbox field="task.ActiveWed" caption="<%=JvString.getPascalCase(symbols.getShortWeekdays()[4])%>" value="true"/>&nbsp;&nbsp;
        <v:db-checkbox field="task.ActiveThu" caption="<%=JvString.getPascalCase(symbols.getShortWeekdays()[5])%>" value="true"/>&nbsp;&nbsp;
        <v:db-checkbox field="task.ActiveFri" caption="<%=JvString.getPascalCase(symbols.getShortWeekdays()[6])%>" value="true"/>&nbsp;&nbsp;
        <v:db-checkbox field="task.ActiveSat" caption="<%=JvString.getPascalCase(symbols.getShortWeekdays()[7])%>" value="true"/>&nbsp;&nbsp;
        <v:db-checkbox field="task.ActiveSun" caption="<%=JvString.getPascalCase(symbols.getShortWeekdays()[1])%>" value="true"/>&nbsp;&nbsp;
      </v:form-field>
    </v:widget-block>

    <v:widget-block id="freq-trigger" clazz="v-hidden">
      <table class="form-table">
        <tr>
          <th><v:itl key="@Common.Type"/></th>
          <td><v:lk-combobox lookup="<%=LkSN.TriggerType%>" field="trigger-combo"/></td>
        </tr>
      </table>
    </v:widget-block>
    <v:widget-block id="trigger-log-cfg" clazz="v-hidden">
      <v:grid>
        <thead>
          <tr>
            <td>Log Level</td>
            <td>Entity Type</td>
            <td>Source</td>
          </tr>
        </thead>
        <tbody id="tbody-log">
        </tbody>
      </v:grid>
    </v:widget-block>
  </v:widget>
</div>


<script>
$(document).ready(function() {
  var combo = $("#task\\.TaskFrequency");
  <% for (LookupItem item : LookupManager.getArray(LkSNTaskFrequency.Monthly, LkSNTaskFrequency.Daily, LkSNTaskFrequency.Recurrent)) { %>
    $("<option/>").appendTo(combo).val(<%=item.getCode()%>).text(<%=JvString.jsString(item.getDescription(pageBase.getLang()))%>);
  <% } %>
  <% if (!task.TaskFrequency.isNull()) { %>
    combo.val(<%=task.TaskFrequency.getInt()%>);
  <% } %>
  
  combo.change(enableDisable);
  $("#trigger-combo").change(enableDisable);
  enableDisable();
});

function enableDisable() {
  var freq = $("#task\\.TaskFrequency").val();
  $("#schedule-dow").setClass("v-hidden", (freq != "<%=LkSNTaskFrequency.Daily.getCode()%>") && (freq != "<%=LkSNTaskFrequency.Recurrent.getCode()%>")); 
  $("#freq-monthly").setClass("v-hidden", freq != "<%=LkSNTaskFrequency.Monthly.getCode()%>"); 
  $("#freq-daily").setClass("v-hidden", freq != "<%=LkSNTaskFrequency.Daily.getCode()%>"); 
  $("#freq-recurrent").setClass("v-hidden", freq != "<%=LkSNTaskFrequency.Recurrent.getCode()%>"); 
}

</script>