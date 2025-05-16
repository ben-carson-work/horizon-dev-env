<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.JvDataSet"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget caption="@Common.Settings">
  <v:widget-block>
    <v:form-field caption="@Common.WebServicesURL">
      <v:input-text field="settings.Url"/>
    </v:form-field>
    <v:form-field caption="@PluginSettings.Embed.ConsumerKey">
      <v:input-text field="settings.User"/>
    </v:form-field>
    <v:form-field caption="@PluginSettings.Embed.Secret">
      <v:input-text field="settings.Password" type="password"/>
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
    <v:form-field caption="@PluginSettings.Embed.UseBKOThumbPrint" hint="@PluginSettings.Embed.UseBKOThumbPrintHint">
      <v:db-checkbox field="settings.UseBKOThumbPrint" caption="" value="true" />
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
    UseEmbedWallet: $("#settings\\.UseEmbedWallet").isChecked(),
    UseBKOThumbPrint: $("#settings\\.UseBKOThumbPrint").isChecked()
  };
}

</script>