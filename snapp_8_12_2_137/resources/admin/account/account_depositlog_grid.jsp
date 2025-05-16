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
APIDef_Account_SearchDepositLog.DORequest reqDO = new APIDef_Account_SearchDepositLog.DORequest();
reqDO.SearchRecap.PagePos.setInt(pageBase.getQP());
reqDO.SearchRecap.RecordPerPage.setInt(QueryDef.recordPerPageDefault);
reqDO.Account.AccountId.setString(pageBase.getNullParameter("AccountId"));
reqDO.FiscalDateFrom.setString(pageBase.getNullParameter("FromDate"));
reqDO.FiscalDateTo.setString(pageBase.getNullParameter("ToDate"));

APIDef_Account_SearchDepositLog.DOResponse ansDO = pageBase.getBL(API_Account_SearchDepositLog.class).execute(reqDO); 
%>

<v:grid id="depositlog-grid" search="<%=ansDO%>">
  <thead>
    <tr>
      <td></td>
      <td width="120px" nowrap>
        <v:itl key="@Common.Transaction"/><br/>
        <v:itl key="@Common.DateTime"/>
      </td>
      <td width="80px" nowrap>
        <v:itl key="@Sale.PNR"/>
      </td>
      <td width="120px" nowrap>
        <v:itl key="@Reservation.Flags"/><br/>
        <v:itl key="@Common.Type"/>
      </td>
      <td width="100%">
        <v:itl key="@Common.Workstation"/><br/>
        <v:itl key="@Common.User"/>
      </td>
      <td width="120px" align="right" nowrap>
        <v:itl key="@Common.Amount"/><br/>
        <v:itl key="@Common.Balance"/>
      </td>
    </tr>
  </thead>
  
  <tbody>
    <v:grid-row search="<%=ansDO%>">
      <% DOAccountDepositLogRef log = ansDO.getRecord(); %>
      <td><v:grid-icon name="transaction.png"/></td>
      <td nowrap>
        <snp:entity-link entityId="<%=log.TransactionId%>" entityType="<%=LkSNEntityType.Transaction%>">
          <%=log.TransactionCode.getHtmlString()%>
        </snp:entity-link>
        <br/>
        <snp:datetime timestamp="<%=log.TransactionDateTime%>" format="shortdatetime" timezone="local" clazz="list-subtitle"/>
      </td>
      <td nowrap>
        <snp:entity-link entityId="<%=log.SaleId%>" entityType="<%=LkSNEntityType.Sale%>">
          <%=log.SaleCode.getHtmlString()%>
        </snp:entity-link>
      </td>
      <td nowrap>
        <div><%=log.TransactionFlags.getHtmlString()%></div>
        <div class="list-subtitle"><%=log.TransactionType.getHtmlLookupDesc(pageBase.getLang())%></div>
      </td>
      <td>
        <snp:entity-link entityId="<%=log.LocationId%>" entityType="<%=LkSNEntityType.Location%>">
          <%=log.LocationName.getHtmlString()%>
        </snp:entity-link>
        &raquo;  
        <snp:entity-link entityId="<%=log.OpAreaId%>" entityType="<%=LkSNEntityType.OperatingArea%>">
          <%=log.OpAreaName.getHtmlString()%>
        </snp:entity-link>
        &raquo;  
        <snp:entity-link entityId="<%=log.WorkstationId%>" entityType="<%=LkSNEntityType.Workstation%>">
          <%=log.WorkstationName.getHtmlString()%>
        </snp:entity-link>
        <br/>
        <snp:entity-link entityId="<%=log.UserAccountId%>" entityType="<%=LkSNEntityType.Account_All%>">
          <%=log.UserAccountName.getHtmlString()%>
        </snp:entity-link>
      </td>
      <td align="right" nowrap>
        <% String color = (log.LogAmount.getMoney() >= 0) ? "" : "color:#ff0000"; %>
        <div style="<%=color%>"><%=pageBase.formatCurrHtml(log.LogAmount)%></div>
        <div class="list-subtitle"><%=pageBase.formatCurrHtml(log.DepositBalance)%></div>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>
