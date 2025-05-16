<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Sale.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.b2b.page.PageB2B_Dashboard" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_Sale.class);
// Select
qdef.addSelect(Sel.SaleId);
qdef.addSelect(Sel.SaleCode);
qdef.addSelect(Sel.SaleDateTime);
qdef.addSelect(Sel.SaleB2BStatus);
qdef.addSelect(Sel.ItemCount);
qdef.addSelect(Sel.TotalAmount);
// Filter
qdef.addFilter(Fil.AccountId, pageBase.getSession().getOrgAccountId());
// Sort
qdef.addSort(Sel.SaleDateTime, false);
// Paging
qdef.pagePos = 1;
qdef.recordPerPage = 5;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
%>

<v:grid>
  <v:grid-title caption="@Sale.LastSales"/>
  <v:grid-row dataset="<%=ds%>">
    <td width="50%">
      <snp:entity-link entityId="<%=ds.getField(Sel.SaleId).getString()%>" entityType="<%=LkSNEntityType.Sale%>" clazz="list-title">
        <%=ds.getField(Sel.SaleCode).getHtmlString()%>
      </snp:entity-link>
      <br/>
      <snp:datetime timestamp="<%=ds.getField(Sel.SaleDateTime)%>" format="shortdatetime" timezone="local" clazz="list-subtitle"/>
    </td>
    <td width="50%" align="right">
      <%=pageBase.formatCurrHtml(ds.getField(Sel.TotalAmount))%><br/>
      <% LookupItem saleB2BStatus = LkSN.SaleB2BStatus.getItemByCode(ds.getField(Sel.SaleB2BStatus)); %>
      <span class="list-subtitle"><%=saleB2BStatus.getHtmlDescription(pageBase.getLang())%></span>
    </td>
  </v:grid-row>
  <tr class="grid-row">
    <td colspan="100%" align="center"><a href="<v:config key="site_url"/>/b2b?page=sale_list" class="list-title"><v:itl key="@Common.ViewAll"/></a></td>
  </tr>
</v:grid>
