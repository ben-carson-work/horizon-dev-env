<%@page import="com.vgs.snapp.dataobject.commission.DOTransactionCommissionRecap"%>
<%@page import="com.vgs.snapp.dataobject.transaction.DOTransaction.DOTransactionCommission"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTransaction" scope="request"/>
<jsp:useBean id="transaction" class="com.vgs.snapp.dataobject.transaction.DOTransaction" scope="request"/>

<v:tab-content>
  <v:grid>
    <thead>
      <tr class="header">
        <td width="40%">
          <v:itl key="@Product.FinanceGroup"/>
        </td>
        <td width="40%">
          <v:itl key="@Product.ProductType"/>
        </td>
        <td align="right" width="20%">
          <v:itl key="@Common.Amount"/><br/>
          <v:itl key="@Common.Quantity"/>
        </td>
      </tr>
    </thead>
    
    <tbody>
      <% for (DOTransactionCommissionRecap.DORecapGroup group : transaction.CommissionRecap.GroupList) { %>
        <tr class="group">
          <td colspan="100%">
            <snp:entity-link entityId="<%=group.AccountId%>" entityType="<%=LkSNEntityType.Organization%>"><%=group.AccountName.getHtmlString()%></snp:entity-link>

            <% if (!group.CommissionRuleId.isNull()) { %>
              &nbsp;&nbsp;&mdash;&nbsp;&nbsp;
              <snp:entity-link entityId="<%=group.CommissionRuleId%>" entityType="<%=LkSNEntityType.CommissionRule%>" clazz="list-title"><%=group.CommissionRuleName.getHtmlString()%></snp:entity-link>
            <% } %>
            
            <% if (group.ExternalPricing.getBoolean()) { %>
              &nbsp;&nbsp;&mdash;&nbsp;&nbsp;
              <v:itl key="@Product.ExternalPricing"/>
            <% } %>
          </td>
        </tr>
      
        <% for (DOTransactionCommissionRecap.DORecapItem item : group.ItemList) { %>
          <tr class="grid-row">
            <td>
              <div class="list-title"><%=item.FinanceGroupTagName.getHtmlString()%></div>
              <div class="list-subtitle"><%=item.FinanceGroupTagCode.getHtmlString()%></div>
            </td>
            <td>
              <div class="list-title">
                <snp:entity-link entityId="<%=item.ProductId%>" entityType="<%=LkSNEntityType.ProductType%>"><%=item.ProductName.getHtmlString()%></snp:entity-link>
                <% if (!item.TicketId.isNull()) { %>
                  (<snp:entity-link entityId="<%=item.TicketId%>" entityType="<%=LkSNEntityType.Ticket%>"><%=item.TicketCode.getHtmlString()%></snp:entity-link>)
                <% } %>
              </div>
              <div class="list-subtitle">
                <%=item.ProductCode.getHtmlString()%>
              </div>
            </td>
            <td align="right">
              <div class="list-title"><%=pageBase.formatCurrHtml(item.CommissionAmount)%></div>
              <div class="list-subtitle"><%=item.CommissionQuantity.getHtmlString()%></div>
            </td>
          </tr>
        <% } %>
      <% } %>
    
      <tr class="header">
        <td colspan="2"><v:itl key="@Commission.CommissionTotalAmount"/></td>
        <td colspan="1" align="right"><%=pageBase.formatCurrHtml(transaction.CommissionRecap.CommissionAmount)%></td>
      </tr>
    </tbody>

  </v:grid>
</v:tab-content>

