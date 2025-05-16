<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.web.search.*"%>
<%@page import="com.vgs.snapp.web.query.*"%>
<%@page import="java.util.*"%>
<%@page import="java.util.stream.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.web.servlet.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="portfolioBalanceRef" class="com.vgs.snapp.dataobject.DOPortfolioBalanceRef" scope="request"/>

<%
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");
boolean binded = JvString.isSameString(pageBase.getEmptyParameter("Binded"), "true");  

List<DOPortfolioBalanceRefItem> balanceRefRecapList = new ArrayList<>();
List<DOPortfolioBalanceRefItem> balanceRefDetailedList = new ArrayList<>();
if (binded) {
  balanceRefRecapList.addAll(portfolioBalanceRef.getBindedRecapPortfolioBalanceList());
  balanceRefDetailedList.addAll(portfolioBalanceRef.getBindedDetailedPortfolioBalanceList());
}
else {
  balanceRefRecapList.addAll(portfolioBalanceRef.getUnbindedRecapPortfolioBalanceList());
  balanceRefDetailedList.addAll(portfolioBalanceRef.getUnbindedDetailedPortfolioBalanceList());
}


%>

<style>
	.widget-block a {
	    visibility: hidden;
	}
	
	.widget-block:hover a {
	    visibility: visible;
	}
</style>

<v:tab-content>
  <v:widget caption="@Common.Wallet" include="<%=balanceRefRecapList.size() == 0%>">
    <v:widget-block>
      <v:recap-item caption="@Common.Balance"><%=pageBase.formatCurrHtml(0)%></v:recap-item>
    </v:widget-block>
  </v:widget>


  <% for (DOPortfolioBalanceRefItem balanceRefItemGrouped : balanceRefRecapList) { %>
    <v:widget caption="<%=balanceRefItemGrouped.MembershipPointName.getHtmlString()%>">
      <v:widget-block>
        <v:recap-item caption="@Common.Balance"><%=balanceRefItemGrouped.getBalanceMoneyDescriptionHtmlSimple(pageBase.getCurrFormatter())%></v:recap-item>
      </v:widget-block>

      <v:widget-block>
      <% boolean showExpirationCaption = true;%>
      <% for (DOPortfolioBalanceRefItem balanceRefItem : balanceRefDetailedList.stream().filter(it -> it.MembershipPointId.isSameString(balanceRefItemGrouped.MembershipPointId.getString())).collect(Collectors.toList())) { %>
        <% String expirationCaption = showExpirationCaption ? pageBase.getLang().Common.Expiration.getHtmlText() : "";%>
        <v:recap-item caption="<%=expirationCaption%>">
         <% if (balanceRefItem.canChangeExpiration(pageBase.getRights())) {%>
           <a href="javascript:portfolioExpirationChange('<%=balanceRefItem.getExpirationChangeParameters()%>', <%=balanceRefItem.showWarnOnExpirationChange(pageBase.getRights())%>)"><%=pageBase.getLang().Portfolio.Edit.getHtmlText()%></a>
         <% } %>
         <%=balanceRefItem.getFormattedHtmlExpirationAndDescription(pageBase.getShortDateFormat(), pageBase.getLang(), pageBase.getCurrFormatter(), balanceRefDetailedList)%>
        </v:recap-item>
        <% showExpirationCaption = false; %>
      <% } %>
      </span>
      </v:widget-block>
    </v:widget>
  <% } %>
</v:tab-content>

<script>
function portfolioExpirationChange(params, showWarn) {
  if (showWarn) {
    confirmDialog(itl("@Portfolio.ExpirationChangeWarning"), function() {
      asyncDialogEasy('portfolio/portfolioslot_change_expiration_dialog', params);
    });
  }
  else 
    asyncDialogEasy('portfolio/portfolioslot_change_expiration_dialog', params);
}
</script>