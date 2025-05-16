<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% 
DONotifyRule.DONotifyRuleEntityChange settings = ((DONotifyRule)request.getAttribute("notifyRule")).NotifyRuleEntityChange;
request.setAttribute("settings", settings);
%>

<v:widget caption="@Common.Options" id="notifyentitychange-widget">
  <v:widget-block>
    <v:form-field caption="@Common.Entity">
      <v:lk-combobox field="notifyEntityChange.NotifyEntityType" lookup="<%=LkSN.EntityType%>" alphaSort="true" allowNull="false"/>
    </v:form-field>
    <v:form-field caption="@Common.Tags">
      <select multiple id="TagIDs" class="v-multibox"></select>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
function getNotifyRuleEntityChange_Config () {
	return {
		NotifyEntityType: $("#notifyEntityChange\\.NotifyEntityType").val(),
    TagIDs: $("#TagIDs").val()
  }
}
</script>