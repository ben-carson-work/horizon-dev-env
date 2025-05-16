<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>
<jsp:useBean id="settings" class="com.vgs.entity.dataobject.DOPlgSettings_EpsonTcp" scope="request"/>


<v:widget caption="@Common.Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
    <table class="form-table" >
       <tr>
        <th><label for="settings.TcpAddress"><v:itl key="@Plugin.TcpAddress"/></label></th>
        <td><v:input-text field="settings.TcpAddress"/></td>
      </tr>
      <tr>
        <th><label for="settings.TcpPort"><v:itl key="@Plugin.TcpPort"/></label></th>
        <td><v:input-text field="settings.TcpPort"/></td>
      </tr>
      <tr>
        <th><label for="settings.IgnorePrintConfirmation"><v:itl key="@Plugin.IgnorePrintConfirmation"/></label></th>
        <td><v:db-checkbox field="settings.IgnorePrintConfirmation" caption="" value="true" /></td>
      </tr>
    </table>
  </v:widget-block>
</v:widget>
 
<script>

function getPluginSettings() {
  return {
	  TcpAddress: $("#settings\\.TcpAddress").val(),
	    TcpPort: $("#settings\\.TcpPort").val(),
	    IgnorePrintConfirmation: $("#settings\\.IgnorePrintConfirmation").isChecked()
  };
}

</script>
