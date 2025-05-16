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
      <%-- 
      <select id="ServerModeCombo">
        <option value="TEST">TEST</option>
        <option value="PROD">PRODUCTION</option>
      </select>
      --%>
    </v:form-field>
    <v:form-field caption="Merchant ID">
      <v:input-text field="settings.MerchantID"/>
    </v:form-field>
    <v:form-field caption="Key">
      <v:input-text field="settings.MerchantKey"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>

//$("#ServerModeCombo").val($("#settings\\.ServerMode").val());

$(document).ready(function() {
  var txt = $("#settings\\.SystemURL");
  if (txt.val() == "")
    txt.val("https://test.timesofmoney.com/direcpay/secure/PaymentTransactionServlet");
});

function getPluginSettings() {
  return {
	  //ServerMode: $("#ServerModeCombo").val(),
    SystemURL: $("#settings\\.SystemURL").val(),
    MerchantID: $("#settings\\.MerchantID").val(),
    MerchantKey: $("#settings\\.MerchantKey").val()
  };
}

</script>
