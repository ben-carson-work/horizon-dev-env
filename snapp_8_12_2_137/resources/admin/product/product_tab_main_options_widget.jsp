<%@page import="com.vgs.web.library.product.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="org.apache.poi.util.*"%>
<%@page import="com.vgs.snapp.dataobject.DOProduct.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProduct" scope="request"/>
<jsp:useBean id="product" class="com.vgs.snapp.dataobject.DOProduct" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="rightCRUD" class="com.vgs.snapp.library.FtCRUD" scope="request"/>

<% boolean canEdit = rightCRUD.canUpdate(); %>

<% if (!product.ProductType.isLookup(LkSNProductType.System, LkSNProductType.Material, LkSNProductType.Presale, LkSNProductType.StaffCard)) { %>
  <v:widget caption="@Common.Options">
    <v:widget-block>
      <v:form-field caption="@Product.ExpirationUsageType" hint="@Product.ExpirationUsageTypeHint">
        <v:lk-checkbox 
          field="product.ExpirationUsageType" 
          lookup="<%=LkSN.ExpirationUsageType%>" 
          hideItems="<%=LookupManager.getArray(
              LkSNExpirationUsageType.AsScheduled,
              LkSNExpirationUsageType.OnFullAdmPrdUsage, 
              LkSNExpirationUsageType.OnFullAdmWalletUsage, 
              LkSNExpirationUsageType.OnFullPrdWalletUsage,
              LkSNExpirationUsageType.OnFullUsage)%>"/>
      </v:form-field>

      <v:form-field caption="@Product.ProductNegativeTransaction" hint="@Product.ProductNegativeTransactionHint">
        <v:lk-combobox lookup="<%=LkSN.ProductNegativeTransaction%>" field="product.ProductNegativeTransaction" allowNull="false" enabled="<%=canEdit%>"/>
      </v:form-field>

      <v:form-field caption="@Product.RequiredPlugins" hint="@Product.RequiredPluginsHint">
        <v:multibox 
            field="product.RequiredPluginIDs" 
            value="<%=pageBase.getBL(BLBO_Product.class).getSelectedRequiredPluginIDs(product.RequiredPluginList)%>" 
            lookupDataSet="<%=pageBase.getBL(BLBO_Product.class).getRequiredPluginDS()%>" 
            idFieldName="PluginId" 
            captionFieldName="PluginName"
            allowNull="true"
            linkEntityType="<%=LkSNEntityType.Plugin%>" 
            enabled="<%=canEdit%>"/>
      </v:form-field>

      <% if (product.ProductType.isLookup(LkSNProductType.Membership)) { %>
        <v:form-field caption="@Product.MembershipPlugin" hint="@Product.MembershipPluginHint">
          <v:combobox field="product.MembershipPluginId" lookupDataSet="<%=pageBase.getBL(BLBO_Plugin.class).getPluginDS(null, LkSNDriverType.FolioClient)%>" captionFieldName="PluginDisplayName" idFieldName="PluginId" linkEntityType="<%=LkSNEntityType.Plugin%>" enabled="<%=canEdit%>"/>
        </v:form-field>
      <% } %>
    </v:widget-block>
      
    <v:widget-block>
      <v:form-field checkBoxField="product.ChangePerformance" caption="@Product.ChangePerformanceAdvanceDays" hint="@Product.ChangePerformanceAdvanceDaysHint">
        <v:input-text field="product.ChangePerformanceAdvanceDays" placeholder="@Common.Always" enabled="<%=canEdit%>" />
      </v:form-field>

      <v:form-field caption="@Product.ChangeVisitDateFee" hint="@Product.ChangeVisitDateFeeHint" multiCol="true">
        <v:multi-col caption="@Common.Fee">
          <% 
          DOFullTextLookupFilters filterFee = new DOFullTextLookupFilters();
          filterFee.Product.ProductTypes.setArray(LookupManager.getIntArray(LkSNProductType.Fee));
          %>
          <snp:dyncombo field="product.ChangeVisitDateFeeProductId" entityType="<%=LkSNEntityType.ProductType%>" filters="<%=filterFee%>" enabled="<%=canEdit%>"/>
        </v:multi-col>
        <v:multi-col caption="@Common.Days">
          <v:input-text field="product.ChangeVisitDateFeeDays" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
        </v:multi-col>
      </v:form-field>

      <v:form-field caption="@Product.PerformanceFutureDaysShort" hint="@Product.PerformanceFutureDaysHint" multiCol="true">
        <v:multi-col caption="@Product.OverrideNo">
          <v:input-text field="product.PerformanceFutureDays" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
        </v:multi-col>
        <v:multi-col caption="@Product.OverrideYes">
          <v:input-text field="product.PerformanceFutureDaysExt" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
        </v:multi-col>
      </v:form-field>
      
      <v:form-field caption="@Product.PerformanceFutureQtyShort" hint="@Product.PerformanceFutureQtyHint" multiCol="true">
        <v:multi-col caption="@Product.OverrideNo">
          <v:input-text field="product.PerformanceFutureQty" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
        </v:multi-col>
        <v:multi-col caption="@Product.OverrideYes">
          <v:input-text field="product.PerformanceFutureQtyExt" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
        </v:multi-col>
      </v:form-field>
    </v:widget-block>

    <v:widget-block>
      <v:form-field caption="@Common.Options" clazz="form-field-optionset">
        <div><v:db-checkbox field="product.VariableDescription" caption="@Product.VariableDescription" hint="@Product.VariableDescriptionHint" value="true" enabled="<%=canEdit%>"/></div>            
        <div><v:db-checkbox field="product.TrackInventory" caption="@Product.TrackInventory" value="true" onclick="refreshStockLink()" enabled="<%=canEdit%>"/> <a id="stock-link" class="hidden" style="font-weight:bold" href="javascript:showStockDialog()">(<v:itl key="@Common.WarehouseStock"/>)</a></div>            
        <div><v:db-checkbox field="product.WritePerformanceAccountId" caption="@Product.WritePerformanceAccount" hint="@Product.WritePerformanceAccountHint" value="true" enabled="<%=canEdit%>"/></div>
        <div><v:db-checkbox field="product.HidePriceVisibility" caption="@Product.HidePriceVisibility" value="true" enabled="<%=canEdit%>"/></div>   
        <div><v:db-checkbox field="product.Membership" caption="@Common.Membership" value="true" enabled="<%=canEdit%>"/></div>
        <div><v:db-checkbox field="product.RestrictOpenOrder" caption="@Common.RestrictOpenOrder" hint="@Common.RestrictOpenOrderHint" value="true" enabled="<%=canEdit%>"/></div>            
        <div><v:db-checkbox field="product.IgnoreEncodedEntitlements" caption="@Product.IgnoreEncodedEntitlements" hint="@Product.IgnoreEncodedEntitlementsHint" value="true" enabled="<%=canEdit%>"/></div>
        <div><v:db-checkbox field="product.AutoRedeemOnSale" caption="@Product.AutoRedeemOnSale" hint="@Product.AutoRedeemOnSaleHint" value="true" enabled="<%=canEdit%>"/></div>
        <div><v:db-checkbox field="product.SpecialProductDoNotOpenApt" caption="@Product.SpecialProductDoNotOpenApt" hint="@Product.SpecialProductDoNotOpenAptHint" value="true" enabled="<%=canEdit%>"/></div>
        <div><v:db-checkbox field="product.ForceReceiptPrint" caption="@Product.ForceReceiptPrint" hint="@Product.ForceReceiptPrintHint" value="true" enabled="<%=canEdit%>"/></div>
        <div><v:db-checkbox field="product.PeopleOfDetermination" caption="@Product.PeopleOfDetermination" hint="@Product.PeopleOfDeterminationHint" value="true" enabled="<%=canEdit%>"/></div>
        <div><v:db-checkbox field="product.Transferable" caption="@Product.Transferable" hint="@Product.TransferableHint" value="true" enabled="<%=canEdit%>"/></div>
        <div><v:db-checkbox field="product.IgnoreAdmissionStatistics" caption="@Product.IgnoreAdmissionStatistics" hint="@Product.IgnoreAdmissionStatisticsHint" value="true" enabled="<%=canEdit%>"/></div>
        <div><v:db-checkbox field="product.AccountMetaDataEngrave" caption="@Product.AccountMetaDataEngrave" hint="@Product.AccountMetaDataEngraveHint" value="true" enabled="<%=canEdit%>"/></div>
        <div><v:db-checkbox field="product.ChangeStartValidity" caption="@Product.ChangeStartValidity" hint="@Product.ChangeStartValidityHint" value="true" enabled="<%=canEdit%>"/></div>
        <div><v:db-checkbox field="product.ChangeExpirationDate" caption="@Product.ChangeExpirationDate" hint="@Product.ChangeExpirationDateHint" value="true" enabled="<%=canEdit%>"/></div>
        <div><v:db-checkbox field="product.PrintValidityDescOnTrnReceipt" caption="@Product.PrintValidityDescOnTrnReceipt" hint="@Product.PrintValidityDescOnTrnReceiptHint" value="true" enabled="<%=canEdit%>"/></div>
        <div><v:db-checkbox field="product.ValidateSecurityRestriction" caption="@Product.ValidateSecurityRestriction" hint="@Product.ValidateSecurityRestrictionHint" value="true" enabled="<%=canEdit%>"/></div>
        <div><v:db-checkbox field="product.ValidateFromVisitDate" caption="@Product.ValidateFromVisitDate" hint="@Product.ValidateFromVisitDateHint" value="true" enabled="<%=canEdit%>"/></div>
        <div><v:db-checkbox field="product.OrderGuestOnly" caption="@Product.OrderGuestOnly" hint="@Product.OrderGuestOnlyHint" value="true" enabled="<%=canEdit%>"/></div>
        <div><v:db-checkbox field="product.PreventDirectSale" caption="@Product.PreventDirectSale" hint="@Product.PreventDirectSaleHint" value="true" enabled="<%=canEdit%>"/></div>
        <div><v:db-checkbox field="product.ForceDynAttrView" caption="@Product.ForceDynAttrView" hint="@Product.ForceDynAttrViewHint" value="true" enabled="<%=canEdit%>"/></div>
        <div><v:db-checkbox field="product.PreventAdmission" caption="@Product.PreventAdmission" hint="@Product.PreventAdmissionHint" value="true" enabled="<%=canEdit%>"/></div>
        <div><v:db-checkbox field="product.Principal" caption="@Product.Principal" hint="@Product.PrincipalHint" value="true" enabled="<%=canEdit%>"/></div>
        <div><v:db-checkbox field="product.NotPrintableAtUnmannedWks" caption="@Product.NotPrintableAtUnmannedWks" hint="@Product.NotPrintableAtUnmannedWksHint" value="true" enabled="<%=canEdit%>"/></div>
        <div><v:db-checkbox field="product.IssueForRefund" caption="@Product.IssueForRefund" hint="@Product.IssueForRefundHint" value="true" enabled="<%=canEdit%>"/></div>
        <div><v:db-checkbox field="product.PromptPerformanceSelection" caption="@Product.PromptPerformanceSelection" hint="@Product.PromptPerformanceSelectionHint" value="true" enabled="<%=canEdit%>"/></div>
        <div><v:db-checkbox field="product.MultipleBookingsOnSamePerformance" caption="@Product.MultipleBookingsOnSamePerformance" hint="@Product.MultipleBookingsOnSamePerformanceHint" value="true" enabled="<%=canEdit%>"/></div>
        <div><v:db-checkbox field="product.NoEventDetailsOnTrnVoidReceipt" caption="@Product.NoEventDetailsOnTrnVoidReceipt" hint="@Product.NoEventDetailsOnTrnVoidReceiptHint" value="true" enabled="<%=canEdit%>"/></div>
        <div><v:db-checkbox field="product.EntitlementStrictMerge" caption="@Product.EntitlementStrictMerge" hint="@Product.EntitlementStrictMergeHint" value="true" enabled="<%=canEdit%>"/></div>
      </v:form-field>
    </v:widget-block>
  </v:widget>
<% } %>


