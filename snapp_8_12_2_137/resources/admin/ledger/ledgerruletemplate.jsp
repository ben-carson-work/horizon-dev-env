<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageLedgerRuleTemplate" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% boolean canEdit = rights.SettingsLedgerAccounts.canUpdate(); %>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>
<div id="main-container">
  <v:tab-group name="tab" main="true">
    <v:tab-item caption="@Common.Profile" icon="profile.png" jsp="ledgerruletemplate_tab_main.jsp" tab="main" default="true"/>
    <v:tab-item caption="@Ledger.LedgerRules" icon="ledgerrule.png" jsp="ledgerruletemplate_tab_rules.jsp" tab="rules" include="<%=!pageBase.isNewItem()%>"/>

    <% if (!pageBase.isNewItem()) { %>
      <v:tab-plus>
        <%-- HISTORY --%>
        <% if (rights.History.getBoolean()) {%>
          <% String hrefHistory = "javascript:asyncDialogEasy('common/history_detail_dialog', 'id=" + pageBase.getId() + "');"; %>
          <v:popup-item caption="@Common.History" fa="history" href="<%=hrefHistory%>"/>
        <% } %>  
      </v:tab-plus>
      
    <% } %>
  </v:tab-group>
</div>


<script>

</script>

<jsp:include page="/resources/common/footer.jsp"/>
