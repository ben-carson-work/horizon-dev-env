<%@page import="com.vgs.cl.document.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<%
  JvDocument settings = (JvDocument)request.getAttribute("settings");
%>

<v:widget caption="Info">
  <v:widget-block>
    <p>
      The <b>"System channel"</b> parameter must be set on the <i>Extension Package for Universal Beijing</i> settings.
    </p>
  </v:widget-block>
</v:widget> 

<v:widget caption="Settings" icon="settings.png">
  <v:widget-block>
    <v:form-field caption="Taxpayer identification" hint="Seller’s taxpayer identification number" mandatory="true">
      <v:input-text field="settings.TaxPayerIdentification"/>
    </v:form-field>
    <v:form-field caption="Maximum TMS serials" hint="WARNING: Keep this number as low as possible because it impacts the performances of the system">
      <v:input-text field="settings.MaxTMSSerials" placeholder="5" type="number"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
  function getPluginSettings() {
    return {
      TaxPayerIdentification: $("#settings\\.TaxPayerIdentification").val(),
      MaxTMSSerials: $("#settings\\.MaxTMSSerials").val()
    };
  }
</script>