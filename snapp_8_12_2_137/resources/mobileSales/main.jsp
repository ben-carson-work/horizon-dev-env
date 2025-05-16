<%@ page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileSales" scope="request"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.1//EN" "http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd">	
<html>
	<head>
		<title><v:config key="site_title"/></title>
		<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
		<META HTTP-EQUIV="Expires" CONTENT="-1"> 
    <meta http-equiv="X-Frame-Options" content="SAMEORIGIN">
		<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">
		<script type="text/javascript" charset="utf-8" src="<v:config key="site_url"/>/libraries/jquery/jquery-2.2.0.min.js"></script>
		<jsp:include page="main-css.jsp" />
		<jsp:include page="main-js.jsp" />
		<jsp:include page="maincontroller-js.jsp" />
    <jsp:include page="../mobileCommon/functions.jsp" />
	</head>
 	<body>
    <jsp:include page="../mobileCommon/login.jsp" />    
 		<div id="appSalesGuestContainer" class="hidden scrolling page">
			<jsp:include page="app_sales_guest.jsp" />
		</div>
		<div id="appSalesOperatorContainer" class="hidden scrolling page">
			<jsp:include page="app_sales_operator.jsp" />
		</div>
 		<div id="mainBody">
	 		<div id="mainHeader">
		 		<jsp:include page="blocks/mainHeader.jsp" />
			</div>
		 	<div id="mainContainer">
		 		<div id="mainBreadcrumbs">
			 		<jsp:include page="blocks/mainBreadcrumbs.jsp" />
				</div>
				<br clear="all" />
				<div id="mainContent" class="scrolling">
					<div id="catalogContainer" class="hidden page">
						<jsp:include page="catalog.jsp" />
					</div>
					<br clear="all" />
					<div id="checkoutContainer" class="hidden page">
						<jsp:include page="checkout.jsp" />
					</div>
					<div id="transactionResultContainer" class="hidden page">
						<div id="transactionResultContent">
							<div id="transactionResult">
								<div class="thumb">
								</div>
								<div class="text">
								</div>
								<br clear="all" />
							</div>
							<div id="transactionResultLookup">
							</div>
						</div>
					</div>
					<div id="lookupContainer" class="hidden page">
						<jsp:include page="lookup.jsp" />
					</div>
			    <div id="registrationContainer" class="hidden scrolling page">
			      <jsp:include page="registration.jsp" />
			    </div>
					<div id="cartContainer" class="hidden page">
						<jsp:include page="cart.jsp" />
					</div>
				</div>
			</div>
		</div>
		<div id="floatingBarsGbg">
			<div id="floatingBarsG" class="">
				<div class="blockG" id="rotateG_01">
				</div>
				<div class="blockG" id="rotateG_02">
				</div>
				<div class="blockG" id="rotateG_03">
				</div>
				<div class="blockG" id="rotateG_04">
				</div>
				<div class="blockG" id="rotateG_05">
				</div>
				<div class="blockG" id="rotateG_06">
				</div>
				<div class="blockG" id="rotateG_07">
				</div>
				<div class="blockG" id="rotateG_08">
				</div>
			</div>
		</div>
		<div id="results"></div>
		<div id="dialogBG" style="display:none;">
			<div id="dialogBox">
				<div id="dialogTitle">
				</div>
				<div id="dialogContent">
				</div>
			</div>
		</div>
		<div id="wrap" class="hidden">
			<div class="wrapBlocker"></div>
    		<iframe id="frame" src="" frameborder="0"></iframe>
        </div>
        
        
        <div id="version" class=""></div>
	</body>
</html>
