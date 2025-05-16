<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<%
  JvDocument settings = (JvDocument) request.getAttribute("settings");
%>

<v:widget caption="Settings">
  <v:widget-block>
    <v:form-field caption="Workstation codes" hint="List of workstation codes (comma separated) for which the plugin should be used. The plugin will be used only for transaction posted by these workstations.">
      <v:input-text field="settings.WorkstationCodes"/>
    </v:form-field>
    <v:form-field caption="Status field code" hint="'MetaFieldCode' where FR status is going to be saved">
      <v:input-text field="settings.StatusMetaFieldCode"/>
    </v:form-field>
  </v:widget-block>
	<v:widget-block>
		<v:form-field caption="URL" hint="FR API end-point">
			<v:input-text field="settings.EndPointUrl" />
		</v:form-field>
		<v:form-field caption="Connection Timeout" hint="Max waiting time in milliseconds for connecting to the web server, zero value means no timeout">
      		<v:input-text field="settings.ConnectTimeout" type="number"/>
    	</v:form-field>
		<v:form-field caption="Read Timeout" hint="Max waiting time in milliseconds for reading data from the web server, zero value means no timeout">
      		<v:input-text field="settings.ReadTimeout" type="number"/>
    	</v:form-field>
	    <v:form-field caption="Biz ID" hint="Value required by FR APIs">
	      <v:input-text field="settings.BizID"/>
	    </v:form-field>
	    <v:form-field caption="Scene" hint="Value required by FR APIs">
	      <v:input-text field="settings.Scene"/>
	    </v:form-field>
	</v:widget-block>
</v:widget>

<script>
  function getPluginSettings() {
    return {
      "WorkstationCodes": $("#settings\\.WorkstationCodes").val(),
      "StatusMetaFieldCode": $("#settings\\.StatusMetaFieldCode").val(),
      "EndPointUrl": $("#settings\\.EndPointUrl").val(),
      "ConnectTimeout": $("#settings\\.ConnectTimeout").val(),
      "ReadTimeout": $("#settings\\.ReadTimeout").val(),
      "BizID": $("#settings\\.BizID").val(),
      "Scene": $("#settings\\.Scene").val()
    };
  }
</script>