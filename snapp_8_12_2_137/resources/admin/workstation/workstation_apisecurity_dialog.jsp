<%@page import="com.vgs.snapp.web.gencache.*"%>
<%@page import="com.vgs.web.library.bean.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request" />
<jsp:useBean id="license" class="com.vgs.snapp.dataobject.DOLicenseDef" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% StationBean station = SrvBO_Cache_Station.instance().getStationById(pageBase.getId()); %>

<v:dialog id="workstation-apisecurity-dialog" title="@Workstation.ApiSecurity" width="640" height="480">

<v:widget>
  <% if (station.workstationType.isLookup(LkSNWorkstationType.POS)) { %>
  <v:widget-block>
    <v:form-field caption="Registered">
      <% if (station.licenseParams != null) { %><v:itl key="@Common.Yes"/><% } else { %><v:itl key="@Common.No"/><% } %>
    </v:form-field>
  </v:widget-block>
  <% } %>
  <v:widget-block>
    <v:form-field caption="Encryption Key">
      <%=JvString.escapeHtml(station.apiEncryptionKey)%>
    </v:form-field>
  </v:widget-block>
  <% if (station.workstationType.isLookup(LkSNWorkstationType.POS)) { %>
  <v:widget-block>
    <v:form-field caption="Rotation Key">
      <%=JvString.escapeHtml(station.apiRotationKey)%>
    </v:form-field>
  </v:widget-block>
  <% } %>
</v:widget>


<script>

$(document).ready(function() {
  var $dlg = $("#workstation-apisecurity-dialog").focus();
  var workstationId = <%=JvString.jsString(pageBase.getId())%>;

  $dlg.bind("snapp-dialog", function(event, params) {
    params.buttons = {
      <v:itl key="@Common.ResetLicense" encode="JS"/>: doResetLicense,
      <v:itl key="@Common.Regenerate" encode="JS"/>: doRegenerateKeys,
      <v:itl key="@Common.Close" encode="JS"/>: doCloseDialog
    };
  });
  
  function doReloadDialog() {
    $dlg.dialog("close");
    asyncDialogEasy("workstation/workstation_apisecurity_dialog", "id=" + workstationId);
  }
  
  function doResetLicense() {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "ResetLicense",
        ResetLicense: {
          WorkstationId: workstationId
        }
      };
      
      showWaitGlass();
      vgsService("Workstation", reqDO, false, function() {
        hideWaitGlass();
        doReloadDialog();
      });
    });
  }
  
  function doRegenerateKeys() {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "RegenerateApiSecurityKeys",
        RegenerateApiSecurityKeys: {
          WorkstationId: workstationId
        }
      };
      
      showWaitGlass();
      vgsService("Workstation", reqDO, false, function() {
        hideWaitGlass();
        doReloadDialog();
      });
    });
	}
});
</script>

</v:dialog>