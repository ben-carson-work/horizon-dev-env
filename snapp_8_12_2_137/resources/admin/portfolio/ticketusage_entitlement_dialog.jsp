<%@page import="com.vgs.web.library.BLBO_Entitlement"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<%@ taglib uri="vgs-tags" prefix="v" %>

<%
QueryDef qdef = new QueryDef(QryBO_TicketUsage.class)
    .addFilter(QryBO_TicketUsage.Fil.TicketUsageId, pageBase.getId())
    .addSelect(
        QryBO_TicketUsage.Sel.TicketEntitlementData,
        QryBO_TicketUsage.Sel.TicketDynamicEntitlementData,
        QryBO_TicketUsage.Sel.TicketProductFlags);

DOEntitlement entitlement = new DOEntitlement();
try (JvDataSet ds = pageBase.execQuery(qdef)) {
  if (!ds.isEmpty()) {
    List<LookupItem> productFlags = ds.getField(QryBO_TicketUsage.Sel.TicketProductFlags).getLookupItems(LkSN.ProductFlag);
    DOEntitlement ticket = EntitlementUtils.createEntitlement(ds.getString(QryBO_TicketUsage.Sel.TicketEntitlementData));
    DOEntitlement dynamic = EntitlementUtils.createEntitlement(ds.getString(QryBO_TicketUsage.Sel.TicketDynamicEntitlementData));
    BLBO_Entitlement.mergeEntitlement(ticket, dynamic, true, LkSNProductFlag.EntitlementStrictMerge.isLookup(productFlags));
    entitlement = ticket;
  }
}

request.setAttribute("entitlement", entitlement);
request.setAttribute("entitlement-readonly", "true"); 
%>

<v:dialog id="ticketusage-entitlement-dialog" title="@Common.Entitlements" width="600">
  <div id="entitlement-container"><jsp:include page="../entitlement/entitlement_widget.jsp"/></div>

<script>

$(document).ready(function() {
  var dlg = $("#ticketusage-entitlement-dialog");
  
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      dialogButton("@Common.Close", doCloseDialog)
    ]
  });
});
</script>

</v:dialog>