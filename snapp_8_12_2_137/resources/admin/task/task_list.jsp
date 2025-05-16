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

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>
  
<v:tab-group name="tab" main="true">
  <v:tab-item tab="system"      caption="@Task.TasksSystem"      fa="cog"                jsp="task_list_system.jsp" default="true"/>
  <v:tab-item tab="user"        caption="@Task.TasksUser"        fa="user-helmet-safety" jsp="task_list_user.jsp"/>
  <v:tab-item tab="maintenance" caption="@Task.TasksMaintenance" fa="tools"              jsp="task_list_maintenance.jsp" />
  <v:tab-item tab="report"      caption="@Task.TasksReport"      fa="envelope"           jsp="task_list_report.jsp" />
  <v:tab-item tab="jobs"        caption="@Task.Jobs"             fa="bolt"               jsp="task_list_jobs.jsp" />
  <v:tab-item tab="asyncproc"   caption="@Common.AsyncProcesses" fa="sync"               jsp="task_list_asyncproc.jsp" />
</v:tab-group>
 
<jsp:include page="/resources/common/footer.jsp"/>
