<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
String linkedSaleId = pageBase.getNullParameter("LinkedSaleId");
String linkedTransactionId = pageBase.getNullParameter("LinkedTransactionId");
String params = "LinkedSaleId=" + linkedSaleId;
if (linkedTransactionId != null)
  params = "LinkedTransactionId=" + linkedTransactionId;
%>

<v:dialog id="linked_transactions_dialog" title="@Sale.LinkedTransactions" width="1000" height="750" autofocus="true"> 

<div class="tab-toolbar">
  <v:pagebox gridId="transaction-grid"/>
</div>

<div class="tab-content">
  <v:async-grid id="transaction-grid" jsp="transaction/transaction_grid.jsp" params="<%=params%>"/>
</div>
  
<script>
var $dlg = $("#linked_transactions_dialog");
$dlg.on("snapp-dialog", function(event, params) {
  params.buttons = [
	{
	  text: itl("@Common.Close"),
	  click: doCloseDialog
	}
  ]; 
});
</script>

</v:dialog>