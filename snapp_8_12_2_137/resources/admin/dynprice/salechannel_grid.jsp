<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
QueryDef qdef = new QueryDef(QryBO_SaleChannel.class);
// Select
qdef.addSelect(QryBO_SaleChannel.Sel.IconName);
qdef.addSelect(QryBO_SaleChannel.Sel.SaleChannelId);
qdef.addSelect(QryBO_SaleChannel.Sel.SaleChannelCode);
qdef.addSelect(QryBO_SaleChannel.Sel.SaleChannelName);
qdef.addSelect(QryBO_SaleChannel.Sel.SaleChannelType);
qdef.addSelect(QryBO_SaleChannel.Sel.ValidFrom);
qdef.addSelect(QryBO_SaleChannel.Sel.ValidTo);
qdef.addSelect(QryBO_SaleChannel.Sel.PriceActionType);
qdef.addSelect(QryBO_SaleChannel.Sel.PriceValueType);
qdef.addSelect(QryBO_SaleChannel.Sel.PriceValue);
qdef.addSelect(QryBO_SaleChannel.Sel.UpgradeFromFacePrice);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Sort
qdef.addSort(QryBO_SaleChannel.Sel.SaleChannelName);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid id="salechannel-grid-table" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.SaleChannel%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="20%">
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.Code"/>
    </td>
    <td width="20%">
      <v:itl key="@SaleChannel.Distribution"/><br/>
      <v:itl key="@Common.Validity"/>
    </td>
    <td width="60%">
      <v:itl key="@Product.PriceRule"/>
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <td><v:grid-checkbox name="cbSaleChannelId" dataset="ds" fieldname="SaleChannelId"/></td>
    <td><v:grid-icon name="<%=ds.getField(QryBO_SaleChannel.Sel.IconName).getString()%>"/></td>
    <td>
      <div>
        <snp:entity-link entityId="<%=ds.getField(QryBO_SaleChannel.Sel.SaleChannelId)%>" entityType="<%=LkSNEntityType.SaleChannel%>" clazz="list-title">
          <%=ds.getField(QryBO_SaleChannel.Sel.SaleChannelName).getHtmlString()%>
        </snp:entity-link>
      </div>
      <div class="list-subtitle"><%=ds.getField(QryBO_SaleChannel.Sel.SaleChannelCode).getHtmlString()%></div>
    </td>
    <td>
      <%=LkSN.SaleChannelType.getItemDescription(ds.getField(QryBO_SaleChannel.Sel.SaleChannelType).getInt())%><br/>
      <% String unlimited = pageBase.getLang().Common.Unlimited.getText(); %>
      <span class="list-subtitle"><%=ds.getField(QryBO_SaleChannel.Sel.ValidFrom).isNull(unlimited)%> - <%=ds.getField(QryBO_SaleChannel.Sel.ValidTo).isNull(unlimited)%></span>
    </td>
    <td>
      <% int actionType = ds.getField(QryBO_SaleChannel.Sel.PriceActionType).getInt(); %>
      <% int valueType = ds.getField(QryBO_SaleChannel.Sel.PriceValueType).getInt(); %>
      <% if (actionType == LkSNPriceActionType.NotSellable.getCode()) { %>
        <span class="list-subtitle"><v:itl key="@Common.None"/></span>
      <% } else { %>
        <%=BLBO_PriceRule.getActionSymbol(actionType)%> <%=ds.getField(QryBO_SaleChannel.Sel.PriceValue).getHtmlString()%><%=BLBO_PriceRule.getValueSymbol(valueType)%>
      <% } %>
    </td>
  </v:grid-row>
</v:grid>
