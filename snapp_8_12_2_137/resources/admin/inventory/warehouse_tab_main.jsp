<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageWarehouse" scope="request"/>
<jsp:useBean id="warehouse" class="com.vgs.snapp.dataobject.DOWarehouse" scope="request"/>
<% boolean canEdit = true; %>

<div class="tab-toolbar">
  <v:button caption="@Common.Save" fa="save" enabled="<%=canEdit%>" href="javascript:doSaveWarehouse()"/>
  <snp:notes-btn entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.Warehouse%>"/>
</div>

<div class="tab-content">
  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:form-field caption="@Common.Code" mandatory="true">
        <v:input-text field="warehouse.WarehouseCode" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Common.Name" mandatory="true">
        <v:input-text field="warehouse.WarehouseName" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
</div>

<script>
function doSaveWarehouse() {
  var reqDO = {
    Command: "SaveWarehouse",
    SaveWarehouse: {
      Warehouse: {
        WarehouseId: <%=warehouse.WarehouseId.getJsString()%>,
        LocationId: <%=warehouse.LocationId.getJsString()%>,
        WarehouseCode: $("#warehouse\\.WarehouseCode").val(),
        WarehouseName: $("#warehouse\\.WarehouseName").val()
      }
    }
  };
  
  vgsService("Inventory", reqDO, false, function(ansDO) {
    showMessage(<v:itl key="@Common.SaveSuccessMsg" encode="JS"/>, function() {
      <% if (warehouse.WarehouseId.isNull()) { %>
        window.location = "<v:config key="site_url"/>/admin?page=warehouse&id=" + ansDO.Answer.SaveWarehouse.WarehouseId;
      <% } else { %>
        window.location.reload();
      <% } %>
    });
  });
}
</script>