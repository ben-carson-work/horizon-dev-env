<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageWebPaymentCallback" scope="request"/>
<jsp:useBean id="recapDO" class="com.vgs.entity.dataobject.DOTransactionShortRecap" scope="request"/>
<jsp:useBean id="authResponse" class="com.vgs.snapp.dataobject.DOWpgResponse" scope="request"/>

<% 
boolean successMessage = authResponse.PaymentStatus.isLookup(LkSNPaymentStatus.Approved);
String url = pageBase.getParameter("url");
String urlShopping = pageBase.getParameter("urlShopping");

LookupItem trnType = LkSN.TransactionType.findItemByCode(JvString.strToIntDef(pageBase.getEmptyParameter("trnType"), 0));

%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <title>SnApp Payment Authorization</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <link rel="shortcut icon" href="<v:config key="resources_url"/>/admin/images/favicon.ico"/>
  <link type="text/css" href="<v:config key="site_url"/>/libraries/jquery-ui-1.14.1/jquery-ui.min.css" rel="stylesheet" />
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/jquery/jquery-3.6.0.min.js"></script>
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/jquery-ui-1.14.1/jquery-ui.min.js"></script>
  <link type="text/css" href="<v:config key="site_url"/>/admin?page=admin-css" rel="stylesheet" media="all" />
  <script type="text/javascript" src="<v:config key="site_url"/>/admin?page=admin-js"></script>
  

    <style type="text/css">
      .form-field {
        margin:4px auto;
      }
      .form-field-caption {
        width: 200px;
      }
      .form-field-value {
        margin-left: 203px;
      }
      #webauth-confirmation-widget {
        width: 600px;
        height: 170px;
        margin: 100px auto;
      }
      .margin-10 {
        margin: 10px;
      }
      .float-right {
        float:right;
      }
    </style>

</head>

<body>
<v:page-form id="webauth-confirmation-form">
	<v:widget id="webauth-confirmation-widget" caption="Horizon Payment Authorization" icon="web_payment.png">
  	<div id="success-box">
  	  <v:widget-block>
  	    <% if (successMessage) { %>
	   	    <v:itl key="@Common.TransactionPostedOK"/><br/>
	        <% if (!authResponse.AuthorizationCode.isNull()) { %> 
		    	  <v:itl key="@Payment.AuthorizationCode"/>:&nbsp;<b><%=authResponse.AuthorizationCode.getString()%></b><br/>
		    	<% } %>
		    <% } else { %>
		      <v:itl key="@Payment.NotApprovedError"/>:&nbsp;<b><%=authResponse.ErrorMessage.getString()%></b><br/>
		    <% } %>
  	    PNR:&nbsp;<b><%=recapDO.SaleCode.getString()%></b>
			  
        <% if (!trnType.isLookup(LkSNTransactionType.OrganizationInventoryBuild) && (pageBase.getRights().B2BAgent_PahDownloadOption.getInt() > 0) && (!recapDO.PahRelativeDownloadUrl.isNull())) { %>
          <br/><v:itl key="@Common.PrintAtHome"/>:&nbsp;<a class="no-ajax" href="javascript:doPrintAtHome()"><v:itl key="@Common.ClickHereToDownload"/></a>
        <% } %>
        <br/><br/>
        <a class="no-ajax" href="#" onclick="closeTab()">Click here to close</a>
	    </v:widget-block>
    </div>
  </v:widget>

<script>
function doPrintAtHome() {
  window.open(<%=recapDO.PahRelativeDownloadUrl.getJsString()%>);
  window.location = <%=JvString.jsString(urlShopping)%>;
}

function closeTab() {
	window.close();
}
</script>  
  
  
</v:page-form>

</body>

</html>
