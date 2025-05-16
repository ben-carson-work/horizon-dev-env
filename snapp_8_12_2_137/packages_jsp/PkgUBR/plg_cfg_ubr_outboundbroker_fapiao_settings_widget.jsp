<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<%
  JvDocument settings = (JvDocument)request.getAttribute("settings");
%>

<v:widget caption="Settings" icon="settings.png">
  <v:widget-block>
    <v:form-field caption="TMS URL" hint="URL of the TMS system" mandatory="true">
      <v:input-text field="settings.TMS_URL"/>
    </v:form-field>
  </v:widget-block>
</v:widget>
<v:widget caption="API Gateway">
  <v:widget-block>
    <p>
      The <b>"API gateway"</b> parameters must be set on the <i>Extension Package for Universal Beijing</i> settings.
    </p>
  </v:widget-block>
</v:widget> 
<script>
  function getPluginSettings() {
    return {
      TMS_URL: $("#settings\\.TMS_URL").val()
    };
  }
</script>