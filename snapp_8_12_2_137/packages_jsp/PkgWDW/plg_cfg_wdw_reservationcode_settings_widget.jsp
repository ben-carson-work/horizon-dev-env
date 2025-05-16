<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>

<%
JvDocument settings = (JvDocument)request.getAttribute("settings");
%>

<v:widget caption="@Common.Settings">
  <v:widget-block>
    <v:form-field caption="Banned words">
      <v:input-txtarea field="settings.BannedWords" rows="6"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
function getPluginSettings() {
  var words = $("#settings\\.BannedWords").val().split("\n");
  for (var i=0; i<words.length; i++)
    words[i] = words[i].trim();
  return {
    "BannedWords": words
  };
}

var settings;

$(document).ready(function() {
  $("#settings\\.BannedWords").val(<%=JvString.jsString(settings.getChildField("BannedWords").getEmptyString())%>.replace(/\,/g,"\n"));
  settings = <%=settings.getJSONString()%>;
});
</script>

