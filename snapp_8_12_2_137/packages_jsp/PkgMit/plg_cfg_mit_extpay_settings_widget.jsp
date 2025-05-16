<%@page import="com.vgs.vcl.JvImageCache"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget id="edp-mit-settings" caption="Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
  	<v:form-field caption="@Common.User" mandatory="true">
      <v:input-text field="User"/>
    </v:form-field>
  	<v:form-field caption="@Common.Password" mandatory="true">
      <v:input-text field="Password" type="password"/>
    </v:form-field>
  	<v:form-field caption="Company" mandatory="true">
      <v:input-text field="Company"/>
    </v:form-field>
  	<v:form-field caption="Branch" mandatory="true">
      <v:input-text field="Branch"/>
    </v:form-field>
  	<v:form-field caption="@Common.URL" mandatory="true">
      <v:input-text field="Url" />
    </v:form-field>
		<v:form-field caption="Key URL" mandatory="true">
      <v:input-text field="KeyUrl" />
    </v:form-field>
  	<v:form-field caption="Currency">
      <select id="CurrencyType" class="form-control">
        <option value="MXN" >MXN</option>
        <option value="USD" >USD</option>
      </select>
    </v:form-field>
    <v:form-field caption="Voucher width" >
      <v:input-text field="ReceiptWidth" placeholder="48" type="number"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
  var $cfg = $("#edp-mit-settings");
  
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.find("#User").val(params.settings.User);
    $cfg.find("#Password").val(params.settings.Password);
    $cfg.find("#Company").val(params.settings.Company);
    $cfg.find("#Branch").val(params.settings.Branch);
    $cfg.find("#Url").val(params.settings.Url);
    $cfg.find("#KeyUrl").val(params.settings.KeyUrl);
    $cfg.find("#ReceiptWidth").val(params.settings.ReceiptWidth);
    $("#CurrencyType").val(params.settings.CurrencyType);
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
  			User : 					$cfg.find("#User").val(),
        Password : 			$cfg.find("#Password").val(),
        Company : 			$cfg.find("#Company").val(),
        Branch : 				$cfg.find("#Branch").val(),
        Url : 					$cfg.find("#Url").val(),
        KeyUrl : 				$cfg.find("#KeyUrl").val(),
        ReceiptWidth : 	$cfg.find("#ReceiptWidth").val(),
        CurrencyType : 	$("#CurrencyType").val()
      };
    });
  });
</script>