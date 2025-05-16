<%@page import="com.vgs.snapp.dataobject.task.*"%>
<%@page import="com.vgs.web.service.*"%>
<%@page import="com.vgs.vcl.*"%>
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

<%
DOTask task;
String title;

if (pageBase.isNewItem()) {
  String docTemplateId = pageBase.getNullParameter("DocTemplateId");
  LookupItem dataExportOption = LkSN.DataExportOption.getItemByCode(pageBase.getParameter("DataExportOption"));
  task = pageBase.getBL(BLBO_Task.class).prepareNewTask_DataExport(docTemplateId, dataExportOption);
  title = pageBase.getLang().Common.New.getText();
}
else {
  task = pageBase.getBL(BLBO_Task.class).loadTask(pageBase.getId());
  title = task.TaskName.getString();
}

DOTask_DataExport cfg = new DOTask_DataExport();
cfg.setJSONString(task.TaskConfig.getString());
cfg.handleDeprecatedFields();

DODocTemplate docTemplate = SrvBO_OC.getDocTemplate(pageBase.getConnector(), cfg.DocTemplateId.getString(), true).DocTemplate;

request.setAttribute("task", task);
request.setAttribute("cfg", cfg);
request.setAttribute("cfgemail", pageBase.getBL(BLBO_DocTemplate.class).fillDocTemplateEmailDefaults(cfg.EmailConfig));
request.setAttribute("cfgftp", cfg.FtpConfig);
request.setAttribute("docTemplate", docTemplate);
%>

<v:dialog id="task_dataexport_dialog" tabsView="true" title="<%=title%>" width="950" height="700" autofocus="false">

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="task-tab-main" caption="@Common.Profile" fa="circle-info" default="true">
    <jsp:include page="task_dataexport_dialog_tab_main.jsp"/>
  </v:tab-item-embedded>

  <% if (cfg.DataExportOption.isLookup(LkSNDataExportOption.Email) && !docTemplate.DocTemplateType.isLookup(LkSNDocTemplateType.AdvancedNotification)) { %>
    <v:tab-item-embedded tab="task-tab-email" caption="@Common.Email" fa="envelope">
      <jsp:include page="task_dataexport_dialog_tab_email.jsp"/>
    </v:tab-item-embedded>

    <v:tab-item-embedded tab="task-tab-query" caption="@DocTemplate.DataSource" fa="database" visibilityController="#cbQuery">
      <jsp:include page="task_dataexport_dialog_tab_query.jsp"/>
    </v:tab-item-embedded>
  <% } %>

  <v:tab-item-embedded tab="task-tab-schedule" caption="@Common.Schedule" fa="clock">
    <jsp:include page="task_dataexport_dialog_tab_schedule.jsp"/>
  </v:tab-item-embedded>

  <v:tab-item-embedded tab="task-tab-option" caption="@Common.Options" fa="gear">
    <jsp:include page="task_dataexport_dialog_tab_options.jsp"/>
  </v:tab-item-embedded>

  <% if (!pageBase.isNewItem()) { %>
    <v:tab-item-embedded tab="task-tab-job" caption="@Task.Jobs" fa="bolt">
      <jsp:include page="task_dataexport_dialog_tab_jobs.jsp"/>
    </v:tab-item-embedded>
  
    <% if (rights.History.getBoolean()) { %>
      <v:tab-item-embedded tab="tabs-history" caption="@Common.History" fa="clock-rotate-left">
        <jsp:include page="../common/page_tab_historydetail.jsp"/>
      </v:tab-item-embedded>
    <% } %>
  <% } %>
  
  
</v:tab-group>


<script>
var dlg = $("#task_dataexport_dialog");
$(document).ready(function() {
  dlg.find(".tabs").tabs();
  
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      dialogButton("@Common.Save", doSaveTaskDataExport),
      dialogButton("@Common.Cancel", doCloseDialog)
    ];
  });
});

function encodeTime(field) {
  var hh = $(field + "-HH").val();
  var mm = $(field + "-MM").val();
  hh = ((hh == "HH") ? "00" : hh);
  mm = ((mm == "MM") ? "00" : mm);
  return "1900-01-01T" + hh + ":" + mm + ":00.000";
}

function doSaveTaskDataExport() {
  var purgeDays = parseInt(dlg.find("#task\\.PurgeDays").val());
  
  var config = {
 	  DocTemplateId: <%=cfg.DocTemplateId.getJsString()%>,
    DataSourceId: dlg.find("#cfg\\.DataSourceId").val(),
    LangISO: dlg.find("#cfg\\.LangISO").val(),
    DataExportOption: <%=cfg.DataExportOption.getInt()%>,
    OutputFormat: $("[name='OutputFormat']:checked").val(),
    FieldDelimiter: dlg.find("#cfg\\.FieldDelimiter").val(),
    QuoteCharacter: dlg.find("#cfg\\.QuoteCharacter").val(),
    IncludeHeaderLine: dlg.find("#cfg\\.IncludeHeaderLine").isChecked(),
    IncludeBOM: dlg.find("#cfg\\.IncludeBOM").isChecked(),
    UseFileNameFormula: dlg.find("[name='cfg\\.UseFileNameFormula']").isChecked(),
    FileNameFormula: dlg.find("#cfg\\.FileNameFormula").val(),
    FileName: dlg.find("#cfg\\.FileName").val(),
    FileNameOption: dlg.find("#cfg\\.FileNameOption").val(),
    FileNameParamId: dlg.find("#cfg\\.FileNameParamId").val(),
    FileNameDateFormat: dlg.find("#cfg\\.FileNameDateFormat").val(),
    SequenceDigits: dlg.find("#cfg\\.SequenceDigits").val(),
    GenerateMD5: dlg.find("#cfg\\.GenerateMD5").isChecked(),
    NotifyOnData: dlg.find("#cfg\\.NotifyOnData").isChecked(),
    ExportFolder: dlg.find("#cfg\\.ExportFolder").val(),
    Email_AddressFrom: dlg.find("#cfg\\.Email_AddressFrom").val(),
    Email_AddressTO: dlg.find("#cfg\\.Email_AddressTO").val(),
    Email_Subject: dlg.find("#cfg\\.Email_Subject").val(),
    FtpConfig: functionExists("getFtpConfig") ? getFtpConfig() : undefined,
    DifferentialExport: dlg.find("[name='cfg\\.DifferentialExport']").isChecked(),
    ParamList: []
  };
  
  dlg.find(".param-item").each(function(idx, param) {
    config.ParamList.push({
      ParamName: $(param).attr("name"),
      ParamValue: $(param).val()
    });
  });
  
  $(document).trigger("task-dataexport-save", {"config":config});
  
  if(config.EmailConfig)
    config.EmailConfig.PurgeDays = dlg.find("#cfgemail\\.PurgeDays").val();

    
  var reqDO = {
    TaskId: <%=task.TaskId.getJsString()%>,
    TaskType: <%=task.TaskType.getInt()%>,
    TaskName: dlg.find("#task\\.TaskName").val(),
    PurgeDays: isNaN(purgeDays) ? null : purgeDays,
    TaskStatus: dlg.find("#cbEnabled").isChecked()? <%=LkSNTaskStatus.Active.getCode()%> : <%=LkSNTaskStatus.Disabled.getCode()%>,
    TaskFrequency: dlg.find("#task\\.TaskFrequency").val(),
    TimeFrom: encodeTime("#task\\.TimeFrom"),
    TimeTo: encodeTime("#task\\.TimeTo"),
    TimeZone: dlg.find("#task\\.TimeZone").val(),
    Interval: dlg.find("#task\\.Interval").val(),
    DailyTime: encodeTime("#task\\.DailyTime"),
    DailyTimeZone: dlg.find("#task\\.DailyTimeZone").val(),
    DayOfMonth: dlg.find("#task\\.DayOfMonth").val(),
    MonthlyTime: encodeTime("#task\\.MonthlyTime"),
    MonthlyTimeZone: dlg.find("#task\\.MonthlyTimeZone").val(),
    ActiveMon: dlg.find("#task\\.ActiveMon").isChecked(),
    ActiveTue: dlg.find("#task\\.ActiveTue").isChecked(),
    ActiveWed: dlg.find("#task\\.ActiveWed").isChecked(),
    ActiveThu: dlg.find("#task\\.ActiveThu").isChecked(),
    ActiveFri: dlg.find("#task\\.ActiveFri").isChecked(),
    ActiveSat: dlg.find("#task\\.ActiveSat").isChecked(),
    ActiveSun: dlg.find("#task\\.ActiveSun").isChecked(),
    ClassAlias: <%=task.ClassAlias.getJsString()%>,
    TaskConfig: JSON.stringify(config),
    TriggerList: []
  };
  
  checkRequired("#task_dataexport_dialog", function() {
    snpAPI.cmd("Task", "Save", reqDO).then(() => {
      triggerEntityChange(<%=LkSNEntityType.Task.getCode()%>);
      dlg.dialog("close");
    });
  });
}


</script>

</v:dialog>