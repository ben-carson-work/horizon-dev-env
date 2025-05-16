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
BLBO_Plugin bl = pageBase.getBL(BLBO_Plugin.class);
DOPlugin plugin = (pageBase.isNewItem()) ? bl.prepareNewPlugin(pageBase.getNullParameter("DriverId"), pageBase.getNullParameter("WorkstationId")) : bl.loadPlugin(pageBase.getId());

String pluginName = plugin.PluginName.isNull(plugin.DriverName.getString());
boolean extPackageDisabled = !plugin.ExtensionPackageEnabled.isNull() && !plugin.ExtensionPackageEnabled.getBoolean();
boolean neededUploadPkg = plugin.ExtensionPackageId.isNull() && (!plugin.DriverLibraryName.getString().isEmpty()); //used to warn the user that the plugin has been moved into a package

PluginSettingsBase plgSettings = bl.getPluginSettings(plugin.DriverClassAlias.getString());
request.setAttribute("settings", bl.maskSettingsWithFakeEncryptedFieldsIfNeeded(plugin, plgSettings));
request.setAttribute("plugin", plugin);

JvDataSet ds = pageBase.execQuery(new QueryDef(QryBO_Plugin.class)
    .addFilter(QryBO_Plugin.Fil.DriverType, LookupManager.getIntArray(LkSNDriverType.CreditCard, LkSNDriverType.Cash))
    .addSort(QryBO_Plugin.Sel.PluginName)
    .addSelect(
        QryBO_Plugin.Sel.PluginId,
        QryBO_Plugin.Sel.PluginDisplayName));


JvDataSet dsPrintableErrorDocTemplates = pageBase.execQuery(new QueryDef(QryBO_DocTemplate.class)
    .addFilter(QryBO_DocTemplate.Fil.DocTemplateType, LkSNDocTemplateType.PrintableErrorReceipt.getCode())
    .addSort(QryBO_DocTemplate.Sel.DocTemplateName)
    .addSelect(
        QryBO_DocTemplate.Sel.IconName,
        QryBO_DocTemplate.Sel.DocTemplateId,
        QryBO_DocTemplate.Sel.DocTemplateName,
        QryBO_DocTemplate.Sel.DriverCount));
%>

<v:dialog tabsView="true" id="plugin_dialog" icon="<%=ImageCacheLinkTag.getLink(plugin.IconName.getString(), 16)%>" title="<%=JvString.escapeHtml(pluginName)%>" width="800" height="600" autofocus="false">
  <v:tab-group name="tab" main="true">
    <v:tab-item-embedded tab="plugin-tab-profile" caption="@Common.Profile" default="true">
      <v:tab-content>
        <% if (neededUploadPkg) { %>
          <div class="plg-needed-upld-pkg-wrn"><v:itl key="@Common.NeedUploadPackageWrn"/></div>
        <% } %>
        <v:widget caption="@Common.General">
          <v:widget-block>
            <v:form-field caption="@Common.Type">
              <input type="text" readonly="readonly" class="form-control" value="<%=plugin.DriverType.getLkValue().getHtmlDescription(pageBase.getLang())%> - <%=plugin.DriverName.getHtmlString()%>"/>
            </v:form-field>
            <v:form-field caption="@Common.Name">
              <v:input-text field="plugin.PluginName" placeholder="<%=plugin.DriverName.getHtmlString()%>" enabled="<%=canEdit%>"/>
            </v:form-field>
            <v:form-field caption="@Common.Alias">
              <v:input-text field="plugin.DeviceAlias" enabled="<%=canEdit%>"/>
            </v:form-field>
            <% if (plugin.DriverType.isLookup(LkSNDriverType.WebPaymentGateway)) { 
              QueryDef wpgQdef = new QueryDef(QryBO_Plugin.class)
                  .addFilter(QryBO_Plugin.Fil.DriverType, LkSNDriverType.WebPayment.getCode())
                  .addSort(QryBO_Plugin.Sel.PluginName)
                  .addSelect(
                      QryBO_Plugin.Sel.PluginId,
                      QryBO_Plugin.Sel.PluginDisplayName);

              	JvDataSet wpgDs = pageBase.execQuery(wpgQdef);
              	%>
            	<v:form-field caption="@Payment.PaymentMethod">
  	    	 			<v:combobox field="plugin.PaymentMethodIDs" lookupDataSet="<%=wpgDs%>" idFieldName="PluginId" captionFieldName="PluginDisplayName" enabled="<%=canEdit%>"/>
              </v:form-field>
              <v:form-field caption="@Common.Code">
                <v:input-text field="plugin.PluginCode" placeholder="@Plugin.PluginCodePlaceholder" enabled="<%=canEdit%>"/>
              </v:form-field>
              <v:form-field caption="Server-To-Server URL">
                <span id="s2sURL"></span>
              </v:form-field>
            <% } %>
            <% if (plugin.DriverType.isLookup(LkSNDriverType.ExtPayDevice, LkSNDriverType.CardReader, LkSNDriverType.SignatureReader)) { %>
              <v:form-field caption="@Payment.PaymentMethod">
  	    	 			<v:multibox field="plugin.PaymentMethodIDs" lookupDataSet="<%=ds%>" idFieldName="PluginId" captionFieldName="PluginDisplayName" enabled="<%=canEdit%>"/>
              </v:form-field>
							<v:form-field caption="@DocTemplate.PrintableErrorReceipt">
      					<v:combobox field="plugin.PrintableErrorReceiptId" lookupDataSet="<%=dsPrintableErrorDocTemplates%>" idFieldName="DocTemplateId" captionFieldName="DocTemplateName"/>
    					</v:form-field>
              
            <% } %>
          </v:widget-block>
          <v:widget-block>
            <% boolean enabled = canEdit && !extPackageDisabled; %>
            <v:db-checkbox field="plugin.PluginEnabled" caption="@Common.Enabled" value="true" enabled="<%=enabled%>"/>
          </v:widget-block>
        </v:widget>  
        <% if (extPackageDisabled) { %>
          <v:widget caption="@Common.Configuration">
            <jsp:include page="../common/config_not_available.jsp"/>
          </v:widget>
        <% } else if (plgSettings.getPluginConfigPageName() != null) { %>
          <jsp:include page="<%=plgSettings.getPluginConfigPageName()%>"/>
        <% } %>
      </v:tab-content>
    </v:tab-item-embedded>
    
    <% if (!pageBase.isNewItem() && rights.History.getBoolean()) { %>
      <v:tab-item-embedded tab="tabs-history" caption="@Common.History">
        <jsp:include page="../common/page_tab_historydetail.jsp"/>
      </v:tab-item-embedded>
    <% } %>

    <v:tab-item-embedded tab="tabs-log" caption="@Common.Logs" icon="<%=LkSNEntityType.Log.getIconName()%>" include="<%=pageBase.getBL(BLBO_Log.class).hasLogs(pageBase.getId())%>">
      <jsp:include page="../common/page_tab_logs.jsp"/>
    </v:tab-item-embedded>
    
  </v:tab-group>

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
  $(document).trigger("plugin-settings-load", {settings:<%=JvString.coalesce(plugin.PluginSettings.getString(), "{}")%>});

  let $dlg = $("#plugin_dialog");
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [];
    
    <% if (canEdit && !extPackageDisabled) { %>
      params.buttons.push({
        text: itl("@Common.Save"),
        click: doSavePlugin,
        disabled: <%=neededUploadPkg%>
      });
    <% } %>
    params.buttons.push(dialogButton("@Common.Cancel", doCloseDialog));
  });

  $("#plugin\\.PluginCode").keyup(recalcS2SURL);
  recalcS2SURL();

  function recalcS2SURL() {
    var code = $("#plugin\\.PluginCode").val();
    code = (code) ? code.trim() : "";
    var span = $("#s2sURL");
    span.setClass("code-missing", code == "");
    if (code == "")
      span.text("");
    else
      span.text("<v:config key="site_url"/>/admin?page=wpg&code=" + code);
  }

  function doSavePlugin() {
    try {
      checkRequired("#plugin_dialog", function() {
        var params = {};
        $(document).trigger("plugin-settings-save", params);
         
        if (!(params.settings) && (typeof getPluginSettings == 'function'))
          params.settings = getPluginSettings();

        var reqDO = {
          Plugin: {
            PluginId: <%=pageBase.isNewItem() ? null : "\"" + plugin.PluginId.getHtmlString() + "\""%>,
            DriverId: "<%=plugin.DriverId.getHtmlString()%>",
            WorkstationId: "<%=plugin.WorkstationId.getHtmlString()%>",
            PluginName: $dlg.find("#plugin\\.PluginName").val(),
            PluginEnabled: $dlg.find("#plugin\\.PluginEnabled").isChecked(),
            DeviceAlias: $dlg.find("#plugin\\.DeviceAlias").val(),
            PluginCode: $dlg.find("#plugin\\.PluginCode").val(),
            PaymentMethodIDs: $dlg.find("#plugin\\.PaymentMethodIDs").val(),
            PrintableErrorReceiptId: $dlg.find("#plugin\\.PrintableErrorReceiptId").val(),
            PluginSettings: (params.settings == null) ? null : JSON.stringify(params.settings)
          }
        };
        
        snpAPI.cmd("Workstation", "SavePlugin", reqDO)
          .then(() => {
            triggerEntityChange(<%=LkSNEntityType.Plugin.getCode()%>);
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


