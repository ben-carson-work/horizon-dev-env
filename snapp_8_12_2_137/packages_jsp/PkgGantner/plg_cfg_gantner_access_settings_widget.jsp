<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageWorkstation" scope="request"/>
<jsp:useBean id="pwks" class="com.vgs.snapp.dataobject.DOWorkstation" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%
  JvDocument settings = (JvDocument)request.getAttribute("settings");
  boolean canEdit = rights.SystemSetupLicensee.canUpdate();
%>

<input type="hidden" name="AptSettings"/>
<v:widget caption="@PluginSettings.Gantner.DeviceSettings">
  <v:widget-block>
    <v:form-field caption="@PluginSettings.Gantner.EntryReaderCode" hint="@PluginSettings.Gantner.EntryReaderCodeHint" mandatory="true">
      <v:input-text field="settings.EntryReaderCode" enabled="<%=canEdit%>"/>
    </v:form-field>
  </v:widget-block>
  
  <v:widget-block>
    <v:form-field caption="@PluginSettings.Gantner.ExitReaderCode" hint="@PluginSettings.Gantner.ExitReaderCodeHint" mandatory="false">
      <v:input-text field="settings.ExitReaderCode" enabled="<%=canEdit%>"/>
    </v:form-field>
  </v:widget-block>
  
</v:widget>

<script>

function saveAptSettings() {
  var cfg = {
    EntryReaderCode: $("#settings\\.EntryReaderCode").val(),
    ExitReaderCode: $("#settings\\.ExitReaderCode").val(),
  };
	
  $("[name='AptSettings']").val(JSON.stringify(cfg));
}
</script>