<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget caption="@Common.Settings">
  <v:widget-block>
    <v:form-field clazz="gyg-field" caption="APIKey" hint="Key used to verify inbound calls. Provided or agreed with Redeam.">
      <v:input-text field="settings.APIKey"/>
    </v:form-field>
    <v:form-field clazz="gyg-field" caption="APISecret" hint="Secret used to verify inbound calls. Provided or agreed with Redeam.">
      <v:input-text field="settings.APISecret"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
var gygSettings = <%=((JvDocument)request.getAttribute("settings")).getJSONString()%>;

function getPluginSettings() {
  gygSettings.APIKey = $("#settings\\.APIKey").val();
  gygSettings.APISecret = $("#settings\\.APISecret").val();
  return gygSettings;
}

$(document).ready(function() {
  var channelSettingsChanged = false;
  $(".gyg-field").change(function() {
    channelSettingsChanged = true;
  });
});

</script>
