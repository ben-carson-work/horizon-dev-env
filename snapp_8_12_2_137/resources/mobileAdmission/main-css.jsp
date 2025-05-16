<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:include page="assets/tabs-css.jsp" />
<jsp:include page="assets/loadingimage-css.jsp" />
<jsp:include page="assets/switcher-css.jsp" />

<style>
body {
  background-color: #e8f2ff;
  padding: 0px;
  margin: 0px;
  font-family: verdana,sans-serif; 
  -webkit-user-select: none;
   padding: 0;
  margin: 0;
  width: 100%;
  height: 100%;
  overflow: hidden;
}
input, textarea {
  -webkit-appearance: none;
  -webkit-border-radius: 0;
}
   .body {
  bottom: 15.7vmin;
  
}
.body-panel {
  background: none;
  position: absolute;
  margin: 0vmin;
  padding: 0;
  top: 0vh;
  left: 0px;
  right: 0px;
  bottom: 0px;
/*
  display:-webkit-box;
  -webkit-box-pack:center;
  -webkit-box-align:center;
  */
}
#content {
  position: fixed;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  overflow: auto;
}

.scrolling {
  -webkit-overflow-scrolling: touch;
  overflow: auto;      
}
.no-scrolling {
  overflow: hidden;      
}

.button {
  display: inline-block;
  position: relative;
  background-color: #85a4c7;
  width: 8vh;
  height: 8vh;
  margin: 1.0vmin;
  border-radius: 1.7vmin;
  border-top: 1px rgba(255,255,255,0.5) solid;
  border-bottom: 1px rgba(0,0,0,0.5) solid;
  box-shadow: 1px 1px 3px rgba(0,0,0,0.5);
  opacity: 1;
  background-repeat: no-repeat;
  background-position: center 35%;
  background-size: 60%;
  text-indent:-99999px;
}
.button.admission.checked {
  display: inline-block;
  position: relative;
  background-color: #fff;
  width: 8vh;
  height: 8vh;
  margin: 1.0vmin;
  border-radius: 1.7vmin;
  border-top: 1px rgba(255,255,255,0.5) solid;
  border-bottom: 1px rgba(0,0,0,0.5) solid;
  box-shadow: 1px 1px 3px rgba(0,0,0,0.5);
  opacity: 1;
  background-repeat: no-repeat;
  background-position: center 35%;
  background-size: 60%;
  text-indent:-99999px;
}

.button .icon {
  position: absolute;
  top: 0px;
  left: 0px;
  right: 0px;
  bottom: 1.0vmin;
  background-repeat: no-repeat;
  background-position: center center;
}

.button .caption {
  position: absolute;
  bottom: 0px;
  left: 0px;
  right: 0px;
  background-color: rgba(0,0,0,0.2);
  line-height: 1.7vmin;
  font-family: sans-serif;
  font-size: 1.5vmin;
  border-bottom-left-radius: 1.7vmin;;
  border-bottom-right-radius: 1.7vmin;;
  color: white;
  text-shadow: 0px -1px rgba(0,0,0,0.5);
  font-weight:bold;
  text-align: center;
}

.button-pressed {
  box-shadow: none;
}

.button .press-shade {
  background: black;
  position: absolute;
  top: 0px;
  left: 0px;
  bottom: 0px;
  right: 0px;
  border-radius: 12px;
  z-index: 10;
  opacity: 0.3;
  visibility:hidden;
}

.button-pressed .press-shade {
  visibility: visible;
}

.enabled {
  opacity: 1;
}
/*----------------------------------------------- toolbar -------------------------------------------------*/
.toolbar {
	height: 10vh;
	background-image: -webkit-linear-gradient(top, #bdcee1 0%, #87a5c7 50%, #7d9ec3 50%, #6a86a5 100%);
	border-top: 1px #dfe7f0 solid;
	border-bottom: 1px #4f647c solid;
	position: fixed;
	top: 0;
	left: 0;
	right: 0;
	z-index: 999;
	min-height:60px !important;
}

.toolbar .title {
  	font-size: 5.0vmin;
	font-weight: bold;
	color: white;
	text-shadow: 0px -1px rgba(0,0,0,0.5);
	text-align: center;
	line-height: 10vh;
	position: absolute;
	top: 0;
	right: 0;
	left: 0;
	bottom: 0;
}

.toolbar .button {
  float: left;
  background-position: center center;
  margin:5px 10px;
}
.toolbar .access-point-name{
 	float: right;
	line-height: 1;
	margin-right: 30px;
	font-weight: bold;
	color: #fff;
	margin-top: 10px;
	font-size: 2vmin;
}

.toolbar .display {
  background-image: -webkit-linear-gradient(top, #3c3c3c 0%, #282828 100%);
  border: 1px #000 solid;
  width: 354px; 
  border-radius: 12px;
  padding: 6px;
  margin: 6px;
  float: left;
  font-size: 18px;
  color: white;
  text-shadow: 0px -1px #000;
}

.toolbar .display .display-item {
  padding: 1px 6px 1px 6px;
}

.toolbar .display .value {
  float: right;
}

.toolbar .display .upgrade {
  border-radius: 6px;
  text-align: center;
  width 100%;
  color:lime;
  font-weight:bold;
  background: rgba(255,255,255,0.2);
  border: 1px rgba(255,255,255,0.1) solid;
}

.toolbar .display .product {
  padding: 1px 6px 1px 6px;
  padding: 3px 6px 4px 6px;
}

.toolbar .display .tax {
  border-bottom: 1px black solid;
  padding-bottom: 8px;
}

.toolbar .display .total {
  font-size: 32px;
  border-top: 1px rgba(255,255,255,0.2) solid;
}
/*------------------------------------------------ toolbar end -------------------------------------------------*/

/*------------------------------------------------ info bar ------------------------------------------------------*/
.infobar {
	height: 1vh;
	background: #FFF;
	position: fixed;
	top: 10vh;
	left: 0;
	right: 0;
	z-index: 999;
	min-height: 20px !important;
	text-align: center;
	padding: 1vh 0;
	text-transform: uppercase;
	font-weight: bold;
	color: #000;
}
/*------------------------------------------------ info bar end------------------------------------------------------*/

/*------------------------------------------------ actionbar ------------------------------------------------------*/
.actionbar {
	height: 10vh;
	background: #e5e5e5;
	border-top: 1px #ccc solid;
	border-bottom: 1px #ccc solid;
	position: fixed;
	top: 14vh;
	left: 0;
	right: 0;
	z-index: 999;
	min-height:60px !important;
}

.actionbar-btn {
	display: block;
	margin: 1vh 0.3vw;
	line-height: 2vh;
	font-family: sans-serif;
	font-size: 2vmin;
	color: #000;
	font-weight: bold;
	text-align: center;
	background-repeat: no-repeat;
	background-position: center center;
	height: 8vh;
	min-height: 35px !important;
	background-size: contain;
	width: 8vh;
	text-indent: -19999px;
	border-radius: 1.7vmin;
	border-top: 1px rgba(255,255,255,0.5) solid;
	border-bottom: 1px rgba(0,0,0,0.5) solid;
	box-shadow: 1px 1px 3px rgba(0,0,0,0.5);
	opacity: 1;
	background-repeat: no-repeat;
	background-size: 60%;
	min-width: 35px !important;
	background-color: #85a4c7;
	cursor:pointer;
}
div#WkName {
position: fixed;
background: #7392B4;
padding: 10px;
top: 0;
border-bottom-left-radius: 10px;
border-bottom-right-radius: 10px;
color: #fff;
left: 10vh;
font-size: 10px;
z-index:999;
}
#loginBg {
  background: rgba(0, 0, 0, 0.7);
  width: 100%;
  height: 100%;
  position: fixed;
  top: 0;
  z-index: 999;
}
#loginBg .login {
position: absolute;
top: 9%;
left: 50%;
margin-left: -200px;
width: 400px;
background: #fff;
border-radius: 5px;
text-align: center;
box-shadow: 0 0 10px #000;
overflow: hidden;
}
#loginBg .login h1 {
background: rgb(225,106,19);
color: #fff;
margin: 0;
font-size: 25px;
padding: 10px 0;
}
#loginBg  .loginContent {
padding: 20px 0;
}
#loginBg  input[type=text], input[type=password] {
height: 40px;
width: 80%;
border: #e5e5e5 solid 1px;
background: #fbfbfb;
box-shadow: 1px 1px 2px rgba(200, 200, 200, 0.2) inset;
padding: 0 5px;
margin: 5px 0;
}
#loginBg .button,#dialogBox .dialogClose {
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
text-indent:0;
}
#loginBg input.button {
margin: 10px auto;
}
#dialogBox {
  background: #fff;
  height: 450px;
  width: 70%;
  top: 50px;
  left: 15%;
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
#dialogBG, #floatingBarsGbg {
background: rgba(0, 0, 0, 0.7);
width: 100%;
height: 100%;
position: fixed;
top: 0;
z-index: 1000;
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

.ftleft {
  	float: left;
}
.actionbar-btn.ftright {
  float: right;
  margin-right:10px;
}
.admissionmode {
  line-height:10vh;
  margin-left:50px;
  witdh:auto;
  font-size:3vh;
  text-transform:uppercase;
}
/*------------------------------------------------ actionbar end ------------------------------------------------------*/
div#aptName {
	display: block;
	height: 32px;
}
.hidden {
  display: none;
}

div#search-bar {
	padding: 10px 0;
}
.hidden-to-remove {
  display: none !important;
}

.statusbar {
  position: absolute;
  top: 12.5vmin;
  left: 0px;
  right: 0px;
  height: 10.0vmin;
  margin: 0.8vmin;
  background: #efefef;
  border-radius: 1.8vmin;
  text-align: center;
  font-weight: bold;
  font-family: verdana,sans-serif;   
  background-image: -webkit-linear-gradient(top, #3c3c3c 0%, #282828 100%);
  border: 1px #000 solid;
  font-size: 4.0vmin;
  color: white;
  text-shadow: 0px -1px #000;
  box-shadow: 1px 1px 3px rgba(0,0,0,0.5);
}

.modal-glass {
  background-color: rgba(0,0,0,0.5);
  position: absolute;
  top: 0px;
  left: 0px;
  width: 100%;
  height: 100%;
}

.dialog {
  position: absolute;
  background-image: -webkit-linear-gradient(top, #708fb4 0%, #4c74a1 40px, #365a8e 100%);
  border-radius: 15px; 
  box-shadow: 0px 0px 20px rgba(0,0,0,0.6);
}

.dialog .dialog-title {
  padding: 10px;
  text-align: center;
  font-size: 20px;
  color: white;
  text-shadow: 0px -1px rgba(0,0,0,0.5);
}

.dialog .dialog-body {
  position: absolute;
  top: 40px;
  left: 0px;
  right: 0px;
  bottom: 0px;
  background-color: #f5f6f8;
  border: 1px white solid;
  margin: 6px;
  border-radius: 12px;
  padding: 12px;
  font-size: 20px;
}

.dialog .dialog-buttons {
  position: absolute;
  bottom: 0px;
  left: 0px;
  right: 0px;
  border-top: 1px #cecece solid;
  text-align: center;
  padding: 6px;
  margin: 6px 6px 0px 6px
}

.dialog .button {
  float: none;
  background-color: #d8d9db;
}

.back-btn {
  float: left;
}

ul.ios-list {
	list-style-type: none;
	margin: 0px;
	padding: 0px;
	border-bottom: 1px #b8babe solid;
	border-top: 1px #b8babe solid;
	background: #fff;
}

.ios-list-title {
  padding: 10px 24px;
  color: #474e67;
  font-weight: bold;
}
.ios-list .thumb {
    float: left;
    width: 80px;
    height: 80px;
    margin-left: -8px;
    margin-top: -8px;
    margin-right: 8px;
    background-size: 100%;
    background-position: center center;
    background-repeat: no-repeat;
  }
ul.ios-list li:first-child {
 
}

ul.ios-list li:last-child {
 
  border-bottom: none;
}

ul.ios-list li {
  /*background-color: #FFF;*/
  border-top: 1px white solid;
  border-bottom: 1px #cbcbcb solid;
  padding: 12px 24px 12px 24px;
  font-weight: bold;
  cursor: pointer;
}

ul.ios-list .caption {
  text-align: right;
  float: right;
  color: #39538a;
  font-weight: normal;
}
/*--------------------------------------------------------- tecnicmsg ----------------------------------------------*/
#tecnicmsg {
	z-index:999999;
	position:absolute;
	width:50vw;
	height:auto;
	background:#FFF;
	z-index:999999;
	position:absolute;
	margin:20vh 25vw;
	text-align:center;
	border:1px solid;
}
#tecnicmsgHeader {
	height: 5vh;
	min-height:40px;
	background-image: -webkit-linear-gradient(top, #bdcee1 0%, #87a5c7 50%, #7d9ec3 50%, #6a86a5 100%);
	border-top: 1px #dfe7f0 solid;
	border-bottom: 1px #4f647c solid;
	font-size: 3vmin;
	font-weight: bold;
	color: white;
	text-shadow: 0px -1px rgba(0,0,0,0.5);
	text-align: center;
	line-height: 5vh;
	margin-bottom:20px;
}
.tecnicmsgBtn {
	display: block;
	width:30%;
	margin: 30px 35%;
	color:#fff;
	padding:10px;
	height: 20px;
	cursor:pointer;
	background: #708DAE;
}
/*--------------------------------------------------------- alertMsg ----------------------------------------------*/
#alertmsgbg {
	width:100vw;
	height:100vh;
	background:rgba(0,0,0,0.4);
	z-index:999999;
	position:absolute;
}
#alertmsg {
	width:50vw;
	height:150px;
	background:#FFF;
	z-index:999999;
	position:absolute;
	margin:20vh 25vw;
	text-align:center;
	
}
#alertmsgHeader {
	height: 5vh;
	min-height:40px;
	background-image: -webkit-linear-gradient(top, #bdcee1 0%, #87a5c7 50%, #7d9ec3 50%, #6a86a5 100%);
	border-top: 1px #dfe7f0 solid;
	border-bottom: 1px #4f647c solid;
	font-size: 3vmin;
	font-weight: bold;
	color: white;
	text-shadow: 0px -1px rgba(0,0,0,0.5);
	text-align: center;
	line-height: 5vh;
}
#alertmsgBody {
	background:#FFF;
}
.alertmsgBtn {
	display: block;
	width:30%;
	margin-top:30px;
	color:#fff;
	padding:10px;
	height: 20px;
	cursor:pointer;
}
#alertmsgBtnCancel {
	float:left;
	margin-left:30px;
	background: #ccc;
}
#alertmsgBtnYes {
	float:right;
	margin-right:30px;
	background: #009933;
}
.admission span {
  width: 2vh;
  height: 2vh;
  display: block;
  position: absolute;
  background-size: 100%;
  bottom: 1vh;
  right: 1vh;
}

.disabled {
  opacity:0.5;
  pointer-events: none;
   cursor: default;
}
.img-keyboard {background-image: url(data:image/gif;base64,<%=JvImageCache.getMobileIcon("keyboard.png")%>);}
.img-undo {background-image: url(data:image/gif;base64,<%=JvImageCache.getMobileIcon("bkoact-back.png")%>);}
.img-accessctrl {background-image: url(data:image/gif;base64,<%=JvImageCache.getMobileIcon("accesscontrol.png")%>);}
.img-property {background-image: url(data:image/gif;base64,<%=JvImageCache.getMobileIcon("[font-awesome]info|CircleBlue")%>);}
.img-shutdown_black {background-image: url(data:image/gif;base64,<%=JvImageCache.getMobileIcon("shutdown_black.png")%>);}
.img-event {background-image: url(data:image/gif;base64,<%=JvImageCache.getMobileIcon(LkSNEntityType.Event.getIconName())%>);}
.img-people {background-image: url(data:image/gif;base64,<%=JvImageCache.getMobileIcon("account_prs.png")%>);}
.img-back {background-image: url(data:image/gif;base64,<%=JvImageCache.getMobileIcon("bkoact-back.png")%>);}
.img-close {background-image: url(data:image/gif;base64,<%=JvImageCache.getMobileIcon("no.png")%>);}
.img-camera {background-image: url(data:image/gif;base64,<%=JvImageCache.getMobileIcon("[font-awesome]camera", NvSubIcon.ColorizeRed)%>);}
.img-query {background-image: url(data:image/gif;base64,<%=JvImageCache.getMobileIcon("accesscontrol.png", NvSubIcon.ActionSearch)%>);}
.img-redeem {background-image: url(data:image/gif;base64,<%=JvImageCache.getMobileIcon("[font-awesome]exclamation", NvSubIcon.CircleRed)%>);}
.img-exit {background-image: url(data:image/gif;base64,<%=JvImageCache.getMobileIcon("accesscontrol.png", NvSubIcon.Exit)%>);}
.img-entry {background-image: url(data:image/gif;base64,<%=JvImageCache.getMobileIcon("accesscontrol.png", NvSubIcon.Entry)%>);}


/*----------------------------------------------- media queries ---------------------------------------------*/
 
@media screen and (max-height: 552px) {
	.toolbar {
		height:60px;	
		font-size: 5.0vmin;
	}
	div#adm-title {
		font-size: 26px;
		line-height: 60px;
	}
	.toolbar .access-point-name {
		font-size: 15px;
	}
	.actionbar {
		top: 90px;
	}
	.infobar {
		top: 60px;
	}
	.actionbar-btn {
		height: 48px;
		width: 48px;
	}
	#alertmsgHeader {
		height: 40px;
		font-size: 20px;
		line-height: 40px;
	}
}
 
</style>
