<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%
  JvDocument settings = (JvDocument)request.getAttribute("settings");
  boolean canEdit = rights.SystemSetupLicensee.canUpdate();
%>
<% String sDisabled = (canEdit) ? "" : "disabled=\"disabled\""; %>

<v:widget caption="@Common.Settings" icon="settings.png">
  <v:widget-block>
    <v:form-field caption="@PluginSettings.Lumidigm.DeviceNumber">
      <v:input-text field="settings.DeviceNumber" enabled="<%=canEdit%>" type="number" defaultValue="0"/>
    </v:form-field>
    <v:form-field caption="@PluginSettings.Lumidigm.SpoofEnabled">
      <v:db-checkbox field="settings.SpoofEnabled" caption="" value="true" />
    </v:form-field>
  </v:widget-block>
</v:widget>
 
<script>

function getPluginSettings() {
  return {
	  DeviceNumber: ($("#settings\\.DeviceNumber").val()== "") ? 0 : $("#settings\\.DeviceNumber").val(),
    SpoofEnabled: $("#settings\\.SpoofEnabled").isChecked()
  };
}

</script>
 