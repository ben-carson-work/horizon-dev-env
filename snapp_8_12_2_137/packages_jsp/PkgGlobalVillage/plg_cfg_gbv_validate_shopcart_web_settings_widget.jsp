<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.JvDataSet"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget caption="@Common.Settings">
  <v:widget-block>
    <v:form-field caption="Product codes" hint="Comma separated list of product codes which need to have a limit control">
      <v:input-text field="settings.ProductCodes"/>
    </v:form-field>
    <v:form-field caption="Max orders" hint="Max number of orders purchasable (res. owner) by an account in a season">
      <v:input-text field="settings.MaxOrders"/>
    </v:form-field>
    <v:form-field caption="Season month reset" hint="IE: setting 6 would mean that the season ends at end of june">
      <v:input-text field="settings.SeasonMonthReset"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>

function getPluginSettings() {
  return {
    "ProductCodes": $("#settings\\.ProductCodes").val(),
    "MaxOrders": $("#settings\\.MaxOrders").val(),
    "SeasonMonthReset": $("#settings\\.SeasonMonthReset").val()
  };
}

</script>