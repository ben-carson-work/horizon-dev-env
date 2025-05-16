<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>
<jsp:useBean id="settings" class="com.vgs.entity.dataobject.DOPlgSettings_DeviceConnectorSdm" scope="request"/>


<v:widget caption="@Common.Settings">
  <v:widget-block>
    <v:form-field caption="Broker URL">
      <v:input-text field="settings.BrokerURL" placeholder="localhost"/>
    </v:form-field>
    <v:form-field caption="Broker Port">
      <v:input-text field="settings.BrokerPort" type="number" placeholder="32726"/>
    </v:form-field>
    <v:form-field caption="Required version" hint="To update the SDM to a specific version, enter that version as a value here. The system will then update the SDM accordingly.">
      <v:input-text field="settings.BrokerVersion"/>
    </v:form-field>
    <v:form-field>
      <v:button clazz="btn-download" caption="@Sdm.DownloadSdmInstaller" onclick="showSDMVersionDialog()"  fa="download"/>
    </v:form-field>    
  </v:widget-block>
</v:widget>
 
<script>

function getPluginSettings() {
  return {
    ConnectionURL: $("#settings\\.BrokerURL").val(),
    Port: parseInt($("#settings\\.BrokerPort").val()) || 32726,
    BrokerVersion: $("#settings\\.BrokerVersion").val()
  };
}

function showSDMVersionDialog() {
  asyncDialogEasy('system/sdmversions_dialog');
}

</script>
