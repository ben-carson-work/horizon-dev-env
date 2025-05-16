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

<style>
.metafield-button {
  margin: 5px;
  margin-bottom: 0;
  margin-right: 15px;
}
#metafielditem-detail .form-field-caption {
  width: 100px;
}
#metafielditem-detail .form-field-value {
  margin-left: 103px;
}
</style>

<% 
BLBO_MetaData bl = pageBase.getBL(BLBO_MetaData.class);
DOMetaField metaField = pageBase.isNewItem() ? bl.prepareNewMetaField() : bl.loadMetaField(pageBase.getId()); 
boolean isLangField = metaField.FieldType.isLookup(LkSNMetaFieldType.Language);
boolean isEmailField = metaField.FieldType.isLookup(LkSNMetaFieldType.EmailAddress1, LkSNMetaFieldType.EmailAddress2, LkSNMetaFieldType.LoginEmail);
DOMetaFieldMasking masking = metaField.Masking;
request.setAttribute("masking", masking);
%>

<div class="tab-content">
  <v:widget caption="@Common.Profile">
    <v:widget-block>
      <v:form-field caption="@Common.Code" mandatory="true">
        <v:input-text field="metafield.MetaFieldCode" />
      </v:form-field>
      <v:form-field caption="@Common.Name" mandatory="true">
        <v:input-text field="metafield.MetaFieldName" />
      </v:form-field>
      <v:form-field caption="@Common.Type">
        <v:lk-combobox field="metafield.FieldDataType" lookup="<%=LkSN.MetaFieldDataType%>" allowNull="false" hideItems="<%=LookupManager.getArray(LkSNMetaFieldDataType.SiaePerformance)%>" enabled="<%=!isLangField && !isEmailField%>"/>
      </v:form-field>
      <v:form-field caption="@Common.Format" id="text-format-field">
        <v:lk-combobox field="metafield.FieldDataFormat" lookup="<%=LkSN.MetaFieldDataFormat%>" indexBegin="<%=LkSNMetaFieldDataFormat.TextBegin%>" indexEnd="<%=LkSNMetaFieldDataFormat.TextEnd%>" allowNull="true"/>
      </v:form-field>
      <v:form-field caption="@Common.RandomCombine" mandatory="false" id="random-combine-field">
        <v:input-text field="metafield.RandomCombine" type="number"/>
      </v:form-field>
      <v:form-field caption="@Common.MaxLength" hint="@Common.MaxLengthHint" mandatory="false" id="max-length-field">
        <v:input-text field="metafield.MaxLength" type="number" min="1"/>
      </v:form-field>
    </v:widget-block>
    
    <v:widget-block>
      <v:form-field caption="@MetaData.PurgeOption" hint="@MetaData.PurgeOptionHint">
        <v:lk-radio field="metafield.PurgeOption" lookup="<%=LkSN.MetaFieldPurgeOption%>" allowNull="true" inline="true"/>
      </v:form-field>
    </v:widget-block>
    
    <v:widget-block>
      <v:db-checkbox field="metafield.FullTextIndex" caption="@Common.FullTextIndex" value="true"/>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <v:db-checkbox field="metafield.UniqueIndex" caption="@Common.UniqueIndex" value="true"/>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <v:db-checkbox field="metafield.Encrypted" caption="@Common.Encrypted" value="true"/>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <v:db-checkbox field="metafield.Engravable" caption="@Common.MetaFieldEngravable" hint="@Common.MetaFieldEngravableHint" value="true"/>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <v:db-checkbox field="metafield.AutoPopulate" caption="@Common.MetaFieldAutoPopulate" hint="@Common.MetaFieldAutoPopulateHint" value="true" checked="<%=pageBase.isNewItem() ? true : metaField.AutoPopulate.getBoolean()%>"/>
    </v:widget-block>
  </v:widget>
  
  <v:widget caption="@Masking.Masking">
    <v:widget-block>
      <v:form-field caption="@Masking.MaskingRule" hint="@Masking.MaskingRuleHint">
        <v:lk-combobox field="masking.MaskingRule" lookup="<%=LkSN.TextMaskingType%>" allowNull="true"/>
      </v:form-field>
      <v:form-field caption="@Masking.UnmaskedStartChars" hint="@Masking.UnmaskedStartCharsHint" mandatory="false" id="unmasked-start-chars">
        <v:input-text field="masking.UnmaskedStartChars" type="number" min="1"/>
      </v:form-field>
      <v:form-field caption="@Masking.UnmaskedEndChars" hint="@Masking.UnmaskedEndCharsHint" mandatory="false" id="unmasked-end-chars">
        <v:input-text field="masking.UnmaskedEndChars" type="number" min="1"/>
      </v:form-field>
      <v:form-field caption="@Masking.SplitWords" hint="@Masking.SplitWordsHint" mandatory="false" id="masked-split-words">
        <v:db-checkbox field="masking.SplitWords" caption="" value="true"/>
      </v:form-field>
      <v:form-field caption="@Masking.MaskedMinChars" hint="@Masking.MaskedMinCharsHint" mandatory="false" id="masked-min-chars">
        <v:input-text field="masking.MaskedMinChars" type="number" min="1"/>
      </v:form-field>
      <v:form-field caption="@Masking.MaskedMinCharsAlign" hint="@Masking.MaskedMinCharsAlignHint" id="masked-min-chars-align">
        <v:lk-combobox field="masking.MaskedMinCharsAlign" lookup="<%=LkSN.TextMaskingAlignType%>"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
</div>

<script>	 
$("#metafield\\.FieldDataType").change(refreshTabs);
$("#masking\\.MaskingRule").change(refreshMasking);
refreshTabs();
refreshMasking();

function refreshTabs() {
  var fdt = $("#metafield\\.FieldDataType").val();
  var visibleItems = (fdt == <%=LkSNMetaFieldDataType.DropDown.getCode()%>) || (fdt == <%=LkSNMetaFieldDataType.SingleChoice.getCode()%>) || (fdt == <%=LkSNMetaFieldDataType.MultipleChoice.getCode()%>) || (fdt == <%=LkSNMetaFieldDataType.Random.getCode()%>);
  $("[data-tabcode='tabs-items']").closest("li").setClass("v-hidden", !visibleItems);
  if (!visibleItems) {
    var select = $("#metafielditem-list")[0];
    for(var i=0; i < select.options.length; i++)
      select.options[i].remove();
  }
}

function refreshMasking() {
  var mr = $("#masking\\.MaskingRule").val();

  $("#unmasked-start-chars").addClass("hidden");
  $("#unmasked-end-chars").addClass("hidden");
  $("#masked-split-words").addClass("hidden");
  $("#masked-min-chars").addClass("hidden");
  $("#masked-min-chars-align").addClass("hidden");

  if (mr == <%=LkSNTextMaskingType.General.getCode()%>) {
    $("#unmasked-start-chars").removeClass("hidden");
    $("#unmasked-end-chars").removeClass("hidden");
    $("#masked-split-words").removeClass("hidden");
    $("#masked-min-chars").removeClass("hidden");
    $("#masked-min-chars-align").removeClass("hidden");
  }
}
</script>