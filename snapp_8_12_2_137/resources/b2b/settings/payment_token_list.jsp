<%@page import="com.vgs.cl.JvString"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.snapp.web.gencache.*"%>
<%@page import="com.vgs.snapp.web.plugin.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.b2b.page.PageB2B_PaymentToken" scope="request"/>

<%
String wpgPluginId = pageBase.getBL(BLBO_Plugin.class).findWebPaymentGatewayPluginId();
PlgWpgBase plugin = SrvBO_Cache_SystemPlugin.instance().getPluginInstance(PlgWpgBase.class, wpgPluginId);
boolean modifyFinance = pageBase.getRights().B2BAgent_ManageFinance.getBoolean();
%>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>
<v:last-error/>

	<div class="tab-toolbar">
	  <v:button caption="@Common.New" fa="plus" onclick="doAddPayment()" enabled="<%=modifyFinance%>"/>
	  <v:button caption="@Common.Delete" fa="trash" bindGrid="payment-token-grid" onclick="deletePaymentTokens()" enabled="<%=modifyFinance%>"/>
	  <span class="divider"></span>
	  <v:button caption="@Payment.ModifyDescription" fa="pen" bindGrid="payment-token-grid" onclick="modifyDescription()" enabled="<%=modifyFinance%>"/>
	  <v:pagebox gridId="payment-token-grid"/>
	</div>
	
	
	<div class="tab-content">
	  <v:last-error/>
	  <% String params = "AccountId=" + pageBase.getSession().getOrgAccountId();%>
	  <v:async-grid id="payment-token-grid" jsp="settings/payment_token_grid.jsp" params="<%=params%>" />
	</div>

<script>
function doAddPayment() {
	if (<%=plugin.supportPayByToken()%>)
    asyncDialogEasy("settings/payment_token_webpayment_dialog", "PluginId=<%=wpgPluginId%>");
	else
		showMessage("Function not supported by \"" + <%=JvString.jsString(plugin.getDescription())%> + "\"");
}

function deletePaymentTokens() {
  confirmDialog(null, function() {
    var reqDO = {
      Command: "DeletePaymentToken",
      DeletePaymentToken: {
        PaymentTokenIDs: $("[name='PaymentTokenId']").getCheckedValues(),
        PluginId: "<%=wpgPluginId%>",
        AccountId: "<%=pageBase.getSession().getOrgAccountId()%>"
      }
    };

    showWaitGlass();
    vgsService("PaymentToken", reqDO, false, function(ansDO) {
      hideWaitGlass();
      triggerEntityChange(<%=LkSNEntityType.PaymentToken.getCode()%>);
    });
  });
}

function modifyDescription() {
	inputDialog(<v:itl key="@Payment.ModifyDescription" encode="JS"/>, "", <v:itl key="@Common.Description" encode="JS"/>, "", false, function(value) {
	  var reqDO = {
      Command: "ModifyDescription",
      ModifyDescription: {
    	  Description: value,
        PaymentTokenIDs: $("[name='PaymentTokenId']").getCheckedValues()
      }
    };

    showWaitGlass();
    vgsService("PaymentToken", reqDO, false, function(ansDO) {
      hideWaitGlass();
		  triggerEntityChange(<%=LkSNEntityType.PaymentToken.getCode()%>);
		});
	}, "", 30);
}
</script>

<jsp:include page="/resources/common/footer.jsp"/>