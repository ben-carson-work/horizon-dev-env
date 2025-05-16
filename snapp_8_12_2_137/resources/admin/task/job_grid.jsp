<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Job.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_Job.class)
    .addSort(Sel.StartDateTime, false)
    .setPaging(pageBase.getQP(), QueryDef.recordPerPageDefault)
    .addSelect(
        Sel.CommonStatus,
        Sel.JobId,
        Sel.JobStatus,
        Sel.StartDateTime,
        Sel.SmoothDuration,
        Sel.JobLogRecap,
        Sel.TaskId,
        Sel.TaskType,
        Sel.TaskName,
        Sel.StartEntityType,
        Sel.StartEntityId,
        Sel.SucceededCount,
        Sel.WarningCount,
        Sel.FailedCount,
        Sel.Checked,
        Sel.ServerId,
        Sel.ServerName,
        Sel.DatabaseProcess);

// Where
String taskId = pageBase.getNullParameter("TaskId"); 
if (taskId != null)
  qdef.addFilter(Fil.TaskId, taskId);
if ((pageBase.getNullParameter("JobId") != null))
  qdef.addFilter(Fil.JobId, JvArray.stringToArray(pageBase.getNullParameter("JobId"), ","));
if ((pageBase.getNullParameter("JobStatus") != null))
  qdef.addFilter(Fil.JobStatus, JvArray.stringToArray(pageBase.getNullParameter("JobStatus"), ",")); 
if ((pageBase.getNullParameter("Checked") != null))
  qdef.addFilter(Fil.Checked, pageBase.getParameter("Checked"));
if (pageBase.getNullParameter("TransactionId") != null)
  qdef.addFilter(Fil.TransactionId, pageBase.getParameter("TransactionId"));
if (pageBase.getNullParameter("FromDateTime") != null)
  qdef.addFilter(Fil.DateTimeFrom, pageBase.convertFromBrowserToServerTimeZone(pageBase.getNullParameter("FromDateTime")));
if (pageBase.getNullParameter("ToDateTime") != null)
  qdef.addFilter(Fil.DateTimeTo, pageBase.convertFromBrowserToServerTimeZone(pageBase.getNullParameter("ToDateTime")));

// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<%!String htmlCounter(JvFieldNode value) {
  String sValue = JvString.htmlEncode(JvString.getSmoothQuantity(value.getInt()));
  if (value.getInt() >= 1000) {
    sValue = "<span title=\"" + JvString.htmlEncode(JvString.formatCurr(value.getFloat(), "#,##0")) + "\">" + sValue + "</span>";
  }
  return sValue;
}%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Job%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td width="120px" nowrap>
        <v:itl key="@Common.DateTime"/><br/>
        <v:itl key="@Common.Duration"/> <span style="float:right" title="<v:itl key="@Task.JobSuccedeed"/> / <v:itl key="@Task.JobWarning"/> / <v:itl key="@Task.JobFailed"/>">(<v:itl key="@Task.JobSuccedeedInitial"/>/<v:itl key="@Task.JobWarningInitial"/>/<v:itl key="@Task.JobFailedInitial"/>)</span> 
      </td>
      <td width="25%" nowrap>
        <v:itl key="@Task.StartType"/><br/>
        <v:itl key="@Common.Server"/>
      </td>
      <% if (taskId == null) { %>
        <td width="25%">
          <v:itl key="@Task.Task"/>
        </td>
      <% } %> 
      <td width="<%=(taskId==null)?"40%":"65%"%>"/>
      <td width="10%" align="right">
      	<v:itl key="@Task.DatabaseProcess"/>
      </td> 
    </tr>
  </thead>
  <tbody>
  <v:grid-row dataset="ds">
    <% LookupItem jobStatus = LkSN.JobStatus.getItemByCode(ds.getField(Sel.JobStatus)); %>
    <% LookupItem taskType = LkSN.TaskType.getItemByCode(ds.getField(Sel.TaskType)); %>
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>" data-jobid="<%=ds.getField(Sel.JobId).getHtmlString()%>" data-jobstatus="<%=ds.getInt(Sel.JobStatus)%>">
      <v:grid-checkbox name="JobId" dataset="ds" fieldname="JobId"/>
      <% if (!ds.getField(Sel.Checked).getBoolean()) { %>
        <div style="text-align:center; color:var(--base-orange-color)"><i class="fa fa-exclamation-triangle"></i></div>
      <% } %>
    </td>
    <td nowrap>
      <div>
        <snp:entity-link entityType="<%=LkSNEntityType.Job%>" entityId="<%=ds.getField(Sel.JobId)%>" clazz="list-title">
          <snp:datetime timestamp="<%=ds.getField(Sel.StartDateTime)%>" format="shortdatetime" timezone="local"/>
        </snp:entity-link>
      </div>
      <span class="list-subtitle">
        <%=ds.getField(Sel.SmoothDuration).getHtmlString()%> 
      </span>     
      <span class="list-subtitle" style="float:right">
        (<%=htmlCounter(ds.getField(Sel.SucceededCount))%>/<%=htmlCounter(ds.getField(Sel.WarningCount))%>/<%=htmlCounter(ds.getField(Sel.FailedCount))%>)
      </span>     
    </td>
    <td nowrap>
      <% LookupItem startEntityType = LkSN.EntityType.getItemByCode(ds.getField(Sel.StartEntityType)); %>
      <% if (startEntityType.isLookup(LkSNEntityType.Person)) { %>
        <v:itl key="@Task.StartType_Manual"/> &mdash;
        <% String accountName = pageBase.getDB().getString("select DisplayName from tbAccount where AccountId=" + ds.getField(Sel.StartEntityId).getSqlString()); %>
        <snp:entity-link entityId="<%=ds.getField(Sel.StartEntityId)%>" entityType="<%=LkSNEntityType.Person%>"><%=JvString.escapeHtml(accountName)%></snp:entity-link>
      <% } else if (startEntityType.isLookup(LkSNEntityType.Task)) { %>
        <% if (!JvString.isSameString(ds.getString(Sel.StartEntityId), ds.getString(Sel.TaskId))) { %>
          <v:itl key="@Task.Task"/>&nbsp;&mdash; 
          <% String taskName = pageBase.getDB().getString("select TaskName from tbTask where TaskId=" + ds.getField(Sel.StartEntityId).getSqlString()); %>
          <snp:entity-link entityId="<%=ds.getField(Sel.StartEntityId)%>" entityType="<%=LkSNEntityType.Task%>"><v:itl key="<%=taskName%>"/></snp:entity-link>
        <% } else { %>
          <v:itl key="@Task.StartType_Scheduled"/>
        <% } %>
      <% } else if (startEntityType.isLookup(LkSNEntityType.TaskTrigger)) { %>
        <% LookupItem triggerType = LookupManager.decodePseudoId(LkSN.class, ds.getField(Sel.StartEntityId).getString()); %>
        <%=triggerType.getDescription(pageBase.getLang())%><br/>
        <v:itl key="@Task.Trigger"/>
      <% } %>
      <br/>
      <span class="list-subtitle"><%=ds.getField(Sel.ServerName).getHtmlString()%></span>&nbsp;
    </td>
    <% if (taskId == null) { %>
      <td>
        <% LookupItem taskEntityType = taskType.isLookup(LkSNTaskType.GenericAutomatedTask) ? LkSNEntityType.TaskDataExport : LkSNEntityType.Task; %>
        <snp:entity-link entityId="<%=ds.getField(Sel.TaskId)%>" entityType="<%=taskEntityType%>">
          <%=JvString.escapeHtml(JvMultiLang.translate(request, ds.getField(Sel.TaskName).getString()))%>
        </snp:entity-link>
        <br/>
        <span class="list-subtitle"><%=taskType.getHtmlDescription(pageBase.getLang())%></span>
      </td>
    <% } %>
    <td><span class="list-subtitle"><%=ds.getField(Sel.JobLogRecap).getHtmlString()%></span></td>
    <td align="right">
      <%=ds.getField(Sel.DatabaseProcess).getHtmlString()%>
    </td>
  </v:grid-row>
  </tbody>
</v:grid>

<script>
$(document).ready(function() {
  var inProgressSelector = "td[data-jobstatus='<%=LkSNJobStatus.InProgress.getCode()%>']";
  var $td = $("#job-grid " + inProgressSelector);
  var $tr = $td.closest("tr");
  var jobId = $td.attr("data-jobid");
  
  if ($td.length > 0) 
    setTimeout(_updateJobs, 5000); 
  
  function _updateJobs() {
    var $selector = $("<div/>");
    var urlo = "admin?page=grid_widget&jsp=task/job_grid.jsp&JobId=" + jobId + "&TaskId=<%=taskId%>";
    asyncLoad($selector, urlo, function() {
      $tr.html($selector.find("td[data-jobid='" + jobId + "']").closest("tr").html());
      if ($tr.find(inProgressSelector).length > 0)
        setTimeout(_updateJobs, 5000);
    });
  }
});
</script>
