<%@page import="com.vgs.vcl.JvImageCache"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget id="prn-masung-settings" caption="Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
  <v:widget-block>
  	<v:form-field caption="Connection type">
      <select id="ConnectionType" class="form-control">
        <option value="USB" >USB</option>
        <option value="COM" >COM</option>
      </select>
    </v:form-field>
    <v:form-field caption="CodePage">
      <select id="CodePage" class="form-control">
        <option value="iso8859_6" >iso8859_6</option>
      </select>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
  var $cfg = $("#prn-masung-settings");
  
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.find("#ConnectionType").val(params.settings.ConnectionType);
    $cfg.find("#CodePage").val(params.settings.CodePage);
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
        ConnectionType : 		$cfg.find("#ConnectionType").val(),
        CodePage : 					$cfg.find("#CodePage").val()
      };
    });
  });
</script>