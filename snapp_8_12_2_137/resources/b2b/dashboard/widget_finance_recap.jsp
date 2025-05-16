<%@page import="com.vgs.snapp.dataobject.DOAccountFinance"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.b2b.page.PageB2B_Dashboard" scope="request"/>

<% DOAccountFinance finance = pageBase.getBL(BLBO_Account.class).loadAccountFinance(pageBase.getSession().getOrgAccountId()); %>

<style>
#outstanding-debts-error {
  text-align: center;
  font-weight: bold;
  color: var(--base-red-color);
}
</style>

<v:widget caption="@Account.Credit.OverallActivity">
  <v:widget-block include="<%=finance.OutstandingDebt.getBoolean() || (finance.TotalOutstanding.getMoney() > 0)%>">
    <div id="outstanding-debts-error"><v:itl key="@Account.Credit.ErrorOutstandingDebts"/></div>
    <v:recap-item caption="@Common.Outstanding" valueColor="red"><v:label field="<%=finance.TotalOutstanding%>"/></v:recap-item>
  </v:widget-block>

  <v:widget-block>
    <v:recap-item caption="@Account.Credit.TotalCredit"><v:label field="<%=finance.TotalCredit%>"/></v:recap-item>
    <v:recap-item caption="@Account.Credit.Unsettled" valueColor="red"><v:label field="<%=finance.TotalOpen%>"/></v:recap-item>
    <v:recap-item caption="@Account.Credit.DepositBalance"><v:label field="<%=finance.AdvDeposit%>"/></v:recap-item>
    <v:recap-item caption="@Account.Credit.OpenOrders">
      <v:hint-handle hint="@Account.Credit.OpenOrderNotUsedHint" include="<%=!finance.OpenOrderAffectCredit.getBoolean()%>" />
      <v:label field="<%=finance.OpenOrderBalance%>"/>
    </v:recap-item>
    <v:recap-item caption="@Account.Credit.TotalAvailable"><v:label field="<%=finance.TotalAvailable%>"/></v:recap-item>
  </v:widget-block>

  <v:widget-block>
    <v:recap-item caption="@Account.Credit.TotalActivity"><v:label field="<%=finance.TotalActivity%>"/></v:recap-item>
    <v:recap-item caption="@Account.Credit.TotalPaid"><v:label field="<%=finance.TotalPaid%>"/></v:recap-item>
  </v:widget-block>
  
  <v:widget-block>
    <v:recap-item caption="@Account.Credit.CreditDays"><v:label field="<%=finance.CreditDays%>" placeholder="@Common.Unlimited"/></v:recap-item>
    <v:recap-item caption="@Account.Credit.CreditPerTrans"><v:label field="<%=finance.CreditPerTransaction%>" placeholder="@Common.Unlimited"/></v:recap-item>
    <v:recap-item caption="@Account.Credit.ItemsPerTrans"><v:label field="<%=finance.ItemsPerTransaction%>" placeholder="@Common.Unlimited"/></v:recap-item>
  </v:widget-block>
</v:widget>
