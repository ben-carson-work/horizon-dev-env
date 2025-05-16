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

  reqDO.Filters.EntityId.setString(pageBase.getNullParameter("RefEntityId"));
});
%>


<style>
.summary-icon {
  cursor: pointer;
}
.summary-icon:hover {
  color: var(--base-blue-color);
}
</style>

<v:grid search="<%=ansDO%>" entityType="<%=LkSNEntityType.LedgerGroup%>">
  <thead>
    <tr>
      <td width="34%" nowrap>
        <v:itl key="@Common.DateTime"/>&nbsp;&nbsp;&mdash;&nbsp;&nbsp;<v:itl key="@Common.FiscalDate"/>&nbsp;&nbsp;&mdash;&nbsp;&nbsp;<v:itl key="@Ledger.Referral"/><br/>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<v:itl key="@Ledger.LedgerAccount"/>
      </td>
      <td width="33%">
        &nbsp;<br/>
        <v:itl key="@Account.Account"/>
      </td>
      <td width="33%">
        &nbsp;<br/>
        <v:itl key="@Ledger.TriggerType"/>
      </td>
      <td align="right">
        &nbsp;<br/>
        <v:itl key="@Ledger.LedgerDebit"/>
      </td>
      <td align="right">
        &nbsp;<br/>
        <v:itl key="@Ledger.LedgerCredit"/>
      </td>
    </tr>
  </thead>
  <tbody>
  <% String lastGroupId = null; %>
  <% for (DOLedgerRefRef ref : ansDO.LedgerRefList) { %>
    <% if (!ref.GroupEntityId.isSameString(lastGroupId)) { %>
      <% lastGroupId = ref.GroupEntityId.getString(); %>
      <tr class="group" data-entitytype="" data-entityid="">
        <td colspan="100%">
          <snp:datetime timestamp="<%=ref.LedgerDateTime%>" format="shortdatetime" timezone="local"/>
          &nbsp;&nbsp;&mdash;&nbsp;&nbsp;
          <%=ref.LedgerFiscalDate.formatHtml(pageBase.getShortDateFormat())%>
          &nbsp;&nbsp;&mdash;&nbsp;&nbsp;  
          <snp:entity-link entityId="<%=ref.LinkEntityId%>" entityType="<%=ref.LinkEntityType.getLkValue()%>">
            <%=ref.LinkEntityDesc.getHtmlString()%>
          </snp:entity-link>
        </td>
      </tr>
    <% } %>
    <tr class="grid-row">
      <td> 
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        [<%=ref.LedgerAccountCode.getHtmlString()%>] <%=ref.LedgerAccountName.getHtmlString()%>
      </td>
      <td>
        <% if (ref.AccountId.isNull()) { %>
          <span class="list-subtitle"><v:itl key="@Common.None"/></span>
        <% } else { %>
          <a id="account-link" href="<v:config key="site_url"/>/admin?page=account&id=<%=ref.AccountId.getHtmlString()%>" class="entity-tooltip" data-EntityType="<%=ref.AccountEntityType.getHtmlString()%>" data-EntityId="<%=ref.AccountId.getHtmlString()%>"><%=ref.AccountName.getHtmlString()%></a>
        <% } %>
      </td>
      <td>
        <span class="list-subtitle"><%=ref.LedgerType.getHtmlLookupDesc(pageBase.getLang())%></span>
      </td>

      <td nowrap align="right">
        <%=(ref.DebitRefAmount.getMoney() == 0) ? "" : pageBase.formatCurrHtml(ref.DebitRefAmount.getMoney())%>
      </td>
      <td nowrap align="right">
        <% if (ref.LedgerRuleSerial.getHtmlString() != null && !ref.LedgerRuleSerial.getHtmlString().isEmpty()) { %>
          <a href="javascript:showLedgerRuleDialog('<%=ref.LedgerRuleId.getHtmlString()%>', '<%=ref.LedgerRuleSerial.getHtmlString()%>', '<%=ref.GroupEntityType.getHtmlString()%>')">
            <%=(ref.CreditRefAmount.getMoney() == 0) ? "" : pageBase.formatCurrHtml(ref.CreditRefAmount.getMoney())%>      
          </a>
        <% } %>
      </td>
    </tr>
  <% } %>
  
  </tbody>
</v:grid>

<script> 
  $(document).ready(function(){
    $("#transaction-link,#account-link").click(function() {
      $("#ledger_dialog").remove();
    })
  });
  
  function showSummaryLedger(groupEntityId, groupEntityType) {
    asyncDialogEasy("ledger/ledger_summary_dialog", "groupEntityid=" + groupEntityId + "&groupEntityType=" + groupEntityType);
  }
  
  function showLedgerRuleDialog(ledgerRuleId, serialNumber, groupEntityType) {
	  asyncDialogEasy("ledger/ledgerrule_dialog", "id=" + ledgerRuleId + "&SerialNumber=" + serialNumber + "&EntityType=" + groupEntityType + "&ReadOnly=" + <%=readOnly%>);
	}
  
  function showManualLedgerDetails(ledgerManualId) {
    asyncDialogEasy("ledger/ledgermanualentryrecap_dialog", "ledgerManualId=" + ledgerManualId);
  }
</script>

