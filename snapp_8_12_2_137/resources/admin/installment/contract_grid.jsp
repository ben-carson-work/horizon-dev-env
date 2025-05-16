<%@page import="com.vgs.snapp.api.installment.API_InstallmentContract_Search"%>
<%@page import="com.vgs.snapp.api.installment.APIDef_InstallmentContract_Search"%>
<%@page import="com.vgs.snapp.web.bko.library.BLBO_Installment"%>
<%@page import="com.vgs.snapp.dataobject.DOInstallmentContractRef"%>
<%@page import="com.vgs.snapp.web.search.BLBO_QueryRef_InstallmentContract"%>
<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_InstallmentContract.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%

APIDef_InstallmentContract_Search.DORequest reqDO = new APIDef_InstallmentContract_Search.DORequest();

if (pageBase.getNullParameter("Code") != null)
  reqDO.Code.setString(pageBase.getNullParameter("Code"));
else {
  if (pageBase.getNullParameter("InstallmentContractStatus") != null)
    reqDO.InstallmentContractStatus.setXMLValue(pageBase.getNullParameter("InstallmentContractStatus"));

  if (pageBase.getNullParameter("CreateDateFrom") != null)
    reqDO.CreateDateFrom.setXMLValue(pageBase.getNullParameter("CreateDateFrom"));

  if (pageBase.getNullParameter("CreateDateTo") != null)
    reqDO.CreateDateTo.setXMLValue(pageBase.getNullParameter("CreateDateTo"));

  if (pageBase.getNullParameter("BlockDateFrom") != null)
    reqDO.BlockDateFrom.setXMLValue(pageBase.getNullParameter("BlockDateFrom"));

  if (pageBase.getNullParameter("BlockDateTo") != null)
    reqDO.BlockDateTo.setXMLValue(pageBase.getNullParameter("BlockDateTo"));

  if (pageBase.getNullParameter("AccountId") != null)
    reqDO.LocateAccount.AccountId.setString(pageBase.getNullParameter("AccountId"));

  if (pageBase.getNullParameter("PaymentTokenAuthCode") != null)
    reqDO.PaymentTokenAuthCode.setString(pageBase.getNullParameter("PaymentTokenAuthCode"));

  if (pageBase.getNullParameter("TransactionId") != null)
    reqDO.LocateTransaction.TransactionId.setString(pageBase.getNullParameter("TransactionId"));

  if (pageBase.getNullParameter("SaleId") != null)
    reqDO.LocateSale.SaleId.setString(pageBase.getNullParameter("SaleId"));
}

reqDO.SearchRecap.PagePos.setInt(pageBase.getQP());
reqDO.SearchRecap.RecordPerPage.setInt(QueryDef.recordPerPageDefault);

reqDO.SearchRecap.addSortField(Sel.CreateDateTime, true);

APIDef_InstallmentContract_Search.DOResponse ansDO = new APIDef_InstallmentContract_Search.DOResponse();
pageBase.getBL(API_InstallmentContract_Search.class).execute(reqDO, ansDO);

request.setAttribute("searchContract", ansDO);
%>

<jsp:include page="../installment/contract_grid_static.jsp"></jsp:include>

<script>
function showReschedulePaymentsDialog() {
  var contractIDs = $("[name='InstallmentContractId']").getCheckedValues();
  if (contractIDs.length == 0)
    showMessage(itl("@Common.NoElementWasSelected"));
  else {
    var $dlg = $("<div><input type='text' class='next-attempt-date form-control'/></div>");
    $dlg.find("input").datepicker();
    $dlg.dialog({
      title: itl("@Installment.ReschedulePayments"),
      modal: true,
      width: 250,
      close: function() {
        $dlg.remove();
      },
      buttons: [
        {
          text: itl("@Common.Ok"),
          click: _doReschedulePayments
        },
        {
          text: itl("@Common.Cancel"),
          click: doCloseDialog
        }
      ] 
    });    
  }
  
  function _doReschedulePayments() {
    var reqDO = {
      Command: "ReschedulePayments",
      ReschedulePayments: {
        InstallmentContractIDs: contractIDs,
        NextAttemptDate: $dlg.find(".next-attempt-date").getXMLDate()
      }
    };
    
    if ($("#instcontr-grid-table").hasClass("multipage-selected")) {
      reqDO.ReschedulePayments.InstallmentContractIDs = null;            
      reqDO.ReschedulePayments.QueryBase64 = "<%=ansDO.SearchRecap.QueryBase64%>";            
    }

    showWaitGlass();
    vgsService("Installment", reqDO, false, function(ansDO) {
      hideWaitGlass();
      $dlg.dialog("close");
      showAsyncProcessDialog(ansDO.Answer.ReschedulePayments.AsyncProcessId, null, true);
    });
  }
}
</script>
