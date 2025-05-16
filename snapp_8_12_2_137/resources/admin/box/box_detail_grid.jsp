<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="com.vgs.web.library.*"%>
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

<%
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); 

@SuppressWarnings("unchecked")
List<DOBox.DOBoxDetail> listDetailOriginal = (List<DOBox.DOBoxDetail>)request.getAttribute("BoxDetailList"); 

List<DOBox.DOBoxDetail> listDetail = new ArrayList<>();
listDetail.addAll(listDetailOriginal);
listDetail.sort(new Comparator<DOBox.DOBoxDetail>() {
  @Override
  public int compare(DOBox.DOBoxDetail o1, DOBox.DOBoxDetail o2) {
    return 
        o1.PaymentGroupTagName.getEmptyString().compareTo(o2.PaymentGroupTagName.getEmptyString()) * 1000 + 
        o1.PaymentMethodName.getEmptyString().compareTo(o2.PaymentMethodName.getEmptyString());
  }
});
%>

<style>
table.listcontainer .payment-group-total td {
  font-weight: bold;
  border-top: 1px solid black;
}

table.listcontainer .payment-group-total:not(:last-child)  td {
  padding-bottom: 50px;
}

</style>
 
<div class="tab-content">
  <v:grid clazz="box-detail-grid">
    <thead>
      <tr>
        <td width="50%">
          <v:itl key="@Payment.PaymentMethod"/><br/>
          <v:itl key="@Currency.Currency"/>
        </td>
        <td width="50%" align="right">
          <div><v:itl key="@Common.MainCurrencyAmount"/></div>
          <div><v:itl key="@Common.ForeignCurrencyAmount"/></div>
        </td>
      </tr>
    </thead>
  
    <tbody>
    <% if (listDetail.isEmpty()) { %>
      <tr class="no-items"><td colspan="100%"><v:itl key="@Common.NoItems"/></td></tr>
    <% } %>
    <% boolean first = true; %>
    <% String paymentGroupId = ""; %>
    <% String paymentGroupCode = ""; %>
    <% String paymentGroupName = ""; %>
    <% long paymentGroupTotal = 0; %>
    <% for (DOBox.DOBoxDetail detail : listDetail) { %>
      <% if (first || !JvString.isSameString(detail.PaymentGroupTagId.getNullString(), paymentGroupId)) {  %>
        <%if (!first) { %>
          <tr class="payment-group-total">
            <td><%=pageBase.getBL(BLBO_PayMethod.class).calcPaymentGroupDesc(paymentGroupCode, paymentGroupName)%></td>  
            <td align="right" style="<%=(paymentGroupTotal<0) ? "color:red" : "" %>">
              <div><%=pageBase.formatCurrHtml(paymentGroupTotal)%></div>
            </td>  
          </tr>
          <% paymentGroupTotal = 0; %>
        <%} %>
        <% paymentGroupId = detail.PaymentGroupTagId.getString(); %>
        <% paymentGroupCode = detail.PaymentGroupTagCode.getString(); %>
        <% paymentGroupName = detail.PaymentGroupTagName.getString(); %>
        <% first = false; %>
      <% } %>
      <% JvCurrency currFormatter = new JvCurrency(detail.CurrencyFormat.getInt(), detail.CurrencySymbol.getString(), detail.CurrencyISO.getString(), detail.RoundDecimals.getInt(), pageBase.getRights().DecimalSeparator.getString(), pageBase.getRights().ThousandSeparator.getString()); %>
      <tr data-paymentmethodid="<%=detail.PaymentMethodId.getHtmlString()%>" data-currencyiso="<%=detail.CurrencyISO.getHtmlString()%>" data-paymentmethodname="<%=detail.PaymentMethodName.getHtmlString()%>" data-totalamount="<%=currFormatter.formatHtml(detail.CurrencyAmount.getMoney())%>">
        <td>
          <%=detail.PaymentMethodName.getHtmlString()%><br/>
          <span class="list-subtitle"><%=detail.CurrencyISO.getHtmlString()%></span>
        </td>
        <% long amount = detail.CurrencyAmount.getMoney(); %>
        <% paymentGroupTotal += detail.Amount.getMoney(); %>
        <td align="right" style="<%=(amount<0) ? "color:red" : "" %>">
          <div><%=pageBase.formatCurrHtml(detail.Amount)%></div>
          <div class="list-subtitle">
            <%=currFormatter.formatHtml(amount)%>
          </div>
        </td>
      </tr>
    <% } %>
    <tr class="payment-group-total">
      <td><%=pageBase.getBL(BLBO_PayMethod.class).calcPaymentGroupDesc(paymentGroupCode, paymentGroupName)%></td>  
      <td align="right" style="<%=(paymentGroupTotal<0) ? "color:red" : "" %>">
        <div><%=pageBase.formatCurrHtml(paymentGroupTotal)%></div>
      </td>  
    </tr>
    </tbody>
  </v:grid>
</div>

