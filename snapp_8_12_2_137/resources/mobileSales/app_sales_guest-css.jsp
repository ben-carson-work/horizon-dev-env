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
#appSalesGuestContainer {
	width:100%;
	height:100%;
	background:rgb(0,133,155) ;
	position: fixed;
}
#appSalesGuestContent {
	width:100%;
	height:100%;
	background: url('<v:config key="resources_url"/>/mobileSales/assets/images/appSalesGuest/homeBg.png') no-repeat 0 0;
	background-size: contain;
}
#homeContent {
	position: absolute;
	width: 480px;
	margin: 45% -240px;
	left: 50%;
}
.appSalesGuestButtonContainer {
	width: 200px;
	max-width: 280px;
	height: 200px;
	/* max-height: 280px; */
	float: left;
	box-shadow: 0 2px 5px rgba(0,0,0,0.3);
	position: relative;
	margin: 0 20px 20px;
	border-radius: 10px;
	cursor: pointer;
}

#lookupButton .appSalesGuestButtonImage {
	background: url('<v:config key="resources_url"/>/mobileSales/assets/images/appSalesGuest/checklist.jpg') no-repeat 0 0;
	width: 100%;
	height: 100%;
	background-size: cover;
	background-repeat: none;
}
#buyButton .appSalesGuestButtonImage {
	background: url('<v:config key="resources_url"/>/mobileSales/assets/images/appSalesGuest/bag.png') no-repeat 0 0;
	width: 100%;
	height: 100%;
	background-size: cover;
	background-repeat: none;
}
#accountButton .appSalesGuestButtonImage {
  background: url('<v:config key="resources_url"/>/mobileSales/assets/images/appSalesGuest/account.png') no-repeat 0 0;
  width: 100%;
  height: 100%;
  background-size: 90%;
  background-position: center center;
  background-repeat: none;
}
	@media (max-width: 640px) and (orientation: landscape) {
		#appSalesGuestContent {
			width: 100%;
			height: 400px;
			background: url('<v:config key="resources_url"/>/mobileSales/assets/images/appSalesGuest/homeBg.png') no-repeat 0 -50px;
			background-size: 100%;
			padding-bottom:0px;
		}
		#homeContent {
			position: absolute;
			width: 300px;
			margin: 200px -150px;
			left:50%;
		}
		.appSalesGuestButtonContainer {
			width: 130px;
			height: 130px;
			float: left;
			box-shadow: 0 2px 5px rgba(0,0,0,0.3);
			position: relative;
			margin:0 10px;
			border-radius: 10px;
			cursor: pointer;
		}
	}
	@media (max-width: 360px) and (orientation: portrait) {
		#appSalesGuestContent {
			width: 100%;
			height: 100%;
			background: url('<v:config key="resources_url"/>/mobileSales/assets/images/appSalesGuest/homeBg.png') no-repeat 0 10%;
			background-size: contain;
		}
		#homeContent {
			position: absolute;
			width: 300px;
			margin: 50% -150px;
			left:50%;
		}
		.appSalesGuestButtonContainer {
			width: 130px;
			max-width: 130px;
			height: 130px;
			max-height: 130px;
			float: left;
			box-shadow: 0 2px 5px rgba(0,0,0,0.3);
			position: relative;
			margin:0 10px;
			border-radius: 10px;
			cursor: pointer;
		}
	}

</style>
