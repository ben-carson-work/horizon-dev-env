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

<v:widget caption="@Common.Settings">
  <v:widget-block>
    <v:form-field caption="Timeout (millisecs.)" hint="Maximum waiting time for device answer">
      <v:input-text field="settings.Timeout" type="number" placeholder="20000"/>
    </v:form-field>
    <v:form-field caption="Notify no image" hint="If enabled an error is shown if image data can't be read from document during capture">
		<v:db-checkbox field="settings.NotifyEmptyImage" caption="@Common.Enabled" value="true"/>
    </v:form-field>
  </v:widget-block>    
</v:widget>

<script>

function getPluginSettings() {
  return {
    Timeout: $("#settings\\.Timeout").val(),
    NotifyEmptyImage: $("#settings\\.NotifyEmptyImage").isChecked()
  };
}

</script>