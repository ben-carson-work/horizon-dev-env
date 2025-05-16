<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>
<jsp:useBean id="settings" class="com.vgs.entity.dataobject.DOPlgSettings_Stimare" scope="request"/>


<v:widget caption="@Common.Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
    <table class="form-table" >
      <tr>
        <th><label for="settings.InterfaceType"><v:itl key="@Common.InterfaceType"/></label></th>
        <td> 
          <select id="settings.InterfaceType" class="form-control">
            <% String sel = (settings.InterfaceType.getInt() == 1) ? "selected" : ""; %>
            <option value="1" <%= sel %>>TCP/IP</option>
            <% sel = (settings.InterfaceType.getInt() == 2) ? "selected" : ""; %>
            <option value="2" <%= sel %>>Serial</option>
            <% sel = (settings.InterfaceType.getInt() == 3) ? "selected" : ""; %>
            <option value="3" <%= sel %>>USB</option>
          </select>
        </td>       
      </tr>
    </table>
  </v:widget-block>
  <v:widget-block id="interface-serial" clazz="v-hidden">
    <table class="form-table" >
      <tr>
        <th><label for="settings.PortName"><v:itl key="@Common.PortName"/></label></th>
        <td> 
          <select id="settings.PortName" class="form-control">
          <% for (LookupItem comPort : LkSN.ComPort.getItems()) { %>
            <% String com = comPort.getDescription(); %>
            <% String sel = JvString.isSameText(com, settings.PortName.getString()) ? "selected" : ""; %>
            <option value="<%=com%>" <%=sel%>><%=com%></option>
          <% } %>
          </select>
        </td>       
      </tr>
      <tr>
        <th><label for="settings.BaudRate"><v:itl key="@Common.Baudrate"/></label></th>
        <td>
          <v:lk-combobox lookup="<%=LkSN.BaudRate%>" field="settings.BaudRate"/>
        </td>
      </tr>
    </table>
  </v:widget-block>
  <v:widget-block id="interface-tcp" clazz="v-hidden">
    <table class="form-table" >
      <tr>
        <th><label for="settings.HostName"><v:itl key="@Common.HostName"/></label></th>
        <td><v:input-text field="settings.HostName"/></td>
      </tr>
      <tr>
        <th><label for="settings.HostPort"><v:itl key="@Common.HostPort"/></label></th>
        <td><v:input-text field="settings.HostPort"/></td>
      </tr>
    </table>
  </v:widget-block>
  <v:widget-block>
    <table class="form-table" >
      <tr>
        <th><label for="settings.CutAllTickets"><v:itl key="@Common.CutAllTickets"/></label></th>
        <td><v:db-checkbox field="settings.CutAllTickets" caption="" value="true" /></td>
      </tr>
    </table>
  </v:widget-block>
  <v:widget-block>
    <table class="form-table" >
      <tr>
        <th><label for="settings.RFIDEnabled"><v:itl key="@Common.RFID"/></label></th>
        <td><v:db-checkbox field="settings.RFIDEnabled" caption="@Common.Enabled" value="true" /></td>
      </tr>
    </table>
  </v:widget-block>
</v:widget>
 
 
<script>

$(document).ready(function() {
  $("#settings\\.InterfaceType").val(<%=settings.InterfaceType.getInt()%>);
  enableDisable();  
});
  
$("#settings\\.InterfaceType").change(enableDisable);

function enableDisable() {
  var inter = $("#settings\\.InterfaceType").val();
  $("#interface-tcp").setClass("v-hidden", inter != 1); 
  $("#interface-serial").setClass("v-hidden", inter != 2); 
  $("#interface-USB").setClass("v-hidden", inter != 3); 
}

function getPluginSettings() {
  return {
    InterfaceType: $("#settings\\.InterfaceType").val(),
    PortName: $("#settings\\.PortName").val(),
    BaudRate: $("#settings\\.BaudRate").val(),
    HostName: $("#settings\\.HostName").val(),
    HostPort: $("#settings\\.HostPort").val(),
/*     UsbDeviceNumber: $("#settings\\.UsbDeviceNumber").val(), */
    RFIDEnabled: $("#settings\\.RFIDEnabled").isChecked(),
    CutAllTickets: $("#settings\\.CutAllTickets").isChecked()
  };
}

</script>
 