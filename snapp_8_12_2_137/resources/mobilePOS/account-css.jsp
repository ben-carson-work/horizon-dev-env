<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<style id="account-css.jsp">
/*
#registrationContainer {
	width: 100%;
	height: 100%;
	background: rgb(0,133,155);
	position: fixed;
}
*/
div#registrationContent {
  background: #fff;
  width: 100%;
  /*border-radius: 20px;

  margin: 5% 10%;*/
}
#accountForm,#existAccountFormFields {
  padding: 75px 20px;
  }
  #accountForm {
    padding-top: 110px;
  }
.fieldlabel { 
  width: 100%;
  display: block;
  float:left;
  padding: 0;
  font-size:16px;
}
input[type='radio'], 
input[type='checkbox'] {
  margin: 15px 15px 15px 35px;
  transform: scale(3, 3); 
  -moz-transform: scale(3, 3); 
  -ms-transform: scale(3, 3); 
  -webkit-transform: scale(3, 3); 
  -o-transform: scale(3, 3); 
}
#selectCategory .button {
margin:0;
font-size:12px;
}
#accountForm input[type=text],#existAccountForm input[type=text],#accountForm input[type=number],#existAccountForm input[type=number]{
	height: 40px;
	width: 100%;
	border: #e5e5e5 solid 1px;
	background: #fbfbfb;
	box-shadow: 1px 1px 2px rgba(200, 200, 200, 0.2) inset;
	padding: 0 5px;
	margin: 5px 0;
}
select {
	height: 40px;
	width: 100%;
	border: #e5e5e5 solid 1px;
	background: #fbfbfb;
	box-shadow: 1px 1px 2px rgba(200, 200, 200, 0.2) inset;
	padding: 0 5px;
	margin: 5px 0;
	font-family: arial;
  font-size: 13px;
}
#existAccountForm {
  position: fixed;
  width: 100%;
  top: 0;
  background: rgba(0,0,0,0.8);
  left: 0;
  bottom: 0;
  overflow:scroll;
  z-index: 3;
}
.accountscontainer {
  width: 4000px;
}
.accountForm {
  margin-bottom:150px;
}
#existingAccounts {
 overflow: scroll;

width: 100%;
margin-top: -25px;
padding: 1px 0;
left: 0;
min-height:50px;
background:#AFC2C5;
color:#fff;
z-index: 2;
}
#saveAccount .button {
width: 100%;
}
span.existingaccount {
  padding: 10px;
  float: left;
  font-weight: bold;
  display: block;
   font-size:14px;
  cursor:pointer;
  width:30vw;
  border-right: 1px solid #fff;
}
span.existingaccount .category {
  color:#fff;
  font-size: 11px
}
form#existSaveAccount {
  background: #fff;
  width: 90%;
  margin-left: 10%;
  margin-top: 0%;
  padding: 0 0 20px 0;
}
#existAccountForm {
position: fixed;
}
#existAccountForm #buttons {
width: 100%;
margin: 0 0%;
background: #fff;
padding: 10px 20px;

}
#existAccountForm #buttons .button {
  margin: 10px 10px;
  float:left;
}
#existAccountForm #buttons .button.back {
  background-image: none;
}
#saveAccount,#existAccountForm {
  font-size: 13px;
}
.ProfilePictureId {
  border: 1px solid #ccc;
  width: 164px;
  float: right;
  border-radius:10px;
}
</style>
