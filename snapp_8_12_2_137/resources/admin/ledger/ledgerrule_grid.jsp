<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_LedgerRule.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>

<%
QueryDef qdef = new QueryDef(QryBO_LedgerRule.class);
// Select
qdef.addSelect(Sel.CommonStatus,
   Sel.LedgerRuleId,     
   Sel.LedgerTriggerType,
   Sel.LedgerRuleFilterListJSON,
   Sel.TriggerEntityType,
   Sel.TriggerEntityId,
   Sel.TriggerEntityCode,
   Sel.TriggerEntityName,
   Sel.LedgerRuleAmount,
   Sel.LedgerRuleAmountType,
   Sel.AutomaticRevert,
   Sel.AffectClearingLimit,
   Sel.RuleDetailsCount,
   Sel.DebitLedgerAccountId,
   Sel.DebitLedgerAccountCode,
   Sel.DebitLedgerAccountName,
   Sel.DebitAccountType,
   Sel.DebitAccountId,
   Sel.DebitAccountName,
   Sel.CreditLedgerAccountId,
   Sel.CreditLedgerAccountCode,
   Sel.CreditLedgerAccountName,
   Sel.CreditAccountType,
   Sel.CreditAccountId,
   Sel.CreditAccountName,
   Sel.UsedTicket,
   Sel.UnusedTicket,
   Sel.ValidOnlineOffline,
   Sel.InvalidOffline,
   Sel.PluginId,
   Sel.SerialNumber,
   Sel.LedgerRuleStatus);

// Filter
int[] ledgerRuleStatusCodes = JvArray.stringToIntArray(LkSNLedgerRuleStatus.Active.getCode()+"", ",");
ledgerRuleStatusCodes = JvArray.add(LkSNLedgerRuleStatus.Inactive.getCode(), ledgerRuleStatusCodes);
qdef.addFilter(Fil.LedgerRuleStatus, ledgerRuleStatusCodes);

String entityId = pageBase.getNullParameter("EntityId");
int entityType = pageBase.getParameter("EntityType") == null ? 0 : JvString.strToIntDef(pageBase.getParameter("EntityType"), 0);

if (entityId != null) {
  if (entityType == LkSNEntityType.LedgerRuleTemplateDate.getCode()) {
    qdef.addFilter(Fil.LedgerRuleTemplateDateId, entityId);  
    qdef.addFilter(Fil.TriggerEntityType, LkSNEntityType.LedgerRuleTemplateDate.getCode());
  }
  else
  {
    qdef.addFilter(Fil.SmartTriggerEntityId, entityId);
    qdef.addFilter(Fil.TriggerEntityType, entityType);
  }
}

//Sort
qdef.addSort(Sel.LedgerTriggerType);
qdef.addSort(Sel.LedgerRuleId);

qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);

request.setAttribute("ds", ds);

boolean readOnly = pageBase.isParameter("ReadOnly", "true");

%>

<script>
function showLedgerRuleDialog(ledgerRuleId, serialNumber) {
  asyncDialogEasy("ledger/ledgerrule_dialog", "id=" + ledgerRuleId + "&SerialNumber=" + serialNumber + "&EntityType=<%=pageBase.getEmptyParameter("EntityType")%>" + "&ReadOnly=" + <%=readOnly%>);
}
</script>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td align="right">#</td>
      <td width="20%">
        <v:itl key="@Ledger.RuleTrigger"/><br/>
        <v:itl key="@Common.Filters"/>
      </td>
      <td width="32%">
        <v:itl key="@Ledger.RuleSource"/><br/>
        <v:itl key="@Account.Location"/>
      </td>
      <td width="32%">
        <v:itl key="@Ledger.RuleTarget"/><br/>
        <v:itl key="@Account.Location"/>
      </td>
      <td align="right" width="16%">
        <v:itl key="@Common.Amount"/><br/>
        <v:itl key="@Ledger.AffectClearingLimit"/>
      </td>
    </tr>
  </thead>
  <tbody>
    <v:grid-row dataset="ds">
      <% LookupItem triggerType = LkSN.LedgerType.getItemByCode(ds.getField(Sel.LedgerTriggerType)); %>
      <% LookupItem amountType = LkSN.LedgerRuleAmountType.getItemByCode(ds.getField(Sel.LedgerRuleAmountType)); %>
      <% LookupItem triggerEntityType = LkSN.EntityType.getItemByCode(ds.getField(Sel.TriggerEntityType)); %>
      <% LookupItem ruleDebit = ds.getField(Sel.DebitAccountType).getInt() > 0 ? LkSN.LedgerRuleAccountType.getItemByCode(ds.getField(Sel.DebitAccountType)) : LkSNLedgerRuleAccountType.Fixed; %>
      <% LookupItem ruleCredit = ds.getField(Sel.CreditAccountType).getInt() > 0 ? LkSN.LedgerRuleAccountType.getItemByCode(ds.getField(Sel.CreditAccountType)) : LkSNLedgerRuleAccountType.Fixed; %> 
      <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="LedgerRuleId" dataset="ds" fieldname="LedgerRuleId"/></td>
      <td align="right">
        <%=ds.getInt(Sel.SerialNumber)%>
      </td>
      <td>
        <a class="list-title" href="javascript:showLedgerRuleDialog('<%=ds.getField(Sel.LedgerRuleId).getHtmlString()%>', '<%=ds.getField(Sel.SerialNumber).getHtmlString()%>')"><%=triggerType.getHtmlDescription(pageBase.getLang())%></a><br/>
        <span class="list-subtitle">
        <% if (!ds.getField(Sel.LedgerRuleFilterListJSON).isNull()) { %>
          <v:itl key="@Common.Configured"/>
        <% } else { %>
          <v:itl key="@Common.None"/>
        <% } %>
        </span>
      </td>
      <td>
        <% if (ds.getInt(Sel.RuleDetailsCount) == 1) { %>
          [<%=ds.getField(Sel.DebitLedgerAccountCode).getHtmlString()%>] <%=ds.getField(Sel.DebitLedgerAccountName).getHtmlString()%><br/>
          <span class="list-subtitle">
            <% if (ruleDebit.isLookup(LkSNLedgerRuleAccountType.Fixed)) { %>
              <a class="entity-tooltip" data-EntityType="<%=ds.getField(Sel.DebitAccountType).getInt()%>" data-EntityId="<%=ds.getField(Sel.DebitAccountId).getHtmlString()%>" href="<v:config key="site_url"/>/admin?page=account&id=<%=ds.getField(Sel.DebitAccountId).getHtmlString()%>"><%=ds.getField(Sel.DebitAccountName).getHtmlString()%></a>
            <% } else { %>
              <%=ruleDebit.getHtmlDescription(pageBase.getLang())%>
            <% } %>
          </span>
        <% } else if (ds.getInt(Sel.RuleDetailsCount) == 0) { %>
            <% if (ds.getBoolean(Sel.AutomaticRevert)) { %>
                   <v:itl key="@Ledger.AutomaticRevert"/>
                   <br/>
                   <span class="list-subtitle"><v:itl key="@Ledger.AutomaticRevert"/></span>
            <% } else { %>
                   <v:itl key="@Plugin.Plugin"/>
                   <br/>
                   <span class="list-subtitle"><v:itl key="@Plugin.Plugin"/></span>
            <% } %>  
        <% } else { %>
          <v:itl key="@Common.MultipleValues"/>
          <br/>
          <span class="list-subtitle"><v:itl key="@Common.MultipleValues"/></span>
        <% } %>
      </td>
      <td>
        <% if (ds.getField(Sel.RuleDetailsCount).getInt() == 1) { %>
          [<%=ds.getField(Sel.CreditLedgerAccountCode).getHtmlString()%>] <%=ds.getField(Sel.CreditLedgerAccountName).getHtmlString()%><br/>
          <span class="list-subtitle">
            <% if (ruleCredit.isLookup(LkSNLedgerRuleAccountType.Fixed)) { %>
              <a class="entity-tooltip" data-EntityType="<%=ds.getField(Sel.CreditAccountType).getInt()%>" data-EntityId="<%=ds.getField(Sel.CreditAccountId).getHtmlString()%>" href="<v:config key="site_url"/>/admin?page=account&id=<%=ds.getField(Sel.CreditAccountId).getHtmlString()%>"><%=ds.getField(Sel.CreditAccountName).getHtmlString()%></a>
            <% } else { %>
              <%=ruleCredit.getHtmlDescription(pageBase.getLang())%>
            <% } %>
          </span>
        <% } else if (ds.getField(Sel.RuleDetailsCount).getInt() == 0) { %>
            <% if (ds.getBoolean(Sel.AutomaticRevert)) { %>
                   <v:itl key="@Ledger.AutomaticRevert"/>
                   <br/>
                   <span class="list-subtitle"><v:itl key="@Ledger.AutomaticRevert"/></span>
            <% } else { %>
                   <v:itl key="@Plugin.Plugin"/>
                   <br/>
                   <span class="list-subtitle"><v:itl key="@Plugin.Plugin"/></span>
            <% } %>  
        <% } else { %>
          <v:itl key="@Common.MultipleValues"/>
          <br/>
          <span class="list-subtitle"><v:itl key="@Common.MultipleValues"/></span>
        <% } %>
      </td>
      <td align="right">
        <% if (triggerType.isLookup(LkSNLedgerType.Amortization)) { %>
        &mdash;
        <% } else { %>
          <% long value = ds.getField(Sel.LedgerRuleAmount).getMoney(); %>
          <% if (amountType.isLookup(LkSNLedgerRuleAmountType.Absolute)) { %>
            <%=pageBase.formatCurrHtml(value)%>
          <% } else { %>
            <% if (!triggerEntityType.isLookup(LkSNEntityType.PaymentMethod, LkSNEntityType.Tax)) { %>
              <% if (amountType.isLookup(LkSNLedgerRuleAmountType.PercGrossInclComm, LkSNLedgerRuleAmountType.PercGrossExclComm)) { %>
                <v:itl key="@Common.Gross"/>
              <% } else if (amountType.isLookup(LkSNLedgerRuleAmountType.PercNetInclComm, LkSNLedgerRuleAmountType.PercNetExclComm)) { %>
                <v:itl key="@Common.Net"/>
              <% } else if (amountType.isLookup(LkSNLedgerRuleAmountType.PercTax)) { %>
                <v:itl key="@Product.Taxes"/>
              <% } else if (amountType.isLookup(LkSNLedgerRuleAmountType.PercComm)) { %>
                <v:itl key="@Commission.Commissions"/>
              <% } else if (amountType.isLookup(LkSNLedgerRuleAmountType.PercCommTax)) { %>
                <v:itl key="@Commission.CommissionTaxes"/>                
              <% } else if (amountType.isLookup(LkSNLedgerRuleAmountType.PercClearingUsed)) { %>
                <v:itl key="@Ledger.ClearingUsed"/>
              <% } else if (amountType.isLookup(LkSNLedgerRuleAmountType.PercClearingLeft)) { %>
                <v:itl key="@Ledger.ClearingLeft"/>
              <% } else if (amountType.isLookup(LkSNLedgerRuleAmountType.PercClearingOver)) { %>
                <v:itl key="@Ledger.ClearingOver"/>
              <% } else if (amountType.isLookup(LkSNLedgerRuleAmountType.PercClearingUnder)) { %>
                <v:itl key="@Ledger.ClearingUnder"/>
    <!--           Removed for now, not found any use yet   -->
    <%--           <% } else if (amountType.isLookup(LkSNLedgerRuleAmountType.PercTargetClearingUsed)) { %> --%>
    <%--             <v:itl key="@Ledger.ClearingTargetUsed"/> --%>
              <% } else if (amountType.isLookup(LkSNLedgerRuleAmountType.VPT)) { %>
                <v:itl key="@Product.VPT"/>  
              <% } %>
              
            <% } %>
            <% if (!amountType.isLookup(LkSNLedgerRuleAmountType.VPT)) { %>
              <%=JvString.escapeHtml(pageBase.formatCurr(value) + "%")%>
            <% } %>
          <% } %>
        <% } %>
        <br>
        <span class="list-subtitle">
          <% if (ds.getField(Sel.AffectClearingLimit).getBoolean()) { %> 
            <v:itl key="@Common.Yes"/> 
          <% } else { %> 
            <v:itl key="@Common.No"/> 
          <% } %>
        </span>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>
    