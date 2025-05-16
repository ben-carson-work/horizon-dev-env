<%@page import="com.vgs.snapp.lookup.LkSN"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>
<jsp:useBean id="settings" class="com.vgs.entity.dataobject.DOPlgSettings_Star" scope="request"/>


<v:widget caption="@Common.Settings" icon="settings.png">

  <v:widget-block>
    <table class="form-table">
      <tr>
        <th><label for="settings.ConnectionType"><v:itl
              key="@Common.InterfaceType" /></label></th>
        <td><select id="settings.ConnectionType" class="form-control" field="settings.ConnectionType">
            <option value="1" ><v:itl key="@Common.ComOverBluethooth"/></option>
            <option value="2" ><v:itl key="@Common.Bluethooth"/></option>
        </select></td>
      </tr>
    </table>
  </v:widget-block>


  <v:widget-block id="interface-COM" clazz="v-hidden">
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
</v:widget>

 
<script>

$(document).ready(function() {
  $("#settings\\.ConnectionType").val(<%=((settings.ConnectionType.getInt()!=2) ? 1 : 2) %>);
  enableDisable();  
});
  
$("#settings\\.ConnectionType").change(enableDisable);

function enableDisable() {
  var inter = $("#settings\\.ConnectionType").val();
  $("#interface-COM").setClass("v-hidden", inter == 2);
}


function getPluginSettings() {
  return {
    PortName: $("#settings\\.PortName").val(),
    BaudRate: $("#settings\\.BaudRate").val(),
    ConnectionType: $("#settings\\.ConnectionType").val()
  };
}

</script>
