<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<v:page-form>

<div class="tab-toolbar">
  <% String hrefNew = ConfigTag.getValue("site_url") + "/admin?page=account&id=new&ParentAccountId=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Location.getCode(); %>
  <v:button caption="@Common.New" title="@Account.NewAccountHint" fa="plus" href="<%=hrefNew%>" enabled="<%=rights.SystemSetupLocations.getOverallCRUD().canCreate()%>"/>
  <v:button caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" onclick="showAccountDeleteDialog()" enabled="<%=rights.SystemSetupLocations.getOverallCRUD().canDelete()%>"/>
  <v:pagebox gridId="account-grid"/>
</div>

<div class="tab-content">    
  <v:last-error/>
  
  <% int[] entityTypes = {LkSNEntityType.Location.getCode()}; %>
  <% String params = "ParentAccountId=" + pageBase.getId() + "&EntityType=" + JvArray.arrayToString(entityTypes, ",");%>
  <v:async-grid id="account-grid" jsp="account/account_grid.jsp" params="<%=params%>"/>
</div>

</v:page-form>
