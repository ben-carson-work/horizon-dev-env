<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageWarehouse" scope="request"/>
<jsp:useBean id="warehouse" class="com.vgs.snapp.dataobject.DOWarehouse" scope="request"/>
<% boolean canLoadInventory = pageBase.getRights().WarehouseLoad.getBoolean();%>

<script>
function doSearch() {
  changeGridPage("#warehousestock-grid", "first");
}
</script>

<div class="tab-toolbar">
  <v:button caption="@Common.Refresh" fa="sync-alt" href="javascript:doSearch()"/>
  <% String hrefTransaction = "javascript:asyncDialogEasy('inventory/stock_transaction_dialog', 'id=" + pageBase.getId() + "')"; %>
  <v:button caption="@Common.Transaction" fa="cog" href="<%=hrefTransaction%>" enabled="<%=canLoadInventory%>"/>

  <v:pagebox gridId="warehousestock-grid"/>
</div>

<div class="tab-content">
  <% String params = "WarehouseId=" + pageBase.getId(); %>
  <v:async-grid id="warehousestock-grid" jsp="inventory/warehousestock_grid.jsp" params="<%=params%>" />
</div>
