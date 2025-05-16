<%@page import="com.vgs.snapp.dataobject.task.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.servlet.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% 
DOJob job = pageBase.getBL(BLBO_Task.class).loadJob(pageBase.getId());
request.setAttribute("job", job);
String title = pageBase.getLang().Task.Job.getText() + " - " + pageBase.convertFromServerToBrowserTimeZone(job.StartDateTime.getDateTime()).format(pageBase.getShortDateTimeFormat());
%> 

<v:dialog id="job_dialog" tabsView="true" title="<%=title%>" width="900" height="700">
 
<v:tab-group name="tabs" main="true">
  <v:tab-item-embedded tab="tabs-profile" fa="circle-info" caption="@Common.Profile" default="true">
    <jsp:include page="job_dialog_tab_profile.jsp"></jsp:include>
  </v:tab-item-embedded>
   
  <v:tab-item-embedded tab="tabs-config" fa="gear" caption="@Common.Settings" include="<%=!job.TaskConfig.isNull()%>">
    <jsp:include page="job_dialog_tab_config.jsp"></jsp:include>
  </v:tab-item-embedded>
   
  <v:tab-item-embedded tab="tabs-repository" fa="paperclip-vertical" caption="@Common.Attachments" include="<%=!job.RepositoryRecapList.isEmpty()%>">
    <jsp:include page="job_dialog_tab_repository.jsp"></jsp:include>
  </v:tab-item-embedded>
   
  <v:tab-item-embedded tab="tabs-action" fa="envelope" caption="@Common.Notifications" include="<%=job.ActionCount.getInt() > 0%>">
    <jsp:include page="job_dialog_tab_action.jsp"></jsp:include>
  </v:tab-item-embedded>
   
  <v:tab-item-embedded tab="tabs-log" icon="<%=LkSNEntityType.Log.getIconName()%>" caption="@Common.Logs" include="<%=job.LogCount.getInt() > 0%>">
    <jsp:include page="../common/page_tab_logs.jsp"/>
  </v:tab-item-embedded>
</v:tab-group>
  
  
<script>

$(document).ready(function() {
  var $dlg = $("#job_dialog");

  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      dialogButton("@Common.Close", doCloseDialog)
    ];
  });
});

</script>

</v:dialog>
