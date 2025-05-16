<%@page import="com.vgs.snapp.web.search.*"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.web.servlet.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTicket" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="ticket" class="com.vgs.snapp.dataobject.DOTicket" scope="request"/>

<% String financeStyle = ticket.TicketStatus.getInt() > LkSNTicketStatus.GoodTicketLimit ? "text-decoration:line-through" : ""; %>
<v:widget caption="@Product.RevenueDetails" include="<%=!ticket.RevenueBreakdownList.isEmpty()%>">
<% for (DOTicket.DOTicketRevenue item : ticket.RevenueBreakdownList) { %>
  <v:widget-block>
    <snp:entity-link entityId="<%=item.GateCategoryId%>" entityType="<%=LkSNEntityType.GateCategory%>"><%=item.GateCategoryName.getHtmlString()%></snp:entity-link>
    <% if (item.ProductVPT.getMoney() != 0) { %>
      <span style="<%=financeStyle%>" class="recap-value">VPT <%=item.ProductVPT.getHtmlString()%></span>
    <% } %>
    
    <v:recap-item caption="@Ledger.ClearingAllocatedLimit" valueStyle="<%=financeStyle%>">
      <a href="javascript:showLedgerAllocatedDialog('<%=item.GateCategoryId.getHtmlString()%>')"><%=pageBase.formatCurrHtml(item.ClearingAllocated)%></a>
      /
      <%=pageBase.formatCurrHtml(item.ClearingLimit)%>
    </v:recap-item>
  </v:widget-block>
<% } %>
</v:widget>
