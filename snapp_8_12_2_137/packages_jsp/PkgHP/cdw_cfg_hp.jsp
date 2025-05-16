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
  <v:widget-block>
  	<v:form-field caption="@Common.Name">
       <select id="settings.LogicName" class="form-control">
        <option value="799" <%=JvString.isSameText("799", settings.getChildField("LogicName").getString()) ? "selected" : ""%>>A799</option>
        <option value="H300S" <%=JvString.isSameText("H300S", settings.getChildField("LogicName").getString()) ? "selected" : ""%>>H300S</option>
        <option value="H300C" <%=JvString.isSameText("H300C", settings.getChildField("LogicName").getString()) ? "selected" : ""%>>H300C</option>
      </select>
    </v:form-field>
    <v:form-field caption="Cashdrawer on port 1">
			<v:db-checkbox field="settings.DrawerPort1" hint="Flag it if cashdrawer is connect to printer port 1" caption="" value="true" onclick="changePort1()"/>
    </v:form-field>
    <v:form-field caption="Cashdrawer on port 2">
			<v:db-checkbox field="settings.DrawerPort2" hint="Flag it if cashdrawer is connect to printer port 2" caption="" value="true" onclick="changePort2()"/>
    </v:form-field>
	</v:widget-block>
</v:widget>
<script>

function changePort1() {
  if ($("#settings\\.DrawerPort1").isChecked())
    $("#settings\\.DrawerPort2").prop("checked", false);
}

function changePort2() {
  if ($("#settings\\.DrawerPort2").isChecked())
    $("#settings\\.DrawerPort1").prop("checked", false);
}

function getPluginSettings() {
  return {
    LogicName: $("#settings\\.LogicName").val(),
    DrawerPort1: $("#settings\\.DrawerPort1").isChecked(),
    DrawerPort2: $("#settings\\.DrawerPort2").isChecked()
  };
}

</script>
