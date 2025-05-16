<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:dialog id="linked_invoicess_dialog" title="@Invoice.LinkedInvoices" width="1000" height="750" autofocus="true"> 

<div class="tab-toolbar">
  <v:pagebox gridId="invoice-grid"/>
</div>

<div class="tab-content">
  <% 
  String params = ""; 
  if (pageBase.getNullParameter("LinkedTransactionId") != null)
    params = "SettlementTransactionId=" + pageBase.getNullParameter("LinkedTransactionId");
  else if (pageBase.getNullParameter("LinkedSaleId") != null)
    params = "SaleId=" + pageBase.getNullParameter("LinkedSaleId");
    
  %>
  <v:async-grid id="invoice-grid" jsp="invoice/invoice_grid.jsp" params="<%=params%>"/>
</div>
  
<script>
var $dlg = $("#linked_invoices_dialog");
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