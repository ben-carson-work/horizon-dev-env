<%@page import="com.vgs.snapp.lookup.*"%>
<%@taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageRewardPoint" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="rewardPoint" class="com.vgs.snapp.dataobject.DORewardPoint" scope="request"/>
<!-- TODO get the actual rights -->

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>
<div id="main-container">
  <v:tab-group name="tab" main="true"> 
    <%-- PROFILE --%>
    <v:tab-item caption="@Common.Profile" icon="profile.png" jsp="rewardpoint_tab_main.jsp" tab="main" default="true"/>
    <%-- REWARD POINT ACCRUAL RULE --%>
    <% if (rewardPoint.AccrualRulesCount.getInt() > 0) { %>
	    <% String params = "MembershipPointId=" + pageBase.getId(); %>
	    <v:tab-item caption="@MembershipPoint.RewardPointAccrualRules" fa="trophy" jsp="rewardpoint_accrualrule_list_widget.jsp" tab="rewardpointaccrual" params="<%=params%>"/>
    <% } %>  
    <%-- ADD --%> 
    <% if (!pageBase.isNewItem()) { %>
      <v:tab-plus>
        <%-- REWARD POINT ACCRUAL RULES --%>
       	<% String hrefRwpAccrualRule = "javascript:asyncDialogEasy('product/rewardpoint/rewardpoint_accrualrule_dialog', 'MembershipPointId=" + pageBase.getId() + "')"; %>
       	<v:popup-item caption="@MembershipPoint.RewardPointAccrualRule" fa="trophy" href="<%=hrefRwpAccrualRule%>"/>
        <%-- NOTES --%>
        <%
        String hrefNotes = "javascript:asyncDialogEasy('common/notes_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.RewardPoint.getCode() + "');";
        %>
        <v:popup-item caption="@Common.Notes" fa="comments" href="<%=hrefNotes%>"/>
      
        <%-- HISTORY --%>
        <% if (rights.History.getBoolean()) { %>
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

