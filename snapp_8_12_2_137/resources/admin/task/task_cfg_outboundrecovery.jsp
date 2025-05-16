<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.web.queue.outbound.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTask" scope="request"/>

<v:widget caption="@Common.Configuration">
  <v:widget-block>
    <v:alert-box type="info" title="@Common.Info">
      <p>The purpose of this task is to cross-check if an outbound event, which was supposed to be sent, was actually sent by the system.</p>
      <p>For each one of the specified <b>outbound message</b>, the task will run a query (*) to retrieve the data which was supposed to be sent, then it will check on the "queue database" (**) if the event was sent.</p> 
      <p><i>(*) The query is run against the outbound message's configured datasource</i></p> 
      <p><i>(**) The "queue database" could match the "production/main" database, or could be a dedicated database depending on the <a href="admin?page=outboundcfg&tab=config" target="_new">configuration</a></i>. The task is supposed to be configured/ran on the "queue" instance.</p> 
    </v:alert-box>
  </v:widget-block>
	<v:widget-block>
    <v:form-field caption="@Outbound.OutboundMessages">
      <v:multibox field="cfg.OutboundMessageIDs" lookupDataSet="<%=pageBase.getBL(BLBO_Outbound.class).getOutboundMessagesDS()%>" idFieldName="OutboundMessageId" captionFieldName="OutboundMessageName"/>
    </v:form-field>
    <v:form-field>
      <v:db-checkbox field="cfg.RetryFailed" value="true" caption="@Outbound.TaskRecovery_RetryFailed" hint="@Outbound.TaskRecovery_RetryFailedHint"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="@Outbound.TaskRecovery_TimeoutMins" hint="@Outbound.TaskRecovery_TimeoutMinsHint">
      <v:input-text field="cfg.TimeoutMins" placeholder="@Common.None"/>
    </v:form-field>
    <v:form-field caption="@Common.FromDate" mandatory="true" hint="<%=pageBase.getBL(BLBO_Task.class).getDateParamHint()%>">
      <v:input-text field="cfg.DateFrom" placeholder="@Task.DateParamPlaceholder" list="DocDateEncode"/>
    </v:form-field>
    <v:form-field caption="@Common.ToDate" mandatory="true" hint="<%=pageBase.getBL(BLBO_Task.class).getDateParamHint()%>">
      <v:input-text field="cfg.DateTo" placeholder="@Task.DateParamPlaceholder" list="DocDateEncode"/>
    </v:form-field>
	</v:widget-block>
</v:widget>

<script>
function saveTaskConfig(reqDO) {
  var config ={
    OutboundMessageIDs: $("#cfg\\.OutboundMessageIDs").val(),
    RetryFailed: $("#cfg\\.RetryFailed").isChecked(),
    TimeoutMins: $("#cfg\\.TimeoutMins").val(),
    DateFrom: $("#cfg\\.DateFrom").val(),
    DateTo: $("#cfg\\.DateTo").val()
  };
  reqDO.TaskConfig = JSON.stringify(config); 
}
</script>

