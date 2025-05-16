<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
String driverId = pageBase.getParameter("driverId");
LkSNRightType.RightTypeItem rightType = (LkSNRightType.RightTypeItem)LkSN.RightType.getItemByCode(pageBase.getParameter("rightType"));
boolean canEdit = pageBase.isParameter("canEdit", "true");
String title = rightType.getDescription(pageBase.getLang());

DODriver driver = pageBase.getBL(BLBO_Driver.class).loadDriver(driverId);
%>

<v:dialog id="rights-pluginconfig-dialog" tabsView="true" title="<%=title%>" width="800" height="600">

  <v:tab-group name="tab" main="true">
    <v:tab-item-embedded tab="tabs-main" caption="@Common.General" default="true">
      <div class="tab-content">
        <% if (driver.ConfigFileName.isNull()) { %>
          <v:alert-box type="info">No config required for this plugin</v:alert-box>
        <% } else { %>
          <jsp:include page="<%=driver.ConfigFileName.getString()%>"></jsp:include>
        <% } %>
      </div>
    </v:tab-item-embedded>
  </v:tab-group>


<script>
$(document).ready(function() {
  var canEdit = <%=canEdit%>;
  var rightType = <%=rightType.getCode()%>;
  
  var $rightItem = $(".rights-item[data-righttype=" + rightType + "]");
  var $targetControl = $rightItem.find(".rights-item-checkbox").isChecked() ? $rightItem.find(".this-control .right-plugin-control") : $rightItem.find(".def-control .right-plugin-control");
  
  var settingsJSON = getNull($targetControl.attr("data-settings"));
  if (settingsJSON != null) {
	  try {
    	$(document).trigger("plugin-settings-load", {settings:JSON.parse(settingsJSON)});
	  }
	  catch (error) {}
  }
  
  var dlgButtons = [dialogButton(itl("@Common.Cancel"), doCloseDialog)]; 
  if (canEdit == true)
    dlgButtons.unshift(dialogButton(itl("@Common.Ok"), _save));
  
  var $dlg = $("#rights-pluginconfig-dialog");
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = dlgButtons;
  });
  
  function _save() {
    var params = {};
    try {
      $(document).trigger("plugin-settings-save", params);
      $targetControl.attr("data-settings", JSON.stringify(params.settings));
      $dlg.dialog("close");
    }
    catch (error) {
      showMessage(error);
    }
  }
});

</script>

</v:dialog>
