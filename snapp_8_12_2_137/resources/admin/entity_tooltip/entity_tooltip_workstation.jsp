<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Workstation.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTooltip" scope="request"/>

<%

QueryDef qdef = new QueryDef(QryBO_Workstation.class);
// Select
qdef.addSelect(Sel.WorkstationId);
qdef.addSelect(Sel.WorkstationCode);
qdef.addSelect(Sel.WorkstationName);
qdef.addSelect(Sel.WorkstationType);
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.CategoryRecursiveName);
qdef.addSelect(Sel.OpAreaAccountId);
qdef.addSelect(Sel.OpAreaDisplayName);
qdef.addSelect(Sel.LocationAccountId);
qdef.addSelect(Sel.LocationDisplayName);
// Filter
qdef.addFilter(Fil.WorkstationId, pageBase.getParameter("EntityId"));
// Exec
JvDataSet ds = pageBase.execQuery(qdef);

LookupItem wksType = LkSN.WorkstationType.getItemByCode(ds.getField(Sel.WorkstationType));
%>

<div class="entity-tooltip-baloon">

<div class="profile-pic-icon" style="background-image:url('<v:image-link name="<%=ds.getField(Sel.IconName).getHtmlString()%>" size="48"/>')"></div>

<div class="content">

  <div class="entity-name"><a href="<v:config key="site_url"/>/admin?page=workstation&id=<%=ds.getField(Sel.WorkstationId).getHtmlString()%>">[<%=ds.getField(Sel.WorkstationCode).getHtmlString()%>] <%=ds.getField(Sel.WorkstationName).getHtmlString()%></a></div>
  
  <div class="entity-type"><%=wksType.getHtmlDescription(pageBase.getLang())%></div>
  
  <div class="entity-cat">
    <% if (!ds.getField(Sel.CategoryRecursiveName).isNull()) { %>
      <%=ds.getField(Sel.CategoryRecursiveName).getHtmlString()%><br/>
    <% } %>
    
    <v:itl key="@Account.Location"/>: <a href="<v:config key="site_url"/>/admin?page=account&id=<%=ds.getField(Sel.LocationAccountId).getHtmlString()%>"><%=ds.getField(Sel.LocationDisplayName).getHtmlString()%></a><br/>
    <v:itl key="@Account.OpArea"/>: <a href="<v:config key="site_url"/>/admin?page=account&id=<%=ds.getField(Sel.OpAreaAccountId).getHtmlString()%>"><%=ds.getField(Sel.OpAreaDisplayName).getHtmlString()%></a>
  </div>

</div>

</div>