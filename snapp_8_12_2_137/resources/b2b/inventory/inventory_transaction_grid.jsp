<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_TransactionAccountInventory.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_TransactionAccountInventory.class);
// Select
qdef.addSelect(Sel.Quantity);
qdef.addSelect(Sel.SaleId);
qdef.addSelect(Sel.SaleCode);
qdef.addSelect(Sel.SaleB2BStatus);
qdef.addSelect(Sel.TransactionDateTime);
qdef.addSelect(Sel.TransactionFiscalDate);
qdef.addSelect(Sel.UserAccountName);
qdef.addSelect(Sel.UserAccountParentId);
qdef.addSelect(Sel.ShipAccountId);
qdef.addSelect(Sel.ShipAccountName);

// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Where
qdef.addFilter(Fil.AccountInventoryBalanceId, pageBase.getEmptyParameter("AccountInventoryBalanceId"));
// Sort
qdef.addSort(Sel.TransactionDateTime, false);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid id="inventory-transaction-grid" dataset="<%=ds%>" qdef="<%=qdef%>">
  <thead>
    <tr>
      <td></td>
      <td width="150px" nowrap>
        <v:itl key="@Sale.PNR"/><br/>
        <v:itl key="@Common.DateTime"/>
      </td>
      <td width="120px" nowrap>
        <v:itl key="@Common.Status"/>
      </td>
      <td width="100%">
        <v:itl key="@Account.Account"/><br/>
        <v:itl key="@Common.User"/>
      </td>
      <td width="120px" align="right" nowrap>
        <v:itl key="@Common.Quantity"/>
      </td>
    </tr>
  </thead>
  
  <tbody>
    <v:grid-row dataset="ds" dateGroupFieldName="<%=Sel.TransactionFiscalDate.name()%>">
      <td><v:grid-icon name="order.png"/></td>
      <td nowrap>
        <snp:entity-link entityType="<%=LkSNEntityType.Sale%>" entityId="<%=ds.getField(Sel.SaleId)%>">
          <%=ds.getField(Sel.SaleCode).getHtmlString()%>
        </snp:entity-link>
        <br/>
        <snp:datetime timestamp="<%=ds.getField(Sel.TransactionDateTime)%>" format="shortdatetime" timezone="local" clazz="list-subtitle"/>
      </td>
      <td nowrap>
        <% LookupItem saleB2BStatus = LkSN.SaleB2BStatus.getItemByCode(ds.getField(Sel.SaleB2BStatus)); %>
        <%=saleB2BStatus.getHtmlDescription(pageBase.getLang())%>
      </td>
      <td>
	      <%=ds.getField(Sel.ShipAccountId).isNull() ? "-" : ds.getField(Sel.ShipAccountName).getHtmlString()%><br/>
	      <% if (ds.getField(Sel.UserAccountParentId).isSameString(pageBase.getSession().getOrgAccountId())) { %>
	        <span class="list-subtitle"><%=ds.getField(Sel.UserAccountName).getHtmlString()%></span>
	      <% } %>&nbsp;
      </td>
      <td align="right" nowrap>
        <%
          int qty = ds.getField(Sel.Quantity).getInt();
          String color = (qty > 0) ? "" : "color:#ff0000";
        %>
        <span style="<%=color%>"><%=qty%></span>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>