<%@page import="com.vgs.entity.dataobject.DOPlgSettings_FolioVirtual.*"%>
<%@page import="com.vgs.snapp.library.SnappUtils"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.api.catalog.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>
<jsp:useBean id="settings" class="com.vgs.entity.dataobject.DOPlgSettings_FolioVirtual" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_Product.class)
    .addFilter(QryBO_Product.Fil.MembershipPluginId, plugin.PluginId.getString())
    .addSelect(
        QryBO_Product.Sel.ProductId,
        QryBO_Product.Sel.ProductCode,
        QryBO_Product.Sel.ProductName);

JvDataSet dsHotel = pageBase.execQuery(qdef);
List<String> missingHotelIDs = JvArray.asList(JvArray.map(settings.HotelList, it -> it.ProductId.getEmptyString().toLowerCase()));
%>

<div id="plugin-folio-virtual">
  
  <v:alert-box type="info">
    Are considered hotels all product types whose "membership plugin" matches this plugin
  </v:alert-box>
  
  <v:ds-loop dataset="<%=dsHotel%>">
    <% missingHotelIDs.remove(dsHotel.getField(QryBO_Product.Sel.ProductId).getEmptyString().toLowerCase()); %>
    <div class="hotel-container"
        data-productid="<%=dsHotel.getField(QryBO_Product.Sel.ProductId).getHtmlString()%>" 
        data-productcode="<%=dsHotel.getField(QryBO_Product.Sel.ProductCode).getHtmlString()%>" 
        data-productname="<%=dsHotel.getField(QryBO_Product.Sel.ProductName).getHtmlString()%>">
    </div>
  </v:ds-loop>
  
  <% for (DOFolioVirtualHotel hotel : settings.HotelList.filter(it -> it.ProductId.inArray(missingHotelIDs))) { %>
    <div class="hotel-container"
        data-missing="true" 
        data-productid="<%=hotel.ProductId.getHtmlString()%>" 
        data-productcode="<%=hotel.HotelCode.getHtmlString()%>" 
        data-productname="<%=hotel.HotelName.getHtmlString()%>">
    </div>
  <% } %>


  <div id="templates" class="hidden">
    
    <v:grid clazz="hotel-widget">
      <thead>
        <v:grid-title caption="DUMMY" icon="DUMMY"/>
        <tr>
          <td><v:grid-checkbox header="true"/></td>
          <td width="25%" nowrap>Folio ID <v:hint-handle hint="Folio unique (within the hotel) number"/></td>
          <td width="10%" nowrap>Room <v:hint-handle hint="Room number. ie: 101, 204, etc..."/></td>
          <td width="40%" nowrap>Guest <v:hint-handle hint="Guest name format: 'LastName, FirstName'"/></td>
          <td width="25%" nowrap>Max credit</td>
          <td nowrap>Charge</td>
        </tr>
      </thead>
      <tbody class="tbody-folios">
      </tbody>
      <tbody>
        <tr>
          <td colspan="100%">
            <v:button clazz="btn-folio-add" fa="plus" caption="@Common.Add"/>
            <v:button clazz="btn-folio-del" fa="minus" caption="@Common.Remove"/>
          </td>
        </tr>
      </tbody>
    </v:grid>
    
    <table>
      <tr class="grid-row folio-row">
        <td><v:grid-checkbox header="false"/></td>
        <td><v:input-text clazz="folio-number"/></td>
        <td><v:input-text clazz="folio-room"/></td>
        <td><v:input-text clazz="folio-guest"/></td>
        <td><v:input-text clazz="folio-credit"/></td>
        <td align="center"><v:db-checkbox clazz="folio-charge" field="" value="true" caption=""/></td>
      </tr>
    </table>

  </div>

</div>


<script>
$(document).ready(function() {
  var $plg = $("#plugin-folio-virtual");
  var $hotelTemplate = $plg.find("#templates .hotel-widget");
  var $folioTemplate = $plg.find("#templates .folio-row");
  
  $plg.find(".hotel-container").each(function(index, elem) {
    var $container = $(elem);
    var $hotel = $hotelTemplate.clone().appendTo($container);
    
    $hotel.find(".widget-title-caption").text($container.attr("data-productname"));
    if ($container.attr("data-missing") !== "true")
      $hotel.find(".widget-title-icon").remove();
    
    $hotel.find(".btn-folio-add").click(_onFolioAddClick);
    $hotel.find(".btn-folio-del").click(_onFolioDelClick);
  });
  
  $(document).von($plg, "plugin-settings-load", function(event, params) {
    var settings = params.settings || {};
    for (const hotel of (settings.HotelList || [])) {
      var $container = $plg.find(".hotel-container[data-productid='" + hotel.ProductId + "']");
      var $tbody = $container.find(".tbody-folios");
      for (const folio of (hotel.FolioList || [])) {
        var $folio = _addNewFolio($tbody);
        $folio.find(".folio-number").val(folio.FolioNumber);
        $folio.find(".folio-room").val(folio.RoomNumber);
        $folio.find(".folio-guest").val(folio.GuestName);
        $folio.find(".folio-credit").val(folio.CreditLimit);
        $folio.find(".folio-charge").setChecked(folio.ChargeAvailable);
      }
    }
  });
  
  $(document).von($plg, "plugin-settings-save", function(event, params) {
    params.settings = {
      "HotelList": []
    };

    $plg.find(".hotel-container").each(function(index, elem) {
      var $container = $(elem);
      var hotel = {
        "ProductId": $container.attr("data-productid"),
        "HotelCode": $container.attr("data-productcode"),
        "HotelName": $container.attr("data-productname"),
        "FolioList": []
      };
      params.settings.HotelList.push(hotel);
      
      $container.find(".folio-row").each(function(index, elem) {
        var $folio = $(elem);
        hotel.FolioList.push({
          "FolioNumber": $folio.find(".folio-number").val(),
          "RoomNumber": $folio.find(".folio-room").val(),
          "GuestName": $folio.find(".folio-guest").val(),
          "CreditLimit": _encodeAmount($folio.find(".folio-credit").val()),
          "ChargeAvailable": $folio.find(".folio-charge").isChecked()
        });
      });
      
      function _encodeAmount(text) {
        var amount = parseFloat((text || "").replace(",", "."));
        if (isNaN(amount))
          throw "Invalid amount: " + text;
        return text;
      }
    });
  });
  
  function _addNewFolio(tbody) {
    return $folioTemplate.clone().appendTo(tbody);
  }
  
  function _onFolioAddClick() {
    _addNewFolio($(this).closest(".hotel-widget").find(".tbody-folios"));
  }
  
  function _onFolioDelClick() {
    $(this).closest(".hotel-widget").find(".tbody-folios .cblist:checked").closest("tr").remove();
  }
});
</script>