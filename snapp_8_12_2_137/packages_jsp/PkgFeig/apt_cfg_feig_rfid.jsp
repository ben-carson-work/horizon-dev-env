<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageWorkstation" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%
  boolean canEdit = rights.SystemSetupLicensee.canUpdate();
  JvDocument settings = (JvDocument)request.getAttribute("settings");
%>
<% String sDisabled = (canEdit) ? "" : "disabled=\"disabled\""; %>


<v:widget caption="@Common.Settings" icon="settings.png">
  <v:widget-block id="interface-type-combo">
    <v:form-field caption="@Common.Type">
      <select id="settings.InterfaceType" class="form-control" <%=sDisabled%>>
        <option value=1>TCP/IP</option>
        <option value=2>Serial</option>
        <option value=3>USB</option>
      </select> 
    </v:form-field>
  </v:widget-block>
  <v:widget-block id="interface-tcp" clazz="v-hidden">
    <v:form-field caption="@Common.HostName">
      <v:input-text field="settings.HostName" enabled="<%=canEdit%>"/>
    </v:form-field>
    <v:form-field caption="@Common.HostPort">
      <v:input-text field="settings.HostPort" enabled="<%=canEdit%>"/>
    </v:form-field>
    <v:form-field caption="@Common.ServerName">
      <v:input-text field="settings.ServerName"/>
    </v:form-field>
    <v:form-field caption="@Common.ServerPort">
      <v:input-text field="settings.ServerPort"/>
    </v:form-field>
    <v:form-field caption="@Common.Timeout">
      <v:input-text field="settings.Timeout" enabled="<%=canEdit%>"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="@PluginSettings.FeigRfid.ReversalRead">
      <v:db-checkbox field="settings.ReversalRead" hint="@PluginSettings.FeigRfid.ReversalReadHint" caption="@Common.Enabled" value="true"/>
    </v:form-field>
	</v:widget-block>
  <v:widget-block  id="interface-serial" clazz="v-hidden">
    <v:form-field caption="@Common.PortName">
      <select id="settings.PortName" class="form-control">
        <% for (LookupItem comPort : LkSN.ComPort.getItems()) { %>
          <% String com = comPort.getDescription(); %>
          <% String sel = JvString.isSameText(com, settings.getChildField("PortName").getString()) ? "selected" : ""; %>
          <option value="<%=com%>" <%=sel%>><%=com%></option>
        <% } %>
      </select>
    </v:form-field>
    <v:form-field caption="@Common.Baudrate">
      <v:lk-combobox lookup="<%=LkSN.BaudRate%>" field="settings.BaudRate"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block  id="interface-serial">
    <v:form-field caption="@AccessPoint.ValidTicketRelay">
      <v:input-text field="settings.ValidTicketRelay" enabled="<%=canEdit%>"/>
    </v:form-field>
    <v:form-field caption="@AccessPoint.RelayOpenDuration">
      <v:input-text field="settings.ValidTicketRelayDuration" enabled="<%=canEdit%>"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="@AccessPoint.InvalidTicketRelay">
      <v:input-text field="settings.InvalidTicketRelay" enabled="<%=canEdit%>"/>
    </v:form-field>
    <v:form-field caption="@AccessPoint.RelayOpenDuration">
      <v:input-text field="settings.InvalidTicketRelayDuration" enabled="<%=canEdit%>"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="@AccessPoint.OpenTurnstileRelay">
      <v:input-text field="settings.OpenTurnstileRelay" enabled="<%=canEdit%>"/>
    </v:form-field>
    <v:form-field caption="@AccessPoint.RelayOpenDuration">
      <v:input-text field="settings.OpenTurnstileRelayDuration" enabled="<%=canEdit%>"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

  <input type="hidden" name="AptSettings"/>

<script>

$(document).ready(function() {
  $("#settings\\.InterfaceType").val(<%=settings.getChildField("InterfaceType").getInt()%>);
  enableDisable();
});

$("#settings\\.InterfaceType").change(enableDisable);

function enableDisable() {
	var inter = $("#settings\\.InterfaceType").val();
  $("#interface-tcp").setClass("v-hidden", inter != 1); 
  $("#interface-serial").setClass("v-hidden", inter != 2); 
}

function saveAptSettings() {
  var cfg = {
    InterfaceType: $("#settings\\.InterfaceType").val(),
    HostName: $("#settings\\.HostName").val(),
    HostPort: $("#settings\\.HostPort").val(),
    ServerName: $("#settings\\.ServerName").val(),
    ServerPort: $("#settings\\.ServerPort").val(),
    Timeout: $("#settings\\.Timeout").val(),
    PortName: $("#settings\\.PortName").val(),
    BaudRate: $("#settings\\.BaudRate").val(),
    ValidTicketRelay: $("#settings\\.ValidTicketRelay").val(),
    InvalidTicketRelay: $("#settings\\.InvalidTicketRelay").val(),
    OpenTurnstileRelay: $("#settings\\.OpenTurnstileRelay").val(),
    ValidTicketRelayDuration: $("#settings\\.ValidTicketRelayDuration").val(),
    InvalidTicketRelayDuration: $("#settings\\.InvalidTicketRelayDuration").val(),
    OpenTurnstileRelayDuration: $("#settings\\.OpenTurnstileRelayDuration").val(),
    ReversalRead: $("#settings\\.ReversalRead").isChecked()
  };
  
  $("[name='AptSettings']").val(JSON.stringify(cfg));
}

</script>
