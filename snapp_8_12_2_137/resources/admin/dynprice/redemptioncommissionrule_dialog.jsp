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

<%
BLBO_RedemptionCommissionRule bl = pageBase.getBL(BLBO_RedemptionCommissionRule.class);
DORedemptionCommissionRule rcorule = pageBase.isNewItem() ? bl.prepareNewRedemptionCommissionRule() : bl.loadRedemptionCommissionRule(pageBase.getId());
request.setAttribute("rcorule", rcorule);
%>

<v:dialog id="rcorule_dialog" title="@RedemptionCommissionRule.RedemptionCommissionRule" tabsView="true" width="800" height="600">

<v:tab-group name="tab" main="true">

  <%-- PROFILE --%>
  <v:tab-item-embedded tab="tabs-profile" caption="@Common.Profile" fa="info-circle" default="true">
    <jsp:include page="redemptioncommissionrule_dialog_tab_profile.jsp"/>
  </v:tab-item-embedded>

  <%-- RESTRICTIONS --%>
  <v:tab-item-embedded tab="tabs-restriction" caption="@Common.Restrictions" fa="filter">
    <jsp:include page="redemptioncommissionrule_dialog_tab_restriction.jsp"/>
  </v:tab-item-embedded> 
	
  <%-- HISTORY --%>
  <% if (!pageBase.isNewItem() && rights.History.getBoolean()) { %>
    <v:tab-item-embedded tab="tabs-history" caption="@Common.History" fa="history">
      <jsp:include page="../common/page_tab_historydetail.jsp"/>
    </v:tab-item-embedded>
  <% } %>
</v:tab-group>

<script>

$(document).ready(function() {
  var $dlg = $("#rcorule_dialog");
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        text: itl("@Common.Save"),
        click: doSaveRedemptionCommissionRule
      },
      {
        text: itl("@Common.Cancel"),
        click: doCloseDialog
      }
      
    ];
  });

  function doSaveRedemptionCommissionRule() {
    if ($dlg.find("[name='rcorule\\.CalculationAmountType']:checked").val() != <%=LkSNCalculationAmountType.ProductPrice.getCode()%> &&
    		$dlg.find("#rcorule\\.MembershipPointId").val() == "")
      showMessage(itl("@Payment.RewardPointNotFound"));
    else if ($dlg.find("#rcorule\\.CommissionRuleValue").val() == "")
      showMessage(itl("@Common.InvalidValue"));
    else {
      var reqDO = {
        Command: "Save",
        Save: {
          RedemptionCommissionRule: {
            RedemptionCommissionRuleId: <%=pageBase.isNewItem() ? null : rcorule.RedemptionCommissionRuleId.getJsString()%>,
            LocationId: $dlg.find("#rcorule\\.LocationId").val(),
            OpAreaId: $dlg.find("#rcorule\\.OpAreaId").val(),
            AccessPointId: $dlg.find("#rcorule\\.AccessPointId").val(),
            MembershipPointId: $dlg.find("#rcorule\\.MembershipPointId").val(),
            ValidDateFrom: $dlg.find("#rcorule\\.ValidDateFrom-picker").getXMLDate(),
            ValidDateTo: $dlg.find("#rcorule\\.ValidDateTo-picker").getXMLDate(),
            CommissionRuleValueType: $("input[name='rcorule\\.CommissionRuleValueType']:checked").val(),
            CommissionRuleValue: $dlg.find("#rcorule\\.CommissionRuleValue").val().replace(",", "."),
            CommissionRuleFormula: $dlg.find("input[name='rcorule\\.CommissionRuleFormula']:checked").val(),
            CommissionRuleStatus: $dlg.find("#rcorule\\.CommissionRuleStatus").isChecked() ? <%=LkSNRedemptionCommissionRuleStatus.Enabled.getCode()%> : <%=LkSNRedemptionCommissionRuleStatus.Disabled.getCode()%>,
            PriorityOrder: $dlg.find("#rcorule\\.PriorityOrder").val(),
            CalculationAmountType: $dlg.find("[name='rcorule\\.CalculationAmountType']:checked").val(),
            SaleChannelIDs: $dlg.find("#rcorule\\.SaleChannelIDs").val(),
            EventIDs: $dlg.find("#rcorule\\.EventIDs").val(),
            ProductTagIDs: $dlg.find("#rcorule\\.ProductTagIDs").val(),
            TaxProfileId: $dlg.find('input[name="rcorule.TaxIncluded"]').is(':checked') ? $dlg.find("#rcorule\\.TaxProfileId").val() : null
          }
        }
      };
      
      showWaitGlass();
      vgsService("RedemptionCommissionRule", reqDO, false, function(ansDO) {
        hideWaitGlass();
        triggerEntityChange(<%=LkSNEntityType.RedemptionCommissionRule.getCode()%>);
        $dlg.dialog("close");
      });
    }
  }
});

</script>

</v:dialog>