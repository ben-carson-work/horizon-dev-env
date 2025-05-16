<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@page import="com.vgs.snapp.lookup.LkSN"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_PaymentCredit.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_PaymentCredit.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.PaymentId);
qdef.addSelect(Sel.TransactionSaleId);
qdef.addSelect(Sel.TransactionSaleCode);
qdef.addSelect(Sel.TransactionDateTime);
qdef.addSelect(Sel.CreditStatus);
qdef.addSelect(Sel.PaymentType);
qdef.addSelect(Sel.TransactionId);
qdef.addSelect(Sel.TransactionDesc);
qdef.addSelect(Sel.SettleTransactionId);
qdef.addSelect(Sel.SettleTransactionDesc);
qdef.addSelect(Sel.DueDate);
qdef.addSelect(Sel.PaymentAmount);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Where
qdef.addFilter(Fil.AccountId, pageBase.getSession().getOrgAccountId());

if (pageBase.getNullParameter("SettleTransactionId") != null)
  qdef.addFilter(Fil.SettleTransactionId, pageBase.getNullParameter("SettleTransactionId"));

if (pageBase.getNullParameter("CreditStatus") != null)
  qdef.addFilter(Fil.CreditStatus, JvArray.stringToIntArray(pageBase.getNullParameter("CreditStatus"), ","));

if (pageBase.getNullParameter("FromDate") != null)
  qdef.addFilter(Fil.IssueDateFrom, pageBase.getNullParameter("FromDate"));

if (pageBase.getNullParameter("ToDate") != null)
  qdef.addFilter(Fil.IssueDateTo, pageBase.getNullParameter("ToDate"));

if (pageBase.getNullParameter("FromDueDate") != null)
  qdef.addFilter(Fil.DueDateFrom, pageBase.getNullParameter("FromDueDate"));

if (pageBase.getNullParameter("ToDueDate") != null)
  qdef.addFilter(Fil.DueDateTo, pageBase.getNullParameter("ToDueDate"));

if (pageBase.getNullParameter("SaleCode") != null)
  qdef.addFilter(Fil.SaleCode, pageBase.getNullParameter("SaleCode"));

// Sort
qdef.addSort(Sel.DueDate);
qdef.addSort(Sel.CreateDateTime);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid id="credit-grid" dataset="<%=ds%>" qdef="<%=qdef%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
      <td width="25%">
        <v:itl key="@Common.Sale"/><br/>
        <v:itl key="@Common.Transaction"/>
      </td>
      <td width="25%">
        <v:itl key="@Common.Type"/><br/>
        <v:itl key="@Common.Description"/>
      </td>
      <td width="25%">
        <v:itl key="@Account.Credit.DueDate"/><br/>
        <v:itl key="@Common.Status"/>
      </td>
      <td width="25%" align="right" valign="top">
        <div><v:itl key="@Common.Amount"/></div>
        <div id="amount-total" style="font-weight:bold"></div>
      </td>
    </tr>
  </thead>
  
  <tbody>
    <v:grid-row dataset="ds">
      <% LookupItem creditStatus = LkSN.CreditStatus.getItemByCode(ds.getField(Sel.CreditStatus)); %>
      <% LookupItem paymentType = LkSN.PaymentType.getItemByCode(ds.getField(Sel.PaymentType)); %>
      <td><v:grid-checkbox name="PaymentId" dataset="ds" fieldname="PaymentId"/></td>
      <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
      <td>
        <snp:entity-link entityId="<%=ds.getField(Sel.TransactionSaleId).getString()%>" entityType="<%=LkSNEntityType.Sale%>" clazz="list-title">
          <%=ds.getField(Sel.TransactionSaleCode).getHtmlString()%>
        </snp:entity-link>
        <br/>
        <span class="list-subtitle"><%=ds.getField(Sel.TransactionDesc).getHtmlString()%></span>
      </td>
      <td>
        <%=paymentType.getDescription(pageBase.getLang())%><br/>
        <span class="list-subtitle">&nbsp;</span>
      </td>
      <td valign="top">
        <%=pageBase.format(ds.getField(Sel.DueDate), pageBase.getShortDateFormat())%><br/>
        <span class="list-subtitle"><%=creditStatus.getHtmlDescription(pageBase.getLang())%></span>
      </td>
      <td align="right">
        <input type="hidden" id="amount_<%=ds.getField(Sel.PaymentId).getEmptyString()%>" value="<%=ds.getField(Sel.PaymentAmount).getString()%>"/>
        <%=pageBase.formatCurrHtml(ds.getField(Sel.PaymentAmount))%><br/>
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
    $("#amount-total").text("");
  else
    $("#amount-total").text(itl("@Common.Selecteds") + " = " + formatCurr(total));
});

</script>

