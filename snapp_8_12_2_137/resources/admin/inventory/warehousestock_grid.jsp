<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_WarehouseStock.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_WarehouseStock.class);
// Select
qdef.addSelect(Sel.ProductIconName);
qdef.addSelect(Sel.ProductProfilePictureId);
qdef.addSelect(Sel.ProductEntityType);
qdef.addSelect(Sel.ProductId);
qdef.addSelect(Sel.ProductCode);
qdef.addSelect(Sel.ProductName);
qdef.addSelect(Sel.Quantity);
qdef.addSelect(Sel.MeasureName);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Filter
qdef.addFilter(Fil.WarehouseId, pageBase.getParameter("WarehouseId"));
// Sort
qdef.addSort(Sel.ProductName);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.InventoryStock%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
      <td width="50%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Code"/>
      </td>
      <td align="right" width="50%">
        <v:itl key="@Common.Quantity"/>
      </td>
    </tr>
  </thead>
  <tbody>
    <v:grid-row dataset="ds">
      <td><v:grid-checkbox name="WarehouseId" dataset="ds" fieldname="WarehouseId"/></td>
      <td><v:grid-icon name="<%=ds.getField(Sel.ProductIconName).getString()%>" repositoryId="<%=ds.getField(Sel.ProductProfilePictureId).getString()%>"/></td>
      <td>
        <snp:entity-link entityId="<%=ds.getField(Sel.ProductId)%>" entityType="<%=ds.getField(Sel.ProductEntityType)%>" clazz="list-title">
          <%=ds.getField(Sel.ProductName).getHtmlString()%>
        </snp:entity-link>
        <br/>
        <span class="list-subtitle"><%=ds.getField(Sel.ProductCode).getHtmlString()%></span>
      </td>
      <td align="right">
        <%=ds.getField(Sel.Quantity).getHtmlString()%><br/>
        <span class="list-subtitle"><%=ds.getField(Sel.MeasureName).getHtmlString()%></span>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>
    