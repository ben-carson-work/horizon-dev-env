<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>

<v:widget caption="Plugin settings">
  <v:widget-block>
  <!-- Insert here configuration fields
    <v:form-field caption="@PluginSettings.CommonDevices.ConnectionTimeout" hint="@PluginSettings.CommonDevices.ConnectionTimeoutHint">
      <v:input-text field="settings.ConnectionTimeout" placeholder="3000" type="number" step="500" min="0"/>
    </v:form-field>
    -->
  </v:widget-block>
</v:widget>

<script>
function getPluginSettings() {
  return {
  <!-- Insert here values to return when settings are saved.
	  ConnectionTimeout : $("#settings\\.ConnectionTimeout").val(),
	  -->
  };
}
</script>