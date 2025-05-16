<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>


<v:widget caption="@Common.Settings">
  <v:widget-block>
    <v:form-field caption="System URL">
      <v:input-text type="text" field="settings.SystemURL"/>
    </v:form-field>
    <v:form-field caption="Customer">
      <v:input-text field="settings.Customer"/>
    </v:form-field>
    <v:form-field caption="Store">
      <v:input-text field="settings.Store"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>

//$("#ServerModeCombo").val($("#settings\\.ServerMode").val());

$(document).ready(function() {
  var txt = $("#settings\\.SystemURL");
  if (txt.val() == "")
    txt.val("https://demo-ipg.comtrust.ae:2443/MerchantAPIX.svc?singleWsdl");
});

function getPluginSettings() {
  return {
	  //ServerMode: $("#ServerModeCombo").val(),
    SystemURL: $("#settings\\.SystemURL").val(),
    Customer: $("#settings\\.Customer").val(),
    Store: $("#settings\\.Store").val()
  };
}

</script>
