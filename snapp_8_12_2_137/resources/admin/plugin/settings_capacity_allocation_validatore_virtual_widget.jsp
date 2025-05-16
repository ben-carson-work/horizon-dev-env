<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.web.library.seat.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="snp-tags" prefix="snp" %>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>
<jsp:useBean id="settings" class="com.vgs.entity.dataobject.DOPlgSettings_CapacityAllocationValidatorVirtual" scope="request"/>

<v:widget caption="@Common.Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
<div class="tab-content">
	<v:grid id="envelopes-grid" style="margin-bottom:10px">
    <thead>
      <tr class="header">
        <td><v:grid-checkbox header="true"/></td>
        <td width="40%"><v:itl key="@Category.Category"/></td>
        <td width="40%"><v:itl key="@Seat.Envelope"/></td>
        <td width="20%"><v:itl key="@SaleCapacity.QuantityFree"/></td>
      </tr>
    </thead>
    <tbody id="capacity-envelope-tbody">
    </tbody>
    <tbody>
      <tr>
        <td colspan="100%">
          <v:button id="btn-capacity-add" caption="@Common.Add" fa="plus"/>
          <v:button id="btn-capacity-del" caption="@Common.Remove" fa="minus"/>
        </td>
      </tr>
    </tbody>
    <tbody id="capacity-templates" class="hidden">
      <tr class="capacity-row-template">
        <td><v:grid-checkbox/></td>
        <td>
          <v:combobox 
              name="SeatCategoryId"
              lookupDataSet="<%=pageBase.getBL(BLBO_Seat.class).getSeatCategoryDS()%>" 
              idFieldName="AttributeItemId" 
              captionFieldName="AttributeItemName"
              allowNull="false"
          />
        </td>
        <td>
          <v:combobox 
              name="SeatEnvelopeId"
              lookupDataSet="<%=pageBase.getBL(BLBO_SeatEnvelope.class).getSeatEnvelopeDS()%>" 
              idFieldName="SeatEnvelopeId" 
              captionFieldName="SeatEnvelopeName"
              allowNull="false"
          />
        </td>
        <td><v:input-text field="QuantityFree"/></td>
      </tr>
    </tbody>
	</v:grid>
</div>
</v:widget>
 
<script>

$(document).ready(function() {
  var settings = <%=settings.getJSONString()%>;
  
  $("#btn-capacity-add").click(function() {
    addEnvelopRow(null, <%=JvString.jsString(pageBase.getBL(BLBO_SeatEnvelope.class).getDefaultEnvelopeId())%>, 0);
  });

  $("#btn-capacity-del").click(function() {
    $("#capacity-envelope-tbody .cblist:checked").closest("tr").remove();
  }); 
  
  if (settings.Envelopes != undefined) {
    for (var i=0; i<settings.Envelopes.length; i++) {
      var rule = settings.Envelopes[i];
      addEnvelopRow(rule.SeatCategoryId, rule.SeatEnvelopeId, rule.QuantityFree);
    }
  }
});

function addEnvelopRow(seatCategoryId, seatEnvelopeId, quantity) {
  var $tr = $("#capacity-templates .capacity-row-template").clone().appendTo("#capacity-envelope-tbody");
  if (seatCategoryId != null)
    $tr.find("#SeatCategoryId").val(seatCategoryId);
  $tr.find("#SeatEnvelopeId").val(seatEnvelopeId);
  $tr.find("#QuantityFree").val(quantity);
}

function getPluginSettings() {
  var settings = {};
  var envelopeRules = [];
  var capacityRules = $("#envelopes-grid tbody#capacity-envelope-tbody tr");
  for (var i=0; i<capacityRules.length; i++) {
    var itemFound = false;
    var rule = $(capacityRules[i]);
    
    var seatCategoryId = rule.find("#SeatCategoryId").val();
    var seatEnvelopeId = rule.find("#SeatEnvelopeId").val();
    var quantityFree = rule.find("#QuantityFree").val();

    $.each(envelopeRules, function(i, obj) {
      if (obj.SeatEnvelopeId == seatEnvelopeId && obj.SeatCategoryId == seatCategoryId) {
        itemFound = true;
        obj.QuantityFree = eval(obj.QuantityFree) + eval(quantityFree);
      }
    });
    
    if (!itemFound) {
      envelopeRules.push({
        "SeatCategoryId" : seatCategoryId,
        "SeatEnvelopeId": seatEnvelopeId,
        "QuantityFree": quantityFree,
      });
    }
  }
  settings.Envelopes = envelopeRules;
  
  return settings;
}

</script>
