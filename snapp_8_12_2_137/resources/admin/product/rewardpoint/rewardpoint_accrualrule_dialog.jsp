<%@page import="com.vgs.web.library.BLBO_PayMethod"%>
<%@page import="com.vgs.web.library.BLBO_Tag"%>
<%@page import="com.vgs.snapp.dataobject.DOFullTextLookupFilters"%>
<%@page import="com.vgs.snapp.dataobject.DORewardPointAccrualRule"%>
<%@page import="com.vgs.web.library.BLBO_RewardPointAccrualRule"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
String rewardPonitAccrualRuleId = pageBase.getId();
String productId = pageBase.getNullParameter("ProductId");
String membershipPointId = pageBase.getNullParameter("MembershipPointId");

BLBO_RewardPointAccrualRule bl = pageBase.getBL(BLBO_RewardPointAccrualRule.class);
DORewardPointAccrualRule rewardPointAccrualRule = rewardPonitAccrualRuleId == null ? bl.prepareNewRewardPointAccrualRule() : bl.loadRewardPointAccrualRule(rewardPonitAccrualRuleId);
request.setAttribute("rewardPointAccrualRule", rewardPointAccrualRule);

boolean canEdit = rights.Products.getOverallCRUD().canUpdate();
%>

<v:dialog id="rewardpoint_accrual_rule_dialog" tabsView="true" width="800" title="@MembershipPoint.RewardPointAccrualRule">
  <v:tab-group name="tab" main="true">
    <v:tab-item-embedded tab="tabs-main" caption="@Common.Profile" default="true">
      <v:tab-content>

        <v:widget caption="@Common.General">
          <v:widget-block>
  		      <v:form-field caption="@Common.Status">
  		        <v:lk-combobox field="rewardPointAccrualRule.RewardPointAccrualRuleStatus" lookup="<%=LkSN.RewardPointAccrualRuleStatus%>" allowNull="false"/>
  		      </v:form-field>
            <v:form-field caption="@Common.Membership" hint="@MembershipPoint.RewardPointAccrualRulePriviledgeCardHint" include="<%=productId==null%>">
              <% 
              DOFullTextLookupFilters prodFilters = new DOFullTextLookupFilters();
              prodFilters.Product.PrivilegeCardsOnly.setBoolean(true);
              %>
              <snp:dyncombo 
              		field="rewardPointAccrualRule.ProductId" 
              		entityType="<%=LkSNEntityType.ProductType%>" 
              		filters="<%=prodFilters%>" 
              		enabled="<%=canEdit%>"/>
            </v:form-field>
            <v:form-field caption="@Product.MembershipPoint" hint="@MembershipPoint.RewardPointAccrualRulePriviledgeRewardPointHint" include="<%=membershipPointId==null%>">
              <snp:dyncombo field="rewardPointAccrualRule.MembershipPointId" entityType="<%=LkSNEntityType.RewardPoint%>" enabled="<%=canEdit%>"/>
            </v:form-field>
          </v:widget-block>
          
          <v:widget-block>
            <% String exchangeRateHint = pageBase.getLang().MembershipPoint.RewardPointAccrualRuleExchangeRateHint.getText(pageBase.getSession().getMainCurrencySymbol()); %>
            <v:form-field caption="@Currency.ExchangeRate" hint="<%=exchangeRateHint%>">
              <v:input-text field="rewardPointAccrualRule.ExchangeRate" enabled="<%=canEdit%>"/>
            </v:form-field>
   	        <% String hrefTag = "javascript:showTagPickupDialog_OLD(" + LkSNEntityType.ProductType.getCode() + ",'rewardPointAccrualRule.TagIDs')"; %>
            <v:form-field caption="@MembershipPoint.RewardPointAccrualRuleTags" hint="@MembershipPoint.RewardPointAccrualRuleTagsHint" href="<%=hrefTag%>">
  		        <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType); %>
              <v:multibox field="rewardPointAccrualRule.ProductTagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName" enabled="<%=canEdit%>"/>
            </v:form-field>
          </v:widget-block>

          <v:widget-block>
            <v:form-field caption="@MembershipPoint.RestrictPaymentMethods" hint="@MembershipPoint.RestrictPaymentMethodsHint" checkBoxField="rewardPointAccrualRule.EnableRestrictPaymentMethods">
              <v:lk-radio lookup="<%=LkSN.RestrictPaymentMethodsType%>" field="rewardPointAccrualRule.RestrictPaymentMethodsType" allowNull="false" inline="true" enabled="<%=canEdit%>"/>
              <% JvDataSet dsPayMethod = pageBase.getBL(BLBO_PayMethod.class).getPaymentMethodDS(); %>
              <v:multibox field="rewardPointAccrualRule.RestrictPaymentMethodIDs" lookupDataSet="<%=dsPayMethod%>" idFieldName="PluginId" captionFieldName="PluginDisplayName" enabled="<%=canEdit%>"/>
            </v:form-field>
          </v:widget-block>
          
          <v:widget-block>
            <v:form-field caption="@Common.Calendar" hint="@MembershipPoint.RewardPointAccrualRuleCalendarHint">
              <snp:dyncombo field="rewardPointAccrualRule.CalendarId" entityType="<%=LkSNEntityType.Calendar%>" enabled="<%=canEdit%>"/>
            </v:form-field>
            <v:form-field caption="@Common.FromDate">
              <v:input-text type="datepicker" field="rewardPointAccrualRule.ValidDateFrom" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
              &nbsp;&nbsp;&nbsp;&nbsp;<v:itl key="@Common.To"/>&nbsp;&nbsp;&nbsp;&nbsp;
              <v:input-text type="datepicker" field="rewardPointAccrualRule.ValidDateTo" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
            </v:form-field>
          </v:widget-block>
          
          
        </v:widget>
      </v:tab-content>
    </v:tab-item-embedded>
  
    <v:tab-item-embedded tab="tabs-history" caption="@Common.History" include="<%=!pageBase.isNewItem()%>">
      <jsp:include page="../../common/page_tab_historydetail.jsp"/>
    </v:tab-item-embedded>
  </v:tab-group>

<script>
//# sourceURL=rewardpoint_accrual_rule_dialog.jsp

$(document).ready(function() {
  var $dlg = $("#rewardpoint_accrual_rule_dialog");
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      <% if (canEdit) { %>
        dialogButton("@Common.Save", _saveRule),
      <% } %>
      dialogButton("@Common.Cancel", doCloseDialog)
    ];
  });
  
  $dlg.find("input[type='checkbox'][name='rewardPointAccrualRule\\.EnableRestrictPaymentMethods']").on("change", function(event) {
  	if (!this.checked) {
  		$dlg.find("#rewardPointAccrualRule\\.RestrictPaymentMethodIDs")[0].selectize.clear();
  	} else {
  		if (!$dlg.find("input[name='rewardPointAccrualRule\\.RestrictPaymentMethodsType']:checked").val())
  			$dlg.find("input[name='rewardPointAccrualRule\\.RestrictPaymentMethodsType']").first().prop("checked", true);
  	}
  });
  
  function getRestrictPaymentMethodsType() {
	  return $dlg.find("input[type='checkbox'][name='rewardPointAccrualRule\\.EnableRestrictPaymentMethods']").isChecked() ? $dlg.find("input[name='rewardPointAccrualRule\\.RestrictPaymentMethodsType']:checked").val() : null;
  }
  
  function getRestrictPaymentMethodIDs() {
	  return $dlg.find("input[type='checkbox'][name='rewardPointAccrualRule\\.EnableRestrictPaymentMethods']").isChecked() ? $dlg.find("#rewardPointAccrualRule\\.RestrictPaymentMethodIDs").val() : null;
  }
  
  function _saveRule() {
    var fixedProductId = <%=JvString.jsString(productId)%>;
    var fixedMembershipPointId = <%=JvString.jsString(membershipPointId)%>;
    var eneableRestrictPaymentMethods = $dlg.find("input[type='checkbox'][name='rewardPointAccrualRule\\.EnableRestrictPaymentMethods']").is(":checked");
    
    var reqDO = {
      RewardPointAccrualRule: {
        RewardPointAccrualRuleId: <%=rewardPointAccrualRule.RewardPointAccrualRuleId.getJsString()%>,
        RewardPointAccrualRuleStatus: $dlg.find("#rewardPointAccrualRule\\.RewardPointAccrualRuleStatus").val(),
        ProductId: $dlg.find("#rewardPointAccrualRule\\.ProductId").val(),
        MembershipPointId: $dlg.find("#rewardPointAccrualRule\\.MembershipPointId").val(),
        ExchangeRate: $dlg.find("#rewardPointAccrualRule\\.ExchangeRate").val(),
        ProductTagIDs: $dlg.find("#rewardPointAccrualRule\\.ProductTagIDs").val(),
        CalendarId: $dlg.find("#rewardPointAccrualRule\\.CalendarId").val(),
        ValidDateFrom: $dlg.find("#rewardPointAccrualRule\\.ValidDateFrom-picker").getXMLDateTime(),
        ValidDateTo: $dlg.find("#rewardPointAccrualRule\\.ValidDateTo-picker").getXMLDateTime(),
        RestrictPaymentMethodsType: getRestrictPaymentMethodsType(),
        RestrictPaymentMethodIDs: getRestrictPaymentMethodIDs(),
        EnableRestrictPaymentMethods: $dlg.find("input[type='checkbox'][name='rewardPointAccrualRule\\.EnableRestrictPaymentMethods']").isChecked()
      }
    }

    if (fixedProductId != null)
      reqDO.RewardPointAccrualRule.ProductId = fixedProductId;

    if (fixedMembershipPointId != null)
      reqDO.RewardPointAccrualRule.MembershipPointId = fixedMembershipPointId;
    
    snpAPI.cmd("RewardPointAccrualRule", "Save", reqDO).then(ansDO => {
      <% if (productId != null) { %>
        entitySaveNotification(<%=LkSNEntityType.ProductType.getCode()%>, fixedProductId, "tab=rewardpointaccrual&productid=" + fixedProductId);
      <% } else if (membershipPointId != null) { %>
        entitySaveNotification(<%=LkSNEntityType.RewardPoint.getCode()%>, fixedMembershipPointId, "tab=rewardpointaccrual&membershippointid=" + fixedMembershipPointId);
      <% } else { %>
        triggerEntityChange(<%=LkSNEntityType.RewardPointAccrualRule.getCode()%>);
      <% } %>
      $dlg.dialog("close");
    });
  }
});
</script>  

</v:dialog>