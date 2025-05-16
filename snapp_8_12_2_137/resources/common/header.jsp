<%@page import="com.vgs.snapp.jwt.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="java.net.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<!DOCTYPE html>
<html>
<% 
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); 
BOSessionBean boSession = (pageBase == null) ? null : (BOSessionBean)pageBase.getSession();
%>
<jsp:include page="header-head.jsp"/>


<% String sBodyClass = BLBO_DBInfo.isTestMode() ? "test-system" : ""; %>
<body class="<%=sBodyClass%>">

<input type="hidden" id="login-user-name" value="<%=JvString.escapeHtml(boSession.getUserName())%>" />
<input type="hidden" id="login-user-name-masked" value="<%=JvString.escapeHtml(pageBase.getDisplayUserName(boSession.getUserName()))%>" />

<div id="admintopbar" class="noselect">
  <%
  String station = boSession.getWorkstationName();
  if (pageBase.isVgsContext("B2B"))
    station = boSession.getOrgAccountName();
  String profilePictureId = pageBase.getBL(BLBO_Repository.class).findProfilePictureId(boSession.getUserAccountId());
  String profilepic = "";
  if (profilePictureId == null)
    profilepic = ImageCacheLinkTag.getLink("account_prs.png", 48);
  else
    profilepic = ConfigTag.getValue("site_url") + "/repository?type=thumb&id=" + profilePictureId;
  String userURL = pageBase.getContextURL() + "?page=" + (pageBase.isVgsContext("B2B") ? "user" : "account") + "&id=" + boSession.getUserAccountId();
  String htmlTimeZone = pageBase.getBrowserTimeZone().getHtmlDescription(pageBase.getLang());
  %>
  <div id="topmenu-test" class="topmenu-item float-left"><i class="fa fa-server"></i><span class="topmenu-caption"><%=JvString.escapeHtml(BLBO_DBInfo.getTestModeLabel())%></span></div>
  <div id="topmenu-station" class="topmenu-item float-left"><i class="fa fa-desktop"></i><span class="topmenu-caption"><%=JvString.escapeHtml(station)%></span></div>
  <div id="topmenu-timezone" class="topmenu-item float-left" title="<%=htmlTimeZone%>" onclick="asyncDialogEasy('../common/timezone_dialog')"><i class="fa fa-clock"></i><span class="topmenu-caption"><%=htmlTimeZone%></span></div>
  <div id="topmenu-user" class="topmenu-item float-right">
    <i class="fa fa-user"></i>
    <span class="topmenu-caption"><%=JvString.escapeHtml(boSession.getUserDesc())%></span>
    <div class="topmenu-content">
      <img id="topmenu-content-profilepic" src="<%=profilepic%>"/>
      <% if (rights.EditOwnProfile.getBoolean()) { %>
        <div class="topmenu-content-item"><a href="<%=userURL%>"><v:itl key="@Account.EditMyProfile"/></a></div>
      <% } %>
      <div class="topmenu-content-item"><a href="javascript:asyncDialogEasy('account/changepassword_dialog')"><v:itl key="@Common.ChangePassword"/></a></div>
      <div class="topmenu-content-item"><a href="javascript:doLogout()"><v:itl key="@Common.Logout"/></a></div>
    </div>
  </div>
  <div id="topmenu-msg" class="topmenu-item float-right"><jsp:include page="..\common\message\message_topmenu_header.jsp"/></div>
</div>
<script>
$(document).ready(function () {
  $(".topmenu-item").mouseenter(function() {
    $(this).find(".topmenu-content").position({
      my: "right top",
      at: "right bottom",
      of: this
    });
  });
});
</script>

<div id="notification-box"></div>

<div id="admincontainer">
  
<div id="adminnavbar" class="thin-scrollbar">
  <div id="side-menu" data-status="normal">
    <div class="side-menu-logo-container"><img class="side-menu-logo" src="<%=pageBase.getBL(BLBO_Account.class).getLicenseeLogoURL()%>"/></div>
    <div class="side-menu-search-normal noselect"><i class="fa fa-search"></i><v:itl key="@Common.Search"/></div>
    <div class="side-menu-search-focused btn-group">
	    <input type="text" class="side-menu-search-txt form-control dropdown-toggle" data-toggle="dropdown" placeholder="<v:itl key="@Common.Search"/>"/>
	  </div>
    <%=pageBase.getMenuHtml()%>
	</div>
  
  <a href="https://www.accesso.com/solutions/ticketing/ticketing-visitor-management" target="_new" class="snapp-info">
    Horizon by VGS &nbsp; <span style="white-space:nowrap"><v:config key="display-version"/></span><br/>
    &copy; 2011 &mdash; <%=JvDateTime.date().format("yyyy")%><br/>
    accesso Technology Group, plc
  </a>

</div>

<div id="templates" class="hidden">
  <div class="upload-item-template">
    <div class="upload-item">
      <div>
        <span class="txt-name"></span><span class="txt-size"></span>
      </div>
      <div class="progress"><div id="progress-bar" class="progress-bar" role="progressbar"></div></div>
    </div>
  </div>
  
  <ul>
    <li class="v-dyncombo-item v-dyncombo-item-simple"></li>
    <li class="v-dyncombo-item v-dyncombo-item-alt v-dyncombo-item-account">
      <div class="v-dyncombo-item-icon"><img width="32" height="32"/></div>
      <div class="v-dyncombo-item-detail">
        <div><span class="v-dyncombo-item-title v-dyncombo-account-name"></span><span class="v-dyncombo-item-subtitle v-dyncombo-account-code"></span></div>
        <div><span class="v-dyncombo-item-subtitle v-dyncombo-account-category"></span></div>
      </div>
    </li>
  </ul>
  
  <div class="async-process-dialog-template">
    <div class="progress"><div class="progress-bar progress-bar-info" role="progressbar"></div></div>
    <div><span class="qty-caption"><v:itl key="@Common.Total"/></span>:&nbsp;&nbsp;&nbsp;<b><span class="qtytot"></span></b></div>
    <div><span class="qty-caption"><v:itl key="@Common.Position"/></span>:&nbsp;&nbsp;&nbsp;<b><span class="qtypos"></span></b></div>
    <div><span class="qty-caption"><v:itl key="@Performance.Skipped"/></span>:&nbsp;&nbsp;&nbsp;<b><span class="qtyskip"></span></b></div>
  </div>
  
</div>


<div id="adminbody" data-pagestatus="<%=JvString.htmlEncode(JvUtils.coalesce(pageBase.getPageStatus(), NPageStatus.NORMAL).name())%>">


<%-- This IF-BLOCK is supposed to always fail. Just a workaround to resolve warning. --%>
<% if (request.getAttribute("BB63A701FB6F4C04B70C44E3CB161795") != null) { %>
</div>
</div>
<% } %>
