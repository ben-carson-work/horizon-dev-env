<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="java.util.Map.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<%
  JvDocument settings = (JvDocument)request.getAttribute("settings");
%>

<v:widget caption="Settings" icon="settings.png">
  <v:widget-block>
    <v:form-field caption="Supervisor Role Code" mandatory="true">
      <v:input-text field="settings.SupervisorRoleCode"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
  function getPluginSettings() {
    return {
      SupervisorRoleCode: $("#settings\\.SupervisorRoleCode").val()
    };
  }
</script>