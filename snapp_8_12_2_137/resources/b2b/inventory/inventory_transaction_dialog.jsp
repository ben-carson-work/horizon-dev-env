<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>



<v:dialog id="transaction_inventory_dialog" title="@Common.Transaction" width="1024" height="768" autofocus="false">

  <div class="tab-toolbar">
    <v:pagebox gridId="transaction-inventory-grid"/>
  </div>

<div class="tab-content">
  <% String params = "AccountInventoryBalanceId=" + pageBase.getNullParameter("AccountInventoryBalanceId"); %>
  <v:async-grid id="transaction-inventory-grid" jsp="inventory/inventory_transaction_grid.jsp" params="<%=params%>"/>
</div>  

<script>
$(document).ready(function() {
  var dlg = $("#transaction_inventory_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {
      <v:itl key="@Common.Close" encode="JS"/>: doCloseDialog
    };
  });
});
</script>

</v:dialog>



