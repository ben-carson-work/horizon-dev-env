<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="java.text.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTask" scope="request"/>
<jsp:useBean id="task" class="com.vgs.snapp.dataobject.DOTask" scope="request"/>

<v:widget caption="Configuration">
  <v:widget-block>
    <v:form-field caption="@Task.ProcessRecover_BaseDate" hint="@Task.ProcessRecover_BaseDate_Hint">
      <v:input-text type="datepicker" field="cfg.BaseDate"/>
    </v:form-field>
    <v:form-field caption="@Task.ProcessRecover_BaseTimeFrom" hint="@Task.ProcessRecover_BaseTimeFrom_Hint">
      <v:input-text type="datetimepicker" field="cfg.BaseTimeFrom"/> 
    </v:form-field>
    <v:form-field caption="@Task.ProcessRecover_BaseTimeTo" hint="@Task.ProcessRecover_BaseTimeTo_Hint">
    <v:input-text type="datetimepicker" field="cfg.BaseTimeTo"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <div>
      <v:db-checkbox field="cfg.HandleMissingProcesses" value="true" caption="@Task.ProcessRecover_HandleMissingProcesses" hint="@Task.ProcessRecover_HandleMissingProcesses_Hint"/>
    </div>
    <v:form-field caption="@Task.ProcessRecover_MissingTimeoutMins" hint="@Task.ProcessRecover_MissingTimeoutMins_Hint">
      <v:input-text field="cfg.MissingTimeoutMins" placeholder="5"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <div>
      <v:db-checkbox field="cfg.HandleFailedProcesses" value="true" caption="@Task.ProcessRecover_HandleFailedProcesses" hint="@Task.ProcessRecover_HandleFailedProcesses_Hint"/>
    </div>
  </v:widget-block>
  <v:widget-block>
    <div>
      <v:db-checkbox field="cfg.HandleWorkingProcesses" value="true" caption="@Task.ProcessRecover_HandleWorkingProcesses" hint="@Task.ProcessRecover_HandleWorkingProcesses_Hint"/>
    </div>
    <v:form-field caption="@Task.ProcessRecover_WorkingTimeoutHours" hint="@Task.ProcessRecover_WorkingTimeoutHours_Hint">
      <v:input-text field="cfg.WorkingTimeoutHours" placeholder="1"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
function saveTaskConfig(reqDO) {
  var config = {
    BaseDate: getNull($("#cfg\\.BaseDate-picker").getXMLDate()),
    BaseTimeFrom: getNull($("#cfg\\.BaseTimeFrom-picker").getXMLDateTime()),
    BaseTimeTo: getNull($("#cfg\\.BaseTimeTo-picker").getXMLDateTime()),
    HandleMissingProcesses: $("#cfg\\.HandleMissingProcesses").isChecked(), 
    MissingTimeoutMins: $("#cfg\\.MissingTimeoutMins").val(),
    HandleFailedProcesses: $("#cfg\\.HandleFailedProcesses").isChecked(),
    HandleWorkingProcesses: $("#cfg\\.HandleWorkingProcesses").isChecked(), 
    WorkingTimeoutHours: $("#cfg\\.WorkingTimeoutHours").val()
  }
  
  reqDO.TaskConfig = JSON.stringify(config); 
}
</script>

