<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>

<v:widget id="rws-tcon-settings" caption="Plugin settings">
  <v:widget-block>
    <v:form-field caption="Server URL">
      <v:input-text field="ServerURL" placeholder="ie: https://stapigatewayint.rwsentosa.com" />
    </v:form-field>
    <v:form-field caption="Source ID">
      <v:input-text field="SourceId"/>
    </v:form-field>
    <v:form-field caption="Auth user name">
      <v:input-text field="AuthUserName"/>
    </v:form-field>
    <v:form-field caption="Auth preshared key">
      <v:input-text field="AuthPresharedKey" type="password"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="Logon user name">
      <v:input-text field="LogonUserName"/>
    </v:form-field>
    <v:form-field caption="Logon password">
      <v:input-text field="LogonPassword" type="password"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="Session timeout (sec)">
      <v:input-text field="SessionTimeout" type="number" placeholder="300"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="Product type"  hint="Product type used by the system to generate the ticket associated with the scanned barcode"> 
      <snp:dyncombo id="ProductId" entityType="<%=LkSNEntityType.ProductType%>"/>
    </v:form-field>
  </v:widget-block>
  
</v:widget>

<script>
$(document).ready(function() {
  var $cfg = $("#rws-tcon-settings");
  
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.find("#ServerURL").val(params.settings.ServerURL);
    $cfg.find("#SourceId").val(params.settings.SourceId);
    $cfg.find("#LogonUserName").val(params.settings.LogonUserName);
    $cfg.find("#LogonPassword").val(params.settings.LogonPassword);
    $cfg.find("#AuthUserName").val(params.settings.AuthUserName);
    $cfg.find("#AuthPresharedKey").val(params.settings.AuthPresharedKey);
    $cfg.find("#SessionTimeout").val(params.settings.SessionTimeout);
    $cfg.find("#ProductId").val(params.settings.ProductId);
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
    	ServerURL: $cfg.find("#ServerURL").val(),  
      SourceId: $cfg.find("#SourceId").val(),  
      LogonUserName: $cfg.find("#LogonUserName").val(),  
      LogonPassword: $cfg.find("#LogonPassword").val(),
      AuthUserName: $cfg.find("#AuthUserName").val(),  
      AuthPresharedKey: $cfg.find("#AuthPresharedKey").val(),
      SessionTimeout: $cfg.find("#SessionTimeout").val(),
      ProductId: $cfg.find("#ProductId").val()
    };
  });

});
</script>