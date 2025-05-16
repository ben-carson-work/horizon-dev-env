<%@page import="com.vgs.web.library.BLBO_Auth.*"%>
<%@page import="com.vgs.snapp.web.gencache.*"%>
<%@page import="com.vgs.snapp.web.plugin.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
  String pluginId = pageBase.getNullParameter("PluginId");  
  String paymentMethodId = pageBase.getNullParameter("PayMethodId"); 
  long amount = JvString.strToMoney(pageBase.getEmptyParameter("Amount"));
	
	DOWpgTransaction wpgTrn = pageBase.getBL(BLBO_Auth.class).createDepositWebAuth(pluginId, paymentMethodId, amount);
	
	request.setAttribute("wpgtrn", wpgTrn);
	request.setAttribute("callbackURL", pageBase.getContextURL() + "?page=wpg&PluginId=" + wpgTrn.PluginId.getString());
%>

<v:dialog id="account_deposit_webpayment_dialog" title="@Account.DepositActionHint" width="800" height="700" autofocus="false">
  <v:widget>
    <v:widget-block>
      <v:form-field caption="@Common.Amount">
        <%=wpgTrn.PaymentAmount.getString()%>
      </v:form-field>
    </v:widget-block>
  </v:widget>
  <%
  SrvBO_Cache_SystemPlugin.instance().getPluginInstance(PlgWpgBase.class, wpgTrn.PluginId.getString()).includePaymentWidget(pageBase, pageContext, wpgTrn);
  %>

<script>
var dlg = $("#account_deposit_webpayment_dialog");
  dlg.on("snapp-dialog", function(event, params) {
  });
  
function WebPayment_CallBack(trnRecap, data) {
  showTransactionRecapDialog({
    SaleId: trnRecap.SaleId,
    SaleCode: trnRecap.SaleCode,
    PahRelativeUrl: trnRecap.PahRelativeDownloadUrl,
    PaymentStatus: data.PaymentStatus,
    AuthorizationCode: data.AuthorizationCode,
    ErrorMessage: data.ErrorMessage
  });
  triggerEntityChange(<%=LkSNEntityType.Account_LocOrg.getCode()%>);
  $("#account_deposit_webpayment_dialog").dialog("close");
};
  
</script>

</v:dialog>
