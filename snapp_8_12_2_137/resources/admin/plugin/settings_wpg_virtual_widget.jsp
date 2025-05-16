<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="snp-tags" prefix="snp" %>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>

<%
JvDocument settings = (JvDocument)request.getAttribute("settings"); 
boolean supportPayByToken = settings.getChildField("SupportPayByToken").getBoolean();
boolean supportWebFrame   = settings.getChildField("SupportWebFrame").getBoolean();
%>

<v:widget caption="@Common.Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
    <v:form-field caption="Support \"Pay By Token\"">
      <v:db-checkbox field="settings.SupportPayByToken" caption="" value="true" checked="<%=supportPayByToken%>" /><br/>
    </v:form-field>
    <v:form-field caption="Support web frame" mandatory="true">
      <v:db-checkbox field="settings.SupportWebFrame" caption="" value="true" checked="<%=supportWebFrame%>" /><br/>
    </v:form-field>   
  </v:widget-block>
</v:widget>
<script>

$(document).ready(function() {
});

function getPluginSettings() {
  return {
  	SupportPayByToken: $("#settings\\.SupportPayByToken").isChecked(),
  	SupportWebFrame:   $("#settings\\.SupportWebFrame").isChecked()
  };
}

</script>
