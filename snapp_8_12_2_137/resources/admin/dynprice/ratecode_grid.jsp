<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_RateCode.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_RateCode.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.RateCodeId);
qdef.addSelect(Sel.RateCodeCode);
qdef.addSelect(Sel.RateCodeName);
qdef.addSelect(Sel.RateCodeSymbol);
qdef.addSelect(Sel.PriceActionType);
qdef.addSelect(Sel.PriceValueType);
qdef.addSelect(Sel.PriceValue);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Sort
qdef.addSort(Sel.RateCodeName);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid id="ratecode-grid-table" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.RateCode%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="60%">
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.Code"/>
    </td>
    <td width="40%" align="right">
      <v:itl key="@Product.PriceRule"/>
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <td><v:grid-checkbox name="RateCodeId" dataset="ds" fieldname="RateCodeId"/></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.RateCodeId).getString()%>" entityType="<%=LkSNEntityType.RateCode%>" clazz="list-title"><%=ds.getField(Sel.RateCodeName).getHtmlString()%></snp:entity-link><br/>
      <span class="list-subtitle">
        <% if (!ds.getField(Sel.RateCodeSymbol).isNull()) { %>
          <i class="fa fa-<%=ds.getField(Sel.RateCodeSymbol).getHtmlString()%>"></i>
        <% } %>
        <%=ds.getField(Sel.RateCodeCode).getHtmlString()%>
      </span>
    </td>
    <td align="right">
      <% int actionType = ds.getField(Sel.PriceActionType).getInt(); %>
      <% int valueType = ds.getField(Sel.PriceValueType).getInt(); %>
      <% if (actionType == LkSNPriceActionType.NotSellable.getCode()) { %>
        <span class="list-subtitle"><v:itl key="@Common.None"/></span>
      <% } else { %>
        <%=BLBO_PriceRule.getActionSymbol(actionType)%> <%=ds.getField(Sel.PriceValue).getHtmlString()%><%=BLBO_PriceRule.getValueSymbol(valueType)%>
      <% } %>
    </td>
  </v:grid-row>
</v:grid>
