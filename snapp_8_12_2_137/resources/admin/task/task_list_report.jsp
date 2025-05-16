<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTaskList" scope="request"/>

<%
String queryBase64 = pageBase.getNullParameter("QueryBase64");
%>

<script>
function doUpdateTaskStatus(reqDO) {
  snpAPI.cmd("Task", "SaveMultiEditTask", reqDO)
	  .then((ansDO) => {
		showAsyncProcessDialog(ansDO.AsyncProcessId, function() {
	    	triggerEntityChange(<%=LkSNEntityType.Task.getCode()%>);
	    });
	  });
}

function changeTaskStatus(status) {
  var taskIDs = $("[name='TaskId']").getCheckedValues();
  var queryBase64 = null;
  if ($("#task-report-grid-table").hasClass("multipage-selected")) {
	taskIDs = "";            
	queryBase64 = $("#task-report-grid-table").attr("data-QueryBase64");
  }
  var reqDO = {
      TaskIDs: taskIDs,
      QueryBase64: queryBase64,
      Task: {
   	    TaskStatus: status
	  }
	};
  doUpdateTaskStatus(reqDO);
}	
</script>

<div class="tab-toolbar">
  <div class="btn-group">
	<v:button id="status-btn" caption="@Common.Status" fa="flag" dropdown="true" bindGrid="task-grid"/>
 	<v:popup-menu bootstrap="true">
	  <% String hrefEnabled = "javascript:changeTaskStatus(" + LkSNTaskStatus.Active.getCode() + ")"; %>
	  <v:popup-item caption="@Common.Enable" href="<%=hrefEnabled%>"/>
	  <% String hrefDisabled = "javascript:changeTaskStatus(" + LkSNTaskStatus.Disabled.getCode() + ")"; %>
	  <v:popup-item caption="@Common.Disable" href="<%=hrefDisabled%>"/>
 	</v:popup-menu>
  </div>
  
  <div class="btn-group"> 
	<v:button caption="@Common.Delete" fa="trash" onclick="deleteTasks()" bindGrid="task-grid"/>
  </div>
  
  <v:pagebox gridId="task-grid"/>
</div>

<div class="tab-content">
  <v:async-grid id="task-grid" jsp="task/task_report_grid.jsp"/>
</div>
