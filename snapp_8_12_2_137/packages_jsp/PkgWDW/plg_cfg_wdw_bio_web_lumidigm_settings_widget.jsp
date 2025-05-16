<%@page import="com.vgs.cl.lookup.LookupItem"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.JvDataSet"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget>
  <v:widget-block>
    <v:form-field caption="Match Threshold Low">
      <v:input-text field="settings.matchThresholdLow" placeholder="23000"/>
    </v:form-field>
    <v:form-field caption="Match Threshold Medium">
      <v:input-text field="settings.matchThresholdMed" placeholder="24000"/>
    </v:form-field>
    <v:form-field caption="Match Threshold High">
      <v:input-text field="settings.matchThresholdHigh" placeholder="25500"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
function getPluginSettings() {
  return {
    matchThresholdLow: $("#settings\\.matchThresholdLow").val(),
    matchThresholdMed: $("#settings\\.matchThresholdMed").val(),
    matchThresholdHigh: $("#settings\\.matchThresholdHigh").val()
	};
}
</script>