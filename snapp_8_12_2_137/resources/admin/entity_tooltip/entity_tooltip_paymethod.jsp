<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Plugin.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTooltip" scope="request"/>

<%

QueryDef qdef = new QueryDef(QryBO_Plugin.class);
// Select
qdef.addSelect(Sel.PluginId);
qdef.addSelect(Sel.PluginDisplayName);
qdef.addSelect(Sel.IconName);
// Filter
qdef.addFilter(Fil.PluginId, pageBase.getParameter("EntityId"));
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
%>

<div class="entity-tooltip-baloon">

<div class="profile-pic-icon" style="background-image:url('<v:image-link name="<%=ds.getField(Sel.IconName).getHtmlString()%>" size="48"/>')"></div>

<div class="content">

  <div class="entity-name"><a href="<v:config key="site_url"/>/admin?page=paymethod&id=<%=ds.getField(Sel.PluginId).getHtmlString()%>"><%=ds.getField(Sel.PluginDisplayName).getHtmlString()%></a></div>
  
  <div class="entity-type"><%=LkSNEntityType.PaymentMethod.getHtmlDescription(pageBase.getLang())%></div>

</div>

</div>