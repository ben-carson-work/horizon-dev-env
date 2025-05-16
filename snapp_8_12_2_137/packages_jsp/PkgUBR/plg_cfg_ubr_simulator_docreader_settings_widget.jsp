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
    <v:form-field caption="Document number" hint="If left empty document number is randomly generated">
      <v:input-text field="settings.DocumentNumber" placeholder="Randomly generated"/>
    </v:form-field>
  </v:widget-block>    
</v:widget>

<script>

function getPluginSettings() {
  return {
	  DocumentNumber: $("#settings\\.DocumentNumber").val()
  };
}

</script>