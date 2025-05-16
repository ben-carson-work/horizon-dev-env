<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.JvDataSet"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget caption="Settings" icon="settings.png">
  <v:widget-block>
    <v:form-field caption="Service URL">
      <v:input-text field="settings.TKT_URL"/>
    </v:form-field>
    <v:form-field caption="Queue Name">
      <v:input-text field="settings.TKT_QueueName"/>
    </v:form-field>
    <v:form-field caption="Client Id">
      <v:input-text field="settings.TKT_ClientId"/>
    </v:form-field>
    <v:form-field caption="Client secret">
      <v:input-text field="settings.TKT_ClientSecret" type="password"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>

function getPluginSettings() {
  return {
  	TKT_URL: $("#settings\\.TKT_URL").val(),
  	TKT_QueueName: $("#settings\\.TKT_QueueName").val(),
    TKT_ClientId: $("#settings\\.TKT_ClientId").val(),
    TKT_ClientSecret: $("#settings\\.TKT_ClientSecret").val()
  };
}
</script>