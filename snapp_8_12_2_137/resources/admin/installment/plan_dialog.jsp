<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.snapp.web.bko.library.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% boolean canEdit = rights.InstallmentPlans.canUpdate(); %>

<%
BLBO_Installment bl = pageBase.getBL(BLBO_Installment.class);
DOInstallmentPlan plan = pageBase.isNewItem() ? bl.prepareNewPlan() : bl.loadPlan(pageBase.getId()); 
String title = pageBase.isNewItem() ? pageBase.getLang().Common.SecurityRole.getText() : plan.InstallmentPlanName.getString();
request.setAttribute("plan", plan);
%>

<v:dialog id="plan_dialog" icon="installment.png" tabsView="true" title="@Installment.InstallmentPlan" width="800" height="750" autofocus="false">
  <v:tab-group name="tab" main="true">
    <v:tab-item-embedded tab="tabs-main" caption="@Common.Profile" icon="profile.png" default="true">
      <jsp:include page="plan_dialog_tab_profile.jsp"/>
    </v:tab-item-embedded>
  
    <v:tab-item-embedded tab="tabs-settings" caption="@Common.Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
      <jsp:include page="plan_dialog_tab_settings.jsp"/>
    </v:tab-item-embedded>
  
    <v:tab-item-embedded tab="tabs-notify" caption="@Common.Notifications" icon="<%=LkSNEntityType.NotifyConfig.getIconName()%>">
      <jsp:include page="plan_dialog_tab_notify.jsp"/>
    </v:tab-item-embedded>
  </v:tab-group>
  
<script>
//# sourceURL=plan_dialog.jsp

  var dlg = $("#plan_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [];
    
    <% if (canEdit) { %>
      params.buttons.push({
        text: <v:itl key="@Common.Save" encode="JS"/>,
        click: doSavePlan
      });
    <% } %>
    params.buttons.push({
      text: <v:itl key="@Common.Cancel" encode="JS"/>,
      click: doCloseDialog
    });
  });
  
  function decodePriceValue(value) {
    var result = {
      type: <%=LkSNPriceValueType.Absolute.getCode()%>,
      value: 0
    };
    value = value.replace(",", ".");
    if (value != "") {
      if (value.indexOf("%") >= 0) 
        result.type = <%=LkSNPriceValueType.Percentage.getCode()%>;
      result.value = parseFloat(value.replace("%", ""));
      if (isNaN(result.value))
        result.value = 0;
    }
    return result;
  }
  
  function doSavePlan() {
	  var feeProductId = $("#plan\\.FeeProductId").val();
    var downPayment = decodePriceValue($("#plan\\.DownPayment").val());
    var contractFee = decodePriceValue($("#plan\\.ContractFee").val());
    var productFee = decodePriceValue($("#plan\\.ProductFee").val());
    
    var reqDO = {
      Command: "SavePlan",
      SavePlan: {
        InstallmentPlan: {
          InstallmentPlanId: <%=JvString.jsString(plan.InstallmentPlanId.getString())%>,
          InstallmentPlanCode: $("#plan\\.InstallmentPlanCode").val(),
          InstallmentPlanName: $("#plan\\.InstallmentPlanName").val(),
          Enabled: $("#plan\\.Enabled").isChecked(),
          EnabledPOS: $("#plan\\.EnabledPOS").isChecked(),
          EnabledB2C: $("#plan\\.EnabledB2C").isChecked(),
          EnabledCLC: $("#plan\\.EnabledCLC").isChecked(),
          ValidDateFrom: $("#plan\\.ValidDateFrom-picker").getXMLDate(),
          ValidDateTo: $("#plan\\.ValidDateTo-picker").getXMLDate(),
          CalendarId: $("#plan\\.CalendarId").val(),
          ContractPreviewDocTemplateId: $("#plan\\.ContractPreviewDocTemplateId").val(),
          ContractDocTemplateId: $("#plan\\.ContractDocTemplateId").val(),
          PaymentCount: $("#plan\\.PaymentCount").val(),
          PaymentCycleType: $("#plan\\.PaymentCycleType").val(),
          PaymentCycleValue: $("#plan\\.PaymentCycleValue").val(),
          FirstInstallmentOffset: $("#plan\\.FirstInstallmentOffset").val(),
          DownPaymentType: downPayment.type,
          DownPaymentValue: downPayment.value,
          VariableDownPayment: $("#plan\\.VariableDownPayment").isChecked(),
          FeeProductId: $("#plan\\.FeeProductId").val(),
          ContractFeeType: feeProductId ? contractFee.type : null,
          ContractFeeValue: feeProductId ? contractFee.value : null,
          ProductFeeType: feeProductId ? productFee.type : null,
          ProductFeeValue: feeProductId ? productFee.value : null,
          MaxAttempts: $("#plan\\.MaxAttempts").val(),
          RetryAfterDays: $("#plan\\.RetryAfterDays").val(),
          AutoRenew: $("#plan\\.AutoRenew").isChecked(),
          DurationDays: $("#plan\\.DurationDays").val(),
          AutoRenewCommDays: $("#plan\\.AutoRenewCommDays").val(),
          RenewInstallmentPlanId: $("#plan\\.RenewInstallmentPlanId").val(),
          CommunicationList: []
        }
      }
    };
    
    var comms = dlg.find(".CommDocTemplate");
    for (var i=0; i<comms.length; i++) {
      var value = $(comms[i]).val();
      if (value != "") {
        reqDO.SavePlan.InstallmentPlan.CommunicationList.push({
          CommunicationType: $(comms[i]).attr("id").substr("CommType_".length),
          DocTemplateId: value
        });
      }
    }
    
    vgsService("Installment", reqDO, false, function(ansDO) {
      triggerEntityChange(<%=LkSNEntityType.InstallmentPlan.getCode()%>);
      dlg.dialog("close");
    });
  }
</script>

</v:dialog>