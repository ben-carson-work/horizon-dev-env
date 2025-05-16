<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageBox" scope="request"/>
<jsp:useBean id="box" class="com.vgs.snapp.dataobject.DOBox" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
 
<% boolean canAudit = LkSNRightBoxMaintenance.Audit.check(rights.BoxMaintenance.getGreater()); %>
 
<v:page-form id="box-form">
<v:input-text type="hidden" field="AuditDeltaAmount"/>

<style>
.warn-color {
  color: var(--base-orange-color);
}
</style>

<div class="tab-toolbar">
  <snp:notes-btn entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.Box%>"/>
  
  <% if (box.BoxStatus.isLookup(LkSNBoxStatus.ToBeAudited)) { %>
  <% String hRef = "javascript:asyncDialogEasy('box/box_audit_dialog', 'boxId=" + box.BoxId.getHtmlString() + "')"; %>
    <v:button caption="@Box.Audit" fa="check" href="<%=hRef%>" enabled="<%=canAudit%>"/>
  <% } %>
</div>
 
<div class="tab-content">
  <v:last-error/>
  <div class="profile-pic-div">
    <v:widget caption="@Common.Recap">
      <v:widget-block>
        <v:itl key="@Common.FiscalDate"/>
        <% box.FBoxDate.setDisplayFormat(pageBase.getShortDateFormat()); %>
        <span class="recap-value"><%=box.FBoxDate.getHtmlString()%></span>
        <br/>
        <v:itl key="@Common.Status"/>
        <span class="recap-value"><%=box.BoxStatus.getLkValue().getHtmlDescription(pageBase.getLang())%></span>
        <br/>
        <% String cashWarnClass = (box.CashLimitWarnAmount.isNull() || (box.CashContentAmount.getMoney() < box.CashLimitWarnAmount.getMoney())) ? "" : "warn-color"; %>
        <v:itl key="@Payment.Cash"/>
        <span class="recap-value <%=cashWarnClass%>"><%=pageBase.formatCurrHtml(box.CashContentAmount)%></span>
      </v:widget-block>
      
      <% if (!box.BoxWarnList.isEmpty()) { %>
        <v:widget-block>
          <% for (DOBox.DOBoxWarn warn : box.BoxWarnList) { %>
            <div class="recap-value-item">
              <span class="recap-value" style="color:var(--base-red-color)"><%=warn.BoxWarnDesc.getHtmlString()%></span>
            </div>
          <% } %>
        </v:widget-block>
      <% } %>
      
      <v:widget-block>
        <v:itl key="@Account.Location"/>
        <span class="recap-value"><snp:entity-link entityId="<%=box.LocationAccountId%>" entityType="<%=LkSNEntityType.Location%>"><%=box.LocationAccountName.getHtmlString()%></snp:entity-link></span>
        <br/>
        <v:itl key="@Account.OpArea"/>
        <span class="recap-value"><snp:entity-link entityId="<%=box.OpAreaAccountId%>" entityType="<%=LkSNEntityType.OperatingArea%>"><%=box.OpAreaAccountName.getHtmlString()%></snp:entity-link></span>
        <br/>
        <v:itl key="@Common.User"/>
        <span class="recap-value"><snp:entity-link entityId="<%=box.UserAccountId%>" entityType="<%=LkSNEntityType.Person%>"><%=box.UserAccountName.getHtmlString()%></snp:entity-link></span>
        <br/>
        <v:itl key="@Box.LastWorkstation"/>
        <span class="recap-value">
          <% if (box.LastWorkstationName.isNull()) { %>
            <v:itl key="@Common.Unknown"/>
          <% } else { %>
            <snp:entity-link entityId="<%=box.LastWorkstationId%>" entityType="<%=LkSNEntityType.Workstation%>"><%=box.LastWorkstationName.getHtmlString()%></snp:entity-link>
          <% } %>
        </span>
      </v:widget-block>
        <% if (box.OverShortFlag.getBoolean()) { %>
        <v:widget-block>
          <v:itl key="@Box.OverShort"/>
          <span class="recap-value" style="<%=(box.OverShortFlag.getBoolean()) ? "color:red" : "" %>"><%=pageBase.formatCurrHtml(box.OverShort)%></span>
        </v:widget-block>
      <% } %>
    </v:widget>
  </div>
  <div class="profile-cont-div">
    <v:grid>
      <thead>
        <tr>
          <td width="20%">
            <v:itl key="@Common.DateTime"/><br/>
            <v:itl key="@Common.Type"/>
          </td>
          <td width="50%">
            <v:itl key="@Common.User"/><br/>
            <v:itl key="@Account.Location"/> &raquo; <v:itl key="@Account.OpArea"/> &raquo; <v:itl key="@Common.Workstation"/>
          </td>
          <td width="30%" align="right">
            <v:itl key="@Common.Amount"/><br/>
            <v:itl key="@Box.BagNumber"/>
          </td>
        </tr>
      </thead>
    
      <tbody>
      <% if (box.DepositList.isEmpty()) { %>
        <tr class="no-items"><td colspan="100%"><v:itl key="@Common.NoItems"/></td></tr>
      <% } %>
      
      <% for (DOBox.DOBoxDeposit deposit : box.DepositList.getItems()) { %>
        <tr class="grid-row">
          <td>
            <a class="list-title" href="javascript:asyncDialogEasy('box/box_deposit_details_dialog', 'boxDepositId=<%=deposit.BoxDepositId.getHtmlString()%>')"><snp:datetime timestamp="<%=deposit.DepositDateTime%>" format="shortdatetime" timezone="local" showMillisHint="true"/></a><br/>
            <span class="list-subtitle"><%=deposit.BoxDepositType.getLkValue().getHtmlDescription(pageBase.getLang())%></span>
          </td>
          <td>
            <a href="<v:config key="site_url"/>/admin?page=account&id=<%=deposit.UserAccountId.getEmptyString()%>"><%=deposit.UserAccountName.getHtmlString()%></a>
            <% if (!deposit.SupAccountId.isNull()) { %>
              <span class="list-subtitle">&nbsp;(<v:itl key="@Common.Supervisor"/>:
                <a href="<v:config key="site_url"/>/admin?page=account&id=<%=deposit.SupAccountId.getEmptyString()%>"><%=deposit.SupAccountName.getHtmlString()%></a>)
              </span>
            <% } %>
            <br/>
            <a href="<v:config key="site_url"/>/admin?page=account&id=<%=deposit.LocationAccountId.getEmptyString()%>"><%=deposit.LocationAccountName.getHtmlString()%></a> &raquo;
            <a href="<v:config key="site_url"/>/admin?page=account&id=<%=deposit.OperatingAreaAccountId.getEmptyString()%>"><%=deposit.OperatingAreaAccountName.getHtmlString()%></a> &raquo;
            <a href="<v:config key="site_url"/>/admin?page=workstation&id=<%=deposit.WorkstationId.getEmptyString()%>"><%=deposit.WorkstationName.getHtmlString()%></a>
          </td>
          <td align="right">
            <% long amount = deposit.DepositAmount.getMoney(); %>
            <span style="<%=(amount<0) ? "color:red" : "" %>"><%=(amount==0) ? "&ndash;" : pageBase.formatCurrHtml(amount)%></span><br/>&nbsp;
            <span class="list-subtitle"><%=deposit.BagNumber.getHtmlString()%></span>
          </td>
        </tr>
      <% } %>
      </tbody>
    </v:grid>
  </div>
</div>

<div id="audit-dialog" class="v-hidden" title="<v:itl key="@Box.Audit"/>">
  <input type="text" name="Amount" style="width:95%" placeholder="<v:itl key="@Box.SpecifyDeltaAmount"/>"/>
</div>

<script>

function doAuditOk() {
  $("#AuditDeltaAmount").val($("#audit-dialog [name='Amount']").val());
  sendPost("#box-form", "audit");
  $("#audit-dialog").dialog("close");
}

$("#audit-dialog [name='Amount']").keypress(function() {
  if (event.keyCode == KEY_ENTER)
    doAuditOk();
});

function showAuditDialog() {
  $("#audit-dialog [name='Amount']").val("");
  $("#audit-dialog").dialog({
    modal: true,
    width: 250,
    height: 140,
    buttons: {
      <v:itl key="@Common.Ok" encode="JS"/>: doAuditOk,
      <v:itl key="@Common.Cancel" encode="JS"/>: function() {
        $("#audit-dialog").dialog("close");
      }
    }
  });
}

$(document).on("OnEntityChange", function(event, params) {
  window.location.reload();
});

</script>

</v:page-form>
