<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>


<style>

.on_off {
	float: left;
}

.iPhoneCheckContainer {
	-webkit-transform: translate3d(0,0,0);
	position: relative;
	height: 3vh;
	cursor: pointer;
	overflow: hidden;
	float: left;
	margin: 2.5vh 2.5vw 0;
	width: 220px;
	min-height: 40px;
}

.iPhoneCheckContainer input {
	position: absolute;
	top: 5px;
	left: 30px;
	filter: progid:DXImageTransform.Microsoft.Alpha(Opacity=0);
	opacity: 0;
}

.iPhoneCheckContainer label {
	white-space: nowrap;
	font-size: 17px;
	line-height: 17px;
	font-weight: bold;
	font-family: "Helvetica Neue", Arial, Helvetica, sans-serif;
	cursor: pointer;
	display: block;
	height: 28px;
	position: absolute;
	width: auto;
	padding-top: 12px;
	overflow: hidden;
	border-radius: 20px;
}

.iPhoneCheckContainer, .iPhoneCheckContainer label {
	user-select: none;
	-moz-user-select: none;
	-khtml-user-select: none;
}

.iPhoneCheckDisabled {
	filter: progid:DXImageTransform.Microsoft.Alpha(Opacity=50);
	opacity: 0.5;
}

label.iPhoneCheckLabelOn {
	color: white;
	background: #ff3019; /* Old browsers */
	background: -moz-linear-gradient(top, #ff3019 0%, #cf0404 100%); /* FF3.6+ */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#ff3019), color-stop(100%,#cf0404)); /* Chrome,Safari4+ */
	background: -webkit-linear-gradient(top, #ff3019 0%,#cf0404 100%); /* Chrome10+,Safari5.1+ */
	text-shadow: 0px 0px 2px rgba(0, 0, 0, 0.6);
	left: 0;
	padding-right: 35px;
}

label.iPhoneCheckLabelOn span {
	padding-left: 8px;
}

label.iPhoneCheckLabelOff {
	color: #FFF;
	background: #97e25d; /* Old browsers */
background: -moz-linear-gradient(top, #97e25d 0%, #61c419 100%); /* FF3.6+ */
background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#97e25d), color-stop(100%,#61c419)); /* Chrome,Safari4+ */
background: -webkit-linear-gradient(top, #97e25d 0%,#61c419 100%); /* Chrome10+,Safari5.1+ */
	text-shadow: 0px 0px 2px rgba(0, 0, 0, 0.6);
	text-align: right;
}

label.iPhoneCheckLabelOff span {
	padding-right: 8px;
}

.iPhoneCheckHandle {
	display: block;
	height: 3vh;
	cursor: pointer;
	position: absolute;
	left: 0;
	width: 0;
	background: #fff;
	/*
	background: #a5a5a5;
 	background: -moz-linear-gradient(top, #a5a5a5 0%, #c9c9c9 50%, #a5a5a5 100%);
 	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#a5a5a5), color-stop(50%,#c9c9c9), color-stop(100%,#a5a5a5));
 	background: -webkit-linear-gradient(top, #a5a5a5 0%,#c9c9c9 50%,#a5a5a5 100%);
 	*/
	padding-left: 0px;
	min-height: 40px;
	border-radius: 20px;
}

.iPhoneCheckHandleRight {
	height: 100%;
	width: 100%;
	padding-right: 3px;
	background: #fff;
	/*
	background: #a5a5a5;
 	background: -moz-linear-gradient(top, #a5a5a5 0%, #c9c9c9 50%, #a5a5a5 100%);
 	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#a5a5a5), color-stop(50%,#c9c9c9), color-stop(100%,#a5a5a5));
 	background: -webkit-linear-gradient(top, #a5a5a5 0%,#c9c9c9 50%,#a5a5a5 100%);
 	*/
	border-radius: 20px;
}

.iPhoneCheckHandleCenter {
	height: 100%;
	width: 100%;
	background: #fff;
	/*
	background: #a5a5a5;
 	background: -moz-linear-gradient(top, #a5a5a5 0%, #c9c9c9 50%, #a5a5a5 100%);
 	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#a5a5a5), color-stop(50%,#c9c9c9), color-stop(100%,#a5a5a5));
 	background: -webkit-linear-gradient(top, #a5a5a5 0%,#c9c9c9 50%,#a5a5a5 100%);
 	*/
	border-radius: 20px;
}

.iOSCheckContainer {
	position: relative;
	height: 27px;
	cursor: pointer;
	overflow: hidden;
}

.iOSCheckContainer input {
	position: absolute;
	top: 5px;
	left: 30px;
	filter: progid:DXImageTransform.Microsoft.Alpha(Opacity=0);
	opacity: 0;
}

.iOSCheckContainer label {
	white-space: nowrap;
	font-size: 17px;
	line-height: 17px;
	font-weight: bold;
	font-family: "Helvetica Neue", Arial, Helvetica, sans-serif;
	cursor: pointer;
	display: block;
	height: 22px;
	position: absolute;
	width: auto;
	padding-top: 5px;
	overflow: hidden;
}

.iOSCheckContainer, .iOSCheckContainer label {
	user-select: none;
	-moz-user-select: none;
	-khtml-user-select: none;
}

.iOSCheckDisabled {
	filter: progid:DXImageTransform.Microsoft.Alpha(Opacity=50);
	opacity: 0.5;
}

label.iOSCheckLabelOn {
	color: white;
	background: none;
	text-shadow: 0px 0px 2px rgba(0, 0, 0, 0.6);
	left: 0;
	padding-top: 5px;
}

label.iOSCheckLabelOn span {
	padding-left: 8px;
}

label.iOSCheckLabelOff {
	color: #8b8b8b;
	background: none;
	text-shadow: 0px 0px 2px rgba(255, 255, 255, 0.6);
	text-align: right;
	right: 0;
}

label.iOSCheckLabelOff span {
	padding-right: 8px;
}

.iOSCheckHandle {
	display: block;
	height: 27px;
	cursor: pointer;
	position: absolute;
	left: 0;
	width: 0;
	background: none;
	padding-left: 3px;
}

.iOSCheckHandleRight {
	height: 100%;
	width: 100%;
	padding-right: 3px;
	background: none;
}

.iOSCheckHandleCenter {
	height: 100%;
	width: 100%;
	background:none;
}
</style>
