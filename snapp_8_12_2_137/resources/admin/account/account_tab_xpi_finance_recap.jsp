<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.ConfigTag"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" scope="request" class="com.vgs.web.page.PageAccount"/>
<jsp:useBean id="account" scope="request" class="com.vgs.snapp.dataobject.DOAccount"/>
<jsp:useBean id="rights" scope="request" class="com.vgs.snapp.dataobject.DORightRoot"/>

<% 
boolean canReadFinance = rights.CreditLine.canRead();
boolean xpiAccount = account.EntityType.isLookup(LkSNEntityType.CrossPlatform);
boolean serviceError = false;
String errorMessage = ""; 
DOAccountFinance accountFinance = new DOAccountFinance();

try {
  accountFinance =  pageBase.getBL(BLBO_XPI.class).getWS(account.AccountId.getString()).xpi_GetAccountFinance();
}
catch (Throwable t) {
  serviceError = true;
  errorMessage = t.getMessage();
}

request.setAttribute("accountFinance", accountFinance);

%>

<v:page-form page="account" id="account-form"> 
<v:input-text field="account.AccountId" type="hidden" />

<div class="tab-content">
  <v:last-error/>

<% if (!serviceError) { %>
  <div class="profile-pic-div">
  <% if (canReadFinance) { %>
    <v:widget caption="@Account.Credit.OverallActivity">
      <% if (accountFinance.OutstandingDebt.getBoolean()) { %>
        <v:widget-block style="text-align:center;color:#c00000;font-weight:bold">
          <v:itl key="@Account.Credit.ErrorOutstandingDebts"/>
        </v:widget-block>
      <% } %>
      <v:widget-block>
        <v:itl key="@Common.Balance"/> <span class="recap-value"><%=pageBase.formatCurrHtml(accountFinance.Balance)%></span><br/>
        <v:itl key="@Account.Credit.TotalAvailable"/> <span class="recap-value"><%=pageBase.formatCurrHtml(accountFinance.TotalAvailable)%></span><br/>
      </v:widget-block>
      <v:widget-block>
        <v:itl key="@Account.Credit.TotalOpen"/> <span class="recap-value"><%=pageBase.formatCurrHtml(accountFinance.TotalOpen)%></span><br/>
        <v:itl key="@Account.Credit.TotalUncommitted"/> <span class="recap-value"><%=pageBase.formatCurrHtml(accountFinance.TotalUncommitted)%></span><br/>
        <v:itl key="@Account.Credit.AdvDeposit"/> <span class="recap-value"><%=pageBase.formatCurrHtml(accountFinance.AdvDeposit)%></span><br/>
      </v:widget-block>
      <v:widget-block>
        <v:itl key="@Account.Credit.TotalActivity"/> <span class="recap-value"><%=pageBase.formatCurrHtml(accountFinance.TotalActivity)%></span><br/>
        <v:itl key="@Account.Credit.TotalPaid"/> <span class="recap-value"><%=pageBase.formatCurrHtml(accountFinance.TotalPaid)%></span><br/>
      </v:widget-block>
    </v:widget>
  <% } %>
  </div>
  
  <div class="profile-cont-div">
  <% if (canReadFinance) { %>
    <v:widget caption="@Account.Credit.FinanceTitle">
      <v:widget-block>
        <v:form-field caption="@Account.Credit.TotalCredit">
          <v:input-text field="accountFinance.TotalCredit" enabled="false"/>
        </v:form-field>
        <v:form-field caption="@Account.Credit.CreditDays">
          <v:input-text field="accountFinance.CreditDays" enabled="false"/>
        </v:form-field>
        <v:form-field caption="@Account.Credit.GracePeriodDays" hint="@Account.Credit.GracePeriodDaysHint">
          <v:input-text field="accountFinance.GracePeriodDays" enabled="false"/>
        </v:form-field>
        <v:form-field caption="@Account.Credit.CreditPerTrans">
          <v:input-text field="accountFinance.CreditPerTransaction" placeholder="@Common.Unlimited" enabled="false"/>
        </v:form-field>
        <v:form-field caption="@Account.Credit.ItemsPerTrans">
          <v:input-text field="accountFinance.ItemsPerTransaction" placeholder="@Common.Unlimited" enabled="false"/>
        </v:form-field>
      </v:widget-block>
    </v:widget>
  <% } %>
  </div>
<% } else {%>
  <div id="main-container">
    <snp:list-tab caption="@Common.Error"/>
    <div class="mainlist-container">
      <div class="error-box">
        <strong><v:itl key="@Common.Error"/></strong>
        <br/>&nbsp;<br/>
        <v:itl key="@XPI.CrossPlatformCommunicationError" param1="<%=errorMessage%>"/>
      </div>

    </div>
  </div>
<% } %>  

  
</div>


</v:page-form>