<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% boolean canEdit = pageBase.isParameter("canEdit", "true");%>

<v:widget id="occdb-redis-settings" caption="@Common.Settings">
  <v:widget-block>
    <v:form-field caption="Endpoint">
      <v:input-text field="RedisEndpoint" enabled="<%=canEdit%>"/>
    </v:form-field>
    <v:form-field caption="Port">
      <v:input-text field="RedisPort" enabled="<%=canEdit%>"/>
    </v:form-field>
    <v:form-field caption="Username">
      <v:input-text field="RedisUsername" enabled="<%=canEdit%>"/>
    </v:form-field>
    <v:form-field caption="Password">
      <v:input-text type="password" field="RedisPassword" enabled="<%=canEdit%>"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="Connection timeout" hint="Connection timeout in milliseconds">
      <v:input-text field="RedisConnectionTimeout" placeholder="1000" enabled="<%=canEdit%>"/>
    </v:form-field>
    <v:form-field caption="Read timeout" hint="Read timeout in milliseconds">
      <v:input-text field="RedisReadTimeout" placeholder="1000" enabled="<%=canEdit%>"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
  var $cfg = $("#occdb-redis-settings");
  
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.find("#RedisEndpoint").val(params.settings.Endpoint);
    $cfg.find("#RedisPort").val(params.settings.Port);
    $cfg.find("#RedisUsername").val(params.settings.Username);
    $cfg.find("#RedisPassword").val(params.settings.Password);
    $cfg.find("#RedisConnectionTimeout").val(params.settings.ConnectionTimeoutMS);
    $cfg.find("#RedisReadTimeout").val(params.settings.ReadTimeoutMS);
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
      Endpoint:            $cfg.find("#RedisEndpoint").val(),
      Port:                _parseInt($cfg.find("#RedisPort")),
      Username:            $cfg.find("#RedisUsername").val(),
      Password:            $cfg.find("#RedisPassword").val(),
      ConnectionTimeoutMS: _parseInt($cfg.find("#RedisConnectionTimeout")),
      ReadTimeoutMS:       _parseInt($cfg.find("#RedisReadTimeout")),
    };
  });
  
  function _parseInt($field) {
    var value = getNull($field.val());
    if (value == null)
      return null;
    else {
      var result = parseInt(value);
      if (isNaN(result)) {
        var fieldName = $field.closest(".form-field").find(".form-field-caption").text();
        throw "Invalid value \"" + value + "\" for field \"" + fieldName + "\""
      }
      return result;
    }
  }
});
</script>
