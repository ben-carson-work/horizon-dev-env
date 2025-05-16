<%@page import="com.vgs.snapp.dataobject.commission.DOSaleCommissionRecap.DOSaleCommissionRecapItem"%>
<%@page import="com.vgs.snapp.dataobject.commission.DOSaleCommissionRecap"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSale" scope="request"/>
<jsp:useBean id="sale" class="com.vgs.snapp.dataobject.transaction.DOSale" scope="request"/>

<v:tab-content>
  <v:grid>
    <thead>
      <tr>
        <td width="20%"> 
          <v:itl key="@Common.Code"/><br/>
          <v:itl key="@Common.DateTime"/>
        </td>
        <td width="50%">
          <v:itl key="@Account.Account"/>
        </td>
        <td width="30%" align="right"> 
          <v:itl key="@Common.Amount"/><br/>
          <v:itl key="@Common.Quantity"/>
        </td>
      </tr>
    </thead>
    
    <tbody>
      <% for (DOSaleCommissionRecapItem item : sale.CommissionRecap.TransactionList) { %>
        <tr class="grid-row">
          <td width="50%">
            <snp:entity-link entityId="<%=item.TransactionId%>" entityType="<%=LkSNEntityType.Transaction%>" clazz="list-title"><%=item.TransactionCode.getHtmlString()%></snp:entity-link>
            <div><snp:datetime timestamp="<%=item.TransactionSerialDateTime%>" format="shortdatelongtime" timezone="local"/></div>
          </td>
          <td width="30%">
            <snp:entity-link entityId="<%=item.AccountId%>" entityType="<%=LkSNEntityType.Organization.getCode()%>"><%=item.AccountName.getHtmlString()%></snp:entity-link> 
            <div class="list-subtitle"><%=item.AccountCode.getHtmlString()%></div>
          </td>
          </td>
          <td width="20%" align="right">
            <div class="list-title"><%=pageBase.formatCurrHtml(item.CommissionAmount)%></div>
            <div class="list-subtitle"><%=item.CommissionQuantity.getHtmlString()%></div>
          </td>
        </tr>
      <% } %>
          
      <tr class="header">
        <td><v:itl key="@Commission.CommissionTotalAmount"/></td>
        <td colspan="4" align="right"><%=pageBase.formatCurrHtml(sale.CommissionRecap.CommissionAmount)%></td>
      </tr> 
    </tbody>
  </v:grid>
</v:tab-content>

