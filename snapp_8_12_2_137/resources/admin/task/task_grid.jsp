<%@page import="com.vgs.snapp.dataobject.task.*"%>
<%@page import="com.vgs.snapp.api.task.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Task.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
LookupItem taskType = LkSN.TaskType.getItemByCode(pageBase.getParameter("TaskType"), LkSNTaskType.GenericSystemTask);
boolean catSystem = taskType.isLookup(LkSNTaskType.GenericSystemTask);

APIDef_Task_Search.DORequest reqDO = new APIDef_Task_Search.DORequest();
reqDO.SearchRecap.PagePos.setInt(pageBase.getQP());
reqDO.SearchRecap.RecordPerPage.setInt(QueryDef.recordPerPageDefault);
reqDO.Filters.FullText.setString(pageBase.getNullParameter("Fulltext"));
reqDO.Filters.TaskType.setArray(JvArray.stringToIntArray(pageBase.getNullParameter("TaskType"), ","));
reqDO.Filters.TaskStatus.setArray(JvArray.stringToIntArray(pageBase.getNullParameter("TaskStatus"), ","));
reqDO.Filters.ExtensionPackageId.setString(pageBase.getNullParameter("ExtensionPackageId"));

if (taskType.isLookup(LkSNTaskType.GenericMaintenanceTask))
  reqDO.SearchRecap.addSortField(Sel.CreateDateTime, true);

APIDef_Task_Search.DOResponse ansDO = pageBase.getBL(API_Task_Search.class).execute(reqDO); 
%>

<v:grid search="<%=ansDO%>">
  <thead>
    <tr>
      <td>
      <% if (!catSystem) { %>
        <v:grid-checkbox header="true"/>
      <% } %>
      </td>
      <td>&nbsp;</td>
      <td width="20%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Type"/>
      </td>
      <td width="20%">
        <v:itl key="@Task.Scheduling"/><br/>
        <v:itl key="@Task.NextFire"/>
      </td>
      <td width="40%">
        <% if (taskType.isLookup(LkSNTaskType.GenericMaintenanceTask)) { %>
          <v:itl key="@Common.Status"/>
        <% } else { %>
          <v:itl key="@Task.Triggers"/>
        <% } %>
      </td>
      <td width="20%">
        <v:itl key="@Plugin.ExtensionPackage"/>
      </td>
      <td></td>
    </tr>
  </thead>
  <tbody>
  <v:grid-row search="<%=ansDO%>">
    <% DOTaskRef task = ansDO.getRecord(); %>
    <td style="<v:common-status-style status="<%=task.CommonStatus%>"/>">
    <% if (!catSystem) { %>
      <v:grid-checkbox name="TaskId" value="<%=task.TaskId%>"/>
    <% } %>
    </td>
    <td><v:grid-icon name="<%=task.IconName%>"/></td>
    <td>
      <snp:entity-link entityId="<%=task.TaskId%>" entityType="<%=LkSNEntityType.Task%>" clazz="list-title">
        <v:label field="<%=task.TaskNameITL%>"/>
      </snp:entity-link>
      <div class="list-subtitle"><v:label field="<%=task.TaskType%>"/></div>
    </td>
    <td>
      <%=task.ScheduleDesc.getHtmlString()%>
      <div class="list-subtitle">
        <% if (task.LastFire.isNull()) { %>
          <v:itl key="@Task.Frequency_NotScheduled"/>
        <% } else { %>
          <snp:datetime timestamp="<%=task.LastFire%>" format="shortdatetime" timezone="local"/>
        <% } %>
      </div>
    </td>
    <td>
      <% if (task.TaskType.isLookup(LkSNTaskType.GenericMaintenanceTask)) { %>
        <snp:task-progress-bar taskId="<%=task.TaskId.getString()%>"/>
      <% } else { %>
        <v:label field="<%=task.TriggerTypes%>"/>
      <% } %>
    </td>
    <td>
      <% if (task.ExtensionPackageId.isNull()) { %>
        <div class="list-subtitle"><%=JvString.MDASH%></div>
      <% } else { %>
        <div><v:label field="<%=task.ExtensionPackageCode%>"/>&nbsp;<v:label field="<%=task.ExtensionPackageVersion%>"/></div>
        <div class="list-subtitle"><v:label field="<%=task.ExtensionPackageName%>"/></div>
      <% } %>
    </td>
    <td>
      <% if (task.UncheckedCount.getInt() > 0) { %>
        <% String title = JvMultiLang.translate(pageBase.getLang(), "@Task.UncheckedErrors", task.UncheckedCount.getString()); %>
        <a href="admin?page=task&tab=job&id=<%=task.TaskId.getHtmlString()%>" title="<%=JvString.escapeHtml(title)%>"><v:grid-icon name="[font-awesome]exclamation-triangle|ColorizeOrange"/></a>
      <% } %>
    </td>
  </v:grid-row>
  </tbody>
</v:grid>


<script>
function deleteTasks() {
  var ids = $("[name='TaskId'].cblist").getCheckedValues();
  if (ids == "")
    showMessage(itl("@Common.NoElementWasSelected"));
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeleteTask",
        DeleteTask: {
          TaskIDs: ids
        }
      };
      
      showWaitGlass();
      vgsService("Task", reqDO, false, function() {
        hideWaitGlass();
        triggerEntityChange(<%=LkSNEntityType.Task.getCode()%>);
      });
    });
  }
}
</script>