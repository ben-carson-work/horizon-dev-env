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

<!-- DOUBR_FR_HttpServer_Settings -->

<v:widget caption="@Common.Settings">
  <v:widget-block>
    <v:form-field caption="Server port">
      <v:input-text field="settings.ServerPort" placeholder="20126"/>
    </v:form-field>
  </v:widget-block>    
</v:widget>

<script>

function getPluginSettings() {
  return {
	  ServerPort: parseInt($("#settings\\.ServerPort").val())
  };
}

</script>