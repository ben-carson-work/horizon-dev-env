<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<% PageCategoryList pageBase = (PageCategoryList)request.getAttribute("pageBase"); %>

<jsp:include page="../common/header.jsp"/>

<v:page-title-box/>

  <% String entityTypeParam = "EntityType=" + pageBase.getParameter("EntityType"); %>
  <v:tab-group name="tab" main="true">
    <v:tab-item caption="@Category.Categories" icon="category.png" tab="cat" jsp="categories_tab_cat.jsp" default="true"/>
  </v:tab-group>
 
<jsp:include page="../common/footer.jsp"/>
