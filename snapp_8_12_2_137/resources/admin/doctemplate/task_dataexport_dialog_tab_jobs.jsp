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


<script>
function doRefresh() {
  var status = $("input[name='Status']:checked").map(function () {return this.value;}).get().join(",");
  setGridUrlParam("#job-grid", "JobStatus", status, false);

  var checked = $("input[name='Checked']:checked");
  setGridUrlParam("#job-grid", "Checked", (checked.length == 1) ? checked.val() : "", true);
}

function doJobsAsChecked() {
  
}

function doManualFire() {
  var reqDO = {
    Command: "ManualFire",
    ManualFire: {
      TaskId: <%=task.TaskId.getJsString()%>
    }
  };

  vgsService("Task", reqDO, false, function(ansDO) {
    showMessage(<v:itl key="@Common.SaveSuccessMsg" encode="JS"/>);
  });
}

function doMarkJobChecked() {
  var ids = $("[name='JobId']").getCheckedValues();
  if (ids == "")
    showIconMessage("warning", <v:itl key="@Common.NoElementWasSelected" encode="JS"/>);
  else {
    var reqDO = {
      Command: "MarkJobChecked",
      MarkJobChecked: {
        JobIDs: ids
      }
    };
    
    vgsService("Task", reqDO, false, doRefresh);
  }
}

</script>

<div class="tab-toolbar">
  <v:button fa="sync-alt" caption="@Common.Refresh" href="javascript:doRefresh()"/>
  <v:button caption="@Task.MarkAsChecked" fa="check" href="javascript:doMarkJobChecked()"/>
  <v:button caption="@Task.ManualFire" fa="bolt" href="javascript:doManualFire()"/>
  <v:pagebox gridId="job-grid"/>
</div>

<div id="data-export-jobs-tab" class="tab-content">
  <div class="profile-pic-div">
    <v:widget caption="@Common.Status">
      <v:widget-block>
      <% for (LookupItem status : LkSN.JobStatus.getItems()) { %>
        <v:db-checkbox field="Status" caption="<%=status.getDescription(pageBase.getLang())%>" value="<%=String.valueOf(status.getCode())%>" /><br/>
      <% } %>
      </v:widget-block>
      <v:widget-block>
        <v:db-checkbox field="Checked" caption="@Task.Checked_True" value="true" /><br/>
        <v:db-checkbox field="Checked" caption="@Task.Checked_False" value="false" /><br/>
      </v:widget-block>
    </v:widget>
  </div>


  <div class="profile-cont-div">
    <% String params = "TaskId=" + task.TaskId.getEmptyString(); %>
    <v:async-grid id="job-grid" jsp="task/job_grid.jsp" params="<%=params%>"/>
  </div>
</div>