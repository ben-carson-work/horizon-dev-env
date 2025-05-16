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

<!-- DOUBR_FR_Biometric_Settings -->

<v:widget caption="@Common.Settings">
  <v:widget-block>
    <v:form-field caption="Validate Token" mandatory="true">
      <v:input-text field="settings.WorkstationId"/>
    </v:form-field>
    <v:form-field caption="URL" mandatory="true">
      <v:input-text field="settings.URL" placeholder="Ex. http://127.0.0.1:8080"/><br/>
      <label id="url-frscreen-link"></label>
    </v:form-field>
    <v:form-field caption="Timeout (secs.)">
      <v:input-text field="settings.Timeout" placeholder="10"/><br/>
    </v:form-field>
  </v:widget-block>    
</v:widget>

<script>

function recalcURL() {
    var baseURL = $("#settings\\.URL").val();
    var lnk = $("#url-frscreen-link").html("<b><i>" + baseURL + "/screen</i></b>");
  }

function getPluginSettings() {
  return {
	  WorkstationId: $("#settings\\.WorkstationId").val(),
	  URL: $("#settings\\.URL").val(),
	  Timeout: $("#settings\\.Timeout").val()
  };
}

recalcURL();
$("#settings\\.URL").keyup(recalcURL);

</script>