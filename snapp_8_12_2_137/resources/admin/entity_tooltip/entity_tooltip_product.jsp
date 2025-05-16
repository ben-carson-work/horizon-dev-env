<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Product.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTooltip" scope="request"/>

<%

QueryDef qdef = new QueryDef(QryBO_Product.class);
// Select
qdef.addSelect(Sel.ProductId);
qdef.addSelect(Sel.ProductCode);
qdef.addSelect(Sel.ProductName);
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.ProfilePictureId);
qdef.addSelect(Sel.CategoryRecursiveName);
// Filter
qdef.addFilter(Fil.ProductId, pageBase.getParameter("EntityId"));
// Exec
JvDataSet ds = pageBase.execQuery(qdef);

LookupItem entityType = LkSNEntityType.ProductType;
%>

<div class="entity-tooltip-baloon">

<% if (ds.getField(Sel.ProfilePictureId).isNull()) { %>
  <div class="profile-pic-icon" style="background-image:url('<v:image-link name="<%=ds.getField(Sel.IconName).getHtmlString()%>" size="48"/>')"></div>
<% } else { %>
  <div class="profile-pic-img" style="background-image:url('<v:config key="site_url"/>/repository?type=small&id=<%=ds.getField(Sel.ProfilePictureId).getHtmlString()%>')"></div>
<% } %>

<div class="content">

  <div class="entity-name"><a href="<v:config key="site_url"/>/admin?page=account&id=<%=ds.getField(Sel.ProductId).getHtmlString()%>">[<%=ds.getField(Sel.ProductCode).getHtmlString()%>] <%=ds.getField(Sel.ProductName).getHtmlString()%></a></div>
  
  <div class="entity-type"><%=entityType.getHtmlDescription(pageBase.getLang())%></div>
  
  <div class="entity-cat"><%=ds.getField(Sel.CategoryRecursiveName).getHtmlString()%></div>

</div>

</div>