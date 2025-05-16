<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTask" scope="request"/>
<jsp:useBean id="task" class="com.vgs.snapp.dataobject.DOTask" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
boolean showStats = !pageBase.isNewItem() && !task.TaskType.isLookup(LkSNTaskType.GenericMaintenanceTask);
%>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<style>
.task-config-section {
  font-weight: bold;
  text-decoration: underline;
}
</style>

<script>
function doManualFire() {
  confirmDialog(null, function() {
    snpAPI.cmd("Task", "ManualFire", {"TaskId":<%=task.TaskId.getSqlString()%>}).then(ansDO => {
      showMessage(itl("@Common.SaveSuccessMsg"), function() {
        <% if (pageBase.isParameter("tab", "job")) { %> 
          triggerEntityChange(<%=LkSNEntityType.Job.getCode()%>);
        <% } %>
      });
    });
  })
}
</script>

<div id="main-container">
  <v:tab-group name="tab" main="true">
    <v:tab-item tab="stats" caption="@Common.Statistics" fa="chart-line" jsp="task_tab_stats.jsp" default="<%=showStats%>" include="<%=showStats%>"/>
    <v:tab-item tab="main" caption="@Common.Settings" fa="gear" jsp="task_tab_main.jsp" default="<%=!showStats%>"/>
    <v:tab-item tab="job" caption="@Task.Jobs" fa="bolt" jsp="task_tab_job.jsp" include="<%=!pageBase.isNewItem()%>"/>
    
    <% if (!pageBase.isNewItem()) { %>
      <v:tab-plus>
			  <%-- NOTES --%>
			  <% String hrefNotes = "javascript:asyncDialogEasy('common/notes_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Task.getCode() + "');"; %>
			  <v:popup-item caption="@Common.Notes" fa="comments" href="<%=hrefNotes%>"/>
			
			  <%-- HISTORY --%>
        <% if (rights.History.getBoolean()) { %>
          <% String hrefHistory = "javascript:asyncDialogEasy('common/history_detail_dialog', 'id=" + pageBase.getId() + "');"; %>
          <v:popup-item caption="@Common.History" fa="history" href="<%=hrefHistory%>"/>
        <% } %>  
      </v:tab-plus>
    <% } %>
  </v:tab-group>
</div>

<jsp:include page="/resources/common/footer.jsp"/>
