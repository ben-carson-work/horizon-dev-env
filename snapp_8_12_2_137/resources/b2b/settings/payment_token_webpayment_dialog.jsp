<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.web.library.BLBO_Auth.*"%>
<%@page import="com.vgs.snapp.web.gencache.*"%>
<%@page import="com.vgs.snapp.web.plugin.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="java.util.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
  List<DOPaymentMethodRef> list = pageBase.getBL(BLBO_PayMethod.class).getRightsPaymentMethods(LkSNTransactionType.CreditCardVerification);
  DOPaymentMethodRef paymentMethodRef = list.stream().filter(payRef -> payRef.PaymentType.isLookup(LkSNPaymentType.WebPayment)).findFirst().orElse(null);
	String pluginId = pageBase.getNullParameter("PluginId");
	String paymentMethodId = paymentMethodRef != null ? paymentMethodRef.PaymentMethodId.getString() : null;

	DOWpgTransaction wpgTrn = pageBase.getBL(BLBO_Auth.class).createPaymentTokenWebAuth(pluginId, paymentMethodId);
	
	request.setAttribute("wpgtrn", wpgTrn);
	request.setAttribute("callbackURL", pageBase.getContextURL() + "?page=wpg&PluginId=" + wpgTrn.PluginId.getString());
%>

<v:dialog id="payment_token_webpayment_dialog" title="Token request" width="800" height="700" autofocus="false">

  <style>
	  #payment_token_webpayment_dialog {
	    padding:0;
	  }
  </style>
  
  <script>
		function WebPayment_CallBack(trnRecap, data) {
			if (typeof data.Token == 'undefined') {
				showTransactionRecapDialog({
			        SaleId: trnRecap.SaleId,
			        SaleCode: trnRecap.SaleCode,
			        PahRelativeUrl: trnRecap.PahRelativeDownloadUrl,
			        PaymentStatus: data.PaymentStatus,
			        AuthorizationCode: data.AuthorizationCode,
			        ErrorMessage: data.ErrorMessage,
			        AdditionalText: itl("@Payment.WarnNoTokenReturnedMsg")
			      });
			      triggerEntityChange(<%=LkSNEntityType.PaymentToken.getCode()%>);	
			}
			else {
				showTransactionRecapDialog({
			        SaleId: trnRecap.SaleId,
			        SaleCode: trnRecap.SaleCode,
			        PahRelativeUrl: trnRecap.PahRelativeDownloadUrl,
			        PaymentStatus: data.PaymentStatus,
			        AuthorizationCode: data.AuthorizationCode,
			        ErrorMessage: data.ErrorMessage
			      });
			      triggerEntityChange(<%=LkSNEntityType.PaymentToken.getCode()%>);
			}
		  
		  $("#payment_token_webpayment_dialog").dialog("close");
		};

  </script>
  
  <% SrvBO_Cache_SystemPlugin.instance().getPluginInstance(PlgWpgBase.class, wpgTrn.PluginId.getString()).includePaymentWidget(pageBase, pageContext, wpgTrn); %>
  
</v:dialog>
