<%@page import="com.vgs.snapp.web.search.BLBO_QueryRef_Portfolio"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
DOPortfolioRef portfolioRef = pageBase.getBL(BLBO_QueryRef_Portfolio.class).loadItem(pageBase.getParameter("PortfolioId"));
request.setAttribute("portfolio", portfolioRef);

String ticketId = pageBase.getNullParameter("TicketId");
%>

<v:dialog id="portfolio-binded-product-wallet-reward-dialog" title="@Portfolio.BindedWalletRewardPoints" width="512" height="200">
	<v:widget>
	  <%request.setAttribute("TicketId", pageBase.getNullParameter("TicketId"));%>
    <jsp:include page="portfolio_binded_product_wallet_reward_widget.jsp"/>
	</v:widget>  
</v:dialog>