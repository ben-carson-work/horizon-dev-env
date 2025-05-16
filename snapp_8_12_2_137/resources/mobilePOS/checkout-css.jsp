<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<style id="checkout-css.jsp">
/*
	default colors:
	orange: rgb(225,106,19) o rgba(225,106,19,x)
	green: rgb(0,133,155) o rgba(0,133,155,x)
	black: rgba(0,0,0,0.7)
*/
td.checkoutItemUnitPrice,th.checkoutItemUnitPrice {
 		text-align:right;
 		width: 80px;
 		white-space: nowrap;
	}
	
td.checkoutItemPrice,th.checkoutItemPrice {
 		text-align:center;
 		width: 100px;
  	}

.paymentMethodList {
  display:flex;
  background:#eee;
  position:fixed;
  bottom:120px;
  padding:10px 0;
}

.scrolling-wrapper {
  overflow-x: scroll;
  overflow-y: hidden;
  white-space: nowrap;
  -webkit-overflow-scrolling: touch;
}
.card {
    display: inline-block;
    margin: 2px 5px;
    background-color: #e7e7e7;
    padding: 12px;
    /* border-radius: 12px; */
    border: 1px solid #b9c3b9;
    box-shadow: 0 3px 7px 0 rgba(0,0,0,0.2), 0 5px 13px 0 rgba(0,0,0,0.19);
    min-width: 150px;
}
  .scrolling-wrapper .card h3 {
	overflow: hidden;
    text-overflow: ellipsis;
    font-size: 19px;
  }
.scrolling-wrapper {
  &::-webkit-scrollbar {
    display: none;
  }
}

.tap {
	width: 95%;
	background: url('<v:config key="resources_url"/>/mobileSales/assets/images/checkout/tablet_back.png') no-repeat 50% 55%;
	
	background-size: 30%;
	text-align: center;
	font-size: 30px;
	font-weight: bold;
}
#tapResults {
	position:relative;
}
#tapResultsContent {
	margin-bottom:10px;
}
.pay {
	width: 70%;
	text-align: center;
	margin: 0 15%;
	line-height: 50px;
	font-size: 15px;
}
.checkoutLookupResults {
	width: 70%;
	margin: 0 15%;
}
.checkoutLookupResults td:not(.label) {
	/*border:1px solid rgb(0,133,155);*/
}
.label {
	background: rgb(0,133,155);
	color: #FFF;
	font-size: 15px;
	width:35%;
}
.ftright {
	text-align:right;
}
.value {
	font-size:18px;
	font-weight:bold;
}
@media only screen and (orientation: portrait) {
	.tap {
	background-size: 70%;
	background-position:50% 15%
	}
	.pay {
	font-size: 25px;
	}
	.label {
		font-size: 15px;
	}
}
@media  only screen and (orientation: landscape) {
  .paymentMethodList {
    padding:10px 100px 10px 0;
    bottom:0;
    
  } 
}

/*-------------------------------- transaction result ----------------------*/
#transactionResultContent .thumb {
	width: 10vh;
	height: 10vh;
	float: left;
	background-size: contain;
}
#transactionResultContent .text {
	float: left;
	line-height: 5vh;
	margin-left: 20px;
}

#transactionResult {
	width: 70%;
	margin: 0 15%;
	text-align: left;
}
table.transactionLookupResults {
	width: 70%;
	margin: 20px 15%;
}
div#operatorCheckout {
	width: 70%;
	margin: 0 15%;
}
input#location {
	width: 38%;
	height: 40px;
	margin: 20px 30%;
	padding: 0 1%;
	font-size: 18px;
}
.button.proceed {
	width: 50%;
	text-align: center;
	line-height: 50px;
	margin: 30px auto;
}
.negative {
	color:#ff6666;
}
#beforepay {
	width:70%;
	margin: 0 auto;
}
#note {
	width:100%;
	height:150px;
}

</style>
