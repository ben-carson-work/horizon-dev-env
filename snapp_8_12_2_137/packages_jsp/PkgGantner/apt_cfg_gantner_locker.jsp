<%@page import="com.vgs.web.library.BLBO_MetaData"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="java.util.Map.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageWorkstation" scope="request"/>
<jsp:useBean id="pwks" class="com.vgs.snapp.dataobject.DOWorkstation" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%
  JvDocument settings = (JvDocument)request.getAttribute("settings");
  boolean canEdit = rights.SystemSetupLicensee.canUpdate();
  JvDataSet dsMetaField = pageBase.getBL(BLBO_MetaData.class).getMetaFieldDS();
%>
<% String sDisabled = (canEdit) ? "" : "disabled=\"disabled\""; %>

<input type="hidden" name="AptSettings"/>

  <v:widget caption="@PluginSettings.Gantner.ServerSettings" icon="settings.png">
    <v:widget-block>
      <v:form-field caption="@PluginSettings.Gantner.ServerIP">
        <v:input-text field="settings.ServerIP" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@PluginSettings.Gantner.ServerPort">
        <v:input-text field="settings.ServerPort" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Common.Password">
        <v:input-text field="settings.ServerPassword" enabled="<%=canEdit%>" type="password"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="Locker number meta field" hint="Meta field used to store the locker number on the ticket" mandatory="true">
        <v:combobox field="settings.LockerMetaFieldId" lookupDataSet="<%=dsMetaField%>" idFieldName="MetaFieldId" captionFieldName="MetaFieldName"/>
      </v:form-field>
      <v:form-field caption="Validate media on locker opening">
        <v:db-checkbox field="settings.ValidateMediaOnOpening" caption="" value="true" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
  
<div id="match-checkbox-template" class="v-hidden"><v:grid-checkbox name="match-checkbox"/></div>
  
<script>
	function saveAptSettings() {
		var cfg = {
			 ServerIP: $("#settings\\.ServerIP").val(),
       ServerPort: $("#settings\\.ServerPort").val(),
       ServerPassword: $("#settings\\.ServerPassword").val(),
       LockerMetaFieldId: $("#settings\\.LockerMetaFieldId").val(),
       ValidateMediaOnOpening: $("#settings\\.ValidateMediaOnOpening").isChecked(),
		};
		
		$("[name='AptSettings']").val(JSON.stringify(cfg));
	}
</script> 
