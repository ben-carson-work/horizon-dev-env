<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>

<v:widget id="rws-membership-cms-settings" caption="Plugin settings">
  <v:widget-block>
    <v:form-field caption="Base URL">
      <v:input-text field="BaseURL" placeholder="ie: https://stagentapi.rwsentosa.com" />
    </v:form-field>
    <v:form-field caption="System ID">
      <v:input-text field="SystemId"/>
    </v:form-field>
    <v:form-field caption="Profit centre">
      <v:input-text field="ProfitCentre" placeholder="ie: FB-HOTEL"/>
    </v:form-field>
    <v:form-field caption="User name">
      <v:input-text field="UserName"/>
    </v:form-field>
    <v:form-field caption="Pre shared key">
      <v:input-text field="Password" type="password"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="Balance enpoint URL">
      <v:input-text field="BalanceEndpointURL" placeholder="cms/1/v2/member/points/balance" />
    </v:form-field>
    <v:form-field caption="Redeem enpoint URL">
      <v:input-text field="RedeemEndpointURL" placeholder="cms/1/v2/member/points/redeem" />
    </v:form-field>
    <v:form-field caption="Void enpoint URL">
      <v:input-text field="VoidEndpointURL" placeholder="cms/1/v2/member/points/void" />
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
  var $cfg = $("#rws-membership-cms-settings");
  
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.find("#BaseURL").val(params.settings.BaseURL);
    $cfg.find("#SystemId").val(params.settings.SystemId);
    $cfg.find("#ProfitCentre").val(params.settings.ProfitCentre);
    $cfg.find("#UserName").val(params.settings.UserName);
    $cfg.find("#Password").val(params.settings.Password);
    $cfg.find("#BalanceEndpointURL").val(params.settings.BalanceEndpointURL);
    $cfg.find("#RedeemEndpointURL").val(params.settings.RedeemEndpointURL);
    $cfg.find("#VoidEndpointURL").val(params.settings.VoidEndpointURL);
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
      BaseURL: $cfg.find("#BaseURL").val(),  
      SystemId: $cfg.find("#SystemId").val(),  
      ProfitCentre: $cfg.find("#ProfitCentre").val(),  
      UserName: $cfg.find("#UserName").val(),  
      Password: $cfg.find("#Password").val(),
      BalanceEndpointURL: $cfg.find("#BalanceEndpointURL").val(),
      RedeemEndpointURL: $cfg.find("#RedeemEndpointURL").val(),
      VoidEndpointURL: $cfg.find("#VoidEndpointURL").val(),
    };
  });

});
</script>