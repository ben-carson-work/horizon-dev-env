<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="java.text.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.task.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTask" scope="request"/>
<jsp:useBean id="task" class="com.vgs.snapp.dataobject.DOTask" scope="request"/>


<style>
  #trigger-list .trigger-item {
    display: block;
  }
  
  #tbody-log select {
    width: 100%;
  }
</style>

<%
  QueryDef qdef = new QueryDef(QryBO_Workstation.class)
    .addSort(QryBO_Workstation.Sel.LocationDisplayName)
    .addSort(QryBO_Workstation.Sel.OpAreaDisplayName)
    .addSort(QryBO_Workstation.Sel.WorkstationName)
    .addSelect(
        QryBO_Workstation.Sel.WorkstationId,
        QryBO_Workstation.Sel.WorkstationName,
        QryBO_Workstation.Sel.OpAreaAccountId,
        QryBO_Workstation.Sel.OpAreaDisplayName,
        QryBO_Workstation.Sel.LocationAccountId,
        QryBO_Workstation.Sel.LocationDisplayName);

  JvDataSet ds = pageBase.execQuery(qdef);

  boolean   enabled            = task.TaskStatus.isLookup(LkSNTaskStatus.Active);
  boolean   canEdit            = !task.TaskStatus.isLookup(LkSNTaskStatus.Completed);
  boolean   extPackageDisabled = !task.ExtensionPackageEnabled.isNull() && !task.ExtensionPackageEnabled.getBoolean();
  boolean   isTaskEnabled      = BLBO_Siae.isSiaeTask(task.ClassAlias.getString()) ? BLBO_Siae.SIAE_SYSTEM_VERIFIED : true;
  boolean   isMaintenanceTask  = task.TaskType.isLookup(LkSNTaskType.GenericMaintenanceTask);
  JvDataSet dsTask             = pageBase.getBL(BLBO_Task.class).getTaskDS(LkSNTaskType.GenericSystemTask, LkSNTaskType.GenericOperationalTask);
  
  boolean   hasLinkedTasks = false;
  JvDataSet dsLinkedTasks  = null;
  if (!pageBase.isNewItem()) {
    dsLinkedTasks  = pageBase.getBL(BLBO_Task.class).getLinkedTasksDS(task.TaskId.getString());
    hasLinkedTasks = !dsLinkedTasks.isEmpty();
  } 
%>

<div id="combo-dummy" class="hidden">
<select class="combo-wks"><option></option>
<% String lastLocationId = null; %>
<% String lastOpAreaId = null; %>
<% while (!ds.isEof()) { %>
  <!-- LOCATION -->
  <% if (!ds.getField(QryBO_Workstation.Sel.LocationAccountId).isSameString(lastLocationId)) { %>
    <option 
        value="L<%=ds.getField(QryBO_Workstation.Sel.LocationAccountId).getHtmlString()%>"
        data-LocationId="<%=ds.getField(QryBO_Workstation.Sel.LocationAccountId).getHtmlString()%>"
        >&#9679; <%=ds.getField(QryBO_Workstation.Sel.LocationDisplayName).getHtmlString()%></option>
    <% lastLocationId = ds.getField(QryBO_Workstation.Sel.LocationAccountId).getString(); %>
  <% } %>
  <!-- OP.AREA -->
  <% if (!ds.getField(QryBO_Workstation.Sel.OpAreaAccountId).isSameString(lastOpAreaId)) { %>
    <option 
        value="O<%=ds.getField(QryBO_Workstation.Sel.OpAreaAccountId).getHtmlString()%>" 
        data-LocationId="<%=ds.getField(QryBO_Workstation.Sel.LocationAccountId).getHtmlString()%>"
        data-OpAreaId="<%=ds.getField(QryBO_Workstation.Sel.OpAreaAccountId).getHtmlString()%>"
        >&nbsp;&nbsp;&nbsp;&raquo; <%=ds.getField(QryBO_Workstation.Sel.OpAreaDisplayName).getHtmlString()%></option>
    <% lastOpAreaId = ds.getField(QryBO_Workstation.Sel.OpAreaAccountId).getString(); %>
  <% } %>
  <!-- WORKSTATION -->
  <option 
      value="W<%=ds.getField(QryBO_Workstation.Sel.WorkstationId).getHtmlString()%>" 
      data-LocationId="<%=ds.getField(QryBO_Workstation.Sel.LocationAccountId).getHtmlString()%>" 
      data-OpAreaId="<%=ds.getField(QryBO_Workstation.Sel.OpAreaAccountId).getHtmlString()%>"
      data-WorkstationId="<%=ds.getField(QryBO_Workstation.Sel.WorkstationId).getHtmlString()%>"
      >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=ds.getField(QryBO_Workstation.Sel.WorkstationName).getHtmlString()%></option>
  <% ds.next(); %>
<% } %>
</select>

<v:lk-combobox clazz="combo-LogLevel" lookup="<%=LkSN.LogLevel%>" allowNull="false"/>
<v:lk-combobox clazz="combo-EntityType" lookup="<%=LkSN.EntityType%>"/>
</div>

<v:page-form id="taskconfig-form">

<% if (!task.TaskStatus.isLookup(LkSNTaskStatus.Completed)) { %>
  <v:tab-toolbar>
    <v:button caption="@Common.Save" fa="save" href="javascript:saveTask()" enabled="<%=(!task.TaskStatus.isLookup(LkSNTaskStatus.Deleted) && !extPackageDisabled)%>"/>
    <snp:notes-btn entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.Task%>"/>
    <% if (!pageBase.isNewItem() && !isMaintenanceTask) { %>
      <v:button caption="@Task.ManualFire" fa="bolt" onclick="doManualFire()" enabled="<%=(!task.TaskStatus.isLookup(LkSNTaskStatus.Deleted) && !extPackageDisabled && isTaskEnabled) %>"/>
    <% } %>
  </v:tab-toolbar>
<% } %>

<v:tab-content>
  <v:profile-recap>
    <v:widget caption="@Common.Recap">
      <% if (isMaintenanceTask) { %>
        <% if (!pageBase.isNewItem()) { %>
          <v:widget-block>
            <v:filter-field caption="@Common.Status">
              <snp:task-progress-bar taskId="<%=task.TaskId.getEmptyString()%>"/>
            </v:filter-field>
          </v:widget-block>
        <% } %>
      <% } else { %>
        <v:widget-block>
          <% if (task.TaskType.isLookup(LkSNTaskType.GenericOperationalTask)) { %>
            <v:filter-field caption="@Common.Name">
              <v:input-text field="task.TaskName" clazz="default-focus" enabled="<%=canEdit%>"/>
            </v:filter-field>
          <% } %>
          <v:filter-field caption="@ServerProfile.ServerProfiles" hint="@Task.ServerProfilesHint">
            <v:multibox
                field="task.ServerProfileIDs" 
                lookupDataSet="<%=pageBase.getBL(BLBO_ServerProfile.class).getServerProfileDS()%>" 
                idFieldName="ServerProfileId" 
                codeFieldName="ServerProfileCode" 
                captionFieldName="ServerProfileName" 
                placeholder="@Common.Any" 
                enabled="<%=canEdit%>"/>
          </v:filter-field>
          <v:filter-field caption="@Task.PurgeDays" hint="@Task.PurgeDaysHint">
            <v:input-text field="task.PurgeDays" placeholder="@Task.AsDefault" enabled="<%=canEdit%>"/>
          </v:filter-field>
        </v:widget-block>
      <% } %>
      
      <% if (!task.TaskStatus.isLookup(LkSNTaskStatus.Completed)) { %>
        <v:widget-block>
          <v:db-checkbox checked="<%=enabled%>" field="task.Enabled" caption="@Common.Enabled" value="true" enabled="<%=canEdit%>"/>
        </v:widget-block>
      <% } %>
    </v:widget>

    <v:widget caption="@Common.Notifications">
      <v:widget-block>
        <v:db-checkbox field="task.SendNotification" caption="@Task.SendNotification" value="true" enabled="<%=canEdit%>"/>
      </v:widget-block>
      <v:widget-block visibilityController="#task\.SendNotification">
        <v:filter-field caption="@DocTemplate.Email_Subject">
          <v:input-text field="task.NotificationSubject" enabled="<%=canEdit%>"/>
        </v:filter-field>

        <v:filter-field caption="@Common.EmailAddress">
          <v:input-text field="task.NotificationEmail" enabled="<%=canEdit%>"/>
        </v:filter-field>

        <v:filter-field caption="@Task.NotifyWhen">
          <div><v:db-checkbox field="task.NotifyOnJobFailure" caption="@Task.JobFails" value="true" enabled="<%=canEdit%>"/></div>
          <div><v:db-checkbox field="task.NotifyOnSuccessCount" caption="@Task.ProcessesWithSuccesses" value="true" enabled="<%=canEdit%>"/></div>
          <div><v:db-checkbox field="task.NotifyOnWarnCount" caption="@Task.ProcessesWithWarnings" value="true" enabled="<%=canEdit%>"/></div>
          <div><v:db-checkbox field="task.NotifyOnFailCount" caption="@Task.ProcessesWithFailures" value="true" enabled="<%=canEdit%>"/></div>
        </v:filter-field>
      </v:widget-block>
    </v:widget>
  </v:profile-recap>
  
  <v:profile-main>
    <v:widget caption="@Task.Scheduling">
      <v:widget-block id="freq-select">
        <v:form-field caption="@Task.Frequency">
          <v:lk-combobox field="task.TaskFrequency" lookup="<%=LkSN.TaskFrequency%>" allowNull="false" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
      <v:widget-block id="freq-not-scheduled" clazz="hidden">
        <v:form-field caption="Executed after" hint="Current task will be executed after the tasks listed">
          <% if (hasLinkedTasks) { %>
            <v:ds-loop dataset="<%=dsLinkedTasks%>">
              <% String linkedTaskId = dsLinkedTasks.getField("TaskId").getString();%>
              <snp:entity-link entityId="<%=linkedTaskId%>" entityType="<%=LkSNEntityType.Task%>">
                &nbsp;&nbsp;<v:itl key='<%=dsLinkedTasks.getField("TaskName").getString()%>'/>
              </snp:entity-link><br/>
            </v:ds-loop>
          <% } %>
        </v:form-field>
      </v:widget-block>
      <v:widget-block id="freq-monthly" clazz="hidden">
        <v:form-field caption="@Task.DayOfMonth">
          <v:input-text field="task.DayOfMonth" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.Time">
          <v:input-text type="timepicker" field="task.MonthlyTime" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.ToTime">
          <v:input-text type="timepicker" field="task.MonthlyTimeTo" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.TimeZone">
          <v:lk-combobox field="task.MonthlyTimeZone" lookup="<%=LkSN.TimeZone%>" allowNull="false" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
      <v:widget-block id="freq-daily" clazz="hidden">
        <v:form-field caption="@Common.Time">
          <v:input-text type="timepicker" field="task.DailyTime" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.ToTime">
          <v:input-text type="timepicker" field="task.DailyTimeTo" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.TimeZone">
          <v:lk-combobox field="task.DailyTimeZone" lookup="<%=LkSN.TimeZone%>" allowNull="false" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
      <v:widget-block id="freq-recurrent" clazz="hidden">
        <v:form-field caption="@Common.FromTime">
          <v:input-text type="timepicker" field="task.TimeFrom" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.ToTime">
          <v:input-text type="timepicker" field="task.TimeTo" enabled="<%=canEdit%>"/>
        </v:form-field>
        <% if (!isMaintenanceTask) { %>
          <v:form-field caption="@Task.IntervalMins">
            <v:input-text field="task.Interval" enabled="<%=canEdit%>"/>
          </v:form-field>
        <% } %>
        <v:form-field caption="@Common.TimeZone">
          <v:lk-combobox field="task.TimeZone" lookup="<%=LkSN.TimeZone%>" allowNull="false" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
      <v:widget-block id="schedule-dow" clazz="hidden">
        <v:form-field caption="@Task.DaysOfWeek">
          <% DateFormatSymbols symbols = new DateFormatSymbols(pageBase.getLocale()); %>
          <v:db-checkbox field="task.ActiveMon" caption="<%=JvString.getPascalCase(symbols.getShortWeekdays()[2])%>" value="true" enabled="<%=canEdit%>"/>&nbsp;&nbsp;
          <v:db-checkbox field="task.ActiveTue" caption="<%=JvString.getPascalCase(symbols.getShortWeekdays()[3])%>" value="true" enabled="<%=canEdit%>"/>&nbsp;&nbsp;
          <v:db-checkbox field="task.ActiveWed" caption="<%=JvString.getPascalCase(symbols.getShortWeekdays()[4])%>" value="true" enabled="<%=canEdit%>"/>&nbsp;&nbsp;
          <v:db-checkbox field="task.ActiveThu" caption="<%=JvString.getPascalCase(symbols.getShortWeekdays()[5])%>" value="true" enabled="<%=canEdit%>"/>&nbsp;&nbsp;
          <v:db-checkbox field="task.ActiveFri" caption="<%=JvString.getPascalCase(symbols.getShortWeekdays()[6])%>" value="true" enabled="<%=canEdit%>"/>&nbsp;&nbsp;
          <v:db-checkbox field="task.ActiveSat" caption="<%=JvString.getPascalCase(symbols.getShortWeekdays()[7])%>" value="true" enabled="<%=canEdit%>"/>&nbsp;&nbsp;
          <v:db-checkbox field="task.ActiveSun" caption="<%=JvString.getPascalCase(symbols.getShortWeekdays()[1])%>" value="true" enabled="<%=canEdit%>"/>&nbsp;&nbsp;
        </v:form-field>
      </v:widget-block>
      <v:widget-block id="freq-trigger" clazz="hidden">
        <table class="form-table">
          <tr>
            <th><v:itl key="@Common.Type"/></th>
            <td><v:lk-combobox lookup="<%=LkSN.TriggerType%>" field="trigger-combo" enabled="<%=canEdit%>"/></td>
          </tr>
        </table>
      </v:widget-block>
      <v:widget-block id="trigger-log-cfg">
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
      <v:widget-block id="next-task">
        <v:form-field caption="@Task.NextTask" hint="@Task.NextTaskHint">
          <v:combobox field="task.NextTaskId" lookupDataSet="<%=dsTask%>" idFieldName="TaskId" captionFieldName="TaskName" linkEntityType="<%=LkSNEntityType.Task%>" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
    </v:widget>
    
    <% if (!extPackageDisabled) { %>
      <% String configJSP = pageBase.getConfigPage(task.ClassAlias.getString()); %>
      <% if (configJSP != null) { %>
        <jsp:include page="<%=configJSP%>"/>
      <% } %>
    <% } else { %>
        <jsp:include page="../common/config_not_available.jsp"/>
    <% } %>
  </v:profile-main>
  
  
</v:tab-content>
</v:page-form>

<script>

var task = <%=task.getJSONString()%>;
var maintenanceTask = <%=isMaintenanceTask%>;
var taskFrequency_NotScheduled = <%=LkSNTaskFrequency.NotScheduled.getCode()%>;
var taskFrequency_Recurrent = <%=LkSNTaskFrequency.Recurrent.getCode()%>;
var taskFrequency_Daily = <%=LkSNTaskFrequency.Daily.getCode()%>;
var taskFrequency_Monthly = <%=LkSNTaskFrequency.Monthly.getCode()%>;
var taskFrequency_Trigger = <%=LkSNTaskFrequency.Trigger.getCode()%>;

function isFrequency(value) {
  return parseInt($("#task\\.TaskFrequency").val()) == parseInt(value);
}

function enableDisable() {
  $("#freq-select").setClass("hidden", maintenanceTask);
  $("#schedule-dow").setClass("hidden", !maintenanceTask && !isFrequency(taskFrequency_Daily) && !isFrequency(taskFrequency_Recurrent));
  $("#freq-not-scheduled").setClass("hidden", maintenanceTask || !isFrequency(taskFrequency_NotScheduled) || <%=!hasLinkedTasks%>);
  $("#freq-monthly").setClass("hidden", !isFrequency(taskFrequency_Monthly)); 
  $("#freq-daily").setClass("hidden", !isFrequency(taskFrequency_Daily)); 
  $("#freq-recurrent").setClass("hidden", !isFrequency(taskFrequency_Recurrent)); 
  $("#freq-trigger").setClass("hidden", !isFrequency(taskFrequency_Trigger)); 
  $("#next-task").setClass("hidden", maintenanceTask); 
  
  var trigger = isFrequency(<%=LkSNTaskFrequency.Trigger.getCode()%>) ? $("#trigger-combo").val() : "";
  $("#trigger-log-cfg").setClass("hidden", trigger != "<%=LkSNTriggerType.Log.getCode()%>");
}

$("#task\\.TaskFrequency").change(enableDisable);
$("#trigger-combo").change(enableDisable);

function getWksCombo(clazz, workstationId, opAreaId, locationId) {
  var cbWhere = $("<select class='combo-wks " + clazz + "'/>");
  cbWhere.html($("#combo-dummy .combo-wks").html());
  
  if (workstationId)
    cbWhere.val("W" + workstationId);
  else if (opAreaId)
    cbWhere.val("O" + opAreaId);
  else if (locationId)
    cbWhere.val("L" + locationId);
  
  return cbWhere;
}

function printLogItem(wItem) {
  var tr = $("<tr/>").appendTo("#tbody-log");
  
  var tdLogLevel = $("<td/>").appendTo(tr);
  var cbLogLevel = $("<select class='combo-LogLevel'/>").appendTo(tdLogLevel);
  cbLogLevel.html($("#combo-dummy .combo-LogLevel").html());
  cbLogLevel.val(wItem.LogLevel);
  
  var tdEntityType = $("<td/>").appendTo(tr);
  var cbEntityType = $("<select class='combo-EntityType'/>").appendTo(tdEntityType);
  cbEntityType.html($("#combo-dummy .combo-EntityType").html());
  cbEntityType.val(wItem.EntityType);
  
  $("<td/>").appendTo(tr).append(getWksCombo("source-wks", wItem.SourceWorkstationId, wItem.SourceOpAreaId, wItem.SourceLocationId));
}

$(document).ready(function() {
  $(document).trigger("task-load", task);

  var haslog = false;
  if ((task.TriggerList) && (task.TriggerList.length > 0)) {
    trigger = task.TriggerList[0];
    $("#trigger-combo").val(trigger.TriggerType);
    if ((trigger.TriggerConfigLog) && (trigger.TriggerConfigLog.EntryList) && (trigger.TriggerConfigLog.EntryList.length > 0)) {
      for (var i=0; i<trigger.TriggerConfigLog.EntryList.length; i++) {
        printLogItem(trigger.TriggerConfigLog.EntryList[i]);
        haslog = true;
      } 
    }
  }

  if (!haslog)
    printLogItem({});
  
  enableDisable();
});

function encodeTime(field, allowNull) {
  var hh = $(field + "-HH").val();
  var mm = $(field + "-MM").val();
  
  if ((allowNull === true) && (hh == "HH"))
    return null;
  else {
    hh = ((hh == "HH") ? "00" : hh);
    mm = ((mm == "MM") ? "00" : mm);
    return "1900-01-01T" + hh + ":" + mm + ":00.000";
  }
}

function saveTask() {
  checkRequired("#taskconfig-form", function() {
    doSave(); 
  });
}

function doSave() {
  var purgeDays = parseInt($("#task\\.PurgeDays").val());
  if ($("#task\\.NextTaskId").val() === <%=task.TaskId.getJsString()%>) {
    showIconMessage("error", <v:itl key="@Task.NextTaskError" encode="JS"/>);
  }
  else {   
    var reqDO = {
      TaskId: <%=task.TaskId.getJsString()%>,
      TaskType: <%=task.TaskType.getInt()%>,
      TaskName: $("#task\\.TaskName").val(),
      ServerProfileIDs: $("#task\\.ServerProfileIDs").val(),
      PurgeDays: isNaN(purgeDays) ? null : purgeDays,
      TaskStatus: $("#task\\.Enabled").isChecked()? <%=LkSNTaskStatus.Active.getCode()%> : <%=LkSNTaskStatus.Disabled.getCode()%>,  
      TaskFrequency: $("#task\\.TaskFrequency").val(),
      ActiveMon: $("#task\\.ActiveMon").isChecked(),
      ActiveTue: $("#task\\.ActiveTue").isChecked(),
      ActiveWed: $("#task\\.ActiveWed").isChecked(),
      ActiveThu: $("#task\\.ActiveThu").isChecked(),
      ActiveFri: $("#task\\.ActiveFri").isChecked(),
      ActiveSat: $("#task\\.ActiveSat").isChecked(),
      ActiveSun: $("#task\\.ActiveSun").isChecked(),
      NextTaskId: $("#task\\.NextTaskId").val(),
      SendNotification: $("#task\\.SendNotification").isChecked(),
      NotificationSubject: $("#task\\.SendNotification").isChecked() ? $("#task\\.NotificationSubject").val() : null,
      NotificationEmail: $("#task\\.SendNotification").isChecked() ? $("#task\\.NotificationEmail").val(): null,
      NotifyOnJobFailure: $("#task\\.SendNotification").isChecked() ? $("#task\\.NotifyOnJobFailure").isChecked() : false,
      NotifyOnSuccessCount: $("#task\\.SendNotification").isChecked() ? $("#task\\.NotifyOnSuccessCount").isChecked() : false,
      NotifyOnWarnCount: $("#task\\.SendNotification").isChecked() ? $("#task\\.NotifyOnWarnCount").isChecked() : false,
      NotifyOnFailCount: $("#task\\.SendNotification").isChecked() ? $("#task\\.NotifyOnFailCount").isChecked() : false,
      ExtensionPackageId: <%=task.ExtensionPackageId.getJsString()%>,
      ClassAlias: <%=task.ClassAlias.getJsString()%>,
      TriggerList: []
    };
    
    if (isFrequency(taskFrequency_Daily)) {
      reqDO.DailyTime = encodeTime("#task\\.DailyTime");
      reqDO.DailyTimeTo = encodeTime("#task\\.DailyTimeTo", true);
      reqDO.DailyTimeZone = $("#task\\.DailyTimeZone").val();
    }
    else if (isFrequency(taskFrequency_Monthly)) {
      reqDO.DayOfMonth = $("#task\\.DayOfMonth").val();
      reqDO.MonthlyTime = encodeTime("#task\\.MonthlyTime");
      reqDO.MonthlyTimeTo = encodeTime("#task\\.MonthlyTimeTo", true);
      reqDO.MonthlyTimeZone = $("#task\\.MonthlyTimeZone").val();
    }
    else if (isFrequency(taskFrequency_Recurrent)) {
      reqDO.TimeFrom = encodeTime("#task\\.TimeFrom");
      reqDO.TimeTo = encodeTime("#task\\.TimeTo");
      reqDO.TimeZone = $("#task\\.TimeZone").val();
      reqDO.Interval = $("#task\\.Interval").val();
    }
    
    if ($("#task\\.TaskFrequency").val() == "<%=LkSNTaskFrequency.Trigger.getCode()%>") {
      var trigger = {
        TriggerType: $("#trigger-combo").val() 
      };
      
      if (trigger.TriggerType == "<%=LkSNTriggerType.Log.getCode()%>") {
        trigger.TriggerConfigLog = {EntryList:[]};
        var trs = $("#tbody-log tr");
        for (var i=0; i<trs.length; i++) {
          var entry = {
            LogLevel: $(trs[i]).find(".combo-LogLevel").val(),
            EntityType: $(trs[i]).find(".combo-EntityType").val()
          };
  
          var rawsrc = $(trs[i]).find(".source-wks").val();
          if ((rawsrc) && (rawsrc.length > 0)) {
            var type = rawsrc.charAt(0);
            var id = rawsrc.substring(1);
            entry.SourceWorkstationId = (type == "W") ? id : null;
            entry.SourceOpAreaId = (type == "O") ? id : null;
            entry.SourceLocationId = (type == "L") ? id : null;
          }
          
          trigger.TriggerConfigLog.EntryList.push(entry);
        };
      }
      
      reqDO.TriggerList.push(trigger);
    }
    
    if (window.saveTaskConfig) {
      try {
        saveTaskConfig(reqDO);  
      }
      catch (error) {
        showMessage(error);
        return;
      }
    }
    
    $(document).trigger("task-save", reqDO);
    if (typeof reqDO.TaskConfig == "object")
      reqDO.TaskConfig = JSON.stringify(reqDO.TaskConfig);      
    
    snpAPI.cmd("Task", "Save", reqDO).then(ansDO => entitySaveNotification(<%=LkSNEntityType.Task.getCode()%>, ansDO.TaskId, "tab=main"));
  }
}

</script>
