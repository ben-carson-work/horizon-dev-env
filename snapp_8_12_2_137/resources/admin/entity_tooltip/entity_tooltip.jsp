<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>


<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTooltip" scope="request"/>

<% String entityTypeCode = pageBase.getParameter("EntityType"); %>
<% LookupItem entityType = LkSN.EntityType.findItemByCode(entityTypeCode); %>
<% if (entityType == null) { %> 
  Unable to find entity type "<%=entityTypeCode%>"
<% } else if (entityType.isLookup(LkSNEntityType.getAccountEntityTypes())) { %>
  <jsp:include page="entity_tooltip_account.jsp"/> 
<% } else if (entityType.isLookup(LkSNEntityType.ProductType)) { %>
  <jsp:include page="entity_tooltip_product.jsp"/> 
<% } else if (entityType.isLookup(LkSNEntityType.Workstation)) { %>
  <jsp:include page="entity_tooltip_workstation.jsp"/> 
<% } else if (entityType.isLookup(LkSNEntityType.PaymentMethod)) { %>
  <jsp:include page="entity_tooltip_paymethod.jsp"/> 
<% } else if (entityType.isLookup(LkSNEntityType.Transaction)) { %>
  <jsp:include page="entity_tooltip_transaction.jsp"/> 
<% } else if (entityType.isLookup(LkSNEntityType.Ticket)) { %>
  <jsp:include page="entity_tooltip_ticket.jsp"/> 
<% } else { %>
  Unhandled entity type: [<%=entityTypeCode%>] <%=entityType.getHtmlDescription(pageBase.getLang())%>
<% } %>
