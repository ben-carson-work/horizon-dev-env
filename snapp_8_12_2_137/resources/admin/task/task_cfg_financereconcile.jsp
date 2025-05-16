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

<v:widget caption="@Common.Clearing">
	<v:widget-block>
    <v:form-field caption="@Task.FinanceReconciliation_VoucherClearing" hint="@Task.FinanceReconciliation_VoucherClearingHint"><v:input-text field="cfg.VouchExpToleranceDays" placeholder="@Task.FinanceReconciliation_NeverCleared"/></v:form-field>
	  <v:form-field caption="@Task.FinanceReconciliation_ProductClearing" hint="@Task.FinanceReconciliation_ProductClearingHint"><v:input-text field="cfg.ProdClearingToleranceDays" placeholder="@Task.FinanceReconciliation_NeverCleared"/></v:form-field>
	  <v:form-field caption="@Task.FinanceReconciliation_ProductExpiration" hint="@Task.FinanceReconciliation_ProductExpirationHint"><v:input-text field="cfg.ProdExpirationToleranceDays" placeholder="@Task.FinanceReconciliation_NoRevenueAllocationProductBreaking"/></v:form-field>
	  <v:form-field caption="@Task.FinanceReconciliation_ProductBreakage" hint="@Task.FinanceReconciliation_ProductBreakageHint"><v:input-text field="cfg.ProdBreakageToleranceDays" placeholder="@Task.FinanceReconciliation_NoRevenueAllocationProductBreaking"/></v:form-field>
	  <v:form-field caption="@Task.FinanceReconciliation_LedgerCleRegRule" hintLink="task/task_financereconcile_ledgerreg_hint"><v:lk-combobox field="cfg.LedgerRegDateTimeRule" lookup="<%=LkSN.LedgerRegDateTimeRule%>" allowNull="false"/></v:form-field>
	  <v:form-field caption="@Task.FinanceReconciliation_LedgerExpRegRule" hintLink="task/task_financereconcile_ledger_exp_reg_hint"><v:lk-combobox field="cfg.LedgerExpRegDateTimeRule" lookup="<%=LkSN.LedgerRegDateTimeRule%>" allowNull="false"/></v:form-field>
    <v:form-field caption="@Task.FinanceReconciliation_LedgerBrkRegRule" hintLink="task/task_financereconcile_ledger_brk_reg_hint"><v:lk-combobox field="cfg.LedgerBrkRegDateTimeRule" lookup="<%=LkSN.LedgerRegDateTimeRule%>" allowNull="false"/></v:form-field>
    <v:form-field caption="@Task.FinanceReconciliation_PPUExpiredPerfClearing" hint="@Task.FinanceReconciliation_PPUExpiredPerfClearingHint"><v:input-text field="cfg.PPUBookedPerformanceToleranceDays" placeholder="@Task.FinanceReconciliation_NeverCleared"/></v:form-field>
    <v:form-field caption="@Task.FinanceReconciliation_Threads" hint="@Task.FinanceReconciliation_ThreadsHint"><v:input-text field="cfg.LedgerTriggerThreads" placeholder="10"/></v:form-field>
  </v:widget-block>
</v:widget>	
<v:widget caption="@Lookup.LedgerType.Amortization">
	<v:widget-block>
	  <v:form-field caption="@Task.FinanceReconciliation_LedgerAmoRegRule" hintLink="task/task_financereconcile_ledger_amo_reg_hint"><v:lk-combobox field="cfg.LedgerAmoRegDateTimeRule" lookup="<%=LkSN.LedgerRegDateTimeRule%>" allowNull="false"/></v:form-field>
	  <v:form-field caption="@Task.FinanceReconciliation_PausedAmortizationForBlockedTickets">
	    <v:db-checkbox field="cfg.PausedAmortizationForManuallyBlockedTickets" caption="@Lookup.TicketStatus.ManuallyBlocked" value="true"/>&nbsp;&nbsp;
	    <v:db-checkbox field="cfg.PausedAmortizationForInstallmentBlockedTickets" caption="@Lookup.TicketStatus.InstallmentBlocked" value="true"/>
	  </v:form-field>
	  <v:form-field caption="@Task.FinanceReconciliation_PausedAmortizationForBlockedContracts">
	    <v:db-checkbox field="cfg.PausedAmortizationForManuallyBlockedContracts" caption="@Lookup.InstallmentContractStatus.ManuallyBlocked" value="true"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	    <v:db-checkbox field="cfg.PausedAmortizationForAutomaticBlockedcontracts" caption="@Lookup.InstallmentContractStatus.AutomaticallyBlocked" value="true"/>
	  </v:form-field>
    <v:form-field caption="@Task.FinanceReconciliation_Threads" hint="@Task.FinanceReconciliation_ThreadsHint"><v:input-text field="cfg.AmortizationThreads" placeholder="10"/></v:form-field>
  </v:widget-block>
</v:widget>	  
<v:widget caption="@Box.BoxMaintenance">
  <v:widget-block>	  
	  <v:form-field caption="@Box.AutoCloseBox" hint="@Box.AutoCloseBoxHint"><v:db-checkbox field="cfg.AutoCloseBox" caption="" value="true"/></v:form-field>
	</v:widget-block>
</v:widget>
<script>

function saveTaskConfig(reqDO) {
  var prodClearingDays = parseInt($("#cfg\\.ProdClearingToleranceDays").val());
  var prodExpirationDays = parseInt($("#cfg\\.ProdExpirationToleranceDays").val());
  var vouchDays = parseInt($("#cfg\\.VouchExpToleranceDays").val());
  var ppuBookedDays = parseInt($("#cfg\\.PPUBookedPerformanceToleranceDays").val());
  var breakageDays = parseInt($("#cfg\\.ProdBreakageToleranceDays").val());
  
  var config ={
		  ProdClearingToleranceDays: !isNaN(prodClearingDays) ? $("#cfg\\.ProdClearingToleranceDays").val() : null,
		  ProdExpirationToleranceDays: !isNaN(prodExpirationDays) ? $("#cfg\\.ProdExpirationToleranceDays").val() : null,
		  VouchExpToleranceDays: !isNaN(vouchDays) ? $("#cfg\\.VouchExpToleranceDays").val() : null,
		  PPUBookedPerformanceToleranceDays: !isNaN(ppuBookedDays) ? $("#cfg\\.PPUBookedPerformanceToleranceDays").val() : null,
		  ProdBreakageToleranceDays: !isNaN(breakageDays) ? $("#cfg\\.ProdBreakageToleranceDays").val() : null,
      LedgerTriggerThreads: $("#cfg\\.LedgerTriggerThreads").val(),
			LedgerRegDateTimeRule: $("#cfg\\.LedgerRegDateTimeRule").val(),
			LedgerExpRegDateTimeRule: $("#cfg\\.LedgerExpRegDateTimeRule").val(),
			LedgerAmoRegDateTimeRule: $("#cfg\\.LedgerAmoRegDateTimeRule").val(),
			LedgerBrkRegDateTimeRule: $("#cfg\\.LedgerBrkRegDateTimeRule").val(),
			PausedAmortizationForManuallyBlockedTickets: $("#cfg\\.PausedAmortizationForManuallyBlockedTickets").isChecked(),
			PausedAmortizationForInstallmentBlockedTickets: $("#cfg\\.PausedAmortizationForInstallmentBlockedTickets").isChecked(),
			PausedAmortizationForManuallyBlockedContracts: $("#cfg\\.PausedAmortizationForManuallyBlockedContracts").isChecked(),
			PausedAmortizationForAutomaticBlockedContracts: $("#cfg\\.PausedAmortizationForAutomaticBlockedcontracts").isChecked(),
      AmortizationThreads: $("#cfg\\.AmortizationThreads").val(),
			AutoCloseBox: $("#cfg\\.AutoCloseBox").isChecked()
	}
	reqDO.TaskConfig = JSON.stringify(config); 
}

</script>

