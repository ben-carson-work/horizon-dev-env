<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<style>

#admission .body {
	position: fixed;
	top: 24vh;
	left: 0px;
	right: 0px;
	padding: 0.8vmin;
}

#admission .display-good {
	background-image: -webkit-linear-gradient(top, #009900 0%, #00aa00 100%);
	border: 1px #009900 solid;
}

#admission .display-bad {
	background-image: -webkit-linear-gradient(top, #22a1dc 0%, #22a1ec 100%);
	border: 1px #22a1dc solid;
}

#search-bar {
	
}

#MediaCode {
	
}

#operator-msg span.thumb, #ticket-info span.thumb, #account-info span.thumb {
	background-size: 80%;
	display: block;
	width: 9vh;
	height: 9vh;
	background-repeat: no-repeat;
	background-position: 50% 50%;
	float: left;
	min-height: 40px;
	min-width: 40px;
}

#operator-msg span.text {
	height: 9vh;
	line-height: 9vh;
	/* display: block; */
	float: left;
}
div#ticket-info {
	border-bottom: 1px solid #ccc;
}
#ticket-info span.text, #account-info span.text {
	height: 9vh;
	line-height: 4vh;
	/* display: block; */
	float: left;
}
#ticket-info span.text, #account-info span.text {
	height: 9vh;
	line-height: 4vh;
	/* display: block; */
	float: left;
}
.product-name,.account-name {
	font-weight:bold;
}
div#operator-msg {
	padding: 20px;
	background: #fff;
	border:1px solid #ccc;
}
div#result {
	padding: 20px;
	background: #fff;
	margin-top:10px;
	border:1px solid #ccc;
}

div#results.query {
	border-color: #ccc;
}

div#results.redeem {
	border-color: #1e5799;
}

input#MediaCode {
	width: 95vw;
	height: 6vh;
	min-height: 40px;
	margin: 0 2.5vw;
	font-size: 4vh;
}

fieldset#scan-type-switch {
	border: none;
	float: left;
	width: 21vw;
}

#ticketInfo .usage {
	border-top: 1px rgba(255,255,255,0.5) solid;
	border-bottom: 1px rgba(0,0,0,0.2) solid;
	font-size: 22px;
	line-height: 60px;
	padding-left: 36px;
	background-repeat: no-repeat;
	background-position: left center;
}

#ticketInfo {
	width: 100%;
}

#admission .manual-input-btn {
	float: right;
}


/*
#admission .tck-note-btn{
  float: right;
  -webkit-animation-name: pulsate-note;
  -webkit-animation-duration: 1.8s;
  -webkit-animation-timing-function: ease-in-out;
  -webkit-animation-iteration-count: infinite
}

@-webkit-keyframes pulsate-note {
  0%   { opacity: 0.1; }
  45% { opacity: 1; }
  55% { opacity: 1; }
  100%   { opacity: 0.1; }
}
*/
@media screen and (max-height: 552px) {
	#admission .body {
		top: 150px;
	}
}

</style>