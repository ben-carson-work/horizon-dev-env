<%@page import="com.vgs.vcl.JvImageCache"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.LkSN"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget id="reader-virtual-sdm-settings" caption="Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
    <v:form-field caption="Media Code" hint="This property is used to set read media code." mandatory="true">
      <v:input-text field="MediaCode" placeholder="IT3FW4EFFE" />
    </v:form-field>
    <v:form-field caption="Interval" hint="This property is used to set the interval between readings." mandatory="true">
      <v:input-text field="Interval" placeholder="10" />
    </v:form-field>        
  </v:widget-block>
</v:widget>
<script>
$(document).ready(function() {
  var $cfg = $("#reader-virtual-sdm-settings");
    
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.find("#MediaCode").val(params.settings.MediaCode);
    $cfg.find("#Interval").val(params.settings.Interval);
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
        MediaCode : $cfg.find("#MediaCode").val(),
        Interval : $cfg.find("#Interval").val()
      };
    });
});
</script>