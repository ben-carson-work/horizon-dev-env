<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>
<jsp:useBean id="account" scope="request" class="com.vgs.snapp.dataobject.DOAccount"/>

<script>

function deleteWarehouses() {
  var ids = $("[name='WarehouseId']").getCheckedValues();
  if (ids == "")
    showMessage(<v:itl key="@Common.NoElementWasSelected" encode="JS"/>);
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeleteWarehouse",
        DeleteWarehouse: {
          WarehouseIDs: ids
        }
      };
      
      vgsService("Inventory", reqDO, false, function() {
        triggerEntityChange(<%=LkSNEntityType.Warehouse.getCode()%>);
      });
    });
  }
}
</script>

<div class="tab-toolbar">
  <% String hrefNew = ConfigTag.getValue("site_url") + "/admin?page=warehouse&id=new&LocationId=" + pageBase.getId(); %>
  <v:button fa="plus" caption="@Common.New" href="<%=hrefNew%>"/>
  <v:button fa="trash" caption="@Common.Delete" href="javascript:deleteWarehouses()"/>

  <v:pagebox gridId="warehouse-grid"/>
</div>

<div class="tab-content">
  <% String params = "LocationId=" + pageBase.getId(); %>
  <v:async-grid id="warehouse-grid" jsp="inventory/warehouse_grid.jsp" params="<%=params%>" />
</div>

