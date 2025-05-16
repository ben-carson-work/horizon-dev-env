<%@page import="com.vgs.vcl.JvImageCache"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget id="wpg-anz-settings" caption="Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
  	<v:form-field caption="API key" mandatory="true">
      <v:input-text field="APIKey"/>
    </v:form-field>
  	<v:form-field caption="API secret" mandatory="true">
      <v:input-text field="APISecret" />
    </v:form-field>
  	<v:form-field caption="API EndPoint" mandatory="true">
      <v:input-text field="EndPoint"/>
    </v:form-field>
  	<v:form-field caption="merchant id" mandatory="true">
      <v:input-text field="MerchantId" />
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
  var $cfg = $("#wpg-anz-settings");
  
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.find("#APIKey").val(params.settings.APIKey);
    $cfg.find("#APISecret").val(params.settings.APISecret);
    $cfg.find("#EndPoint").val(params.settings.EndPoint);
    $cfg.find("#MerchantId").val(params.settings.MerchantId);
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
        APIKey : 					$cfg.find("#APIKey").val(),
        APISecret : 			$cfg.find("#APISecret").val(),
        EndPoint : 				$cfg.find("#EndPoint").val(),
        MerchantId : 			$cfg.find("#MerchantId").val()
      };
    });
  });
</script>