<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>

<div id="gep-kafka-settings">

  <v:widget caption="@Common.Settings">
    <v:widget-block>
      <v:form-field caption="Base URL" hint="Endpoint where outbound messages will be sent to (ie: https://api.qa.us.te2.io)">
        <v:input-text field="BaseURL" clazz="gep-field"/>
      </v:form-field>
      <v:form-field caption="@Common.ConnectionTimeoutMSecs" hint="@Common.ConnectionTimeoutMSecsHint">
        <v:input-text field="ConnectionTimeout" clazz="gep-field" placeholder="0" type="number" min="0"/>
      </v:form-field>
      <v:form-field caption="@Common.ReadTimeoutMSecs" hint="@Common.ReadTimeoutMSecsHint">
        <v:input-text field="ReadTimeout" clazz="gep-field" type="number" placeholder="0" min="0"/>
      </v:form-field>
    </v:widget-block>
    
    <v:widget-block>
      <v:form-field caption="AccountId">
        <v:input-text field="TokenAccountId" clazz="gep-field"/>
      </v:form-field>
      <v:form-field caption="Scopes">
        <v:input-text field="TokenScopes" clazz="gep-field" placeholder="message.read message.write admin"/>
      </v:form-field>
      <v:form-field caption="Private key">
        <v:input-txtarea field="TokenPrivateKey" clazz="gep-field" rows="10" style="font-family:monospace"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>

</div>


<script>
$(document).ready(function() {
  var $cfg = $("#gep-kafka-settings");

  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    for (const key of Object.keys(params.settings)) 
      $cfg.find("#" + key + ".gep-field").val(params.settings[key]);
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {};
    $cfg.find(".gep-field").each(function() {
      var $field = $(this);
      params.settings[$field.attr("id")] = $field.val();
    });
  });
});
</script>