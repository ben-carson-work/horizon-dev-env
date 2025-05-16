<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<v:dialog id="stock_transaction_dialog" title="@Common.Transaction" width="800" height="600" autofocus="false">

  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:form-field caption="@Common.Type">
        <label class="checkbox-label"><input type="radio" name="InventoryType" value="load" checked="checked"/> <v:itl key="@Common.InventoryLoad"/></label>
        &nbsp;
        <label class="checkbox-label"><input type="radio" name="InventoryType" value="unload"/> <v:itl key="@Common.InventoryUnload"/></label>
      </v:form-field>
      <v:form-field id="invtrn-srcdst" caption="@Common.Source">
        <% JvDataSet dsWarehouse = pageBase.getBL(BLBO_Inventory.class).getWarehouseDS(); %>
        <v:combobox field="invtrn-TargetWarehouseId" lookupDataSet="<%=dsWarehouse%>" idFieldName="WarehouseId" captionFieldName="WarehouseName" groupFieldName="LocationId" groupLabelFieldName="LocationName" />
      </v:form-field>
      <v:form-field caption="@Common.Notes">
        <input type="text" id="invtrn-note" class="form-control"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:db-checkbox field="cbConvertMeasure" value="true" checked="true" caption="@Product.ConvertToBaseMeasure" hint="@Product.ConvertToBaseMeasureHint"/>
    </v:widget-block>
  </v:widget>
  
  <v:grid>
    <thead>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td width="50%"><v:itl key="@Product.ProductType"/></td>
        <td width="25%"><v:itl key="@Product.Measure"/></td>
        <td width="25%"><v:itl key="@Common.Quantity"/></td>
      </tr>
    </thead>
    <tbody id="invtrn-items-tbody"></tbody>
    <tbody>
      <tr>
        <td colspan="100%">
          <v:button id="btn-add" caption="@Common.Add" fa="plus"/>
          <v:button id="btn-del" caption="@Common.Remove" fa="minus"/>
        </td>
      </tr>
    </tbody>
  </v:grid>
  
<div id="templates" class="hidden">
  <v:combobox
      name="MeasureId"
      lookupDataSet="<%=pageBase.getBL(BLBO_Measure.class).getMeasureDS()%>" 
      idFieldName="MeasureId"
      captionFieldName="MeasureName" 
      enabledFieldName="Enabled"
      allowNull="false"/>
</div>

<script>

$(document).ready(function() {
  var dlg = $("#stock_transaction_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {
      <v:itl key="@Common.Save" encode="JS"/>: doSaveTransaction,
      <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
    };
  });

  function isLoadTransaction() {
    return dlg.find("[name='InventoryType']:checked").val() == "load";
  }

  dlg.find("[name='InventoryType']").click(function() {
    $("#invtrn-srcdst .form-field-caption").html(isLoadTransaction() ? <v:itl key="@Common.Source" encode="JS"/> : <v:itl key="@Common.Destination" encode="JS"/>);
  });
  
  dlg.find("#btn-add").click(function() {
    showLookupDialog({
      EntityType: <%=LkSNEntityType.ProductType.getCode()%>,
      ProductParams: {
        ProductTypes: "<%=LkSNProductType.Product.getCode()%>,<%=LkSNProductType.Material.getCode()%>",
        InventoryOnly: true
      },
      onPickup: doAddInvProduct
    });
  });
  
  dlg.find("#btn-del").click(function() {
    dlg.find("#invtrn-items-tbody .cblist:checked").parents("tr").remove();
  });

  function doAddInvProduct(item) {
    if (dlg.find("#invtrn-items-tbody [data-ProductId='" + item.ItemId + "']").length == 0) {
      var tr = $("<tr data-ProductId='" + item.ItemId + "'/>").appendTo("#invtrn-items-tbody");
      $("<td><input type='checkbox' class='cblist'/></td>").appendTo(tr);
      $("<td/>").appendTo(tr).append("[" + escapeHtml(item.ItemCode) + "] " + escapeHtml(item.ItemName));
      $("<td/>").appendTo(tr).append($("#templates [name='MeasureId']").clone());
      $("<td><input type='text' name='Quantity' placeholder='0' class='form-control'/></td>").appendTo(tr);
    }
  }

  function doSaveTransaction() {
    var reqDO = {
      Command: "CreateInventoryTransaction",
      CreateInventoryTransaction: {
        InventoryTransactionType: isLoadTransaction() ? <%=LkSNInventoryTransactionType.Load.getCode()%> : <%=LkSNInventoryTransactionType.Unload.getCode()%>,
        WarehouseId: <%=JvString.jsString(pageBase.getId())%>,
        TargetWarehouseId: dlg.find("#invtrn-TargetWarehouseId").val(),
        Note: dlg.find("#invtrn-note").val(),
        ConvertToBaseMeasure: dlg.find("#cbConvertMeasure").isChecked(),
        ItemList: []
      }
    };
    
    dlg.find("#invtrn-items-tbody tr").each(function(idx, tr) {
      var $tr = $(tr);
      var qty = strToIntDef($tr.find("[name='Quantity']").val(), 0);
      if (qty != 0) {
        reqDO.CreateInventoryTransaction.ItemList.push({
          ProductId: $tr.attr("data-ProductId"),
          MeasureId: $tr.find("[name='MeasureId']").val(),
          Quantity: qty
        });
      }
    });

    showWaitGlass();
    vgsService("Inventory", reqDO, false, function(ansDO) {
      hideWaitGlass();

      triggerEntityChange(<%=LkSNEntityType.InventoryStock.getCode()%>);
      dlg.dialog("close");
    });
  }
  
});
</script>

</v:dialog>