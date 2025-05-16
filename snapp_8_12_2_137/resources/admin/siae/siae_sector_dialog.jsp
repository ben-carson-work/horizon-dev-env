<%@page import="com.vgs.snapp.query.QryBO_SiaeProduct"%>
<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@page import="com.vgs.web.tag.ConfigTag"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeSector.Sel"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeSector.Fil"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeSector"%>
<%@page import="com.vgs.snapp.query.QryBO_Product"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeOrganizer"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeEvent"%>
<%@page import="com.vgs.snapp.dataobject.DOEvent"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeLookup.*"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeOrganizer"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<style>
.siae-table {
  width: 100%;
}

.siae-table td {
  text-align: center;
  border: 1px solid black;
}

.image-button {
  cursor: pointer;
}
</style>

<%
BLBO_Siae bl = pageBase.getBL(BLBO_Siae.class);
BLBO_Event eventBl = pageBase.getBL(BLBO_Event.class);
DOEvent snappEvent = eventBl.loadEvent(pageBase.getId());
request.setAttribute("snappEvent", snappEvent);

boolean eventoInviti = snappEvent.SiaeEvent.EventoInviti.getBoolean();
String productCaption = eventoInviti ? "Prodotto" : "Prodotto con prezzo I1";

QueryDef qdef = new QueryDef(QryBO_SiaeSector.class);
//Select
qdef.addSelect(Sel.ProductId);
qdef.addSelect(Sel.ProductName);
qdef.addSelect(Sel.Capienza);
qdef.addSelect(Sel.SectorCode);
qdef.addSelect(Sel.CodeAndName);
//Filter
qdef.addFilter(Fil.ForEventId, pageBase.getId());
//Sort
qdef.addSort(QryBO_SiaeSector.Sel.SectorCode);
//Exec
JvDataSet sectorDs = pageBase.execQuery(qdef);

JvDataSet productsDs = pageBase.getBL(BLBO_Siae.class).getDefaultSectorProductDS(pageBase.getId(), eventoInviti);

qdef = new QueryDef(QryBO_SiaeSector.class);
//Select
qdef.addSelect(Sel.AllCodes);
qdef.addSelect(Sel.SectorCode);
qdef.addSelect(Sel.CodeAndName);
//Filter
qdef.addFilter(Fil.AllCodes, pageBase.getId());
//Sort
qdef.addSort(QryBO_SiaeSector.Sel.CodeAndName);
//Exec
JvDataSet ordiniDiPostoDs = pageBase.execQuery(qdef);

boolean isEnabled = bl.isSiaeEnabled();
%>

<v:dialog id="sector_dialog" icon="siae.png" title="Ordini di posto SIAE" width="800" height="780" autofocus="false">
<jsp:include page="/resources/admin/siae/siae_alert.jsp" />
<div class="profile-pic-div">
  <snp:profile-pic entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.Event%>" field="snappEvent.ProfilePictureId" enabled="false"/>
</div>

<div class="profile-cont-div">
<v:widget caption="Evento SIAE">
  <v:widget-block>
    <v:form-field caption="@Common.Code" mandatory="true">
      <v:input-text field="account.AccountCode" placeholder="<%=snappEvent.EventCode.getHtmlString()%>" enabled="false" />
    </v:form-field>
    <v:form-field caption="@Common.Name" mandatory="true">
      <snp:entity-link entityId="<%=snappEvent.EventId.getString()%>" entityType="<%=LkSNEntityType.Event%>">
        <%=snappEvent.EventName%>
      </snp:entity-link>
    </v:form-field>

  </v:widget-block>
</v:widget>

<v:widget caption="Ordini di Posto">
  <v:widget-block>
  <table class="siae-table" id="sector-table">
  <tr>
    <th>Ordine di Posto</th>
    <th>Prodotto</th>
    <th>Capienza</th>
    <th> </th>
  </tr>
  <% while (!sectorDs.isEof()) { %>
  <tr data-sectorcode="<%=sectorDs.getString(Sel.SectorCode)%>" data-sectortitle="<%=sectorDs.getString(Sel.CodeAndName)%>">
    <td><%=sectorDs.getString(Sel.SectorCode) %></td>
    <td><%=sectorDs.getString(Sel.ProductName) %></td>
    <td><%=sectorDs.getString(Sel.Capienza) %></td>
    <td><span class="image-button fa fa-lg fa-trash del-sector-btn"></span></td>
  </tr>
  <% sectorDs.next(); %>
  <% } %>
  </table>
  </v:widget-block>
</v:widget>

<v:widget caption="Crea nuovo">
  <v:widget-block>
    <v:form-field caption="Ordine di posto">
      <select id="sector-select" class="form-control">
       <% while (!ordiniDiPostoDs.isEof()) { %>
        <option value="<%=ordiniDiPostoDs.getString(Sel.SectorCode) %>"><%=ordiniDiPostoDs.getString(Sel.CodeAndName) %></option>
        <% ordiniDiPostoDs.next(); %>
       <% } %>
      </select>
    </v:form-field>
    <v:form-field caption="<%=productCaption%>">
      <select id="product-select" class="form-control">
        <% while (!productsDs.isEof()) { %>
          <option value="<%=productsDs.getString(QryBO_Product.Sel.ProductId) %>"><%=productsDs.getString(QryBO_Product.Sel.ProductName) %></option>
          <% productsDs.next(); %>
         <% } %>
      </select>
    </v:form-field>
    <v:form-field caption="Capienza">
      <input id="capacity-input" class="form-control" type="number" placeholder="1" min="1" step="1" />
    </v:form-field>
    <v:button id="add-btn" caption="Add" fa="plus"/>
  </v:widget-block>
</v:widget>
</div>
<script src="<v:config key="resources_url"/>/admin/script/siae.js"></script>
<script>

$(document).ready(function() {
  var dlg = $("#sector_dialog");
  
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        text: "Close",
        click: doCloseDialog
      }
    ];
    setTimeout(function() {
      $(".default-focus").focus();
    }, 1);
  });

  dlg.find("#add-btn").click(doAddEventSector);
  dlg.find("#sector-table .del-sector-btn").click(doDeleteEventSector);
  
  function doAddEventSector() {
    var productId = dlg.find("[id='product-select']").val();
    var productName = dlg.find("[id='product-select']").find(':selected').text();
    var sectorCode = dlg.find("[id='sector-select']").val();
    var sectorTitle = dlg.find("[id='sector-select']").find(':selected').text();
    var capacity = dlg.find("[id='capacity-input']").val() || 1;
    var sectorTable = dlg.find("[id='sector-table']");
    
    var reqDO = {
      Command: "AddEventSector",
      AddSector: {
        EventId: <%=JvString.jsString(pageBase.getId())%>,
        SectorCode: sectorCode,
        ProductId: productId,
        Capienza: capacity
      }
    };
    vgsService("Siae", reqDO, false, function(ansDO) {
      dlg.find("[id='sector-select']").find(':selected').remove();
      var $row = $('<tr/>');
      $row.attr("data-sectorcode", sectorCode);
      $row.attr("data-sectortitle", sectorTitle);
      $('<td>').text(sectorCode).appendTo($row);
      $('<td>').text(productName).appendTo($row);
      $('<td>').text(capacity).appendTo($row);
      var $td = $('<td>').appendTo($row);
      var $img = $("<span class='image-button fa fa-lg fa-trash'/>").appendTo($td);
      $img.click(doDeleteEventSector);
      $row.appendTo(sectorTable);
    });
  };

  function doDeleteEventSector() {
    var tr = $(this).closest("tr");
    var sectorCode = tr.attr("data-sectorcode");
    var sectorTitle = tr.attr("data-sectortitle");
    
  
    var reqDO = {
      Command: "DeleteEventSector",
      DeleteEventSector: {
        EventId: <%=JvString.jsString(pageBase.getId())%>,
        SectorCode: sectorCode
      }
    };
    vgsService("Siae", reqDO, false, function(ansDO) {
      tr.remove();
      $("<option>").val(sectorCode).text(sectorTitle).appendTo("#sector-select");
      sortOptions();
    });
  };
  
  function sortOptions() {
    var options = dlg.find('#sector-select option')
    var selected = dlg.find('#sector-select').val();
    options.sort(function(a, b) {
      if (a.text > b.text) return 1;
      else if (a.text < b.text) return -1;
      else return 0;
    });
    dlg.find('#sector-select').empty().append(options);
    dlg.find('#sector-select').val(selected);
  };
  
});


</script>
</v:dialog>