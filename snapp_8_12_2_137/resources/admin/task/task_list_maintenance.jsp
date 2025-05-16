<%@page import="com.vgs.snapp.task.*"%>
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


<div class="tab-toolbar">
  <div class="btn-group">
    <v:button id="new-btn" caption="@Common.New" fa="plus" dropdown="true" bindGrid="task-grid" bindGridEmpty="true"/>
		<v:popup-menu bootstrap="true">
		<% for (TaskBase<?> instance : BOTaskManager.getInstances(LkSNTaskType.GenericMaintenanceTask)) { %>
		  <% String href = pageBase.getContextURL() + "?page=task&id=new&ClassAlias=" + instance.getClassAlias(); %>
		  <v:popup-item caption="<%=instance.getTaskName()%>" href="<%=href%>" />
		<% } %>
		</v:popup-menu>
  </div>

  <v:button caption="@Common.Delete" fa="trash" onclick="deleteTasks()" bindGrid="task-grid"/>
    
  <v:pagebox gridId="task-grid"/>
</div>

<div class="tab-content">
  <% String params = "TaskType=" + LkSNTaskType.GenericMaintenanceTask.getCode(); %>
  <v:async-grid id="task-grid" jsp="task/task_grid.jsp" params="<%=params%>"/>
</div>

