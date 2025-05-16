<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_TransactionStock.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_TransactionStock.class);
// Select
qdef.addSelect(Sel.ProductIconName);
qdef.addSelect(Sel.ProductProfilePictureId);
qdef.addSelect(Sel.ProductEntityType);
qdef.addSelect(Sel.ProductId);
qdef.addSelect(Sel.ProductCode);
qdef.addSelect(Sel.ProductName);
qdef.addSelect(Sel.WarehouseId);
qdef.addSelect(Sel.WarehouseCode);
qdef.addSelect(Sel.WarehouseName);
qdef.addSelect(Sel.WarehouseLocationId);
qdef.addSelect(Sel.WarehouseLocationCode);
qdef.addSelect(Sel.WarehouseLocationName);
qdef.addSelect(Sel.Quantity);
qdef.addSelect(Sel.MeasureId);
qdef.addSelect(Sel.MeasureName);
qdef.addSelect(Sel.FaceQuantity);
qdef.addSelect(Sel.FaceMeasureId);
qdef.addSelect(Sel.FaceMeasureName);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Filter
qdef.addFilter(Fil.TransactionId, pageBase.getParameter("TransactionId"));
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
      <td width="20%">
        <v:itl key="@Product.ProductType"/><br/>
        <v:itl key="@Common.Code"/>
      </td>
      <td width="20%">
        <v:itl key="@Account.Location"/><br/>
        <v:itl key="@Common.Warehouse"/>
      </td>
      <td align="right" width="60%">
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
      <td>
        <snp:entity-link entityId="<%=ds.getField(Sel.WarehouseLocationId)%>" entityType="<%=LkSNEntityType.Location%>">
          <%=ds.getField(Sel.WarehouseLocationName).getHtmlString()%>
        </snp:entity-link>
        <br/>
        <snp:entity-link entityId="<%=ds.getField(Sel.WarehouseId)%>" entityType="<%=LkSNEntityType.Warehouse%>">
          <%=ds.getField(Sel.WarehouseName).getHtmlString()%>
        </snp:entity-link>
      </td>
      <td align="right">
        <% String color = (ds.getField(Sel.Quantity).getMoney() < 0) ? "var(--base-red-color)" : "var(--base-green-color)"; %>
        <%=ds.getField(Sel.MeasureName).getHtmlString()%> <span style="color:<%=color%>"><%=ds.getField(Sel.Quantity).getHtmlString()%></span><br/>
        <% if (!ds.getField(Sel.MeasureId).isSameString(ds.getField(Sel.FaceMeasureId)) || (ds.getField(Sel.Quantity).getMoney() != ds.getField(Sel.FaceQuantity).getMoney())) { %>
          <span class="list-subtitle"><%=ds.getField(Sel.FaceMeasureName).getHtmlString()%> <%=ds.getField(Sel.FaceQuantity).getHtmlString()%></span>
        <% } %>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>
    