<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="product_multiedit_revenuerecognition_js.jsp" />

<div class="tab-content">
  <div class="postbox ui-widget ">
    <v:widget-block id="date-range-section">
		<v:form-field caption="@Common.DateRange">
			<v:input-text type="datepicker" field="RevRec-DateFrom"/>
			<v:input-text type="datepicker" field="RevRec-DateTo"/>
		</v:form-field>
    <v:alert-box type="info" title="@Common.Info" style="max-height:350px;overflow:auto">
		  If date range is left empty, applying a multi-edit will affect parameters on ALL active date range tabs (if the product already exists) 
		  or will create a new tab (if it is a new product). 
		  If the date range is filled, any tab which includes dates mentioned in the specified range will be updated.
			Only the VPT default value will be affected.
		  <br/><br/>
			Example:<br/>
			<ul>
				<li>Multi edit date range selection: 1 - 9 March</li>
				<li>Two active tabs on the product exist: 1 - 8 March and 9 – 15 March</li>
				<li>When applying the update, both tabs will be updated with the new parameters</li>
			</ul>
		</v:alert-box>
    </v:widget-block>
    <v:widget-block id="breakage-block">
      <v:form-field id="ProdME-BreakageType" caption="@Product.BreakageType" checkBoxField="field-checkbox">
        <v:lk-combobox lookup="<%=LkSN.BreakageDaysType%>" field="product.BreakageType" allowNull="false"/>
      </v:form-field>
      <v:form-field id="ProdME-BreakageDays" caption="@Product.BreakageDays" checkBoxField="field-checkbox">
        <v:input-text field="product.BreakageDays"/>
      </v:form-field>
      <v:form-field id="ProdME-RevenueRecognitionType" caption="@Product.Token" checkBoxField="field-checkbox">
        <v:lk-combobox lookup="<%=LkSN.RevenueRecognitionType%>" field="product.RevenueRecognitionType" allowNull="false"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block id="gatecategory-block">
      <v:form-field id="ProdME-GateCategories" caption="@Product.GateCategory" checkBoxField="field-checkbox">
        <div class="gatecategory-box-container"/>
        <div id="add-gatecategory-btn" class="gatecategory-item-box" onclick="showGateCategoryPickupDialog()"><i class="fa fa-plus"></i></div>
        <div id="ProdME-GateCategoryOperation" class="gatecategory-selection">
          <div id="gatecategories-operation-selection-type-container">
            <div id="gatecategories-operation-type-container">
              <label><input type="radio" name="GateCategoriesOperation" value="add" checked><v:itl key="@Common.Add"/></label>&nbsp;&nbsp;&nbsp;
              <label><input type="radio" name="GateCategoriesOperation" value="update"><v:itl key="@Common.Update"/></label>&nbsp;&nbsp;&nbsp;
              <label><input type="radio" name="GateCategoriesOperation" value="remove"><v:itl key="@Common.Remove"/></label>
            </div>
          </div>
        </div>
      </v:form-field>
      <v:form-field id="ProdME-ClearingLimit" caption="@Product.ClearingLimit" checkBoxField="field-checkbox">
        <v:input-text field="product.ClearingLimit" placeholder="100%"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block id="vpt-block">
      <v:form-field id="ProdME-VisitPerTicket" caption="@Product.VPT" checkBoxField="field-checkbox">
        <v:input-text field="product.VisitPerTicket"/>
      </v:form-field>
      <v:form-field id="ProdME-AmortizationVPTCalendar" caption="@Common.Calendar" checkBoxField="field-checkbox">
        <v:combobox field="product.AmortizationVPTCalendarId" lookupDataSet="<%=pageBase.getBL(BLBO_Calendar.class).getAllCalendarDS()%>" idFieldName="CalendarId" captionFieldName="CalendarName" allowNull="false" name="field-value"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block id="amortization-block">
      <v:form-field id="ProdME-AmortizationPeriods" caption="@Product.AmortizationPeriods" checkBoxField="field-checkbox">
        <v:input-text field="product.AmortizationPeriods"/>
      </v:form-field>
      <v:form-field id="ProdME-AmortizationPeriodType" caption="@Product.AmortizationPeriodType" checkBoxField="field-checkbox">
        <v:lk-combobox lookup="<%=LkSN.AmortizationPeriodType%>" field="product.AmortizationPeriodType" allowNull="false"/>
      </v:form-field>
      <v:form-field id="ProdME-AmortizationWithinExpiration" caption="@Product.AmortizationWithinExpiration" checkBoxField="Upd_AmortizationWithinExpiration">
        <select name="field-value" class="form-control">
          <option value="false"><v:itl key="@Common.Inactive"/></option>
          <option value="true"><v:itl key="@Common.Active"/></option>
        </select>
      </v:form-field>
      <v:form-field id="ProdME-AmortizationTrigger" caption="@Product.AmortizationTrigger" checkBoxField="field-checkbox">
        <v:lk-combobox lookup="<%=LkSN.AmortizationTriggerType%>" field="product.AmortizationTrigger" allowNull="false"/>
      </v:form-field>
      <v:form-field id="ProdME-AmortizationDelay" caption="@Product.AmortizationDelay" checkBoxField="field-checkbox">
        <v:input-text field="product.AmortizationDelay"/>
      </v:form-field>
    </v:widget-block>
  </div>
</div>

<div id="revenue-date-dialog" class="v-hidden" title="Revenue Date">
  <span class="ui-helper-hidden-accessible"><input type="text"/></span>
  <v:form-field caption="@Common.FromDate">
    <v:input-text type="datepicker" field="ValidDateFrom"/>
  </v:form-field>
  <v:form-field caption="@Common.ToDate">
    <v:input-text type="datepicker" field="ValidDateTo"/>
  </v:form-field>
</div>
