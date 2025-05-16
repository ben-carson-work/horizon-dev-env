<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTask" scope="request"/>
<%
  String startDateTimeHint = 
      "Indicate the start date time to be used to collect statistics." + JvString.CRLF +
      "If left empty the default value will be the previous fiscal day.";
  
  String endDateTimeHint = 
      "Indicate the end date time to be used to collect statistics." + JvString.CRLF +
      "If left empty the default value will be the previous fiscal day.";
  
  JvDocument cfg = (JvDocument)request.getAttribute("cfg");
%>

<v:widget caption="Service endpoint config">
  <v:widget-block>
    <v:form-field caption="Process contract service URL" >
      <v:input-text field="cfg.ProcessContract_URL"/>
    </v:form-field>
    <v:form-field caption="Upgrade passholder service URL" >
      <v:input-text field="cfg.UpgradePassholder_URL"/>
    </v:form-field>
    <v:form-field caption="Connection timeout (msecs)" >
      <v:input-text field="cfg.ConnectionTimeout" placeholder="5"/>
    </v:form-field>
    <v:form-field caption="Read timeout (msecs)" >
      <v:input-text field="cfg.ReadTimeout" placeholder="5"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="Options">
  <v:widget-block>
    <v:form-field caption="Max days" hint="Number of days to look back. 1 will export yesterdays only; 2 will export yesterday plus the day before; etc...">
      <v:input-text field="cfg.MaxDays" placeholder="1"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="Collect statistics">
  <v:widget-block>
    <v:db-checkbox field="cfg.CollectStatistics" value="true" caption="Collect statistics and send notification"/>
  </v:widget-block>
  <v:widget-block id="collect-stats-widget">
    <v:form-field caption="Collect statistics service URL" >
      <v:input-text field="cfg.CollectStatistics_URL"/>
    </v:form-field>
    <v:form-field caption="Email addresses" hint="Comma separated list of e-mails that Alta will use to send notifications">
      <v:input-text field="cfg.CollectStatsEmailAddresses"/>
    </v:form-field>
    <v:form-field caption="Start date time" hint="<%=startDateTimeHint%>">
      <v:input-text type="datetimepicker" field="cfg.CollectStatsStartDateTime"/>
    </v:form-field>
    <v:form-field caption="End date time" hint="<%=endDateTimeHint%>">
      <v:input-text type="datetimepicker" field="cfg.CollectStatsEndDateTime"/>
    </v:form-field>
    <v:form-field caption="Return contract IDs" >
      <v:db-checkbox field="cfg.ReturnContractIDs" value="true" caption=""/>
    </v:form-field>
    <v:form-field caption="Return audit notes" >
      <v:db-checkbox field="cfg.ReturnAuditNotes" value="true" caption=""/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="AuthZ settings">
  <v:widget-block>
    <v:form-field caption="AuthZ service URL" >
      <v:input-text field="cfg.AuthZ_URL"/>
    </v:form-field>
    <v:form-field caption="Client Id">
      <v:input-text field="cfg.AuthZ_ClientId"/>
    </v:form-field>
    <v:form-field caption="Client secret">
      <v:input-text type="password" field="cfg.AuthZ_ClientSecret"/>
    </v:form-field>
    <v:form-field caption="AuthZ scope">
      <v:input-text field="cfg.AuthZ_Scope"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="APMP Keys">
  <v:widget-block>
    <v:form-field caption="Private key" hint="APMP Private key. Used to generate message signature of the full payload">
      <v:input-txtarea field="cfg.APMPPrivateKey" rows="10"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>

$(document).ready(function() {
  $("#cfg\\.CollectStatistics").click(refreshVisibility);
  refreshVisibility();
});

function refreshVisibility() {
  $("#collect-stats-widget").setClass("v-hidden", !$("#cfg\\.CollectStatistics").isChecked());
}

function saveTaskConfig(reqDO) {
  var collectStatsStartDateTime = $("#cfg\\.CollectStatsStartDateTime-picker").getXMLDateTime();
  var collectStatsEndDateTime = $("#cfg\\.CollectStatsEndDateTime-picker").getXMLDateTime();
  var config = {
    ProcessContract_URL: $("#cfg\\.ProcessContract_URL").val(),
    UpgradePassholder_URL: $("#cfg\\.UpgradePassholder_URL").val(),
    CollectStatistics: $("#cfg\\.CollectStatistics").isChecked(),
    CollectStatistics_URL: $("#cfg\\.CollectStatistics_URL").val(),
    CollectStatsEmailAddresses: $("#cfg\\.CollectStatsEmailAddresses").val(),
    CollectStatsStartDateTime: collectStatsStartDateTime!="" ? collectStatsStartDateTime : null,
    CollectStatsEndDateTime: collectStatsEndDateTime!="" ? collectStatsEndDateTime : null,
    ReturnContractIDs: $("#cfg\\.ReturnContractIDs").isChecked(),
    ReturnAuditNotes: $("#cfg\\.ReturnAuditNotes").isChecked(),
    ConnectionTimeout: $("#cfg\\.ConnectionTimeout").val(),
    ReadTimeout: $("#cfg\\.ReadTimeout").val(),
    APMPPrivateKey: $("#cfg\\.APMPPrivateKey").val(),
    AuthZ_URL: $("#cfg\\.AuthZ_URL").val(),
    AuthZ_ClientId: $("#cfg\\.AuthZ_ClientId").val(),
    AuthZ_ClientSecret: $("#cfg\\.AuthZ_ClientSecret").val(),
    AuthZ_Scope: $("#cfg\\.AuthZ_Scope").val(),
    MaxDays: $("#cfg\\.MaxDays").val()
  };
  
  reqDO.TaskConfig = JSON.stringify(config);	
}
</script>