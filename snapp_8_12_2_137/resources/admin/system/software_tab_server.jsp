<%@page import="com.vgs.snapp.library.SnappUtils"%>
<%@page import="com.vgs.web.library.BLBO_DBInfo"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSoftware" scope="request"/>
<jsp:useBean id="rights" scope="request" class="com.vgs.snapp.dataobject.DORightRoot"/>

<div class="tab-toolbar">
  <v:button caption="@Common.Search" fa="search" onclick="search()"/>
  <v:button fa="sync-alt" caption="@Common.Refresh" href="javascript:changeGridPage('#server-grid', 1)"/>
  <% if (rights.SettingsITSettings.getBoolean()) { %>
    <v:button id="btn-delete-server" fa="trash" caption="@Common.Delete"/>
    <span class="divider"></span>
    <% String clickParams = "javascript:asyncDialogEasy('right/rights_dialog', 'Filter=server&EntityType=" + LkSNEntityType.ServerRoot.getCode() + "&EntityId=" + SnappUtils.encodeServerPseudoId(0) + "')"; %>
    <v:button fa="sliders-h" caption="@Common.Parameters" onclick="<%=clickParams%>"/>
    <v:button fa="cloud" caption="@Common.CheckForUpdates" onclick="asyncDialogEasy('monitor/softwareupdate_dialog')"/>
    <span class="divider"></span>
    <% String hRef="javascript:showHistoryLog(" + LkSNEntityType.Server.getCode() + ")";%>
    <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/>
  <% } %>

  <v:pagebox gridId="server-grid"/>
</div>

<div class="tab-content">
  <div class="profile-pic-div">
    <v:widget caption="@Common.Search">
      <v:widget-block>
        <input type="text" id="full-text-search" class="form-control default-focus" placeholder="<v:itl key="@Common.FullSearch"/>"/>
      </v:widget-block>
    </v:widget>
    <v:widget caption="@Common.Filters">
      <v:widget-block>
        <v:itl key="@ServerProfile.ServerProfiles"/><br/>
        <snp:dyncombo id="ServerProfileId" entityType="<%=LkSNEntityType.ServerProfile%>"  auditLocationFilter="true"/>

      </v:widget-block>
    </v:widget>
  </div>
  <div class="profile-cont-div">
    <v:async-grid id="server-grid" jsp="monitor/server_grid.jsp"/>
  </div>
  
  <v:last-error/>   
</div>

<script>
$(document).ready(function() {
  $(document).on("click", "#server-grid .cblist", doRefreshVisibility);
  $("#btn-delete-server").click(doDeleteServer);
  $("#full-text-search").keypress(function(e) {
      if (e.keyCode == KEY_ENTER) {
        search();
        return false;
	  }
	  });
  
  doRefreshVisibility();

  function doDeleteServer() {
    var ids = $("#server-grid [name='ServerId']").getCheckedValues();
    if (ids == "")
      showMessage(itl("@Common.NoElementWasSelected"));
    else {
      confirmDialog(null, function() {
        var reqDO = {
          Command: "DeleteServer",
          DeleteServer: {
            ServerIDs: ids
          }
        };
        
        showWaitGlass();
        vgsService("System", reqDO, false, function(ansDO) {
          hideWaitGlass();
          triggerEntityChange(<%=LkSNEntityType.Server.getCode()%>);
        });
      });
    }
  }

  function doRefreshVisibility() {
    $("#btn-delete-server").setClass("disabled", $("#server-grid [name='ServerId']").getCheckedValues() == "");
  }
  
});
	
function search() {
  setGridUrlParam("#server-grid", "ServerProfileId", $("#ServerProfileId").val() || "");
  setGridUrlParam("#server-grid", "FullText", $("#full-text-search").val(), true);
}
</script>
