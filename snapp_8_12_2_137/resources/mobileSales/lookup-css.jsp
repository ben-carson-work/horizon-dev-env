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
.tap {
	width: 95%;
	background: url('<v:config key="resources_url"/>/mobileSales/assets/images/checkout/tablet_back.png') no-repeat 50% 55%;
	background-size: 30%;
	text-align: center;
	font-size: 45px;
	font-weight: bold;
	position: absolute;
	bottom: 10px;
	top: 10px;
}
#lookupResults {
	width:70%;
	margin:0 15%;
}
@media only screen and (orientation: portrait) {
	.tap {
		background-size: 60%;
		background-position:50% 35%
	}
}
</style>
