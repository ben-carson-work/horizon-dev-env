<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageWorkstation" scope="request"/>
<jsp:useBean id="wks" class="com.vgs.snapp.dataobject.DOWorkstation" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% 
boolean canEditWorkstationAndSetupDevices = rights.SystemSetupWorkstations.getOverallCRUD().canUpdate() && rights.SystemSetupWorkstationDevices.getBoolean();; 
%>

<v:tab-toolbar>
  <v:button-group>
    <v:button id="btn-newplugin" caption="@Common.New" fa="plus" bindGrid="plugin-grid" bindGridEmpty="true" enabled="<%=canEditWorkstationAndSetupDevices%>"/>
    
    <v:button-group>
      <v:button id="btn-status" caption="@Common.Status" fa="flag" dropdown="true" bindGrid="plugin-grid" enabled="<%=canEditWorkstationAndSetupDevices%>"/>
       <v:popup-menu bootstrap="true">
         <v:popup-item id="menu-status-enable" caption="@Common.Enable" href="javascript:updatePlugin(true)"/>
         <v:popup-item id="menu-status-disable" caption="@Common.Disable" href="javascript:updatePlugin(false)"/>
       </v:popup-menu>
    </v:button-group>

    <v:button id="btn-delplugin" caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" bindGrid="plugin-grid" enabled="<%=canEditWorkstationAndSetupDevices%>"/>
  </v:button-group>
  
  <v:pagebox gridId="plugin-grid"/>
</v:tab-toolbar>
    
<v:tab-content>
  <% String params = "WorkstationId=" + pageBase.getId(); %>
  <v:async-grid id="plugin-grid" jsp="plugin/plugin_grid.jsp" params="<%=params%>" />
</v:tab-content>

<script>
$(document).ready(function() {
  $("#btn-newplugin").click(_showDriverPickup);
  $("#btn-delplugin").click(_removePlugins);
  $("#menu-status-enable").click(() => _updateStatus(true));
  $("#menu-status-disable").click(() => _updateStatus(false));
  
  function _showDriverPickup() {
    <% if (wks.WorkstationType.isLookup(LkSNWorkstationType.POS, LkSNWorkstationType.VPS, LkSNWorkstationType.WEB, LkSNWorkstationType.KSK)) { %>
      asyncDialogEasy("plugin/driver_pickup_dialog", "DriverGroup=<%=LkSNDriverType.GROUP_Device%>,<%=LkSNDriverType.GROUP_ApplicationEvent%>");
    <% } else if (wks.WorkstationType.isLookup(LkSNWorkstationType.APT, LkSNWorkstationType.MOB)) { %>
      asyncDialogEasy("plugin/driver_pickup_dialog", "DriverGroup=<%=LkSNDriverType.GROUP_Device%>");
    <% } else if (wks.WorkstationType.isLookup(LkSNWorkstationType.BKO, LkSNWorkstationType.B2B, LkSNWorkstationType.CLC, LkSNWorkstationType.WPG)) { %>    
      asyncDialogEasy("plugin/driver_pickup_dialog", "DriverGroup=<%=LkSNDriverType.GROUP_ServerWorkstation%>");
    <% } %>    
  }     
  
  function _updateStatus(pluginEnabled) {
    snpAPI.cmd("Plugin", "UpdatePluginStatus", {
      PluginIDs: $("[name='PluginId']").getCheckedValues(),
      PluginEnabled: pluginEnabled
    }).then(ansDO =>
      triggerEntityChange(<%=LkSNEntityType.Plugin.getCode()%>)
    );
  }
  
  function _removePlugins() {
    confirmDialog(null, function() {
      snpAPI.cmd("Workstation", "RemovePlugin", {
        PluginIDs: $("[name='PluginId']").getCheckedValues()
      }).then(ansDO =>
        triggerEntityChange(<%=LkSNEntityType.Plugin.getCode()%>)
      );
    });
  }
});

function driverPickupCallback(driverId) {
  asyncDialogEasy("plugin/plugin_dialog", "id=new&DriverId=" + driverId + "&WorkstationId=<%=pageBase.getId()%>");
}
  
</script>
