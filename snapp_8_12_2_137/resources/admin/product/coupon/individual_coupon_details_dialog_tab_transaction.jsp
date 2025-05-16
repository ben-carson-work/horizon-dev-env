<%@page import="java.util.ArrayList"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Transaction.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>
<%@ taglib uri="snp-tags" prefix="snp"%>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<% boolean canEdit = false;%>
 
<% 
   String[] transactionIDs = pageBase.getDB().executeQuery(
    "select SrcEntityId from tbEntityLink where DstEntityType =" + LkSNEntityType.Coupon.getCode() + " and DstEntityId = " + JvString.sqlStr(pageBase.getId()) + JvString.CRLF +
    "union" + JvString.CRLF +
    "select IssueTransactionId from tbIndividualCoupon where IndividualCouponId =" + JvString.sqlStr(pageBase.getId()) + JvString.CRLF +
    "union" + JvString.CRLF +
    "select SettleTransactionId from tbIndividualCoupon where IndividualCouponId = " + JvString.sqlStr(pageBase.getId()) + " and SettleTransactionId is not null").getStrings(); 
  
  QueryDef qdefTrn = new QueryDef(QryBO_Transaction.class);
  //Select
  qdefTrn.addSelect(QryBO_Transaction.Sel.TransactionId);
  qdefTrn.addSelect(QryBO_Transaction.Sel.TransactionCode);
  qdefTrn.addSelect(QryBO_Transaction.Sel.TransactionFiscalDate);
  qdefTrn.addSelect(QryBO_Transaction.Sel.TransactionDateTime);
  qdefTrn.addSelect(QryBO_Transaction.Sel.WorkstationId);
  qdefTrn.addSelect(QryBO_Transaction.Sel.WorkstationCode);
  qdefTrn.addSelect(QryBO_Transaction.Sel.WorkstationName);
  qdefTrn.addSelect(QryBO_Transaction.Sel.TransactionSerial);
  qdefTrn.addSelect(QryBO_Transaction.Sel.Flags);
  qdefTrn.addSelect(QryBO_Transaction.Sel.TransactionType);
  qdefTrn.addSelect(QryBO_Transaction.Sel.LocationAccountId);
  qdefTrn.addSelect(QryBO_Transaction.Sel.LocationAccountName);
  qdefTrn.addSelect(QryBO_Transaction.Sel.OpAreaAccountId);
  qdefTrn.addSelect(QryBO_Transaction.Sel.OpAreaAccountName);
  qdefTrn.addSelect(QryBO_Transaction.Sel.UserAccountId);
  qdefTrn.addSelect(QryBO_Transaction.Sel.UserAccountName);
  qdefTrn.addSelect(QryBO_Transaction.Sel.UserAccountEntityType);
  qdefTrn.addSelect(QryBO_Transaction.Sel.SupAccountId);
  qdefTrn.addSelect(QryBO_Transaction.Sel.SupAccountName);
  qdefTrn.addSelect(QryBO_Transaction.Sel.SupAccountEntityType);
  qdefTrn.addSelect(QryBO_Transaction.Sel.ItemCount);
  qdefTrn.addSelect(QryBO_Transaction.Sel.TotalAmount);
  qdefTrn.addSelect(QryBO_Transaction.Sel.PaidAmount);
  qdefTrn.addSelect(QryBO_Transaction.Sel.SaleId);
  qdefTrn.addSelect(QryBO_Transaction.Sel.SaleCode);
  //Where
  qdefTrn.addFilter(QryBO_Transaction.Fil.TransactionId, transactionIDs);
  //Sort
  qdefTrn.addSort(QryBO_Transaction.Sel.TransactionFiscalDate, false);
  qdefTrn.addSort(QryBO_Transaction.Sel.TransactionDateTime, false);
  qdefTrn.addSort(QryBO_Transaction.Sel.TransactionSerial, false);
  //Exec
  JvDataSet dsTrn = pageBase.execQuery(qdefTrn);
  request.setAttribute("dsTrn", dsTrn);
%>

<div class="tab-content">

 <v:grid id="voucher-transaction-grid" dataset="<%=dsTrn%>" qdef="<%=qdefTrn%>">
  <tr class="header">
    <td width="120px" nowrap>
      <v:itl key="@Common.Code"/><br/>
      <v:itl key="@Common.DateTime"/>
    </td>
    <td width="150px" nowrap>
      <v:itl key="@Reservation.Flags"/><br/>
      <v:itl key="@Common.Type"/>
    </td>
    <td width="70%">
      <v:itl key="@Account.Location"/> &raquo; <v:itl key="@Account.OpArea"/> &raquo; <v:itl key="@Common.Workstation"/><br/>
      <v:itl key="@Common.User"/>
    </td>
    <td width="15%" align="right">
      <v:itl key="@Common.Quantity"/>
    </td>
    <td width="15%" align="right">
      <v:itl key="@Reservation.TotalAmount"/><br/>
      <v:itl key="@Reservation.PaidAmount"/>
    </td>
  </tr>
  <v:grid-row dataset="dsTrn">
    <% LookupItem transactionType = LkSN.TransactionType.getItemByCode(dsTrn.getField(QryBO_Transaction.Sel.TransactionType).getInt()); %>
    <td>
      <snp:entity-link entityId="<%=dsTrn.getField(QryBO_Transaction.Sel.TransactionId).getString()%>" entityType="<%=LkSNEntityType.Transaction%>" clazz="list-title">
        <%= dsTrn.getField(QryBO_Transaction.Sel.TransactionCode).getHtmlString() %>
      </snp:entity-link>
      <br/>
      <snp:datetime timestamp="<%=dsTrn.getField(QryBO_Transaction.Sel.TransactionDateTime)%>" format="shortdatetime" timezone="local" clazz="list-subtitle"/>
    </td>
    <td>
      <%= dsTrn.getField(QryBO_Transaction.Sel.Flags).getHtmlString() %><br/>
      <span class="list-subtitle"><%= transactionType.getDescription(pageBase.getLang()) %></span>
    </td>
    <td>
      <snp:entity-link entityId="<%=dsTrn.getField(QryBO_Transaction.Sel.LocationAccountId).getString()%>" entityType="<%=LkSNEntityType.Location%>"><%=dsTrn.getField(QryBO_Transaction.Sel.LocationAccountName).getHtmlString()%></snp:entity-link> &raquo;
      <snp:entity-link entityId="<%=dsTrn.getField(QryBO_Transaction.Sel.OpAreaAccountId).getString()%>" entityType="<%=LkSNEntityType.OperatingArea%>"><%=dsTrn.getField(QryBO_Transaction.Sel.OpAreaAccountName).getHtmlString()%></snp:entity-link> &raquo;
      <snp:entity-link entityId="<%=dsTrn.getField(QryBO_Transaction.Sel.WorkstationId).getString()%>" entityType="<%=LkSNEntityType.Workstation%>"><%=dsTrn.getField(QryBO_Transaction.Sel.WorkstationName).getHtmlString()%></snp:entity-link>
      <br/>
      <% if (dsTrn.getField(QryBO_Transaction.Sel.UserAccountId).isNull()) { %>
        &nbsp;
      <% } else { %>
        <% LookupItem userAccountEntityType = LkSN.EntityType.getItemByCode(dsTrn.getField(QryBO_Transaction.Sel.UserAccountEntityType)); %>
        <snp:entity-link entityId="<%=dsTrn.getField(QryBO_Transaction.Sel.UserAccountId).getString()%>" entityType="<%=userAccountEntityType%>"><%=dsTrn.getField(QryBO_Transaction.Sel.UserAccountName).getHtmlString()%></snp:entity-link>
      <% }%>
      <% if (!dsTrn.getField(QryBO_Transaction.Sel.SupAccountId).isNull()) { %>
        <span class="list-subtitle">&nbsp;(<v:itl key="@Common.Supervisor"/>:
          <% LookupItem supAccountEntityType = LkSN.EntityType.getItemByCode(dsTrn.getField(QryBO_Transaction.Sel.SupAccountEntityType)); %>
          <snp:entity-link entityId="<%=dsTrn.getField(QryBO_Transaction.Sel.SupAccountId).getString()%>" entityType="<%=supAccountEntityType%>"><%=dsTrn.getField(QryBO_Transaction.Sel.SupAccountName).getHtmlString()%></snp:entity-link>)
        </span>
      <% } %>
    </td>
    <td align="right">
      <%=dsTrn.getField(QryBO_Transaction.Sel.ItemCount).getHtmlString()%>
    </td>
    <td align="right">
      <%=pageBase.formatCurrHtml(dsTrn.getField(QryBO_Transaction.Sel.TotalAmount))%><br/>
      <span class="list-subtitle"><%=pageBase.formatCurrHtml(dsTrn.getField(QryBO_Transaction.Sel.PaidAmount))%></span>
    </td>
  </v:grid-row>
</v:grid>
</div>