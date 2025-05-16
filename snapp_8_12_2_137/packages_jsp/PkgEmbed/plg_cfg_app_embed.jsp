<%@page import="com.vgs.web.library.BLBO_Plugin"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>
<%  JvDocument settings = (JvDocument)request.getAttribute("settings"); %>
<v:widget caption="@Common.Settings" icon="settings.png">
  <v:widget-block>
    <v:form-field caption="@Common.WebServicesURL">
     <v:input-text field="settings.Url"/>
    </v:form-field>
    <v:form-field caption="@PluginSettings.Embed.ConsumerKey">
      <v:input-text field="settings.User"/>
    </v:form-field>
    <v:form-field caption="@PluginSettings.Embed.Secret">
      <% String password = settings.getChildField("Password").isNull() ? "" : BLBO_Plugin.MASKER_PASS; %>
      <input type="password" id="settings.Password" class="form-control" value="<%=JvString.escapeHtml(password)%>">
    </v:form-field>
    <v:form-field caption="@PluginSettings.Embed.CashierId">
      <v:input-text field="settings.CashierId"/>
    </v:form-field>
    <v:form-field caption="@PluginSettings.Embed.CardHistoryDays">
      <v:input-text field="settings.CardHistoryDays" type="number" defaultValue="90"/>
    </v:form-field>
    <v:form-field caption="@PluginSettings.Embed.AllowBarcodeEncoding">
      <v:db-checkbox field="settings.AllowBarcodeEncoding" caption="" value="true" />
    </v:form-field>
    <v:form-field caption="@PluginSettings.Embed.UseEmbedWallet">
      <v:db-checkbox field="settings.UseEmbedWallet" caption="" value="true" />
    </v:form-field>
  </v:widget-block>
</v:widget>
 
<script>

function getPluginSettings() {
  return {
    Url: $("#settings\\.Url").val(),
    User: $("#settings\\.User").val(),
    Password: $("#settings\\.Password").val(),
    CashierId: $("#settings\\.CashierId").val(),
    CardHistoryDays: $("#settings\\.CardHistoryDays").val(),
    AllowBarcodeEncoding: $("#settings\\.AllowBarcodeEncoding").isChecked(),
    UseEmbedWallet: $("#settings\\.UseEmbedWallet").isChecked()
  };
}

</script>
 