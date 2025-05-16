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

<v:dialog id="ledger_regenerate_dialog" width="800" height="600" title="@Ledger.Ledger">

  <v:wizard>
    <jsp:include page="ledger_regenerate_dialog_step_params.jsp"></jsp:include>
    <jsp:include page="ledger_regenerate_dialog_step_recap.jsp"></jsp:include>
    <% if (rights.LedgerRegenerate.getBoolean()) { %>
      <jsp:include page="../common/wizard_step_survey.jsp"><jsp:param name="TransactionType" value="<%=LkSNTransactionType.LedgerBalanceRecalc.getCode()%>"/></jsp:include>
      <jsp:include page="../common/wizard_step_notes.jsp"></jsp:include>
      <jsp:include page="ledger_regenerate_dialog_step_result.jsp"></jsp:include>
    <% } %>
  </v:wizard>

<script>
//# sourceURL=ledger_regenerate_dialog.jsp

$(document).ready(function() {
  var $dlg = $("#ledger_regenerate_dialog");
  var $wizard = $dlg.find(".wizard");
  
  $dlg.on("snapp-dialog", function(event, params) {
    params.open = _enableDisable;
    params.buttons = [
      dialogButton("@Common.Back", _backStep, "btn-back"),
      dialogButton("@Common.Continue", _nextStep, "btn-next"),
      dialogButton("@Common.Close", doCloseDialog)
    ]; 
  });
  
  var origEnableDisable = jQuery.fn.enableDisable; 
  jQuery.fn.enableDisable = function(p1, p2, p3, p4, p5) {
    if (this.id == $wizard.attr("id"))
      _enableDisable();
    else if (origEnableDisable)
      return origEnableDisable(p1, p2, p3, p4, p5);
    return $(this);
  };
  
  $wizard.vWizard({
    onStepChanged: _enableDisable
  });
  
  function _enableDisable() {
    var index = $wizard.vWizard("activeIndex");
    var length = $wizard.vWizard("length");

    var firstStep = (index == 0);
    var lastStep = (index == length-1);
    var mismatch = $wizard.find("#wizard-step-recap").attr("data-status") == "mismatch";
    
    var $dialogButtonset = $dlg.closest(".ui-dialog").find(".ui-dialog-buttonset");
    var $btnNext = $dialogButtonset.find("#btn-next"); 
    var $btnBack = $dialogButtonset.find("#btn-back"); 

    $btnBack.setEnabled(!firstStep); 
    $btnNext.setEnabled(!lastStep && (firstStep || mismatch));
  }
  
  function _nextStep() {
    if ($wizard.find("#wizard-step-notes").is(".active")) {
      confirmDialog(null, function() {
        $wizard.vWizard("next");
      });
    }
    else
      $wizard.vWizard("next");
  }
  
  function _backStep() {
    $wizard.vWizard("prior");
  }

});

</script>

</v:dialog>


