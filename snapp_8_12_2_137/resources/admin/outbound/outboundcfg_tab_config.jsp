<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.web.queue.outbound.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageOutboundCfg" scope="request"/>

<%
DOOutboundConfig outboundcfg = pageBase.getBL(BLBO_Outbound.class).loadOutboundConfig();
request.setAttribute("outboundcfg", outboundcfg);

JvDataSet dsDataSource = pageBase.getBL(BLBO_DataSource.class).getDataSourceDS(LkSNDataSourceType.Outbound);
%>

<style>
.radio-inline-label {
  margin-left: 15px;
}
</style>

<div class="tab-toolbar">
  <v:button id="btn-save" fa="save" caption="@Common.Save"/>
</div>
    
<div class="tab-content">
  <v:widget caption="SnApp">
    <v:widget-block>
      <v:form-field caption="@Outbound.InstanceType" hint="@Outbound.InstanceTypeHint">
        <label class="checkbox-label radio-inline-label"><input type="radio" id="radio-main" name="instance-type">&nbsp;<v:itl key="@Outbound.InstanceTypeMain"/></label>
        <label class="checkbox-label radio-inline-label"><input type="radio" id="radio-queue" name="instance-type">&nbsp;<v:itl key="@Outbound.InstanceTypeQueue"/></label>
      </v:form-field>
      <v:form-field id="field-queue-type" caption="@Outbound.QueueType" hint="@Outbound.QueueTypeHint" clazz="hidden">
        <label class="checkbox-label radio-inline-label"><input type="radio" id="radio-internal" name="queue-type">&nbsp;<v:itl key="@Outbound.QueueTypeInternal"/></label>
        <label class="checkbox-label radio-inline-label"><input type="radio" id="radio-external" name="queue-type">&nbsp;<v:itl key="@Outbound.QueueTypeExternal"/></label>
      </v:form-field>
    </v:widget-block>
    <v:widget-block id="external-queue-block" clazz="hidden">
      <v:form-field caption="@Common.URL">
        <v:input-text field="outboundcfg.QueueURL"/>
      </v:form-field>
      <v:form-field caption="@Common.WorkstationId">
        <v:input-text field="outboundcfg.QueueWorkstationId" autocomplete="new-password"/>
      </v:form-field>
      <v:form-field caption="@Common.SecretKey">
        <v:input-text field="outboundcfg.QueueSecretKey" type="password" autocomplete="new-password"/>
      </v:form-field>
      <v:form-field caption="@Outbound.QueueOfflineItemCount" hint="@Outbound.QueueOfflineItemCountHint">
        <v:input-text placeholder="10" field="outboundcfg.QueueOfflineItemCount"/>
      </v:form-field>
      <v:form-field caption="@Outbound.QueueOfflineSleep" hint="@Outbound.QueueOfflineSleepHint">
        <v:input-text placeholder="1000" field="outboundcfg.QueueOfflineSleep"/>
      </v:form-field>
    </v:widget-block>
    
    <v:widget-block id="main-dsrc-block" clazz="hidden">
      <v:form-field caption="@Outbound.MainDataSourceInstance">
        <v:combobox field="outboundcfg.QueueProdDataSourceId" lookupDataSet="<%=dsDataSource%>" captionFieldName="DataSourceName" idFieldName="DataSourceId" allowNull="true" linkEntityType="<%=LkSNEntityType.DataSource%>"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
</div>

<script>
$(document).ready(function() {
  $("[name='instance-type']").change(refresh);
  $("[name='queue-type']").change(refresh);
  $("#btn-save").click(doSave);
  
  var instanceTypeSelector = <%=outboundcfg.QueueInstance.getBoolean()%> ? "#radio-queue" : "#radio-main";
  var queueTypeSelector = <%=outboundcfg.ExternalQueue.getBoolean()%> ? "#radio-external" : "#radio-internal";
  $(instanceTypeSelector).setChecked(true);
  $(queueTypeSelector).setChecked(true);
  refresh()
  
  function doSave() {
    
    showMessage(<v:itl key="@Outbound.ServerRestartRequired" encode="JS"/>, function() {
      var reqDO = {
          Command: "SaveOutboundConfig",
          SaveOutboundConfig: {
            OutboundConfig: {
              QueueInstance: $("#radio-queue").isChecked(),
              ExternalQueue: $("#radio-external").isChecked() && !$("#radio-queue").isChecked(),
              QueueURL: $('#outboundcfg\\.QueueURL').val(),
              QueueWorkstationId: $('#outboundcfg\\.QueueWorkstationId').val(),
              QueueSecretKey: $('#outboundcfg\\.QueueSecretKey').val(),
              QueueProdDataSourceId: $('#outboundcfg\\.QueueProdDataSourceId').val()
            }
          }
        };

        showWaitGlass();
        vgsService("System", reqDO, false, function() {
          hideWaitGlass();
          entitySaveNotification(<%=LkSNEntityType.OutboundConfiguration.getCode()%>, null);
        });
      });
  }
  
  function refresh() {
    var main = $("#radio-main").isChecked();
    var queue = $("#radio-queue").isChecked();
    var internal = $("#radio-internal").isChecked();
    var external = $("#radio-external").isChecked();
    
    $("#field-queue-type").setClass("hidden", !main);
    $("#external-queue-block").setClass("hidden", !(main && external));
    $("#main-dsrc-block").setClass("hidden", !(queue));
  }
});
  
</script>


