<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%
JvDocument settings = (JvDocument)request.getAttribute("settings"); 
%>

<v:widget caption="@Common.Settings">
  <v:widget-block>
    <v:form-field caption="Login fail" hint="If flaged login will not be allowed">
        <v:db-checkbox field="settings.LoginFail" caption="@Common.Enabled" value="true"/>
      </v:form-field>
  </v:widget-block>    
</v:widget>

<script>

function getPluginSettings() {
  return {
    LoginFail: $("#settings\\.LoginFail").isChecked()
  };
}

</script>