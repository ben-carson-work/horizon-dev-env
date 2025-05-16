<%@page import="com.vgs.snapp.web.bko.library.BLBO_Installment"%>
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

<div class="tab-content">
  <v:widget caption="@Common.Profile" icon="profile.png">
    <v:widget-block>
      <v:form-field caption="@Common.Code" mandatory="true">
        <v:input-text field="plan.InstallmentPlanCode" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Common.Name" mandatory="true">
        <v:input-text field="plan.InstallmentPlanName" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="@Common.ValidFrom" mandatory="true">
        <v:input-text field="plan.ValidDateFrom" type="datepicker" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Common.ValidTo">
        <v:input-text field="plan.ValidDateTo" type="datepicker" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Common.Calendar">
        <% JvDataSet dsCalendar = pageBase.getBL(BLBO_Calendar.class).getCalendarDS(plan.CalendarId.getString()); %>
        <v:combobox field="plan.CalendarId" lookupDataSet="<%=dsCalendar%>" idFieldName="CalendarId" captionFieldName="CalendarName" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="@Installment.PreviewTemplate">
        <% JvDataSet dsTemplate = pageBase.getBL(BLBO_DocTemplate.class).getDocTemplateDS(LkSNDocTemplateType.InstallmentContract); %>
        <v:combobox field="plan.ContractPreviewDocTemplateId" lookupDataSet="<%=dsTemplate%>" idFieldName="DocTemplateId" captionFieldName="DocTemplateName" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Installment.PrintTemplate">
        <% JvDataSet dsTemplate = pageBase.getBL(BLBO_DocTemplate.class).getDocTemplateDS(LkSNDocTemplateType.InstallmentContract); %>
        <v:combobox field="plan.ContractDocTemplateId" lookupDataSet="<%=dsTemplate%>" idFieldName="DocTemplateId" captionFieldName="DocTemplateName" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:db-checkbox field="plan.Enabled" caption="@Common.Enabled" value="true" enabled="<%=canEdit%>"/>
      <div id="plan-channel-container">
        <v:db-checkbox field="plan.EnabledPOS" caption="@Common.PlatformPOS" value="true" enabled="<%=canEdit%>"/>&nbsp;
        <v:db-checkbox field="plan.EnabledB2C" caption="@Common.PlatformB2C" value="true" enabled="<%=canEdit%>"/>&nbsp;
        <v:db-checkbox field="plan.EnabledCLC" caption="@Common.PlatformCLC" value="true" enabled="<%=canEdit%>"/>&nbsp;
      </div>
    </v:widget-block>
  </v:widget>
</div>

<script>
$(document).ready(refreshChannelTypeVisibility);
$("#plan\\.Enabled").click(refreshChannelTypeVisibility);

function refreshChannelTypeVisibility() {
  $("#plan-channel-container").setClass("v-hidden", !$("#plan\\.Enabled").isChecked());
}
</script>