<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>

<div id="motf-restful-reader-settings">

  <v:widget caption="@Common.Settings">
    <v:widget-block>
      <jsp:include page="doc-openapi.jspf"></jsp:include>
    </v:widget-block>
    
    <v:widget-block>
      <v:form-field caption="Client ID" hint="RFID reader identifier (can be any string) to be shared with MOTF rfid layer">
        <v:input-text field="ClientId" clazz="motf-field"/>
      </v:form-field>
      <v:form-field caption="Client Key" hint="Private key used to sign JWT token to be shared with MOTF rfid layer">
        <v:input-text field="ClientKey" clazz="motf-field" type="password"/>
      </v:form-field>
      <v:form-field caption="TCP/IP Port" hint="TCP/IP port on wich the plugin should listen for incoming requests">
        <v:input-text field="TcpIpPort" clazz="motf-field" type="number"/>
      </v:form-field>
      <v:form-field caption="Idle timeout secs" hint="Number of seconds after which, if not receivig any incoming call from the device, the POS will assume the device is offline/disconnected">
        <v:input-text field="IdleSecs" clazz="motf-field" type="number"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>

</div>


<script>
$(document).ready(function() {
  var $cfg = $("#motf-restful-reader-settings");

  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.docToView({"doc":params.settings});
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = $cfg.find(".motf-field").viewToDoc();
  });
});
</script>