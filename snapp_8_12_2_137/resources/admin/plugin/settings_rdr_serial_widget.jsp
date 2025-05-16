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
<jsp:useBean id="settings" class="com.vgs.entity.dataobject.DOPlgSettings_RdrSerial" scope="request"/>


<v:widget caption="@Common.Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block  id="interface-serial">
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

function getPluginSettings() {
  return {
    PortName: $("#settings\\.PortName").val(),
    BaudRate: $("#settings\\.BaudRate").val(),
  };
}

</script>
