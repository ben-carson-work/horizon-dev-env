<%@page import="com.vgs.vcl.JvImageCache"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.LkSN"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget id="reader-posiflex-cd3601-settings" caption="Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block> 
    <v:input-text field="PortName" placeholder="COM2"/>
  </v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
  var $cfg = $("#reader-posiflex-cd3601-settings");
    
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.find("#PortName").val(params.settings.PortName);
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
        PortName : $cfg.find("#PortName").val()
      };
    });
});
</script>