<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccountList" scope="request"/>

<v:page-form>

<div class="tab-toolbar">
  <% 
    String hrefNew = pageBase.getContextURL() + "?page=account&id=new&EntityType=" + pageBase.getEmptyParameter("EntityType");
    if (pageBase.hasParameter("ParentAccountId"))
      hrefNew += "&ParentAccountId=" + pageBase.getParameter("ParentAccountId");
  %>
  <div class="btn-group">
    <v:button caption="@Common.New" title="@Account.NewAccountHint" fa="plus" href="<%=hrefNew%>"/>
    <v:button caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" onclick="showAccountDeleteDialog()" />
  </div>
  <v:pagebox gridId="account-grid"/>
</div>

<div class="tab-content">    
  <v:last-error/>
  
  <% String params = "EntityType=" + pageBase.getParameter("EntityType") + "&ParentAccountId=" + pageBase.getParameter("ParentAccountId"); %>
  <v:async-grid id="account-grid" jsp="account/account_grid.jsp" params="<%=params%>"/>
</div>

</v:page-form>
