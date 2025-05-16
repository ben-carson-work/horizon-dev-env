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
    <v:form-field caption="@Task.DeleteMaxRowsNumber" hint="@Task.DeleteMaxRowsNumberHint">
      <v:input-text field="cfg.DeletedRowsNumberLimit" placeholder="1000"/>
    </v:form-field>

  </v:widget-block>
</v:widget>

<v:widget caption="@Common.System">
  <v:widget-block>
    <v:form-field caption="@Common.Logs">
      <div class="multi-col-container">
        <div class="multi-col-item">
          <div class="multi-col-item-title"><v:itl key="@Lookup.LogLevel.Fatal"/></div>
          <div class="multi-col-item-value"><v:input-text field="cfg.LogDays_Fatal" placeholder="@Common.Unlimited"/></div>
        </div>
        <div class="multi-col-item">
          <div class="multi-col-item-title"><v:itl key="@Lookup.LogLevel.Error"/></div>
          <div class="multi-col-item-value"><v:input-text field="cfg.LogDays_Error" placeholder="@Common.Unlimited"/></div>
        </div>
        <div class="multi-col-item">
          <div class="multi-col-item-title"><v:itl key="@Lookup.LogLevel.Warn"/></div>
          <div class="multi-col-item-value"><v:input-text field="cfg.LogDays_Warn" placeholder="@Common.Unlimited"/></div>
        </div>
        <div class="multi-col-item">
          <div class="multi-col-item-title"><v:itl key="@Lookup.LogLevel.Info"/></div>
          <div class="multi-col-item-value"><v:input-text field="cfg.LogDays_Info" placeholder="@Common.Unlimited"/></div>
        </div>
        <div class="multi-col-item">
          <div class="multi-col-item-title"><v:itl key="@Lookup.LogLevel.Debug"/></div>
          <div class="multi-col-item-value"><v:input-text field="cfg.LogDays_Debug" placeholder="@Common.Unlimited"/></div>
        </div>
        <div class="multi-col-item">
          <div class="multi-col-item-title"><v:itl key="@Lookup.LogLevel.Trace"/></div>
          <div class="multi-col-item-value"><v:input-text field="cfg.LogDays_Trace" placeholder="@Common.Unlimited"/></div>
        </div>
      </div>
    </v:form-field>
  </v:widget-block>

  <v:widget-block>
    <v:form-field caption="@Common.ProcessQueue">
      <div class="multi-col-container">
        <div class="multi-col-item">
          <div class="multi-col-item-title"><v:itl key="@Common.Failed"/></div>
          <div class="multi-col-item-value"><v:input-text field="cfg.UploadDays_Fail" placeholder="@Common.Unlimited"/></div>
        </div>
        <div class="multi-col-item">
          <div class="multi-col-item-title"><v:itl key="@Common.Success"/></div>
          <div class="multi-col-item-value"><v:input-text field="cfg.UploadDays_Success" placeholder="@Common.Unlimited"/></div>
        </div>
        <div class="multi-col-item"></div>
        <div class="multi-col-item"></div>
        <div class="multi-col-item"></div>
        <div class="multi-col-item"></div>
      </div>
    </v:form-field>
  </v:widget-block>

  <v:widget-block>
    <v:form-field caption="@Stats.PostProcesses">
      <div class="multi-col-container">
        <div class="multi-col-item">
          <div class="multi-col-item-title"><v:itl key="@Common.Failed"/> <v:hint-handle hint="@Task.DataPurge_AsyncFinalizeFailedPurgeDaysHint"/></div>
          <div class="multi-col-item-value"><v:input-text field="cfg.AsyncFinalizePurgeDays_Failed" placeholder="@Common.Unlimited"/></div>
        </div>
        <div class="multi-col-item">
          <div class="multi-col-item-title"><v:itl key="@Common.Success"/> <v:hint-handle hint="@Task.DataPurge_AsyncFinalizeSucceededPurgeHint"/></div>
          <div class="multi-col-item-value"><v:input-text field="cfg.AsyncFinalizePurgeDays_Succeeded" placeholder="@Common.Unlimited"/></div>
        </div>
        <div class="multi-col-item"></div>
        <div class="multi-col-item"></div>
        <div class="multi-col-item"></div>
        <div class="multi-col-item"></div>
      </div>
    </v:form-field>
  </v:widget-block>
</v:widget> 
  
<v:widget caption="@Outbound.Outbound">  
  <v:widget-block>
    <v:form-field caption="@Outbound.OutboundQueue">
      <div class="multi-col-container">
        <div class="multi-col-item">
          <div class="multi-col-item-title"><v:itl key="@Common.Failed"/></div>
          <div class="multi-col-item-value"><v:input-text field="cfg.OutboundDays_Fail" placeholder="@Common.Unlimited"/></div>
        </div>
        <div class="multi-col-item">
          <div class="multi-col-item-title"><v:itl key="@Common.Success"/></div>
          <div class="multi-col-item-value"><v:input-text field="cfg.OutboundDays_Success" placeholder="@Common.Unlimited"/></div>
        </div>
        <div class="multi-col-item"></div>
        <div class="multi-col-item"></div>
        <div class="multi-col-item"></div>
        <div class="multi-col-item"></div>
      </div>
    </v:form-field>
 
    <v:form-field caption="@Outbound.OutboundOffline">
      <div class="multi-col-container">
        <div class="multi-col-item">
          <div class="multi-col-item-title"><v:itl key="@Common.Failed"/></div>
          <div class="multi-col-item-value"><v:input-text field="cfg.OutboundOfflineDays_Fail" placeholder="@Common.Unlimited"/></div>
        </div>
        <div class="multi-col-item">
          <div class="multi-col-item-title"><v:itl key="@Common.Success"/></div>
          <div class="multi-col-item-value"><v:input-text field="cfg.OutboundOfflineDays_Success" placeholder="@Common.Unlimited"/></div>
        </div>
        <div class="multi-col-item"></div>
        <div class="multi-col-item"></div>
        <div class="multi-col-item"></div>
        <div class="multi-col-item"></div>
      </div>
    </v:form-field>

    <v:form-field caption="@Task.DataPurge_OutboundTrigger">
      <div class="multi-col-container">
        <div class="multi-col-item">
          <div class="multi-col-item-title"><v:itl key="@Common.All"/> <v:hint-handle hint="@Task.DataPurge_OutboundTriggerHint"/></div>
          <div class="multi-col-item-value"><v:input-text field="cfg.OutboundTriggerPurgeDays" placeholder="1"/></div>
        </div>
        <div class="multi-col-item"></div>
        <div class="multi-col-item"></div>
        <div class="multi-col-item"></div>
        <div class="multi-col-item"></div>
        <div class="multi-col-item"></div>
      </div>
    </v:form-field>
  </v:widget-block>
</v:widget>	
  
<v:widget caption="@SaleCapacity.SaleCapacity">  
  <v:widget-block>
    <v:form-field caption="@Task.DataPurge_ExpiredSaleCapacityHolds"     hint="@Task.DataPurge_ExpiredSaleCapacityHoldsHint"><v:input-text field="cfg.ExpiredSaleCapacityHoldDays" placeholder="1"/></v:form-field>
    <v:form-field caption="@Task.DataPurge_ShrinkSaleCapacityLogs"       hint="@Task.DataPurge_ShrinkSaleCapacityLogsHint"><v:input-text field="cfg.ShrinkSaleCapacityLogDays" placeholder="0"/></v:form-field>
    <v:form-field caption="@Task.DataPurge_LogsExpiredSaleCapacitySlots" hint="@Task.DataPurge_LogsExpiredSaleCapacitySlotsHint"><v:input-text field="cfg.LogsExpiredSaleCapacitySlotsDays" placeholder="90"/></v:form-field>
    <v:form-field caption="@Task.DataPurge_ExpiredSaleCapacitySlots"     hint="@Task.DataPurge_ExpiredSaleCapacitySlotsHint"><v:input-text field="cfg.ExpiredSaleCapacitySlotsDays"/></v:form-field>
  </v:widget-block>
</v:widget>   
  
<v:widget caption="@Common.Transaction">
  <v:widget-block>
	  <v:form-field caption="@Task.DataPurge_AuthDetails"            hint="@Task.DataPurge_AuthDetailsHint"><v:input-text field="cfg.CCAuthDays" placeholder="@Common.Unlimited"/></v:form-field>
	  <v:form-field caption="@Task.DataPurge_ReceiptSpool"           hint="@Task.DataPurge_ReceiptSpoolHint"><v:input-text field="cfg.ReceiptSpoolDays" placeholder="1"/></v:form-field>
	  <v:form-field caption="@Task.DataPurge_TicketSoftPurge"        hint="@Task.DataPurge_TicketSoftPurgeHint"><v:input-text field="cfg.TicketSoftPurgeDays" placeholder="@Common.Unlimited"/></v:form-field>
	  <v:form-field caption="@Task.DataPurge_PaymentReceipt"         hint="@Task.DataPurge_PaymentReceiptHint"><v:input-text field="cfg.PaymentReceiptDays" placeholder="@Common.Unlimited"/></v:form-field>
    <v:form-field caption="@Task.DataPurge_BiometricTemplatePurge" hint="@Task.DataPurge_BiometricTemplatePurgeHint"><v:input-text field="cfg.BiometricTemplatePurgeDays" placeholder="@Common.Unlimited"/></v:form-field>
    <v:form-field caption="@Task.DataPurge_Ledger"                 hint="@Task.DataPurge_LedgerHint"><v:input-text field="cfg.LedgerPurgeDays" placeholder="@Common.Unlimited"/></v:form-field>
	</v:widget-block> 
</v:widget>
  
<v:widget caption="@Common.Other">
  <v:widget-block>
    <v:form-field caption="@Task.Jobs"                              hint="@Task.DataPurge_JobsHint"><v:input-text field="cfg.TaskJobDays" placeholder="@Common.Unlimited"/></v:form-field>
  	<v:form-field caption="@Common.History"                         hint="@Task.DataPurge_HistoryHint"><v:input-text field="cfg.HistoryLogDays" placeholder="@Common.Unlimited"/></v:form-field>
  	<v:form-field caption="@Task.DataPurge_Emails"                  hint="@Task.DataPurge_EmailsHint"><v:input-text field="cfg.EmailDays" placeholder="@Common.Unlimited"/></v:form-field>
  	<v:form-field caption="@Task.DataPurge_ExpiredSeatHolds"        hint="@Task.DataPurge_ExpiredSeatHoldsHint"><v:input-text field="cfg.ExpiredSeatHoldDays" placeholder="1"/></v:form-field>
  	<v:form-field caption="@Task.DataPurge_ShopcartPurge"           hint="@Task.DataPurge_ShopcartPurgeHint"><v:input-text field="cfg.ShopcartPurgeDays" placeholder="1"/></v:form-field>
  	<v:form-field caption="@Task.DataPurge_ApiTracingPurge"         hint="@Task.DataPurge_ApiTracingPurgeHint"><v:input-text field="cfg.ApiTracingPurgeDays" placeholder="1"/></v:form-field>
  	<v:form-field caption="@Task.DataPurge_CaptchaCodePurge"        hint="@Task.DataPurge_CaptchaCodePurgeHint"><v:input-text field="cfg.CaptchaCodePurgeDays" placeholder="1"/></v:form-field>
    <v:form-field caption="@Task.DataPurge_AsyncProcessLogPurge"    hint="@Task.DataPurge_AsyncProcessLogPurgeHint"><v:input-text field="cfg.AsyncProcessLogPurgeDays" placeholder="@Common.Unlimited"/></v:form-field>
    <v:form-field caption="@Task.DataPurge_SaleCodePurge"           hint="@Task.DataPurge_SaleCodePurgeHint"><v:input-text field="cfg.SaleCodePurgeDays" placeholder="1"/></v:form-field>
    <v:form-field caption="@Task.DataPurge_DraftContractPurge"      hint="@Task.DataPurge_DraftContractPurgeHint"><v:input-text field="cfg.DraftContractDays" placeholder="1"/></v:form-field>
    <v:form-field caption="@Task.DataPurge_RedemptionChangesPurge"  hint="@Task.DataPurge_RedemptionChangesPurgeHint"><v:input-text field="cfg.RedemptionChangesPurgeDays" placeholder="1"/></v:form-field>
    <v:form-field caption="@Task.DataPurge_MessagePurge"            hint="@Task.DataPurge_MessagePurgeHint"><v:input-text field="cfg.MessagePurgeDays" placeholder="@Common.Unlimited"/></v:form-field>
    <v:form-field caption="@Task.DataPurge_WhitelistSupportTable"   hint="@Task.DataPurge_WhitelistSupportTableHint"><v:input-text field="cfg.WhitelistSupportTablePurgeDays" placeholder="0"/></v:form-field>
    <v:form-field caption="@Task.DataPurge_MaintenanceTask"         hint="@Task.DataPurge_MaintenanceTaskHint"><v:input-text field="cfg.MaintenanceTaskDays" placeholder="1"/></v:form-field>
    <v:form-field caption="@Task.DataPurge_ConsQueuePurge"          hint="@Task.DataPurge_ConsQueuePurgeHint"><v:input-text field="cfg.ConsQueuePurgeDays" placeholder="1"/></v:form-field>
    <v:form-field caption="@Task.DataPurge_EntitlementDynamic"      hint="@Task.DataPurge_EntitlementDynamicHint"><v:input-text field="cfg.EntitlementDynamicDays" placeholder="1"/></v:form-field>
    <v:form-field caption="@Task.DataPurge_SnAppWarFiles"           hint="@Task.DataPurge_SnAppWarFilesHint"><v:input-text field="cfg.SnAppWarFilesQtyToKeep" placeholder="2"/></v:form-field>
    <v:form-field caption="@Task.DataPurge_ExtMediaCodeHoldMinutes" hint="@Task.DataPurge_ExtMediaCodeHoldMinutesHint"><v:input-text field="cfg.ExtMediaCodeHoldMinutes" placeholder="10"/></v:form-field>
  </v:widget-block>
</v:widget>	

<v:widget caption="@Task.IndexMaintenance">	
	<v:widget-block>
	  <v:form-field caption="@Task.IndexFragLimit" hint="@Task.IndexFragLimitHint"><v:input-text field="cfg.DB_IndexFragLimit" placeholder="@Task.DontCheck"/></v:form-field>
	  <v:form-field><v:db-checkbox field="cfg.DB_IndexRebuildOnline" value="true" caption="@Task.RebuildOnline"/></v:form-field>
	</v:widget-block>
</v:widget>	

<script>

function saveTaskConfig(reqDO) {
  var recSpoolDaysEmpty = $("#cfg\\.ReceiptSpoolDays").val() == "";
  var config = {
  	LogDays_Fatal: $("#cfg\\.LogDays_Fatal").val(),
  	LogDays_Error: $("#cfg\\.LogDays_Error").val(),
  	LogDays_Warn: $("#cfg\\.LogDays_Warn").val(),
  	LogDays_Info: $("#cfg\\.LogDays_Info").val(),
  	LogDays_Debug: $("#cfg\\.LogDays_Debug").val(),
  	LogDays_Trace: $("#cfg\\.LogDays_Trace").val(),
  	UploadDays_Fail: $("#cfg\\.UploadDays_Fail").val(),
  	UploadDays_Success: $("#cfg\\.UploadDays_Success").val(),
  	OutboundDays_Fail: $("#cfg\\.OutboundDays_Fail").val(),
  	OutboundDays_Success: $("#cfg\\.OutboundDays_Success").val(),
    OutboundOfflineDays_Fail: $("#cfg\\.OutboundOfflineDays_Fail").val(),
    OutboundOfflineDays_Success: $("#cfg\\.OutboundOfflineDays_Success").val(),
    TaskJobDays: $("#cfg\\.TaskJobDays").val(),
    HistoryLogDays: $("#cfg\\.HistoryLogDays").val(),
    EmailDays: $("#cfg\\.EmailDays").val(),
    DB_IndexFragLimit: $("#cfg\\.DB_IndexFragLimit").val(),
    DB_IndexRebuildOnline: $("#cfg\\.DB_IndexRebuildOnline").isChecked(),
    CCAuthDays: $("#cfg\\.CCAuthDays").val(),
    ReceiptSpoolDays: (recSpoolDaysEmpty)? 1 : $("#cfg\\.ReceiptSpoolDays").val(),
    TicketSoftPurgeDays: $("#cfg\\.TicketSoftPurgeDays").val(),
    PaymentReceiptDays: $("#cfg\\.PaymentReceiptDays").val(),
    ExpiredSeatHoldDays: $("#cfg\\.ExpiredSeatHoldDays").val(),
    ExpiredSaleCapacityHoldDays: $("#cfg\\.ExpiredSaleCapacityHoldDays").val(),
    ShrinkSaleCapacityLogDays: $("#cfg\\.ShrinkSaleCapacityLogDays").val(),
    LogsExpiredSaleCapacitySlotsDays: $("#cfg\\.LogsExpiredSaleCapacitySlotsDays").val(),
    ExpiredSaleCapacitySlotsDays: $("#cfg\\.ExpiredSaleCapacitySlotsDays").val(),
    ShopcartPurgeDays: $("#cfg\\.ShopcartPurgeDays").val(),
    ApiTracingPurgeDays: $("#cfg\\.ApiTracingPurgeDays").val(),
    CaptchaCodePurgeDays: $("#cfg\\.CaptchaCodePurgeDays").val(),
    BiometricTemplatePurgeDays: $("#cfg\\.BiometricTemplatePurgeDays").val(),
    LedgerPurgeDays: $("#cfg\\.LedgerPurgeDays").val(),
    AsyncProcessLogPurgeDays: $("#cfg\\.AsyncProcessLogPurgeDays").val(),
    AsyncFinalizePurgeDays_Succeeded: $("#cfg\\.AsyncFinalizePurgeDays_Succeeded").val(),
    AsyncFinalizePurgeDays_Failed: $("#cfg\\.AsyncFinalizePurgeDays_Failed").val(),
    SaleCodePurgeDays: $("#cfg\\.SaleCodePurgeDays").val(),
    OutboundTriggerPurgeDays: $("#cfg\\.OutboundTriggerPurgeDays").val(),
  	DeletedRowsNumberLimit: $("#cfg\\.DeletedRowsNumberLimit").val(),
    DraftContractDays: $("#cfg\\.DraftContractDays").val(),
    RedemptionChangesPurgeDays: $("#cfg\\.RedemptionChangesPurgeDays").val(),
    MessagePurgeDays: $("#cfg\\.MessagePurgeDays").val(),
    WhitelistSupportTablePurgeDays: $("#cfg\\.WhitelistSupportTablePurgeDays").val(),
    MaintenanceTaskDays: $("#cfg\\.MaintenanceTaskDays").val(),
    ConsQueuePurgeDays: $("#cfg\\.ConsQueuePurgeDays").val(),
    EntitlementDynamicDays: $("#cfg\\.EntitlementDynamicDays").val(),
    SnappWarFilesQtyToKeep: $("#cfg\\.SnAppWarFilesQtyToKeep").val(),
    ExtMediaCodeHoldMinutes: $("#cfg\\.ExtMediaCodeHoldMinutes").val()
  }
  
  reqDO.TaskConfig = JSON.stringify(config); 
}

</script>

