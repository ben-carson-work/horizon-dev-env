<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Task.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%

QueryDef qdef = new QueryDef(QryBO_Task.class);
// Select
qdef.addSelect(Sel.TaskId);
qdef.addSelect(Sel.CommonStatus);
qdef.addSelect(Sel.DataExport_IconAlias);
qdef.addSelect(Sel.DataExport_Option);
qdef.addSelect(Sel.DataExport_RecipientRecap);
qdef.addSelect(Sel.ScheduleDesc);
qdef.addSelect(Sel.DataExport_DocTemplateId);
qdef.addSelect(Sel.DataExport_DocTemplateName);
qdef.addSelect(Sel.LastFire);
qdef.addSelect(Sel.UncheckedCount);

qdef.addSelect(Sel.TaskName);
// Where
qdef.addFilter(Fil.TaskType, LkSNTaskType.GenericAutomatedTask.getCode());
// Sort
qdef.addSort(Sel.DataExport_DocTemplateName);
qdef.addSort(Sel.TaskName);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid id="task-report-grid-table" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Task%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true" multipage="true"/></td>
      <td>&nbsp;</td>
      <td width="20%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Recap"/>
      </td>
      <td width="20%">
        <v:itl key="@DocTemplate.DocTemplate"/>
      </td>
      <td width="60%">
        <v:itl key="@Task.Scheduling"/><br/>
        <v:itl key="@Task.NextFire"/>
      </td>
    </tr>
  </thead>
  <tbody>
  <v:grid-row dataset="ds">
    <% LookupItem dataExportOption = LkSN.DataExportOption.getItemByCode(ds.getField(Sel.DataExport_Option)); %>
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="TaskId" dataset="ds" fieldname="TaskId"/></td>
    <td><i class="fa fa-2x <%=ds.getField(Sel.DataExport_IconAlias).getHtmlString()%>"></i></td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.TaskId)%>" entityType="<%=LkSNEntityType.TaskDataExport%>" clazz="list-title">
        <%=ds.getField(Sel.TaskName).getHtmlString()%>
      </snp:entity-link>
      <br/>
      <span class="list-subtitle"><%=ds.getField(Sel.DataExport_RecipientRecap).getHtmlString()%></span>
    </td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.DataExport_DocTemplateId)%>" entityType="<%=LkSNEntityType.DocTemplate%>">
        <v:itl key="<%=ds.getField(Sel.DataExport_DocTemplateName).getString()%>"/>
      </snp:entity-link>
    </td>
    <td>
      <%=ds.getField(Sel.ScheduleDesc).getHtmlString()%><br/>
      <span class="list-subtitle">
        <% if (ds.getField(Sel.LastFire).isNull()) { %>
          <v:itl key="@Task.Frequency_NotScheduled"/>
        <% } else { %>
          <snp:datetime timestamp="<%=ds.getField(Sel.LastFire)%>" format="shortdatetime" timezone="local"/>
        <% } %>
      </span>
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