<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>
<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>

<v:widget caption="@Common.Settings" icon="settings.png">
  <v:widget-block>
    <v:form-field caption="Terminal Id">
      <v:input-text field="settings.TerminalId"/>
    </v:form-field>
    <v:form-field caption="Pin Pad IP Address">
      <v:input-text field="settings.PosURL"/>
    </v:form-field>
    <v:form-field caption="Pin Pad Port">
      <v:input-text field="settings.PosPort"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>

function getPluginSettings() {
  return {
    TerminalId: $("#settings\\.TerminalId").val(),
    PosURL: $("#settings\\.PosURL").val(),
    PosPort: $("#settings\\.PosPort").val()
  };
}

</script>

