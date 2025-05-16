<%@page import="com.vgs.snapp.dataobject.transaction.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.account.*"%>
<%@page import="com.vgs.snapp.api.account.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
APIDef_Account_SearchOpenOrderLog.DORequest reqDO = new APIDef_Account_SearchOpenOrderLog.DORequest();
reqDO.SearchRecap.PagePos.setInt(pageBase.getQP());
reqDO.SearchRecap.RecordPerPage.setInt(QueryDef.recordPerPageDefault);
reqDO.Account.AccountId.setString(pageBase.getNullParameter("AccountId"));
reqDO.FiscalDateFrom.setString(pageBase.getNullParameter("FromDate"));
reqDO.FiscalDateTo.setString(pageBase.getNullParameter("ToDate"));

APIDef_Account_SearchOpenOrderLog.DOResponse ansDO = pageBase.getBL(API_Account_SearchOpenOrderLog.class).execute(reqDO); 
%>

<v:grid id="openorderlog-grid" search="<%=ansDO%>">
  <thead>
    <tr>
      <td></td>
      <td width="120px" nowrap>
        <v:itl key="@Common.Transaction"/><br/>
        <v:itl key="@Common.DateTime"/>
      </td>
      <td width="80px" nowrap>
        <v:itl key="@Sale.PNR"/><br/>
        <v:itl key="@Common.Type"/>
      </td>
      <td width="100%" align="right" nowrap>
        <v:itl key="@Common.Amount"/><br/>
        <v:itl key="@Common.Balance"/>
      </td>
    </tr>
  </thead>
  
  <tbody>
    <v:grid-row search="<%=ansDO%>">
      <% DOAccountOpenOrderLogRef log = ansDO.getRecord(); %>
      <td><v:grid-icon name="transaction.png"/></td>
      <td nowrap>
        <% if (log.TransactionId.isNull()) { %>
          <div class="list-subtitle">&mdash;</div>
          <div class="list-subtitle"><v:label field="<%=log.LogFiscalDate%>"/></div>
          <% System.out.println(log); %>
        <% } else { %>
          <snp:entity-link entityId="<%=log.TransactionId%>" entityType="<%=LkSNEntityType.Transaction%>">
            <v:label field="<%=log.TransactionCode%>"/>
          </snp:entity-link>
          <div class="list-subtitle">
            <snp:datetime timestamp="<%=log.TransactionDateTime%>" format="shortdatetime" timezone="local"/>
          </div>
        <% } %>
      </td>
      <td nowrap>
        <% if (!log.SaleId.isNull()) { %>
          <snp:entity-link entityId="<%=log.SaleId%>" entityType="<%=LkSNEntityType.Sale%>">
            <v:label field="<%=log.SaleCode%>"/>
          </snp:entity-link>
        <% } %>
        <div class="list-subtitle"><v:label field="<%=log.TransactionType%>"/></div>
      </td>
      <td align="right" nowrap>
        <% String color = (log.LogAmount.getMoney() >= 0) ? "" : "color:#ff0000"; %>
        <div class="list-title"><v:label field="<%=log.LogAmount%>" style="<%=color%>"/></div>
        <div class="list-subtitle"><v:label field="<%=log.OpenOrderBalance%>"/></div>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>
