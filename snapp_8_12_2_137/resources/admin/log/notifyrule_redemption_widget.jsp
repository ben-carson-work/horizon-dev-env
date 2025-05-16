<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% 
DONotifyRule.DONotifyRuleRedemption settings = ((DONotifyRule)request.getAttribute("notifyRule")).NotifyRuleRedemption;
request.setAttribute("settings", settings);
%>

<v:widget caption="@Common.Options" id="notifyredemption-widget">
  <v:widget-block>
    <v:form-field caption="@Common.Type" mandatory="true">
      <v:lk-combobox field="notifyRedemption.NotifyRedemptionType" lookup="<%=LkSN.NotifyRedemptionType%>" allowNull="false"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
function getNotifyRulRedemption_Config () {
  return {
	  NotifyRedemptionType: $('#notifyRedemption\\.NotifyRedemptionType').val()
  }
}
</script>