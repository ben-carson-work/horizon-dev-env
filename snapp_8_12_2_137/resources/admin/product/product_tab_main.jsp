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

<% 
boolean xpiProduct = product.XPIOneToOne.getBoolean() || (product.XPIProdCrossSellCount.getInt() > 0);

boolean canEdit = rightCRUD.canUpdate(); 
boolean canCreate = rightCRUD.canCreate(); 
boolean canDelete = rightCRUD.canDelete();
boolean canSuspend = canEdit && rights.ProductSuspension.getBoolean();
boolean isNew = product.ProductId.isNull();
boolean systemCode = product.ProductType.isLookup(LkSNProductType.System);
boolean presaleCode = product.ProductType.isLookup(LkSNProductType.Presale);

DOProductSuspend productSuspensionDetails = pageBase.getBL(BLBO_ProductSuspend.class).productSuspended(JvDateTime.now().getDatePart(), product.ProductSuspendList.getItems());

String sReadOnly = canEdit ? "" : " readonly=\"readonly\""; 

BLBO_DocTemplate blDocTemplate = pageBase.getBL(BLBO_DocTemplate.class);

%>

<jsp:include page="product_tab_main_css.jsp" />
<jsp:include page="product_tab_main_js.jsp" />

<v:page-form id="product-form">
<v:input-text type="hidden" field="product.ProductId"/>
<v:input-text type="hidden" field="product.ProductType"/>

<div id="suspend_product_dialog" class="v-hidden">
  <v:form-field caption="@Product.SuspendFrom">
    <v:input-text type="datepicker" field="product.SuspendFrom"/>
  </v:form-field>
</div>

<script>
  var metaFields = <%=pageBase.getBL(BLBO_MetaData.class).encodeItems(product.MetaDataList)%>;
</script>

<v:tab-toolbar>
  <v:button id="btn-save" caption="@Common.Save" fa="save" enabled="false"/>
  
  <snp:notes-btn entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.ProductType%>"/>
  <% if (!systemCode && !pageBase.isNewItem()) { %>
    <span class="divider"></span>
    <v:button caption="@Common.Duplicate" fa="clone" onclick="doDuplicate()" enabled="<%=canCreate%>"/>
    <span class="divider"></span>
    <% String hrefExport = ConfigTag.getValue("site_url") + "/admin?page=export&EntityIDs=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.ProductType.getCode(); %> 
    <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" href="<%=hrefExport%>"/> 
  <% } %>
</v:tab-toolbar>

<v:tab-content>
  
  <v:profile-recap>
    <snp:profile-pic entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.ProductType%>" field="product.ProfilePictureId" enabled="<%=canEdit%>"/>

    <jsp:include page="../common/icon-alias-widget.jsp">
      <jsp:param name="iconAlias-Field" value="product.IconAlias"/>
      <jsp:param name="iconAlias-ForegroundField" value="product.ForegroundColor"/>
      <jsp:param name="iconAlias-BackgroundField" value="product.BackgroundColor"/>
      <jsp:param name="iconAlias-CanEdit" value="<%=canEdit%>"/>
    </jsp:include>
    
    <% if (!pageBase.isNewItem() && !product.ProductType.isLookup(LkSNProductType.Material)) { %>
    <v:grid id="attribute-grid" clazz="noselect">
      <thead>
        <tr>
          <td colspan="100%" class="widget-title">
            <span class="widget-title-caption"><v:itl key="@Product.Attributes"/></span>
            <div class="attribute-tools">
              <% if (canEdit) { %>
                <i class="add-btn fa fa-plus" onclick="showAttributePickup()"></i>
              <% } %>
              <i class="info-btn fa fa-circle-question v-tooltip"></i>
            </div>
          </td>
        </tr>
      </thead>
      <tbody>
      </tbody>
    </v:grid>
    <% } %>
  </v:profile-recap>
  
  <v:profile-main>
    <% if (productSuspensionDetails != null) { %>
      <% String suspensionDescription = "";
         String suspensionHref = "javascript:asyncDialogEasy('product/product_suspend_dialog', 'id=" + pageBase.getId() + "&ReadOnly=" + !canSuspend + "')"; 
         if (productSuspensionDetails.SuspendDateTo.isNull())
           suspensionDescription = pageBase.getLang().Product.ProductTypeSuspendedTillUnlimited.getText();
         else
           suspensionDescription = pageBase.getLang().Product.ProductTypeSuspendedTill.getText(pageBase.format(productSuspensionDetails.SuspendDateTo, pageBase.getShortDateFormat()));
      %>
      <v:alert-box type="warning">
        <a href="<%=suspensionHref%>"><%=suspensionDescription%></a>
      </v:alert-box>
    <% } %>
    <v:widget caption="@Common.General">
      <v:widget-block>
        <v:form-field caption="@Common.Code" mandatory="true">
          <v:input-text field="product.ProductCode" enabled="<%=canEdit && !systemCode%>" />
        </v:form-field>
        <v:form-field caption="@Common.Name" mandatory="true">
          <snp:itl-edit field="product.ProductName" entityType="<%=LkSNEntityType.ProductType%>" entityId="<%=pageBase.getId()%>" langField="<%=LkSNHistoryField.ProductType_Name%>" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.Description" checkBoxField="product.ShowNameExt">
          <snp:itl-edit field="product.ProductNameExt" entityType="<%=LkSNEntityType.ProductType%>" entityId="<%=pageBase.getId()%>" langField="<%=LkSNHistoryField.ProductType_NameExt%>" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.Parent">
          <snp:parent-pickup placeholder="@Common.NotAssigned" field="product.ParentEntityId" id="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.ProductType.getCode()%>" parentEntityType="<%=product.ParentEntityType.getInt()%>" enabled="<%=(canDelete && !systemCode && !presaleCode)%>"/>
        </v:form-field>
        <v:form-field caption="@Account.Location">
          <snp:dyncombo field="product.LocationId" entityType="<%=LkSNEntityType.Location%>" enabled="<%=(canEdit && !systemCode && !presaleCode)%>"/>
        </v:form-field>
      </v:widget-block>
      
      <v:widget-block>
        <v:form-field caption="@Category.Category" mandatory="true">
          <v:combobox field="product.CategoryId" lookupDataSetName="dsCategoryTree" idFieldName="CategoryId" captionFieldName="AshedCategoryName" linkEntityType="<%=LkSNEntityType.Category%>" enabled="<%=canEdit%>"/>
        </v:form-field>
        
        <v:form-field caption="@Product.AgeCategory">
          <v:lk-combobox field="product.AgeCategory" lookup="<%=LkSN.AgeCategory%>" allowNull="true" enabled="<%=canEdit%>"/>
        </v:form-field>
        
        <% String hrefTag = "javascript:showTagPickupDialog_OLD(" + LkSNEntityType.ProductType.getCode() + ",'product.TagIDs')"; %>
        <v:form-field caption="@Common.Tags" href="<%=hrefTag%>">
          <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType); %>
          <v:multibox field="product.TagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName" enabled="<%=canEdit%>"/>
        </v:form-field>

        <v:form-field caption="@Common.TagGroups" multiCol="true">
          <v:multi-col caption="@Product.PrintGroup">
            <snp:tag-combobtn field="product.PrintGroupTagId" entityType="<%=LkSNEntityType.PrintGroup%>" enabled="<%=canEdit%>"/>
          </v:multi-col>
          <v:multi-col caption="@Product.FinanceGroup">
            <snp:tag-combobtn field="product.FinanceGroupTagId" entityType="<%=LkSNEntityType.FinanceGroup%>" enabled="<%=canEdit%>"/>
          </v:multi-col>
          <v:multi-col caption="@Product.AdmGroup">
            <snp:tag-combobtn field="product.AdmGroupTagId" entityType="<%=LkSNEntityType.AdmissionGroup%>" enabled="<%=canEdit%>"/>
          </v:multi-col>
          <v:multi-col caption="@Product.AreaGroup">
            <snp:tag-combobtn field="product.AreaGroupTagId" entityType="<%=LkSNEntityType.AreaGroup%>" enabled="<%=canEdit%>"/>
          </v:multi-col>
        </v:form-field>
      </v:widget-block>

      <% if (product.ProductType.isLookup(LkSNProductType.Material)) { %>
        <v:widget-block>
          <v:form-field caption="@Product.MeasureProfile" mandatory="true">
            <v:combobox 
                field="product.MeasureProfileId"
                lookupDataSet="<%=pageBase.getBL(BLBO_Measure.class).getMeasureProfileDS()%>" 
                idFieldName="MeasureProfileId" 
                captionFieldName="MeasureProfileName"
                enabledFieldName="Enabled"
                linkEntityType="<%=LkSNEntityType.MeasureProfile%>" 
                allowNull="true"
                 enabled="<%=canEdit%>"/>
          </v:form-field>
        </v:widget-block>
        <v:widget-block>
          <v:db-checkbox field="product.ProductStatus" value="<%=LkSNProductStatus.OnSale.getCode()%>" caption="@Common.Active" enabled="<%=canEdit%>"/>
        </v:widget-block>
      <% } else { %>
        <v:widget-block>
          <v:form-field caption="@Common.Status">
            <v:lk-combobox field="product.ProductStatus" lookup="<%=LkSN.ProductStatus%>" allowNull="false" enabled="<%=canEdit && !systemCode && !presaleCode%>"/>
          </v:form-field>
          <% if (!systemCode && !product.ProductType.isLookup(LkSNProductType.Presale)) { %>
            <% if (product.ProductType.isLookup(LkSNProductType.Fee)) { %>
              <v:form-field caption="@Common.SaleCalendar" hint="@Common.SaleCalendarHint">
                <snp:dyncombo field="product.CalendarId" entityType="<%=LkSNEntityType.Calendar%>" enabled="<%=canEdit%>"/>
              </v:form-field>
            <% } else { %>
              <v:form-field caption="@Common.Calendars" multiCol="true">
                <v:multi-col caption="@Common.SaleCalendar" hint="@Common.SaleCalendarHint">
                  <snp:dyncombo field="product.CalendarId" entityType="<%=LkSNEntityType.Calendar%>" enabled="<%=canEdit%>"/>
                </v:multi-col>
                <v:multi-col caption="@Common.VisitCalendar" hint="@Common.VisitCalendarHint">
                  <snp:dyncombo field="product.VisitCalendarId" entityType="<%=LkSNEntityType.Calendar%>" enabled="<%=canEdit%>"/>
                </v:multi-col>
                <v:multi-col caption="@Common.DatedCalendar" hint="@Common.DatedCalendarHint">
                  <snp:dyncombo field="product.DatedCalendarId" entityType="<%=LkSNEntityType.Calendar%>" enabled="<%=canEdit%>"/>
                </v:multi-col>
                <v:multi-col caption="@Product.StopSaleCalendar" hint="@Product.StopSaleCalendarHint">
                  <v:input-group>
                    <v:input-group-btn>
                      <v:button id="btn-stopsale" fa="calendar-alt" caption="@Common.Calendar" enabled="<%=canEdit && rights.EditStopSaleDates.getBoolean()%>"/>
                    </v:input-group-btn>
                    <v:input-text field="product.EntryQty" placeholder="@Product.EntryQty" enabled="<%=canEdit%>"/>
                  </v:input-group>
                </v:multi-col>
              </v:form-field>
            <% } %>
          
            <v:form-field caption="@Common.OnSaleFromDate">
              <v:input-text type="datepicker" field="product.OnSaleDateFrom" placeholder="@Common.Unlimited" enabled="<%=canEdit && !systemCode%>"/>
              <v:itl key="@Common.To" transform="lowercase"/>
              <v:input-text type="datepicker" field="product.OnSaleDateTo" placeholder="@Common.Unlimited" enabled="<%=canEdit && !systemCode%>"/>
            </v:form-field>
            <v:form-field caption="@Common.OnSaleFromTime">
              <v:input-text type="timepicker" field="product.OnSaleTimeFrom" enabled="<%=canEdit && !systemCode%>"/>
              <v:itl key="@Common.To" transform="lowercase"/>
              <v:input-text type="timepicker" field="product.OnSaleTimeTo" enabled="<%=canEdit && !systemCode%>"/>
            </v:form-field>
            <v:form-field caption="@Product.PerformanceTime" hint="@Product.PerformanceTimeHint">
              <v:input-text type="timepicker" field="product.PerformanceTimeFrom" enabled="<%=canEdit && !systemCode%>"/>
              <v:itl key="@Common.To" transform="lowercase"/>
              <v:input-text type="timepicker" field="product.PerformanceTimeTo" enabled="<%=canEdit && !systemCode%>"/>
            </v:form-field>
            <% if (!product.ProductType.isLookup(LkSNProductType.Fee)) { %>
              <v:form-field caption="@Product.PerformanceSelectionType" hint="@Product.PerformanceSelectionTypeHint">
                <v:lk-combobox field="product.PerformanceSelectionType" lookup="<%=LkSN.EntryType%>" hideItems="<%=LookupManager.getArray(LkSNEntryType.Dynamic)%>" allowNull="true" enabled="<%=canEdit && !systemCode%>"/>
              </v:form-field>
            <% } %>
          <% } %>
        </v:widget-block>
      
        <v:widget-block>
          <% if (!systemCode && !product.ProductType.isLookup(LkSNProductType.Fee, LkSNProductType.Presale, LkSNProductType.StaffCard)) { %>
            <v:form-field caption="@Common.PriorityOrder" hint="@Common.PriorityOrderHint">
              <v:input-text field="product.PriorityOrder" enabled="<%=canEdit%>"/>
            </v:form-field>
            <v:form-field caption="@Product.PortfolioPriority" hint="@Product.PortfolioPriorityHint">
              <v:input-text field="product.PortfolioPriority" placeholder="1, 2, 3 etc." enabled="<%=canEdit%>"/>
            </v:form-field>
          <% } %>
        </v:widget-block>
      <% } %>
    </v:widget>
    
    <v:widget caption="@Right.Finance">
      <% if (!product.ProductType.isLookup(LkSNProductType.StaffCard)) { %>
        <v:widget-block>
          <v:form-field caption="@Payment.PaymentProfile">
            <v:combobox 
                field="product.PaymentProfileId" 
                lookupDataSet="<%=pageBase.getBL(BLBO_PaymentProfile.class).getPaymentProfileDS(product.PaymentProfileId.getString())%>" 
                idFieldName="PaymentProfileId" 
                captionFieldName="PaymentProfileName" 
                allowNull="true" 
                linkEntityType="<%=LkSNEntityType.PaymentProfile%>"
                enabled="<%=canEdit%>"/>
          </v:form-field>
          <v:form-field caption="@Ledger.LedgerRuleTemplates" hint='@Ledger.LedgerRuleTemplatesHint'>
            <% 
              String[] tagIDs = product.TagIDs.getArray();
              JvDataSet dsLedgerRuleTemplate = pageBase.getBL(BLBO_LedgerRule.class).getLedgerRuleTemplateDSByTagIDs(product.TagIDs.getArray(), product.LedgerRuleTemplateIDs.getArray());                
            %>
            <v:multibox 
                field="product.LedgerRuleTemplateIDs" 
                lookupDataSet="<%=dsLedgerRuleTemplate%>" 
                idFieldName="LedgerRuleTemplateId" 
                captionFieldName="LedgerRuleTemplateName" 
                linkEntityType="<%=LkSNEntityType.LedgerRuleTemplate%>" 
                enabled="<%=canEdit%>"/>
          </v:form-field>
          <v:form-field caption="@Product.GateCategory" hint='@Product.GateCategoryHint'>
            <v:multibox 
                field="product.GateCategoryIDs" 
                lookupDataSet="<%=pageBase.getBL(BLBO_GateCategory.class).getGateCategoriesDS()%>" 
                idFieldName="GateCategoryId" 
                captionFieldName="GateCategoryName" 
                linkEntityType="<%=LkSNEntityType.GateCategory%>" 
                enabled="<%=canEdit%>"/>
          </v:form-field>
        </v:widget-block>
        <v:widget-block>
          <v:form-field caption="@Product.WalletClearing" hint="@Product.WalletClearingHint">
            <v:lk-combobox field="product.WalletClearingTriggerType" lookup="<%=LkSN.LedgerType%>" limitItems="<%=LkSNLedgerType.getWalletPointsTypes()%>" allowNull="true" enabled="<%=canEdit%>"/>
          </v:form-field>
          <v:form-field caption="@Product.RewardPointClearing" hint="@Product.RewardPointClearingHint">
            <v:lk-combobox field="product.RewardPointClearingTriggerType" lookup="<%=LkSN.LedgerType%>" limitItems="<%=LkSNLedgerType.getWalletPointsTypes()%>" allowNull="true" enabled="<%=canEdit%>"/>
          </v:form-field>
          <v:form-field clazz="form-field-optionset">
	          <v:db-checkbox field="product.BindWalletRewardToProduct" caption="@Product.BindWalletRewardToProduct" hint="@Product.BindWalletRewardToProductHint" value="true" enabled="<%=canEdit%>"/>
	          <div data-visibilitycontroller="#product\.BindWalletRewardToProduct">
	            <v:db-checkbox field="product.WalletRewardSingleUse" caption="@Product.WalletRewardSingleUse" hint="@Product.WalletRewardSingleUseHint" value="true" enabled="<%=canEdit%>"/><br/>
	            <v:db-checkbox field="product.WalletRewardPayPartial" caption="@Product.WalletRewardPayPartial" hint="@Product.WalletRewardPayPartialHint" value="true" enabled="<%=canEdit%>"/>
	          </div>
 	          <br/><v:db-checkbox field="product.ChargePPUOnBooking" caption="@Product.ChargePPUOnBooking" hint="@Product.ChargePPUOnBookingHint" value="true" enabled="<%=canEdit%>"/>
          </v:form-field>
          
        </v:widget-block> 
      <% } %>
    </v:widget>

    <jsp:include page="product_tab_main_media_widget.jsp"></jsp:include>
    <jsp:include page="product_tab_main_account_widget.jsp"></jsp:include>
    <jsp:include page="product_tab_main_options_widget.jsp"></jsp:include>

    <v:widget caption="@Product.Groups" include="<%=!product.ProductType.isLookup(LkSNProductType.System, LkSNProductType.Fee, LkSNProductType.Material, LkSNProductType.Presale, LkSNProductType.StaffCard)%>">
      <v:widget-block>
        <v:form-field caption="@Product.QuantityMin" hint="@Product.QuantityMinHint">
          <v:input-text field="product.QuantityMin" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Product.QuantityStep" hint="@Product.QuantityStepHint">
          <v:input-text field="product.QuantityStep" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Product.TrnMaxQty" hint="@Product.TrnMaxQtyHint"> 
          <v:input-text field="product.TrnMaxQty" placeholder="Unlimited" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
    </v:widget>

    <jsp:include page="product_tab_main_identitycheck_widget.jsp"></jsp:include>
        
    <v:widget caption="@ActivationGroup.ActivationGroup" include="<%=!product.ProductType.isLookup(LkSNProductType.System, LkSNProductType.Fee, LkSNProductType.Material, LkSNProductType.Presale, LkSNProductType.StaffCard)%>">
      <v:widget-block>
        <v:form-field caption="@Product.ProductPriorityLevel" hint="@Product.ProductPriorityLevelHint">
          <v:lk-combobox field="product.ProductPriorityLevel" lookup="<%=LkSN.ProductPriorityLevel%>" allowNull="true" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field id="priority-order-check-type" caption="@Product.PriorityOrderCheckType" hint="@Product.PriorityOrderCheckTypeHint">
          <v:lk-combobox lookup="<%=LkSN.PriorityOrderCheckType%>" field="product.PriorityOrderCheckType" allowNull="false" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field id="enforce-secondary-group">
          <v:db-checkbox field="product.EnforceSecondaryGroup" caption="@Product.EnforceSecondaryGroup"  hint="@Product.EnforceSecondaryGroupHint" value="true" enabled="<%=canEdit%>"/>
       </v:form-field>
       <v:form-field id="allow-standalone-sales">
          <v:db-checkbox field="product.AllowStandaloneSales" caption="@Product.AllowStandaloneSales"  hint="@Product.AllowStandaloneSalesHint" value="true" enabled="<%=canEdit%>"/>
       </v:form-field>
      </v:widget-block>
    </v:widget>

    <v:widget caption="@DocTemplate.AutoGenDoc" include="<%=!product.ProductType.isLookup(LkSNProductType.System, LkSNProductType.Fee, LkSNProductType.Material, LkSNProductType.Presale, LkSNProductType.StaffCard)%>">
      <v:widget-block>
        <v:form-field caption="@DocTemplate.DocTemplate">
          <v:combobox field="product.AutoGenDocTemplateId" lookupDataSet="<%=blDocTemplate.getDocTemplateDS(LkSNDocTemplateType.AutoGenDoc)%>" idFieldName="DocTemplateId" captionFieldName="DocTemplateName" linkEntityType="<%=LkSNEntityType.DocTemplate%>" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
      <v:widget-block>
        <v:form-field clazz="form-field-optionset">
          <v:db-checkbox field="product.AutoGenDocAfterPayment" caption="@Product.AutoGenDocAfterPayment" hint="@Product.AutoGenDocAfterPaymentHint" value="true" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
    </v:widget>
    
    <v:widget caption="@Right.OrderDispatch" include="<%=!product.ProductType.isLookup(LkSNProductType.System, LkSNProductType.Fee, LkSNProductType.Material, LkSNProductType.Presale, LkSNProductType.StaffCard)%>">
      <v:widget-block>
        <v:form-field caption="@DocTemplate.DocTemplatesCommon" hint="@Product.OrderDispatchCommonTemplatesHint">
          <v:multibox field="product.DocTemplateIDs" lookupDataSet="<%=blDocTemplate.getDocTemplateDS(LookupManager.getIntArray(LkSNDocTemplateType.TrnReceipt))%>" idFieldName="DocTemplateId" captionFieldName="DocTemplateName" linkEntityType="<%=LkSNEntityType.DocTemplate%>" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@DocTemplate.DocTemplatesSpecific" hint="@Product.OrderDispatchSpecificTemplatesHint">
          <v:multibox field="product.SpecificDocTemplateIDs" lookupDataSet="<%=blDocTemplate.getDocTemplateDS(LookupManager.getIntArray(LkSNDocTemplateType.TrnReceipt))%>" idFieldName="DocTemplateId" captionFieldName="DocTemplateName" linkEntityType="<%=LkSNEntityType.DocTemplate%>" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
    </v:widget>
      
    <div id="maskedit-container"></div>
    
    <div id="templates" class="hidden">
      <table>
        <tr class="grid-row attribute-item">
          <td><i class="fa fa-bars drag-handle"></i></td>
          <td width="100%">
            <a class="item-name list-title"></a><br/>
            <span class="attribute-name list-subtitle"></span><i class="fa fa-loveseat ai-icon icon-seat fg-red"></i><i class="fa fa-atom-simple ai-icon icon-dynent fg-green"></i>
          </td>
          <% if (canEdit) { %>
            <td align="right">
              <div class="btn-group attribute-item-popup-group">
                <button class="item-btn btn btn-default dropdown-toggle row-hover-visible" type="button" data-toggle="dropdown"><span class="caret"></span></button>
                <v:popup-menu bootstrap="true">
                  <% for (LookupItem item : LkSN.AttributeSelection.getItems()) { %>
                    <% String href = "changeAttributeSelection(this, " + item.getCode() + ")"; %>
                    <v:popup-item caption="<%=item.getRawDescription()%>" onclick="<%=href%>"/>
                  <% } %>
                  <v:popup-divider/>
                  <v:popup-item caption="@Entitlement.DynamicEntitlement" onclick="toggleAttributeItemDynamicEntitlement(this)"/>
                  <v:popup-divider/>
                  <v:popup-item caption="@Common.Remove" onclick="removeAttributeItem(this)"/>
                </v:popup-menu>
              </div>
            </td>
          <% } %>
        </tr>
      </table>
      
      <div class="attribute-legend">
        <strong><v:itl key="@Product.AttributeSelectionType"/>:</strong>
        <table class="attribute-legend-grid">
          <tr><td class="legend-color legend-fixed"><v:itl key="@Product.SelectionFixed"/></td></tr>
          <tr><td class="legend-color legend-dynamic"><v:itl key="@Product.SelectionDynamic"/></td></tr>
          <tr><td class="legend-color legend-dynforce"><v:itl key="@Product.SelectionDynForce"/></td></tr>
          <tr><td class="legend-color legend-disabled"><v:itl key="@Common.Disabled"/></td></tr>
        </table>
        &nbsp;<br/>
        <strong><v:itl key="@Common.Options"/>:</strong>
        <table class="attribute-legend-grid">
          <tr><td><i class="fa fa-loveseat fg-red"></i> <v:itl key="@Seat.SeatCategory"/></td></tr>
          <tr><td><i class="fa fa-atom-simple fg-green"></i> <v:itl key="@Entitlement.DynamicEntitlement"/></td></tr>
        </table>
      </div>
      
      <div class="stopsale-icon stopsale-icon-soft"><i class="fa fa-exclamation-circle"></i></div>
      <div class="stopsale-icon stopsale-icon-hard"><i class="fa fa-ban"></i></div>
      
      <div class="stopsale-dialog">
        <div class="stopsale-legend">
          <div class="stopsale-legend-item stopsale-legend-soft"><i class="fa fa-exclamation-circle"></i>&nbsp;<v:itl key="@Lookup.StopSaleType.Soft"/></div>
          <div class="stopsale-legend-item stopsale-legend-hard"><i class="fa fa-ban"></i>&nbsp;<v:itl key="@Lookup.StopSaleType.Hard"/></div>
        </div>
        
        <v:cal-month showYearOnTitle="true" showMonthNav="true"/>
      </div>
      
    </div>
  </v:profile-main>
</v:tab-content>
</v:page-form>

