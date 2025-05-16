<%@page import="com.vgs.snapp.web.search.BLBO_QueryRef_Portfolio"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.search.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_PortfolioSlotLog.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
String portfolioId = pageBase.getParameter("PortfolioId");
String ticketId = pageBase.getNullParameter("TicketId");

DOPortfolioRef portfolioRef = pageBase.getBL(BLBO_QueryRef_Portfolio.class).loadItem(portfolioId);
request.setAttribute("portfolioBalanceRef", portfolioRef.PortfolioBalanceRef);

pageBase.setDefaultParameter("Binded", ticketId != null ? "true" : "false");
%>

<v:dialog id="portfolio-wallet-recap-dialog" icon="wallet.png" tabsView="true" title="@Common.Portfolio" width="1024" height="768" autofocus="false">

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-balance" caption="@Balance" default="true">
    <jsp:include page="portfolio_wallet_recap_tab_balance.jsp"/>
  </v:tab-item-embedded>
  <v:tab-item-embedded tab="tabs-transaction" caption="@Transaction">
    <jsp:include page="portfolio_wallet_recap_tab_transaction_list.jsp"><jsp:param name="PortfolioId" value="<%=portfolioId%>"/></jsp:include>
  </v:tab-item-embedded>
</v:tab-group>

<script>
$(document).ready(function() {
  var $dlg = $("#portfolio-wallet-recap-dialog");
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      dialogButton("@Common.Close", doCloseDialog)
    ]
  });
});
</script>

</v:dialog>