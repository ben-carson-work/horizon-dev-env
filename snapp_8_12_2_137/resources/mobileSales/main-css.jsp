<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v"%>
<jsp:include page="assets/loadingimage-css.jsp" />
<style>
/*
	default colors:
	orange: rgb(225,106,19) o rgba(225,106,19,x)
	green: rgb(0,133,155) o rgba(0,133,155,x)
	black: rgba(0,0,0,0.7)
*/
body {
	width: 100%;
	height: 100%;
	margin: 0;
	padding: 0;
	font-family: arial;
	color: rgba(0, 0, 0, 0.7);
}

#wrap {
	z-index: 1000000000000000;
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
}

#wrap .wrapBlocker {
	width: 100%;
	height: 100%;
	position: absolute;
	top: 0;
	left: 0;
	z-index: 1;
}

#wrap iframe {
	width: 100%;
	height: 100%;
}

.scrolling {
	-webkit-overflow-scrolling: touch;
	overflow: auto;
}

#mainBody {
	width: 100%;
	height: 100%;
}

#mainContainer {
	position: fixed;
	top: 90px;
	width: 94%;
	padding: 20px 3%;
	bottom: 0px;
}

#mainContent {
	position: absolute;
	top: 80px;
	width: 94%;
	padding: 0px 3%;
	bottom: 10px;
	left: 0;
}

.button {
	background: rgb(225, 106, 19);
	display: block;
	width: 50px;
	height: 50px;
	border-radius: 5px;
	border: 2px solid #FFF;
	background-position: 50% 50%;
	background-repeat: no-repeat;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.7);
	color: #FFF;
	cursor: pointer;
}

.button.addtocartAttribute {
  width: 20%;
  text-align: center;
  padding: 8px 0 20px;
  height: 20px;
  position: fixed;
  top: 110px;
  right: 40px;
}
#mainBreadcrumbs .button.addtocartAttribute {
  width: 15%;
  text-align: center;
  padding: 15px 0;
  height: 20px;
  float: right;
  margin: 0 100px 0 0;
}

.scrolling {
	-webkit-overflow-scrolling: touch;
	overflow: auto;
}

.hidden {
	visibility: hidden;
	display: none;
}

.disabled {
	pointer-events: none;
	opacity: 0.4;
}
/*----------------------------------------------- table style -------------------------*/
table {
	
}

tr {
	height: 60px;
}

td, th {
	padding: 10px;
}

.even {
	background: rgba(0, 133, 155, 0.3)
}

.odd {
	background: #FFF;
}
/*----------------------------------------------- table style -------------------------*/
/*----------------------------------------header------------------------------------------*/
div#mainHeader {
	position: fixed;
	width: 100%;
}

#mainHeaderContent {
	height: 70px;
	color: #666;
	background: rgb(0, 133, 155)
		url('<v:config key="resources_url"/>/mobileSales/assets/images/header/headerBg.png')
		no-repeat 0 0;
	position: relative;
	padding: 10px 20px;
	box-shadow: 0px 3px 10px rgba(0, 0, 0, 0.7);
}

#mainHeaderContent #logo {
	background:
		url('<v:config key="resources_url"/>/mobileSales/assets/images/header/logo.png')
		no-repeat 0 0;
	width: 132px;
	height: 70px;
	float: left;
	background-size: contain;
}
div#WkName {
position: fixed;
background: rgb(0,133,155);
padding: 10px;
top: 0;
border-bottom-left-radius: 10px;
border-bottom-right-radius: 10px;
color: #fff;
left: 160px;
font-size: 12px;
}
#dialogBox .Save {
position: absolute;
bottom: 25px;
right: 25px;
font-size: 25px;
text-align: center;
width: 70px;
height: 70px;
line-height: 70px;
}
#controls {
	float: right;
	width: 55%;
}

.navigation {
	float: left;
	width: 66px;
	height: 66px;
	border-radius: 10px;
	border: 2px solid #FFF;
	margin: 0px 30px 0px 0;
}

.home {
	background-image:
		url('<v:config key="resources_url"/>/mobileSales/assets/images/header/home.png');
}

.back {
	background-image:
		url('<v:config key="resources_url"/>/mobileSales/assets/images/header/back.png');
}

#mainHeaderCart {
	position: absolute;
	right: 100px;
	text-align: right;
	border-radius: 10px;
	box-shadow: 0 0 5px rgba(0, 0, 0, 0.7);
	background: #fff;
	padding: 17px 10px;
}

#mainHeaderCartButton, #mainHeaderCheckoutButton {
	float: right;
	width: 66px;
	height: 66px;
	border-radius: 10px;
	border: 2px solid #FFF;
	background-position: 50% 30%;
	position: relative;
}
#mainHeaderCartButton {
		background-image: url('<v:config key="resources_url"/>/mobileSales/assets/images/header/orderlist.png');
	}
	#mainHeaderCheckoutButton {
		background-image: url('<v:config key="resources_url"/>/mobileSales/assets/images/header/checkout.png');
	}
span.buttonText {
	color: #FFF;
	font-size: 10px;
	text-decoration: none;
	position: absolute;
	bottom: 2px;
	font-variant: small-caps;
	text-align: center;
	width: 100%;
}
/*---------------------------------------- header ------------------------------------------*/
/*---------------------------------------- breadcrumbs ------------------------------------------*/
div#mainBreadcrumbsContent {
	float: left;
	width: 70%;
	height: 40px;
}

.mainBreadcrumbsButtons {
	display: block;
	float: left;
	width: 40px;
	height: 40px;
	background-repeat: no-repeat;
	background-position: 50% 50%;
}

#mainBreadcrumbsHome {
	background-image:url('<v:config key="resources_url"/>/mobileSales/assets/images/breadcrumbs/homeBread.png');
}

.separator {
	/*background-image:url('<v:config key="resources_url"/>/mobileSales/assets/images/breadcrumbs/separator.png');*/
	float: left;
	width: 0px;
	height: 40px;
	background-repeat: no-repeat;
	background-position: 50% 50%;
}

#mainBreadcrumbsPath {
	height: 40px;
}

#mainBreadcrumbsPath span.breadcrumbsText {
	padding: 0 5px;
	line-height: 40px;
	text-transform: uppercase;
	font-weight: bold;
	font-size: 12px;
}

.breadcrumbNode {
	float: left;
	display: block;
	cursor: pointer;
	height: 40px;
	background: rgba(0, 133, 155, 0.7);
	padding: 0 10px;
	margin: 0 10px;
	color: #fff;
	/* border: 3px solid #fff; */
	/* box-shadow: 0 0 10px rgba(0,0,0,0.7); */
	border-radius: 0;
	position: relative;
	border-top-left-radius: 10px;
	border-bottom-left-radius: 10px;
}

.breadcrumbNode:not(.last ):after {
	position: absolute;
	content: "";
	width: 0;
	border-style: solid;
	border-width: 20px 0 20px 15px;
	border-color: transparent transparent transparent rgba(0, 133, 155, 0.7);
	right: -15px;
}

.breadcrumbNode.last {
	border-radius: 10px;
}
/*---------------------------------------- breadcrumbs ------------------------------------------*/
/*---------------------------------------- category item ------------------------------------------*/
.categoryItemContainer, .productItemContainer, .eventItemContainer {
	width: 214px;
	max-width: 280px;
	height: 214px;
	max-height: 280px;
	float: left;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
	position: relative;
	margin: 0px 10px 20px;
	border-radius: 10px;
	cursor: pointer;
	border: 3px solid rgb(0, 133, 155);
	overflow: hidden;
}

.categoryItemContainer:before, .categoryItemContainer:after,
	.productItemContainer:before, .productItemContainer:after,
	.appSalesGuestButtonContainer:before, .appSalesGuestButtonContainer:after {
	z-index: -1;
	position: absolute;
	content: "";
	bottom: 7px;
	left: 2px;
	width: 46%;
	top: 80%;
	max-width: 300px;
	background: #777;
	-webkit-box-shadow: 0 15px 10px rgba(0, 0, 0, 0.3);
	-moz-box-shadow: 0 15px 10px rgba(0, 0, 0, 0.3);
	box-shadow: 0 18px 10px rgba(0, 0, 0, 0.3);
	-webkit-transform: rotate(-7deg);
	-moz-transform: rotate(-7deg);
	-o-transform: rotate(-7deg);
	-ms-transform: rotate(-7deg);
	transform: rotate(-7deg);
}

.categoryItemContainer:after, .productItemContainer:after,
	.appSalesGuestButtonContainer:after {
	-webkit-transform: rotate(7deg);
	-moz-transform: rotate(7deg);
	-o-transform: rotate(7deg);
	-ms-transform: rotate(7deg);
	transform: rotate(7deg);
	right: 2px;
	left: auto;
}

.categoryItemContent, .productItemContent, .appSalesGuestButtonContent,.attributeItemContent {
	width: 100%;
	height: 100%;
	overflow: hidden;
	position: relative;
	background: #fff;
}
.attributeItemContent.selected .productPriceContainer,.attributeItemContent.selected .productName {
    background: rgba(225,106,19,0.8) ;
}
.attributeItemContent.selected .productPriceContainer {
    background: rgba(225,106,19,0.8) url('<v:config key="resources_url"/>/mobileSales/assets/images/check.png') no-repeat 3% 50%;
background-size: auto 65%;
}

.attribute.selected {
    border: 3px solid  rgba(225,106,19,1);
}
.categoryItemContainer .categoryImage, .productItemContainer .productImage,
	.appSalesGuestButtonContainer .appSalesGuestButtonImage {
	width: 100%;
	height: 100%;
	background-size: cover;
	background-repeat: none;
}

.categoryItemContainer .categoryName, .appSalesGuestButtonName {
	background: rgba(0, 133, 155, 0.7);
	height: 20%;
	width: 100%;
	position: absolute;
	bottom: -3px;
	color: #FFF;
	text-align: center;
	padding: 5px 0;
	font-size: 20px;
	font-weight: bold;
	text-shadow: 0 0 5px rgba(0, 0, 0, 0.7);
}

.productItemContainer .productPriceContainer {
	background: rgba(0, 133, 155, 0.7);
	height: 10%;
	width: 100%;
	position: absolute;
	bottom: -3px;
	color: #FFF;
	text-align: center;
	padding: 5px 0;
	font-size: 20px;
	font-weight: bold;
	text-shadow: 0 0 5px rgba(0, 0, 0, 0.7);
}

.panel {
	display: none;
	width: 100%;
	background: rgb(19, 133, 155);
	float: left;
}

.panel:before {
	content: "";
	position: absolute;
	left: 13%;
	z-index: 1;
	height: 20px;
	border-style: solid;
	border-width: 0 15px 20px 15px;
	border-color: transparent transparent #148599 transparent;
	margin-top: -39px;
}

.active {
	display: block;
}

.productName {
	text-align: center;
	position: absolute;
	width: 100%;
	background: rgba(0, 133, 155, 0.7);
	bottom: 10%;
	margin-bottom: 7px;
	font-weight: bold;
	color: #fff;
	padding: 3px 0;
	border-bottom: 1px solid #FFF;
}

.addtocart {
	width: 5vw;
	height: 5vw;
	float: right;
	margin: 0.2vw 3px 0 0;
	color: #FFF;
	line-height: 5vw;
	text-decoration: none;
	font-size: 3.5vw;
}

.infoProduct {
	position: absolute;
	text-align: center;
	right: 6px;
	top: -2px;
	width: 50px;
	height: 50px;
	line-height: 50px;
	text-decoration: none;
	font-size: 40px;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
	border: 2px solid #FFF;
	color: #FFF;
	background: rgb(0, 133, 155);
	border-top-left-radius: 0;
	border-top-right-radius: 0;
}

span.productPrice {
	font-size: 18px;
	font-weight: bold;
	text-shadow: 0 0 5px rgba(0, 0, 0, 0.7);
	position: absolute;
	bottom: 5px;
	right: 10px;
}

span.productQtyCart {
	font-size: 18px;
	font-weight: bold;
	text-shadow: 0 0 5px rgba(0, 0, 0, 0.7);
	position: absolute;
	bottom: 5px;
	left: 10px;
}

/*---------------------------------------- category item ------------------------------------------*/
#dialogBG, #floatingBarsGbg {
	background: rgba(0, 0, 0, 0.7);
	width: 100%;
	height: 100%;
	position: fixed;
	top: 0;
	z-index: 1000;
}
#loginBg {
  background: rgba(0, 0, 0, 0.7);
  width: 100%;
  height: 100%;
  position: fixed;
  top: 0;
  z-index: 999;
}

#dialogBox {
	background: #fff;
	height: 450px;
	width: 70%;
	top: 50px;
	left: 10%;
	border-radius: 20px;
	position: absolute;
}

#dialogTitle {
	padding: 30px;
	background: rgb(0, 133, 155);
	color: #FFF;
	padding: 10px 30px;
	text-transform: uppercase;
	font-size: 30px;
	font-weight: bold;
	border-top-left-radius: 20px;
	border-top-right-radius: 20px;
}

#dialogContent {
	padding:30px;
}

#dialogBox #productDetails {
	float: left;
	margin: 15px;
	font-size: 14px;
	width: 57%;
	height: 260px;
	overflow: auto;
}

#dialogBox #productDetails #productName {
	font-weight: bold;
	font-size: 20px;
}

#dialogBox .addtocart {
	position: absolute;
	bottom: 30px;
	right: 40px;
	font-size: 25px;
	text-align: center;
	width: 70px;
	height: 70px;
	line-height: 70px;
}

#dialogBox .productPrice {
	position: absolute;
	bottom: 40px;
	right: 140px;
	font-size: 30px;
	text-align: right;
}

#dialogBox .dialogClose {
	position: absolute;
	bottom: 30px;
	left: 40px;
	width: 70px;
	font-size: 25px;
	text-align: center;
	background: rgb(0, 133, 155);
	text-decoration: none;
	height: 70px;
	line-height: 70px;
}

#dialogBox .productItemContainer {
	width: 200px;
	max-width: 280px;
	height: 200px;
	max-height: 280px;
	float: left;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
	position: relative;
	margin: 10px;
	border-radius: 10px;
	cursor: pointer;
}
.logout {
	cursor: pointer;
	margin-top: 5px;
	float: right;
	text-transform: uppercase;
}
div#version {
	position: fixed;
	bottom: 10px;
	width: 100%;
	text-align: right;
	right: 15px;
	font-size: 12px;
}
@media only screen and (orientation: portrait) {
	#dialogBox {
		background: #fff;
		height: 700px;
		width: 80%;
		top: 100px;
		left: 10%;
		border-radius: 20px;
		position: absolute;
	}
	#dialogBox #productDetails {
		width: 370px;
		height: 510px;
		overflow: auto;
	}
	#dialogBox .addtocart, #dialogBox .dialogClose {
		width: 70px;
		height: 70px;
		font-size: 20px;
	}
	#dialogContent {
		padding: 20px;
	}
	#dialogBox .dialogClose {
		bottom: 25px;
		left: 25px;
		width: 70px;
		font-size: 20px;
		text-align: center;
		height: 70px;
		line-height: 70px
	}
	#dialogBox .addtocart {
		right: 25px;
		bottom: 25px;
		width: 70px;
		font-size: 20px;
		text-align: center;
		height: 70px;
		line-height: 70px
	}
	#dialogBox .productItemContainer {
		width: 20vw;
		height: 20vw;
		float: left;
		box-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
		position: relative;
		margin: 2vw 1%;
		border-radius: 10px;
		cursor: pointer;
	}
}

@media ( max-width : 640px) and (orientation: portrait) {
#mainContent {
	position: absolute;
	top: 50px;
	width: 94%;
	padding: 0px 3%;
	bottom: 10px;
	left: 0;
}

	
	#mainHeaderContent {
		height: 50px;
		color: #666;
		background: rgb(0, 133, 155)
			url('<v:config key="resources_url"/>/mobileSales/assets/images/header/headerBg.png')
			no-repeat 0 0;
		position: relative;
		padding: 10px 20px;
		box-shadow: 0px 3px 10px rgba(0, 0, 0, 0.7);
	}
	#mainHeaderContent #logo {
		width: 94px;
		height: 50px;
		padding: 0;
	}
	#mainHeaderCartButton, #mainHeaderCheckoutButton {
		float: right;
		width: 40px;
		height: 40px;
		border-radius: 5px;
		border: 2px solid #FFF;
		position: relative;
		margin: 5px -11px;
		box-shadow: 0 0 5px rgba(0, 0, 0, 0.7);
		background-size: 50%;
		background-position: 50% 50%;
	}
	#mainHeaderCartButton span.buttonText, #mainHeaderCheckoutButton span.buttonText
		{
		display: none;
	}
	#mainHeaderCart {
		position: absolute;
		right: 60px;
		text-align: right;
		font-size: 12px;
		top: 15px;
		padding: 8px 7px;
	}
	#mainHeaderCart a {
		text-decoration: none;
	}
	.navigation {
		float: left;
		width: 40px;
		height: 40px;
		border-radius: 5px;
		border: 2px solid #FFF;
		margin: 5px 10px 0 0;
		background-size: 50%;
		box-shadow: 0 0 5px rgba(0, 0, 0, 0.7);
	}
	#controls {
		width: 45%;
	}
	#mainContainer {
		padding: 0px 3% 10px;
	}
	.mainBreadcrumbsButtons {
		display: block;
		float: left;
		width: 30px;
		height: 30px;
		background-repeat: no-repeat;
		background-position: 50% 50%;
	}
	.breadcrumbNode {
		float: left;
		display: block;
		cursor: pointer;
		height: 30px;
		background: rgba(0, 133, 155, 0.7);
		padding: 0 5px;
		margin: 0 5px;
		color: #fff;
		/* border: 3px solid #fff; */
		/* box-shadow: 0 0 10px rgba(0,0,0,0.7); */
		border-radius: 0;
		position: relative;
		border-top-left-radius: 10px;
		border-bottom-left-radius: 10px;
	}
	#mainBreadcrumbsPath span.breadcrumbsText {
		line-height: 30px;
	}
	.breadcrumbNode.last {
		border-radius: 7px;
	}
	span.productPrice {
		font-size: 15px;
	}
	span.productQtyCart {
		font-size: 15px;
	}

	#dialogBox {
		background: #fff;
		height: 580px;
		width: 80%;
		top: 50px;
		left: 10%;
		border-radius: 20px;
		position: absolute;
	}
	#dialogBox .productItemContainer {
		width: 240px;
		height: 240px;
		border-radius: 10px;
		background: #fff;
		overflow: hidden;
		border: 3px solid rgb(0, 133, 155);
		position: relative;
		margin: 20px 0px;
		float: none;
	}
	#dialogTitle {
		font-size: 20px;
	}
	#dialogBox #productDetails {
		margin: 5px;
		float: none;
		height: 160px;
		width: 100%;
		overflow:auto;
	}
	.categoryItemContainer .categoryName, .appSalesGuestButtonName {
		font-size: 14px;
	}
	#dialogBox .dialogClose {
		bottom: 25px;
		left: 25px;
		width: 70px;
		font-size: 25px;
		text-align: center;
		height: 70px;
		line-height: 70px;
	}
	#dialogBox .addtocart {
		right: 25px;
		bottom: 25px;
		width: 70px;
		font-size: 25px;
		text-align: center;
		height: 70px;
		line-height: 70px;
	}
	#dialogBox .productPrice {
		position: absolute;
		bottom: 40px;
		right: 120px;
		font-size: 30px;
		text-align: right;
	}
	.breadcrumbNode:not(.last ):after {
		position: absolute;
		content: "";
		width: 0;
		border-style: solid;
		border-width: 15px 0 15px 10px;
		border-color: transparent transparent transparent rgba(0, 133, 155, 0.7);
		right: -10px;
	}
}

@media ( max-width : 640px) and (orientation: landscape) {
	.categoryItemContainer, .productItemContainer, .eventItemContainer {
		width: 185px;
		height: 185px;
		float: left;
		box-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
		position: relative;
		margin: 0px 6px 20px;
		border-radius: 10px;
		cursor: pointer;
	}
	#dialogBox .productItemContainer {
		width: 100px;
		height: 100px;
		float: left;
		box-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
		position: relative;
		margin: 10px;
		border-radius: 10px;
		cursor: pointer;
	}
	#mainHeaderContent {
		height: 50px;
		color: #666;
		background: rgb(0, 133, 155)
			url('<v:config key="resources_url"/>/mobileSales/assets/images/header/headerBg.png')
			no-repeat 0 0;
		position: relative;
		padding: 10px 20px;
		box-shadow: 0px 3px 10px rgba(0, 0, 0, 0.7);
	}
	#mainHeaderContent #logo {
		width: 132px;
		height: 50px;
		padding: 0;
	}
	#mainHeaderCartButton, #mainHeaderCheckoutButton {
		float: right;
		width: 50px;
		height: 50px;
		border-radius: 10px;
		border: 2px solid #FFF;
		
		background-position: 50% 20%;
		background-size: 40%;
		position: relative;
	}
	
	.navigation {
		float: left;
		width: 50px;
		height: 50px;
		border-radius: 10px;
		border: 2px solid #FFF;
		margin: 0px 10px 0 0;
		background-size: 50%;
	}
	#mainContainer {
		padding: 0px 3%;
	}
	#mainHeaderCart {
		right: 84px;
		padding: 9px 10px;
	}
	#dialogBox {
		background: #fff;
		height: 300px;
		width: 80%;
		top: 30px;
		left: 10%;
		border-radius: 20px;
		position: absolute;
	}
	.categoryItemContainer .categoryName, .appSalesGuestButtonName {
		font-size: 14px;
	}
}


</style>
