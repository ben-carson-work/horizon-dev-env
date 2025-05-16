<%@page import="com.vgs.web.library.pluginsettings.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% boolean canEdit = rights.SystemSetupWorkstations.getOverallCRUD().canUpdate(); %>

<style>
.plg-needed-upld-pkg-wrn { 
  display: block;
  color: red;
  font-size: 11pt;
  margin: 5px;
}
</style>

<%
BLBO_Driver bl = pageBase.getBL(BLBO_Driver.class);
DODriver driver = bl.loadDriver(pageBase.getId());
request.setAttribute("driver", driver);

boolean extPackageDisabled = !driver.ExtensionPackageEnabled.isNull() && !driver.ExtensionPackageEnabled.getBoolean();
boolean neededUploadPkg = driver.ExtensionPackageId.isNull() && (!driver.LibraryName.getString().isEmpty()); //used to warn the user that the driver has been moved into a package

PluginSettingsBase drvSettings = pageBase.getBL(BLBO_Plugin.class).getPluginSettings(driver.ClassAlias.getString());
request.setAttribute("settings", drvSettings.getDriverConfigDataObject(driver.DriverSettings.getString()));
boolean hasSettings = (drvSettings.getDriverConfigPageName() != null);
%>

<v:dialog id="driver_dialog" icon="<%=ImageCacheLinkTag.getLink(driver.IconName.getString(), 16)%>" title="<%=driver.DriverName.getHtmlString()%>" width="800" height="600" autofocus="false">
  <% if (neededUploadPkg) { %>
    <div class="plg-needed-upld-pkg-wrn"><v:itl key="@Common.NeedUploadPackageWrn"/></div>
  <% } %>
  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:form-field caption="@Common.Type">
        <input type="text" readonly="readonly" class="form-control" value="<%=driver.DriverType.getLkValue().getHtmlDescription(pageBase.getLang())%> - <%=driver.DriverName.getHtmlString()%>"/>
      </v:form-field>
      <v:form-field caption="@Common.Name">
        <v:input-text field="driver.DriverName" placeholder="<%=driver.DriverName.getHtmlString()%>" enabled="false"/>
      </v:form-field>
      <v:form-field caption="@Plugin.ExtensionPackageName">
       <v:input-text field="driver.ExtensionPackageName" placeholder="<%=driver.ExtensionPackageName.getHtmlString()%>" enabled="false"/>
      </v:form-field>
      <v:form-field caption="@Common.LibraryName">
        <v:input-text field="driver.LibraryName" enabled="false"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>  
  <% if (extPackageDisabled) { %>
    <v:widget caption="@Common.Configuration">
      <jsp:include page="../common/config_not_available.jsp"/>
    </v:widget>
  <% } else if (hasSettings) { %>
    <jsp:include page="<%=drvSettings.getDriverConfigPageName()%>"/>
  <% } %>

<style>
#s2sURL {
  font-weight: bold;
}
#s2sURL.code-missing{
  font-weight: normal;
  font-style: italic;
  color: var(--base-red-color);
}
</style>

<script>

$(document).ready(function() {
  $(document).trigger("driver-settings-load", {settings:<%=JvUtils.coalesce(driver.DriverSettings.getNullString(true), "{}")%>});

  var $dlg = $("#driver_dialog");
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [];
    
    <% if (canEdit && !extPackageDisabled) { %>
      params.buttons.push({
        text: itl("@Common.Save"),
        click: doSaveDriver,
        disabled: <%=neededUploadPkg || !hasSettings%>
      });
    <% } %>
    params.buttons.push({
      text: itl("@Common.Cancel"),
      click: doCloseDialog
    });
  });
  
  function doSaveDriver() {
    try {
      checkRequired("#driver_dialog", function() {
        var params = {};
        $(document).trigger("driver-settings-save", params);
         
        if (!(params.settings) && (typeof getDriverSettings == "function"))
          params.settings = getDriverSettings();
        
        var settings = params.settings;
        if ((getNull(settings) != null) && (typeof settings == "object")) 
          settings = JSON.stringify(settings);

        var reqDO = {
          DriverId: <%=driver.DriverId.getJsString()%>,
          Settings: settings
        };
        
        snpAPI.cmd("Plugin", "SaveDriverSettings", reqDO).then(ansDO => {
          triggerEntityChange(<%=LkSNEntityType.Driver.getCode()%>);
          $dlg.dialog("close");
        });
      });
    }
    catch (err) {
      showMessage(err);
    }

  }
});

</script>

</v:dialog>


