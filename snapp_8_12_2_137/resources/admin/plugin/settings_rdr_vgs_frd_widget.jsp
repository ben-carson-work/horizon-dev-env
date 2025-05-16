<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>


<% JvDocument settings = (JvDocument)request.getAttribute("settings"); 
boolean ShowBBoxOnScreen = settings.getChildField("ShowBBoxOnScreen").getBoolean();
boolean EnableSmileDetection = settings.getChildField("EnableSmileDetection").getBoolean();
%>

<v:widget caption="@PluginSettings.FRDeviceReader.DeviceConnectionParameter" hint="@PluginSettings.FRDeviceReader.DeviceConnectionParameterHint"> 
  <v:widget-block>
    <v:form-field caption="@PluginSettings.FRDeviceReader.IpAddress" hint="@PluginSettings.FRDeviceReader.IpAddressHint" mandatory="true">
      <v:input-text field="settings.DeviceHost"/>
    </v:form-field>
    <v:form-field caption="@PluginSettings.FRDeviceReader.TcpPort" hint="@PluginSettings.FRDeviceReader.TcpPortHint"  mandatory="false">
      <v:input-text field="settings.DeviceTcpPort" type="number" placeholder="14141"  min="0" max="65535" step="1"/>
    </v:form-field>    
    <v:form-field caption="@PluginSettings.FRDeviceReader.OfflineTimeout" hint="@PluginSettings.FRDeviceReader.OfflineTimeoutHint" mandatory="false">
      <v:input-text field="settings.OfflineTimeout" type="number" placeholder="10000" min="0"/>
    </v:form-field>
    <v:form-field caption="@PluginSettings.FRDeviceReader.ProtectionPIN" hint = "@PluginSettings.FRDeviceReader.ProtectionPINHint" mandatory="false">
      <v:input-text field="settings.ProtectionPIN" type="text"/>
    </v:form-field>
  </v:widget-block>
</v:widget>
<v:widget caption="@PluginSettings.FRDeviceReader.BoundingBoxFilter" tooltipJsp ="plugin/settings_rdr_vgs_frd_tooltip"> 
  <v:widget-block>
      <v:form-field caption="@PluginSettings.FRDeviceReader.OuterBBoxMarginLR" hint="@PluginSettings.FRDeviceReader.OuterBBoxMarginLRHint" mandatory="false">
      <v:input-text field="settings.OuterBBoxMarginLeftRight" type="number" placeholder="75"/>
    </v:form-field> 
    <v:form-field caption="@PluginSettings.FRDeviceReader.OuterBBoxPaddingTop" hint = "@PluginSettings.FRDeviceReader.OuterBBoxPaddingTopHint" mandatory="false">
      <v:input-text field="settings.OuterBBoxPaddingTop" type="number" placeholder="75"/>
    </v:form-field>
    <v:form-field caption="@PluginSettings.FRDeviceReader.InnerBBoxPadding" hint = "@PluginSettings.FRDeviceReader.InnerBBoxPaddingHint" mandatory="false">
      <v:input-text field="settings.InnerBBoxPadding" type="number" placeholder="350"/>
    </v:form-field>
    <v:form-field>
      <v:db-checkbox field="settings.ShowBBoxOnScreen" value="true" checked="<%=ShowBBoxOnScreen%>" caption="@PluginSettings.FRDeviceReader.ShowBBox" hint="@PluginSettings.FRDeviceReader.ShowBBoxHint"/>
    </v:form-field> 
  </v:widget-block>
</v:widget>

<v:widget caption="@PluginSettings.FRDeviceReader.FaceOrientationFilter" hint="@PluginSettings.FRDeviceReader.FaceOrientationFilterHint"> 
  <v:widget-block>  
    <v:form-field caption="@PluginSettings.FRDeviceReader.EulerX" hint="@PluginSettings.FRDeviceReader.EulerXHint" mandatory="false">
      <v:input-text field="settings.EulerX" type="number" placeholder="40" min="0" max="45" step="1"/>
    </v:form-field>                 
    <v:form-field caption="@PluginSettings.FRDeviceReader.EulerY" hint="@PluginSettings.FRDeviceReader.EulerYHint" mandatory="false">
      <v:input-text field="settings.EulerY" type="number" placeholder="40" min="0" max="45" step="1"/>
    </v:form-field> 
    <v:form-field caption="@PluginSettings.FRDeviceReader.EulerZ" hint="@PluginSettings.FRDeviceReader.EulerZHint" mandatory="false">
      <v:input-text field="settings.EulerZ" type="number" placeholder="40" min="0" max="45" step="1"/>
    </v:form-field>
      </v:widget-block>
</v:widget>
<v:widget caption="@PluginSettings.FRDeviceReader.OtherParameters"> 
  <v:widget-block>
    <v:db-checkbox field="settings.EnableSmileDetection" value="true" checked="<%=EnableSmileDetection%>" caption="@PluginSettings.FRDeviceReader.EnableSmileDetection" hint="@PluginSettings.FRDeviceReader.EnableSmileDetectionHint"/>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="@PluginSettings.FRDeviceReader.SmileDetectionThreshold" hint="@PluginSettings.FRDeviceReader.SmileDetectionThresholdHint" mandatory="false">
      <v:input-text field="settings.SmileDetectionProbabilityThreshold" type="number" placeholder="0.8" min="0" max="1" step="0.1"/>
    </v:form-field> 
  </v:widget-block>
</v:widget>

<script>

function getPluginSettings() {
	  return {
		 DeviceHost: $("#settings\\.DeviceHost").val(),
		 DeviceTcpPort: $("#settings\\.DeviceTcpPort").val(),
		 OfflineTimeout: $("#settings\\.OfflineTimeout").val(),
		 ProtectionPIN: $("#settings\\.ProtectionPIN").val(),
		 ShowBBoxOnScreen: $("#settings\\.ShowBBoxOnScreen").isChecked(),
		 OuterBBoxMarginLeftRight: $("#settings\\.OuterBBoxMarginLeftRight").val(),
		 OuterBBoxPaddingTop: $("#settings\\.OuterBBoxPaddingTop").val(),
		 InnerBBoxPadding: $("#settings\\.InnerBBoxPadding").val(),
		 EnableSmileDetection: $("#settings\\.EnableSmileDetection").isChecked(),
		 SmileDetectionProbabilityThreshold: $("#settings\\.SmileDetectionProbabilityThreshold").val(),
		 EulerX: $("#settings\\.EulerX").val(),
		 EulerY: $("#settings\\.EulerY").val(),
		 EulerZ: $("#settings\\.EulerZ").val(),
	  };
	}

</script>
