<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>
<jsp:useBean id="settings" class="com.vgs.entity.dataobject.DOPlgSettings_AuthMercury" scope="request"/>


<v:widget caption="@Common.Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
    <table class="form-table" >
      <tr>
        <th><label for="settings.MerchantId"><v:itl key="@Common.MerchantId"/></label></th>
        <td><v:input-text field="settings.MerchantId"/></td>
      </tr>
      <tr>
        <% String password = settings.Password.isNull() ? "" : BLBO_Plugin.MASKER_PASS; %>
        <th><label for="settings.Password"><v:itl key="@Common.Password"/></label></th>
        <td><input type="password" id="settings.Password" value="<%=JvString.escapeHtml(password)%>"/></td>
      </tr>
      <tr>
        <th><label for="settings.WebServicesURL"><v:itl key="@Common.WebServicesURL"/></label></th>
        <td><v:input-text field="settings.WebServicesURL"/></td>
      </tr>
    </table>
  </v:widget-block>
</v:widget>
 
 
<script>

function getPluginSettings() {
  return {
    MerchantId: $("#settings\\.MerchantId").val(),
    WebServicesURL: $("#settings\\.WebServicesURL").val(),
    Password: $("#settings\\.Password").val()
  };
}

</script>
 