<%@page import="com.vgs.snapp.web.common.library.EntityLinkManager"%>
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
<%
String ticketId = ticket.TicketId.getString();
DOPortfolioRef portfolioRef = ticket.MainPortfolio.isEmpty() ? ticket.Portfolio : ticket.MainPortfolio;
request.setAttribute("portfolio", portfolioRef);

if (ticket.BindWalletRewardToProduct.getBoolean())
  request.setAttribute("TicketId", ticketId);
%>

<v:widget caption="@Common.Portfolio">
  <jsp:include page="portfolio_accountwallet_widget.jsp"/>
  
  <% if (ticket.Portfolio.MediaCount.getInt() > 0) { %>
    <v:widget-block clazz="group"><v:itl key="@Common.Medias"/></v:widget-block>
    
    <v:widget-block>
      <v:icon-pane iconName="<%=ticket.Portfolio.MainMediaIconName.getString()%>">
        <div class="list-title">
          <snp:entity-link entityId="<%=ticket.Portfolio.MainMediaId%>" entityType="<%=LkSNEntityType.Media%>"><%=ticket.Portfolio.MainMediaCalcCode.getHtmlString()%></snp:entity-link>
        </div>
        <div class="list-subtitle"><%=ticket.Portfolio.MainMediaCodes.getHtmlString()%></div>
      </v:icon-pane>
    </v:widget-block>
  
    <% if (ticket.Portfolio.MediaCount.getInt() > 1) { %>
      <% String href = EntityLinkManager.instance().getLink(pageBase.isVgsContext("B2B"), LkSNEntityType.Ticket, ticketId) + "&tab=pfmedia&portfolioid=" + ticket.PortfolioId.getHtmlString(); %>
      <v:widget-block include="<%=ticket.Portfolio.MediaCount.getInt() > 1%>">
        <div style=text-align:center><a href="<%=href%>"><v:itl key="@Common.FullList" param1="<%=ticket.Portfolio.MediaCount.getString()%>"/></a></div>
      </v:widget-block>
    <% } %>
  
  <% } %>
</v:widget>


