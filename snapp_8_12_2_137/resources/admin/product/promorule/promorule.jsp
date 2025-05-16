<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PagePromoRule" scope="request"/>
<jsp:useBean id="promo" class="com.vgs.snapp.dataobject.DOPromoRule" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% 
boolean canEdit = rights.PromotionRules.canUpdate();

request.setAttribute("EntityRight_CanEdit", canEdit);
request.setAttribute("EntityRight_DocEntityType", LkSNEntityType.PromoRule);
request.setAttribute("EntityRight_DocEntityId", pageBase.getId());
request.setAttribute("EntityRight_EntityTypes", new LookupItem[] {LkSNEntityType.Workstation, LkSNEntityType.Person, LkSNEntityType.Organization});
request.setAttribute("EntityRight_ShowRightLevelEdit", false);
request.setAttribute("EntityRight_ShowRightLevelDelete", false);
request.setAttribute("EntityRight_HistoryField", LkSNHistoryField.PromoRule_EntityRights);
%>
<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<style>

#product-tree-block>.inside-block {
  max-height: 200px;
  overflow-y: scroll;
}

</style>

<div id="main-container">
  <v:tab-group name="tab" main="true">
    <%-- PROFILE --%>
    <v:tab-item caption="@Common.Profile" icon="profile.png" jsp="promorule_tab_main.jsp" tab="main" default="true"/>
    <% if (!pageBase.isNewItem()) { %>
      <%-- ACTION --%>
      <% if (!promo.ProductType.isLookup(LkSNProductType.SystemPromo)) { %>
	      <v:tab-item caption="@Product.PromoActions" fa="list" jsp="promorule_tab_action.jsp" tab="action"/>
      <% } %>
      <%-- SALE CAPACITY LIST --%>
      <% if (!pageBase.isNewItem() && promo.HasLimitedCapacity.getBoolean()) { %>
        <v:tab-item caption="@SaleCapacity.SaleCapacity" fa="battery-half" jsp="../product_tab_sale_capacity.jsp" tab="capacity"/>
      <% } %>
      <%-- LEDGER RULE --%>
      <% if ((promo.LedgerRuleCount.getInt() > 0) || pageBase.isTab("tab", "ledgerrule")) { %>
        <% String jsp_ledgerrule = "/admin?page=ledgerrule_tab_widget&EntityId=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.PromoRule.getCode() + "&readonly=" + !canEdit; %>
        <v:tab-item caption="@Ledger.LedgerRules" icon="ledgerrule.png" tab="ledgerrule" jsp="<%=jsp_ledgerrule%>" />
      <% } %>
      <%-- RICHDESC --%>
      <v:tab-item caption="@Common.Description" icon="<%=BLBO_RichDesc.ICONNAME_RICHDESC%>" tab="description" jsp="promorule_tab_description.jsp" />
      <%-- INDIVIDUAL COUPON LIST --%>
      <% if (promo.PromoRuleType.isLookup(LkSNPromoRuleType.IndividualCoupon) && rights.Coupons.getOverallCRUD().canRead()) { %>
        <v:tab-item caption="@Common.Coupons" icon="coupon.png" jsp="promorule_tab_individual_coupon.jsp" tab="coupons"/>
      <% } %>
      <%-- RIGHT --%>
      <% if (!promo.ProductType.isLookup(LkSNProductType.SystemPromo)) { %>
	      <v:tab-item caption="@Common.Rights" icon="<%=LkSNEntityType.Login.getIconName()%>" jsp="../../common/page_tab_rights.jsp" tab="rights"/>
      <% } %>
      <%-- REPOSITORY --%>
      <% if (!promo.RepositoryList.isEmpty()) { %>
        <% String jsp_repository = "/admin?page=repositorylist_widget&id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.PromoRule.getCode() + "&readonly=" + !canEdit; %>
        <v:tab-item caption="@Common.Documents" icon="attachment.png" tab="repository" jsp="<%=jsp_repository%>" />
      <% } %>
      <%-- ADD --%>
      <v:tab-plus>
        <%-- CAPACITY --%>
        <% String hrefCapacity = "javascript:asyncDialogEasy('product/salecapacity/sale_capacity_dialog', 'ProductId=" + pageBase.getId() + "');"; %>
        <v:popup-item caption="@SaleCapacity.SaleCapacity" fa="battery-half" href="<%=hrefCapacity%>"/>

        <%-- LEDGER RULE --%>
        <% String hrefLedgerRule = pageBase.getContextURL() + "?page=promorule&tab=ledgerrule&id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.PromoRule.getCode(); %>
        <v:popup-item caption="@Ledger.LedgerRules" fa="book" href="<%=hrefLedgerRule%>"/>

			  <%-- NOTES --%>
			  <% String hrefNotes = "javascript:asyncDialogEasy('common/notes_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.PromoRule.getCode() + "');"; %>
			  <v:popup-item caption="@Common.Notes" fa="comments" href="<%=hrefNotes%>"/>
			
			  <%-- HISTORY --%>
        <% if (rights.History.getBoolean()) { %>
          <% String hrefHistory = "javascript:asyncDialogEasy('common/history_detail_dialog', 'id=" + pageBase.getId() + "');"; %>
          <v:popup-item caption="@Common.History" fa="history" href="<%=hrefHistory%>"/>
        <% } %>  			  
			  <% if (canEdit) { %>
			    <%-- UPLOAD --%>
			    <% String hrefUpload = "javascript:showUploadDialog(" + LkSNEntityType.PromoRule.getCode() + ", '" + pageBase.getId() + "', " + true + ");";%>
			    <v:popup-item caption="@Common.UploadFile" title="@Common.UploadFileHint" fa="upload" href="<%=hrefUpload%>"/>
			  <% } %>
      </v:tab-plus>
    <% } %>
  </v:tab-group>
</div>

<jsp:include page="/resources/common/footer.jsp"/>
