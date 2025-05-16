<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>

<v:widget caption="@Common.Settings">
  <v:widget-block>
<%--     <v:form-field caption="NI Dll file configuration Path">
      <v:input-text type="text" field="settings.ConfigFilePath"/>
    </v:form-field>
 --%>        <v:form-field caption="@Receipt.ReceiptWidth">
      <v:input-text field="settings.ReceiptWidth" placeholder="42"/>
    </v:form-field>
    
  </v:widget-block>
</v:widget>

<script>

function getPluginSettings() {
  return {
    ReceiptWidth: $("#settings\\.ReceiptWidth").val()
  };
}

</script>
