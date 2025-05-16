<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="java.text.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTask" scope="request"/>
<jsp:useBean id="task" class="com.vgs.snapp.dataobject.DOTask" scope="request"/>

<v:page-form>

<v:tab-toolbar>
  <v:button id="btn-refresh" caption="@Common.Refresh" fa="sync-alt"/>
  <v:button id="btn-markchecked" caption="@Task.MarkAsChecked" fa="check" bindGrid="job-grid"/>
  <v:button id="btn-manualfire" caption="@Task.ManualFire" fa="bolt" onclick="doManualFire()" include="<%=!task.TaskType.isLookup(LkSNTaskType.GenericMaintenanceTask)%>"/>
  
  <v:pagebox gridId="job-grid"/>
</v:tab-toolbar>

<v:tab-content>
  <v:profile-recap>
    <v:widget caption="@Common.DateRange">
      <v:widget-block>
        <label for="FromDateTime"><v:itl key="@Common.From"/></label><br/>
        <v:input-text type="datetimepicker" field="FromDateTime" style="width:120px"/>
          
        <div class="filter-divider"></div>
          
        <label for="ToDateTime"><v:itl key="@Common.To"/></label><br/>
        <v:input-text type="datetimepicker" field="ToDateTime" style="width:120px"/>
      </v:widget-block>
    </v:widget>
    
    <v:widget caption="@Common.Status">
      <v:widget-block>
        <v:lk-checkbox field="Status" lookup="<%=LkSN.JobStatus%>"/>
      </v:widget-block>
      
      <v:widget-block>
        <v:db-checkbox field="Checked" caption="@Task.Checked_True" value="true" /><br/>
        <v:db-checkbox field="Checked" caption="@Task.Checked_False" value="false" /><br/>
      </v:widget-block>
    </v:widget>
  </v:profile-recap>

  <v:profile-main>
    <% String params = "TaskId=" + pageBase.getId(); %>
    <v:async-grid id="job-grid" jsp="task/job_grid.jsp" params="<%=params%>"/>
  </v:profile-main>
</v:tab-content>

<script>
$(document).ready(function() {
  $("#btn-refresh").click(_refresh);
  $("#btn-markchecked").click(_markJobChecked);
  
  function _refresh() {
    setGridUrlParam("#job-grid", "FromDateTime", $("#FromDateTime-picker").getXMLDateTime());
    setGridUrlParam("#job-grid", "ToDateTime", $("#ToDateTime-picker").getXMLDateTime(true));

    var status = $("input[name='Status']:checked").map(function () {return this.value;}).get().join(",");
    setGridUrlParam("#job-grid", "JobStatus", status, false);

    var checked = $("input[name='Checked']:checked");
    setGridUrlParam("#job-grid", "Checked", (checked.length == 1) ? checked.val() : "", true);
  }

  function _markJobChecked() {
    snpAPI.cmd("Task", "MarkJobChecked", {
      JobIDs: $("[name='JobId']").getCheckedValues()
    })
    .then(_refresh);
  }
});

</script>


</v:page-form>