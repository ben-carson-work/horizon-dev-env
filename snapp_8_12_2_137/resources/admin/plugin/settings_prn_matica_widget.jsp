<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>
<jsp:useBean id="settings" class="com.vgs.entity.dataobject.DOPlgSettings_PrnMatica" scope="request"/>


<v:widget caption="@Common.Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
    <table class="form-table" >
      <tr>
        <th><label for="settings.PrinterName"><v:itl key="@Common.Name"/></label></th>
        <td><v:input-text field="settings.PrinterName"/></td>
      </tr>
      <tr>
        <th><label for="settings.PrinterDPI"><v:itl key="@Common.DPI"/></label></th>
        <td><v:input-text field="settings.PrinterDPI"/></td>
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

function getPluginSettings() {
  return {
    PrinterDPI: $("#settings\\.PrinterDPI").val(),
    PrinterName: $("#settings\\.PrinterName").val(),
    RFIDEnabled: $("#settings\\.RFIDEnabled").isChecked()
  };
}

</script>
