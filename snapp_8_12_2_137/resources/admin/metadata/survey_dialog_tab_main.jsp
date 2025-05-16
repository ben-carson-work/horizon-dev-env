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
<jsp:useBean id="survey" class="com.vgs.snapp.dataobject.DOSurvey" scope="request"/>
<% boolean canEdit = rights.SettingsCustomForms.getBoolean(); %>

<%
request.setAttribute("surveySalRules", survey.SaleRules);
request.setAttribute("surveyTrnRules", survey.TransactionRules);
%>

<div class="tab-content">
  <v:widget caption="@Common.Profile">
    <v:widget-block>
      <v:form-field caption="@Common.Code" mandatory="true">
        <v:input-text field="survey.SurveyCode" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Common.Name" mandatory="true">
        <v:input-text field="survey.SurveyName" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
    
    <v:widget-block>
      <v:form-field caption="@Common.Type" mandatory="true">
        <v:lk-combobox field="survey.SurveyType" lookup="<%=LkSN.SurveyType%>" allowNull="false" enabled="<%=canEdit%>"/>
      </v:form-field>
      <div id="survey-sale-options" class="v-hidden">
        <v:form-field caption="@Common.Properties">
          <v:lk-combobox field="surveySalRules.SaleType" lookup="<%=LkSN.SurveySaleType%>" allowNull="false" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field id="order-sale-owner-category" caption="@Common.OwnerAccountCategory">
          <% JvDataSet dsCat = pageBase.getBL(BLBO_Category.class).getCategoryAshedTreeDS(LkSNEntityType.Person, LkSNEntityType.Organization); %>
          <v:multibox field="surveySalRules.OrderOwnerCategoryIDs" lookupDataSet="<%=dsCat%>" idFieldName="CategoryId" captionFieldName="AshedCategoryName"/>
      	</v:form-field>
        <v:form-field caption="@Common.SurveyFilterTaxes" hint="@Common.SurveyFilterTaxesHint">
          <v:boolcombobox name="surveySalRules.TaxExempt" id="surveySalRules.TaxExempt" value="surveySalRules.TaxExempt" captionNullField="@Common.Always" captionFalseField="@Common.NotTaxExempt" captionTrueField="@Sale.TaxExempt"/>
        </v:form-field>
      </div>
      <div id="survey-trn-options" class="v-hidden">
        <v:form-field caption="@Common.SurveyFrequency">
          <v:input-text field="survey.Frequency" placeholder="@Common.Always" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.Properties">
          <v:lk-multibox field="surveyTrnRules.TransactionTypes" lookup="<%=LkSN.TransactionType%>" placeholder="@Common.All" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.SurveyFilterTaxes" hint="@Common.SurveyFilterTaxesHint">
          <v:boolcombobox name="surveyTrnRules.TaxExempt" id="surveyTrnRules.TaxExempt" value="surveyTrnRules.TaxExempt" captionNullField="@Common.Always" captionFalseField="@Common.NotTaxExempt" captionTrueField="@Sale.TaxExempt"/>
        </v:form-field>
        <v:form-field>
          <v:db-checkbox field="surveyTrnRules.AttachToSale" value="true" caption="@Common.SurveyAttachToSale" hint="@Common.SurveyAttachToSaleHint"/>
        </v:form-field>
      </div>
    </v:widget-block>
    
    <v:widget-block>
      <% JvDataSet dsMaskAll = pageBase.getBL(BLBO_Mask.class).getMaskDS(LkSNEntityType.Sale); %>
      <v:form-field caption="@Common.DataMasks">
        <v:multibox field="survey.MaskIDs" lookupDataSet="<%=dsMaskAll%>" idFieldName="MaskId" captionFieldName="MaskName" linkEntityType="<%=LkSNEntityType.Mask%>" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
    
    <v:widget-block>
      <v:form-field>
        <v:db-checkbox field="survey.Enabled" caption="@Common.Active" value="true" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
  
  <script>
    function refreshSurveyVisibility() {
      var surveyType = parseInt($("#survey\\.SurveyType").val());
      var saleType = parseInt($("#surveySalRules\\.SaleType").val());
      
      $("#survey-sale-options").setClass("v-hidden", surveyType != <%=LkSNSurveyType.Sale.getCode()%>);
      $("#order-sale-owner-category").setClass("v-hidden", (surveyType == <%=LkSNSurveyType.Transaction.getCode()%>))
      $("#survey-trn-options").setClass("v-hidden", surveyType != <%=LkSNSurveyType.Transaction.getCode()%>);
    }
  
    $("#survey\\.SurveyType").click(refreshSurveyVisibility);
    $("#surveySalRules\\.SaleType").click(refreshSurveyVisibility);
    refreshSurveyVisibility();
    
  </script>
  
</div>

