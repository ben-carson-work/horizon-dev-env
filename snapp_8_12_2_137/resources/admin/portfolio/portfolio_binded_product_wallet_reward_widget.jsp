<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="java.util.List"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="portfolio" class="com.vgs.snapp.dataobject.DOPortfolioRef" scope="request"/>

<%
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");
String ticketId = JvString.getNull((String)request.getAttribute("TicketId"));
%>


<%
if (!portfolio.PortfolioBalanceRef.getBindedDetailedBalanceList(ticketId).isEmpty()) {
%>
	<v:widget-block clazz="group">
	  <v:itl key="@Portfolio.BindedWalletRewardPoints"/>
	</v:widget-block>
	
	<v:widget-block>
	  <v:icon-pane iconName="ticket-new.png">
	    
	    <v:recap-item caption="@Common.Balance" include="<%=portfolio.PortfolioBalanceRef.showGenericBalanceMessage()%>">
	      <%=pageBase.formatCurrHtml(0)%>
      </v:recap-item>
      
      <% if (!portfolio.PortfolioBalanceRef.showGenericBalanceMessage()) { %>
        <% boolean showBalanceCaption = true; %>
        <% for (DOPortfolioBalanceRefItem balanceRefItem : portfolio.PortfolioBalanceRef.getBindedBalanceListWithMoney(ticketId)) { %>
          <% String balanceCaption = showBalanceCaption ? pageBase.getLang().Common.Balance.getHtmlText() : "";%>
          <v:recap-item caption="<%=balanceCaption%>"><%=balanceRefItem.getBalanceMoneyDescription(pageBase.getCurrFormatter())%></v:recap-item>
          <% showBalanceCaption = false; %>
        <% } %>
      <% } %>
    
      <v:recap-item>
        <% String params = "PortfolioId=" + portfolio.PortfolioId.getHtmlString() + "&TicketId=" + ticketId; %>
        <a href="javascript:asyncDialogEasy('portfolio/portfolio_wallet_recap_dialog', '<%=params%>')" style="float: right"><v:itl key="@Common.Details" /></a>
      </v:recap-item>
	    
	  </v:icon-pane>
	</v:widget-block>
<% } %>