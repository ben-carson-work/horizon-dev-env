<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.bko.page.PageBO_InstallmentContract" scope="request"/>
<jsp:useBean id="contract" class="com.vgs.snapp.dataobject.DOInstallmentContract" scope="request"/>
<jsp:useBean id="contractRights" class="com.vgs.snapp.dataobject.DOInstallmentContractRights" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
String sStatusColor = "";
if (contract.InstallmentContractStatus.isLookup(LkSNInstallmentContractStatus.AutomaticallyBlocked))
  sStatusColor = " color:var(--base-orange-color)";
else if (contract.InstallmentContractStatus.getInt() > LkSNInstallmentContractStatus.GoodStatusLimit)
  sStatusColor = " color:var(--base-red-color)";
%>

<v:tab-toolbar include="<%=contractRights.CRUD.canUpdate()%>">
  <snp:notes-btn entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.InstallmentContract%>"/>

  <v:button id="btn-contract-block" caption="@Common.Block" fa="lock" include="<%=contractRights.ManualBlock.getBoolean()%>"/>
  <v:button id="btn-contract-unblock" caption="@Common.Unblock" fa="unlock" include="<%=contractRights.ManualUnblock.getBoolean()%>"/>

  <v:button id="btn-contract-export" caption="@Installment.SetAsExported" fa="calendar" include="<%=contractRights.ManualExport.getBoolean()%>"/>
  <v:button id="btn-contract-unexport" caption="@Installment.SetAsUnexported" fa="calendar" include="<%=contractRights.ManualUnexport.getBoolean()%>"/>
</v:tab-toolbar>  

<v:tab-content>

<v:profile-recap>
  <v:widget caption="@Common.Recap">
    <v:widget-block>
      <v:recap-item caption="@Common.Code"><%=contract.InstallmentContractCode.getHtmlString()%></v:recap-item>
      <v:recap-item caption="@Common.Status"><%=contract.InstallmentContractStatus.getHtmlLookupDesc(pageBase.getLang())%></v:recap-item>
      <v:recap-item caption="@Common.ArchivedOn" valueColor="red" include="<%=!contract.ArchivedOnDateTime.isNull()%>"><snp:datetime timestamp="<%=contract.ArchivedOnDateTime%>" format="shortdatetime" timezone="local"/></v:recap-item>
      <v:recap-item caption="@Account.Account">
        <snp:entity-link entityId="<%=contract.AccountId%>" entityType="<%=LkSNEntityType.Account_All%>">
          <%=contract.AccountName.getHtmlString()%>
        </snp:entity-link>
      </v:recap-item>
      <v:recap-item caption="@Installment.InstallmentPlan">
        <snp:entity-link entityId="<%=contract.InstallmentPlanId%>" entityType="<%=LkSNEntityType.InstallmentPlan%>">
          <%=contract.InstallmentPlanName.getHtmlString()%>
        </snp:entity-link>
      </v:recap-item>
    </v:widget-block>
    
    <v:widget-block>
      <v:recap-item caption="@Installment.CardType"><%=contract.PaymentTokenCardType.getHtmlString()%></v:recap-item>
      <v:recap-item caption="@Installment.CardNumber"><%=contract.PaymentTokenCardNumber.getHtmlString()%></v:recap-item>
      <v:recap-item caption="@Payment.AuthorizationCode" include="<%=contract.PaymentTokenAuthCode.isNull()%>"><%=contract.PaymentTokenAuthCode.getHtmlString()%></v:recap-item>
    </v:widget-block>
    
    <v:widget-block>
      <v:recap-item caption="@Common.Transaction">
        <snp:entity-link entityId="<%=contract.IssueTransactionId%>" entityType="<%=LkSNEntityType.Transaction%>">
          <%=contract.IssueTransactionCode.getHtmlString()%>
        </snp:entity-link>
      </v:recap-item>
      <v:recap-item caption="@Common.FiscalDate"><%=contract.CreateFiscalDate.formatHtml(pageBase.getShortDateFormat())%></v:recap-item>
      <v:recap-item caption="@Common.DateTime"><snp:datetime timestamp="<%=contract.CreateDateTime%>" format="shortdatetime" timezone="local"/></v:recap-item>
    </v:widget-block>
    
    <v:widget-block>
      <v:recap-item caption="@Installment.TotalAmount"><%=pageBase.formatCurrHtml(contract.TotalAmount)%></v:recap-item>
      <v:recap-item caption="@Installment.DownPayment"><%=pageBase.formatCurrHtml(contract.DownPaymentAmount)%></v:recap-item>
      <v:recap-item caption="@Installment.TotalFinanced"><%=pageBase.formatCurrHtml(contract.FinancedAmount)%></v:recap-item>
    </v:widget-block>
    
    <v:widget-block>
      <% String exportedCaption = contract.ExportedDateTime.isNull() ? "@Installment.NotExported" : "@Installment.Exported"; %>
      <v:recap-item caption="<%=exportedCaption%>"><snp:datetime timestamp="<%=contract.ExportedDateTime%>" format="shortdatetime" timezone="local"/></v:recap-item>
    </v:widget-block>
    
    <v:widget-block include="<%=!contract.BlockDate.isNull()%>">
      <v:recap-item caption="@Installment.BlockDate"><%=contract.BlockDate.formatHtml(pageBase.getShortDateFormat())%></v:recap-item>
    </v:widget-block>

    <v:widget-block include="<%=!contract.ScheduledRenewalDate.isNull()%>">
      <v:recap-item caption="@Installment.ScheduledRenewalDate"><%=contract.ScheduledRenewalDate.formatHtml(pageBase.getShortDateFormat())%></v:recap-item>
      <v:recap-item caption="@Installment.RenewToPlan">
        <snp:entity-link entityId="<%=contract.RenewToInstallmentPlanId%>" entityType="<%=LkSNEntityType.InstallmentPlan%>">
          <%=contract.RenewToInstallmentPlanName.getHtmlString()%>
        </snp:entity-link>
      </v:recap-item>
    </v:widget-block>
  </v:widget>
</v:profile-recap>

<v:profile-main>
  <v:grid>
    <thead>
      <v:grid-title caption="@Common.Items"/>
      <tr>
        <td>&nbsp;</td>
        <td width="40%">
          <v:itl key="@Product.ProductType"/> 
        </td>
        <td width="30%">
          <v:itl key="@Common.Options"/>
        </td>
        <td width="10%" align="right">
          <v:itl key="@Reservation.UnitAmount"/><br/>
          <v:itl key="@Reservation.UnitTax"/>
        </td>
        <td width="10%" align="right">
          <v:itl key="@Common.Quantity"/>
        </td>
        <td width="10%" align="right">
          <v:itl key="@Reservation.TotalAmount"/><br/>
          <v:itl key="@Reservation.TotalTax"/>
        </td>
      </tr>
    </thead>
    <tbody>
      <% for (DOInstallmentItem item : contract.InstallmentItemList) { %>
      <tr class="grid-row">
        <td><v:grid-icon name="<%=item.IconName.getString()%>" repositoryId="<%=item.ProductProfilePictureId.getString()%>"/></td>
        <td>
          <snp:entity-link entityId="<%=item.ProductId%>" entityType="<%=LkSNEntityType.ProductType%>">
            <%=item.ProductName.getHtmlString()%>
          </snp:entity-link>
        </td>
        <td>
          <% if (item.OptionsDesc.getEmptyString().length() > 0) { %>
            <%=item.OptionsDesc.getHtmlString()%>
          <% } else { %>
            &mdash; 
          <% } %>
        </td>
        <td align="right">
          <%=pageBase.formatCurrHtml(item.UnitAmount)%><br/>
          <span class="list-subtitle"><%=pageBase.formatCurrHtml(item.UnitTax)%></span>
        </td>
        <td align="right">
          <%=item.Quantity.getInt()%>
        </td>
        <td align="right">
          <%=pageBase.formatCurrHtml(item.UnitAmount.getMoney() * item.Quantity.getInt())%><br/>
          <span class="list-subtitle"><%=pageBase.formatCurrHtml(item.UnitTax.getMoney() * item.Quantity.getInt())%></span>
        </td>
      </tr>
      <% } %>
    </tbody>
  </v:grid>
</v:profile-main>

<v:profile-main>
  <v:grid>
    <thead>
      <v:grid-title caption="@Installment.Installments"/>
      <tr>
        <td align="right">#</td>
        <td></td>
        <td width="20%">
          <v:itl key="@Installment.ScheduledDate"/><br/>
          <v:itl key="@Installment.NextAttemptDate"/>
        </td>
        <td width="20%">
          <v:itl key="@Installment.Settlement"/>
        </td>
        <td width="60%" align="right">
          <v:itl key="@Common.Amount"/>
        </td>
      </tr>
    </thead>
    <tbody>
      <% for (DOInstallmentContract.DOInstallment detail : contract.InstallmentList) { %>
      <tr class="grid-row">
        <td align="right"><%=detail.InstallmentNumber.getHtmlString()%></td>
        <td><v:grid-icon name="<%=detail.IconName.getString()%>"/></td>
        <td>
          <%= contractRights.ShowInstallmentScheduleDates.getBoolean() ? detail.ScheduledDate.formatHtml(pageBase.getShortDateFormat()) : JvString.MDASH %><br/>
          <span class="list-subtitle">
          <% if (detail.Active.getBoolean()) { %>
            <%=contractRights.ShowInstallmentScheduleDates.getBoolean() ? detail.NextAttemptDate.formatHtml(pageBase.getShortDateFormat()) : JvString.MDASH %>
          <% } else { %>
            <v:itl key="@Common.Inactive"/>
          <% } %>
          </span>
        </td>
        <td>
        <% if (detail.SettleTransactionId.isNull()) { %>
          <% int failedCount = detail.AttemptCount.getInt(); %>
          <% if (detail.InstallmentStatus.isLookup(LkSNInstallmentStatus.WrittenOff)) { %>
            <%=detail.InstallmentStatus.getHtmlLookupDesc(pageBase.getLang())%>
          <% } else if (failedCount == 0) { %>
            &mdash;
          <% } else { %>
            <v:itl key="@Installment.FailedAttempts" param1="<%=String.valueOf(failedCount)%>"/>
          <% } %>
        <% } else { %>
          <snp:entity-link entityId="<%=detail.SettleTransactionId%>" entityType="<%=LkSNEntityType.Transaction%>">
            <%=detail.SettleTransactionCode.getHtmlString() %>
          </snp:entity-link>
          <br/>
          <span class="list-subtitle"><snp:datetime timestamp="<%=detail.SettleTransactionDateTime%>" format="shortdatetime" timezone="local"/></span>
        <% } %>
        </td>
        <td align="right">
          <%=pageBase.formatCurrHtml(detail.InstallmentAmount)%>
        </td>
      </tr>
      <% } %>
    </tbody>
  </v:grid>
</v:profile-main>

</v:tab-content>

<script>
$(document).ready(function() {
  $("#btn-contract-block").click(_manualBlock);
  $("#btn-contract-unblock").click(_unblock);
  $("#menu-contract-auto-block").click(_autoBlock);
  $("#menu-contract-auto-unblock").click(_unblock);
  $("#btn-contract-export").click(_manualExport);
  $("#btn-contract-unexport").click(_manualUnexport);

  function _manualBlock() {
    _changeInstallmentContractStatus(<%=LkSNInstallmentContractStatus.ManuallyBlocked.getCode()%>);
  }

  function _autoBlock() {
    _changeInstallmentContractStatus(<%=LkSNInstallmentContractStatus.AutomaticallyBlocked.getCode()%>);
  }

  function _unblock() {
    _changeInstallmentContractStatus(<%=LkSNInstallmentContractStatus.Active.getCode()%>);
  }

  function _manualUnblock() {
    _changeInstallmentContractStatus(<%=LkSNInstallmentContractStatus.Active.getCode()%>);
  }

  function _manualExport() {
    asyncDialogEasy("installment/contract_export_dialog", "contractid=" + <%=contract.InstallmentContractId.getJsString()%>);
  }

  function _manualUnexport() {
    confirmDialog(null, function() {
      snpAPI.cmd("Installment", "SetManuallyUnexported", {
        LocateInstallmentContractList: [{InstallmentContractId:<%=contract.InstallmentContractId.getJsString()%>}]
      }).then(ansDO => window.location.reload());
    });
  }

  function _changeInstallmentContractStatus(contractStatus) {
    confirmDialog(null, function() {
      snpAPI.cmd("Installment", "ChangeContractStatus", {
        InstallmentContractId: <%=contract.InstallmentContractId.getJsString()%>,
        InstallmentContractStatus: contractStatus
      }).then(ansDO => window.location.reload());
    });
  }
});
</script>