<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="java.util.Map.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageWorkstation" scope="request"/>
<jsp:useBean id="pwks" class="com.vgs.snapp.dataobject.DOWorkstation" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%
  JvDocument settings = (JvDocument)request.getAttribute("settings");
  boolean canEdit = rights.SystemSetupLicensee.canUpdate();
%>
<% String sDisabled = (canEdit) ? "" : "disabled=\"disabled\""; %>

  <v:widget caption="@PluginSettings.TrueViewCounter.CameraSettings" icon="settings.png">
    <v:widget-block>
      <v:form-field caption="@PluginSettings.TrueViewCounter.CameraUrl">
        <v:input-text field="settings.CameraUrl" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@PluginSettings.TrueViewCounter.RefreshFrequency">
        <v:input-text field="settings.RefreshFrequency" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
 
  <input type="hidden" name="AptSettings"/>
 
<script>
  function saveAptSettings() {
    var cfg = {
    		CameraUrl: $("#settings\\.CameraUrl").val(),
    		RefreshFrequency: $("#settings\\.RefreshFrequency").val()
    };
    
    $("[name='AptSettings']").val(JSON.stringify(cfg));
  }
</script>