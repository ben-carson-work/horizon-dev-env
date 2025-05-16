<%@page import="com.vgs.snapp.web.b2c.page.*"%>
<%@page import="com.vgs.snapp.web.b2c.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% PageB2C_Base<?> pageBase = (PageB2C_Base<?>)request.getAttribute("pageBase");%> 

<jsp:include page="<%=pageBase.getFragmentInclude(PageB2C_Base.FRAGMENT_Header)%>"></jsp:include>

<jsp:include page="<%=pageBase.getFragmentInclude(PageB2C_Base.FRAGMENT_CatalogNode)%>">
  <jsp:param  name="RootCatalogId" value="3FC632FC-930E-42BF-B185-2E32D33A313F"/>
  <jsp:param  name="ParentCatalogId" value="3FC632FC-930E-42BF-B185-2E32D33A313F"/>
</jsp:include>

<jsp:include page="<%=pageBase.getFragmentInclude(PageB2C_Base.FRAGMENT_Footer)%>"></jsp:include>
