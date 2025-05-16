<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="rcorule" class="com.vgs.snapp.dataobject.DORedemptionCommissionRule" scope="request"/>

<div id="tab-profile" class="tab-content">
  <v:widget caption="@Common.Profile">
    <v:widget-block>
      <v:form-field caption="@Common.Type" mandatory="true">
        <v:lk-radio field="rcorule.CommissionRuleValueType" lookup="<%=LkSN.PriceValueType%>"  allowNull="false" inline="true" onclick="onCommissionRuleValueTypeChange()"/>
      </v:form-field>
      <v:form-field caption="@RedemptionCommissionRule.CalculationAmountType" mandatory="true" >
        <v:lk-radio lookup="<%=LkSN.CalculationAmountType%>" field="rcorule.CalculationAmountType" allowNull="false" inline="true" onclick="updateMembershipPointSelection()"/>
      </v:form-field>
      <div id="membership-block">
        <v:form-field id="membership-point-selection" caption="@Product.MembershipPoint">
          <snp:dyncombo field="rcorule.MembershipPointId" entityType="<%=LkSNEntityType.RewardPoint%>" parentComboId="rcorule.membershipPointId"/>
        </v:form-field>
      </div>
    </v:widget-block>
    
    
    <v:widget-block>
      <v:form-field caption="@RedemptionCommissionRule.TypeValue" hint="@RedemptionCommissionRule.TypeValueHint" mandatory="true">
         <v:input-text field="rcorule.CommissionRuleValue" placeholder="@Common.Value" onChange="calcNetAmount()"/>
      </v:form-field>
        
      <v:form-field id="tax-included-field" caption="@RedemptionCommissionRule.TaxIncluded" checkBoxField="rcorule.TaxIncluded" multiCol="true">
        <v:multi-col caption="@Product.TaxProfile">
          <v:combobox field="rcorule.TaxProfileId" lookupDataSet="<%=pageBase.getBL(BLBO_Tax.class).getTaxProfileDS()%>" idFieldName="TaxProfileId" captionFieldName="TaxProfileName" linkEntityType="<%=LkSNEntityType.TaxProfile.getCode()%>" onchange="calcNetAmount()"/>
        </v:multi-col>
        <v:multi-col id="net-value-column" caption="@RedemptionCommissionRule.NetValue" clazz="hidden">
          <v:input-text field="rcorule.CommissionRuleNetValue" placeholder="@Common.Value" enabled="false"/>
        </v:multi-col>
      </v:form-field>
    </v:widget-block>
    
    <v:widget-block>
      <v:form-field caption="@Product.PriceFormulaTitle" mandatory="true">
        <v:lk-radio field="rcorule.CommissionRuleFormula" lookup="<%=LkSN.CommissionRuleFormulaType%>" allowNull="false" inline="true"/>
      </v:form-field>
      <v:form-field caption="@RedemptionCommissionRule.PriorityOrder" mandatory="true">
        <v:input-text field="rcorule.PriorityOrder"/>
      </v:form-field>
    </v:widget-block>
    
    <v:widget-block>
      <v:db-checkbox field="rcorule.CommissionRuleStatus" value="<%=LkSNRedemptionCommissionRuleStatus.Enabled.getCode()%>" caption="@Common.Active"/>
    </v:widget-block>
    
  </v:widget>
  <v:widget caption="@Common.Date">
    <v:widget-block>
      <v:form-field caption="@Common.FromDate">
        <v:input-text type="datepicker" field="rcorule.ValidDateFrom" placeholder="@Common.Unlimited"/>
        &nbsp;&nbsp;&nbsp; <v:itl key="@Common.To" transform="lowercase"/> &nbsp;&nbsp;&nbsp;
        <v:input-text type="datepicker" field="rcorule.ValidDateTo" placeholder="@Common.Unlimited"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
</div>

<script type="text/javascript">

calcNetAmount();
updateMembershipPointSelection();


function updateMembershipPointSelection() {
  let $calcAmountType = $("[name='rcorule\\.CalculationAmountType']:checked");
  let $membershipPointField = $("#membership-point-selection");
  if ($calcAmountType.val() == <%=LkSNCalculationAmountType.ProductPrice.getCode()%>) {
    $membershipPointField.addClass("hidden");
    $membershipPointField.find("#rcorule\\.MembershipPointId").val(null)
  } else {
    $membershipPointField.removeClass("hidden");
  }
}

function onCommissionRuleValueTypeChange() {
	calcNetAmount();
	let $taxField = $("#tax-included-field");
	let priceValueType = $("input[name='rcorule\\.CommissionRuleValueType']:checked").val();
	if (priceValueType == <%=LkSNPriceValueType.Percentage.getCode()%>) {
      resetTaxIncludedField();
      $taxField.addClass("hidden");
	}
	else if (priceValueType == <%=LkSNPriceValueType.Absolute.getCode()%>) 
	  $taxField.removeClass("hidden");
}

function resetTaxIncludedField() {
  $("#rcorule\\.TaxProfileId").val(null);
  $("#rcorule\\.CommissionRuleNetValue").val(null);
}

function calcNetAmount() {
  let $ruleNetValue = $("#rcorule\\.CommissionRuleNetValue");
  let $netValueColumn = $("#net-value-column");
  let $taxProfileCombo = $("#rcorule\\.TaxProfileId");
  let $commissionRuleValueType = $("input[name='rcorule\\.CommissionRuleValueType']:checked");
  if ($commissionRuleValueType.val() == <%=LkSNPriceValueType.Absolute.getCode()%> &&
  		$taxProfileCombo.val()) {
    let ruleValue = $("#rcorule\\.CommissionRuleValue").val().replace(",", ".");
  	let reqDO = {
  	  TaxProfile: {
        TaxProfileId: $taxProfileCombo.val()
      },
      Amount: ruleValue,
      TaxCalcType: <%=LkSNTaxCalcType.TaxIncluded.getCode()%>
    };
    
    snpAPI.cmd("Product", "CalculateTaxes", reqDO)
    	.then(ansDO => {
    	  let taxAmount = ansDO.TaxAmount;
    	  let netValue = ansDO.NetAmount;
          $ruleNetValue.val(formatCurr(netValue));
          $netValueColumn.removeClass("hidden");
    	});
  } 
  else {
	$netValueColumn.addClass("hidden")
  	$ruleNetValue.val(null);
  }
}
</script>
