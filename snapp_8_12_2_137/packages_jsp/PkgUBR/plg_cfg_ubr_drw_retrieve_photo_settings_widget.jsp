<%@page import="com.vgs.cl.document.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<%
  JvDocument settings = (JvDocument) request.getAttribute("settings");
%>

<v:widget caption="Settings">
	<v:widget-block>
		<v:form-field caption="URL" hint="FR API end-point">
			<v:input-text field="settings.URL" />
		</v:form-field>
    <v:form-field caption="Validate Token" hint="Value required by FR APIs">
      <v:input-text field="settings.ValidateToken"/>
    </v:form-field>
	</v:widget-block>
</v:widget>

<script>

  function getPluginSettings() {
    return {
      "URL": $("#settings\\.URL").val(),
      "ValidateToken": $("#settings\\.ValidateToken").val()
    };
  }
</script>