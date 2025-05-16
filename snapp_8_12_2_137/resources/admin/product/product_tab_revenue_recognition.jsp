<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProduct" scope="request"/>
<jsp:useBean id="product" class="com.vgs.snapp.dataobject.DOProduct" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%
boolean canEdit = pageBase.getRightCRUD().canUpdate();
String sReadOnly = canEdit ? "" : "readonly=\"readonly\""; 
String sDisabled = canEdit ? "" : "disabled=\"disabled\"";
String[] parentIDs = EntityTree.getIDs(pageBase.getConnector(), LkSNEntityType.ProductType, pageBase.getId());
JvDataSet dsPerfTypeAll = pageBase.getBL(BLBO_PerformanceType.class).getDS(parentIDs);
JvDataSet dsSaleChannelAll = pageBase.getBL(BLBO_SaleChannel.class).getSaleChannelLookupDS((LookupItem)null);
JvDataSet dsCalendarAll = pageBase.getBL(BLBO_Calendar.class).getAllCalendarDS();
JvDataSet dsLocation = pageBase.getBL(BLBO_Account.class).getAccountDS(LkSNEntityType.Location);

request.setAttribute("dsPerfTypeAll", dsPerfTypeAll);
request.setAttribute("dsSaleChannelAll", dsSaleChannelAll);
request.setAttribute("dsLocation", dsLocation);
%>

<div class="tab-toolbar">
  <v:button caption="@Common.Save" fa="save" onclick="Save()" enabled="<%=canEdit%>"/>
<%--   <v:button id="add-gate-category-button" caption="@Product.AddGateCategory" fa="plus" onclick="showGateCategoryPickupDialog()" enabled="<%=canEdit%>"/> --%>
</div>

<div class="tab-content" style="min-height:300px; overflow:hidden">

   <div id="matrix-container">
    <ul id="matrix-tabs" class="matrix-tab">
      <li class="matrix-tab-plus"><i class="fa fa-plus"></i></li> 
    </ul>
  </div>

<v:profile-recap>
  <v:widget caption="@Ticket.Breakage">
    <v:widget-block id="breakage-block">
      <v:itl key="@Common.Type"/><span class="form-field-hint form-field-hint-link v-tooltip hint-tooltip" data-jsp="product/product_revenue_recognition_breakage_hint"></span><br/>
      <v:lk-combobox lookup="<%=LkSN.BreakageDaysType%>" field="product.BreakageDaysType" allowNull="false" enabled="<%=canEdit%>"/><br/><br/>
  
      <div id="breakage-days-block">
        <v:itl key="@Common.Days"/><br/>
        <v:input-text field="product.BreakageDays"  enabled="<%=canEdit%>"/>
      </div>
    </v:widget-block>
  </v:widget>
  
  <v:widget caption="@Product.Token">
    <v:widget-block id="general-block">
      <v:lk-radio lookup="<%=LkSN.RevenueRecognitionType%>" field="product.RevenueRecognitionType" allowNull="false" inline="true" enabled="<%=canEdit%>"/>
    </v:widget-block>
  </v:widget>
  
  <v:widget caption="@Common.Options">
    <v:widget-block id="general-block">
      <v:db-checkbox caption="@Product.GateCategoryDynamicClearing" hint="@Product.GateCategoryDynamicClearingHint" value="true" field="product.DynamicClearing" enabled="<%=canEdit%>"/><br/>
      <div id="dynamic-block">
        <br/>
	      <v:lk-radio 
	            lookup="<%=LkSN.GateCategoryConfigurationType%>" 
	            field="product.GateCategoryConfigurationType" 
	            allowNull="false" 
	            inline="true"
	            hideItems="<%=LookupManager.getArray(LkSNGateCategoryConfigurationType.Static)%>" 
	            enabled="<%=canEdit%>"/>
      </div>
    </v:widget-block>
  </v:widget>
  
  <v:grid id="location-weight-grid">
    <thead>
      <v:grid-title caption="@Ledger.LocationWeight" hintLink="product/product_revenue_recognition_location_weight_hint"/>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td width="70%"><v:itl key="@Account.Location"/></td>
        <td width="30%"><v:itl key="@Ledger.Weight"/>&nbsp;(%)</td>
      </tr>
    </thead>
    <tbody name="location-weight-grid-body">
    </tbody>
    <tbody>
      <tr>
        <td colspan="100%">
          <v:button caption="@Common.Add" fa="plus" href="javascript:addRevenueWeight()"/>
          <v:button caption="@Common.Remove" fa="minus" href="javascript:removeRevenueWeight()"/>
        </td>
      </tr>
    </tbody>
  </v:grid>
  
  <div id="location-account-template" class="hidden">
    <v:combobox field="product.LocationAccountId" lookupDataSetName="dsLocation" idFieldName="AccountId" captionFieldName="DisplayName" linkEntityType="<%=LkSNEntityType.Location.getCode()%>"/>
  </div>
  
</v:profile-recap>

<v:profile-main>
  <div class="form-toolbar">
    <v:button id="add-gate-category-button" caption="@Product.AddGateCategory" fa="plus" onclick="showGateCategoryPickupDialog()" enabled="<%=canEdit%>"/>
  </div>
  <div id="gatecategory-perc-description" class="hidden"><v:alert-box type="info"><v:itl key="@Product.GateCategoryPercRuledescription"/></v:alert-box></div>
  <div id="revenue-matrix-list"></div>
</v:profile-main>

  <div id="revrec-templates" class="hidden">
    <v:widget clazz="gatecategory-widget" caption=" ">
      <v:widget-block id="general-block">
        <v:form-field hint="@SaleChannel.PriceRuleHint" caption="@Product.ClearingLimit">
          <v:input-text field="product.ClearingLimit" placeholder="100%" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field>
          <v:db-checkbox field="product.ApplyOnTotal" value="true" caption="@Product.RevRec_ApplyOnTotal" hint="@Product.RevRec_ApplyOnTotalHint" enabled="<%=canEdit%>"/>
          &nbsp;&nbsp;&nbsp;
          <v:db-checkbox field="product.ExtractFromGross" value="true" caption="@Product.RevRec_ExtractFromGross" hint="@Product.RevRec_ExtractFromGrossHint" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
      
      <div id="amortization-block">
        <v:widget-block>
          <v:form-field caption="@Product.AmortizationPeriods" hint="@Product.AmortizationPeriodsHint">
            <v:input-text field="product.AmortizationPeriods" placeholder="Auto" enabled="<%=canEdit%>"/>
          </v:form-field>      
          <v:form-field caption="@Product.AmortizationPeriodType" mandatory="true">
            <v:lk-combobox lookup="<%=LkSN.AmortizationPeriodType%>" field="product.AmortizationPeriodType" allowNull="false" enabled="<%=canEdit%>"/>
          </v:form-field>
          <v:form-field id="amortization-calendar-block" caption="@Common.Calendar">
            <v:combobox field="product.AmortizationCalendarId" lookupDataSet="<%=pageBase.getBL(BLBO_Calendar.class).getAllCalendarDS()%>" idFieldName="CalendarId" captionFieldName="CalendarName" allowNull="false" enabled="<%=canEdit%>"/>
          </v:form-field>
          <v:form-field clazz="form-field-optionset">
            <v:db-checkbox field="product.AmortizationWithinExpiration" caption="@Product.AmortizationWithinExpiration" hint="@Product.AmortizationWithinExpirationHint" value="true" enabled="<%=canEdit%>"/>
          </v:form-field>
        </v:widget-block>
        <v:widget-block>
          <v:form-field caption="@Product.AmortizationTrigger" hintLink="product/product_revenue_recognition_amortization_trigger_hint" mandatory="true">
            <v:lk-combobox lookup="<%=LkSN.AmortizationTriggerType%>" field="product.AmortizationTrigger" allowNull="false" enabled="<%=canEdit%>"/>
          </v:form-field>
          <v:form-field id="amortization-delay-block" caption="@Product.AmortizationDelay" hint="@Product.AmortizationDelayHint">
            <v:input-text field="product.AmortizationDelay" placeholder="0" enabled="<%=canEdit%>"/>
          </v:form-field>
        </v:widget-block>
      </div>

      <v:widget-block id="vpt-block">
        <v:form-field caption="@Product.VPT">
          <v:input-text field="VisitPerTicket" clazz="vpt-text" enabled="<%=canEdit%>"/>
          <label class="checkbox-label"><input type="checkbox" class="ShowMatrix"/> Show matrix </label>
          <div class="matrix"><table class="matrix-grid"></table></div>
        </v:form-field>
        <v:form-field id="vpt-calendar-block" caption="@Common.Calendar">
          <v:combobox field="product.CalendarId" lookupDataSet="<%=pageBase.getBL(BLBO_Calendar.class).getAllCalendarDS()%>" idFieldName="CalendarId" captionFieldName="CalendarName" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
    </v:widget>
  </div>
  
  <div id="revenue-date-dialog" class="v-hidden" title="Revenue Date">
    <span class="ui-helper-hidden-accessible"><input type="text"/></span>
    <v:form-field caption="@Common.FromDate">
      <v:input-text type="datepicker" field="ValidDateFrom" enabled="<%=canEdit%>"/>
    </v:form-field>
    <v:form-field caption="@Common.ToDate">
      <v:input-text type="datepicker" field="ValidDateTo" enabled="<%=canEdit%>"/>
    </v:form-field>
  </div>

  <div id="revenue-setup-dialog" class="v-hidden" title="<v:itl key="@Product.RevenueSetupDialog"/>">
    <table style="width:100%">
      <tr valign="top">
        <td width="50%">
          <v:grid>
            <thead>
              <tr>
                <td><v:grid-checkbox header="true"/></td>
                <td width="100%"><v:itl key="@SaleChannel.SaleChannels"/></td>
              </tr>
            </thead>
            <tbody>
              <v:grid-row dataset="<%=dsSaleChannelAll%>">
                <td><v:grid-checkbox name="SaleChannelId" dataset="<%=dsSaleChannelAll%>" fieldname="SaleChannelId"/></td>
                <td><%=dsSaleChannelAll.getField(QryBO_SaleChannel.Sel.SaleChannelName).getHtmlString()%></td>
              </v:grid-row>
            </tbody>
          </v:grid>
        </td>
        <td>&nbsp;</td>
        <td width="50%">
          <v:grid>
            <thead>
              <tr>
                <td><v:grid-checkbox header="true"/></td>
                <td width="100%"><v:itl key="@Performance.PerformanceTypes"/></td>
              </tr>
            </thead>
            <tbody>
              <v:grid-row dataset="<%=dsPerfTypeAll%>">
                <td><v:grid-checkbox name="PerformanceTypeId" dataset="<%=dsPerfTypeAll%>" fieldname="PerformanceTypeId"/></td>
                <td><%=dsPerfTypeAll.getField(QryBO_PerformanceType.Sel.PerformanceTypeName).getHtmlString()%></td>
              </v:grid-row>
            </tbody>
          </v:grid>
        </td>
      </tr>
    </table>  
  </div>
  
  <div id="revenue-edit-dialog" class="v-hidden" title="Revenue Edit">
    <input type="hidden" id="pt-hidden"/>
    <input type="hidden" id="sc-hidden"/>
    <table class="form-table">
      <tr valign="top">
        <td width="50%" style="line-height:20px">
          <div id="amount-container">
            <input type="text" id="cell-value-edit" placeholder="<v:itl key="@Common.Value"/>" class="form-control" style="margin-top:10px"/><br/>
          </div>
        </td>
      </tr>
    </table>
  </div>

  <div id="price-templates" class="hidden">
    <ul>
      <li class="matrix-tab">
        <div class="matrix-tab-text">
          <div class="matrix-tab-serial"></div>
          <div class="matrix-tab-caption"></div>
        </div>
        <div class="matrix-tab-remove matrix-tab-btn"><i class="fa fa-times"></i></div>
        <div class="matrix-tab-edit matrix-tab-btn"><i class="fa fa-pencil"></i></div>
      </li>
    </ul>
  </div>

</div>

<jsp:include page="product_tab_revenue_recognition_js.jsp"/>
<jsp:include page="product_tab_revenue_recognition_css.jsp"/>