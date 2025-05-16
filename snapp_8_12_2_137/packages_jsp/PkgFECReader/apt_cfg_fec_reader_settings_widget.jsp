<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageWorkstation" scope="request"/>

<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>

<v:widget caption="@Common.Settings" icon="settings.png">
  <v:widget-block>
    <v:form-field caption="@FECReader.BrokerURL" hint="@FECReader.BrokerURLHint" mandatory="true">
      <v:input-text field="settings.BrokerURL" placeholder="tcp://120.0.0.1:8883" />
    </v:form-field>
    <v:form-field caption="@Common.UserName">
      <v:input-text field="settings.UserName"/>
    </v:form-field>
    <v:form-field caption="@Common.Password">
      <v:input-text field="settings.Password" type="password"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<input type="hidden" name="AptSettings"/>
 
<script>
  function saveAptSettings() {
    var cfg = {
        BrokerURL: $("#settings\\.BrokerURL").val(),
        UserName: $("#settings\\.UserName").val(),
        Password: $("#settings\\.Password").val()
    };
    
    $("[name='AptSettings']").val(JSON.stringify(cfg));
  }
</script>
