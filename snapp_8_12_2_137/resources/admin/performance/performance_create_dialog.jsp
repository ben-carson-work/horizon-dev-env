<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="java.text.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request" />
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
String eventId = pageBase.getNullParameter("EventId");
boolean tabResource = rights.ResourceManagement.canUpdate() && pageBase.getBL(BLBO_Event.class).hasResourceManagement(eventId); 
%>

<v:dialog id="performance_create_dialog" title="@Performance.CreateWizard" width="900" height="700" autofocus="false">

  <v:wizard>
    <jsp:include page="performance_create_dialog_step_schedule.jsp"></jsp:include>
    <jsp:include page="performance_create_dialog_step_sale.jsp"></jsp:include>
    <% if (tabResource) { %>
      <jsp:include page="performance_create_dialog_step_resource.jsp"></jsp:include>
    <% } %> 
    <jsp:include page="performance_create_dialog_step_admission.jsp"></jsp:include>
  </v:wizard>
  
  
<script>

$(document).ready(function() {
  var $dlg = $("#performance_create_dialog");
  var $wizard = $dlg.find(".wizard");
  
  $dlg.on("snapp-dialog", function(event, params) {
    params.open = _enableDisable;
    params.buttons = [
      dialogButton("@Common.Back", _backStep, "btn-back"),
      dialogButton("@Common.Continue", _nextStep, "btn-next"),
      dialogButton("@Common.Confirm", _confirm, "btn-confirm"),
      dialogButton("@Common.Close", doCloseDialog)
    ]; 
  });
  
  $wizard.vWizard({
    onStepChanged: _enableDisable
  });

  function _enableDisable() {
    var index = $wizard.vWizard("activeIndex");
    var length = $wizard.vWizard("length");

    var firstStep = (index == 0);
    var lastStep = (index >= length-1);
    
    var $dialogButtonset = $dlg.closest(".ui-dialog").find(".ui-dialog-buttonset");
    var $btnNext = $dialogButtonset.find("#btn-next"); 
    var $btnBack = $dialogButtonset.find("#btn-back"); 
    var $btnConfirm = $dialogButtonset.find("#btn-confirm"); 
    
    $btnBack.setEnabled(!firstStep); 
    $btnNext.setClass("hidden", lastStep);
    $btnConfirm.setClass("hidden", !lastStep);
  }
  
  function _nextStep() {
    $wizard.vWizard("next");
  }
  
  function _backStep() {
    $wizard.vWizard("prior");
  }
  
  function _confirm() {
    $wizard.vWizard("validateActiveStep", _callCreatePerformanceAPI);
  }

  function _callCreatePerformanceAPI() {
    var reqDO = {
      EventId: <%=JvString.jsString(pageBase.getNullParameter("EventId"))%>,
    };

    $wizard.vWizard("fillData", reqDO);
    console.log(reqDO);

    snpAPI.cmd("Performance", "MultiCreate", reqDO).then(ansDO => {
      $dlg.dialog("close");
      showAsyncProcessDialog(ansDO.AsyncProcessId);
    });
  }
});

</script>
</v:dialog>

