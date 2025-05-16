<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PagePromoRule" scope="request"/>
<jsp:useBean id="promo" class="com.vgs.snapp.dataobject.DOPromoRule" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% boolean canEdit = rights.PromotionRules.canUpdate(); %>
<% boolean canCreate = rights.PromotionRules.canCreate(); %>
<% String sReadOnly = canEdit ? "" : " readonly=\"readonly\""; %>

<v:page-form>

<%
QueryDef qdef = new QueryDef(QryBO_DocTemplate.class);
// Select
qdef.addSelect(QryBO_DocTemplate.Sel.IconName);
qdef.addSelect(QryBO_DocTemplate.Sel.DocTemplateId);
qdef.addSelect(QryBO_DocTemplate.Sel.DocTemplateName);
qdef.addSelect(QryBO_DocTemplate.Sel.DriverCount);
// Where
qdef.addFilter(QryBO_DocTemplate.Fil.DocTemplateType, LkSNDocTemplateType.Media.getCode());
// Sort
qdef.addSort(QryBO_DocTemplate.Sel.DocTemplateName);
// Exec
request.setAttribute("dsDocTemplates", pageBase.execQuery(qdef)); 
%>

<% boolean systemCode = promo.ProductType.isLookup(LkSNProductType.SystemPromo); %>

<div class="tab-toolbar">
  <v:button caption="@Common.Save" fa="save" onclick="doSave()" enabled="<%=canEdit%>"/>
  <snp:notes-btn entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.PromoRule%>"/>
  <% if (!systemCode && !pageBase.isNewItem()) { %>
<!--     <span class="divider"></span> -->
<v:button caption="@Common.Duplicate" fa="clone" onclick="doDuplicate()" enabled="<%=canCreate%>"/>
  <% } %>
</div>

<div class="tab-content">
<v:last-error/>
  <div class="profile-pic-div">
    <snp:profile-pic entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.PromoRule%>" field="promo.ProfilePictureId" enabled="<%=canEdit%>"/>
  </div>
  <div class="profile-cont-div">
    <v:widget caption="@Common.General">    
      <v:widget-block>
        <v:form-field caption="@Common.Type">
          <input type="text" id="promo.ProductRuleType" class="form-control" name="promo.ProductRuleType" value="<%=promo.PromoRuleType.getLookupDesc(pageBase.getLang())%>" disabled>
        </v:form-field>
        <v:form-field caption="@Common.Code" mandatory="true">
          <v:input-text field="promo.ProductCode" enabled="<%=canEdit && !systemCode%>" />
        </v:form-field>
        <v:form-field caption="@Common.Name" mandatory="true">
          <snp:itl-edit field="promo.ProductName" entityType="<%=LkSNEntityType.ProductType%>" entityId="<%=pageBase.getId()%>" langField="<%=LkSNHistoryField.ProductType_Name%>" enabled="<%=canEdit%>"/>
        </v:form-field>
          <v:form-field caption="@Category.Category" mandatory="true">
          <v:combobox field="promo.CategoryId" lookupDataSetName="dsCategoryTree" idFieldName="CategoryId" captionFieldName="AshedCategoryName" enabled="<%=canEdit%>"/>
        </v:form-field>
 
        <v:form-field caption="@Common.Description" checkBoxField="promo.ShowNameExt">
          <snp:itl-edit field="promo.ProductNameExt" entityType="<%=LkSNEntityType.ProductType%>" entityId="<%=pageBase.getId()%>" langField="<%=LkSNHistoryField.ProductType_NameExt%>" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Account.Location">
          <snp:dyncombo field="promo.LocationId" entityType="<%=LkSNEntityType.Location%>" enabled="<%=(canEdit && !systemCode)%>"/>
        </v:form-field>
      </v:widget-block>            
      <v:widget-block>
        <v:form-field caption="@Common.Status">
          <v:lk-combobox field="promo.ProductStatus" lookup="<%=LkSN.ProductStatus%>" allowNull="false" enabled="<%=canEdit && !systemCode%>"/>
        </v:form-field>
	    <% if (!systemCode) { %>
        <v:form-field caption="@Common.Calendar">
          <v:combobox 
            field="promo.CalendarId" 
            lookupDataSet="<%=pageBase.getBL(BLBO_Calendar.class).getCalendarDS(promo.CalendarId.getString())%>" 
            idFieldName="CalendarId" 
            captionFieldName="CalendarName" 
            linkEntityType="<%=LkSNEntityType.Calendar%>"
            enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.FromDate">
          <v:input-text type="datepicker" field="promo.ValidityDateFrom" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
          <v:itl key="@Common.To" transform="lowercase"/>
          <v:input-text type="datepicker" field="promo.ValidityDateTo" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.FromTime">
          <v:input-text type="timepicker" field="promo.ActiveFromTime" enabled="<%=canEdit%>"/>
          <v:itl key="@Common.To" transform="lowercase"/>
          <v:input-text type="timepicker" field="promo.ActiveToTime" enabled="<%=canEdit%>"/>
        </v:form-field>
        <% } %>
      </v:widget-block>
      <% if (!systemCode) { %>
        <v:widget-block>
	        <% String hrefTag = "javascript:showTagPickupDialog_OLD(" + LkSNEntityType.PromoRule.getCode() + ",'promo.TagIDs')"; %>
          <v:form-field caption="@Common.Tags" href="<%=hrefTag%>">
		        <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.PromoRule); %>
            <v:multibox field="promo.TagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName" enabled="<%=canEdit%>"/>
          </v:form-field>
	        <v:form-field caption="@Product.PrintGroup">
	          <snp:tag-combobtn field="promo.PrintGroupTagId" entityType="<%=LkSNEntityType.PrintGroup%>" enabled="<%=canEdit%>"/>
	        </v:form-field>
	        <v:form-field caption="@Product.FinanceGroup">
	          <snp:tag-combobtn field="promo.FinanceGroupTagId" entityType="<%=LkSNEntityType.FinanceGroup%>" enabled="<%=canEdit%>"/>
	        </v:form-field>
	      </v:widget-block>
	      <v:widget-block >
	        <v:form-field caption="@Product.PromoSelection" id="selection-type-section">
	          <v:lk-combobox field="promo.PromoSelectionType" lookup="<%=LkSN.PromoSelectionType%>" allowNull="false" enabled="<%=canEdit%>"/>
	        </v:form-field>
	        <v:form-field caption="@Common.MediaTemplate" id="media-template-section">
	          <v:combobox field="promo.DocTemplateId" lookupDataSetName="dsDocTemplates" idFieldName="DocTemplateId" captionFieldName="DocTemplateName" linkEntityType="<%=LkSNEntityType.DocTemplate%>" enabled="<%=canEdit%>"/>	          
	        </v:form-field>
	        <% if (promo.PromoRuleType.isLookup(LkSNPromoRuleType.IndividualCoupon)) { %> 
            <v:form-field caption="@Product.ExtMediaGroup" hint="@Product.ExtMediaGroupHint">
              <snp:dyncombo field="promo.ExtMediaGroupId" entityType="<%=LkSNEntityType.ExtMediaGroup%>"/>
            </v:form-field>
	        <% } %>
	        <v:form-field>      
	          <v:db-checkbox field="promo.Combinable" caption="@Product.PromoCombinable" hint="@Product.PromoCombinableHint" value="true" enabled="<%=canEdit%>"/>
	        </v:form-field>
          <% String hrefTag = "javascript:showTagPickupDialog_OLD(" + LkSNEntityType.PromoRule.getCode() + ",'promo.CombinableTagIDs')"; %>
          <v:form-field id="combinable-tags" caption="@Product.PromoCombinableTags" hint="@Product.PromoCombinableTagsHint" href="<%=hrefTag%>">
		        <% JvDataSet dsCombinableTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.PromoRule); %>
            <v:multibox field="promo.CombinableTagIDs" lookupDataSet="<%=dsCombinableTag%>" idFieldName="TagId" captionFieldName="TagName" placeholder="@Common.Any" enabled="<%=canEdit%>"/>
          </v:form-field>	        
	        <v:form-field id="hide-on-pos-section">      
	          <v:db-checkbox field="promo.HideOnPOS" caption="@Product.PromoBtnHideOnPOS" value="true" enabled="<%=canEdit%>"/>
	        </v:form-field>
	        <% if (promo.PromoRuleType.isLookup(LkSNPromoRuleType.IndividualCoupon)) { %> 
	          <v:form-field>      
	            <v:db-checkbox field="promo.ExternalCheckCouponRedeem" caption="@Product.ExternalCheckCouponRedeem" hint="@Product.ExternalCheckCouponRedeemHint" value="true" enabled="<%=canEdit%>"/>
	          </v:form-field>
	        <% } %>
	      </v:widget-block>
      <% } %>
    </v:widget> 
    <% if (!systemCode) { %>
    <v:widget caption="@Product.PromoOverallConstraints">    
      <v:widget-block>
        <v:form-field caption="@Product.PromoMinTrnAmount">
          <v:input-text field="promo.MinTrnAmount" placeholder="@Common.Any" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Product.PromoMinItemCount" hint="@Product.PromoMinItemHelp">
          <v:input-text field="promo.MinItemCount" placeholder="@Common.Any" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Product.PromoMinItemAmount">
          <v:input-text field="promo.MinItemAmount" placeholder="@Common.Any" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Account.Associations">
          <v:multibox 
            field="promo.AssociationIDs" 
            value="<%=pageBase.getBL(BLBO_PromoRule.class).findLinkedAssociationIDs(promo.PromoRuleAssociationList)%>" 
            lookupDataSet="<%=pageBase.getBL(BLBO_Account.class).getAccountDS(LkSNEntityType.Association)%>" 
            idFieldName="AccountId" 
            captionFieldName="DisplayName"
            allowNull="true"
            linkEntityType="<%=LkSNEntityType.Association%>" 
            enabled="<%=canEdit%>"/>  
        </v:form-field>
      </v:widget-block>   
      <v:widget-block>     
      <v:db-checkbox field="promo.FilterByShopcartContent" caption="@Product.PromoFilterByShopcartContent" hint="@Product.PromoFilterByShopcartContentHint" value="true" enabled="<%=canEdit%>"/>
       <v:grid id="activation-list" style="margin-top:10px">
        <thead >
          <tr>
            <td><v:grid-checkbox header="true"/></td>
            <td>&nbsp;</td>
            <td width="40%"><v:itl key="@Common.Name"/></td>
            <td width="40%"><v:itl key="@Common.Type"/></td>
            <td width="20%" style="white-space:nowrap"><v:itl key="@Product.PromoTriggerQuantityMin"/></td>
          </tr>
        </thead>
        <tbody id="activation-list-tbody">
        </tbody>
        <tbody id="activation-tool-tbody">
          <tr>
            <td colspan="100%">
	            <div class="btn-group">
	              <v:button id="AddItem" caption="@Common.Add" fa="plus" dropdown="true" enabled="<%=canEdit%>"/>
	              <v:popup-menu bootstrap="true">
	                <v:popup-item caption="@Product.ProductType" onclick="addProductTypeActivation()" icon="<%=LkSNEntityType.ProductType.getIconName()%>"/>
	                <v:popup-item caption="@Category.Category" onclick="addCategoryActivation()"  icon="category.png"/>
	              </v:popup-menu>
	            </div>
              <v:button caption="@Common.Remove" fa="minus" href="javascript:removeActivations()" enabled="<%=canEdit%>"/>
            </td>
          </tr>
        </tbody>
      </v:grid>
      </v:widget-block>   
    </v:widget> 
    
    <% if (promo.PromoRuleType.isLookup(LkSNPromoRuleType.IndividualCoupon)) { %> 
    <v:widget caption="@Coupon.Coupon">    
      <v:widget-block>
        <v:form-field caption="@Coupon.ExpirationRule" hint="@Coupon.ExpirationRuleHint">
          <v:lk-combobox field="promo.CouponExpirationRule" lookup="<%=LkSN.CouponExpirationRule%>" allowNull="true" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field id="coupon-exp-rule-quantity" caption="@Coupon.ExpirationRuleQuantity">
          <v:input-text field="promo.CouponExpirationRuleQuantity" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
    </v:widget>    
    <% } %>
       
    <v:widget caption="@Product.PromoPrdConstraints" hint="@Product.PromoPrdConstraintsHint">    
      <v:widget-block>
        <v:form-field caption="@Product.PromoBenefitPeriod" hint="@Product.PromoBenefitPeriodHint">
          <v:lk-combobox field="promo.PeriodType" lookup="<%=LkSN.PromoPeriodType%>" allowNull="true" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field id="period-limit" caption="@Product.PromoPrdNumberOfDays" hint="@Product.PromoPrdNumberOfDaysHint">
          <v:input-text field="promo.PrdLimit" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field id="period-max-items" caption="@Product.PromoPrdMaxItemCount" hint="@Product.PromoPrdMaxItemCountHint">
          <v:input-text field="promo.PrdMaxItemCount" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
    </v:widget>

     <v:widget caption="@Common.Settlement">    
      <v:widget-block>
        <v:form-field caption="@Common.Options" clazz="form-field-optionset">
          <div><v:db-checkbox field="promo.BearedDiscount" caption="@Product.BearedDiscount" hint="@Product.BearedDiscountHint" value="true" enabled="<%=canEdit%>"/></div>            
        </v:form-field>
      </v:widget-block>
    </v:widget>
    
    <v:widget caption="@Product.PromoPaymentConstraints">    
      <v:widget-block>
        <v:form-field caption="@Payment.CardTypes">
            <v:multibox 
                field="promo.CardTypeIDs" 
                lookupDataSet="<%=pageBase.getBL(BLBO_CardType.class).getCardTypeDS()%>" 
                idFieldName="CardTypeId" 
                captionFieldName="CardTypeName" 
                linkEntityType="<%=LkSNEntityType.CardType%>" 
                enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
    </v:widget>
    
    <% if (!systemCode && promo.HasLimitedCapacity.getBoolean()) { %>
    <v:widget caption="@SaleCapacity.SaleCapacity">    
      <v:widget-block>
         <v:form-field caption="@SaleCapacity.CounterType" clazz="form-field-optionset">
          <v:lk-radio lookup="<%=LkSN.SaleCapacityCountType%>" field="promo.SaleCapacityCountType" allowNull="false" inline="true" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
    </v:widget>
    <% } %>

    <v:widget caption="@Plugin.Plugins">    
      <v:widget-block>
        <v:form-field caption="@Product.PromoRulePlugin" checkBoxField="promo.RequirePlugin">
          <v:combobox field="promo.PosPromoRulePluginId" lookupDataSet="<%=pageBase.getBL(BLBO_Plugin.class).getPluginDS(null, LkSNDriverType.PromoRulePos)%>" captionFieldName="PluginDisplayName" idFieldName="PluginId" linkEntityType="<%=LkSNEntityType.Plugin%>" enabled="<%=canEdit%>"/>
          <v:combobox field="promo.WebPromoRulePluginId" lookupDataSet="<%=pageBase.getBL(BLBO_Plugin.class).getPluginDS(null, LkSNDriverType.PromoRuleWeb)%>" captionFieldName="PluginDisplayName" idFieldName="PluginId" linkEntityType="<%=LkSNEntityType.Plugin%>" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>   
    </v:widget>
    <% } %>
  </div>
</div>
<% JvDataSet dsCategory = pageBase.getBL(BLBO_Category.class).getCategoryAshedTreeDS(LkSNEntityType.ProductType); %>
<div id="category-template" class="v-hidden"><v:combobox lookupDataSet="<%=dsCategory%>" idFieldName="CategoryId" captionFieldName="AshedCategoryName" name="trigger-category" clazz="trigger-grid-input" enabled="<%=canEdit%>"/></div>
<div id="trigger-checkbox-template" class="v-hidden"><v:grid-checkbox name="trigger-checkbox"/></div>

<div id="templates" class="hidden">
  <table>
    <tr class="grid-row, trigger-list-row-template">
      <td>
        <v:grid-checkbox name="trigger-checkbox"/>
      </td>
      <td>
        <img class="list-icon" width="32" height="32">
      </td>
      <td>
       <a class="entity-link list-title"></a><br/>
       <span class="entity-code list-subtitle"></span>
      </td>
      <td class="entity-type">
      </td>
      <td>
        <input type="text" name="QuantityMin" class="promo-grid-input form-control"/>
      </td>
    </tr>
  </table>
</div>

<script>
//# sourceURL=promorule_tab_main.jsp
var promo;

function addProductTypeActivation() {
  showLookupDialog({
    EntityType: <%=LkSNEntityType.ProductType.getCode()%>,
    onPickup: function(item) {
      var trigger = {
          QuantityMin: 1,
          QuantityStep: 1,
          ProductId: item.ItemId,
          ProductCode: item.ItemCode,
          ProductName: item.ItemName,
          ProductIconName: item.IconName,
          ProductProfilePictureId: item.ProfilePictureId
        };        
      addActivation(trigger);
    }
  });
}

function addCategoryActivation() {
  showLookupDialog({
    EntityType: <%=LkSNEntityType.Category_ProductType.getCode()%>,
    onPickup: function(item) {
      var trigger = {
          QuantityMin: 1,
          QuantityStep: 1,
          CategoryId: item.ItemId,
          CategoryCode: item.ItemCode,
          CategoryName: item.ItemName,
          CategoryIconName: item.IconName,
          CategoryProfilePictureId: item.ProfilePictureId
        };        
      addActivation(trigger);
    }
  });
}

function addActivation(trigger) {
  trigger = (trigger) ? trigger : {
    QuantityMin: 1,
    QuantityStep: 1
  };
  
  
  var trTrigger = $("#templates .trigger-list-row-template").clone().appendTo("#activation-list-tbody"); 
  
  var entityLink = trTrigger.find(".entity-link");
  if (trigger.CategoryId) {
    trTrigger.find(".list-icon").attr("src", _getIconURL(trigger.CategoryIconName, trigger.CategoryProfilePictureId));
    entityLink.attr("href", getPageURL(<%=LkSNEntityType.Category.getCode()%>, trigger.CategoryId));
    entityLink.text(trigger.CategoryName);        
    trTrigger.find(".entity-code").text(trigger.CategoryCode);
    trTrigger.find(".entity-type").text(itl("@Category.Category"));
  } 
  else {
    trTrigger.find(".list-icon").attr("src", _getIconURL(trigger.ProductIconName, trigger.ProductProfilePictureId));
    entityLink.attr("href", getPageURL(<%=LkSNEntityType.ProductType.getCode()%>, trigger.ProductId));
    entityLink.text(trigger.ProductName);   
    trTrigger.find(".entity-code").text(trigger.ProductCode);
    trTrigger.find(".entity-type").text(itl("@Product.ProductType"));
  }
  trTrigger.data("ProductId", trigger.ProductId);
  trTrigger.data("CategoryId", trigger.CategoryId);
  trTrigger.find("input[name=QuantityMin]").attr("value", trigger.QuantityMin);

  function _getIconURL(iconName, profilePictureId) {
    return "<v:config key="site_url"/>/" + ((profilePictureId) ? "repository?type=thumb&id=" + profilePictureId : "imagecache?size=32&name=" + encodeURIComponent(iconName));
  }
}

function removeActivations() {
  var cbs = $("#activation-list-tbody [name='trigger-checkbox']:checked");
  for (var i=0; i<cbs.length; i++) {
    $(cbs[i]).closest("tr").remove();
  }
}

function getRuleActivationList() {
 var list = [];
 
 if ($("#promo\\.FilterByShopcartContent").isChecked()) {
   var trs = $("#activation-list-tbody tr");
   for (var i=0; i<trs.length; i++) {
     var tr = $(trs[i]);
     var categoryId = tr.data("CategoryId");
     var productId = tr.data("ProductId");
     
     categoryId = (categoryId == "") ? null : categoryId;
     productId = (productId == "") ? null : productId;
     if (categoryId != null)
       productId = null;
     if (productId != null)
       categoryId = null;
     
     list.push({
       TriggerType: <%=LkSNPromoTriggerType.RuleActivation.getCode()%>,
       CategoryId: categoryId,
       ProductId: productId,
       QuantityMin: strToIntDef(tr.find("[name='QuantityMin']").val(), 0),
       QuantityStep: 1
     });
   }
 }
 
 return list;
}

function combinableChanged() {
	$("#combinable-tags").setClass("v-hidden", !$("#promo\\.Combinable").isChecked());
}

function refreshNameExt() {
  $("#name-ext-container").setClass("v-hidden", !$("#promo\\.ShowNameExt").isChecked());
  $("#promo\\.ProductNameExt").attr("placeholder", $("#promo\\.ProductName").val());
}

function promoSelectionTypeChanged() {
  var hideTemplate = <%=promo.PromoRuleType.isLookup(LkSNPromoRuleType.Generic, LkSNPromoRuleType.CommonCoupon)%>;
  $("#media-template-section").setClass("v-hidden", hideTemplate);
  
  var hideHideOnPOS = <%=promo.PromoRuleType.isLookup(LkSNPromoRuleType.Generic)%> && ($("#promo\\.PromoSelectionType").val() != <%=LkSNPromoSelectionType.Manual.getCode()%>);
  $("#hide-on-pos-section").setClass("v-hidden", hideHideOnPOS);
}

function promoPeriodTypeChanged() {
  var hideFields = $("#promo\\.PeriodType").val() == "";
  $("#period-limit").setClass("hidden", hideFields);
  $("#period-max-items").setClass("hidden", hideFields);
}

function doSave() {
  
  var promoActiveFromTime = null;
  if (($("#promo\\.ActiveFromTime-HH").getComboIndex() > 0) || ($("#promo\\.ActiveFromTime-MM").getComboIndex() > 0))
    promoActiveFromTime = "1970-01-01T" + $("#promo\\.ActiveFromTime").getXMLTime();
  
  var promoActiveToTime = null;
  if (($("#promo\\.ActiveToTime-HH").getComboIndex() > 0) || ($("#promo\\.ActiveToTime-MM").getComboIndex() > 0))
    promoActiveToTime = "1970-01-01T" + $("#promo\\.ActiveToTime").getXMLTime();
  

  if (promo.PromoSelectionType == <%=LkSNPromoSelectionType.Manual.getCode()%>) {

    promo.HideOnPOS = $("#promo\\.HideOnPOS").isChecked();
    if (promo.PromoRuleType == <%=LkSNPromoRuleType.IndividualCoupon.getCode()%>)
      promo.DocTemplateId = $("#promo\\.DocTemplateId").val();
    else
      promo.DocTemplateId = null;
  }
  else {
    promo.HideOnPOS = false;
    promo.DocTemplateId = null;
  }
 
  if ($("#promo\\.Combinable").isChecked())
	  promo.CombinableTagIDs = $("#promo\\.CombinableTagIDs").val();
  else
	  promo.CombinableTagIDs = null;
	  
  if (promo.PromoSelectionType != <%=LkSNPromoSelectionType.Manual.getCode()%>) {
    promo.PromoDiscountValueMax = null;
    promo.VariableDiscount = false;
  }
  
  var associationList = [];
  var $options = $("#promo\\.AssociationIDs option:selected");
  $options.each(function() {
  	associationList.push({
  		AssociationId: $(this).val()
  	});
  })
  
  var reqDO = {
    Command: "SavePromoRule",
    SavePromoRule: {
      PromoRule: {
        ProductId                    : promo.ProductId,
        ProductCode                  : $("#promo\\.ProductCode").val(),
        ProductName                  : $("#promo\\.ProductName").val(),
        CategoryId                   : $("#promo\\.CategoryId").val(),
        ShowNameExt                  : $("[name='promo\\.ShowNameExt']").isChecked(),
        ProductNameExt               : $("#promo\\.ProductNameExt").val(),
        PromoRuleType                : promo.PromoRuleType,
        LocationId                   : $("#promo\\.LocationId").val(),
        ProductStatus                : $("#promo\\.ProductStatus").val(),
        Combinable                   : $("#promo\\.Combinable").isChecked(),
        CombinableTagIDs             : promo.CombinableTagIDs,
        TagIDs                       : $("#promo\\.TagIDs").val(),
        PrintGroupTagId              : $("[name='promo\\.PrintGroupTagId']").val(),
        FinanceGroupTagId            : $("[name='promo\\.FinanceGroupTagId'").val(),
        ProfilePictureId             : $("#promo\\.ProfilePictureId").val(),
        CalendarId                   : $("#promo\\.CalendarId").val(),
        ActiveFromTime               : promoActiveFromTime,
        ActiveToTime                 : promoActiveToTime,
        HideOnPOS                    : promo.HideOnPOS,
        ExternalCheckCouponRedeem    : $("#promo\\.ExternalCheckCouponRedeem").isChecked(),
        DocTemplateId                : ((promo.PromoSelectionType == <%=LkSNPromoSelectionType.Manual.getCode()%>) && (promo.PromoRuleType == <%=LkSNPromoRuleType.IndividualCoupon.getCode()%>)) ? $("#promo\\.DocTemplateId").val() : null,
        ValidityDateFrom             : $("#promo\\.ValidityDateFrom-picker").getXMLDateTime(),
        ValidityDateTo               : $("#promo\\.ValidityDateTo-picker").getXMLDateTime(),
        MinTrnAmount                 : strToFloatDef($("#promo\\.MinTrnAmount").val(), null),
        MinItemCount                 : strToIntDef($("#promo\\.MinItemCount").val(), null),
        MinItemAmount                : strToFloatDef($("#promo\\.MinItemAmount").val(), null),
        PrdLimit                     : strToIntDef($("#promo\\.PrdLimit").val(), null),
        PrdMaxItemCount              : strToIntDef($("#promo\\.PrdMaxItemCount").val(), null),
        PeriodType                   : $("#promo\\.PeriodType").val(),
        RuleActivationList           : getRuleActivationList(),
        PromoSelectionType           : $("#promo\\.PromoSelectionType").val(),
        PromoDiscountValue           : promo.PromoDiscountValue,
        PromoDiscountValueMax        : promo.PromoDiscountValueMax, 
        VariableDiscount             : promo.VariableDiscount,
        PromoActionTarget            : promo.PromoActionTarget,
        PromoDiscountValue           : promo.PromoDiscountValue,
        PromoDiscountType            : promo.PromoDiscountType,
        RequirePlugin                : $("[name='promo\\.RequirePlugin']").isChecked(),
        PosPromoRulePluginId         : $("[name='promo\\.RequirePlugin']").isChecked() ? $("#promo\\.PosPromoRulePluginId").val() : null,
        WebPromoRulePluginId         : $("[name='promo\\.RequirePlugin']").isChecked() ? $("#promo\\.WebPromoRulePluginId").val() : null,
        PromoRuleAssociationList     : associationList,		
        CardTypeIDs                  : $("#promo\\.CardTypeIDs").val(),
        SaleCapacityCountType        : $("[name='promo\\.SaleCapacityCountType']").val(),
        <% if (!systemCode && promo.HasLimitedCapacity.getBoolean()) { %>
        SaleCapacityCountType        : $("[name='promo\\.SaleCapacityCountType']:checked").val(),
        <%}%>
        BearedDiscount               : $("[name='promo\\.BearedDiscount']").isChecked(),
        CouponExpirationRule         : $("[name='promo\\.CouponExpirationRule']").val(),
        CouponExpirationRuleQuantity : $("[name='promo\\.CouponExpirationRuleQuantity']").val(),
        ExtMediaGroupId              : $("[name='promo\\.ExtMediaGroupId'").val()
      }
    }
  };
   
  showWaitGlass();
  vgsService("Product", reqDO, false, function(ansDO) {
    hideWaitGlass();
    entitySaveNotification(<%=LkSNEntityType.PromoRule.getCode()%>, ansDO.Answer.SavePromoRule.ProductId);
  });
}

function refreshFilterVisibility() {  
  if($("#promo\\.FilterByShopcartContent").prop('checked'))
    $("#activation-list").removeClass("v-hidden");
  else
    $("#activation-list").addClass("v-hidden");
}

$("#promo\\.FilterByShopcartContent").change(refreshFilterVisibility);


$(document).ready(function() {
  promo = <%=promo.getJSONString()%>;
  
  $("#promo\\.ProductName").keyup(refreshNameExt);
  $("#promo\\.ShowNameExt").click(refreshNameExt);
  $("#promo\\.PromoSelectionType").change(promoSelectionTypeChanged);
  $("#promo\\.PeriodType").change(promoPeriodTypeChanged);
  $("#promo\\.Combinable").change(combinableChanged);
  
  refreshNameExt();
  combinableChanged();
  
  if ((promo) && (promo.RuleActivationList)) {
    for (var i=0; i<promo.RuleActivationList.length; i++) {
      if (promo.RuleActivationList[i].TriggerType == <%=LkSNPromoTriggerType.RuleActivation.getCode()%>)
        addActivation(promo.RuleActivationList[i]);  
    }    
    $("#promo\\.FilterByShopcartContent").prop('checked', (promo.RuleActivationList.length > 0));
  }

  refreshFilterVisibility();
  hideProdRuleType = <%=promo.PromoRuleType.isLookup(LkSNPromoRuleType.IndividualCoupon, LkSNPromoRuleType.CommonCoupon)%>;
  $("#selection-type-section").setClass("v-hidden", hideProdRuleType);
  promoSelectionTypeChanged();
  promoPeriodTypeChanged();
});

function doDuplicate() {
  var reqDO = {
      Command: "GenerateDuplicateCodeName",
      GenerateDuplicateCodeName: {
        ProductCode: $("#promo\\.ProductCode").val(),
        ProductName: $("#promo\\.ProductName").val()
      }
  }
  
  vgsService("Product", reqDO, false, function(ansDO) {
    inputProductDetails(ansDO.Answer.GenerateDuplicateCodeName.CandidateProductCode, ansDO.Answer.GenerateDuplicateCodeName.CandidateProductName);
  });
  
  function inputProductDetails(productCode, productName) {
    var dlgInput = $("<div class='duplicate-input-dialog'/>");
    dlgInput.append("<div class='form-field'><div class='form-field-caption'><v:itl key='@Common.NewCode'/></div><div class='form-field-value'><input type='text' class='form-control' id='promo.CandidateProductCode' name='promo.CandidateProductCode' value='" + productCode + "'/></div></div>");
    dlgInput.append("<div class='form-field'><div class='form-field-caption'><v:itl key='@Common.NewName'/></div><div class='form-field-value'><input type='text' class='form-control' id='promo.CandidateProductName' name='promo.CandidateProductName' value='" + productName + "'/></div></div>");
    
    dlgInput.append('<div class="form-field"><div class="form-field-caption"><v:itl key="@Common.Status"/></div><div class="form-field-value"><v:lk-combobox field="newStatus" lookup="<%=LkSN.ProductStatus%>" allowNull="false"/></div></div>');
    
    dlgInput.dialog({
      title: itl("@Product.PromoRule"),
      modal: true,
      width: 550,
      height: 250,
      close: function() {
        dlgInput.remove();
      },
      buttons: [
        dialogButton("@Common.Ok", function() {
          var reqDO = {
            Command: "DuplicatePromoRule",
            DuplicatePromoRule: {
              ProductId: <%=JvString.jsString(pageBase.getId())%>,
              CandidateProductCode: $("#promo\\.CandidateProductCode").val(),
              CandidateProductName: $("#promo\\.CandidateProductName").val(),
              ProductStatus: $("#newStatus").val()
            }
          };
          dlgInput.dialog("close");
          
          showWaitGlass();
          vgsService("Product", reqDO, false, function(ansDO) {
            hideWaitGlass();
            if (ansDO.Answer.DuplicatePromoRule.CandidateCodeNameDifferent == true)
              showDuplicateResultDialog(ansDO.Answer.DuplicatePromoRule.ProductId, ansDO.Answer.DuplicatePromoRule.ProductCode, ansDO.Answer.DuplicatePromoRule.ProductName);
            else
              window.location = "<%=pageBase.getContextURL()%>?page=promorule&id=" + ansDO.Answer.DuplicatePromoRule.ProductId;
          });
        }),
        dialogButton("@Common.Cancel", doCloseDialog)
      ]
    });
  }
}
  
</script>

</v:page-form>

