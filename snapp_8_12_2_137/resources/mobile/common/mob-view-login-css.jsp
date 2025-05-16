<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.web.mob.page.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="lic" class="com.vgs.snapp.dataobject.DOLicense" scope="request"/>
<%
PageMOB_Base<?> pageBase = (PageMOB_Base<?>)request.getAttribute("pageBase");
String profilePictureId = null;
if (!BLBO_DBInfo.isDatabaseEmpty() && !BLBO_DBInfo.isDatabaseUpdateNeeded()) 
  profilePictureId = pageBase.getBL(BLBO_Repository.class).findProfilePictureId(BLBO_DBInfo.getMasterAccountId());
%>

<style>

body[data-page='login'] {
  background-color: var(--pagetitle-bg-color);
}

#login-title {
  margin-top: 6vw;
  margin-bottom: 3vw;
}

#login-logo {
  width: 35vw;
  height: 35vw;
  margin: auto;
  border-radius: 3vw;
  box-shadow: 0 0 1.5vh rgba(0,0,0,0.2);
  background-color: white;
  background-size: cover;
  <% if (profilePictureId == null) { %>
    background-image: url(<v:image-link name="snapp-icon-round.png" size="128"/>);
  <% } else { %>
    background-image: url(<v:config key="site_url"/>/repository?type=small&id=<%=profilePictureId%>);
  <% } %>
}

#login-box {
  padding: 1.5vw;
  font-size: 6vw;
}

#login-box .login-item {
  padding: 1.5vw;
}

#login-box input {
  width: 100%;
  margin: 0;
  border: none;
  border-radius: 1.5vw;
  padding: 2vw;
}

#login-box input[disabled='disabled'] {
  background-color: white;
  opacity: 0.5;
}

#btn-login {
  background-color: var(--highlight-color);
  padding: 2vw;
  font-size: 6.75vw;
  text-align: center;
  border-radius: 1.5vw;
  color: white;
  text-shadow: 0 0 1.5vw rgba(0,0,0,0.2);
  cursor: pointer;
}

#login-error {
  color: var(--base-red-color);
  text-align: center;
  padding: 1.5vw;
}

</style>
