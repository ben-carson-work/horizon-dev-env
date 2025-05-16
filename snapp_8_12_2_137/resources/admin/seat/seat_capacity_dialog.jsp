<%@page import="com.vgs.snapp.library.SnappUtils"%>
<%@page import="com.vgs.web.library.seat.BLBO_SeatEnvelope"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.library.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%
BLBO_Seat bl = pageBase.getBL(BLBO_Seat.class);
String performanceId = pageBase.getNullParameter("PerformanceId");
String accessAreadId = pageBase.getNullParameter("AccessAreaId");
DOSeatCapacityDialogInfo capacityInfo = bl.loadSeatCapacityDialogInfo(pageBase.getId(), performanceId, accessAreadId, pageBase.isNewItem());
request.setAttribute("capacity", capacityInfo.CapacitySector);
%>

<v:dialog id="seat_capacity_dialog" title="@Seat.SectorCapacity" width="800" height="600" autofocus="false">
  
  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:form-field caption="@Common.Name">
        <v:input-text field="capacity.SeatSectorName" enabled="<%=performanceId == null && capacityInfo.CanEditConf.getBoolean()%>"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
  <v:grid>
    <thead>
      <tr class="header">
        <td><v:grid-checkbox header="true"/></td>
        <td width="40%"><v:itl key="@Seat.Category"/></td>
        <td width="40%"><v:itl key="@Seat.Envelope"/></td>
        <td width="20%"><v:itl key="@Common.Quantity"/></td>
        <% if (performanceId != null) { %>
          <td><v:itl key="@Seat.Counter_Reserved"/></td>
          <td><v:itl key="@Seat.Counter_Avail"/></td>
          <td nowrap><v:itl key="@Common.Enabled"/> <v:hint-handle hint="@Performance.CapacitySlotEnabledHint"/></td>
        <% } %>
      </tr>
    </thead>
    <tbody id="capacity-category-tbody">
    </tbody>
    <% if (capacityInfo.CanEditConf.getBoolean()) { %>
      <tbody>
        <tr>
          <td colspan="100%">
            <v:button id="btn-capacity-add" caption="@Common.Add" fa="plus"/>
            <v:button id="btn-capacity-del" caption="@Common.Remove" fa="minus"/>
          </td>
        </tr>
      </tbody>
    <% } %>
    <tbody id="capacity-templates" class="hidden">
      <tr class="capacity-row-template">
        <td><v:grid-checkbox/></td>
        <td>
          <v:combobox 
              name="SeatCategoryId"
              lookupDataSet="<%=pageBase.getBL(BLBO_Seat.class).getSeatCategoryDS()%>" 
              idFieldName="AttributeItemId" 
              captionFieldName="AttributeItemName" 
              groupFieldName="AttributeId" 
              groupLabelFieldName="AttributeName"
              allowNull="false"
              enabled="<%=capacityInfo.CanEditConf.getBoolean()%>"
          />
        </td>
        <td>
          <v:combobox 
              name="SeatEnvelopeId"
              lookupDataSet="<%=pageBase.getBL(BLBO_SeatEnvelope.class).getSeatEnvelopeDS()%>" 
              idFieldName="SeatEnvelopeId" 
              captionFieldName="SeatEnvelopeName"
              allowNull="false"
              enabled="<%=capacityInfo.CanEditConf.getBoolean()%>"
          />
        </td>
        <td><v:input-text field="Quantity" enabled="<%=capacityInfo.CanEditQty.getBoolean()%>"/></td>
        <%
        if (performanceId != null) {
        %>
          <td align="right"><span class="qty-reserved"></span></td>
          <td align="right"><span class="qty-free"></span></td>
          <td align="right"><input type="checkbox" class="seat-available" <%=capacityInfo.CanEditQty.getBoolean() ? "" : " disabled='disabled'"%>></td>
        <% } %>
      </tr>
    </tbody>
    
  </v:grid>

<script>
$(document).ready(function() {
  var $dlg = $("#seat_capacity_dialog");
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        text: itl("@Common.Save"),
        click: doSaveCapacity,
        disabled: <%= !capacityInfo.CanEditConf.getBoolean() && !capacityInfo.CanEditQty.getBoolean() %>
      },
      {
        text: itl("@Common.Cancel"),
        click: doCloseDialog
      }
    ]; 
  });

  function addCategoryRow(seatCategoryId, seatEnvelopeId, available, quantity, qtyFree) {
    var $tr = $dlg.find("#capacity-templates .capacity-row-template").clone().appendTo("#capacity-category-tbody");
    $tr.find("[name='SeatCategoryId']").val(seatCategoryId);
    $tr.find("[name='SeatEnvelopeId']").val(seatEnvelopeId);
    $tr.find("[name='Quantity']").val(quantity);
    $tr.find(".seat-available").setChecked(available !== false);
    
    if (getNull(qtyFree) != null) {
      $tr.find(".qty-reserved").text(quantity - qtyFree);
      $tr.find(".qty-free").text(qtyFree);
    }
  }
  
  $dlg.find("#btn-capacity-add").click(function() {
    addCategoryRow(null, <%=JvString.jsString(pageBase.getBL(BLBO_SeatEnvelope.class).getDefaultEnvelopeId())%>, true, 1);
  });
  
  $dlg.find("#btn-capacity-del").click(function() {
    $dlg.find("#capacity-category-tbody .cblist:checked").closest("tr").remove();
  }); 

  <% for (DOSeatCapacitySector.DOSeatCapacityQuantity qtyDO : capacityInfo.CapacitySector.CapacityQuantityList) { %>
    <% if (qtyDO.Quantity.getInt() > 0) { %>
      addCategoryRow(<%=qtyDO.SeatCategoryId.getJsString()%>, <%=qtyDO.SeatEnvelopeId.getJsString()%>, <%=qtyDO.Available.getBoolean()%>, <%=qtyDO.Quantity.getInt()%>, <%=qtyDO.QuantityFree.getInt()%>);
    <% } %>
  <% } %>
  
  function doSaveCapacity() {
    var reqDO = {
      Command: "SaveCapacitySector",
      SaveCapacitySector: {
        CapacitySector: {
          SeatSectorId: <%=capacityInfo.CapacitySector.SeatSectorId.getJsString()%>,
          SeatSectorName: $("#capacity\\.SeatSectorName").val(),
          AccessAreaId: <%=JvString.jsString(pageBase.getNullParameter("AccessAreaId"))%>,
          PerformanceId: <%=JvString.jsString(performanceId)%>,
          CapacityQuantityList: []
        }
      }
    };
    
    $("#capacity-category-tbody tr").each(function() {
      var $tr = $(this);
      reqDO.SaveCapacitySector.CapacitySector.CapacityQuantityList.push({
        SeatCategoryId: $tr.find("[name='SeatCategoryId']").val(),
        SeatEnvelopeId: $tr.find("[name='SeatEnvelopeId']").val(),
        Quantity: $tr.find("[name='Quantity']").val(),
        Available: $tr.find(".seat-available").isChecked()
      });
    });
    
    showWaitGlass();
    vgsService("Seat", reqDO, false, function(ansDO) {
      hideWaitGlass();
      triggerEntityChange(<%=LkSNEntityType.SeatSector.getCode()%>);
      <% if (performanceId != null) { %>
        triggerEntityChange(<%=LkSNEntityType.Performance.getCode()%>, <%=JvString.jsString(performanceId)%>);
      <% } %>
      $dlg.dialog("close");
    });
  }
});
</script>

</v:dialog>


