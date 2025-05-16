<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
  boolean canEdit = rights.SuperUser.getBoolean() || rights.ExtensionPackages.canUpdate();
%>

<div class="tab-toolbar">
  <v:button caption="@Common.Search" fa="search" onclick="search()"/>
  <span class="divider"></span>
  <div class="btn-group">
		<v:button caption="@Common.New" fa="plus" href="javascript:showDriverPickup()" enabled="<%=canEdit%>"/>
		<v:button id="delete-btn" caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" href="javascript:doRemovePlugins()" enabled="<%=rights.SystemSetupWorkstations.getOverallCRUD().canDelete()%>"/>
    <v:button id="status-btn" caption="@Common.Status" clazz="disabled" fa="flag" dropdown="true" enabled="<%=canEdit%>"/>
    <v:popup-menu bootstrap="true">
      <v:popup-item caption="@Common.Enable" clazz="plugin-status-item plugin-status-item-enable"/>
      <v:popup-item caption="@Common.Disable" clazz="plugin-status-item plugin-status-item-disable"/>
    </v:popup-menu>
  </div>
  <v:pagebox gridId="webplugin-grid"/>  
</div>

<div class="tab-content">
  <div class="profile-pic-div">
  <v:widget caption="@Common.Search">
    <v:widget-block>
      <input type="text" id="full-text-search" class="form-control default-focus" placeholder="<v:itl key="@Common.FullSearch"/>"/>
    </v:widget-block>
  </v:widget>
  <v:widget caption="@Common.Status">
    <v:widget-block>
      <v:db-checkbox field="Status" caption="@Common.Enabled" value="true" /><br/>
      <v:db-checkbox field="Status" caption="@Common.Disabled" value="false" /><br/>          
    </v:widget-block>
  </v:widget>
  <v:widget caption="@Plugin.ExtensionPackage">
    <v:widget-block>
      <snp:dyncombo id="extensionpack" entityType="<%=LkSNEntityType.ExtensionPackage%>"/>
    </v:widget-block>
  </v:widget>
  </div>
  
  <div class="profile-cont-div">
    <% String params = "DriverType=" + JvString.getEmpty(JvUtils.getServletParameter(request, "DriverType")); %>
    <v:async-grid id="webplugin-grid" jsp="plugin/webplugin_grid.jsp" params="<%=params%>"/>
  </div>
</div>
 
<script>
$(document).ready(function() {
  $(document).on("cbListClicked", enableDisable);
  
  function enableDisable() {
    var empty = ($("#webplugin-grid [name='PluginId']").getCheckedValues() == "");
    $("#status-btn").setClass("disabled", empty);
    $("#delete-btn").setClass("disabled", empty);
  }
  
  $(".plugin-status-item").click(function() {
    var reqDO = {
      Command: "UpdatePluginStatus",
      UpdatePluginStatus: {
        PluginIDs: $("#webplugin-grid [name='PluginId']").getCheckedValues(),
        PluginEnabled: $(this).hasClass("plugin-status-item-enable")
      }
    };
    
    showWaitGlass();
    vgsService("Plugin", reqDO, false, function(ansDO) {
      hideWaitGlass();
      triggerEntityChange(<%=LkSNEntityType.Plugin.getCode()%>);
    });
  });
  
  $("#full-text-search").keypress(function(e) {
    if (e.keyCode == KEY_ENTER) {
      search();
      return false;
    }
  });
});
 
function search() {
  setGridUrlParam("#webplugin-grid", "ExtPackStatus", $("[name='Status']").getCheckedValues());
  setGridUrlParam("#webplugin-grid", "ExtPackExtension", ($("#extensionpack").val() || ""));
  setGridUrlParam("#webplugin-grid", "FullText", $("#full-text-search").val(), true);
}

function showDriverPickup() {
	asyncDialogEasy("plugin/driver_pickup_dialog", "DriverGroup=<%=LkSNDriverType.GROUP_Server%>");
}

function driverPickupCallback(driverId) {
  asyncDialogEasy("plugin/plugin_dialog", "id=new&DriverId=" + driverId );
}

function doRemovePlugins() {
  var ids = $("[name='PluginId']").getCheckedValues();
  if (ids == "")
    showMessage(<v:itl key="@Common.NoElementWasSelected" encode="JS"/>);
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "RemovePlugin",
        RemovePlugin: {
          PluginIDs: ids
        }
      };
      vgsService("Workstation", reqDO, false, function(ansDO) {
        changeGridPage("#webplugin-grid", 1);
      });
    });
  }    
}
</script>