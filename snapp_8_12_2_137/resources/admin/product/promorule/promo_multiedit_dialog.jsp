<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
String sProductIDs = pageBase.getNullParameter("ProductIDs");
%>

<v:dialog id="promo-multiedit-dialog" tabsView="true" width="800" height="720" title="@Common.MultiEdit" autofocus="false">

  <v:tab-group name="tab" main="true">
    <!-- GENERAL -->
    <v:tab-item-embedded tab="tabs-general" caption="@Common.General" default="true">
      <div class="tab-content">
        <div class="postbox ui-widget ">
          <div class="widget-content">
            <v:widget-block>
              <v:form-field caption="@Account.Location" checkBoxField="PromoME-Location">
                <v:combobox name="PromoME-Location-VALUE" lookupDataSet="<%=pageBase.getBL(BLBO_Account.class).getLocationDS()%>" idFieldName="AccountId" captionFieldName="DisplayName"/>
              </v:form-field>
              
              <v:form-field caption="@Common.Status" checkBoxField="PromoME-Status">
                <v:lk-combobox field="PromoME-Status-VALUE" lookup="<%=LkSN.ProductStatus%>" allowNull="false"/>
              </v:form-field>
              
              <v:form-field caption="@Category.Category" checkBoxField="PromoME-Category">
                <v:combobox name="PromoME-Category-VALUE" lookupDataSet="<%=pageBase.getBL(BLBO_Category.class).getCategoryAshedTreeDS(LkSNEntityType.PromoRule)%>" idFieldName="CategoryId" captionFieldName="AshedCategoryName" allowNull="false"/>
              </v:form-field>
              
              <v:form-field caption="@Common.Calendar" checkBoxField="PromoME-Calendar">
                <% String calendarId = null; %>              
                <v:combobox name="PromoME-Calendar-VALUE" lookupDataSet="<%=pageBase.getBL(BLBO_Calendar.class).getCalendarDS(calendarId)%>" idFieldName="CalendarId" captionFieldName="CalendarName" allowNull="false"/>
              </v:form-field>
              
              <v:form-field caption="@Common.FromDate" checkBoxField="PromoME-FromDate">
                <v:input-text type="datepicker" field="promo.ValidityDateFrom" placeholder="@Common.Unlimited"/>
              </v:form-field>
              
              <v:form-field caption="@Common.ToDate" checkBoxField="PromoME-ToDate">
                <v:input-text type="datepicker" field="promo.ValidityDateTo" placeholder="@Common.Unlimited"/>
              </v:form-field>
              
              <v:form-field caption="@Common.FromTime" checkBoxField="PromoME-FromTime">
                <v:input-text type="timepicker" field="promo.ActiveFromTime" placeholder="@Common.Unlimited"/>
              </v:form-field>
              
              <v:form-field caption="@Common.ToTime" checkBoxField="PromoME-ToTime">
                <v:input-text type="timepicker" field="promo.ActiveToTime" placeholder="@Common.Unlimited"/>
              </v:form-field>
              
              <v:form-field caption="@Product.PromoCombinable" checkBoxField="PromoME-Combinable">
                <select name="PromoME-Combinable-VALUE" class="form-control">
                  <option value="false"><v:itl key="@Common.Inactive"/></option>
                  <option value="true"><v:itl key="@Common.Active"/></option>
                </select>
              </v:form-field>
               
              <v:form-field caption="@Product.PromoBtnHideOnPOS" checkBoxField="PromoME-BtnHideOnPos">
                <select name="PromoME-BtnHideOnPos-VALUE" class="form-control">
                  <option value="false"><v:itl key="@Common.Inactive"/></option>
                  <option value="true"><v:itl key="@Common.Active"/></option>
                </select>
              </v:form-field> 
            </v:widget-block>

            <v:widget-block>
              <v:form-field caption="@Product.PrintGroup" checkBoxField="PromoME-PrintGroup">
                <v:combobox name="PromoME-PrintGroup-VALUE" lookupDataSet="<%=pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.PrintGroup)%>" idFieldName="TagId" captionFieldName="TagName" allowNull="false"/>
              </v:form-field>
              
              <v:form-field caption="@Product.FinanceGroup" checkBoxField="PromoME-FinanceGroup">
                <v:combobox name="PromoME-FinanceGroup-VALUE" lookupDataSet="<%=pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.FinanceGroup)%>" idFieldName="TagId" captionFieldName="TagName" allowNull="false"/>
              </v:form-field>
            </v:widget-block>      
          </div>
        </div>
      </div>
    </v:tab-item-embedded>

  
    <!-- CONSTRAINTS -->
    <v:tab-item-embedded tab="tabs-constraints" caption="@Product.Constraints">
      <div class="tab-content">
        <div class="postbox ui-widget ">
          <div class="widget-content">
            <v:widget-block>
              <v:form-field caption="@Product.PromoMinTrnAmount" checkBoxField="PromoME-MinTrnAmount">
                <v:input-text field="PromoME-MinTrnAmount-VALUE" placeholder="@Common.Any"/>
              </v:form-field>

              <v:form-field caption="@Product.PromoMinItemCount" checkBoxField="PromoME-MinItemCount" hint="@Product.PromoMinItemHelp">
                <v:input-text field="PromoME-MinItemCount-VALUE" placeholder="@Common.Any"/>
              </v:form-field>
              
              <v:form-field caption="@Product.PromoMinItemAmount" checkBoxField="PromoME-MinItemAmount">
                <v:input-text field="PromoME-MinItemAmount-VALUE" placeholder="@Common.Any"/>
              </v:form-field>
            </v:widget-block>        
            <v:widget-block>
              <v:form-field caption="@Product.PromoPeriodPrdMaxItemCount" checkBoxField="PromoME-PrdMaxItemCount">
                <v:input-text field="PromoME-PrdMaxItemCount-VALUE" placeholder="@Common.Unlimited"/>
              </v:form-field>
              <v:form-field id="PromoME-PeriodType" caption="@Product.PromoBenefitPeriod" checkBoxField="field-checkbox">
                <v:lk-combobox lookup="<%=LkSN.PromoPeriodType%>" allowNull="true"/>
              </v:form-field>            
              <v:form-field caption="@Product.PromoPrdNumberOfDays" checkBoxField="PromoME-PrdLimit">
                <v:input-text field="PromoME-PrdLimit-VALUE" placeholder="@Common.Unlimited"/>
              </v:form-field>
            </v:widget-block>
          </div>
        </div>
      </div>
    </v:tab-item-embedded>

  
    <!-- ACTION -->
    <v:tab-item-embedded tab="tabs-action" caption="@Product.PromoActions">
      <div class="tab-content">
        <div class="postbox ui-widget ">
          <div class="widget-content">
            <v:widget-block>
              <v:form-field caption="@Product.PromoTagFilter" checkBoxField="PromoME-Tags" hint="@Product.PromoTagFilterHelp">
                <v:multibox field="PromoME-TagIDs-VALUE" lookupDataSet="<%=pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType)%>" idFieldName="TagId" captionFieldName="TagName"/>
                <v:form-field id="PromoME-TagsOperation">
                <div id="tag-operation-type-container">
                  <label><input type="radio" name="TagOperation" value="add" checked><v:itl key="@Common.Add"/></label>&nbsp;&nbsp;&nbsp;
                  <label><input type="radio" name="TagOperation" value="remove"><v:itl key="@Common.Remove"/></label>
                </div>
                </v:form-field>  
              </v:form-field>
              
              <v:form-field caption="@Product.PromoPerformanceTagFilter" checkBoxField="PromoME-Perf-Tags" hint="@Product.PromoPerformanceTagFilterHelp">
                <v:multibox field="PromoME-Perf-TagIDs-VALUE" lookupDataSet="<%=pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.Performance)%>" idFieldName="TagId" captionFieldName="TagName"/>
                <v:form-field id="PromoME-Perf-TagsOperation">
                <div id="perf-tag-operation-type-container">
                  <label><input type="radio" name="PerfTagOperation" value="add" checked><v:itl key="@Common.Add"/></label>&nbsp;&nbsp;&nbsp;
                  <label><input type="radio" name="PerfTagOperation" value="remove"><v:itl key="@Common.Remove"/></label>
                </div>
                </v:form-field>  
              </v:form-field>

              <v:form-field caption="@Product.PromoMaxPerTrans" checkBoxField="PromoME-MaxRulePerTrans" hint="@Product.PromoMaxPerTransHelp">
                <v:input-text field="field-value" placeholder="@Common.Unlimited"/>
              </v:form-field>

            </v:widget-block>  
          </div>
        </div>
      </div>
    </v:tab-item-embedded>
  </v:tab-group>

<script>

  $(".widget-title").addClass("v-hidden");

  $(document).ready(function() {
    var dlg = $("#promo-multiedit-dialog");
    dlg.on("snapp-dialog", function(event, params) {
      params.buttons = {
        <v:itl key="@Common.Ok" encode="JS"/>: doUpdatePromoss,
        <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
      };
    });
    
    function doUpdatePromoss() {    
      var reqDO = {
            Command: "SaveMultiEditPromoRule",
            SaveMultiEditPromoRule: {
              PromoRuleIDs: <%=JvString.jsString(sProductIDs)%>,
              ProductType: <%=LkSNProductType.PromoRule.getCode()%>,
              General: {},
              GeneralPromoRule: {},
              ConstraintsPromoRule: {},
              ActionPromoRule: {}
            }
          }
          
      
      <%-- GENERAL PROMO RULE --%>
      
      if (dlg.find("[name='PromoME-Location']").isChecked())
        reqDO.SaveMultiEditPromoRule.GeneralPromoRule.LocationId =  dlg.find("[name='PromoME-Location-VALUE']").val();

      if (dlg.find("[name='PromoME-Status']").isChecked())
        reqDO.SaveMultiEditPromoRule.GeneralPromoRule.ProductStatus = $("[name='PromoME-Status-VALUE']").val();
      
      if (dlg.find("[name='PromoME-Category']").isChecked())
        reqDO.SaveMultiEditPromoRule.GeneralPromoRule.CategoryId = $("[name='PromoME-Category-VALUE']").val();
      
      if (dlg.find("[name='PromoME-Calendar']").isChecked()) 
        reqDO.SaveMultiEditPromoRule.GeneralPromoRule.CalendarId = $("[name='PromoME-Calendar-VALUE']").val();
      
      if (dlg.find("[name='PromoME-FromTime']").isChecked()) {
        if ((dlg.find("[name='promo.ActiveFromTime-HH']").getComboIndex() > 0) || (dlg.find("[name='promo.ActiveFromTime-MM']").getComboIndex() > 0)) 
          reqDO.SaveMultiEditPromoRule.GeneralPromoRule.ActiveFromTime = "1970-01-01T" + dlg.find("[name='promo.ActiveFromTime']").getXMLTime();
        else
          reqDO.SaveMultiEditPromoRule.GeneralPromoRule.ActiveFromTime = null;
      }
       
      if (dlg.find("[name='PromoME-ToTime']").isChecked()) {
        if ((dlg.find("[name='promo.ActiveToTime-HH']").getComboIndex() > 0) || (dlg.find("[name='promo.ActiveToTime-MM']").getComboIndex() > 0)) 
          reqDO.SaveMultiEditPromoRule.GeneralPromoRule.ActiveToTime = "1970-01-01T" + dlg.find("[name='promo.ActiveToTime']").getXMLTime();
        else
          reqDO.SaveMultiEditPromoRule.GeneralPromoRule.ActiveToTime = null;
      }
      
      if (dlg.find("[name='PromoME-FromDate']").isChecked()) 
       reqDO.SaveMultiEditPromoRule.GeneralPromoRule.ValidityDateFrom = dlg.find("[id='promo.ValidityDateFrom-picker']").getXMLDateTime(); 
      
      if (dlg.find("[name='PromoME-ToDate']").isChecked()) 
        reqDO.SaveMultiEditPromoRule.GeneralPromoRule.ValidityDateTo = dlg.find("[id='promo.ValidityDateTo-picker']").getXMLDateTime();
      
      if (dlg.find("[name='PromoME-Combinable']").isChecked()) 
        reqDO.SaveMultiEditPromoRule.GeneralPromoRule.Combinable = dlg.find("[name='PromoME-Combinable-VALUE']").val();

      if (dlg.find("[name='PromoME-BtnHideOnPos']").isChecked()) 
        reqDO.SaveMultiEditPromoRule.GeneralPromoRule.HideButtonOnPos = dlg.find("[name='PromoME-BtnHideOnPos-VALUE']").val();
      
      if (dlg.find("[name='PromoME-PrintGroup']").isChecked())
        reqDO.SaveMultiEditPromoRule.GeneralPromoRule.PrintGrpId = $("[name='PromoME-PrintGroup-VALUE']").val();
      
      if (dlg.find("[name='PromoME-FinanceGroup']").isChecked()) 
        reqDO.SaveMultiEditPromoRule.GeneralPromoRule.FinanceGrpId = $("[name='PromoME-FinanceGroup-VALUE']").val();

      <%-- CONSTRAINTS PROMO RULE --%>
      if (dlg.find("[name='PromoME-MinTrnAmount']").isChecked()) 
        reqDO.SaveMultiEditPromoRule.ConstraintsPromoRule.MinTrnAmount = dlg.find("[name='PromoME-MinTrnAmount-VALUE']").val();
     
      if (dlg.find("[name='PromoME-MinItemCount']").isChecked()) 
        reqDO.SaveMultiEditPromoRule.ConstraintsPromoRule.MinItemCount = dlg.find("[name='PromoME-MinItemCount-VALUE']").val();

      if (dlg.find("[name='PromoME-MinItemAmount']").isChecked()) 
        reqDO.SaveMultiEditPromoRule.ConstraintsPromoRule.MinItemAmount= dlg.find("[name='PromoME-MinItemAmount-VALUE']").val();
      
      if (dlg.find("[name='PromoME-PrdMaxItemCount']").isChecked()) 
        reqDO.SaveMultiEditPromoRule.ConstraintsPromoRule.PrdMaxItemCount = dlg.find("[name='PromoME-PrdMaxItemCount-VALUE']").val();
    
      if (dlg.find("[name='PromoME-PrdLimit']").isChecked()) 
        reqDO.SaveMultiEditPromoRule.ConstraintsPromoRule.PrdLimit = dlg.find("[name='PromoME-PrdLimit-VALUE']").val();
      
      if ($("#PromoME-PeriodType [name='field-checkbox']").isChecked())
        reqDO.SaveMultiEditPromoRule.ConstraintsPromoRule.PeriodType = $("#PromoME-PeriodType .form-field-value select").val();
        
      <%-- ACTION PROMO RULE --%>
      if (dlg.find("[name='PromoME-Tags']").isChecked()) {
        reqDO.SaveMultiEditPromoRule.ActionPromoRule.TagOperation = dlg.find("[name='TagOperation']:checked").val();
        reqDO.SaveMultiEditPromoRule.ActionPromoRule.TagIDs = dlg.find("[name='PromoME-TagIDs-VALUE']").getStringArray();
      }
      
      if (dlg.find("[name='PromoME-Perf-Tags']").isChecked()) {
        reqDO.SaveMultiEditPromoRule.ActionPromoRule.PerfTagOperation = dlg.find("[name='PerfTagOperation']:checked").val();
        reqDO.SaveMultiEditPromoRule.ActionPromoRule.PerformanceTagIDs = dlg.find("[name='PromoME-Perf-TagIDs-VALUE']").getStringArray();
      }
      
      if ($("#PromoME-MaxRulePerTrans [name='field-checkbox']").isChecked()) 
        reqDO.SaveMultiEditPromoRule.ActionPromoRule.MaxRulePerTrans = strToFloatDef($("#promo\\.MaxRulePerTrans").val(), null);;
      
      vgsService("Product", reqDO, false, function(ansDO) {
        showAsyncProcessDialog(ansDO.Answer.SaveMultiEditPromoRule.AsyncProcessId, function() {
          dlg.dialog("close");
          triggerEntityChange(<%=LkSNEntityType.PromoRule.getCode()%>);
        });
      });
    }  
  }); 
 
</script>  

</v:dialog>
