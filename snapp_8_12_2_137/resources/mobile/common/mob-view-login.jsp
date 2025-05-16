<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.web.mob.page.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="lic" class="com.vgs.snapp.dataobject.DOLicense" scope="request"/>

<jsp:include page="mob-view-login-css.jsp"/>

<div id="login-title"><div id="login-logo"></div></div>
<div id="login-box">
  <div class="login-item"><input type="text" id="txt-username" placeholder="<v:itl key="@Common.UserName"/>" autocomplete="off" /></div>
  <div class="login-item"><input type="password" id="txt-password" placeholder="<v:itl key="@Common.Password"/>"/></div>
  <div class="login-item">
    <div id="login-error" class="hidden"></div>
    <div id="login-spinner" class="hidden"></div>
    <div id="btn-login"><v:itl key="@Common.Login"/></div>
  </div>
</div>
