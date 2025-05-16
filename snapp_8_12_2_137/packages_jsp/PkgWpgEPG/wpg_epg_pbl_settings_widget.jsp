<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>

<v:widget id="wpg_epg_pbl-settings" caption="@Common.Settings">
  <v:widget-block>
    <v:form-field caption="System URL" mandatory="true">
      <v:input-text field="SystemURL" type="text"/>
    </v:form-field>  
    <v:form-field caption="Customer">
      <v:input-text field="Customer"/>
    </v:form-field>
    <v:form-field caption="Store">
      <v:input-text field="Store"/>
    </v:form-field>
    <v:form-field caption="Terminal">
      <v:input-text field="Terminal"/>
    </v:form-field>  
    <v:form-field caption="User Name" mandatory="true">
      <v:input-text field="UserName"/>
    </v:form-field> 
    <v:form-field caption="User Password" mandatory="true">
      <v:input-text field="Password" type="password" />
    </v:form-field>            
  </v:widget-block>
</v:widget>

<script>


$(document).ready(function() {
  var $cfg = $("#wpg_epg_pbl-settings");
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.find("#SystemURL").val(params.settings.SystemURL);
    $cfg.find("#Customer").val(params.settings.Customer);
    $cfg.find("#Store").val(params.settings.Store);
    $cfg.find("#Terminal").val(params.settings.Terminal);
    $cfg.find("#UserName").val(params.settings.UserName);
    $cfg.find("#Password").val(params.settings.Password);
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
    		SystemURL :     	$cfg.find("#SystemURL").val(),
    		Customer : 			  $cfg.find("#Customer").val(),
    		Store:    			  $cfg.find("#Store").val(),
    		Terminal:    			$cfg.find("#Terminal").val(),
    		UserName:    			$cfg.find("#UserName").val(),
    		Password:    			$cfg.find("#Password").val()
      };
    });
});

</script>
