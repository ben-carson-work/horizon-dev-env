<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>


<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:dialog id="portfolioslot_dialog" icon="membershippoint.png" title="@Product.MembershipPoints" width="800" height="600" autofocus="false">

<div class="form-toolbar">
  <v:pagebox gridId="portfolioslot-grid"/>
</div>

<% String membershipParams = "PortfolioId=" + pageBase.getId() + "&ExcludePorfolioWalletSlot=true"; %>
<v:async-grid jsp="portfolio/portfolioslot_grid.jsp" id="portfolioslot-grid" params="<%=membershipParams%>"></v:async-grid>

<script>

$(document).ready(function() {
  $("#portfolio_dialog .tabs").tabs();
  
   var dlg = $("#portfolioslot_dialog");
   dlg.on("snapp-dialog", function(event, params) {
     params.buttons = {
       <v:itl key="@Common.Close" encode="JS"/>: doCloseDialog
     };
   });

});

</script>

</v:dialog>