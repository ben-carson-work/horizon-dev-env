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
<jsp:useBean id="settings" class="com.vgs.entity.dataobject.DOPlgSettings_AuthRapidConnect" scope="request"/>

<style>

.settings-section {
  font-weight: bold;
  text-decoration: underline;
}

</style>

<v:widget caption="@Common.Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
    <table class="form-table" >
      <tr>
        <th><label for="settings.MerchantId"><v:itl key="@Common.MerchantId"/></label></th>
        <td><v:input-text field="settings.MerchantId"/></td>
      </tr>
      <tr>
        <th><label for="settings.TPPId"><v:itl key="TPP Id"/></label></th>
        <td><v:input-text field="settings.TPPId"/></td>
      </tr>
      <tr>
        <th><label for="settings.TerminalId"><v:itl key="Terminal Id"/></label></th>
        <td><v:input-text field="settings.TerminalId"/></td>
      </tr>
      <tr>
        <th><label for="settings.GroupId"><v:itl key="Group Id"/></label></th>
        <td><v:input-text field="settings.GroupId"/></td>
      </tr>
      <tr>
        <th><label for="settings.DID"><v:itl key="DID"/></label></th>
        <td><v:input-text field="settings.DID"/></td>
      </tr>
      <tr>
        <th><label for="settings.URL"><v:itl key="URL"/></label></th>
        <td><v:input-text field="settings.URL"/></td>
      </tr>
      <tr>
        <th><label for="settings.AlternateURL"><v:itl key="Alternate URL"/></label></th>
        <td><v:input-text field="settings.AlternateURL"/></td>
      </tr>
    </table>
  </v:widget-block>
  <v:widget-block>
    <div class="settings-section"><v:itl key="TransArmor"/></div>
    <table class="form-table" >      
      <tr>
        <th><label for="settings.KeyID"><v:itl key="Encryption Key ID"/></label></th>
        <td><v:input-text field="settings.KeyID"/></td>
      </tr>
      <tr>
        <th><label for="settings.TknType"><v:itl key="Token Type"/></label></th>
        <td><v:input-text field="settings.TknType"/></td>
      </tr>
    </table>
  </v:widget-block>
</v:widget>
 
 
<script>

function getPluginSettings() {
  return {
    MerchantId: $("#settings\\.MerchantId").val(),
    TPPId: $("#settings\\.TPPId").val(), 
    TerminalId: $("#settings\\.TerminalId").val(),
    GroupId: $("#settings\\.GroupId").val(),
    DID: $("#settings\\.DID").val(),
    KeyID: $("#settings\\.KeyID").val(),
    TknType: $("#settings\\.TknType").val(),
    URL: $("#settings\\.URL").val(),
    AlternateURL: $("#settings\\.AlternateURL").val()
  };
}
</script>
 