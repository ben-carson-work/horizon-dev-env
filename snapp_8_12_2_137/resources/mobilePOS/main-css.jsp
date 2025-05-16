<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v"%>
<jsp:include page="assets/loadingimage-css.jsp" />
<style id="meain-css.jsp">
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
.img-responsive {
  margin: 0 auto;
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
	padding: 20px 3%;
	bottom: 0px;
}

#mainContent {
	position: absolute;
	top: 15px;
	padding: 0px 5px;
	bottom: 10px;
	left: 0;
}
.btn-primary,.btn-primary:focus,.btn-primary:focus:hover {
  color: #000;
  background-color: #fff;
  border-color: #ccc;
  outline:none;
}
.btn-primary:hover,.btn-primary:active:hover,.btn-primary:active {
    color: #fff !important;
    background-color: #ccc;
    border-color: #999;
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
.quantityInCart {
  float:right;
  font-size:20px;
}
.ui-datepicker {
  width: 222px;
  height: auto;
  margin: 5px auto 0;
  font: 9pt Arial, sans-serif;
  -webkit-box-shadow: 0px 0px 10px 0px rgba(0, 0, 0, .5);
  -moz-box-shadow: 0px 0px 10px 0px rgba(0, 0, 0, .5);
  box-shadow: 0px 0px 10px 0px rgba(0, 0, 0, .5);
}
.ui-datepicker a {
  text-decoration: none;
}
/* DatePicker Table */
.ui-datepicker table {
  width: 100%;
}
.ui-state-default, .ui-widget-content .ui-state-default, .ui-widget-header .ui-state-default, .ui-button, html .ui-button.ui-state-disabled:hover, html .ui-button.ui-state-disabled:active {
    border: none;
    background: #f6f6f6;
    font-weight: normal;
    color: #454545;
}
.ui-datepicker-header {
  background: #000;
  color: #e0e0e0 !important;
  font-weight: bold;
  -webkit-box-shadow: inset 0px 1px 1px 0px rgba(250, 250, 250, 2);
  -moz-box-shadow: inset 0px 1px 1px 0px rgba(250, 250, 250, .2);
  box-shadow: inset 0px 1px 1px 0px rgba(250, 250, 250, .2);
  text-shadow: 1px -1px 0px #000;
  filter: dropshadow(color=#000, offx=1, offy=-1);
  line-height: 30px;
  border-width: 1px 0 0 0;
  border-style: solid;
  border-color: #111;
}
.ui-datepicker-title {
  text-align: center;
}
.ui-datepicker-prev, .ui-datepicker-next {
  display: inline-block;
  width: 30px;
  height: 30px;
  text-align: center;
  cursor: pointer;
  color: #e0e0e0;
/*background-image: url('../img/arrow.png');
  background-repeat: no-repeat;
  line-height: 600%;*/
  overflow: hidden;
}
.ui-datepicker-prev {
  float: left;
  background-position: center -30px;
}
.ui-datepicker-next {
  float: right;
  background-position: center 0px;
}
.ui-datepicker thead {
  background-color: #f7f7f7;
  background-image: -moz-linear-gradient(top,  #f7f7f7 0%, #f1f1f1 100%);
  background-image: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#f7f7f7), color-stop(100%,#f1f1f1));
  background-image: -webkit-linear-gradient(top,  #f7f7f7 0%,#f1f1f1 100%);
  background-image: -o-linear-gradient(top,  #f7f7f7 0%,#f1f1f1 100%);
  background-image: -ms-linear-gradient(top,  #f7f7f7 0%,#f1f1f1 100%);
  background-image: linear-gradient(top,  #f7f7f7 0%,#f1f1f1 100%);
  filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#f7f7f7', endColorstr='#f1f1f1',GradientType=0 );
  border-bottom: 1px solid #bbb;
}
.ui-datepicker th {
  text-transform: uppercase;
  font-size: 6pt;
  padding: 5px 0;
  color: #666666;
  text-shadow: 1px 0px 0px #fff;
  filter: dropshadow(color=#fff, offx=1, offy=0);
}
.ui-datepicker tbody td {
  padding: 0;
  border-right: 1px solid #bbb;
}
.ui-datepicker tbody td:last-child {
  border-right: 0px;
}
.ui-datepicker tbody tr {
  border-bottom: 1px solid #bbb;
}
.ui-datepicker tbody tr:last-child {
  border-bottom: 0px;
}
.ui-datepicker td span, .ui-datepicker td a {
  display: inline-block;
  font-weight: bold;
  text-align: center;
  width: 30px;
  height: 30px;
  line-height: 30px;
  color: #666666;
  text-shadow: 1px 1px 0px #fff;
  filter: dropshadow(color=#fff, offx=1, offy=1);
}
.ui-datepicker-calendar .ui-state-default {
  background: #ededed;
  background: -moz-linear-gradient(top,  #ededed 0%, #dedede 100%);
  background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#ededed), color-stop(100%,#dedede));
  background: -webkit-linear-gradient(top,  #ededed 0%,#dedede 100%);
  background: -o-linear-gradient(top,  #ededed 0%,#dedede 100%);
  background: -ms-linear-gradient(top,  #ededed 0%,#dedede 100%);
  background: linear-gradient(top,  #ededed 0%,#dedede 100%);
  filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ededed', endColorstr='#dedede',GradientType=0 );
  -webkit-box-shadow: inset 1px 1px 0px 0px rgba(250, 250, 250, .5);
  -moz-box-shadow: inset 1px 1px 0px 0px rgba(250, 250, 250, .5);
  box-shadow: inset 1px 1px 0px 0px rgba(250, 250, 250, .5);
}
.ui-datepicker-calendar .ui-state-hover {
  background: #f7f7f7;
}
.ui-datepicker-calendar .ui-state-active {
  background: #6eafbf;
  -webkit-box-shadow: inset 0px 0px 10px 0px rgba(0, 0, 0, .1);
  -moz-box-shadow: inset 0px 0px 10px 0px rgba(0, 0, 0, .1);
  box-shadow: inset 0px 0px 10px 0px rgba(0, 0, 0, .1);
  color: #e0e0e0;
  text-shadow: 0px 1px 0px #4d7a85;
  filter: dropshadow(color=#4d7a85, offx=0, offy=1);
  border: 1px solid #55838f;
  position: relative;
  margin: -1px;
}
.ui-datepicker-unselectable .ui-state-default {
  background: #f4f4f4;
  color: #b4b3b3;
}
.ui-datepicker-calendar td:first-child .ui-state-active {
  width: 29px;
  margin-left: 0;
}
.ui-datepicker-calendar td:last-child .ui-state-active {
  width: 29px;
  margin-right: 0;
}
.ui-datepicker-calendar tr:last-child .ui-state-active {
  height: 29px;
  margin-bottom: 0;
}
/*----------------------------------------------- table style -------------------------*/
table {
	
}

table:not(.ui-datepicker-calendar) tr {
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
.mainHeaderBtnContainer .btn {
  display: flex;
  align-items: center;
}
#mainHeaderContent {
	color: #666;
	background: #D9D7CE;
	position: relative;
	padding: 10px 20px;
  display: flex;
  align-items:stretch;
  height:100px;
  border-bottom:1px solid #efefef;
}

#mainHeaderContent > div {
  padding:0 6px;
  /*min-width:100px;*/
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
.miniCart {
  border-radius:10px;
  background: #303030;
  height:100%;
  padding:6px;
  color:#fff;
  font-weight:bold;
}

.miniCartSubTotal,.miniCartTax,.miniCartTotal,.miniCartItems {
  display:flex;
  align-items:center;
}
.miniCartTotal {
  /*border-top: 1px solid #fff;*/
  font-size:20px;
}
.miniCartItems { 
  font-size:20px;
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
.btn.disabled {
  background-color: #e6e6e6;
  border-color: #adadad;
}
.btn.default:hover {
  background-color: #fff;
  border-color: #adadad;
}
/*----------------------------------------header------------------------------------------*/
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

/* .home { */
/* 	background-image: url('<v:config key="resources_url"/>/mobileSales/assets/images/header/home.png'); */
/* } */

/* #mainHeaderCart .back { */
/* 	background-image: url('<v:config key="resources_url"/>/mobileSales/assets/images/header/back.png'); */
/* } */

#mainHeaderCart {
	position: absolute;
	right: 100px;
	text-align: right;
	border-radius: 10px;
	background: #F5F5F7;
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
.mainHeaderText {
  font-size: 7vw;
  padding: 17px 0 !important;
  line-height: 1;
  text-align: center;
}
#tab-header-redeem-manual input {
  text-transform: uppercase;
  width: 80vw;
  border: none;
  padding: 3vw;
  margin: 0;
  font-size: 4vw;
  line-height: 14vw;
  height: 81px;
}
.miniCartContainer,.mainHeaderText {
  flex-grow:2;
}
.miniCart hr{
	margin-top: 0px;
	margin-bottom: 0px;
}
.mainHeaderBtnContainer .btn {
  height:80px;
	/*width:80px;
  min-width:80px;
  min-height:80px;*/
	padding: 6px;
}
#mainHeaderContinue span{
  background-position: center center;
  background-repeat: no-repeat;
  width: 100%;
  height: 100%;
}
#mainHeaderContinue span.shopCartIcon {
	width: 62px;
  background-image:url(<v:image-link name="bkoact-check.png" size="64"/>);
}
#mainHeaderContinue span.mediaIcon {
	width: 62px;
  background-image:url(<v:image-link name="bkoact-media-black.png" size="64"/>);
}
#mainHeaderContinue span.cashRegisterIcon {
	width: 62px;
  background-image:url(<v:image-link name="bkoact-cashregister.png" size="64"/>);
}
#mainHeaderContinue span.keyboardIcon {
	width: 62px;
  background-image:url(<v:image-link name="[font-awesome]keyboard" size="64"/>);
}
.keyboardopen {
background-color: #fecc00;
}
.btn-default.keyboardopen:hover {
    
    background-color: #fecc00;
    border-color: transparent;
}
#mainHeaderContinue.keyboardopen span.keyboardIcon {
  background-image:url(<v:image-link name="[font-awesome]keyboard|TransformNegative" size="64"/>);
}
/*---------------------------------------- header ------------------------------------------*/
/*---------------------------------------- sidebar -----------------------------------------*/

#mainSidebarContent {
  display:flex;
  flex-direction:column;
  height:100%;
  right:0;
  position:fixed;
  align-items:center;
  box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.4);
  background:#5E5E5E;
  width:100px;
  z-index:99;
}

/*---------------------------------------- footer ------------------------------------------*/
div#mainFooter {
  position: fixed;
  width: 100%;
  bottom:0;
  background:#5E5E5E;
}
#mainFooterContainer {
  display:flex;
}
/*---------------------------------------- footer ------------------------------------------*/
/*---------------------------------------- breadcrumbs ------------------------------------------*/
div#mainBreadcrumbsContent {
	float: left;
	width: 70%;
	height: 40px;
  color:#fff;
  display:none;
}
.footerBtnContainer {
  padding:20px 0;
  color:#fff;
  border-left: 1vw solid #5E5E5E;
}
.footerBtnContainer.active-tab {
  opacity: 1;
  border-left: 1vw solid #fecc00;
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
  display:none;
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
/*---------------------------------------- login ------------------------------------------------*/
.loginContent {
  width: 50%; 
  margin: auto; 
  padding: 30px; 
  background: #fff; 
  border-radius: 15px;    
  margin-top: 20%;
}
/*---------------------------------------- login ------------------------------------------------*/
/*---------------------------------------- category item ------------------------------------------*/

.categoryItemContainer,.productItemContainer,.eventItemContainer  {
  height:15vw;
  margin: 5px 0;
  padding:0 5px;
}

/*.categoryItemContainer:after,
	.productItemContainer:after,
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
}*/

	.appSalesGuestButtonContainer:after {
	-webkit-transform: rotate(7deg);
	-moz-transform: rotate(7deg);
	-o-transform: rotate(7deg);
	-ms-transform: rotate(7deg);
	transform: rotate(7deg);
	right: 2px;
	left: auto;
}

.categoryItemContent,.productItemContent,.eventItemContent {
	width: 100%;
	height: 100%;
	overflow: hidden;
	position: relative;
  display:flex;
  align-items:center;
  cursor:pointer;
  border-radius:5px;
  background:#fff;
  
}
.productItemContent{
  align-items:stretch;
}
.categoryItemContent {
  
  
}
.productItemContent {
  
  
}
.eventItemContent {
  

}
.eventImage,.categoryImage,.productImage {
  height: 100%;
  background-size: cover;
  background-position: center center;
  background-repeat:no-repeat;
  width: 15vw;
  margin-right: 10px;
}
.productDetails {
    width: 75vw;
}
.productPriceContainer {
  float: left;
  width: 20%;
}
.attributeItemContent {
  display:flex;
  justify-content:space-between;
}
.attributeItemContent.selected .productPriceContainer,.attributeItemContent.selected .productName {
  background: rgba(225,106,19,0.8) ;
}
.attributeSelection {
  width: 20%;
  float: left;
  min-height: 100%;
}
.attributeItemContent.selected .attributeSelection {
  background: url(<v:image-link name="bkoact-check.png" size="64"/>) no-repeat;
  background-position: center center;
  
}
.attribute {
  border: 3px solid  #fff;
}
.attributeContainer {
  margin-top: 40px;
}
.attributeSummary {
  position:fixed;
  width:100%;
  background:#F0EFF5;
  height:40px;
  display:flex;
  align-items:center;
  margin-top: -40px;
}
.attribute.selected {
    border: 3px solid  rgba(225,106,19,1);
}
	.appSalesGuestButtonContainer .appSalesGuestButtonImage {
	width: 100%;
	height: 100%;
	background-size: cover;
	background-repeat: none;
}

.categoryItemContainer .categoryName,.eventName, .appSalesGuestButtonName {
	color: #000;
  font-weight:normal;
  font-size:20px;
  padding: 0;
}

.productItemContainer .productPrice, .attributePriceContainer {
	color:#000;
  text-align: right;
  float: left;
  width: 20%;
  padding: 5px 0 0;
}

.productPrice{
	padding: 5px 6px 0px 0px !important;
}

/*.panel {
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
}*/

.active {
	display: block;
}

.productName {
  float: left;
  width: 80%;
  margin-bottom: 7px;
  font-weight: normal;
  color: #000;
  padding: 5px 12px 0px 0;
  font-size:20px;
  border-bottom: 1px solid #efefef;
  min-height: 45px;
}


.productDescription {
    float: left;
    width: 80%;
    font-weight: normal;
    color: #000;
    padding: 0px 0px 0px 0;
    font-size: 16px;
    min-height: 45px;
}

.attributeImage {
  width: 15vw;
  background-size: cover;
  background-repeat: no-repeat;
}
.attributeItemInfo {
  width:75vw;
}
.attributeName {
  float: left;
  width: 60%;
  margin-bottom: 7px;
  font-weight: normal;
  color: #000;
  padding: 5px 23px 0px 0;
  font-size:20px;
  border-bottom: 1px solid #efefef;
  min-height: 45px;
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



span.productPrice {
	font-size: 20px;
	font-weight: bold;

}

span.productQtyCart {
	font-size: 18px;
	font-weight: bold;
	text-shadow: 0 0 5px rgba(0, 0, 0, 0.7);
	position: absolute;
	bottom: 5px;
	left: 10px;
}
.tab-button {
  width: 20vw;
  height: 15vw;
  float: left;
  position: relative;
  opacity: 0.5;
  cursor: pointer;
  border-top: 1.5vw solid rgba(0,0,0,0);
}
/*---------------------------------------- category item ------------------------------------------*/
/*---------------------------------------- form ----------------------------------------------*/
input[type='text'],input[type='email'],input[type='password'] {
  width:100%;
  height:40px;
  border-radius:0px;
  border: 1px solid #ccc;
  padding:0 10px;
  font-size: 20px;
}
input.error {
  border:3px solid red;
}
.formItem {
  margin:10px 0;
}
.formNavigation {
  padding:20px 0;
  width:100%;
  height:120px;
  background:#eee;
  position:absolute;
  bottom: 0;
  z-index: 9999;
}
.ui-datepicker {

    background: #fff;
}
/*---------------------------------------- form ----------------------------------------------*/
.no-padding {
  padding:0;
}
.flex {
  display:flex;
}
#ProductContainer.active {
    right: 0;
  }
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

@media ( max-width : 1024px) and (orientation: portrait) {
#mainContent {
	position: absolute;
	top: 15px;
	padding: 0px 5px;
	bottom: 10px;
	left: 0;
}
.mainHeaderBtnContainer,.miniCartContainer {
    padding: 5px;
}

.page {
    margin-bottom: 110px;
    }
	
#mainHeaderContent {
	padding: 10px 10px 10px 0px;
  width: 100%;
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
		font-size: 20px;
	}
	span.productQtyCart {
		font-size: 20px;
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
		/*font-size: 14px;*/
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
 #mainSidebarContent {
    display:none;
  }
@media  (orientation: portrait) {
  #mainFooterContainer { 
    display:block;
  }
  #mainSidebarContent {
    display:none;
  }
}
#ui-datepicker-div {
  /*left: auto !important;*/
}
@media  (orientation: landscape) {
  #mainFooterContainer { 
    /*display:none;*/
  }
  .productDetails {
    width: 27vw;
  }
  #mainFooter .tab-button-list{
    /*display:none;*/
  }
  #mainSidebarContent {
    /*display:block;*/
  }
  /*---------------------------------------- login ------------------------------------------------*/
/*.loginContent {
  width: 20%; 
  margin: auto; 
  padding: 30px; 
  background: #fff; 
  border-radius: 15px;    
  margin-top: 20%;
}*/
/*---------------------------------------- login ------------------------------------------------*/
	/*.categoryItemContainer, .productItemContainer, .eventItemContainer {
		width: 185px;
		height: 185px;
		float: left;
		box-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
		position: relative;
		margin: 0px 6px 20px;
		border-radius: 10px;
		cursor: pointer;
	}*/
 /* #ProductContainer.active {
    right: 0;
    padding-right:100px;
  }
  #mainContent {
    padding: 0px 105px 0 5px;
  }
  #mainHeaderContent {
    padding-right:100px;
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
	
}*/
@media ( max-width : 601px) and (orientation: landscape) {
.loginContent {
  width: 50%; 
  margin: auto; 
  padding: 30px; 
  background: #fff; 
  border-radius: 15px;    
  margin-top: 20%;
}
}

</style>
