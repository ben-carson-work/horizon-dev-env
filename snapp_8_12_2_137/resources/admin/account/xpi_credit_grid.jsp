<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>


<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
String crossPlatformId = pageBase.getEmptyParameter("CrossPlatformId");

DOCmd_Account reqDO = new DOCmd_Account();
reqDO.Request.Command.setString(reqDO.Request.CreditSearch.getNodeName());
reqDO.Request.CreditSearch.PagePos.setInteger(pageBase.getQP());
reqDO.Request.CreditSearch.RecordPerPage.setInteger(QueryDef.recordPerPageDefault);
reqDO.Request.CreditSearch.AccountId.setString(crossPlatformId);
reqDO.Request.CreditSearch.CreditStatus.setArray(pageBase.getNullParameter("CreditStatus") != null ? JvArray.stringToIntArray(pageBase.getNullParameter("CreditStatus"), ",") : new int[0]);
reqDO.Request.CreditSearch.IssueDateFrom.setDateTime(pageBase.getNullParameter("FromDate") != null ? JvDateTime.createByXML(pageBase.getNullParameter("FromDate")) : null);
reqDO.Request.CreditSearch.IssueDateTo.setDateTime(pageBase.getNullParameter("ToDate") != null ? JvDateTime.createByXML(pageBase.getNullParameter("ToDate")) : null);
reqDO.Request.CreditSearch.DueDateFrom.setDateTime(pageBase.getNullParameter("FromDueDate") != null ? JvDateTime.createByXML(pageBase.getNullParameter("FromDueDate")) : null);
reqDO.Request.CreditSearch.DueDateTo.setDateTime(pageBase.getNullParameter("ToDueDate") != null ? JvDateTime.createByXML(pageBase.getNullParameter("ToDueDate")) : null);



boolean serviceError = false;
String errorMessage = ""; 
List<DOCredit> creditList = new ArrayList<>();

try {
  creditList = pageBase.getBL(BLBO_XPI.class).getWS(crossPlatformId).post(DOCmd_Account.class, reqDO).Answer.CreditSearch.CreditList.getItems();
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
<v:grid id="xpi-credit-grid" entityType="<%=LkSNEntityType.Payment%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
      <td width="25%">
        <v:itl key="@Account.Credit.IssueTransaction"/><br/>
        <v:itl key="@Common.Status"/>
      </td>
      <td width="25%">
        <v:itl key="@Common.Type"/><br/>
        <v:itl key="@Common.Description"/>
      </td>
      <td width="25%">
        <v:itl key="@Account.Credit.SettleTransaction"/><br/>
        <v:itl key="@Account.Credit.DueDate"/>
      </td>
      <td width="25%" align="right" valign="top">
        <v:itl key="@Common.Amount"/>
        <span id="amount-total" style="font-weight:bold"></span>
      </td>
    </tr>
  </thead>
  
  <tbody>
    <% for (DOCredit credit : creditList) { %>
      <tr class="grid-row">
	      <td><input name="PaymentId" value="<%=credit.PaymentId.getHtmlString()%>" type="checkbox" class="cblist"></td>
	      <td><v:grid-icon name="<%=credit.IconName.getString()%>"/></td>
	      <td>
	        <a class="list-title" href="javascript:showXPITransactionDialog('<%=credit.IssueTransactionId.getHtmlString()%>','<%=crossPlatformId%>')"><%=credit.IssueTransactionDesc.getHtmlString()%></a><br/>
	        <span class="list-subtitle"><%=credit.CreditStatus.getLkValue().getDescription(pageBase.getLang())%></span>
	      </td>
	      <td>
	        <%=credit.PaymentType.getLkValue().getDescription(pageBase.getLang())%><br/>
	        <span class="list-subtitle"><%=credit.CreditDesc.getHtmlString()%></span>
	      </td>
	      <td valign="top">
	        <% if (credit.SettleTransactionId.isNull()) { %>
	          <v:itl key="@Account.Credit.Unsettled"/>
	        <% } else { %>
<%-- 	          <a href="<v:config key="site_url"/>/admin?page=transaction&id=<%=ds.getField(Sel.SettleTransactionId).getEmptyString()%>"> --%>
	            <%=credit.SettleTransactionId.getHtmlString()%>
<!-- 	          </a> -->
	        <% } %>
	        <br/>
	        <% credit.DueDate.setDisplayFormat(pageBase.getShortDateFormat()); %>
	        <span class="list-subtitle">
	          <% if (credit.DueDate.isNull()) { %>
	            <v:itl key="@Account.Credit.NoExpiration"/>
	          <% } else { %>
	            <%=credit.DueDate.getHtmlString()%>
	          <% } %>
	        </span>
	      </td>
	      <td align="right">
	        <input type="hidden" id="amount_<%=credit.PaymentId.getEmptyString()%>" value="<%=credit.PaymentAmount.getString()%>"/><%=pageBase.formatCurrHtml(credit.PaymentAmount.getMoney())%>
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

<script>

$(document).on("cbListClicked", function() {
  var total = 0;
  var arr = $("input[name='PaymentId']:checked");
  for (var i=0; i<arr.length; i++) 
    total += parseFloat($("#amount_" + $(arr[i]).val()).val());
  setVisible("#amount-total", arr.length > 0);
  $("#amount-total").html(total);
});


</script>

