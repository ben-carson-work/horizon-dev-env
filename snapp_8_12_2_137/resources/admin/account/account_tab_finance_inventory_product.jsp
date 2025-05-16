<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.JvDataSet"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>

<v:page-form>

<div class="tab-toolbar">
  <v:pagebox gridId="inventory-product-grid"/>
</div>


<div class="tab-content">    
  <v:last-error/>
  <% String params = "AccountId=" + pageBase.getId();%>
  <v:async-grid id="inventory-product-grid" jsp="account/account_inventory_product_grid.jsp" params="<%=params%>" />
</div>

</v:page-form>