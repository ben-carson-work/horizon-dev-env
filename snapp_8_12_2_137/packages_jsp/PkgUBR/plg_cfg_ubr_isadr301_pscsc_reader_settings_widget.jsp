<%@page import="com.vgs.snapp.lookup.LkSN"%>
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
  <v:form-field caption="Block Number" hint="Indicate which block has to be read from the card">
    <v:input-text field="settings.DataBlock" type="number"/>
  </v:form-field>
  <v:form-field caption="Read delay" hint="Delay in millisecs. to prevent same media read to be trigger to be validate, values less than three seconds are ignored">
    <v:input-text field="settings.SameMediaDelay" type="number"/>
  </v:form-field>
</v:widget>

<script>

function getPluginSettings() {
  return {
    DataBlock: $("#settings\\.DataBlock").val(),
    SameMediaDelay: $("#settings\\.SameMediaDelay").val()
  };
}

</script> 