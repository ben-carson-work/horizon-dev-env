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

APIDef_Ledger_Search.DOResponse ansDO = pageBase.getBL(API_Ledger_Search.class).execute(reqDO -> {
  reqDO.SearchRecap.PagePos.setInt(pageBase.getQP());
  reqDO.SearchRecap.RecordPerPage.setInt(QueryDef.recordPerPageDefault);
  
  reqDO.Filters.NonZeroAmountOnly.setBoolean(true);

  String groupEntityCode = pageBase.getNullParameter("GroupEntityCode");
  reqDO.Filters.GroupEntityCode.setString(groupEntityCode);

  if ((groupEntityCode == null) || pageBase.isParameter("ApplyAllCondition", "true")) {
    reqDO.Filters.FromFiscalDate.setXMLValue(pageBase.getNullParameter("FromFiscalDate"));
    reqDO.Filters.ToFiscalDate.setXMLValue(pageBase.getNullParameter("ToFiscalDate"));
    reqDO.Filters.LedgerAccountId.setString(pageBase.getNullParameter("LedgerAccountId"));
    reqDO.Filters.RefEntityId.setString(pageBase.getNullParameter("RefEntityId"));
    reqDO.Filters.LocationId.setString(pageBase.getNullParameter("LocationAccountId"));
    reqDO.Filters.TriggerTypes.setArray(JvArray.stringToIntArray(pageBase.getNullParameter("TriggerType"), ","));
    reqDO.Filters.AffectClearingLimit.setBoolean(pageBase.isParameter("AffectClearingLimit", "true"));
    
    String groupEntityIDs = JvString.coalesce(pageBase.getNullParameter("GroupEntityIDs"), pageBase.getNullParameter("GroupEntityId"));
    if (groupEntityIDs != null)
      reqDO.Filters.GroupEntityId.setArray(JvArray.stringToArray(groupEntityIDs, ","));
  }
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
      <td width="40%" nowrap>
        <v:itl key="@Common.DateTime"/>&nbsp;&nbsp;&mdash;&nbsp;&nbsp;<v:itl key="@Common.FiscalDate"/>&nbsp;&nbsp;&mdash;&nbsp;&nbsp;<v:itl key="@Ledger.Referral"/><br/>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<v:itl key="@Ledger.LedgerAccount"/>
      </td>
      <td width="40%">
        &nbsp;<br/>
        <v:itl key="@Account.Account"/>
      </td>
      <td width="20%">
        &nbsp;<br/>
        <v:itl key="@Ledger.TriggerType"/>
      </td>
      <td align="right">
        &nbsp;<br/>
        <v:itl key="@Ticket.Tickets"/>
      </td>
      <td align="right">
        &nbsp;<br/>
        <v:itl key="@Ledger.Allocated"/>
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
  <% for (DOLedgerRef ledger : ansDO.LedgerList) { %>
    <% if (!ledger.GroupEntityId.isSameString(lastGroupId)) { %>
      <% lastGroupId = ledger.GroupEntityId.getString(); %>
      <tr class="group" data-entitytype="" data-entityid="">
        <td colspan="100%">
          <snp:datetime timestamp="<%=ledger.LedgerDateTime.getDateTime()%>" format="shortdatetime" timezone="local"/>
          &nbsp;&nbsp;&mdash;&nbsp;&nbsp;
          <%=ledger.LedgerFiscalDate.formatHtml(pageBase.getShortDateFormat())%>
          &nbsp;&nbsp;&mdash;&nbsp;&nbsp;  
          
          <% if (ledger.GroupEntityType.isLookup(LkSNEntityType.Portfolio)) { %>
            <v:itl key="@Common.WalletExpired"/> &mdash;
          <% } %>
          
          <% if (!ledger.LinkEntityType.isNull()) { %>
            <snp:entity-link entityId="<%=ledger.LinkEntityId%>" entityType="<%=ledger.LinkEntityType%>">
              <%=ledger.LinkEntityDesc.getHtmlString()%>
            </snp:entity-link>
          <% } %>

          <% if (!ledger.LedgerManualId.isNull()) { %>
            &nbsp;&nbsp;&mdash;&nbsp;&nbsp;

            <a href="javascript:showManualLedgerDetails('<%=ledger.LedgerManualId.getString()%>')" class="v-tooltip"><v:itl key="@Ledger.ManualEntry"/></a>
            &nbsp;&nbsp;&mdash;&nbsp;&nbsp; 

            <snp:entity-link entityId="<%=ledger.ManualUserAccountId%>" entityType="<%=LkSNEntityType.Person%>">
              <%=ledger.ManualUserAccountName.getHtmlString()%>
            </snp:entity-link>
            
            <% if (ledger.ManualNotes.getNullString(true) != null) { %>
              &nbsp;&nbsp;&mdash;&nbsp;&nbsp;
              <%=ledger.ManualNotes.getHtmlString()%>
            <% } %>
          <% } %>
          &nbsp;&nbsp;&mdash;&nbsp;&nbsp; 
          <i class="summary-icon fa fa-layer-group" title="<v:itl key="@Ledger.ShowSummarizedLedger"/>" onclick="showSummaryLedger('<%=lastGroupId%>', <%=ledger.GroupEntityType.getInt()%>)"></i>
        </td>
      </tr>
    <% } %>
    <tr class="grid-row">
      <td> 
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        [<%=ledger.LedgerAccountCode.getHtmlString()%>] <%=ledger.LedgerAccountName.getHtmlString()%>
      </td>
      <td>
        <% if (ledger.AccountId.isNull()) { %>
          <span class="list-subtitle"><v:itl key="@Common.None"/></span>
        <% } else { %>
          <a id="account-link" href="<v:config key="site_url"/>/admin?page=account&id=<%=ledger.AccountId.getHtmlString()%>" class="entity-tooltip" data-EntityType="<%=ledger.AccountEntityType.getHtmlString()%>" data-EntityId="<%=ledger.AccountId.getHtmlString()%>"><%=ledger.AccountName.getHtmlString()%></a>
        <% } %>
      </td>
      <td>
        <span class="list-subtitle"><%=ledger.LedgerType.getHtmlLookupDesc(pageBase.getLang())%></span>
      </td>
      <td nowrap align="right">
        <%=ledger.TicketCount.getHtmlString()%>
      </td>
      <td align="right" style="<%=(ledger.LedgerAmount.getMoney() < 0) ? "color:#b00000" : ""%>">
        <% if (!ledger.AllocatedAmount.isNull()) { %>
          <%=pageBase.formatCurrHtml(ledger.AllocatedAmount)%>
        <% } %>
      </td>
      <td nowrap align="right">
        <% if (ledger.LedgerAmount.getMoney() < 0) { %>
          <%=pageBase.formatCurrHtml(Math.abs(ledger.LedgerAmount.getMoney()))%>
        <% } %>
      </td>
      <td nowrap align="right">
        <% if (ledger.LedgerAmount.getMoney() > 0) { %>
          <a href="javascript:showLedgerRef('<%=ledger.LinkEntityDesc.getHtmlString()%>', '<%=ledger.GroupEntityId.getHtmlString()%>', '<%=ledger.LedgerSerial.getHtmlString()%>')">
            <%=pageBase.formatCurrHtml(Math.abs(ledger.LedgerAmount.getMoney()))%>
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
  
  function showLedgerRef(title, groupEntityId, legderSerial) {
    asyncDialogEasy("ledger/ledgerref_rules_dialog", "Title=" + title + "&GroupEntityId=" + groupEntityId + "&LedgerSerial=" + legderSerial);
  }
  
  function showManualLedgerDetails(ledgerManualId) {
    asyncDialogEasy("ledger/ledgermanualentryrecap_dialog", "ledgerManualId=" + ledgerManualId);
  }
</script>

