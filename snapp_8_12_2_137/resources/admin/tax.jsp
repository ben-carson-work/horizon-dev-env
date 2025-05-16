<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTax" scope="request"/>
<jsp:useBean id="tax" class="com.vgs.snapp.dataobject.DOTax" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>


<% boolean canEdit = true; %>

<jsp:include page="../common/header.jsp"/>

<v:page-title-box/>

<div id="main-container">
  <v:tab-group name="tab" main="true">
    <%-- PROFILE --%>
    <v:tab-item caption="@Common.Profile" icon="profile.png" jsp="tax_tab_main.jsp" tab="main" default="true"/>

    <%-- LEDGER RULE --%>
    <% if ((tax.LedgerRuleCount.getInt() > 0) || pageBase.isTab("tab", "ledgerrule")) { %>
      <% String jsp_ledgerrule = "/admin?page=ledgerrule_tab_widget&EntityId=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Tax.getCode() + "&readonly=" + !canEdit; %>
      <v:tab-item caption="@Ledger.LedgerRules" icon="ledgerrule.png" tab="ledgerrule" jsp="<%=jsp_ledgerrule%>" />
    <% } %>

    <%-- ADD --%>
    <% if (canEdit && !pageBase.isNewItem()) { %>
      <v:tab-plus>
			  <%-- LEDGER RULE --%>
			  <% String hrefLedgerRule = pageBase.getContextURL() + "?page=tax&tab=ledgerrule&id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Tax.getCode(); %>
			  <v:popup-item caption="@Ledger.LedgerRules" fa="book" href="<%=hrefLedgerRule%>"/>
			  
			  <%-- NOTES --%>
			  <% String onclickNotes = "asyncDialogEasy('common/notes_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Tax.getCode() + "');"; %>
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

<jsp:include page="../common/footer.jsp"/>
