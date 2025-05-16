<%@page import="com.vgs.vcl.*"%>
<%@page import="java.text.DateFormatSymbols"%>
<%@page import="com.vgs.cl.document.*"%>
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
<jsp:useBean id="plan" class="com.vgs.snapp.dataobject.DOInstallmentPlan" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% boolean canEdit = rights.InstallmentPlans.canUpdate(); %>

<%!
private String encodePriceValue(FtLookup<LkSNPriceValueType> priceValueType, FtCurrency value) {
  String result = String.valueOf(value);
  if (priceValueType.isLookup(LkSNPriceValueType.Percentage))
    result += "%";
  return result;
}
%>

<%
request.setAttribute("plan.DownPayment", encodePriceValue(plan.DownPaymentType, plan.DownPaymentValue));
request.setAttribute("plan.ContractFee", encodePriceValue(plan.ContractFeeType, plan.ContractFeeValue));
request.setAttribute("plan.ProductFee", encodePriceValue(plan.ProductFeeType, plan.ProductFeeValue));
%>
  
<div class="tab-content">
  <v:widget caption="@Common.Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
    <v:widget-block>
      <v:form-field caption="@Installment.PaymentCount">
        <v:input-text field="plan.PaymentCount" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Installment.FirstInstallmentOffset" hint="@Installment.FirstInstallmentOffsetHint">
        <v:input-text field="plan.FirstInstallmentOffset" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Installment.PaymentCycle" hint="@Installment.PaymentCycleHint">
        <table style="width:100%;border-spacing:0">
          <tr>
            <td><v:lk-combobox field="plan.PaymentCycleType" lookup="<%=LkSN.PaymentCycleType%>" allowNull="false" enabled="<%=canEdit%>"/></td>
            <td><v:input-text field="plan.PaymentCycleValue" enabled="<%=canEdit%>"/></td>
          </tr>
        </table>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="@Installment.DownPayment" hint="@Installment.DownPaymentHint">
        <v:input-text field="plan.DownPayment" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field><v:db-checkbox field="plan.VariableDownPayment" caption="@Installment.VariableDownPayment" value="true" enabled="<%=canEdit%>"/></v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="@Installment.FeeType" hint="@Installment.FeeTypeHint">
        <% JvDataSet dsFee = pageBase.getBL(BLBO_Product.class).getFeeLookupDS(plan.FeeProductId.getString()); %>
        <v:combobox field="plan.FeeProductId" lookupDataSet="<%=dsFee%>" idFieldName="ProductId" captionFieldName="ProductName" enabled="<%=canEdit%>"/>
      </v:form-field>
      <div id="fee-block">
	      <v:form-field caption="@Installment.ContractFee" hint="@Installment.ContractFeeHint">
	        <v:input-text field="plan.ContractFee" enabled="<%=canEdit%>"/>
	      </v:form-field>
	      <v:form-field caption="@Installment.ProductFee" hint="@Installment.ProductFeeHint">
	        <v:input-text field="plan.ProductFee" enabled="<%=canEdit%>"/>
	      </v:form-field>
	    </div>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="@Installment.MaxAttempts" hint="@Installment.MaxAttemptsHint">
        <v:input-text field="plan.MaxAttempts" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Installment.RetryAfterDays" hint="@Installment.RetryAfterDaysHint">
        <v:input-text field="plan.RetryAfterDays" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:db-checkbox caption="@Installment.AutoRenewal" value="true" field="plan.AutoRenew" enabled="<%=canEdit%>"/>
      <div id="auto-renew-block" style="margin-top:10px">
	      <v:form-field caption="@Installment.DurationDays" hint="@Installment.DurationDaysHint">
	        <v:input-text field="plan.DurationDays" enabled="<%=canEdit%>"/>
	      </v:form-field>
	      <v:form-field caption="@Installment.AutoRenewCommDays" hint="@Installment.AutoRenewCommDaysHint">
	        <v:input-text field="plan.AutoRenewCommDays" enabled="<%=canEdit%>"/>
	      </v:form-field>
	      <v:form-field caption="@Installment.RenewToPlan">
	        <% JvDataSet dsPlan = pageBase.getBL(BLBO_Installment.class).getPlanDS(plan.InstallmentPlanId.getString()); %>
	        <v:combobox field="plan.RenewInstallmentPlanId" lookupDataSet="<%=dsPlan%>" idFieldName="InstallmentPlanId" captionFieldName="InstallmentPlanName" enabled="<%=canEdit%>"/>
	      </v:form-field>
      </div>
    </v:widget-block>
  </v:widget>
</div>

<script>
//# sourceURL=plan_dialog_tab_settings.jsp
  $(document).ready(function() {
    $("#plan\\.AutoRenew").setChecked(<%=(plan.DurationDays.getInt() > 0)%>);
    enableDisableFee();
    enableDisableAutoRenew();
  });
  function enableDisableFee() {
    $("#fee-block").setClass("v-hidden", $("#plan\\.FeeProductId").val() == "");
  }
  function enableDisableAutoRenew() {
    $("#auto-renew-block").setClass("v-hidden", !$("#plan\\.AutoRenew").isChecked());
  }
  $("#plan\\.FeeProductId").click(enableDisableFee);
  $("#plan\\.AutoRenew").click(function() {
    if ($(this).isChecked() && (parseInt($("#plan\\.DurationDays").val()) < 1))
      $("#plan\\.DurationDays").val("1");
    enableDisableAutoRenew();
  });
</script>