<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<style>
/*
	default colors:
	orange: rgb(225,106,19) o rgba(225,106,19,x)
	green: rgb(0,133,155) o rgba(0,133,155,x)
	black: rgba(0,0,0,0.7)
*/
#appSalesOperatorContainer {
	width:100%;
	height:100%;
	background:rgb(0,133,155) ;
	position: fixed;
}
.login {
	position: absolute;
	top: 9%;
	left: 50%;
	margin-left: -200px;
	width: 400px;
	background: #fff;
	border-radius: 5px;
	text-align: center;
	box-shadow:0 0 10px #000;
	overflow:hidden;
}
 .login h1 {
	background:rgb(225,106,19);
	color:#fff;
	margin:0;
	font-size: 25px;
	padding: 10px 0;
}
.loginContent {
	padding: 20px 0;
}
 input[type=text], input[type=password] {
	height: 40px;
	width: 80%;
	border: #e5e5e5 solid 1px;
	background: #fbfbfb;
	box-shadow: 1px 1px 2px rgba(200, 200, 200, 0.2) inset;
	padding: 0 5px;
	margin: 5px 0;
}
 input.button {
	margin: 10px auto;
}
</style>
