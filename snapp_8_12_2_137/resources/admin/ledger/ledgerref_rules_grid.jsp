<%@page import="com.vgs.snapp.dataobject.ledger.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.api.ledger.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<% 
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");

boolean readOnly = pageBase.isParameter("ReadOnly", "true");
APIDef_Ledger_SearchRef.DOResponse ansDO = pageBase.getBL(API_Ledger_SearchRef.class).execute(reqDO -> {
  reqDO.SearchRecap.PagePos.setInt(pageBase.getQP());
  reqDO.SearchRecap.RecordPerPage.setInt(QueryDef.recordPerPageDefault);
  
  String groupEntityId = pageBase.getNullParameter("GroupEntityId");
  if (groupEntityId != null)
    reqDO.Filters.GroupEntityId.setString(groupEntityId);
  
  String ledgerSerial = pageBase.getNullParameter("LedgerSerial");
  if (ledgerSerial != null)
    reqDO.Filters.LedgerSerial.setString(ledgerSerial);
});
boolean showLegend = ansDO.LedgerRefList.contains(ref -> ref.AffectClearingLimit.getBoolean());

%>
<style>

.ledger-ref-footer td {
  border-top: 1px #aaaaaa solid;
}

</style>
<% if (showLegend) { %>
   <v:alert-box type="info">
   (*) <v:itl key="@Ledger.AffectClearingLimit"/>
   </v:alert-box>
<% } %>

<v:grid search="<%=ansDO%>" entityType="<%=LkSNEntityType.LedgerRule%>">
  <thead>
    <tr>
      <td align="right">#</td>
      <td width="60%">
        <v:itl key="@Common.Entity"/>
      </td>
      <td align="right" width="40%">
        <v:itl key="@Common.Amount"/>
      </td>
    </tr>
  </thead>
  <tbody>
  <% for (DOLedgerRefRef ref : ansDO.LedgerRefList) { %>
    <tr class="grid-row">
      <td align="right">
        <% if (ref.LedgerRuleSerial.getHtmlString() != null && !ref.LedgerRuleSerial.getHtmlString().isEmpty()) { %>
          <a class="list-title" href="javascript:showLedgerRuleDialog('<%=ref.LedgerRuleId.getHtmlString()%>', '<%=ref.LedgerRuleSerial.getHtmlString()%>', '<%=ref.GroupEntityType.getHtmlString()%>')"><%=ref.LedgerRuleSerial.getHtmlString()%></a>
        <% } %>
      </td>
      <td nowrap>
      <%if (ref.EntityType.isLookup(LkSNEntityType.SaleItemDetail)) {%>
          <%=ref.EntityDesc.getHtmlString()%>
      <%} else {%>
	      <snp:entity-link entityId="<%=ref.EntityId%>" entityType="<%=ref.EntityType.getLkValue()%>" openOnNewTab="true">
	        <%=ref.EntityDesc.getHtmlString()%>
	      </snp:entity-link>
      <%}%>
      </td>
      <td nowrap align="right">
        <%=(ref.LedgerRefAmount.getMoney() == 0) ? "" : pageBase.formatCurrHtml(ref.LedgerRefAmount.getMoney())%><%=ref.AffectClearingLimit.getBoolean() ? " *" : ""%>
      </td>      
    </tr>
  <% } %>
  
  </tbody>
  
</v:grid>

<script> 
	function showLedgerRuleDialog(ledgerRuleId, serialNumber, groupEntityType) {
	  asyncDialogEasy("ledger/ledgerrule_dialog", "id=" + ledgerRuleId + "&SerialNumber=" + serialNumber + "&EntityType=" + groupEntityType + "&ReadOnly=" + <%=readOnly%>);
	}
</script>

