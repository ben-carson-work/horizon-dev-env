<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
String accountId = pageBase.getNullParameter("AccountId");
QueryDef qdef = new QueryDef(QryBO_PaymentToken.class);
//Select
qdef.addSelect(QryBO_PaymentToken.Sel.PaymentTokenId);
qdef.addSelect(QryBO_PaymentToken.Sel.PaymentTokenDesc);
qdef.addSelect(QryBO_PaymentToken.Sel.CardType);
qdef.addSelect(QryBO_PaymentToken.Sel.CardNumber);
qdef.addSelect(QryBO_PaymentToken.Sel.CardExpDate);
qdef.addSelect(QryBO_PaymentToken.Sel.CardHolderName);
qdef.addSelect(QryBO_PaymentToken.Sel.CreateDate);
qdef.addSelect(QryBO_PaymentToken.Sel.ExpirationDate);
//Where
if (pageBase.getNullParameter("AccountId") != null)
  qdef.addFilter(QryBO_PaymentToken.Fil.AccountId, pageBase.getParameter("AccountId"));
//Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
//Sort
qdef.addSort(QryBO_PaymentToken.Sel.CreateDate);
//Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" id="payment-token-grid" entityType="<%=LkSNEntityType.PaymentToken%>">
  <thead>
  <tr class="header">
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td></td>
      <td width="15%">
        <v:itl key="@Payment.CreditCard"/><br/>
      </td>
      <td width="8%">
        <v:itl key="@Common.Expiration"/>
      </td>
      <td width="22%">
        <v:itl key="@Payment.Cardholder"/><br/>
      </td>
      <td width="45%">
        <v:itl key="@Common.Description"/><br/>
      </td>
      <td width="10%" align="right">
        <v:itl key="@Payment.TokenValidity"/>
      </td>
    </tr>
  </tr>
  </thead>
  <v:grid-row dataset="ds">
    <td><v:grid-checkbox name="PaymentTokenId" dataset="ds" fieldname="PaymentTokenId"/></td>
    <td><v:grid-icon name="fa" iconAlias="credit-card"/></td>
    <td>
      <%=ds.getField(QryBO_PaymentToken.Sel.CardType).getEmptyString()%>&nbsp;(<%=ds.getField(QryBO_PaymentToken.Sel.CardNumber).getEmptyString()%>)<br/>
    </td>
    <td>
      <% 
      String cardExpDate = ds.getField(QryBO_PaymentToken.Sel.CardExpDate).getNullString();
      if (cardExpDate != null)
        cardExpDate = cardExpDate.substring(0, 2) + "/20" + cardExpDate.substring(2);
      %>
      <%=cardExpDate%><br/>
    </td>
    <td>
      <%=ds.getField(QryBO_PaymentToken.Sel.CardHolderName).getEmptyString()%><br/>
    </td>
    <td>
      <%=ds.getField(QryBO_PaymentToken.Sel.PaymentTokenDesc).getEmptyString()%><br/>
    </td>
    <td align="right">
      <%=pageBase.format(ds.getField(QryBO_PaymentToken.Sel.CreateDate), pageBase.getShortDateFormat())%><br/>
      <span class="list-subtitle">
       <% if (ds.getField(QryBO_PaymentToken.Sel.ExpirationDate).isNull()) { %>
         <v:itl key="@Common.Unlimited"/>
       <% } else { %>
         <%=pageBase.format(ds.getField(QryBO_PaymentToken.Sel.ExpirationDate), pageBase.getShortDateFormat())%>
       <% } %>
     </span>
    </td>
  </v:grid-row> 
</v:grid>

<script>
	

</script>
