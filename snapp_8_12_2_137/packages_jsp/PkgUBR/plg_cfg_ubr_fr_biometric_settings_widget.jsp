<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>

<%
JvDocument settings = (JvDocument)request.getAttribute("settings");
%>

<!-- DOUBR_FR_Display_Settings -->

<v:widget caption="@Common.Settings">
  <v:widget-block>
    <v:form-field caption="Validate Token" mandatory="true">
      <v:input-text field="settings.WorkstationId"/>
    </v:form-field>
    <v:form-field caption="URL" mandatory="true">
      <v:input-text field="settings.URL" placeholder="Ex. http://127.0.0.1:8080"/><br/>
      <label id="url-verify-link"></label><br/>
      <label id="url-capture-link"></label><br/>
    </v:form-field>
    <v:form-field caption="Timeout (secs.)">
      <v:input-text field="settings.Timeout" placeholder="10"/>
    </v:form-field>
  </v:widget-block>    
</v:widget>

<script>

function recalcURL() {
    var baseURL = $("#settings\\.URL").val();
    $("#url-verify-link").html("<b><i>" + baseURL + "/verify</i></b> <b><i>");
    $("#url-capture-link").html("<b><i>" + baseURL + "/capture</i></b> <b><i>");
  }

function getPluginSettings() {
  return {
	  WorkstationId: $("#settings\\.WorkstationId").val(),
    URL: $("#settings\\.URL").val(),
    Timeout: parseInt($("#settings\\.Timeout").val())
  };
}

recalcURL();
$("#settings\\.URL").keyup(recalcURL);

</script>