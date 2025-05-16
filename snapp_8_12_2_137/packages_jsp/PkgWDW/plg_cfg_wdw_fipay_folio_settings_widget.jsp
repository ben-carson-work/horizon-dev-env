<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.snapp.lookup.LkSNDriverType"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>

<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>

<!-- DOPlugin_WDW_FIPay_Folio_Settings -->
<v:widget caption="@Common.Settings">
  <v:widget-block>
    <v:form-field caption="@PluginSettings.FIPay.DeviceConnector" mandatory="true">
      <v:combobox field="settings.DeviceConnectorPluginId" lookupDataSet="<%=pageBase.getBL(BLBO_Plugin.class).getPluginDS(plugin.WorkstationId.getString(), LkSNDriverType.DeviceConnector)%>" allowNull="false" idFieldName="PluginId" captionFieldName="DriverName"/>
	  </v:form-field>
	</v:widget-block>
</v:widget>

<script>

function getPluginSettings() {
  return {
	  DeviceConnectorPluginId: $("#settings\\.DeviceConnectorPluginId").val()
	};
}

</script>

