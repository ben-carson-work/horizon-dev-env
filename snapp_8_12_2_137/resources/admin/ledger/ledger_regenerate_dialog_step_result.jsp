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
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<v:wizard-step id="wizard-step-result" title="@Common.Result" clazz="loading">
  <v:widget clazz="result-spinner"><v:widget-block><i class="fa fa-circle-notch fa-spin"></i></v:widget-block></v:widget>

  <div class="result-data">
    <v:alert-box type="success"><v:itl key="@Common.SaveSuccessMsg"/></v:alert-box>

    <v:widget>
      <v:widget-block>
        <v:form-field caption="@Common.Sale">
          <snp:entity-link clazz="result-data-sale" entityId="REPLACE" entityType="<%=LkSNEntityType.Sale%>"></snp:entity-link>
        </v:form-field>
        <v:form-field caption="@Common.Transaction">
          <snp:entity-link clazz="result-data-transaction" entityId="REPLACE" entityType="<%=LkSNEntityType.Transaction%>"></snp:entity-link>
        </v:form-field>
      </v:widget-block>
    </v:widget>
  </div>

<style>
  #wizard-step-result .result-spinner {font-size: 3em; text-align: center;}
  #wizard-step-result:not(.loading) .result-spinner {display: none;}
  #wizard-step-result.loading .result-data {display: none;}
</style>

<script>
//# sourceURL=ledger_regenerate_dialog_step_result.jsp

$(document).ready(function() {
  const $step = $("#wizard-step-result");
  const $wizard = $step.closest(".wizard");

  $step.vWizard("step-activate", function(params) {
    if (params.direction == "forward") {
      $step.addClass("loading");
      
      var reqDO = {
        Command: "RecalcBalance",
        RecalcBalance: {
          Transaction: {}  
        }
      };

      $(document).trigger("ledger-recalcbalance-fillrequest", reqDO.RecalcBalance);
      $(document).trigger("wizard-transaction-fillrequest", reqDO.RecalcBalance.Transaction);

      vgsService("Ledger", reqDO, false, function(ansDO) {
        $step.removeClass("loading");
        triggerEntityChange(<%=LkSNEntityType.LedgerAccount.getCode()%>);
        
        var trnRecapDO = (((ansDO.Answer || {}).RecalcBalance || {}).TransactionRecap || {});
        _renderResultLink(".result-data-sale", trnRecapDO.SaleId, trnRecapDO.SaleCode);
        _renderResultLink(".result-data-transaction", trnRecapDO.TransactionId, trnRecapDO.TransactionCode);
      });
    }
  });
  
  function _renderResultLink(selector, id, name) {
    var $link = $step.find(selector);
    $link.attr("href", $link.attr("href").replaceAll("REPLACE", id));
    $link.text(name);
  }
});

</script>
    
</v:wizard-step>
