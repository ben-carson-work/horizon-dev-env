<%@page import="com.vgs.web.library.BLBO_Tax"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@page import="com.vgs.cl.document.*"%>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>
<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>

<v:widget  caption="@Common.Settings" icon="settings.png">
  <v:widget-block>
    <v:form-field caption="@Common.Name">
       <v:input-text field="settings.PrinterLogicName"/>
    </v:form-field>
    <v:form-field caption="@PluginSettings.Epson.DoubleWidthHeader">
      <v:db-checkbox field="settings.DoubleWidthHeader" caption="" value="true" />
    </v:form-field>
  </v:widget-block>
  <v:widget-block id="header-logo">
    <v:form-field caption="@PluginSettings.Epson.PrintHeaderLogo">
      <v:db-checkbox field="settings.PrintHeaderLogo" caption="@Common.Enabled" value="true"/>
    </v:form-field>
    <v:form-field id="header-logo-number" caption="@PluginSettings.Epson.HeaderLogoNumber">
       <v:input-text field="settings.HeaderLogoNumber" placeholder="1-9"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block id="footer-logo">
    <v:form-field caption="@PluginSettings.Epson.PrintFooterLogo">
      <v:db-checkbox field="settings.PrintFooterLogo" caption="@Common.Enabled" value="true"/>
    </v:form-field>
    <v:form-field id="footer-logo-number" caption="@PluginSettings.Epson.FooterLogoNumber">
       <v:input-text field="settings.FooterLogoNumber" placeholder="1-9"/>
    </v:form-field>
    <v:form-field caption="Lotteria Scontrini">
      <v:db-checkbox field="settings.LotteriaScontrini" caption="@Common.Enabled" value="true" />
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>

$(document).ready(function() {
  enableDisableHeaderLogo();
  enableDisableFooterLogo();
});

$("#settings\\.PrintHeaderLogo").change(enableDisableHeaderLogo);
$("#settings\\.PrintFooterLogo").change(enableDisableFooterLogo);

function enableDisableHeaderLogo() {
  var enabled = $("#settings\\.PrintHeaderLogo").isChecked();
    $("#header-logo-number").setClass("v-hidden", !enabled);
}

function enableDisableFooterLogo() {
  var enabled = $("#settings\\.PrintFooterLogo").isChecked();
    $("#footer-logo-number").setClass("v-hidden", !enabled);
}

function getPluginSettings() {
  var response = {
      PrinterLogicName: $("#settings\\.PrinterLogicName").val(),
      DoubleWidthHeader:$("#settings\\.DoubleWidthHeader").isChecked(),
      PrintHeaderLogo:$("#settings\\.PrintHeaderLogo").isChecked(),
      HeaderLogoNumber:$("#settings\\.HeaderLogoNumber").val(),
      PrintFooterLogo:$("#settings\\.PrintFooterLogo").isChecked(),
      FooterLogoNumber:$("#settings\\.FooterLogoNumber").val(),
      LotteriaScontrini:$("#settings\\.LotteriaScontrini").isChecked()
    };
  return response;
}
</script>
 