<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.service.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<v:dialog id="itemaccount_dialog" title="@Account.Accounts" width="900" height="700" resizable="false">

  <div class="body-block">
	  <ul class="tab-button-list"></ul>
	  <div class="tab-content"></div>
	</div>
  
  <div class="toolbar-block">
    <div id="btn-itemaccount-copy" class="v-button btn-float-left"><v:itl key="@Common.Copy"/></div>
    <div id="btn-itemaccount-next" class="v-button btn-float-right hl-green"><v:itl key="@Common.Next"/></div>
    <div id="btn-itemaccount-back" class="v-button btn-float-right hl-green"><v:itl key="@Common.Back"/></div>
  </div>
  
  <div id="itemaccount-li-template" class="v-hidden">
	  <li class="tab-button noselect">
      <div class="tab-button-icon"><i class="ok-icon fa fa-check-circle"></i><i class="warn-icon fa fa-exclamation-circle"></i></div>
      <div class="tab-button-account">Guest</div>
	    <div class="tab-button-product"></div>
	  </li>
  </div>

  <jsp:include page="itemaccount_dialog_css.jsp"/>
  <jsp:include page="itemaccount_dialog_js.jsp"/>

</v:dialog>