<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.JvDataSet"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.search.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%

DOAccountInventoryBalanceSearchRequest reqDO = new DOAccountInventoryBalanceSearchRequest();

reqDO.SearchRecapRequest.PagePos.setInt(pageBase.getQP());
reqDO.SearchRecapRequest.RecordPerPage.setInt(QueryDef.recordPerPageDefault);

if (pageBase.getNullParameter("AccountId") != null)
  reqDO.AccountId.setString(pageBase.getNullParameter("AccountId"));

DOAccountInventoryBalanceSearchAnswer ansDO = pageBase.getBL(BLBO_AccountInventory.class).searchAccountInventoryBalance(reqDO);
%>

<v:grid search="<%=ansDO%>" id="inventory-balance-grid">
  <thead>
    <tr>
      <td>&nbsp;</td>
      <td width="70%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Code"/>
      </td>
      <td width="10%">
      </td>
      <td width="10%" align="right">
        <v:itl key="@Common.Quantity"/>
      </td>
      <td width="10%" align="right">
        <v:itl key="@Reservation.UnitAmount"/><br/>
        <v:itl key="@Reservation.TotalAmount"/>
      </td>
    </tr>
  </thead>
  
  <tbody>
    <v:grid-row search="<%=ansDO%>">
      <% DOAccountInventoryBalanceRef record = ansDO.getRecord(); %>
      <td><v:grid-icon name="<%=record.ProductIconName.getString()%>" repositoryId="<%=record.ProductProfilePictureId.getString()%>"/></td>
      <td>
        <%=record.ProductName.getHtmlString()%><br/>
        <span class="list-subtitle"><%=record.ProductCode.getHtmlString()%>&nbsp;</span>
      </td>
      <td align="right">
        <a href="javascript:showTransactionHistory('<%=record.AccountInventoryBalanceId.getEmptyString()%>')"><v:itl key="@Common.Details"/></a>
      </td>
      <td align="right">
        <%=record.Quantity.getInt()%>
      </td>  
      <td align="right">
        <%=pageBase.formatCurrHtml(record.UnitAmount.getMoney())%><br/>
        <span class="list-subtitle"><%=pageBase.formatCurrHtml(record.TotalAmount.getMoney())%></span>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>

<script>
function showTransactionHistory(accountInventoryBalanceId) {
	asyncDialogEasy('inventory/inventory_transaction_dialog', 'AccountInventoryBalanceId=' + accountInventoryBalanceId);
}
	

</script>
