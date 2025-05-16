<%@page import="com.vgs.snapp.web.search.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTooltip" scope="request"/>

<% 
LookupItem entityType = LkSNEntityType.Ticket;
String ticketId = pageBase.getParameter("EntityId");

DOTicketRef ticket = pageBase.getBL(BLBO_QueryRef_Ticket.class).loadItem(ticketId);

String statusColorHex = LkCommonStatus.findColorHex(ticket.CommonStatus.getLkValue());

%>

<div class="entity-tooltip-baloon">

  <div class="profile-pic-icon" style="background-image:url('<v:image-link name="<%=ticket.IconName.getString()%>" size="48"/>')"></div>
  
  <div class="content">

    <div class="entity-name"><snp:entity-link entityType="<%=entityType%>" entityId="<%=ticketId%>" entityTooltip="false"><%=ticket.TicketCode.getHtmlString()%></snp:entity-link></div>
    
    <div style="font-weight:bold; color:<%=statusColorHex%>"><%=ticket.TicketStatus.getHtmlLookupDesc(pageBase.getLang())%></div>
  
    <div class="recap-value-item">&nbsp;</div>
    
    <div class="recap-value-item">
      <v:itl key="@Product.ProductType"/>
      <span class="recap-value"><%=ticket.ProductCode.getHtmlString()%></span>
    </div>
    <div class="recap-value-item">
      &nbsp;
      <span class="recap-value"><%=ticket.ProductName.getHtmlString()%></span>
    </div>
    
    <div class="recap-value-item">
      <v:itl key="@Product.Price"/>
      <span class="recap-value">
        <% if (ticket.GroupQuantity.getInt() > 1) { %> <%=ticket.GroupQuantity.getInt()%> x <% } %>
        <%=pageBase.formatCurrHtml(ticket.UnitAmount)%>
      </span>
    </div>
  
  <%-- 
    <div class="entity-name"><a href="<v:config key="site_url"/>/admin?page=account&id=<%=ds.getField(Sel.ProductId).getHtmlString()%>">[<%=ds.getField(Sel.ProductCode).getHtmlString()%>] <%=ds.getField(Sel.ProductName).getHtmlString()%></a></div>
    
    <div class="entity-type"><%=entityType.getHtmlDescription(pageBase.getLang())%></div>
    
    <div class="entity-cat"><%=ds.getField(Sel.CategoryRecursiveName).getHtmlString()%></div>
  --%>
  
  </div>

</div>