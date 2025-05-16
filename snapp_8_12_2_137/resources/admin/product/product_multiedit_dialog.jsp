<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="product_expiration_usagetype_handler_js.jsp"/>
<%
String sProductIDs = pageBase.getNullParameter("ProductIDs");
String[] sProductIDArray = JvArray.stringToArray(sProductIDs, ",");

QueryDef qdefTag = new QueryDef(QryBO_Tag.class);
qdefTag.addSelect(QryBO_Tag.Sel.TagId, QryBO_Tag.Sel.TagName);
qdefTag.addFilter(QryBO_Tag.Fil.EntityType, LkSNEntityType.ProductType.getCode());
qdefTag.addSort(QryBO_Tag.Sel.TagName);

QueryDef qdefDoc = new QueryDef(QryBO_DocTemplate.class);
qdefDoc.addSelect(QryBO_DocTemplate.Sel.DocTemplateId, QryBO_DocTemplate.Sel.DocTemplateName);
qdefDoc.addFilter(QryBO_DocTemplate.Fil.DocTemplateType, LkSNDocTemplateType.Media.getCode());
qdefDoc.addSort(QryBO_DocTemplate.Sel.DocTemplateName);

QueryDef qdef = new QueryDef(QryBO_DocTemplate.class);
qdef.addSelect(QryBO_DocTemplate.Sel.IconName, QryBO_DocTemplate.Sel.DocTemplateId, QryBO_DocTemplate.Sel.DocTemplateName, QryBO_DocTemplate.Sel.DriverCount);
qdef.addFilter(QryBO_DocTemplate.Fil.DocTemplateType, LkSNDocTemplateType.AutoGenDoc.getCode());
qdef.addSort(QryBO_DocTemplate.Sel.DocTemplateName);

JvDataSet dsSaleChannel = pageBase.getBL(BLBO_SaleChannel.class).getSaleChannelLookupDS((LookupItem)null);

String[] forParentEntityIDs = new String[0];
for (String productId: sProductIDArray)
  forParentEntityIDs = JvArray.add(EntityTree.getIDs(pageBase.getConnector(), LkSNEntityType.ProductType, productId), forParentEntityIDs);
forParentEntityIDs = JvArray.distinct(forParentEntityIDs);

QueryDef qdefPT = new QueryDef(QryBO_PerformanceType.class);
qdefPT.addSelect(QryBO_PerformanceType.Sel.PerformanceTypeId, QryBO_PerformanceType.Sel.PerformanceTypeName);
qdefPT.addFilter(QryBO_PerformanceType.Fil.ForParentEntityId, forParentEntityIDs);
qdefPT.addSort(QryBO_PerformanceType.Sel.PerformanceTypeName);
%>

<jsp:include page="product_multiedit_dialog_js.jsp" />
<jsp:include page="product_multiedit_dialog_css.jsp" />

<v:dialog id="product_multiedit_dialog" tabsView="true" title="@Common.MultiEdit" width="1310" height="720" autofocus="false">
  <v:tab-group name="tab" main="true">
  
    <!-- GENERAL -->
    <v:tab-item-embedded tab="tabs-general" caption="@Common.General" default="true">
      <div class="tab-content">
        <v:widget>
          <v:widget-block>
            <v:form-field id="ProdME-Status" caption="@Common.Status" checkBoxField="Upd_Status">
              <v:lk-combobox lookup="<%=LkSN.ProductStatus%>" allowNull="false"/>
            </v:form-field>
            <v:form-field id="ProdME-Category" caption="@Category.Category" checkBoxField="Upd_Category">
              <% request.setAttribute("dsCategory", pageBase.getBL(BLBO_Category.class).getCategoryAshedTreeDS(LkSNEntityType.ProductType)); %>
              <v:combobox idFieldName="CategoryId" captionFieldName="AshedCategoryName" lookupDataSetName="dsCategory" name="field-value" allowNull="false"/>
            </v:form-field>
            <v:form-field id="ProdME-Calendar" caption="@Common.SaleCalendar" checkBoxField="Upd_Calendar">
              <% String calId = null; %>
              <% request.setAttribute("dsCalendar", pageBase.getBL(BLBO_Calendar.class).getCalendarDS(calId)); %>
              <v:combobox idFieldName="CalendarId" captionFieldName="CalendarName" lookupDataSetName="dsCalendar" name="field-value"/>
            </v:form-field>
            <v:form-field id="ProdME-VisitCalendar" caption="@Common.VisitCalendar" checkBoxField="Upd_VisitCalendar">
              <% String calId = null; %>
              <% request.setAttribute("dsCalendar", pageBase.getBL(BLBO_Calendar.class).getCalendarDS(calId)); %>
              <v:combobox idFieldName="CalendarId" captionFieldName="CalendarName" lookupDataSetName="dsCalendar" name="field-value"/>
            </v:form-field>
            <v:form-field id="ProdME-DatedCalendar" caption="@Common.DatedCalendar" checkBoxField="Upd_DatedCalendar">
              <% String calId = null; %>
              <% request.setAttribute("dsCalendar", pageBase.getBL(BLBO_Calendar.class).getCalendarDS(calId)); %>
              <v:combobox idFieldName="CalendarId" captionFieldName="CalendarName" lookupDataSetName="dsCalendar" name="field-value"/>
            </v:form-field>
            <v:form-field id="ProdME-FromDate" caption="@Common.FromDate" checkBoxField="Upd_FromDate">
              <v:input-text type="datepicker" field="product.OnSaleDateFrom"/>
            </v:form-field>
             <v:form-field id="ProdME-ToDate" caption="@Common.ToDate" checkBoxField="Upd_ToDate">
              <v:input-text type="datepicker" field="product.OnSaleDateTo"/>
            </v:form-field>
            <v:form-field id="ProdME-FromTime" caption="@Common.FromTime" checkBoxField="Upd_FromTime">
              <v:input-text type="timepicker" field="product.OnSaleTimeFrom"/>
            </v:form-field>
            <v:form-field id="ProdME-ToTime" caption="@Common.ToTime" checkBoxField="Upd_ToTime">
              <v:input-text type="timepicker" field="product.OnSaleTimeTo"/>
            </v:form-field>
            <v:form-field id="ProdME-Parent" caption="@Common.Parent" checkBoxField="Upd_Parent">
              <snp:parent-pickup placeholder="@Common.NotAssigned" field="product.ParentEntityId" id="multi-edit" entityType="<%=LkSNEntityType.ProductType.getCode()%>"/>
            </v:form-field>
            <v:form-field id="ProdME-Location" caption="@Account.Location" checkBoxField="Upd_Location">
              <v:combobox field="product.LocationId" lookupDataSet="<%=pageBase.getBL(BLBO_Account.class).getLocationDS()%>" idFieldName="AccountId" captionFieldName="DisplayName"/>
            </v:form-field>
            <v:form-field id="ProdME-PerformanceSelectionType" caption="@Product.PerformanceSelectionType" hint="@Product.PerformanceSelectionTypeHint" checkBoxField="Upd_PerformanceSelectionType">
              <v:lk-combobox lookup="<%=LkSN.EntryType%>" field="product.PerformanceSelectionType" hideItems="<%=LookupManager.getArray(LkSNEntryType.Dynamic)%>" allowNull="true"/>
            </v:form-field>
          </v:widget-block>
          <v:widget-block>
            <v:form-field id="ProdME-PortfolioPriority" caption="@Product.PortfolioPriority" hint="@Product.PortfolioPriorityHint" checkBoxField="Upd_PortfolioPriority">
              <v:input-text field="field-value" placeholder="1, 2, 3, etc."/>
            </v:form-field>
          </v:widget-block>
          <v:widget-block>
            <v:form-field id="ProdME-PrintGroup" caption="@Product.PrintGroup" checkBoxField="Upd_PrintGroup">
              <% request.setAttribute("dsPrintGroup", pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.PrintGroup)); %>
              <v:combobox idFieldName="TagId" captionFieldName="TagName" lookupDataSetName="dsPrintGroup" name="field-value"/>
            </v:form-field>
            <v:form-field id="ProdME-FinanceGroup" caption="@Product.FinanceGroup" checkBoxField="Upd_FinanceGroup">
              <% request.setAttribute("dsFinanceGroup", pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.FinanceGroup)); %>
              <v:combobox idFieldName="TagId" captionFieldName="TagName" lookupDataSetName="dsFinanceGroup" name="field-value"/>
            </v:form-field>
            <v:form-field id="ProdME-AdmGroup" caption="@Product.AdmGroup" checkBoxField="Upd_AdmGroup">
              <% request.setAttribute("dsAdmissionGroup", pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.AdmissionGroup)); %>
              <v:combobox idFieldName="TagId" captionFieldName="TagName" lookupDataSetName="dsAdmissionGroup" name="field-value"/>
            </v:form-field>
            <v:form-field id="ProdME-AreaGroup" caption="@Product.AreaGroup" checkBoxField="Upd_AreaGroup">
              <% request.setAttribute("dsAreaGroup", pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.AreaGroup)); %>
              <v:combobox idFieldName="TagId" captionFieldName="TagName" lookupDataSetName="dsAreaGroup" name="field-value"/>
            </v:form-field>
          </v:widget-block>
          <v:widget-block>
            <v:form-field id="ProdME-Tags" caption="@Common.Tags" checkBoxField="Upd_Tags">
              <v:multibox field="ProdME-TagIDs" lookupDataSet="<%=pageBase.execQuery(qdefTag)%>" idFieldName="TagId" captionFieldName="TagName"/>
              <div id="tag-operation-type-container">
                <label><input type="radio" name="TagOperation" value="add" checked><v:itl key="@Common.Add"/></label>&nbsp;&nbsp;&nbsp;
                <label><input type="radio" name="TagOperation" value="remove"><v:itl key="@Common.Remove"/></label>
              </div>
            </v:form-field>
            <v:form-field id="ProdME-ExpirationUsageType" caption="@Product.ExpirationUsageType" checkBoxField="Upd_ExpirationUsageType">
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
          </v:widget-block>
          <v:widget-block>
           <v:form-field id="ProdME-Plugins" caption="@Product.RequiredPlugins" checkBoxField="Upd_RequiredPlugins">
             <v:multibox field="ProdME-PluginIDs" lookupDataSet="<%=pageBase.getBL(BLBO_Product.class).getRequiredPluginDS()%>" idFieldName="PluginId" captionFieldName="PluginName"/>
              <div id="plugin-operation-type-container">
                <label><input type="radio" name="PluginOperation" value="add" checked><v:itl key="@Common.Add"/></label>&nbsp;&nbsp;&nbsp;
                <label><input type="radio" name="PluginOperation" value="remove"><v:itl key="@Common.Remove"/></label>
              </div>
            </v:form-field>
          </v:widget-block>
          <v:widget-block>
            <v:form-field id="ProdME-ProductNegativeTransaction" caption="@Product.ProductNegativeTransaction" checkBoxField="Upd_ProductNegativeTransaction">
              <v:lk-combobox lookup="<%=LkSN.ProductNegativeTransaction%>" field="ProductNegativeTransaction" allowNull="false"/>
            </v:form-field>
          </v:widget-block> 
          <v:widget-block>
            <v:form-field id="ProdME-QuantityMin" caption="@Product.QuantityMin" checkBoxField="Upd_QuantityMin">
              <v:input-text field="field-value" placeholder="@Common.Unlimited"/>
            </v:form-field>
            <v:form-field id="ProdME-QuantityStep" caption="@Product.QuantityStep" checkBoxField="Upd_QuantityStep">
              <v:input-text field="field-value" placeholder="@Common.Unlimited"/>
            </v:form-field>
            <v:form-field id="ProdME-TrnMaxQty" caption="@Product.TrnMaxQty" hint="@Product.TrnMaxQtyHint" checkBoxField="Upd_TrnMaxQty">
              <v:input-text field="field-value" placeholder="@Common.Unlimited"/>
            </v:form-field>
          </v:widget-block>
        </v:widget>
      </div>
    </v:tab-item-embedded>
  
    <!-- FLAGS -->
    <v:tab-item-embedded tab="tabs-flag" caption="@Common.Options">
      <div class="tab-content">
        <v:widget>
          <v:widget-block>
            <v:form-field id="ProdME-PerformanceFutureDays" caption="@Product.PerformanceFutureDays" checkBoxField="Upd_PerformanceFutureDays">
              <v:input-text field="field-value" placeholder="@Common.Unlimited"/>
            </v:form-field>
            <v:form-field id="ProdME-ChangePerformanceAdvanceDays" caption="@Product.ChangePerformanceAdvanceDays" hint="@Product.ChangePerformanceAdvanceDaysHint" checkBoxField="Upd_ChangePerformance">
              <v:input-text field="field-value" placeholder="@Common.Always" />
            </v:form-field>
            <v:form-field id="ProdME-PerformanceFutureDaysExt" caption="@Product.PerformanceFutureDaysExt" checkBoxField="Upd_PerformanceFutureDaysExt">
              <v:input-text field="field-value" placeholder="@Common.Unlimited"/>
            </v:form-field>
            <v:form-field id="ProdME-PerformanceFutureQty" caption="@Product.PerformanceFutureQty" checkBoxField="Upd_PerformanceFutureQty">
              <v:input-text field="field-value" placeholder="@Common.Unlimited"/>
            </v:form-field>
            <v:form-field id="ProdME-PerformanceFutureQtyExt" caption="@Product.PerformanceFutureQtyExt" checkBoxField="Upd_PerformanceFutureQtyExt">
              <v:input-text field="field-value" placeholder="@Common.Unlimited"/>
            </v:form-field>
          </v:widget-block>
          
          <v:widget-block>
            <v:form-field id="ProdME-TrackInventory" caption="@Product.TrackInventory" checkBoxField="Upd_TrackInventory">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-WritePerformanceAccountId" caption="@Product.WritePerformanceAccount" checkBoxField="Upd_WritePerformanceAccountId">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-VariableDescription" caption="@Product.VariableDescription" checkBoxField="Upd_VariableDescription">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-HidePriceVisibility" caption="@Product.HidePriceVisibility" checkBoxField="Upd_HidePriceVisibility">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-PrivilegeCard" caption="@Common.Membership" checkBoxField="Upd_PrivilegeCard">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-RestrictOpenOrder" caption="@Common.RestrictOpenOrder" checkBoxField="Upd_RestrictOpenOrder">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-IgnoreEncodedEntitlements" caption="@Product.IgnoreEncodedEntitlements" checkBoxField="Upd_IgnoreEncodedEntitlements">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-AutoRedeemOnSale" caption="@Product.AutoRedeemOnSale" checkBoxField="Upd_AutoRedeemOnSale">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-SpecialProductDoNotOpenApt" caption="@Product.SpecialProductDoNotOpenApt" checkBoxField="Upd_SpecialProductDoNotOpenApt">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-ForceReceiptPrint" caption="@Product.ForceReceiptPrint" checkBoxField="Upd_ForceReceiptPrint">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-PeopleOfDetermination" caption="@Product.PeopleOfDetermination" checkBoxField="Upd_PeopleOfDetermination">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-Transferable" caption="@Product.Transferable" checkBoxField="Upd_Transferable">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-IgnoreAdmissionStatistics" caption="@Product.IgnoreAdmissionStatistics" checkBoxField="Upd_IgnoreAdmissionStatistics">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-AccountMetaDataEngrave" caption="@Product.AccountMetaDataEngrave" checkBoxField="Upd_AccountMetaDataEngrave">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-ChangeExpirationDate" caption="@Product.ChangeExpirationDate" checkBoxField="Upd_ChangeExpirationDate">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-ChangeStartValidity" caption="@Product.ChangeStartValidity" checkBoxField="Upd_ChangeStartValidity">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-PreventAdmission" caption="@Product.PreventAdmission" checkBoxField="Upd_PreventAdmission">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-IssueForRefund" caption="@Product.IssueForRefund" checkBoxField="Upd_IssueForRefund">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-BindWalletRewardToProduct" caption="@Product.BindWalletRewardToProduct" checkBoxField="Upd_BindWalletRewardToProduct">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-ChargePPUOnBooking" caption="@Product.ChargePPUOnBooking" checkBoxField="Upd_ChargePPUOnBooking">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-PromptPerformanceSelection" caption="@Product.PromptPerformanceSelection" checkBoxField="Upd_PromptPerformanceSelection">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-NoEventDetailsOnTrnVoidReceipt" caption="@Product.NoEventDetailsOnTrnVoidReceipt" checkBoxField="Upd_NoEventDetailsOnTrnVoidReceipt">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-EntitlementStrictMerge" caption="@Product.EntitlementStrictMerge" checkBoxField="Upd_EntitlementStrictMerge">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
          </v:widget-block>
        </v:widget>
      </div>
    </v:tab-item-embedded>
  
    <!-- MEDIA -->
    <v:tab-item-embedded tab="tabs-media" caption="@Common.Templates">
      <div class="tab-content">
        <v:widget caption="@Common.Media">
          <v:widget-block>
            <v:form-field id="ProdME-POS_AllowPrint" caption="@DocTemplate.POS_AllowPrint" checkBoxField="field-checkbox">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-POS_Template" caption="@DocTemplate.POS_Template" checkBoxField="field-checkbox">
              <v:multibox field="ProdME-POS_TemplateIDs" lookupDataSet="<%=pageBase.execQuery(qdefDoc)%>" idFieldName="DocTemplateId" captionFieldName="DocTemplateName"/>
              <div id="POS_Template-operation-type-container">
                <label><input type="radio" name="POS_TemplateOperation" value="add" checked><v:itl key="@Common.Add"/></label>&nbsp;&nbsp;&nbsp;
                <label><input type="radio" name="POS_TemplateOperation" value="remove"><v:itl key="@Common.Remove"/></label>
              </div>
            </v:form-field>
            <%-- check box allow printing --%>
            <v:form-field id="ProdME-CLC_AllowPrint" caption="@DocTemplate.CLC_AllowPrint" checkBoxField="field-checkbox">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-CLC_Template" caption="@DocTemplate.CLC_Template" checkBoxField="field-checkbox">
              <v:combobox idFieldName="DocTemplateId" captionFieldName="DocTemplateName" lookupDataSet="<%=pageBase.execQuery(qdefDoc)%>" name="field-value"/>
            </v:form-field>
            <v:form-field id="ProdME-B2B_AllowPrint" caption="@DocTemplate.B2B_AllowPrint" checkBoxField="field-checkbox">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-B2B_Template" caption="@DocTemplate.B2B_Template" checkBoxField="field-checkbox">
              <v:combobox idFieldName="DocTemplateId" captionFieldName="DocTemplateName" lookupDataSet="<%=pageBase.execQuery(qdefDoc)%>" name="field-value"/>
            </v:form-field> 
            <v:form-field id="ProdME-B2C_AllowPrint" caption="@DocTemplate.B2C_AllowPrint" checkBoxField="field-checkbox">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-B2C_Template" caption="@DocTemplate.B2C_Template" checkBoxField="field-checkbox">
              <v:combobox idFieldName="DocTemplateId" captionFieldName="DocTemplateName" lookupDataSet="<%=pageBase.execQuery(qdefDoc)%>" name="field-value"/>
            </v:form-field>
            <v:form-field id="ProdME-MOB_AllowPrint" caption="@DocTemplate.MOB_AllowPrint" checkBoxField="field-checkbox">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-MOB_Template" caption="@DocTemplate.MOB_Template" checkBoxField="field-checkbox">
              <v:combobox idFieldName="DocTemplateId" captionFieldName="DocTemplateName" lookupDataSet="<%=pageBase.execQuery(qdefDoc)%>" name="field-value"/>
            </v:form-field>
            <v:form-field id="ProdME-MWLT_AllowPrint" caption="@DocTemplate.MWLT_AllowPrint" checkBoxField="field-checkbox">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-MWLT_Template" caption="@DocTemplate.MWLT_Template" checkBoxField="field-checkbox">
              <v:combobox idFieldName="DocTemplateId" captionFieldName="DocTemplateName" lookupDataSet="<%=pageBase.execQuery(qdefDoc)%>" name="field-value"/>
            </v:form-field>            
          </v:widget-block>
          <v:widget-block>
            <v:form-field id="ProdME-ExtMediaGroup" caption="@Product.ExtMediaGroup" checkBoxField="field-checkbox">
             <snp:dyncombo field="MediaGroupId" entityType="<%=LkSNEntityType.ExtMediaGroup%>"/>
            </v:form-field>
            <v:form-field id="ProdME-GroupTicketOption" caption="@Product.GroupTicketOption" checkBoxField="field-checkbox">
              <v:lk-combobox lookup="<%=LkSN.GroupTicketOption%>" field="field-value" allowNull="false"/>
            </v:form-field>
          </v:widget-block>
          <v:widget-block>
            <v:form-field id="ProdME-ForceMediaGeneration" caption="@Product.ForceMediaGeneration" checkBoxField="field-checkbox">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-MediaExclusiveUse" caption="@Product.MediaExclusiveUse" checkBoxField="field-checkbox">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-PahGenerateMedia" caption="@Product.PahGenerateMedia" checkBoxField="field-checkbox">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-MediaNotExisting" caption="@Product.MediaNotExisting" checkBoxField="field-checkbox">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-MediaAlreadyExisting" caption="@Product.MediaAlreadyExisting" checkBoxField="field-checkbox">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-RequireOrganizeStep" caption="@Product.RequireOrganizeStep" checkBoxField="field-checkbox">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
          </v:widget-block>
        </v:widget>
        <v:widget caption="@DocTemplate.AutoGenDoc">
          <v:widget-block>
            <v:form-field id="ProdME-AutoGenDocTemplate" caption="@DocTemplate.AutoGenDocTemplate" checkBoxField="field-checkbox">
              <v:combobox idFieldName="DocTemplateId" captionFieldName="DocTemplateName" lookupDataSet="<%=pageBase.execQuery(qdef)%>" name="field-value"/>
            </v:form-field>
<!--
            <v:form-field id="ProdME-AutoGenDocStep" caption="@DocTemplate.AutoGenDocStep" checkBoxField="field-checkbox">
              <v:lk-combobox field="field-value" lookup="<%=LkSN.AutoGenDocStep%>" allowNull="true"/>
            </v:form-field>
            <v:form-field id="ProdME-AutoGenDocActivation" caption="@DocTemplate.AutoGenDocActivation" checkBoxField="field-checkbox">
              <v:lk-combobox field="field-value" lookup="<%=LkSN.AutoGenDocActivation%>" allowNull="true"/>
            </v:form-field>
-->
          </v:widget-block>
        </v:widget>
        <v:widget caption="@Right.OrderDispatch">
          <v:widget-block>
            <v:form-field id="ProdME-CommonOrderDispatch" caption="@DocTemplate.DocTemplatesCommon" checkBoxField="field-checkbox">
              <v:multibox field="ProdME-CommonOrderDispatchIDs" lookupDataSet="<%=pageBase.getBL(BLBO_DocTemplate.class).getDocTemplateDS(LookupManager.getIntArray(LkSNDocTemplateType.TrnReceipt))%>" idFieldName="DocTemplateId" captionFieldName="DocTemplateName"/>
              <div id="commonorderdispatch-operation-type-container">
                <label><input type="radio" name="CommonOrderDispatchOperation" value="add" checked><v:itl key="@Common.Add"/></label>&nbsp;&nbsp;&nbsp;
                <label><input type="radio" name="CommonOrderDispatchOperation" value="remove"><v:itl key="@Common.Remove"/></label>
              </div>
            </v:form-field>
            <v:form-field id="ProdME-SpecificOrderDispatch" caption="@DocTemplate.DocTemplatesSpecific" checkBoxField="field-checkbox">
              <v:multibox field="ProdME-SpecificOrderDispatchIDs" lookupDataSet="<%=pageBase.getBL(BLBO_DocTemplate.class).getDocTemplateDS(LookupManager.getIntArray(LkSNDocTemplateType.TrnReceipt))%>" idFieldName="DocTemplateId" captionFieldName="DocTemplateName"/>
              <div id="specificorderdispatch-operation-type-container">
                <label><input type="radio" name="SpecificOrderDispatchOperation" value="add" checked><v:itl key="@Common.Add"/></label>&nbsp;&nbsp;&nbsp;
                <label><input type="radio" name="SpecificOrderDispatchOperation" value="remove"><v:itl key="@Common.Remove"/></label>
              </div>
            </v:form-field>
          </v:widget-block>
        </v:widget>
      </div>
    </v:tab-item-embedded>
  
    <!-- ATTRIBUTE -->
    <v:tab-item-embedded tab="tabs-attribute" caption="@Product.MultiEditAttrAccBioFam">
      <div class="tab-content">
        <v:widget>
          <v:widget-block id="attribute-widget-block">
            <v:form-field id="ProdME-Attributes" caption="@Product.Attributes" checkBoxField="field-checkbox">
                <div id="add-btn" class="attribute-item-box"  title="<v:itl key="@Common.Add"/>" style="cursor:pointer" onclick="showAttributePickup()"><i class="fa fa-plus"></i></div>
                <div id="ProdME-AttributeOperation" class="attribute-selection">
                  <div id="attribute-operation-selection-type-container">
                   <div id="attribute-operation-type-container">
                     <label><input type="radio" onclick="refreshAttributeSelectionType(false)" name="AttributeOperation" value="add" checked><v:itl key="@Common.Add"/></label>&nbsp;&nbsp;&nbsp;
                     <label><input type="radio" onclick="refreshAttributeSelectionType(true)" name="AttributeOperation" value="remove"><v:itl key="@Common.Remove"/></label>
                   </div>
                   <div id="attribute-item-container">
                     <div id="attribute-selection-type-container">
                       <% for (LookupItem item : LkSN.AttributeSelection.getItems()) { %>
                         <label><input type="radio" name="AttributeSelection" value="<%=item.getCode()%>"><%=item.getDescription(pageBase.getLang())%></label>&nbsp;&nbsp;&nbsp;
                       <% } %>
                     </div>
                   </div>
                 </div>
               </div>
            </v:form-field>
          </v:widget-block>
          <v:widget-block id="salerights-widget-block">
            <v:form-field id="ProdME-SaleRights" caption="@Product.SaleRights" checkBoxField="field-checkbox">
              <div class="salerights-box-container"></div>
              <div class="btn-group">
                <button id="add-entityright-btn" type="button" class="salerights-item-box" data-toggle="dropdown">
                  <i class="fa fa-plus"></i>
                </button>
                <v:popup-menu bootstrap="true">
                  <% 
                  boolean first = true;
                  for (LookupItem entityType : LookupManager.getArray(LkSNEntityType.Person, LkSNEntityType.Organization)) { 
                    if (first)
                      first = false;
                    else {
                      %><v:popup-divider/><%
                    }
            
                    for (EntityRightPopupItem item : EntityRightPopupItem.getList(entityType)) { 
                      %><v:popup-item icon="<%=item.iconName%>" caption="<%=item.caption%>" onclick="<%=item.onclick%>"/><%
                    }
                  } 
                  %>
                </v:popup-menu>
              </div>
              <div id="ProdME-SaleRightsOperation" class="salerights-selection">
                <div id="salerights-operation-selection-type-container">
                  <div id="salerights-operation-type-container">
                    <label><input type="radio" name="SaleRightsOperation" value="add" checked><v:itl key="@Common.Add"/></label>&nbsp;&nbsp;&nbsp;
                    <label><input type="radio" name="SaleRightsOperation" value="remove"><v:itl key="@Common.Remove"/></label>
                  </div>
                </div>
              </div>
            </v:form-field>
          </v:widget-block>
          <v:widget-block>
          <v:form-field id="ProdME-ReqAccount" caption="@Product.RequireAccount" checkBoxField="field-checkbox">
            <select name="field-value" class="form-control" id="require-account-selection">
              <option value="false"><v:itl key="@Common.Inactive"/></option>
              <option value="true"><v:itl key="@Common.Active"/></option>
            </select>
          </v:form-field>
          <v:form-field id="ProdME-CategoryAccount" caption="@Category.Category" checkBoxField="field-checkbox">
             <% request.setAttribute("dsAccountCategoryTree", pageBase.getBL(BLBO_Category.class).getCategoryAshedTreeDS(LkSNEntityType.Person)); %>
             <v:combobox field="field-value" lookupDataSetName="dsAccountCategoryTree" idFieldName="CategoryId" captionFieldName="AshedCategoryName"/>
          </v:form-field>
          <v:form-field id="ProdME-RequireAccountOptions" caption="@Product.RequireAccountOptions" checkBoxField="field-checkbox">
            <label class="checkbox-label">
              <input type="radio" name="ProdME-RequireAccountOption" value=<%=BLBO_Product.RequestAccountOption.ON_SALE.name()%>>
              <v:itl key="@Product.RequireAccountOnSaleOnly"/>
            </label>
            &nbsp; 
            <label class="checkbox-label">
              <input type="radio" name="ProdME-RequireAccountOption" value=<%=BLBO_Product.RequestAccountOption.ON_ENCODING.name()%>>
              <v:itl key="@Product.RequireAccountOnEncodingOnly"/>
            </label>
            &nbsp; 
            <label class="checkbox-label">
              <input type="radio" name="ProdME-RequireAccountOption" value=<%=BLBO_Product.RequestAccountOption.ON_REDEMPTION.name()%>> 
              <v:itl key="@Product.RequireAccountOnRedemptionOnly"/>
            </label>
          </v:form-field>
          </v:widget-block>
          <v:widget-block>
          <v:form-field id="ProdME-Biometric" caption="@Common.IdentityCheck" checkBoxField="field-checkbox">
            <v:lk-combobox field="field-value" lookup="<%=LkSN.BiometricCheckLevel%>" allowNull="false"/>
          </v:form-field>
          <v:form-field id="ProdME-BiometricEnrollment" caption="@Biometric.Enrollment" checkBoxField="field-checkbox">
            <v:lk-combobox field="field-value" lookup="<%=LkSN.BiometricEnrollment%>" allowNull="false"/>
          </v:form-field>
          <v:form-field id="ProdME-BiometricValidityPeriod" caption="@Biometric.ValidityQantity" hint="@Biometric.ValidityPeriodHint" checkBoxField="field-checkbox">
            <v:input-text field="field-value" placeholder="Unlimited"/>
          </v:form-field>
          </v:widget-block>
          <v:widget-block>
          <v:form-field id="ProdME-ManualVerification" caption="@Product.ManualVerification" checkBoxField="field-checkbox">
            <v:lk-combobox field="field-value" lookup="<%=LkSN.ManualVerificationType%>" allowNull="false"/>
          </v:form-field>
          <v:form-field id="ProdME-ManualVerificationMessage" caption="@Product.ManualVerificationMessage" checkBoxField="Upd_ManualVerificationMessage">
            <v:input-text field="field-value"/>
          </v:form-field>
          </v:widget-block>
          <v:widget-block>
            <v:form-field id="ProdME-ProdPriorityLevel" caption="@Product.ProductPriorityLevel" checkBoxField="field-checkbox">
              <v:lk-combobox lookup="<%=LkSN.ProductPriorityLevel%>" field="field-value" allowNull="true"/>
            </v:form-field>
            <v:form-field id="ProdME-PriorityOrderCheckType" caption="@Product.PriorityOrderCheckType" checkBoxField="field-checkbox">
              <v:lk-combobox lookup="<%=LkSN.PriorityOrderCheckType%>" field="field-value" allowNull="true"/>
            </v:form-field>
            <v:form-field id="ProdME-EnforceSecondaryGroup" caption="@Product.EnforceSecondaryGroup" checkBoxField="field-checkbox">
              <select name="field-value" class="form-control" id="require-account-selection" onchange="refreshProdMEVisibility();">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-AllowStandaloneSales" caption="@Product.AllowStandaloneSales" checkBoxField="field-checkbox">
              <select name="field-value" class="form-control" id="require-account-selection" onchange="refreshProdMEVisibility();">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
          </v:widget-block>
        </v:widget>
      </div>
    </v:tab-item-embedded>
  
    <!-- PROFILES -->
    <v:tab-item-embedded tab="tabs-profiles" caption="@Common.Profiles">
      <div class="tab-content">
        <v:widget>
          <v:widget-block>
            <v:form-field id="ProdME-LedgerRuleTemplate" caption="@Ledger.LedgerRule" checkBoxField="field-checkbox">
              <v:multibox field="ProdME-LedgerRuleTemplateIDs" lookupDataSet="<%=pageBase.getBL(BLBO_LedgerRule.class).getLedgerRuleTemplateDS()%>" idFieldName="LedgerRuleTemplateId" captionFieldName="LedgerRuleTemplateName"/>
              <div id="ProdME-LedgerRuleTemplateOperation">
                <div id="ledgerruletemplate-operation-type-container">
                  <label><input type="radio" name="LedgerRuleTemplateOperation" value="add" checked><v:itl key="@Common.Add"/></label>&nbsp;&nbsp;&nbsp;
                  <label><input type="radio" name="LedgerRuleTemplateOperation" value="set"><v:itl key="@Common.Set"/></label>&nbsp;&nbsp;&nbsp;
                  <label><input type="radio" name="LedgerRuleTemplateOperation" value="remove"><v:itl key="@Common.Remove"/></label>
                </div>
              </div>
            </v:form-field>
          </v:widget-block>
          <v:widget-block> 
            <v:form-field id="ProdME-PaymentProfile" caption="@Payment.Payment" checkBoxField="field-checkbox">
              <% request.setAttribute("dsPaymentProfile", pageBase.getBL(BLBO_PaymentProfile.class).getPaymentProfileDS()); %>
              <v:combobox idFieldName="PaymentProfileId" captionFieldName="PaymentProfileName" lookupDataSetName="dsPaymentProfile" name="field-value"/>
            </v:form-field>
          </v:widget-block>
          <v:widget-block> 
            <v:form-field id="ProdME-MeasureProfile" caption="@Product.Measure" checkBoxField="field-checkbox">
              <% request.setAttribute("dsMeasureProfile", pageBase.getBL(BLBO_Measure.class).getMeasureProfileDS()); %>
              <v:combobox idFieldName="MeasureProfileId" captionFieldName="MeasureProfileName" lookupDataSetName="dsMeasureProfile" name="field-value" allowNull="false"/>
            </v:form-field>
          </v:widget-block>
        </v:widget>
      </div>
    </v:tab-item-embedded>
  
    <!-- UPGRADE -->
    <v:tab-item-embedded tab="tabs-upgrade" caption="@Product.MultiEditRefUpgRenewTab">
      <div class="tab-content">
        <v:widget>
          <v:widget-block>
            <v:form-field id="ProdME-Refundable" caption="@Product.Refundable" checkBoxField="field-checkbox">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
              <v:form-field id="ProdME-TicketVoidAdvanceDays" caption="@Product.TicketVoidAdvanceDays" hint="@Product.TicketVoidAdvanceDaysHint" checkBoxField="field-checkbox">
                <v:input-text field="field-value" style="width:95%" placeholder="@Common.Always"/>
              </v:form-field>
            </v:form-field>
            <v:form-field id="ProdME-PartiallyRefundable" caption="@Product.PartiallyRefundable" checkBoxField="field-checkbox">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
          </v:widget-block>
          <v:widget-block>
            <v:form-field id="ProdME-Upgradable" caption="@Product.Upgradable" checkBoxField="field-checkbox">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-Downgradable" caption="@Product.Downgradable" checkBoxField="field-checkbox">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-InheritFromCat" caption="@Product.InheritFromCat" checkBoxField="field-checkbox">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-AllowCrossLocationUpg" caption="@Product.AllowCrossLocationUpg" checkBoxField="field-checkbox">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-UpgDays" caption="@Product.UsedProducts" checkBoxField="field-checkbox">
              <v:input-text field="field-value" placeholder="@Common.Unlimited"/>
            </v:form-field>
            <v:form-field id="ProdME-ExpUpgDays" caption="@Product.ExpirationUpgradeDays" checkBoxField="field-checkbox">
              <v:input-text field="field-value" placeholder="@Common.Unlimited"/>
            </v:form-field>
            <v:form-field id="ProdME-FromVisitUpgDays" caption="@Product.FromVisitUpgradeDays" checkBoxField="field-checkbox">
              <v:input-text field="field-value" placeholder="@Common.Unlimited"/>
            </v:form-field>
            <v:form-field id="ProdME-FromVisitUpgPerfDays" caption="@Product.FromVisitUpgradePerfDays" checkBoxField="field-checkbox">
              <v:input-text field="field-value" placeholder="@Common.Unlimited"/>
            </v:form-field>
          </v:widget-block>
          <v:widget-block>
            <v:form-field id="ProdME-RenewStartDelta" caption="@Product.StartDelta" checkBoxField="field-checkbox">
              <v:input-text field="field-value" placeholder="@Common.Unlimited"/>
            </v:form-field>
            <v:form-field id="ProdME-RenewEndDelta" caption="@Product.EndDelta" checkBoxField="field-checkbox">
              <v:input-text field="field-value" placeholder="@Common.Unlimited"/>
            </v:form-field>
            <v:form-field id="ProdME-RenewableFromAny" caption="@Product.RenewableFromAny" checkBoxField="field-checkbox">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-RenewableToAny" caption="@Product.RenewableToAny" checkBoxField="field-checkbox">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-RenewalSrcProd" caption="@Product.SourceProducts" checkBoxField="field-checkbox">
              <div class="srcproducts-box-container"></div>
              <div id="add-entityright-btn" class="srcproducts-item-box" onclick="showProductPickupDialog()"><i class="fa fa-plus"></i></div>
              <div id="ProdME-SrcProductsOperation" class="srcproducts-selection">
                <div id="srcproducts-operation-selection-type-container" class="v-hidden">
                  <div id="srcproducts-operation-type-container">
                    <label><input type="radio" name="SrcProductsOperation" value="add" checked><v:itl key="@Common.Add"/></label>&nbsp;&nbsp;&nbsp;
                    <label><input type="radio" name="SrcProductsOperation" value="remove"><v:itl key="@Common.Remove"/></label>
                  </div>
                </div>
              </div>
            </v:form-field>
          </v:widget-block>
        </v:widget>
      </div>
    </v:tab-item-embedded>
  
    <!-- PRICES -->
    <v:tab-item-embedded tab="tabs-price" caption="@Product.Prices">
      <div class="tab-content">
        <v:widget>
          <v:widget-block>
            <v:form-field id="ProdME-FacePrice" caption="@Product.FacePrice" checkBoxField="field-checkbox">
              <v:input-text field="field-value"/>
              <v:itl key="@Product.StartDate"/>&nbsp;&nbsp;<v:input-text type="datepicker" field="FacePriceDateFrom" placeholder="@Common.Unlimited"/>
              <v:alert-box type="info" title="@Common.Info" style="max-height:280px;overflow:auto" >
                <v:itl key="@Product.MultiEditFacePrice_Line1"/><br/>
                <v:itl key="@Product.MultiEditFacePrice_Line2"/>
              </v:alert-box>
            </v:form-field>
          </v:widget-block>
          <v:widget-block>
            <v:form-field id="ProdME-PriceTaxes" caption="@Product.Taxes" checkBoxField="field-checkbox">
              <div id="pricetaxes-selection-type-container">
                <% for (LookupItem item : LkSN.TaxCalcType.getItems()) { %>
                  <label><input type="radio" onclick="refreshTaxSelectionType()" name="PriceTaxSelection" value="<%=item.getCode()%>"><%=item.getDescription()%></label>&nbsp;&nbsp;&nbsp;
                <% } %>
              </div>
              <div id="pricetaxes-selection" class="v-hidden">
                <v:combobox field="taxProfileId" lookupDataSet="<%=pageBase.getBL(BLBO_Tax.class).getTaxProfileDS()%>" idFieldName="TaxProfileId" captionFieldName="TaxProfileName" name="field-value"/>
              </div>
            </v:form-field>
            <v:form-field id="ProdME-TaxablePrice" caption="@Product.TaxablePrice" checkBoxField="field-checkbox">
               <v:input-text field="field-value" placeholder="100%"/>
            </v:form-field>
          </v:widget-block>
          <v:widget-block>
            <v:form-field id="ProdME-VariablePrice" caption="@Product.VariablePrice" checkBoxField="field-checkbox">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-ChargeToWallet" caption="@Product.ChargeToWallet" checkBoxField="field-checkbox">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-MinPrice" caption="@Product.MinPrice" checkBoxField="field-checkbox">
              <v:input-text field="field-value" placeholder="@Common.Unlimited"/>
            </v:form-field>
            <v:form-field id="ProdME-MaxPrice" caption="@Product.MaxPrice" checkBoxField="field-checkbox">
              <v:input-text field="field-value" placeholder="@Common.Unlimited"/>
            </v:form-field>
            <v:form-field id="ProdME-ClearingLimitPerc" caption="@Product.ClearingLimitPerc" checkBoxField="field-checkbox">
               <v:input-text field="field-value" placeholder="100%"/>
            </v:form-field>
            <v:form-field id="ProdME-IncludeBearedDiscounts" caption="@Product.IncludeBearedDiscounts" checkBoxField="field-checkbox">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-IncludeBearedTaxes" caption="@Product.IncludeBearedTaxes" checkBoxField="field-checkbox">
              <select name="field-value" class="form-control">
                <option value="false"><v:itl key="@Common.Inactive"/></option>
                <option value="true"><v:itl key="@Common.Active"/></option>
              </select>
            </v:form-field>
            <v:form-field id="ProdME-PresaleValue" caption="@Product.PresaleValue" checkBoxField="field-checkbox">
               <v:input-text field="field-value"/>
            </v:form-field>
          </v:widget-block>
          <v:widget-block>
            <v:form-field id="ProdME-SaleChannels" caption="@SaleChannel.SaleChannel" checkBoxField="field-checkbox">
              <v:multibox field="ProdME-SaleChannelIDs" lookupDataSet="<%=dsSaleChannel%>" idFieldName="SaleChannelId" captionFieldName="SaleChannelName"/>
              <div id="salechannel-operation-type-container">
                <label><input type="radio" name="SaleChannelOperation" value="add" checked><v:itl key="@Common.Add"/></label>&nbsp;&nbsp;&nbsp;
                <label><input type="radio" name="SaleChannelOperation" value="remove"><v:itl key="@Common.Remove"/></label>
              </div>
            </v:form-field>
            <v:form-field id="ProdME-PerformanceTypes" caption="@Performance.PerformanceType" checkBoxField="field-checkbox">
              <v:multibox field="ProdME-PerformanceTypeIDs" lookupDataSet="<%=pageBase.execQuery(qdefPT)%>" idFieldName="PerformanceTypeId" captionFieldName="PerformanceTypeName"/>
              <div id="performancetype-operation-type-container">
                <label><input type="radio" name="PerformanceTypeOperation" value="add" checked><v:itl key="@Common.Add"/></label>&nbsp;&nbsp;&nbsp;
                <label><input type="radio" name="PerformanceTypeOperation" value="remove"><v:itl key="@Common.Remove"/></label>
              </div>
           </v:form-field>
            <v:form-field id="ProdME-PosPricingPlugin" caption="@Product.PosPricingPlugin" checkBoxField="field-checkbox">
              <v:combobox field="product.PosPricingPluginId" lookupDataSet="<%=pageBase.getBL(BLBO_Plugin.class).getPluginDS(null, LkSNDriverType.ProdPricingPos)%>" idFieldName="PluginId" captionFieldName="PluginDisplayName"/>
            </v:form-field>
            <v:form-field id="ProdME-PriceGroup" caption="@Product.PriceGroup" checkBoxField="Upd_PriceGroup">
              <% request.setAttribute("dsPriceGroup", pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.PriceGroup)); %>
              <v:combobox idFieldName="TagId" captionFieldName="TagName" lookupDataSetName="dsPriceGroup" name="field-value"/>
            </v:form-field>
          </v:widget-block>
        </v:widget>
      </div>
    </v:tab-item-embedded>

    <!-- SUSPENSION -->    
    <v:tab-item-embedded tab="tabs-suspend" caption="@Product.Suspension">
      <jsp:include page="product_multiedit_suspend.jsp"></jsp:include>
    </v:tab-item-embedded>
    
    <!-- REV REC -->    
    <v:tab-item-embedded tab="tabs-revrec" caption="@Product.RevenueRecognition">
      <jsp:include page="product_multiedit_revenuerecognition.jsp"></jsp:include>
        <v:widget>
	      <v:widget-block>
	        <v:form-field id="ProdME-PortfolioExpirationWallet" caption="@Product.WalletClearing" checkBoxField="Product_WalletClearing">
		      <v:lk-combobox field="product.WalletClearingTriggerType" lookup="<%=LkSN.LedgerType%>" limitItems="<%=LkSNLedgerType.getWalletPointsTypes()%>" allowNull="true"/>
	        </v:form-field>
	        <v:form-field id="ProdME-PortfolioExpirationRewardPoint" caption="@Product.RewardPointClearing" checkBoxField="Product_RewardPointClearing">
	          <v:lk-combobox field="product.RewardPointClearingTriggerType" lookup="<%=LkSN.LedgerType%>" limitItems="<%=LkSNLedgerType.getWalletPointsTypes()%>" allowNull="true"/>
	        </v:form-field>
	      </v:widget-block>
	    </v:widget>
    </v:tab-item-embedded>

  </v:tab-group>
</v:dialog>