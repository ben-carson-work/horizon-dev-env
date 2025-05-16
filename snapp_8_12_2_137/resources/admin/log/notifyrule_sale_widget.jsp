<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
DONotifyRule.DONotifyRuleSale settings = ((DONotifyRule)request.getAttribute("notifyRule")).NotifyRuleSale;
request.setAttribute("settings", settings);
%>

<v:widget caption="@Common.Options" id="notifysale-widget">
  <v:widget-block>
    <v:form-field caption="@Notify.NotifySaleEvent" mandatory="true">
      <v:lk-combobox field="notifySale.NotifySaleType" lookup="<%=LkSN.NotifySaleType%>" alphaSort="true" allowNull="false"/>
    </v:form-field>
  </v:widget-block>
  <div class="notify-cashInput-block" data-NotifyCashType="<%=LkSNNotifySaleType.CashInput.getCode()%>">
    <v:widget-block id="cashinput-block" >
      <v:form-field caption="@Notify.CashAmount">
        <v:input-text field="configCashInput.CashAmount"/>
      </v:form-field>    
    </v:widget-block>
  </div>
</v:widget>

<script>
function getNotifyRuleSale_Config() {
	var result = {
			NotifySaleType: $('#notifySale\\.NotifySaleType').val(),
	    NotifySaleFrequency: $('#notifySale\\.NotifySaleFrequency').val(),
	    NotifySaleRange: $("#notifySale\\.NotifySaleRange").val()
	};
	
	if ($('#notifySale\\.NotifySaleType').val() == <%=LkSNNotifySaleType.CashInput.getCode()%>) {
    result.Config_CashInput = {
        "CashAmount": $("#configCashInput\\.CashAmount").val()
    }
  };
	
  return result;
}
</script>