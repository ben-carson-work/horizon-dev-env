<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<v:wizard-step id="performance-create-wizard-step-sale" title="@Performance.Sale">
  <v:widget>
    <v:widget-block>
      <v:form-field caption="@Common.Status">
        <v:lk-combobox lookup="<%=LkSN.PerformanceStatus%>" allowNull="false" field="PerformanceStatus"/>
      </v:form-field>
      <v:form-field caption="@Performance.PerformanceType">
        <div><v:db-checkbox field="PerfTypeInherit" value="true" caption="@Performance.PerformanceTypeFromCalendar" checked="true"/></div>
        <% JvDataSet dsPerfType = pageBase.getBL(BLBO_PerformanceType.class).getDS(pageBase.getNullParameter("EventId")); %>
        <v:combobox field="PerformanceTypeId" lookupDataSet="<%=dsPerfType%>" idFieldName="PerformanceTypeId" captionFieldName="PerformanceTypeName"/>
      </v:form-field>
      <v:form-field caption="@Event.DynRateCode">
        <div><v:db-checkbox field="DynRateCode" value="true" caption="@Performance.DynRateCode" hint="@Performance.DynRateCodeHint" checked="true"/></div>
      </v:form-field>
      <v:form-field caption="@Common.OnSaleFrom">
        <v:input-text type="datepicker" field="OnSaleFrom" placeholder="@Common.Unlimited" />
      </v:form-field>
      <v:form-field caption="@Common.OnSaleTo">
        <v:input-text type="datepicker" field="OnSaleTo" placeholder="@Common.Unlimited" />
      </v:form-field>
      <v:form-field caption="@Performance.DeltaPriceValue" hint="@Performance.DeltaPriceHint">
        <input type="text" id="DeltaPrice" name="DeltaPrice" class="form-control">
      </v:form-field>
      <v:form-field>
        <label><input type="checkbox" id="RestrictOpenOrder" name="RestrictOpenOrder" value="true"> <v:itl key="@Common.RestrictOpenOrder"/></label>
      </v:form-field>
    </v:widget-block>
  </v:widget>


<script>

$(document).ready(function() {
  const $step = $("#performance-create-wizard-step-sale");
  const $wizard = $step.closest(".wizard");
  const $cbPerfInherit = $step.find("#PerfTypeInherit").click(_refreshPerfTypeVisibility);

  $step.vWizard("step-validate", _stepValidate);
  $step.vWizard("step-filldata", _stepFillData);

  _refreshPerfTypeVisibility();

  function _refreshPerfTypeVisibility() {
    $step.find("#PerformanceTypeId").setClass("hidden", $cbPerfInherit.isChecked());
  }
  
  function _stepValidate(callback) {
    callback();
  }
  
  function _stepFillData(data) {
    data.PerformanceTypeFromCalendar = $step.find("#PerfTypeInherit").isChecked();
    data.PerformanceTypeId           = $step.find("#PerformanceTypeId").val();
    data.DynRateCode                 = $step.find("#DynRateCode").isChecked();
    data.OnSaleFrom                  = $step.find("#OnSaleFrom").val();
    data.OnSaleTo                    = $step.find("#OnSaleTo").val();
    data.PerformanceStatus           = $step.find("#PerformanceStatus").val();
    data.RestrictOpenOrder           = $step.find("#RestrictOpenOrder").isChecked();
    data.DeltaPrice                  = getNull($step.find("#DeltaPrice").val());
  }
});

</script>
    
</v:wizard-step>
