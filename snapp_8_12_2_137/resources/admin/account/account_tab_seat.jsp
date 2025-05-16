<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.library.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>
<jsp:useBean id="account" class="com.vgs.snapp.dataobject.DOAccount" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
FtCRUD rightCRUD = (FtCRUD)request.getAttribute("rightCRUD");
boolean canEdit = rightCRUD.canUpdate(); 
%>

<v:tab-toolbar>
  <v:button-group>
    <v:button-group>
      <v:button id="btn-newsector" caption="@Common.New" fa="plus" dropdown="true" bindGrid="seat-sector-grid" bindGridEmpty="true" enabled="<%=canEdit%>"/>
  		<v:popup-menu bootstrap="true">
  		  <v:popup-item id="menu-new-capacity" fa="chart-pie-simple" caption="@Seat.SectorCapacity" />
  		  <v:popup-item id="menu-new-map" fa="loveseat" caption="@Seat.SectorSeat"/>
  		</v:popup-menu>
    </v:button-group>

    <v:button-group>
      <v:button id="btn-sectorstatus" caption="@Common.Status" fa="flag" dropdown="true" bindGrid="seat-sector-grid" enabled="<%=canEdit%>"/>
      <v:popup-menu bootstrap="true">
        <% for (LookupItem item : LkSN.SeatSectorStatus.getItems()) { %>
          <v:popup-item 
              id="<%=\"menu-sectorstatus-\" + item.getCode()%>"
              clazz="menu-sectorstatus" 
              icon="<%=item.getIconName()%>" 
              caption="<%=item.getRawDescription()%>" 
              attributes="<%=TagAttributeBuilder.builder().put(\"data-status\", item.getCode())%>"/>
        <% } %>
      </v:popup-menu>
    </v:button-group>
  
    <v:button id="btn-delsector" caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" onclick="deleteSeatSectors()" bindGrid="seat-sector-grid" enabled="<%=canEdit%>"/>
  </v:button-group>
    
  <span class="divider"></span>
  <v:button id="btn-importsector" caption="@Common.Import" fa="sign-in" bindGrid="seat-sector-grid" bindGridEmpty="true" enabled="<%=canEdit%>"/>

  <v:pagebox gridId="seat-sector-grid"/>
</v:tab-toolbar>


<v:tab-content>
  <% String params = "AccessAreaId=" + pageBase.getId(); %>
  <v:async-grid id="seat-sector-grid" jsp="seat/seat_sector_grid.jsp" params="<%=params%>"/>
</v:tab-content>

<script>

$(document).ready(function() {
  const ACCESS_AREA_ID = <%=JvString.jsString(pageBase.getId())%>
  
  $("#menu-new-capacity").click(_newCapacity);
  $("#menu-new-map").click(_newMap);
  $(".menu-sectorstatus").click(_updateSectorStatus);
  $("#btn-delsector").click(_deleteSector);
  $("#btn-importsector").click(_showImportDialog);
  
  function _newCapacity() {
    asyncDialogEasy("seat/seat_capacity_dialog", "id=new&AccessAreaId=" + ACCESS_AREA_ID);
  }
  
  function _newMap() {
    asyncDialogEasy("seat/seat_map_dialog", "id=new&AccessAreaId=" + ACCESS_AREA_ID);
  }

  function _updateSectorStatus() {
    snpAPI.cmd("Seat", "UpdateSectorStatus", {
      SeatSectorIDs: $("[name='SeatSectorId']").getCheckedValues(),
      SeatSectorStatus: $(this).attr("data-status")
    }).then(ansDO => 
      triggerEntityChange(<%=LkSNEntityType.SeatSector.getCode()%>)
    );
  }

  function _deleteSector() {
    confirmDialog(null, function() {
      snpAPI.cmd("Seat", "DeleteSector", {
        SeatSectorIDs: $("[name='SeatSectorId']").getCheckedValues()
      }).then(ansDO => 
        triggerEntityChange(<%=LkSNEntityType.SeatSector.getCode()%>)
      );
    });
  }

  function _showImportDialog() {
    vgsImportDialog("<v:config key="site_url"/>/admin?page=account&tab=seat&action=import-seatmap&id=<%=pageBase.getId()%>");
  }
});

</script>