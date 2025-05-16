<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<style>
	.cartRows {
		font-size:2vw;
		border:none;
	}
	.cartHeader th {
		background:rgb(0,133,155);
		color:#FFF;
		font-size: 1.2vw;
	}
	.cartRows td {
		border-bottom:1px solid #FFF;
	}
	td.productImage,th.productImage {
		width:50px;
	}
 	td.productImage img {
 		width:50px;
 	}
 	td.buttons,th.buttons {
		width: 125px;
	}
	td.delete,th.delete {
		width: 60px;
	}
 	td .button {
	 	width: 40px;
		height: 40px;
		margin: 1vw 1vw;
		color: #FFF;
		float:left;
		line-height: 40px;
		text-decoration: none;
		font-size: 30px;
		text-align: center;
		font-weight: bold;
		
 	}
 	td.cartItemUnitPrice,th.cartItemUnitPrice {
 		text-align:right;
 		width: 80px;
	}
 	td.quantity,th.quantity {
 		text-align:right;
 		width: 40px;
 	}
 	td.cartItemPrice,th.cartItemPrice {
 		text-align:right;
 		width: 100px;
 	}
 	table.cartTotals {
		width: 30%;
		float: right;
		border:1px solid rgba(0,133,155,1);
		font-weight:bold;
	}
@media only screen and (orientation: portrait) {
 	td.buttons,th.buttons {
		width: 40px;
	}
 	td.buttons .button {
	 	width: 40px;
		height: 40px;
		margin: 5px 0;
		line-height: 40px;
		float:none;
		font-size: 25px;
 	}
 	td.cartProductName {
 		font-size:12px;
 	}
 	td.cartProductName,th.cartProductName { 
 		
 		
 	}
 	td.cartItemPrice, th.cartItemPrice,td.cartItemUnitPrice, th.cartItemUnitPrice {
		width: 70px;
	}
	td.productImage,th.productImage {
		width:50px;
	}

 	.cartRows {
		font-size: 20px;
	}
	.cartHeader th {
		font-size: 12px;
	}
 }
</style>
