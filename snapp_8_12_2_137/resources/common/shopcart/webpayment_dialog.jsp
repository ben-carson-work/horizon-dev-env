<%@page import="com.vgs.web.library.BLBO_Auth.*"%>
<%@page import="com.vgs.snapp.web.gencache.SrvBO_Cache_SystemPlugin"%>
<%@page import="com.vgs.snapp.web.plugin.PlgWpgBase"%>
<%@page import="com.vgs.web.tag.ConfigTag"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
String saleId = pageBase.getNullParameter("SaleId");
boolean includeTickets = pageBase.isParameter("IncludeTickets", "true");
boolean preparePahDownload = pageBase.isParameter("PreparePahDownload", "true");
boolean organizationInventoryBuild = pageBase.isParameter("OrganizationInventoryBuild", "true");
boolean createOrderConfirmation = pageBase.isParameter("CreateOrderConfirmation", "true");
boolean sendOrderConfirmation = pageBase.isParameter("SendOrderConfirmation", "true");
String paymentMethodIs = pageBase.getNullParameter("PaymentMethodId");
String orderDocTemplateId = pageBase.getNullParameter("OrderDocTemplateId");
if (!JvUtils.isValidUUID(orderDocTemplateId))
  orderDocTemplateId = null;

DOWpgTransaction wpgtrn = pageBase.getBL(BLBO_Auth.class).createWebAuthPayment(saleId, paymentMethodIs, orderDocTemplateId, preparePahDownload, includeTickets, createOrderConfirmation, sendOrderConfirmation, organizationInventoryBuild);

request.setAttribute("wpgtrn", wpgtrn);
request.setAttribute("callbackURL", pageBase.getContextURL() + "?page=wpg&PluginId=" + wpgtrn.PluginId.getString());
%>

<v:dialog id="webpayment_dialog" title="<%=wpgtrn.CalcWebAuthRef.getString()%>" width="800" height="700" autofocus="false">

  <style>
  #webpayment_dialog {
    padding:0;
  }
  </style>
  
  <script>
    function WebPayment_CallBack(trnRecap, data) {
      showTransactionRecapDialog({
        SaleId: trnRecap.SaleId,
        SaleCode: trnRecap.SaleCode,
        PahRelativeUrl: <%=organizationInventoryBuild%> ? null : trnRecap.PahRelativeDownloadUrl,
        PaymentStatus: data.PaymentStatus,
        AuthorizationCode: data.AuthorizationCode,
        ErrorMessage: data.ErrorMessage,
        OrganizationInventoryBuild: <%=organizationInventoryBuild%>
      });
      $("#webpayment_dialog").dialog("close");
    }
  </script>
  
  <% SrvBO_Cache_SystemPlugin.instance().getPluginInstance(PlgWpgBase.class, wpgtrn.PluginId.getString()).includePaymentWidget(pageBase, pageContext, wpgtrn); %>
  
</v:dialog>
