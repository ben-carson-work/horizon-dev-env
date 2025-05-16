<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PagePayMethod" scope="request"/>
<jsp:useBean id="pay" class="com.vgs.snapp.dataobject.DOPaymentMethod" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% boolean canEdit = true; %>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<div id="main-container">
  <v:tab-group name="tab" id="main-tab-group" main="true">
    <v:tab-item caption="@Common.Recap" icon="profile.png" jsp="paymethod_tab_main.jsp" tab="main" default="true"/>

    <%-- LEDGER RULE --%>
    <% if ((pay.LedgerRuleCount.getInt() > 0) || pageBase.isTab("tab", "ledgerrule")) { %>
      <% String jsp_ledgerrule = "/admin?page=ledgerrule_tab_widget&EntityId=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.PaymentMethod.getCode() + "&readonly=" + !canEdit; %>
      <v:tab-item caption="@Ledger.LedgerRules" icon="ledgerrule.png" tab="ledgerrule" jsp="<%=jsp_ledgerrule%>" />
    <% } %>
    
    <%-- ADD --%>
    <% if (!pageBase.isNewItem()) { %>
      <v:tab-plus>
			  <%-- LEDGER RULE --%>
			  <% String hrefLedgerRule = pageBase.getContextURL() + "?page=paymethod&tab=ledgerrule&id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.PaymentMethod.getCode(); %>
			  <v:popup-item caption="@Ledger.LedgerRules" fa="book" href="<%=hrefLedgerRule%>"/>
			  
			  <%-- NOTES --%>
			  <% String onclickNotes = "asyncDialogEasy('common/notes_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.PaymentMethod.getCode() + "');"; %>
			  <v:popup-item caption="@Common.Notes" fa="comments" onclick="<%=onclickNotes%>"/>
			  
			  <%-- HISTORY --%>
			  <% if (rights.History.getBoolean()) {%>
			    <% String onclickHistory = "asyncDialogEasy('common/history_detail_dialog', 'id=" + pageBase.getId() + "');"; %>
			    <v:popup-item caption="@Common.History" fa="history" onclick="<%=onclickHistory%>"/>
			  <% } %>  
      </v:tab-plus>
    <% } %>
  </v:tab-group>
</div>


<jsp:include page="/resources/common/footer.jsp"/>
