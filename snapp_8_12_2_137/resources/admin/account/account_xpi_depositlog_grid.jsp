<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
String crossPlatformId = pageBase.getEmptyParameter("CrossPlatformId");

DOCmd_Account reqDO = new DOCmd_Account();
reqDO.Request.Command.setString(reqDO.Request.DepositLogSearch.getNodeName());
reqDO.Request.DepositLogSearch.AccountId.setString(crossPlatformId);
reqDO.Request.DepositLogSearch.DateFrom.setDateTime(pageBase.getNullParameter("FromDate") != null ? JvDateTime.createByXML(pageBase.getNullParameter("FromDate")) : null);
reqDO.Request.DepositLogSearch.DateTo.setDateTime(pageBase.getNullParameter("FromTo") != null ? JvDateTime.createByXML(pageBase.getNullParameter("FromTo")) : null);

boolean serviceError = false;
String errorMessage = ""; 
List<DODepositLog> depositLogList = new ArrayList<>();

try {
  depositLogList = pageBase.getBL(BLBO_XPI.class).getWS(crossPlatformId).post(DOCmd_Account.class, reqDO).Answer.DepositLogSearch.DepositLogList.getItems();
}
catch (Throwable t) {
  serviceError = true;
  errorMessage = t.getMessage();
}
%>

<script>
function showXPITransactionDialog(crossTransactionId, crossPlatformId) {
  asyncDialogEasy("xpi/xpi_transaction_dialog", "CrossTransactionRef=" + crossTransactionId + "&CrossPlatformId=" + crossPlatformId);
}
</script>

<% if (!serviceError) { %>
<v:grid id="xpi-depositlog-grid">
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
    <% for (DODepositLog depositLog : depositLogList) { %>
      <tr>
      <% LookupItem transactionType = depositLog.TransactionType.getLkValue(); %>
      <td><v:grid-icon name="transaction.png"/></td>
      <td nowrap>
        <% if (transactionType.isLookup(LkSNTransactionType.XPI)) { %>
          <a class="list-title" href="javascript:showXPITransactionDialog('<%=depositLog.TransactionId.getHtmlString()%>','<%=crossPlatformId%>')"><%=depositLog.TransactionCode.getHtmlString()%></a>
        <% } else {%>
          <%=depositLog.TransactionCode.getHtmlString()%>
        <% } %>
        <br/>
        <snp:datetime timestamp="<%=depositLog.TransactionDateTime%>" format="shortdatetime" timezone="local" clazz="list-subtitle"/>
      </td>
      <td nowrap>
        <%=depositLog.SaleCode.getHtmlString()%>
      </td>
      <td nowrap>
        <%=depositLog.TransactionFlags.getHtmlString()%><br/>
        <span class="list-subtitle"><%=transactionType.getHtmlDescription(pageBase.getLang())%></span>
      </td>
      <td>
        <%=depositLog.LocationName.getHtmlString()%>
        »    
        <%=depositLog.OpAreaName.getHtmlString()%>
        »
        <%=depositLog.WorkstationName.getHtmlString()%>
        <br/>
        <%=depositLog.UserAccountName.getHtmlString()%>
      </td>
      <td align="right" nowrap>
        <%
          long amount = depositLog.LogAmount.getMoney();
          String color = (amount >= 0) ? "" : "color:#ff0000";
        %>
        <span style="<%=color%>"><%=pageBase.formatCurrHtml(amount)%></span><br/>
        <span class="list-subtitle"><%=pageBase.formatCurrHtml(depositLog.DepositBalance)%></span>
      </td>
      </tr>
    <% } %>
  </tbody>
</v:grid>
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