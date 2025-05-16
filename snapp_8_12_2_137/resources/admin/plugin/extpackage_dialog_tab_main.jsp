<%@page import="com.vgs.snapp.dataobject.plugin.DOExtensionPackageStatusRef"%>
<%@page import="com.vgs.cl.document.FtList"%>
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
<jsp:useBean id="pkg" class="com.vgs.snapp.dataobject.DOExtensionPackage" scope="request"/>

<% 
  boolean canEdit = rights.SuperUser.getBoolean() || rights.ExtensionPackages.canUpdate();
  boolean canDelete = rights.SuperUser.getBoolean() || rights.ExtensionPackages.canDelete();
%>

<v:tab-toolbar> 
  <v:button id="btn-pkg-enable" fa="check" caption="@Common.Enable" clazz="v-hidden" enabled="<%=canEdit%>"/>
  <v:button id="btn-pkg-disable" fa="lock" caption="@Common.Disable" clazz="v-hidden" enabled="<%=canEdit%>"/>
  <v:button id="btn-pkg-delete" fa="trash" caption="@Common.Delete" clazz="v-hidden" enabled="<%=canDelete%>"/>
</v:tab-toolbar>

<v:tab-content>
  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:itl key="@Common.Name"/>
      <span class="recap-value"><%=pkg.ExtensionPackageCode.getHtmlString()%></span>
      <br/>
      <v:itl key="@Common.Description"/>
      <span class="recap-value"><%=pkg.ExtensionPackageName.getHtmlString()%></span>
      <br/>
      <v:itl key="@Common.Version"/>
      <span class="recap-value"><%=pkg.ExtensionPackageVersion.getHtmlString()%></span>
      <br/>
      <v:itl key="@Common.Size"/>
      <span class="recap-value"><%=JvString.getSmoothSize(pkg.JarFileSize.getLong())%></span>
    </v:widget-block>
  </v:widget>
  
  <v:grid id="pkg-status-grid">
    <thead><v:grid-title caption="@Common.Status"/></thead>
    <tbody></tbody>
  </v:grid>
</v:tab-content>

<style>
#pkg-status-grid .pkg-server-name {
  width: 50%;
}
#pkg-status-grid .pkg-server-status {
  width: 50%;
  text-align: right;
}

#pkg-status-grid .pkg-server-id {
  border-left: 4px solid var(--base-gray-color);
}

#pkg-status-grid tr.status-<%=LkCommonStatus.Warn.getCode()%> .pkg-server-id {border-left-color:var(--base-orange-color)}
#pkg-status-grid tr.status-<%=LkCommonStatus.Active.getCode()%> .pkg-server-id {border-left-color:var(--base-green-color)}
#pkg-status-grid tr.status-<%=LkCommonStatus.Deleted.getCode()%> .pkg-server-id {border-left-color:var(--base-red-color)}

</style>

<script>

$(document).ready(function() {
  var $dlg = $("#extpackage_dialog");
  var pkg = <%=pkg.getJSONString()%>;
  var servers = <%=JvUtils.listToJSONString(pageBase.getBL(BLBO_Plugin.class).getExtensionPackageServerStatusList(pkg.ExtensionPackageId.getString()))%>;

  $dlg.find("#btn-pkg-enable").click(_enablePackage);
  $dlg.find("#btn-pkg-disable").click(_disablePackage);
  $dlg.find("#btn-pkg-delete").click(_deletePackage);

  _renderPackage();

  function _renderPackage() {
    $("#btn-pkg-enable").setClass("v-hidden", pkg.Enabled);
    $("#btn-pkg-disable").setClass("v-hidden", !pkg.Enabled);
    $("#btn-pkg-delete").setClass("v-hidden", pkg.Enabled);
    
    var tbody = $("#pkg-status-grid tbody");
    tbody.empty();
    
    if (!(servers) || (servers.length == 0)) {
      tbody.append("<tr><td><span class='list-subtitle'><v:itl key="@Common.None"/></span></td></tr>");
    } 
    else {
      for (var i=0; i<servers.length; i++) {
        var srv = servers[i]; 
        var tr = $("<tr><td class='pkg-server-id'/><td class='pkg-server-name'/><td class='pkg-server-status'/></tr>").appendTo(tbody);
        tr.addClass("status-" + srv.CommonStatus);
        tr.find(".pkg-server-id").text(srv.ServerId);
        tr.find(".pkg-server-name").text(srv.ServerName);
        tr.find(".pkg-server-status").text(srv.ExtensionPackageStatusDesc);
      }
    }
    
    setTimeout(_refreshInfo, 1000);
  }

  function _refreshInfo() {
    if ($("#extpackage_dialog").length > 0) {
      snpAPI.cmd("Plugin", "LoadExtensionPackage", {ExtensionPackageId:<%=pkg.ExtensionPackageId.getJsString()%>}, {showWaitGlass:false})
        .then(ansDO => {
          pkg = ansDO.ExtensionPackage || {};
          servers = ansDO.ServerStatusList || [];
          _renderPackage();    
        });
    }
  }
  
  function _enablePackage() {
    _doEnablePackage(true);
  }
  
  function _disablePackage() {
    _doEnablePackage(false);
  }

  function _doEnablePackage(enabled) {
    snpAPI.cmd("Plugin", "EnableExtensionPackage", {
      ExtensionPackageId: <%=pkg.ExtensionPackageId.getJsString()%>,
      Enabled: enabled
    }).then(ansDO => triggerEntityChange(<%=LkSNEntityType.ExtensionPackage.getCode()%>));
  }

  function _deletePackage() {
    snpAPI.cmd("Plugin", "DeleteExtensionPackage", {
      ExtensionPackageIDs: <%=pkg.ExtensionPackageId.getJsString()%>
    }).then(ansDO => {
      triggerEntityChange(<%=LkSNEntityType.ExtensionPackage.getCode()%>);
      $dlg.dialog("close");
    });
  }

});

</script>