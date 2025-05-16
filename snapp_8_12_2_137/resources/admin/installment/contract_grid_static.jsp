<%@page import="com.vgs.snapp.api.installment.APIDef_InstallmentContract_Search"%>
<%@page import="com.vgs.snapp.api.account.APIDef_Account_ActionInfo"%>
<%@page import="com.vgs.snapp.dataobject.task.DOTask_InstallmentCharge"%>
<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="java.util.List"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.QryBO_InstallmentContract.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<% 
APIDef_InstallmentContract_Search.DOResponse ansDO = (APIDef_InstallmentContract_Search.DOResponse)request.getAttribute("searchContract");
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");
String title = request.getParameter("title");
boolean multiPage = false;
if (pageBase.getNullParameter("MultiPage") != null)
  multiPage = pageBase.findBoolParameter("MultiPage");
%>

<v:grid id="instcontr-grid-table" search="<%=ansDO%>" entityType="<%=LkSNEntityType.Ticket%>">
  <v:grid-title caption="<%=title%>" include="<%=title != null%>"/>

  <thead>
    <tr class="header">
      <td><v:grid-checkbox header="true" multipage="<%=multiPage%>"/></td>
      <td>&nbsp;</td>
      <td width="150px" nowrap="nowrap">
        <v:itl key="@Common.Code"/><br/>
        <v:itl key="@Common.Status"/>
      </td>
      <td width="25%">
        <v:itl key="@Installment.Payor"/><br/>
        <v:itl key="@Installment.InstallmentPlan"/>
      </td>
      <td width="25%">
        <v:itl key="@Common.Transaction"/><br/>
        <v:itl key="@Common.DateTime"/>
      </td>
      <td width="50%" align="right">
        <v:itl key="@Installment.Financed"/><br/>
        (<v:itl key="@Installment.Outstanding"/>) <v:itl key="@Installment.Unsettled"/> 
      </td>
    </tr>
  </thead>
  
  <tbody>
    <v:grid-row search="<%=ansDO%>" dateGroupFieldName="<%=Sel.CreateDateTime.name()%>">
      <%DOInstallmentContractRef contract = ansDO.getRecord();%>
      <% LookupItem instContrStatus = LkSN.InstallmentContractStatus.getItemByCode(contract.InstallmentContractStatus.getInt()); %>
      <td style="<v:common-status-style status="<%=contract.CommonStatus%>"/>">
        <v:grid-checkbox name="InstallmentContractId" fieldname="InstallmentContractId" value="<%=contract.InstallmentContractId.getString()%>"/>
      </td>
      <td><v:grid-icon name="<%=contract.IconName.getString()%>"/></td>
      <td>
        <snp:entity-link entityId="<%=contract.InstallmentContractId%>" entityType="<%=LkSNEntityType.InstallmentContract%>" clazz="list-title">
          <%=contract.InstallmentContractCode%>
        </snp:entity-link>
        <br/>
        <span class="list-subtitle"><%=instContrStatus.getHtmlDescription(pageBase.getLang())%></span>        
      </td>
      <td>
        <snp:entity-link entityId="<%=contract.AccountId.getString()%>" entityType="<%=contract.AccountEntityType.getLkValue()%>">
          <%=contract.AccountName.getHtmlString()%>
        </snp:entity-link>
        <br/>
        <snp:entity-link entityId="<%=contract.InstallmentPlanId.getString()%>" entityType="<%=LkSNEntityType.InstallmentPlan%>">
          <%=contract.InstallmentPlanName.getHtmlString()%>
        </snp:entity-link>
      </td>
      <td>
        <% if (contract.IssueTransactionId.isNull()) { %>
          - 
        <% } else { %>
          <snp:entity-link entityId="<%=contract.IssueTransactionId.getString()%>" entityType="<%=LkSNEntityType.Transaction%>">
            <%=contract.IssueTransactionCode.getHtmlString()%>
          </snp:entity-link>
        <% } %>
        <br/>
        <snp:datetime timestamp="<%=contract.CreateDateTime%>" format="shortdatetime" timezone="local" clazz="list-subtitle"/>
      </td>
      <td align="right">
        <%=pageBase.formatCurrHtml(contract.FinancedAmount)%><br/>
        <span class="list-subtitle">
          <% long outstanding = contract.OutstandingAmount.getMoney(); %>
          <% if (outstanding != 0) { %>
            <span style="font-weight:bold;color:var(--base-red-color)">(<%=pageBase.formatCurrHtml(outstanding)%>)</span>
          <% } %>
          <%=pageBase.formatCurrHtml(contract.UnsettledAmount)%>
        </span>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>
