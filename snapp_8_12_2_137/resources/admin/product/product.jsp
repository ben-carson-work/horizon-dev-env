<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProduct" scope="request"/>
<jsp:useBean id="product" class="com.vgs.snapp.dataobject.DOProduct" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% boolean canEdit = pageBase.getRightCRUD().canUpdate(); %>

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
    <v:tab-item caption="@Common.Profile" icon="profile.png" jsp="product_tab_main.jsp" tab="main" default="true"/>
    <% if (!pageBase.isNewItem()) { %>
      <%-- RICHDESC --%>
      <v:tab-item caption="@Common.Description" icon="<%=BLBO_RichDesc.ICONNAME_RICHDESC%>" tab="description" jsp="product_tab_description.jsp" />
    
      <%-- PRODUCT PACKAGE --%>
      <% if (product.ProductType.isLookup(LkSNProductType.Package)) { %>
        <v:tab-item caption="@Package.Package" icon="package.png" tab="package" jsp="product_tab_package.jsp" />
      <% } %>

      <%-- ENTITLEMENT --%>
      <% if (!product.ProductType.isLookup(LkSNProductType.System, LkSNProductType.Fee, LkSNProductType.Material, LkSNProductType.Presale, LkSNProductType.StaffCard)) { %>
        <v:tab-item caption="@Common.Entitlements" icon="ticket.png" tab="entitlement" jsp="product_tab_entitlement.jsp" />
      <% } %>

      <%-- BOM --%>
      <% if (!product.MaterialList.isEmpty() || !product.PreparationMins.isNull() || pageBase.isTab("tab", "bom")) { %>
        <v:tab-item caption="@Product.BillOfMaterials" icon="measure.png" tab="bom" jsp="product_tab_bom.jsp" />
      <% } %>

      <%-- RESOURCE CONFIG --%>
      <% if (rights.ResourceManagement.canRead() && ((product.ResourceTypeCount.getInt() > 0) || pageBase.isTab("tab", "resconfig"))) { %>
        <v:tab-item caption="@Resource.ResourceManagement" icon="<%=LkSNEntityType.ResourceType.getIconName()%>" tab="resconfig" jsp="product_tab_resconfig.jsp" />
      <% } %>
      
      <%-- GUEST PRODUCTS --%>
      <% if (!product.GuestProductList.isEmpty() || pageBase.isTab("tab", "guest")) { %>
        <v:tab-item caption="@Product.Guests" icon="<%=LkSNEntityType.ProductType.getIconName()%>" tab="guest" jsp="product_tab_guest.jsp" />
      <% } %>
      
      <%-- PPU RULES --%>
      <v:tab-item caption="@Entitlement.PayPerUse" icon="<%=LkSNEntityType.RewardPoint.getIconName()%>" tab="ppurule" jsp="product_tab_ppurule.jsp" include="<%=!product.PPURuleList.isEmpty() || pageBase.isTab(\"tab\", \"ppurule\")%>" />

      <%-- LEDGER RULE --%>
      <% if (!product.ProductType.isLookup(LkSNProductType.Material) && ((product.LedgerRuleCount.getInt() > 0) || pageBase.isTab("tab", "ledgerrule"))) { %>
        <% String jsp_ledgerrule = "/admin?page=ledgerrule_tab_widget&EntityId=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.ProductType.getCode() + "&readonly=" + !canEdit; %>
        <v:tab-item caption="@Ledger.LedgerRules" icon="ledgerrule.png" tab="ledgerrule" jsp="<%=jsp_ledgerrule%>" />
      <% } %>

      <%-- REVENUE RECOGNITION --%>
      <% if (!product.ProductType.isLookup(LkSNProductType.System, LkSNProductType.Fee, LkSNProductType.Material, LkSNProductType.Presale) && ((product.RevenueDateCount.getInt() > 0) || pageBase.isTab("tab", "revenue"))) { %>
        <v:tab-item caption="@Product.RevenueRecognition" icon="coins.png" tab="revenue" jsp="product_tab_revenue_recognition.jsp" />
      <% } %>
      
      <%-- PRICE --%>
      <% if (pageBase.getBLDef().isProductPriceable(product) || pageBase.getBLDef().isProductTaxable(product)) { %>
        <v:tab-item caption="@Product.Prices" icon="coins.png" tab="price" jsp="product_tab_price.jsp" />
      <% } %>
      
      <%-- PRICE SIMULATOR --%>
      <% if (product.PosPricingPluginId.isNull() && !product.ProductType.isLookup(LkSNProductType.System, LkSNProductType.Fee, LkSNProductType.Material, LkSNProductType.StaffCard)) {%>
				<v:tab-item caption="@Product.PriceSimulator" icon="coins.png" tab="price_simulator" jsp="product_tab_price_simulator.jsp" />
      <% } %>
      
      <%-- RIGHTS --%>
      <% if (product.ProductType.isLookup(LkSNProductType.Product, LkSNProductType.Package)) { %>
        <v:tab-item caption="@Product.SaleRights" icon="<%=LkSNEntityType.Login.getIconName()%>" jsp="product_tab_right.jsp" tab="rights"/>
      <% } %>
      
      <%-- CROSS PLATFORM SALES --%>
      <% if ((product.XPIProdCrossSellCount.getInt() > 0) || pageBase.isTab("tab", "xpi")) { %>
        <v:tab-item caption="@XPI.CrossPlatformSales" icon="crossplatform.png" jsp="product_tab_xpi.jsp" tab="xpi"/>
      <% } %>
      
      <%-- ASSOCIATION --%>
      <% if ((product.ProductAssociationList.getSize() > 0) || pageBase.isTab("tab", "association")) { %>
        <v:tab-item caption="@Account.Associations" icon="account_asc.png" tab="association" jsp="product_tab_association.jsp" />
      <% } %>

      <%-- REPOSITORY --%>
      <% if (!product.RepositoryList.isEmpty() || pageBase.isTab("tab", "repository")) { %>
        <% String jsp_repository = "/admin?page=repositorylist_widget&id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.ProductType.getCode() + "&readonly=" + !canEdit; %>
        <v:tab-item caption="@Common.Documents" icon="attachment.png" tab="repository" jsp="<%=jsp_repository%>" />
      <% } %>
      
      <%-- SALE CAPACITY LIST --%>
      <% if (!pageBase.isNewItem() && product.HasLimitedCapacity.getBoolean()) { %>
        <v:tab-item caption="@SaleCapacity.SaleCapacity" fa="battery-half" jsp="product_tab_sale_capacity.jsp" tab="capacity"/>
      <% } %>

      <%-- REWARD POINT ACCRUAL RULE --%>
      <% if (!product.RewardPointAccrualRuleList.isEmpty() || pageBase.isTab("tab", "rewardpoint-accrual-rule")) { %>
          <% String params = "ProductId=" + pageBase.getId(); %>
    		  <v:tab-item caption="@MembershipPoint.RewardPointAccrualRules" fa="trophy" jsp="rewardpoint/rewardpoint_accrualrule_list_widget.jsp" tab="rewardpointaccrual" params="<%=params%>"/>
      <% } %>

      <%-- ADD --%>
      <% if (!pageBase.isNewItem()) { %>
        <v:tab-plus>
          <% if (!product.ProductType.isLookup(LkSNProductType.System, LkSNProductType.Material, LkSNProductType.StaffCard, LkSNProductType.Fee, LkSNProductType.Presale)) { %>
            <%-- UPGRADES --%>
            <% String hrefUpgrades = "javascript:asyncDialogEasy('product/productupg_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.ProductType.getCode() + "&ReadOnly=" + !canEdit + "')"; %>
            <v:popup-item caption="@Product.Upgrades" fa="sort" href="<%=hrefUpgrades%>"/>
          
            <%-- RENEWALPRODUCT --%>
            <% String hrefRenewProduct = "javascript:asyncDialogEasy('product/productrenew_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.ProductType.getCode() + "&ReadOnly=" + !canEdit + "')"; %>
            <v:popup-item caption="@Product.RenewalPolicy" fa="redo" href="<%=hrefRenewProduct%>"/>
          
            <%-- UPSELL --%>
            <% if (BLBO_DBInfo.isUpsellEnabled()) { %>
              <% String hrefUpsellProduct = "javascript:asyncDialogEasy('product/productupsell_dialog', 'id=" + pageBase.getId() + "')"; %>
              <v:popup-item caption="@Product.Upsells" fa="arrow-alt-to-top" href="<%=hrefUpsellProduct%>"/>
            <% } %>
          
            <%-- REVALIDATE PRODUCT --%>
            <% String hrefRevalidateProduct = "javascript:asyncDialogEasy('product/productrevalidate_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.ProductType.getCode() + "&ReadOnly=" + !canEdit + "')"; %>
            <v:popup-item caption="@Product.Revalidation" fa="calendar-plus" href="<%=hrefRevalidateProduct%>"/>
                    
            <%-- BOM --%>
            <% String hrefBOM = pageBase.getContextURL() + "?page=product&tab=bom&id=" + pageBase.getId(); %>
            <v:popup-item caption="@Product.BillOfMaterials" fa="flask" href="<%=hrefBOM%>"/>
          
            <%-- GUEST PRODUCTS --%>  
            <% String hrefGuests = pageBase.getContextURL() + "?page=product&tab=guest&id=" + pageBase.getId(); %>
            <v:popup-item caption="@Product.Guests" fa="tag" href="<%=hrefGuests%>"/>
          
            <%-- REVENUE RECOGNITION --%>
            <% String hrefRevenueDate = pageBase.getContextURL() + "?page=product&tab=revenue&id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.ProductType.getCode(); %>
            <v:popup-item caption="@Product.RevenueRecognition" fa="usd-circle" href="<%=hrefRevenueDate%>"/>
      
            <%-- RESOURCE CONFIG --%>
            <% String hrefResourceType = pageBase.getContextURL() + "?page=product&tab=resconfig&id=" + pageBase.getId(); %>
            <v:popup-item caption="@Resource.ResourceManagement" fa="graduation-cap" href="<%=hrefResourceType%>"/>
          
            <%-- CROSS PLATFORM SALES --%>
            <% String hrefXPI = pageBase.getContextURL() + "?page=product&tab=xpi&id=" + pageBase.getId();%>
            <v:popup-item caption="@XPI.CrossPlatformSales" fa="share-alt" href="<%=hrefXPI%>"/>

            <%-- ASSOCIATIONS --%>
            <% String hrefAssociation = pageBase.getContextURL() + "?page=product&tab=association&id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.ProductType.getCode(); %>
            <v:popup-item caption="@Account.Associations" fa="draw-circle" href="<%=hrefAssociation%>"/>
            
            <%-- CAPACITY --%>
            <% String hrefCapacity = "javascript:asyncDialogEasy('product/salecapacity/sale_capacity_dialog', 'ProductId=" + pageBase.getId() + "');"; %>
            <v:popup-item caption="@SaleCapacity.SaleCapacity" fa="battery-half" href="<%=hrefCapacity%>"/>
            
            <%-- PPU RULES --%>
            <% String hrefPPURules = pageBase.getContextURL() + "?page=product&tab=ppurule&id=" + pageBase.getId(); %>
            <v:popup-item caption="@Entitlement.PayPerUse" fa="award-simple" href="<%=hrefPPURules%>"/>
          <% } %>

          <% if (!product.ProductType.isLookup(LkSNProductType.System, LkSNProductType.Material, LkSNProductType.StaffCard, LkSNProductType.Presale)) { %>
            <%-- REFUND --%>  
            <% String clickRefund = "asyncDialogEasy('product/product_refund_dialog', 'id=" + pageBase.getId() + "&ReadOnly=" + !canEdit + "')"; %>
            <v:popup-item caption="@Product.RefundPolicy" fa="money-bill" onclick="<%=clickRefund%>"/>
          
            <%-- SALE CONSTRAINTS --%>  
            <% String hrefSaleConst = "javascript:asyncDialogEasy('product/product_saleconstr_dialog', 'id=" + pageBase.getId() + "&ReadOnly=" + !canEdit + "')"; %>
            <v:popup-item caption="@Product.SaleConstraints" fa="arrows-to-line" href="<%=hrefSaleConst%>"/>
          
            <%-- SUSPENSIONS --%>          
            <% String hrefSuspend = "javascript:asyncDialogEasy('product/product_suspend_dialog', 'id=" + pageBase.getId() + "&ReadOnly=" + !canEdit + "')"; %>
            <v:popup-item caption="@Product.Suspensions" fa="pause" href="<%=hrefSuspend%>"/>
          <% } %>

          <% if (!product.ProductType.isLookup(LkSNProductType.Material, LkSNProductType.StaffCard)) { %>
            <%-- LEDGER RULE --%>
            <% String hrefLedgerRule = pageBase.getContextURL() + "?page=product&tab=ledgerrule&id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.ProductType.getCode(); %>
            <v:popup-item caption="@Ledger.LedgerRules" fa="book" href="<%=hrefLedgerRule%>"/>
          <% } %>

          <% if (!product.ProductType.isLookup(LkSNProductType.System)) { %>
            <%-- CODE ALIAS --%>
            <% String hrefCodeAlias = "javascript:asyncDialogEasy('code_alias_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.ProductType.getCode() + "&ReadOnly=" + !canEdit + "')"; %>
            <v:popup-item caption="@Common.CodeAliases" fa="barcode" href="<%=hrefCodeAlias%>"/>
          <% } %>

          <% if (product.Membership.getBoolean()) { %>
            <%-- REWARD POINT ACCRUAL RULES --%>
            <% String hrefRwpAccrualRule = "javascript:asyncDialogEasy('product/rewardpoint/rewardpoint_accrualrule_dialog', 'ProductId=" + pageBase.getId() + "')"; %>
            <v:popup-item caption="@MembershipPoint.RewardPointAccrualRule" fa="trophy" href="<%=hrefRwpAccrualRule%>"/>
          <% } %>
          
          <%-- RELATED LOCATIONS --%>
          <% String hrefLocationTab = "javascript:asyncDialogEasy('common/location_list_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.ProductType.getCode() + "')"; %>
          <v:popup-item caption="@Common.RelatedLocations" fa="map-marker" href="<%=hrefLocationTab%>"/>
						  
				  <%-- NOTES --%>
				  <% String hrefNotes = "javascript:asyncDialogEasy('common/notes_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.ProductType.getCode() + "&ReadOnly=" + !canEdit + "');"; %>
				  <v:popup-item caption="@Common.Notes" fa="comments" href="<%=hrefNotes%>"/>
				  
				  <%-- HISTORY --%>
				  <% if (rights.History.getBoolean()) {%>
				    <% String hrefHistory = "javascript:asyncDialogEasy('common/history_detail_dialog', 'id=" + pageBase.getId() + "');"; %>
				    <v:popup-item caption="@Common.History" fa="history" href="<%=hrefHistory%>"/>
				  <% } %>  
				
				  <%-- UPLOAD --%>
				  <% if (canEdit) {%>
					  <% String hrefUpload = "javascript:showUploadDialog(" + LkSNEntityType.ProductType.getCode() + ", '" + pageBase.getId() + "', " + (product.RepositoryList.isEmpty()) + ");"; %>
					  <v:popup-item caption="@Common.UploadFile" title="@Common.UploadFileHint" fa="upload" href="<%=hrefUpload%>"/>
					  <% if (BLBO_DBInfo.isSiae() && rights.FiscalSystemView.getBoolean() && !pageBase.isNewItem()) { %>
					    <% String hrefSIAE = "javascript:asyncDialogEasy('siae/siae_product_dialog', 'id=" + pageBase.getId() + "')"; %>
					    <v:popup-item caption="SIAE" icon="siae.png" href="<%=hrefSIAE%>"/>
					  <% } %>
					<% } %>
        </v:tab-plus>
      <% } %>
    <% } %>
  </v:tab-group>
</div>


<jsp:include page="/resources/common/footer.jsp"/>
