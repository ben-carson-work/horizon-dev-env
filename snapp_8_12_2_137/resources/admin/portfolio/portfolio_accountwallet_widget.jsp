<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.library.*"%>
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

boolean showAccountName = !JvString.isSameString(JvString.getEmpty((String)request.getAttribute("show-account-name")), "false");
String ticketId = JvString.getNull((String)request.getAttribute("TicketId"));
String mediaPortfolioId= pageBase.getNullParameter("MediaPortfolioId");
%>

<v:widget-block include="<%=showAccountName%>">
  <% if (portfolio.AccountId.isNull()) { %>
    <v:itl key="@Account.AnonymousAccount"/>
  <% } else { %>
    <v:icon-pane iconName="<%=portfolio.AccountIconName.getString()%>" repositoryId="<%=portfolio.AccountProfilePictureId.getString()%>">
      <snp:entity-link entityId="<%=portfolio.AccountId%>" entityType="<%=portfolio.AccountEntityType%>" clazz="list-title">
        <%=portfolio.AccountName.getHtmlString()%>
      </snp:entity-link>
      <div class="list-subtitle">
        <%=portfolio.AccountCategoryNames.getHtmlString()%>
      </div>
    </v:icon-pane>
  <% } %>
</v:widget-block>

<v:widget-block include="<%=ticketId == null%>">  
  <v:icon-pane iconName="wallet.png">
    
    <v:recap-item caption="@Common.Balance" include="<%=portfolio.PortfolioBalanceRef.showGenericBalanceMessage()%>">
      <%=pageBase.formatCurrHtml(0)%>
    </v:recap-item>

    <%
    if (!portfolio.PortfolioBalanceRef.showGenericBalanceMessage()) {
    %>
	    <% boolean showBalanceCaption = true;%>
	    <% for (DOPortfolioBalanceRefItem balanceRefItem : portfolio.PortfolioBalanceRef.getUnbindedBalanceListWithMoney()) { %>
	      <% String balanceCaption = showBalanceCaption ? pageBase.getLang().Common.Balance.getHtmlText() : "";%>
	      <v:recap-item caption="<%=balanceCaption%>"><%=balanceRefItem.getBalanceMoneyDescription(pageBase.getCurrFormatter())%></v:recap-item>
	      <% showBalanceCaption = false; %>
	    <% }; %>
	
	    <v:recap-item caption="@Portfolio.BindedWalletRewardPoints" include="<%=!portfolio.PortfolioBalanceRef.getBindedRecapPortfolioBalanceList().isEmpty()%>">
	      <%=pageBase.formatCurrHtml(portfolio.PortfolioBalanceRef.getTotalBindedWalletAmount(mediaPortfolioId))%>  
	    </v:recap-item>
    <% } %>
    	
    <v:recap-item caption="@Common.CreditLimit"><%=pageBase.formatCurrHtml(portfolio.WalletCreditLimit)%></v:recap-item>

    <v:recap-item include="<%=portfolio.HasPortfolioBalanceDetails.getBoolean()%>">
      <% String params = "PortfolioId=" + portfolio.PortfolioId.getHtmlString(); %>
      <a
        href="javascript:asyncDialogEasy('portfolio/portfolio_wallet_recap_dialog', '<%=params%>')"
        style="float: right"><v:itl key="@Common.Details" /></a>
    </v:recap-item>

  </v:icon-pane>
</v:widget-block>

<% if (ticketId != null) { %>
  <jsp:include page="portfolio_binded_product_wallet_reward_widget.jsp"/>
<% } %>

