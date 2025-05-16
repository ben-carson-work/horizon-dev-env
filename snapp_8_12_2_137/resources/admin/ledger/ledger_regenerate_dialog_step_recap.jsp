<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<v:wizard-step id="wizard-step-recap" title="@Common.Recap">
  <v:widget clazz="recap-spinner"><v:widget-block><i class="fa fa-circle-notch fa-spin"></i></v:widget-block></v:widget>
  
  <v:alert-box clazz="recap-match" type="success"><v:itl key="@Ledger.NoMismatchFound"/></v:alert-box>
  <v:alert-box clazz="recap-error" type="warning" title="@Common.Warning"></v:alert-box>

  <v:grid clazz="recap-mismatch">
    <thead>
      <tr>
        <td class="recap-mismatch-col-account"><v:itl key="@Account.Account"/></td>
        <td class="recap-mismatch-col-entrybalance"><v:itl key="@Ledger.Entries"/></td>
        <td class="recap-mismatch-col-consbalance"><v:itl key="@Ledger.Consolidated"/></td>
      </tr>
    </thead>
    <tbody>
    </tbody>
  </v:grid>
  
  <div id="templates" class="hidden">
    <v:grid>
      <v:grid-group clazz="recap-mismatch-date"></v:grid-group>
      <tr class="grid-row recap-mismatch-row">
        <td class="recap-mismatch-col recap-mismatch-col-account"></td>
        <td class="recap-mismatch-col recap-mismatch-col-entrybalance"></td>
        <td class="recap-mismatch-col recap-mismatch-col-consbalance"></td>
      </td>
    </v:grid>

    <v:widget caption="DUMMY" clazz="recap-date-widget">
      <v:widget-block></v:widget-block>
    </v:widget>
  </div>

<style>
  #wizard-step-recap .recap-spinner {font-size: 3em; text-align: center;}
  
  #wizard-step-recap:not([data-status='loading']) .recap-spinner,
  #wizard-step-recap:not([data-status='error']) .recap-error,
  #wizard-step-recap:not([data-status='match']) .recap-match,
  #wizard-step-recap:not([data-status='mismatch']) .recap-mismatch {display: none;}
  /*
  #wizard-step-recap.loading .recap-match {display: none;}
  #wizard-step-recap.mismatch .recap-match {display: none;}
  #wizard-step-recap:not(.mismatch) .recap-mismatch {display: none;}
  */
  #wizard-step-recap .recap-mismatch-col-entrybalance,#wizard-step-recap .recap-mismatch-col-consbalance {text-align: right;}
  #wizard-step-recap .recap-mismatch-row-date {font-weight: bold;}
  #wizard-step-recap .recap-mismatch-row-ledgeraccount .recap-mismatch-col-account {padding-left: 30px;}
  #wizard-step-recap .recap-mismatch-row-account .recap-mismatch-col-account {padding-left: 60px;}
  #wizard-step-recap tbody .recap-mismatch-col-consbalance {color: var(--base-red-color);}
</style>

<script>
//# sourceURL=ledger_regenerate_dialog_step_recap.jsp

$(document).ready(function() {
  const $step = $("#wizard-step-recap");
  const $wizard = $step.closest(".wizard");
  var changeList = [];

  $step.vWizard("step-activate", function(params) {
    if (params.direction == "forward") {
      $step.attr("data-status", "loading");
      $wizard.enableDisable();
      
      _queryDateList(function(ansDO) {
        $step.removeClass("loading");
        var $dateTemplate = $step.find("#templates .recap-date-widget");
        var $container = $step.find(".recap-mismatch tbody");
        $container.empty();
        
        var dates = ((((ansDO.Answer || {}).CheckBalance || {}).DateList || []));
        for (var dateDO of dates) {
          $container.append(_createMismatchRow("recap-mismatch-row-date", null, formatDate(dateDO.Date), dateDO.EntryBalance, dateDO.ConsBalance));

          for (ledgerAccountDO of (dateDO.LedgerAccountList || [])) {
            $container.append(_createMismatchRow("recap-mismatch-row-ledgeraccount", ledgerAccountDO.LedgerAccountCode, ledgerAccountDO.LedgerAccountName, ledgerAccountDO.EntryBalance, ledgerAccountDO.ConsBalance));

            for (accountDO of (ledgerAccountDO.AccountList || [])) {
              $container.append(_createMismatchRow("recap-mismatch-row-account", accountDO.AccountCode, accountDO.AccountName, accountDO.EntryBalance, accountDO.ConsBalance));
              
              changeList.push({
                LedgerFiscalDate: dateDO.Date,
                LedgerAccountId: ledgerAccountDO.LedgerAccountId,
                Account: {AccountId: accountDO.AccountId},
                BalanceDelta: accountDO.EntryBalance - accountDO.ConsBalance
              });
            }
          }
        }
        
        $step.attr("data-status", (dates.length > 0) ? "mismatch" : "match");
        $wizard.enableDisable();
      });     
    }
  });
  
  $(document).von($step, "ledger-recalcbalance-fillrequest", function(event, reqCMD) {
    reqCMD.ChangeList = changeList;
  });

  function _queryDateList(callback) {
    var reqDO = {
      Command: "CheckBalance",
      CheckBalance: {
        DateFrom: $wizard.find("#picker-date-from").val(),
        DateTo: $wizard.find("#picker-date-to").val(),
        ReturnMismatchOnly: true
      }
    };
    
    vgsService("Ledger", reqDO, true, function(ansDO) {
      var error = getVgsServiceError(ansDO);
      if (error) {
        $step.attr("data-status", "error");
        $step.find(".recap-error .alert-body").text(error);
      }
      else 
        callback(ansDO);
    });
  }
  
  function _formatLedgerAmount(value) {
    if (value == 0)
      return CHAR_MDASH;
    if (value < 0)
      return "DR " + formatAmount(-value);
    else
      return "CR " + formatAmount(value);
  }
  
  function _createMismatchRow(clazz, code, name, entry, cons) {
    var account = name || "";
    if (code)
      account = "[" + code + "] " + account;
    
    var $result = $step.find("#templates .recap-mismatch-row").clone();
    $result.addClass(clazz);
    $result.find(".recap-mismatch-col-account").text(account);
    $result.find(".recap-mismatch-col-entrybalance").text(_formatLedgerAmount(entry));
    $result.find(".recap-mismatch-col-consbalance").text(_formatLedgerAmount(cons));
    return $result;
  }
});

</script>
    
</v:wizard-step>
