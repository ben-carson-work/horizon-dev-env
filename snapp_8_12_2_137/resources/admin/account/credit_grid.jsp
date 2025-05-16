<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.account.*"%>
<%@page import="com.vgs.snapp.api.account.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_PaymentCredit.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
APIDef_Account_SearchCredit.DORequest reqDO = new APIDef_Account_SearchCredit.DORequest();
reqDO.SearchRecap.PagePos.setInt(pageBase.getQP());
reqDO.SearchRecap.RecordPerPage.setInt(QueryDef.recordPerPageDefault);
reqDO.Filters.Account.AccountId.setString(pageBase.getNullParameter("AccountId"));
reqDO.Filters.SettleTransaction.TransactionId.setString(pageBase.getNullParameter("SettleTransactionId"));
reqDO.Filters.CreditStatus.setString(pageBase.getNullParameter("CreditStatus"));
reqDO.Filters.IssueDateFrom.setString(pageBase.getNullParameter("FromDate"));
reqDO.Filters.IssueDateTo.setString(pageBase.getNullParameter("ToDate"));
reqDO.Filters.DueDateFrom.setString(pageBase.getNullParameter("FromDueDate"));
reqDO.Filters.DueDateTo.setString(pageBase.getNullParameter("ToDueDate"));

APIDef_Account_SearchCredit.DOResponse ansDO = pageBase.getBL(API_Account_SearchCredit.class).execute(reqDO);
%>

<v:grid id="credit-grid" search="<%=ansDO%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true" multipage="true"/></td>
      <td>&nbsp;</td>
      <td width="20%">
        <v:itl key="@Sale.PNR"/><br/>
        <v:itl key="@Common.Status"/>
      </td>
      <td width="20%">
        <v:itl key="@Common.Type"/><br/>
        <v:itl key="@Common.Description"/>
      </td>
      <td width="20%">
        <v:itl key="@Account.Credit.IssueTransaction"/><br/>
        <v:itl key="@Account.Credit.SettleTransaction"/>
      </td>
      <td width="20%">
        <v:itl key="@Invoice.Invoice"/><br/>
        <v:itl key="@Common.History"/>
      </td>
      <td width="20%" align="right" valign="top">
        <div id="amount-total"><v:itl key="@Common.Amount"/></div>
        <div><v:itl key="@Account.Credit.DueDate"/></div>
      </td>
    </tr>
  </thead>
  
  <tbody>
    <v:grid-row search="<%=ansDO%>">
      <% DOCreditRef credit = ansDO.getRecord(); %>
      <td style="<v:common-status-style status="<%=credit.CommonStatus%>"/>"><v:grid-checkbox name="PaymentId" value="<%=credit.PaymentId.getHtmlString()%>"/></td>
      <td><v:grid-icon name="<%=credit.IconName.getString()%>"/></td>
      <td>
        <snp:entity-link entityId="<%=credit.TransactionSaleId%>" entityType="<%=LkSNEntityType.Sale%>"><%=credit.TransactionSaleCode.getHtmlString()%></snp:entity-link>
        <div class="list-subtitle"><%=credit.CreditStatus.getHtmlLookupDesc(pageBase.getLang())%></div>
      </td>
      <td>
        <div><%=credit.PaymentType.getHtmlLookupDesc(pageBase.getLang())%></div>
        <div class="list-subtitle"><%=credit.CreditDesc.getHtmlString()%></div>
      </td>
      <td valign="top">
          <snp:entity-link entityId="<%=credit.TransactionId%>" entityType="<%=LkSNEntityType.Transaction%>"><%=credit.TransactionCode.getHtmlString()%></snp:entity-link>
        <br/>
        <% if (credit.SettleTransactionId.isNull()) { %>
          <v:itl key="@Account.Credit.Unsettled"/>
        <% } else { %>
          <snp:entity-link entityId="<%=credit.SettleTransactionId%>" entityType="<%=LkSNEntityType.Transaction%>"><%=credit.SettleTransactionCode.getHtmlString()%></snp:entity-link>
        <% } %>
      </td>
      <td>
        <snp:entity-link entityId="<%=credit.InvoiceId%>" entityType="<%=LkSNEntityType.Invoice%>"><%=credit.InvoiceCode.getHtmlString()%></snp:entity-link>
        <div class="list-subtitle"><a href="javascript:showCreditHistory('<%=credit.PaymentId.getEmptyString()%>')"><v:itl key="@Common.History"/></a></div>
      </td>
      <td align="right">
        <input type="hidden" id="amount_<%=credit.PaymentId.getEmptyString()%>" value="<%=credit.PaymentAmount.getXMLValue()%>"/>
        <div><%=pageBase.formatCurrHtml(credit.PaymentAmount)%></div>
        <div class="list-subtitle">
          <% if (credit.DueDate.isNull()) { %>
            <v:itl key="@Account.Credit.NoExpiration"/>
          <% } else { %>
            <%=credit.DueDate.formatHtml(pageBase.getShortDateFormat())%>
          <% } %>
        </div>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>

<script>

$(document).on("cbListClicked", function() {
  var total = 0;
  var arr = $("input[name='PaymentId']:checked");
  for (var i=0; i<arr.length; i++) 
    total += parseFloat($("#amount_" + $(arr[i]).val()).val());
  
  if (arr.length == 0)
    $("#amount-total").text(itl("@Common.Amount"));
  else
    $("#amount-total").text(itl("@Common.Selecteds") + " = " + formatCurr(total));
});

function showCreditHistory(paymentId) {
  asyncDialogEasy("log/loglist_dialog", "EntityId=" + paymentId);
}

</script>

