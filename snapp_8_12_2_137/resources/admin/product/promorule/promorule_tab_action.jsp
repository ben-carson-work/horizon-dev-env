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
<% boolean canEdit = rights.PromotionRules.canUpdate() && !promo.ProductType.isLookup(LkSNProductType.SystemPromo); %>
<% String sReadOnly = canEdit ? "" : " readonly=\"readonly\""; %>
<% boolean isManualSelectionType = promo.PromoSelectionType.isLookup(LkSNPromoSelectionType.Manual); %>

<style>
.var-disc-text {
  width: 150px !important;
}
</style>

<v:page-form>

<div class="tab-toolbar">
  <v:button caption="@Common.Save" fa="save" onclick="doSave()" enabled="<%=canEdit%>"/>
</div>

<div class="tab-content">
  <v:last-error/>

  <v:widget caption="@Product.Discounts">
    <v:widget-block>
     <label class="checkbox-label" title="<v:itl key="@Lookup.PromoActionTarget.TransactionHint"/>"><input type="radio" name="PromoActionTarget" value="<%=LkSNPromoActionTarget.Transaction.getCode()%>" <%=sReadOnly%>/> <v:itl key="@Lookup.PromoActionTarget.Transaction"/></label>&nbsp;&nbsp;
     <label class="checkbox-label" title="<v:itl key="@Lookup.PromoActionTarget.BonusItemsHint"/>"><input type="radio" name="PromoActionTarget" value="<%=LkSNPromoActionTarget.Item.getCode()%>" <%=sReadOnly%>/> <v:itl key="@Lookup.PromoActionTarget.BonusItems"/></label>&nbsp;&nbsp;
     <label class="checkbox-label" title="<v:itl key="@Lookup.PromoActionTarget.SingleItemHint"/>"><input type="radio" name="PromoActionTarget" value="<%=LkSNPromoActionTarget.SingleItem.getCode()%>" <%=sReadOnly%>/> <v:itl key="@Lookup.PromoActionTarget.SingleItem"/></label>&nbsp;&nbsp;
     <label class="checkbox-label" title="<v:itl key="@Lookup.PromoActionTarget.MembershipPointHint"/>"><input type="radio" name="PromoActionTarget" value="<%=LkSNPromoActionTarget.MembershipPoints.getCode()%>" <%=sReadOnly%>/> <v:itl key="@Lookup.PromoActionTarget.MembershipPoints"/></label>
     <label class="checkbox-label" title="<v:itl key="@Lookup.PromoActionTarget.SettlementHint"/>"><input type="radio" name="PromoActionTarget" value="<%=LkSNPromoActionTarget.Settlement.getCode()%>" <%=sReadOnly%>/> <v:itl key="@Lookup.PromoActionTarget.Settlement"/></label>
    </v:widget-block>
    <v:widget-block id="action-target-trn" clazz="v-hidden">
	    <v:form-field caption="@Common.Type">
	      <v:lk-combobox field="promo.PromoDiscountType" lookup="<%=LkSN.PromoActionType%>" allowNull="false" enabled="<%=canEdit%>"/>
	    </v:form-field>
        <v:form-field id="discount-field-optionset" clazz="form-field-optionset">
          <div id="variable-discount">
            <v:db-checkbox field="promo.VariableDiscount"
              caption="@Product.PromoVariableDiscount"
              hint="@Product.PromoVariableDiscountHint" value="true"
              enabled="<%=canEdit%>" />
          </div>
          <div id="disable-minimum-cap">
            <v:db-checkbox field="promo.DisableTrnMinimumCap"
              caption="@Product.PromoDisableTrnMinimumCap"
              hint="@Product.PromoDisableTrnMinimumCapHint" value="true"
              enabled="<%=canEdit%>" />
          </div>
        </v:form-field>
        <v:form-field caption="@Common.Value" clazz="v-hidden" id="fix-disc-text">
          <v:input-text field="promo.PromoDiscountValue" enabled="<%=canEdit%>"/>
	    </v:form-field>
	    <v:form-field caption="@Common.Value" clazz="v-hidden" id="var-disc-text">
	      <v:input-text field="promo.PromoDiscountValueMin" clazz="var-disc-text" enabled="<%=canEdit%>"/>&nbsp;&nbsp;
	      <v:itl key="@Common.To" transform="lowercase"/>&nbsp;&nbsp;
	      <v:input-text field="promo.PromoDiscountValueMax" clazz="var-disc-text" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
	    </v:form-field>
  	</v:widget-block>
    <v:widget-block id="action-target-mpoint" clazz="v-hidden">
      <v:form-field caption="@Product.MembershipPointTarget" hint="@Product.MembershipPointTargetHelp">
        <v:lk-combobox field="promo.PromoMPointTarget" lookup="<%=LkSN.PromoMPointTarget%>" allowNull="false" enabled="<%=canEdit%>"/>
      </v:form-field>
  	</v:widget-block>
    <v:widget-block id="action-target-tags">
      <v:form-field caption="@Product.PromoTagFilter" hint="@Product.PromoTagFilterHelp">
       <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType); %>
       <v:multibox field="promo.ActionTags" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName"/>
      </v:form-field>
      <v:form-field caption="@Product.PromoPerformanceTagFilter" hint="@Product.PromoPerformanceTagFilterHelp">
       <% JvDataSet dsPerfTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.Performance); %>
       <v:multibox field="promo.ActionPerformanceTags" lookupDataSet="<%=dsPerfTag%>" idFieldName="TagId" captionFieldName="TagName"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block id="action-max-per-trans">
      <v:form-field caption="@Product.PromoMaxPerTrans"  hint="@Product.PromoMaxPerTransHelp">
        <v:input-text field="promo.MaxRulePerTrans" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block id="action-target-item" style="background:white">
	    <v:grid id="action-list-item" style="margin-bottom:10px">
	      <thead>
	        <tr>
	          <td><v:grid-checkbox header="true"/></td>
	          <td>&nbsp;</td>
	          <td width="40%"><v:itl key="@Common.Name"/></td>
	          <td width="20%"><v:itl key="@Common.Type"/></td>
	          <td width="20%" style="white-space:nowrap"><v:itl key="@Product.PromoActionType"/></td>
	          <td width="20%" style="white-space:nowrap"><v:itl key="@Product.PromoActionValue"/></td>
	        </tr>
	      </thead>
	      <tbody id="action-list-tbody">
	      </tbody>
	      <tbody id="action-tool-tbody">
	      <tr>
	        <td colspan="100%">
	          <div class="btn-group">
	            <v:button caption="@Common.Add" fa="plus" dropdown="true" enabled="<%=canEdit%>"/>
	            <v:popup-menu bootstrap="true">
	              <v:popup-item caption="@Product.ProductType" onclick="addProductActionItem()" icon="<%=LkSNEntityType.ProductType.getIconName()%>"/>
	              <v:popup-item caption="@Common.Coupon" onclick="addCouponActionItem()" icon="promorule.png"/>
	            </v:popup-menu>
	          </div>
	          <v:button caption="@Common.Remove" fa="minus" onclick="removeActionsItem()" enabled="<%=canEdit%>"/>
	        </td>
	      </tr>
	      </tbody>
	    </v:grid>
    </v:widget-block>
    
    <v:widget-block id="action-mpoint-item" style="background:white">
	    <v:grid id="membership-point-list-item" style="margin-bottom:10px">
	      <thead>
	        <tr>
	          <td><v:grid-checkbox header="true"/></td>
	          <td>&nbsp;</td>
	          <td width="70%"><v:itl key="@Common.Name"/></td>
	          <td width="30%" style="white-space:nowrap"><v:itl key="@Product.MembershipPoints"/></td>
	        </tr>
	      </thead>
	      <tbody id="membership-point-list-tbody">
	      </tbody>
	      <tbody id="membership-point-tool-tbody">
	      <tr>
	        <td colspan="100%">
	          <div class="btn-group">
	            <v:button caption="@Common.Add" fa="plus" dropdown="false" onclick="addNewMembershipPointActionItem()" enabled="<%=canEdit%>"/>
	          </div>
	          <v:button caption="@Common.Remove" fa="minus" onclick="removeMembershipPointActionItem()" enabled="<%=canEdit%>"/>
	        </td>
	      </tr>
	      </tbody>
	    </v:grid>
    </v:widget-block>
  </v:widget>

  <v:widget caption="@Common.Conditions" id="action-conditions">
    <v:widget-block>
      <label class="checkbox-label"><input type="radio" name="ItemsTarget" value="1" <%=sReadOnly%>/> <v:itl key="@Product.PromoApplyOnce"/></label>&nbsp;&nbsp;
      <label class="checkbox-label"><input type="radio" name="ItemsTarget" value="2" <%=sReadOnly%>/> <v:itl key="@Product.PromoApplyOnCondition"/></label>&nbsp;&nbsp;
    </v:widget-block>
    <v:widget-block id="trigger-list-block" style="background:white">
      <v:grid id="trigger-list" style="margin-bottom:10px">
        <thead>
           <tr>
            <td><v:grid-checkbox header="true"/></td>
            <td>&nbsp;</td>
            <td width="40%"><v:itl key="@Common.Name"/></td>
            <td width="20%"><v:itl key="@Common.Type"/></td>
            <td width="20%" style="white-space:nowrap" title="<v:itl key="@Product.PromoTriggerQuantityMinHint"/>"><v:itl key="@Product.PromoTriggerQuantityMin"/></td>
            <td width="20%" style="white-space:nowrap" title="<v:itl key="@Product.PromoTriggerQuantityStepHint"/>"><v:itl key="@Product.PromoTriggerQuantityStep"/></td>
          </tr>
        </thead>
        <tbody id="trigger-list-tbody">
        </tbody>
        <tbody id="trigger-tool-tbody">
        <tr>
          <td colspan="100%">
            <div class="btn-group">
              <v:button caption="@Common.Add" fa="plus" dropdown="true" enabled="<%=canEdit%>"/>
              <v:popup-menu bootstrap="true">
                <v:popup-item caption="@Product.ProductType" onclick="addProductTypeTrigger()" icon="<%=LkSNEntityType.ProductType.getIconName()%>"/>
                <v:popup-item caption="@Category.Category" onclick="addCategoryTrigger()" icon="category.png"/>
                <v:popup-item caption="@Payment.WalletDeposit" onclick="addWalletDepositTrigger()" icon="wallet.png"/>
              </v:popup-menu>
            </div>
            <v:button caption="@Common.Remove" fa="minus" onclick="removeTriggers()" enabled="<%=canEdit%>"/>
          </td>
        </tr>
        </tbody>
      </v:grid>    
    </v:widget-block>
  </v:widget>

</div>

<div id="templates" class="hidden">
  <table>
    <tr class="grid-row, action-list-row-template">
	  <td>
	    <v:grid-checkbox name="action-checkbox"/>
	  </td>
      <td>
        <img class="list-icon" width="32" height="32">
      </td>
      <td>
        <a class="entity-link" target="_new"></a><br/>
        <span class="entity-code"></span>
      </td>
      <td class="entity-type">
      </td>
	    <td class="action-type">
	      <v:lk-combobox field="ActionType" lookup="<%=LkSN.PromoActionType%>" allowNull="false" clazz="promo-grid-input" enabled="<%=canEdit%>"/>
	    </td>
      <td class="action-value">
        <input type="text" name="ActionValue"  class="promo-grid-input form-control"/>
      </td>
    </tr>	
	
   <tr class="grid-row, membership-point-list-row-template">
	  <td>
	    <v:grid-checkbox name="membership-point-checkbox"/>
	  </td>
      <td>
        <img class="list-icon" width="32" height="32">
      </td>
      <td>
        <a class="entity-link"></a><br/>
        <span class="entity-code"></span>
      </td>
      <td class="membership-point-value">
        <input type="text" name="Points" class="promo-grid-input form-control"/>
      </td>
    </tr>	
	
    <tr class="grid-row trigger-list-row-template">
  	  <td>
  	    <v:grid-checkbox name="trigger-checkbox"/>
  	  </td>
      <td>
        <img class="list-icon" width="32" height="32">
      </td>
	    <td>
	     <a class="entity-link"></a><br/>
	     <span class="entity-code"></span>
	    </td>
      <td class="entity-type">
      </td>
      <td>
	    <input type="text" name="QuantityMin" title="<v:itl key="@Product.PromoTriggerQuantityMinHint"/>" class="promo-grid-input form-control"/>
      </td>
      <td>
        <input type="text" name="QuantityStep" title="<v:itl key="@Product.PromoTriggerQuantityStepHint"/>" class="promo-grid-input form-control"/>
      </td>
    </tr>	
  </table>
</div>

<script>
//# sourceURL=promorule_tab_action.jsp
var promo;

function addProductActionItem() {
  showLookupDialog({
    EntityType: <%=LkSNEntityType.ProductType.getCode()%>,
    onPickup: function(item) {
      var action = {
    		  ActionValue: 0,
          ProductId: item.ItemId,
          ProductCode: item.ItemCode,
          ProductName: item.ItemName,
          ProductIconName: item.IconName,
          ProductProfilePictureId: item.ProfilePictureId,
          ProductType: <%=LkSNProductType.Product.getCode()%>
        };        
      addActionItem(action);
    }
  });
}

function addCouponActionItem() {
  showLookupDialog({
    EntityType: <%=LkSNEntityType.Coupon.getCode()%>,
    onPickup: function(item) {
      var action = {
          ActionValue: 0,
          ProductId: item.ItemId,
          ProductCode: item.ItemCode,
          ProductName: item.ItemName,
          ProductIconName: item.IconName,
          ProductProfilePictureId: item.ProfilePictureId,
          ProductType: <%=LkSNProductType.PromoRule.getCode()%>
        };        
      addActionItem(action);
    }
  });
}
	    
function addNewMembershipPointActionItem() {
  showLookupDialog({
    EntityType: <%=LkSNEntityType.RewardPoint.getCode()%>,
    onPickup: function(item) {
      var action = {
    	  Points: 0,
          MembershipPointId: item.ItemId,
          MembershipPointCode: item.ItemCode,
          MembershipPointName: item.ItemName,
          MembershipPointIconName: item.IconName
        };        
      addMembershipPointActionItem(action);
    }
  });
}

function addMembershipPointActionItem(action) {
  action = (action) ? action : {
	  Points: 0
  };

  var trAction = $("#templates .membership-point-list-row-template").clone().appendTo("#membership-point-list-tbody");
  trAction.data("MembershipPointId", action.MembershipPointId); 

  var entityLink = trAction.find(".entity-link");

  trAction.find(".list-icon").attr("src", getPromoIconURL(action.MembershipPointIconName, null));
  entityLink.attr("href", getPageURL(<%=LkSNEntityType.RewardPoint.getCode()%>, action.MembershipPointId));
  entityLink.text(action.MembershipPointName);   
  trAction.find(".entity-code").text(action.MembershipPointCode);

  trAction.find("input[name=Points]").attr("value", action.Points);
}

function removeMembershipPointActionItem() {
  var cbs = $("#membership-point-list-item [name='membership-point-checkbox']:checked");
  for (var i=0; i<cbs.length; i++) {
    $(cbs[i]).closest("tr").remove();
  }
}

function getMembershipPointActionList() { 
  var list = [];
  var trs = $("#membership-point-list-tbody tr");
  for (var i=0; i<trs.length; i++) {
    var tr = $(trs[i]);
    var membershipPointId = tr.data("MembershipPointId");
    if (membershipPointId) {
      list.push({
    	MembershipPointId: membershipPointId,
        Points: strToFloatDef(tr.find("input[name='Points']").val(), 0)
      });
    }
  }
  return list;
}

function addActionItem(action) {
  action = (action) ? action : {
    ActionValue: 0
  };
  
  var trAction = $("#templates .action-list-row-template").clone().appendTo("#action-list-tbody");
  trAction.data("ProductId", action.ProductId);
  
  
  var entityLink = trAction.find(".entity-link");
  var entityType = (action.ProductType == <%=LkSNProductType.PromoRule.getCode()%>) ? <%=LkSNEntityType.PromoRule.getCode()%> : <%=LkSNEntityType.ProductType.getCode()%>;

  trAction.find(".list-icon").attr("src", getPromoIconURL(action.ProductIconName, action.ProductProfilePictureId));
  entityLink.attr("href", getPageURL(entityType, action.ProductId));
  entityLink.text(action.ProductName);   
  trAction.find(".entity-code").text(action.ProductCode);

  if (action.ProductType == <%=LkSNProductType.PromoRule.getCode()%>)
    trAction.find(".entity-type").text(itl("@Common.Coupon"));
  else 
    trAction.find(".entity-type").text(itl("@Product.ProductType"));

  trAction.find("input[name=ActionValue]").attr("value", action.ActionValue);
  trAction.find("select[name=ActionType]").val(action.ActionType);  
}

function removeActionsItem() {
  var cbs = $("#action-list-item [name='action-checkbox']:checked");
  for (var i=0; i<cbs.length; i++) {
    $(cbs[i]).closest("tr").remove();
  }
}

function getActionList() { 
  var list = [];
  var trs = $("#action-list-tbody tr");
  for (var i=0; i<trs.length; i++) {
    var tr = $(trs[i]);
    var productId = tr.data("ProductId");
    if (productId) {
      list.push({
        ProductId: productId,
        ActionType: strToIntDef(tr.find("select[name='ActionType']").val(), <%=LkSNPromoActionType.PercDiscount.getCode()%>),
        ActionValue: strToFloatDef(tr.find("input[name='ActionValue']").val(), 0)
      });
    }
  }
  return list;
}

function refreshActionTargetVisibility() {
  var trn = $("[name='PromoActionTarget']:checked").val();
  $("#action-target-trn").setClass("v-hidden", true);
  $("#action-target-item").setClass("v-hidden", true);
  $("#action-mpoint-item").setClass("v-hidden", true);
  $("#action-target-mpoint").setClass("v-hidden", true);
  $("#action-target-tags").setClass("v-hidden", true);
  $("#action-conditions").setClass("v-hidden", true);
  $("#action-max-per-trans").setClass("v-hidden", true);
  
  if (trn == "<%=LkSNPromoActionTarget.Transaction.getCode()%>") {
    $("#action-max-per-trans").setClass("v-hidden", false);
    $("#action-target-trn").setClass("v-hidden", false);    
    $("#action-target-tags").setClass("v-hidden", false);
    if ($("#promo\\.PromoDiscountType").val() == <%=LkSNPromoActionType.AbsPrice.getCode()%>) {
    	showIconMessage("warning", <v:itl key="@Product.PromoInvalidDiscountType" encode="JS"/>);
      $("#promo\\.PromoDiscountType").val(<%=LkSNPromoActionType.AbsDiscount.getCode()%>); 
    }
    else if ($("#promo\\.PromoDiscountType").val() == <%=LkSNPromoActionType.AbsDiscount.getCode()%>) {
      $("#action-conditions").setClass("v-hidden", false);
    }
    else if ($("#promo\\.PromoDiscountType").val() == <%=LkSNPromoActionType.PercDiscount.getCode()%>) {
    	if (promo.RuleTriggerList && (promo.RuleTriggerList.length > 0))
    		$("#action-conditions").setClass("v-hidden", false);
    }

    $("#promo\\.PromoDiscountType option[value*='<%=LkSNPromoActionType.AbsPrice.getCode()%>']").hide();
  }
  else if (trn == "<%=LkSNPromoActionTarget.Item.getCode()%>") {
    $("#action-max-per-trans").setClass("v-hidden", false);
    $("#action-target-item").setClass("v-hidden", false);
    $("#action-conditions").setClass("v-hidden", false);
  }
  else if (trn == "<%=LkSNPromoActionTarget.SingleItem.getCode()%>") {
    $("#action-max-per-trans").setClass("v-hidden", false);
    $("#action-target-trn").setClass("v-hidden", false);    
    $("#action-target-tags").setClass("v-hidden", false);    
    $("#promo\\.PromoDiscountType option[value*='<%=LkSNPromoActionType.AbsPrice.getCode()%>']").show();
  }
  else if (trn == "<%=LkSNPromoActionTarget.MembershipPoints.getCode()%>") {
    $("#action-max-per-trans").setClass("v-hidden", false);
    $("#action-mpoint-item").setClass("v-hidden", false);
    $("#action-target-mpoint").setClass("v-hidden", false);
    refreshMPointTargetVisibility();
  }
  else if (trn == "<%=LkSNPromoActionTarget.Settlement.getCode()%>") {
    $("#action-target-trn").setClass("v-hidden", false);    
    if ($("#promo\\.PromoDiscountType").val() == <%=LkSNPromoActionType.AbsPrice.getCode()%>) {
      showIconMessage("warning", <v:itl key="@Product.PromoInvalidDiscountType" encode="JS"/>);
      $("#promo\\.PromoDiscountType").val(<%=LkSNPromoActionType.AbsDiscount.getCode()%>); 
    }
    $("#promo\\.PromoDiscountType option[value*='<%=LkSNPromoActionType.AbsPrice.getCode()%>']").hide();
  }
  
  refreshDisableTrnMinimumCap();
}

function discountTypeChanged() {
  if ((($("[name='PromoActionTarget']:checked").val() == "<%=LkSNPromoActionTarget.Transaction.getCode()%>") &&
	   ($("#promo\\.PromoDiscountType").val() == <%=LkSNPromoActionType.PercDiscount.getCode()%>)) ||
	   $("[name='PromoActionTarget']:checked").val() == "<%=LkSNPromoActionTarget.Settlement.getCode()%>"){
   	promo.RuleTriggerList = [];
	}
  refreshActionTargetVisibility();
  refreshDiscountFieldOptionset();
}

function isDisableTrnMinimumCapVisible() {
	return <%=isManualSelectionType %> &&
	   ($("[name='PromoActionTarget']:checked").val() == "<%=LkSNPromoActionTarget.Transaction.getCode()%>") &&
	   ($("#promo\\.PromoDiscountType").val() == <%=LkSNPromoActionType.AbsDiscount.getCode()%>) &&
	   !$("#promo\\.VariableDiscount").prop("checked");
}

function refreshDisableTrnMinimumCap() {
	$("#disable-minimum-cap").setClass("v-hidden", !isDisableTrnMinimumCapVisible());
}

function validateActionData() {
  if (
      ($("[name='PromoActionTarget']:checked").val() == <%=LkSNPromoActionTarget.Transaction.getCode()%>) ||
      ($("[name='PromoActionTarget']:checked").val() == <%=LkSNPromoActionTarget.Settlement.getCode()%>)
     ) {
    if ($("#promo\\.PromoDiscountType").val() == <%=LkSNPromoActionType.AbsPrice.getCode()%>) {
    	showIconMessage("warning", <v:itl key="@Product.PromoInvalidDiscountType" encode="JS"/>);
      return false;
    }
    else if ($("#promo\\.PromoDiscountType").val() == <%=LkSNPromoActionType.PercDiscount.getCode()%>) {
			if (!$("#promo\\.VariableDiscount").prop('checked')) {
	      if (strToFloatDef($("#promo\\.PromoDiscountValue").val(), 0) > 100) {
	    	  $("#promo\\.PromoDiscountValue").focus();
	    	  	showIconMessage("warning", <v:itl key="@Product.PromoInvalidDiscountValue" encode="JS"/>);
	        return false;
	      }
			}
			else {
				var minValue = strToFloatDef($("#promo\\.PromoDiscountValueMin").val(), -1);
		    var maxValue = $("#promo\\.PromoDiscountValueMax").val() == "" ? -2 : strToFloatDef($("#promo\\.PromoDiscountValueMax").val(), -1);
				var errorOnMin = false;
				var errorOnMax = false;
				if ((minValue == -1) || (minValue > 100))
          errorOnMin = true;
				else if ((maxValue > 100) || ((maxValue >= 0) && (minValue > maxValue)) || (maxValue == -2) || (maxValue == -1))
				  errorOnMax = true;

				if (errorOnMin)
					$("#promo\\.PromoDiscountValueMin").focus();
				if (errorOnMax)
					$("#promo\\.PromoDiscountValueMax").focus();
				if (errorOnMin || errorOnMax) {
			  	showIconMessage("warning", <v:itl key="@Product.PromoInvalidDiscountValue" encode="JS"/>);
			    return false;					
				}
			}
    }
  }
  else if ($("[name='PromoActionTarget']:checked").val() == <%=LkSNPromoActionTarget.Item.getCode()%>) {
    var actionList = getActionList();
    if (actionList.length > 0) {
      for (var i = 0; i < actionList.length; i++) {
        var action = actionList[i];
        if (action.ActionType == <%=LkSNPromoActionType.PercDiscount.getCode()%>) {
          if (action.ActionValue > 100  || action.ActionValue < 0) {
        	  showIconMessage("warning", <v:itl key="@Product.PromoInvalidDiscountValue" encode="JS"/>);
            return false;
          }
        }
      }
    }
    else {
     	showIconMessage("warning", <v:itl key="@Product.PromoBonusItemEmpty" encode="JS"/>);
      return false;
    }
  }


  return true;
}

function addProductTypeTrigger() {
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
    	addTrigger(trigger);
    }
  });
}

function addCategoryTrigger() {
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
	      addTrigger(trigger);
	    }
	  });
	}

function addWalletDepositTrigger() {
  <%
  QueryDef qdef = new QueryDef(QryBO_Product.class);
  // Select
  qdef.addSelect(QryBO_Product.Sel.IconName);
  qdef.addSelect(QryBO_Product.Sel.ProductId);
  qdef.addSelect(QryBO_Product.Sel.ProductCode);
  qdef.addSelect(QryBO_Product.Sel.ProductName);
  qdef.addSelect(QryBO_Product.Sel.ProfilePictureId);
  // Where
  qdef.addFilter(QryBO_Product.Fil.ProductCode, "#WDEPOSIT");
  // Exec
  JvDataSet dsWallet = pageBase.execQuery(qdef);
  %>  
  
  var trigger = {
      QuantityMin: 1,
      QuantityStep: 1,
      ProductId: '<%= dsWallet.getField(QryBO_Product.Sel.ProductId) %>',
      ProductCode: '<%= dsWallet.getField(QryBO_Product.Sel.ProductCode) %>',
      ProductName: '<%= dsWallet.getField(QryBO_Product.Sel.ProductName) %>',
      ProductIconName: '<%= dsWallet.getField(QryBO_Product.Sel.IconName) %>'
    };        
  addTrigger(trigger);
}

function addTrigger(trigger) {
  trigger = (trigger) ? trigger : {
    QuantityMin: 1,
    QuantityStep: 1
  };
   
  var trTrigger = $("#templates .trigger-list-row-template").clone().appendTo("#trigger-list-tbody"); 
  
  var entityLink = trTrigger.find(".entity-link");
  if (trigger.CategoryId) {
    trTrigger.find(".list-icon").attr("src", getPromoIconURL(trigger.CategoryIconName, trigger.CategoryProfilePictureId));
    entityLink.attr("href", getPageURL(<%=LkSNEntityType.Category.getCode()%>, trigger.CategoryId));
    entityLink.text(trigger.CategoryName);    	  
    trTrigger.find(".entity-code").text(trigger.CategoryCode);
    trTrigger.find(".entity-type").text("<v:itl key="@Category.Category"/>");
  } 
  else {
	  trTrigger.find(".list-icon").attr("src", getPromoIconURL(trigger.ProductIconName, trigger.ProductProfilePictureId));
	  entityLink.attr("href", getPageURL(<%=LkSNEntityType.ProductType.getCode()%>, trigger.ProductId));
	  entityLink.text(trigger.ProductName);	  
    trTrigger.find(".entity-code").text(trigger.ProductCode);
    trTrigger.find(".entity-type").text("<v:itl key="@Product.ProductType"/>");
  }
  trTrigger.data("ProductId", trigger.ProductId);
  trTrigger.data("CategoryId", trigger.CategoryId);
  trTrigger.find("input[name=QuantityMin]").attr("value", trigger.QuantityMin);
  trTrigger.find("input[name=QuantityStep]").attr("value", trigger.QuantityStep);
}

function getPromoIconURL(iconName, profilePictureId) {
  return (profilePictureId) ? calcRepositoryURL(profilePictureId, "thumb") : calcIconName(iconName, 32);
}

function removeTriggers() {
  var cbs = $("#trigger-list [name='trigger-checkbox']:checked");
  for (var i=0; i<cbs.length; i++) {
    $(cbs[i]).closest("tr").remove();
  }
}

function getRuleTriggerList() {
	var list = [];
  var tgt = $("[name='ItemsTarget']:checked").val();
  if (tgt == 2) {
    var trs = $("#trigger-list-tbody tr");
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
        TriggerType: 1,
        CategoryId: categoryId,
        ProductId: productId,
        QuantityMin: strToIntDef(tr.find("input[name='QuantityMin']").val(), 0),
        QuantityStep: strToIntDef(tr.find("input[name='QuantityStep']").val(), 0)
      });
    }
  }

  return list;
}

function validateTriggersData(ruleTriggerList) {
  if (ruleTriggerList) {
    for (var i = 0; i < ruleTriggerList.length; i++) {
      var trigger = ruleTriggerList[i];
      if (trigger.QuantityStep <= 0) {
     		showIconMessage("warning", <v:itl key="@Product.PromoInvalidStepQtyValue" encode="JS"/>);
        return false;
      }
    }
  }
  return true;
}

function refreshTriggersVisibility() {
  var trn = $("[name='ItemsTarget']:checked").val();
  $("#trigger-list-block").setClass("v-hidden", true);
  
  if (trn == 2) 
    $("#trigger-list-block").setClass("v-hidden", false);     
}

function doSave() {
  if (validateActionData()) {
    var validTriggersData = false;

    promo.PromoActionTarget = $("[name='PromoActionTarget']:checked").val();

    var variableDiscount = $("#promo\\.VariableDiscount").prop('checked') && (promo.PromoActionTarget != <%=LkSNPromoActionTarget.Item.getCode()%>) && <%=isManualSelectionType%>;
    promo.VariableDiscount = variableDiscount;
    
    var disableTrnMinimumCap = $("#promo\\.DisableTrnMinimumCap").prop('checked') && isDisableTrnMinimumCapVisible();
    promo.DisableTrnMinimumCap = disableTrnMinimumCap;

    if (promo.PromoActionTarget == <%=LkSNPromoActionTarget.Transaction.getCode()%>) {
      promo.MaxRulePerTrans = strToFloatDef($("#promo\\.MaxRulePerTrans").val(), null);
      promo.PromoDiscountType = $("#promo\\.PromoDiscountType").val();
      if (variableDiscount) {
    	  promo.PromoDiscountValue = strToFloatDef($("#promo\\.PromoDiscountValueMin").val(), 0);
    	  promo.PromoDiscountValueMax = $("#promo\\.PromoDiscountValueMax").val() == "" ? null : strToFloatDef($("#promo\\.PromoDiscountValueMax").val(), 0);
      } 
      else { 
        promo.PromoDiscountValue = strToFloatDef($("#promo\\.PromoDiscountValue").val(), 0);
        promo.PromoDiscountValueMax = null;
      }
      promo.ActionTags = $("#promo\\.ActionTags").val();
      promo.ActionPerformanceTags = $("#promo\\.ActionPerformanceTags").val();
      promo.ActionList = [];
      if ($("#promo\\.PromoDiscountType").val() == <%=LkSNPromoActionType.PercDiscount.getCode()%>) {
        promo.RuleTriggerList = [];
        validTriggersData = true;
      }
      else {
        var ruleTriggerList = getRuleTriggerList();
        validTriggersData = validateTriggersData(ruleTriggerList);
        if (validTriggersData)
          promo.RuleTriggerList = ruleTriggerList;
      }
    } 
    else if (promo.PromoActionTarget == <%=LkSNPromoActionTarget.Item.getCode()%>) {
      promo.MaxRulePerTrans = strToFloatDef($("#promo\\.MaxRulePerTrans").val(), null);
      promo.PromoDiscountType = <%=LkSNPromoActionType.PercDiscount.getCode()%>;
      promo.PromoDiscountValue = 0;
      promo.PromoDiscountValueMax = null;
      promo.ActionTags = '';
      promo.ActionPerformanceTags = '';
      promo.ActionList = getActionList();
      var ruleTriggerList = getRuleTriggerList();
      validTriggersData = validateTriggersData(ruleTriggerList);
      if (validTriggersData)
        promo.RuleTriggerList = ruleTriggerList;
    }
    else if (promo.PromoActionTarget == <%=LkSNPromoActionTarget.SingleItem.getCode()%>) {
      promo.MaxRulePerTrans = strToFloatDef($("#promo\\.MaxRulePerTrans").val(), null);
      promo.PromoDiscountType = $("#promo\\.PromoDiscountType").val();
      if (variableDiscount) {
    	  promo.PromoDiscountValue = strToFloatDef($("#promo\\.PromoDiscountValueMin").val(), 0);
        promo.PromoDiscountValueMax = $("#promo\\.PromoDiscountValueMax").val() == "" ? null : strToFloatDef($("#promo\\.PromoDiscountValueMax").val(), 0);
      } 
      else { 
        promo.PromoDiscountValue = strToFloatDef($("#promo\\.PromoDiscountValue").val(), 0);
        promo.PromoDiscountValueMax = null;
      }
      promo.ActionTags = $("#promo\\.ActionTags").val();
      promo.ActionPerformanceTags = $("#promo\\.ActionPerformanceTags").val();
      promo.ActionList = [];
      promo.RuleTriggerList = [];
      validTriggersData = true;
    }
    else if (promo.PromoActionTarget == <%=LkSNPromoActionTarget.MembershipPoints.getCode()%>) {
      promo.MaxRulePerTrans = strToFloatDef($("#promo\\.MaxRulePerTrans").val(), null);
      promo.PromoMPointTarget = $("#promo\\.PromoMPointTarget").val();
      
      if (promo.PromoMPointTarget == <%=LkSNPromoMPointTarget.PurchasedProd.getCode()%>) {
       	promo.ActionTags = $("#promo\\.ActionTags").val();
       	promo.ActionPerformanceTags = $("#promo\\.ActionPerformanceTags").val();
        promo.RuleTriggerList = [];
        validTriggersData = true;
      }
      else if (promo.PromoMPointTarget == <%=LkSNPromoMPointTarget.Priviledge.getCode()%>) {
        promo.ActionTags = [];
        promo.ActionPerformanceTags = [];
        var ruleTriggerList = getRuleTriggerList();
        validTriggersData = validateTriggersData(ruleTriggerList);
        if (validTriggersData)
          promo.RuleTriggerList = ruleTriggerList;
      }

      promo.ActionList = [];
      promo.MembershipPointActionList = getMembershipPointActionList();
    }
    else if (promo.PromoActionTarget == <%=LkSNPromoActionTarget.Settlement.getCode()%>) {
      promo.MaxRulePerTrans = null;
      promo.PromoDiscountType = $("#promo\\.PromoDiscountType").val();
      if (variableDiscount) {
        promo.PromoDiscountValue = strToFloatDef($("#promo\\.PromoDiscountValueMin").val(), 0);
        promo.PromoDiscountValueMax = $("#promo\\.PromoDiscountValueMax").val() == "" ? null : strToFloatDef($("#promo\\.PromoDiscountValueMax").val(), 0);
      } 
      else { 
        promo.PromoDiscountValue = strToFloatDef($("#promo\\.PromoDiscountValue").val(), 0);
        promo.PromoDiscountValueMax = null;
      }
      promo.ActionTags = $("#promo\\.ActionTags").val();
      promo.ActionPerformanceTags = $("#promo\\.ActionPerformanceTags").val();
      promo.ActionList = [];
      promo.RuleTriggerList = [];
      validTriggersData = true;
    } 
        
    if (validTriggersData) {      
      var reqDO = {
          Command: "SavePromoRule",
          SavePromoRule: {
            PromoRule: {
              ProductId: promo.ProductId,
              ProductCode: promo.ProductCode,
              ProductName: promo.ProductName,
              PromoActionTarget: promo.PromoActionTarget,           
              PromoMPointTarget: promo.PromoMPointTarget,           
              VariableDiscount: promo.VariableDiscount,
              DisableTrnMinimumCap: promo.DisableTrnMinimumCap,
              MaxRulePerTrans: promo.MaxRulePerTrans,
              PromoDiscountType: promo.PromoDiscountType,
              PromoDiscountValue: promo.PromoDiscountValue, 
              PromoDiscountValueMax: promo.PromoDiscountValueMax,
              ActionTags: promo.ActionTags,
              ActionPerformanceTags: promo.ActionPerformanceTags,
              ActionList: promo.ActionList,
              MembershipPointActionList: promo.MembershipPointActionList,
              RuleTriggerList: promo.RuleTriggerList
            }
          }
        };
      
      console.log(JSON.stringify(reqDO));
      
      showWaitGlass();
      vgsService("Product", reqDO, false, function(ansDO) {
        hideWaitGlass();
        entitySaveNotification(<%=LkSNEntityType.PromoRule.getCode()%>, ansDO.Answer.SavePromoRule.ProductId, "tab=action");
      });

    }
  }
}

function refreshVariableDiscountVisibility() {
	var varDiscount = $("#promo\\.VariableDiscount").prop('checked');
	
	$("#var-disc-text").setClass("v-hidden", !varDiscount);
	$("#fix-disc-text").setClass("v-hidden", varDiscount);
	
	if (varDiscount) {
		if ($("#promo\\.PromoDiscountType").val() == <%=LkSNPromoActionType.AbsPrice.getCode()%>) {
	   	showIconMessage("warning", <v:itl key="@Product.PromoInvalidDiscountType" encode="JS"/>);
		  $("#promo\\.PromoDiscountType").val(<%=LkSNPromoActionType.AbsDiscount.getCode()%>); 
		}
		$("#promo\\.PromoDiscountType option[value*='<%=LkSNPromoActionType.AbsPrice.getCode()%>']").hide();
		
	  if ($("#promo\\.PromoDiscountType").val() == <%=LkSNPromoActionType.PercDiscount.getCode()%>) {
      if (!promo.PromoDiscountValue)
    	  $("#promo\\.PromoDiscountValueMin").val(0);
      if (!promo.PromoDiscountValueMax)
    	  $("#promo\\.PromoDiscountValueMax").val(100);
		}
	  else if ($("#promo\\.PromoDiscountType").val() == <%=LkSNPromoActionType.AbsDiscount.getCode()%>) {
      if (!promo.PromoDiscountValueMax)
    	  $("#promo\\.PromoDiscountValueMax").val(null);
	  }
	} 
	else if ($("[name='PromoActionTarget']:checked").val() == "<%=LkSNPromoActionTarget.SingleItem.getCode()%>") 
		$("#promo\\.PromoDiscountType option[value*='<%=LkSNPromoActionType.AbsPrice.getCode()%>']").show();		
}

function refreshMPointTargetVisibility() {
  var mPointTgt = $("#promo\\.PromoMPointTarget").val();
  $("#action-target-tags").setClass("v-hidden", true);
  $("#action-conditions").setClass("v-hidden", true);
  
  if (mPointTgt == <%=LkSNPromoMPointTarget.PurchasedProd.getCode()%>) 
    $("#action-target-tags").setClass("v-hidden", false);  
  else if (mPointTgt == <%=LkSNPromoMPointTarget.Priviledge.getCode()%>)
		$("#action-conditions").setClass("v-hidden", false);
}

function refreshDiscountFieldOptionset() {
  refreshVariableDiscountVisibility();
  refreshDisableTrnMinimumCap();
  $("#discount-field-optionset").setClass("v-hidden", !isDisableTrnMinimumCapVisible() && <%=!isManualSelectionType%>);
}

$(document).ready(function() {
  promo = <%=promo.getJSONString()%>;
  
  $("[name='PromoActionTarget']").change(refreshActionTargetVisibility);
  $("[name='ItemsTarget']").change(refreshTriggersVisibility);
  $("#promo\\.VariableDiscount").change(refreshVariableDiscountVisibility);
  $("#promo\\.PromoMPointTarget").change(refreshMPointTargetVisibility);
  $("#promo\\.PromoDiscountType").change(discountTypeChanged);
  $("#promo\\.VariableDiscount").change(refreshDisableTrnMinimumCap);
  
  setRadioChecked("[name='PromoActionTarget']", promo.PromoActionTarget);
  setRadioChecked("[name='PromoMPointTarget']", promo.PromoMPointTarget);
  
  $("#promo\\.PromoDiscountValueMin").val($("#promo\\.PromoDiscountValue").val());
  
  $("#promo\\.VariableDiscount").prop('checked', promo.VariableDiscount && <%=isManualSelectionType%>);
  $("#variable-discount").setClass("v-hidden", <%=!isManualSelectionType%>);
  
  $("#promo\\.DisableTrnMinimumCap").prop('checked', promo.DisableTrnMinimumCap && <%=isManualSelectionType%>);
  refreshDiscountFieldOptionset();
  
  if (promo.RuleTriggerList)
    setRadioChecked("[name='ItemsTarget']", 2);
  else
    setRadioChecked("[name='ItemsTarget']", 1);
  refreshTriggersVisibility();

  if ((promo) && (promo.MembershipPointActionList)) {
    for (var i=0; i<promo.MembershipPointActionList.length; i++) 
      addMembershipPointActionItem(promo.MembershipPointActionList[i]);    
  }
	  
  if ((promo) && (promo.ActionList)) {
    for (var i=0; i<promo.ActionList.length; i++) 
      addActionItem(promo.ActionList[i]);    
  }
	  
  if ((promo) && (promo.RuleTriggerList)) {
    for (var i=0; i<promo.RuleTriggerList.length; i++) {
      if (promo.RuleTriggerList[i].TriggerType == 1)
        addTrigger(promo.RuleTriggerList[i]);         
    }
  }

  refreshActionTargetVisibility();
  
  if (($("[name='PromoActionTarget']:checked").val() == "<%=LkSNPromoActionTarget.Transaction.getCode()%>") && 
		  ($("#promo\\.PromoDiscountType").val() == <%=LkSNPromoActionType.PercDiscount.getCode()%>) && 
		  (promo.RuleTriggerList && (promo.RuleTriggerList.length > 0)))
  	showIconMessage("warning", "'Apply on condition' option have been discontinued on percentage transaction discounts." + "\n" + "By saving this promotion rule all the conditions will be removed.");

});
</script>

</v:page-form>

