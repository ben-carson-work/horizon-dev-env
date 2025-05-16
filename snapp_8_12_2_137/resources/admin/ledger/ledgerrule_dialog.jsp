<%@page import="com.vgs.web.library.product.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
boolean canEdit = rights.SettingsLedgerAccounts.canUpdate();
String setDisabled = canEdit ? "" : "disabled";

BLBO_LedgerRule bl = pageBase.getBL(BLBO_LedgerRule.class);
String templateLedgerRuleId = pageBase.getNullParameter("TemplateLedgerRuleId");
DOLedgerRule ledgerRule = pageBase.isNewItem() ? bl.prepareNewLedgerRule(templateLedgerRuleId) : bl.loadLedgerRule(pageBase.getId());
request.setAttribute("ledgerRule", ledgerRule);


if (pageBase.isNewItem() && (templateLedgerRuleId == null)) {
  LookupItem entityType = LkSN.EntityType.findItemByCode(pageBase.getParameter("EntityType"));
  String entityId = pageBase.getNullParameter("EntityId");
  
  if (entityType != null) {
    ledgerRule.TriggerEntityType.setLkValue(entityType);
    ledgerRule.TriggerEntityId.setString(entityId);
  }
}

if (pageBase.isNewItem())
  ledgerRule.LedgerTriggerType.setLkValue(LkSNLedgerType.SalePay);

boolean creditCardPaymentMethod = false;
boolean intercompanyPaymentMethod = false;
boolean walletRewardPaymentMethod = false;
boolean folioChargePaymentMethod = false;
boolean isOverRefund = ledgerRule.TriggerEntityType.isLookup(LkSNEntityType.ProductType) && ledgerRule.TriggerEntityId.isSameString(NSystemProduct.OverRefund.getProductId());
boolean isWalletDeposit = ledgerRule.TriggerEntityType.isLookup(LkSNEntityType.ProductType) && ledgerRule.TriggerEntityId.isSameString(NSystemProduct.WalletDeposit.getProductId());
boolean isWalletClearing = ledgerRule.TriggerEntityType.isLookup(LkSNEntityType.ProductType) && ledgerRule.TriggerEntityId.isSameString(NSystemProduct.WalletClearing.getProductId());
boolean isRewardClearing = ledgerRule.TriggerEntityType.isLookup(LkSNEntityType.ProductType) && ledgerRule.TriggerEntityId.isSameString(NSystemProduct.RewardPointClearing.getProductId());

boolean pluginEnabled = ledgerRule.PluginEnabled.getBoolean();
boolean active = ledgerRule.LedgerRuleStatus.isLookup(LkSNLedgerRuleStatus.Active);
String checked = active ? " checked" : "";

if (ledgerRule.TriggerEntityType.isLookup(LkSNEntityType.PaymentMethod)) {
  LookupItem driverType = pageBase.getBL(BLBO_Plugin.class).getDriverTypeByPluginId(ledgerRule.TriggerEntityId.getString());
  creditCardPaymentMethod = driverType.isLookup(LkSNDriverType.CreditCard, LkSNDriverType.WebPayment, LkSNDriverType.GiftCard);
  intercompanyPaymentMethod = driverType.isLookup(LkSNDriverType.Intercompany);
  walletRewardPaymentMethod = driverType.isLookup(LkSNDriverType.Wallet) || driverType.isLookup(LkSNDriverType.RewardPoints);
  folioChargePaymentMethod = driverType.isLookup(LkSNDriverType.Membership);
}

QueryDef qdefPLG = new QueryDef(QryBO_Plugin.class)
    .addFilter(QryBO_Plugin.Fil.DriverType, LkSNDriverType.Ledger.getCode())
    .addFilter(QryBO_Plugin.Fil.PluginEnabled, "true")
    .addFilter(QryBO_Plugin.Fil.ExtensionPackageEnabled, "true")
    .addSort(QryBO_Plugin.Sel.PluginDisplayName)
    .addSelect(
    QryBO_Plugin.Sel.PluginId,
    QryBO_Plugin.Sel.DriverName,
    QryBO_Plugin.Sel.DriverClassAlias,
    QryBO_Plugin.Sel.PluginDisplayName);

String title = pageBase.getLang().Ledger.LedgerRule.getText();
if (ledgerRule.TriggerEntityId.getString() != null && !pageBase.isNewItem())
  title = ledgerRule.Description.getString();
%>

<v:dialog id="ledgerrule_dialog" width="1000" height="700" title="<%=title%>">

<table style="width:100%">
  <tr>
    <td width="50%" valign="top">
      <%-- TRIGGER --%>
      <v:widget caption="@Ledger.RuleTrigger">
        <div id="only-product-block">
          <v:widget-block>
            <v:form-field caption="@Common.Type">
              <% if (isWalletDeposit) { %>
                <v:lk-combobox field="ledgerRule.LedgerTriggerType" lookup="<%=LkSN.LedgerType%>" limitItems="<%=LkSNLedgerType.getSystemProductWalletDepositTypes()%>" allowNull="false" enabled="<%=canEdit%>"/>
              <% } else if (isWalletClearing) { %>
                <v:lk-combobox field="ledgerRule.LedgerTriggerType" lookup="<%=LkSN.LedgerType%>" limitItems="<%=LkSNLedgerType.getSystemProductWalletClearigTypes()%>" allowNull="false" enabled="<%=canEdit%>"/>
              <% } else if (isRewardClearing) { %>
                <v:lk-combobox field="ledgerRule.LedgerTriggerType" lookup="<%=LkSN.LedgerType%>" limitItems="<%=LkSNLedgerType.getSystemProductRewardClearigTypes()%>" allowNull="false" enabled="<%=canEdit%>"/>
              <% } else if (isOverRefund) { %>
                <v:lk-combobox field="ledgerRule.LedgerTriggerType" lookup="<%=LkSN.LedgerType%>" limitItems="<%=LkSNLedgerType.getSystemProductOverRefundTypes()%>" allowNull="false" enabled="<%=canEdit%>"/>	              
	            <% } else { %>
	              <v:lk-combobox field="ledgerRule.LedgerTriggerType" lookup="<%=LkSN.LedgerType%>" limitItems="<%=LkSNLedgerType.getLedgerRuleTypes()%>" allowNull="false" enabled="<%=canEdit%>"/>
	            <% } %>
	        </v:form-field>
	        
	        <div id="include-filters">
		        <v:form-field clazz="form-field-optionset">
		          <div id="trigger-used-unused">
	              <div><v:db-checkbox caption="@Ledger.UsedTicket" value="true" field="ledgerRule.UsedTicket" enabled="<%=canEdit%>"/></div>
	              <div><v:db-checkbox caption="@Ledger.UnusedTicket" value="true" field="ledgerRule.UnusedTicket" enabled="<%=canEdit%>"/></div>
	            </div>
	            <div id="trigger-online-offline">
	              <div><v:db-checkbox caption="@Ledger.ValidOnlineOffline" value="true" field="ledgerRule.ValidOnlineOffline" hint="@Ledger.ValidOnlineOfflineHint" enabled="<%=canEdit%>"/></div>
	              <div><v:db-checkbox caption="@Ledger.InvalidOffline" value="true" field="ledgerRule.InvalidOffline" hint="@Ledger.InvalidOfflineHint" enabled="<%=canEdit%>"/></div>
	            </div>
		        </v:form-field>
	        </div>
	        
	        <div id="additional-triggers">
		        <v:form-field clazz="form-field-optionset" checkBoxField="AdditionalTriggers" caption="@Ledger.AdditionalTriggers">
	            <div id="trigger-refund"><v:db-checkbox caption="@Ledger.TriggerOnRefund" hint="@Ledger.TriggerOnRefundHint" value="true" field="ledgerRule.TriggerOnRefund" enabled="<%=canEdit%>"/></div>
	            <div id="trigger-upgrade"><v:db-checkbox caption="@Ledger.TriggerOnUpgrade" hint="@Ledger.TriggerOnUpgradeHint" value="true" field="ledgerRule.TriggerOnUpgrade" enabled="<%=canEdit%>"/></div>
	            <div id="trigger-res-status">
	              <div><v:db-checkbox caption="@Ledger.ResPaidNotEnc" value="true" field="ledgerRule.TriggerOnPaidNotEnc" enabled="<%=canEdit%>"/></div>
	              <div><v:db-checkbox caption="@Ledger.ResEncNotPaid" value="true" field="ledgerRule.TriggerOnEncNotPaid" enabled="<%=canEdit%>"/></div>
	            </div>
	            <div id="trigger-order-payment">
                <div><v:db-checkbox caption="@Ledger.TriggerOnUnpaidProduct" hint="@Ledger.TriggerOnUnpaidProductHint" value="true" field="ledgerRule.TriggerOnUnpaidProduct" enabled="<%=canEdit%>"/></div>
	            </div>
		        </v:form-field>
	        </div>
	        
	        <div id="used-location-only-block">
		        <v:form-field clazz="form-field-optionset" checkBoxField="WeightOptions" caption="@Ledger.WeightOptions">
              <v:db-checkbox caption="@Ledger.MultiplyNEntries" hint="@Ledger.MultiplyNEntriesHint" field="ledgerRule.MultiplyWeight" value="true" enabled="<%=canEdit%>"/>
	            <v:db-checkbox caption="@Ledger.InheritProductWeights" hint="@Ledger.InheritProductWeightsHint" field="ledgerRule.InheritProductWeights" value="true" enabled="<%=canEdit%>"/>
	            <div id="prod-upgrade-location-only-block">
	              <v:db-checkbox caption="@Ledger.IncludeUpgradedProductsUsages" field="ledgerRule.IncludeUpgradedProductsUsages" value="true" enabled="<%=canEdit%>"/>
	            </div>
		        </v:form-field>
	        </div>
	      </v:widget-block>
	      <v:widget-block id="value-type-block">
	        <v:form-field id="value-type-type" caption="@Common.ValueType"><v:lk-combobox field="ledgerRule.LedgerRuleAmountType" lookup="<%=LkSN.LedgerRuleAmountType%>" allowNull="false" enabled="<%=canEdit%>"/></v:form-field>
	          <div id="trigger-pointsvalidfordiscount">
	            <v:form-field clazz="form-field-optionset"> 
	              <v:db-checkbox caption="@Ledger.TriggerOnPointsValidForDiscount" value="true" field="ledgerRule.TriggerOnPointsValidForDiscount" enabled="<%=canEdit%>"/>
	              <v:db-checkbox caption="@Ledger.TriggerOnPointsValidForPayment" value="true" field="ledgerRule.TriggerOnPointsValidForPayment" enabled="<%=canEdit%>"/>
	            </v:form-field>
	          </div>  
	          <v:form-field id="value-type-value" caption="@Common.Value"><v:input-text field="ledgerRule.LedgerRuleAmount" enabled="<%=canEdit%>"/></v:form-field>
	        </v:widget-block>
	        
	        <v:widget-block id="automatic-revert-refund-block" clazz="hidden">
            <v:db-checkbox field="ledgerRule.AutomaticRevertRefund" caption="@Ledger.AutomaticRevert" hint="@Ledger.AutomaticRevertHint" value="true" enabled="<%=canEdit%>"/>
            <div data-visibilitycontroller="#ledgerRule\.AutomaticRevertRefund" id="auto-hide-automaticrevertrefund">
	            
	            <v:form-field caption="@Ledger.AutoRevertLedgerAccount" hint="@Ledger.AutoRevertLedgerAccountHint">
	              <snp:dyncombo field="ledgerRule.AutoRevertRefundLedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" allowNull="false" showItemCode="true" enabled="<%=canEdit%>"/>
	            </v:form-field>
	            
	            <v:form-field caption="@Ledger.AutoRevertLocation" hint="@Ledger.AutoRevertLocationHint">
	              <select id="autorevert-location-refund-select" class="form-control">
	                <optgroup label="Dynamic">
	                  <% for (LookupItem item : LkSN.LedgerRuleAccountType.getItems()) { %>
	                    <% if (!item.isLookup(LkSNLedgerRuleAccountType.Fixed) ) { %> 
	                      <option data-accounttype="<%=item.getCode()%>" value="<%=item.getCode()%>"><%=JvString.escapeHtml(JvMultiLang.translate(pageContext.getRequest(), item.getRawDescription()))%></option>
	                    <% } %>  
	                  <% } %>
	                </optgroup>
	                <optgroup label="Fixed">
	                  <% JvDataSet dsLoc = pageBase.getBL(BLBO_Account.class).getLocationDS(true); %>
	                  <v:ds-loop dataset="<%=dsLoc%>">
	                    <option data-accounttype="<%=LkSNLedgerRuleAccountType.Fixed.getCode()%>" value="<%=dsLoc.getField(QryBO_Account.Sel.AccountId).getHtmlString()%>">
	                      <%=dsLoc.getField(QryBO_Account.Sel.DisplayName).getHtmlString()%>
	                    </option>
	                  </v:ds-loop>
	                </optgroup>
	              </select>
	            </v:form-field>
            </div>
          </v:widget-block>
          
          
          <v:widget-block id="automatic-revert-upgrade-block" clazz="hidden">
            <v:db-checkbox field="ledgerRule.AutomaticRevertUpgrade" caption="@Ledger.AutomaticRevertUpgDest" hint="@Ledger.AutomaticRevertUpgDestHint" value="true" enabled="<%=canEdit%>"/>
            <div data-visibilitycontroller="#ledgerRule\.AutomaticRevertUpgrade" id="auto-hide-automaticrevertupgrade">
              
              <v:form-field caption="@Ledger.AutoRevertLedgerAccount" hint="@Ledger.AutoRevertLedgerAccountHint">
                <snp:dyncombo field="ledgerRule.AutoRevertUpgradeLedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" allowNull="false" showLinkButton="true" showItemCode="true" enabled="<%=canEdit%>"/>
              </v:form-field>
              
              <v:form-field caption="@Ledger.AutoRevertLocation" hint="@Ledger.AutoRevertLocationHint">
                <select id="autorevert-location-upgrade-select" class="form-control">
                  <optgroup label="Dynamic">
                    <% for (LookupItem item : LkSN.LedgerRuleAccountType.getItems()) { %>
                      <% if (!item.isLookup(LkSNLedgerRuleAccountType.Fixed) ) { %> 
                        <option data-accounttype="<%=item.getCode()%>" value="<%=item.getCode()%>"><%=JvString.escapeHtml(JvMultiLang.translate(pageContext.getRequest(), item.getRawDescription()))%></option>
                      <% } %>  
                    <% } %>
                  </optgroup>
                  <optgroup label="Fixed">
                    <% JvDataSet dsLoc = pageBase.getBL(BLBO_Account.class).getLocationDS(true); %>
                    <v:ds-loop dataset="<%=dsLoc%>">
                      <option data-accounttype="<%=LkSNLedgerRuleAccountType.Fixed.getCode()%>" value="<%=dsLoc.getField(QryBO_Account.Sel.AccountId).getHtmlString()%>">
                        <%=dsLoc.getField(QryBO_Account.Sel.DisplayName).getHtmlString()%>
                      </option>
                    </v:ds-loop>
                  </optgroup>
                </select>
              </v:form-field>
            </div>
          </v:widget-block>
          
          
	        <v:widget-block id="clearing-limit-block">
	          <div><v:db-checkbox caption="@Ledger.AffectClearingLimit" field="ledgerRule.AffectClearingLimit" value="true" enabled="<%=canEdit%>"/></div>
	        </v:widget-block>
        </div>
        <v:widget-block id="plugin-block">  
          <div><v:db-checkbox caption="@Ledger.UsePlugin" field="ledgerRule.UsePlugin" value="true"/></div>
          <div><label><input type="checkbox" id="ledgerRule.Active" name="ledgerRule.Active" <%=checked%>> <v:itl key="@Common.Active"/></label></div>
        </v:widget-block>
      </v:widget>
    </td>
    <td width="10px" nowrap></td>
    <td width="50%" valign="top">
      <%-- FILTER --%>
      <v:widget caption="@Common.Filter">
        <v:widget-block>
          <v:form-field id="workstation-type-filter" caption="@Ledger.WorkstationType" hint="@Ledger.WorkstationTypeHint">
            <v:lk-combobox field="ledgerRule.FilterWorkstationType" lookup="<%=LkSN.WorkstationType%>" allowNull="true" enabled="<%=canEdit%>"/>
          </v:form-field>
          <% if ((pageBase.isParameter("EntityType", LkSNEntityType.ProductType.getCode())) || (pageBase.isParameter("EntityType", LkSNEntityType.PaymentMethod.getCode())) || (pageBase.isParameter("EntityType", LkSNEntityType.LedgerRuleTemplateDate.getCode()))) { %>
            <v:form-field id="product-location-filter" caption="@Account.Location" hint="@Ledger.LocationHint">
              <snp:dyncombo field="ledgerRule.FilterLocationId" entityType="<%=LkSNEntityType.Location%>" allowNull="true" enabled="<%=canEdit%>"/>
            </v:form-field>           
            <v:form-field id="product-workstation-filter" caption="@Common.Workstation" hint="@Ledger.WorkstationHint">
              <snp:dyncombo field="ledgerRule.FilterWorkstationId" entityType="<%=LkSNEntityType.Workstation%>" allowNull="true" enabled="<%=canEdit%>"/>
            </v:form-field>
            <v:form-field caption="@Ledger.SaleWorkstation" hint="@Ledger.SaleWorkstationTypeHint">
              <v:lk-combobox field="ledgerRule.FilterSaleWorkstationType" lookup="<%=LkSN.WorkstationType%>" allowNull="true" enabled="<%=canEdit%>"/>
            </v:form-field>
            <v:form-field caption="@Lookup.LedgerRuleAccountType.SaleLocation" hint="@Ledger.SaleLocationHint">
              <snp:dyncombo field="ledgerRule.FilterSaleLocationId" entityType="<%=LkSNEntityType.Location%>" allowNull="true" enabled="<%=canEdit%>"/>
            </v:form-field>
            <v:form-field id="gate-category-filter" caption="@Product.GateCategory">
              <snp:dyncombo field="ledgerRule.FilterGateCategoryId" entityType="<%=LkSNEntityType.GateCategory%>" allowNull="true" enabled="<%=canEdit%>"/>
            </v:form-field>
            <% if (!pageBase.isParameter("EntityType", LkSNEntityType.PaymentMethod.getCode())) { %>
              <v:form-field id="event-filter" caption="@Event.Event" hint="@Ledger.AccessPointHint">
                <snp:dyncombo field="ledgerRule.FilterEventId" entityType="<%=LkSNEntityType.Event%>" allowNull="true" enabled="<%=canEdit%>"/>
              </v:form-field>
              <v:form-field id="access-point-filter" caption="@AccessPoint.AccessPoint" hint="@Ledger.AccessPointHint">
                <snp:dyncombo field="ledgerRule.FilterAccessPointId" entityType="<%=LkSNEntityType.AccessPoint%>" allowNull="true" enabled="<%=canEdit%>"/>
              </v:form-field>
            <% } %>  
            <v:form-field caption="@Ledger.TaxesOnSale">
              <v:lk-combobox field="ledgerRule.FilterTaxExempt" lookup="<%=LkSN.LedgerTaxExemptFilter%>" allowNull="true" enabled="<%=canEdit%>"/>
            </v:form-field>
            <v:form-field id="membershippoint-filter" caption="@Common.WalletReward">
              <v:multibox	               
                 field="ledgerRule.FilterMembershipPointIDs"
                 lookupDataSet="<%=pageBase.getBL(BLBO_RewardPoint.class).getRewardPointDS(true)%>"
                 idFieldName="MembershipPointId"
                 captionFieldName="MembershipPointName"
                 linkEntityType="<%=LkSNEntityType.RewardPoint.getCode()%>"
                 enabled="<%=canEdit%>"/>
             </v:form-field>
             <v:form-field id="salechannel-filter" caption="@SaleChannel.SaleChannel">
              <v:multibox                
                 field="ledgerRule.FilterSaleChannelIDs"
                 lookupDataSet="<%=pageBase.getBL(BLBO_SaleChannel.class).getSaleChannelLookupDS(null, null)%>"
                 idFieldName="SaleChannelId"
                 captionFieldName="SaleChannelName"
                 linkEntityType="<%=LkSNEntityType.SaleChannel%>"
                 enabled="<%=canEdit%>"/>
             </v:form-field>
          <% } %>
          <% if (creditCardPaymentMethod) { %> 
            <v:form-field caption="@Ledger.CardTypes" hint="@Ledger.CardTypesHint">
              <v:input-text field="ledgerRule.FilterPaymentCodes" placeholder="@Ledger.CardTypesPlaceholder"/>
            </v:form-field>
          <% } %>
          <% if (intercompanyPaymentMethod) { %> 
            <v:form-field caption="@Ledger.CostCenters" hint="@Ledger.CostCentersHint">
              <v:input-text field="ledgerRule.FilterPaymentCodes"/>
            </v:form-field>
          <% } %>
          <% if (folioChargePaymentMethod) { %> 
            <v:form-field caption="@Ledger.FolioClient">
              <% JvDataSet dsFolioClients = pageBase.getBL(BLBO_Plugin.class).getPluginDS(null, LkSNDriverType.FolioClient); %>
              <v:multibox 
              field="ledgerRule.FilterFolioClientIDs" 
              lookupDataSet="<%=pageBase.getBL(BLBO_Plugin.class).getPluginDS(null, LkSNDriverType.FolioClient)%>" 
              idFieldName="PluginId" 
              captionFieldName="PluginName" 
              linkEntityType="<%=LkSNEntityType.Plugin%>"
              enabled="<%=canEdit%>"/>
            </v:form-field>
          <% } %>
        </v:widget-block>
      </v:widget>
    </td>
  </tr>
  <tr id="standard-details-table">
    <td colspan="100%">
      <%-- DETAIL --%>
      <v:grid id="rule-detail-grid">
        <thead>
          <v:grid-title caption="@Common.Details"/>
          <tr>
            <td><v:grid-checkbox header="true"/></td>
            <td>#</td>
            <td width="40%">
              <v:itl key="@Ledger.RuleSource"/><br/>
              <v:itl key="@Account.Location"/>
            </td>
            <td width="40%">
              <v:itl key="@Ledger.RuleTarget"/><br/>
              <v:itl key="@Account.Location"/>
            </td>
            <td width="20%">
              <span id="weight-column-text">
                <v:itl key="@Common.Weight"/><br/>
                <v:itl key="@Ledger.LocationUsageFilter"/>
              </span>
            </td>
          </tr>
        </thead>
        <tbody id="rule-detail-body">
        </tbody>
        <tbody>
          <tr>
            <td colspan="100%">
              <v:button caption="@Common.Add" fa="plus" href="javascript:addEmptyDetailLine()" enabled="<%=canEdit%>"/>
              <v:button caption="@Common.Remove" fa="minus" href="javascript:removeObject()" enabled="<%=canEdit%>"/>
            </td>
          </tr>
        </tbody>
      </v:grid>
      <v:widget caption="@Common.Details" id="plugin-detail-grid">
        <v:widget-block>  
          <v:form-field caption="@Plugin.Plugin">
            <v:combobox field="ledgerRule.PluginId" lookupDataSet="<%=pageBase.execQuery(qdefPLG)%>" idFieldName="PluginId" captionFieldName="DriverName" allowNull="false"/>
          </v:form-field>
        </v:widget-block>
      </v:widget>
    </td>
  </tr>
</table>

<div id="ledger-rule-templates" class="hidden">
  <snp:dyncombo clazz="LedgerAccountTemplate-Select" field="LedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" allowNull="true" showItemCode="true" enabled="<%=canEdit%>"/>  
  <v:combobox clazz="usage-filter-loc-select" lookupDataSet="<%=pageBase.getBL(BLBO_Account.class).getLocationDS(true)%>" idFieldName="AccountId" captionFieldName="DisplayName"/> 
  <v:combobox clazz="gate-cat-select" lookupDataSet="<%=pageBase.getBL(BLBO_GateCategory.class).getGateCategoriesDS()%>" allowNull="false" idFieldName="GateCategoryId" captionFieldName="GateCategoryName"/>

  <select class="LocationTypeTemplate-Select form-control" <%=setDisabled%>>
    <optgroup label="Dynamic">
      <% for (LookupItem item : LkSN.LedgerRuleAccountType.getItems()) { %>
        <% if (!item.isLookup(LkSNLedgerRuleAccountType.Fixed) ) { %> 
          <option data-accounttype="<%=item.getCode()%>" value="<%=item.getCode()%>"><%=JvString.escapeHtml(JvMultiLang.translate(pageContext.getRequest(), item.getRawDescription()))%></option>
        <% } %>  
      <% } %>
    </optgroup>
    <optgroup label="Fixed">
      <% JvDataSet dsLoc = pageBase.getBL(BLBO_Account.class).getLocationDS(true); %>
      <v:ds-loop dataset="<%=dsLoc%>">
        <option data-accounttype="<%=LkSNLedgerRuleAccountType.Fixed.getCode()%>" value="<%=dsLoc.getField(QryBO_Account.Sel.AccountId).getHtmlString()%>">
          <%=dsLoc.getField(QryBO_Account.Sel.DisplayName).getHtmlString()%>
        </option>
      </v:ds-loop>
    </optgroup>
  </select>
</div>

<jsp:include page="ledgerrule_dialog_js.jsp"/>
<jsp:include page="ledgerrule_dialog_css.jsp"/>

</v:dialog>

