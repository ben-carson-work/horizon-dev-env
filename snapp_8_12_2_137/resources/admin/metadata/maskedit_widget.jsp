<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="com.vgs.snapp.library.MetaDataUtils"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.document.FtList"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page import="com.vgs.cl.*"%>
<%@ page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="maskEdit" scope="request" class="com.vgs.snapp.dataobject.DOMaskEdit"/>

<%
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");
LookupItem entityType = LkSN.EntityType.findItemByCode(pageBase.getNullParameter("EntityType"));
boolean has_required = false;
String maskId = "";
boolean overallCanEdit = !pageBase.isParameter("readonly", "true");
%>

<%!
private String getFormatClass(LookupItem dataType, LookupItem dataFormat) {
  if ((dataType != null) && (dataFormat != null) && dataType.isLookup(LkSNMetaFieldDataType.Text)) {
    if (dataFormat.isLookup(LkSNMetaFieldDataFormat.Text_UpperCase))
      return "fmt-uppercase";
    else if (dataFormat.isLookup(LkSNMetaFieldDataFormat.Text_LowerCase))
      return "fmt-lowercase";
    else if (dataFormat.isLookup(LkSNMetaFieldDataFormat.Text_PascalCase))
      return "fmt-pascalcase";
    else if (dataFormat.isLookup(LkSNMetaFieldDataFormat.Text_SentenceCase))
      return "fmt-sentencecase";
  }
  return "";
}
%>

<% for (DOMaskEdit.DOMaskEditForm mask : maskEdit.FormList) { %>
  <v:widget caption="<%=mask.Caption.getHtmlString()%>">
    <v:widget-block>
      <% for (DOMaskEdit.DOMaskEditItem maskItem : mask.ItemList) { %>
      <%
        boolean canEdit = overallCanEdit && maskItem.CanEdit.getBoolean();
        String id = maskItem.MetaFieldId.getString();
        if (maskItem.Required.getBoolean()) 
          has_required = true;
      %>
      
      <v:form-field caption="<%=maskItem.Caption.getString()%>" hint="<%=maskItem.Hint.getString()%>" mandatory="<%=maskItem.Required.getBoolean()%>">
        <% 
        String inputName = "MetaFieldId_" + id; 
        String sReadOnly = (canEdit) ? "" : "readonly=\"readonly\"";  
        String sDisabled = (canEdit) ? "" : "disabled=\"disabled\"";
        String maxLength = maskItem.MaxLength.getInt()>0 ? maskItem.MaxLength.getString() : "";
        LookupItem dataType = LkSN.MetaFieldDataType.getItemByCode(maskItem.FieldDataType.getInt()); 
        LookupItem dataFormat = LkSN.MetaFieldDataFormat.findItemByCode(maskItem.FieldDataFormat.getInt()); 
        LookupItem fieldType = LkSN.MetaFieldType.findItemByCode(maskItem.FieldType.getInt());
        String metaFieldCodeClass = "MetaFieldCode_" + maskItem.MetaFieldCode.getHtmlString();
        DOMetaFieldMasking masking = pageBase.getBL(BLBO_MetaData.class).getMetaField(id, null, null).Masking;
        String sMasked = (canEdit || masking.MaskingRule.isNull()) ? "" : "masked=\"true\"";
        %>
        <%-- ReadOnly --%>
        <% if (!canEdit && !masking.MaskingRule.isNull()) { %>
          <input type="text" name="<%=inputName%>" id="<%=inputName%>" maxlength="<%=maxLength%>" class="form-control <%=getFormatClass(dataType, dataFormat)%> <%=metaFieldCodeClass%>" readonly="readonly" masked="<%=!masking.MaskingRule.isNull()%>"/>
        <%-- DropDown --%>
        <% } else if (dataType.isLookup(LkSNMetaFieldDataType.DropDown)) { %>
          <v:combobox name="<%=inputName%>" lookupDataSet="<%=pageBase.getBL(BLBO_MetaData.class).getMetaFieldItemDS(id)%>" idFieldName="MetaFieldItemCode" captionFieldName="CalcName" enabled="<%=canEdit%>" clazz="<%=metaFieldCodeClass%>"/>
        <%-- Boolean --%>
        <% } else if (dataType.isLookup(LkSNMetaFieldDataType.Boolean)) { %>
          <label><input type="radio" name="<%=inputName%>" value="1" <%=sDisabled%> class="<%=metaFieldCodeClass%>" /> <v:itl key="@Common.Yes"/></label>
          &nbsp;
          <label><input type="radio" name="<%=inputName%>" value="0" <%=sDisabled%> class="<%=metaFieldCodeClass%>" /> <v:itl key="@Common.No"/></label>
        <%-- Date --%>
        <% } else if (dataType.isLookup(LkSNMetaFieldDataType.Date)) { %>
          <v:input-text type="datepicker" field="<%=inputName%>" enabled="<%=canEdit%>" clazz="<%=metaFieldCodeClass%>"/>
        <%-- Time --%>
        <% } else if (dataType.isLookup(LkSNMetaFieldDataType.Time)) { %>
          <v:input-text type="timepicker" field="<%=inputName%>" enabled="<%=canEdit%>" clazz="<%=metaFieldCodeClass%>" />
        <%-- SingleChoice --%>
        <% } else if (dataType.isLookup(LkSNMetaFieldDataType.SingleChoice)) { %>
          <% JvDataSet dsMFI = pageBase.getBL(BLBO_MetaData.class).getMetaFieldItemDS(id); %>
          <v:ds-loop dataset="<%=dsMFI%>">
            <label class="checkbox-label">
              <% String sValue = dsMFI.getField("MetaFieldItemCode").isNull(dsMFI.getField("CalcName").getString()); %>
              <input type="radio" name="<%=inputName%>" value="<%=JvString.escapeJSON(sValue)%>" <%=sDisabled%> class="<%=metaFieldCodeClass%>" />
              <%=dsMFI.getField("CalcName").getHtmlString()%>
            </label>&nbsp;
          </v:ds-loop>
        <%-- MultipleChoice --%>
        <% } else if (dataType.isLookup(LkSNMetaFieldDataType.MultipleChoice)) { %>
          <% JvDataSet dsMFI = pageBase.getBL(BLBO_MetaData.class).getMetaFieldItemDS(id); %>
          <v:ds-loop dataset="<%=dsMFI%>">
            <label class="checkbox-label">
              <% String sValue = dsMFI.getField("MetaFieldItemCode").isNull(dsMFI.getField("CalcName").getString()); %>
              <input type="checkbox" name="<%=inputName%>" class="multi-choice-item <%=metaFieldCodeClass%>" value="<%=JvString.escapeJSON(sValue)%>" <%=sDisabled%> />
              <%=dsMFI.getField("CalcName").getHtmlString()%>
            </label>&nbsp;
          </v:ds-loop>
        <%-- Random --%>
        <% } else if (dataType.isLookup(LkSNMetaFieldDataType.Random)) { %>
        <div class="input-group" data-metafieldid="<%=id%>">
          <input type="text" name="<%=inputName%>" id="<%=inputName%>" readonly="readonly" class="form-control <%=metaFieldCodeClass%>"/>
          <span class="input-group-btn">
            <v:button caption="@Common.MetaFieldRandomRegenerate" onclick="doRegenerateRandomField(this)"/>
          </span>
        </div>
        <%-- Text, RichText --%>
        <% } else if (dataType.isLookup(LkSNMetaFieldDataType.Text, LkSNMetaFieldDataType.RichText) && !BLBO_MetaData.isAccountDetailField(fieldType)) { %>
          <%
          String sTextReadOnly = (canEdit && !dataType.isLookup(LkSNMetaFieldDataType.RichText)) ? "" : "readonly=\"readonly\""; 
          //String sOnClick = "showTranslationDialog('" + id + "')";
          String sOnClick = "asyncDialogEasy('../admin/metadata/maskedit_multilang_dialog', 'id=" + id + "')";
          if (dataType.isLookup(LkSNMetaFieldDataType.RichText)) 
             sOnClick = "asyncDialogEasy('metadata/maskedit_richtext_dialog', 'id=" + id + "')";
          %>
          <input type="hidden" class="multilanguage-text" name="<%=inputName%>" id="<%=inputName%>" <%=sReadOnly%>/>
          <div class="input-group">
            <input type="text" class="form-control default-multilanguage-text <%=getFormatClass(dataType, dataFormat)%> <%=metaFieldCodeClass%>" name="DefaultLang_<%=inputName%>" id="DefaultLang_<%=inputName%>" <%=sTextReadOnly%> maxLength="100" onchange="doChangeMultiLangText('<%=id%>')" onkeyup="doChangeMultiLangText('<%=id%>')" />
            <span class="input-group-btn">
              <button class="btn btn-default multi-lang-edit-button" type="button" onclick="<%=sOnClick%>"><i class="fa fa-globe"></i></button>
            </span>
          </div>
        <% } else if (dataType.isLookup(LkSNMetaFieldDataType.Email)) { %>
          <input type="email" class="form-control <%=metaFieldCodeClass%>" name="<%=inputName%>" id="<%=inputName%>" maxlength="<%=maxLength%>" <%=sReadOnly%> />
        <%-- Note --%>
        <% } else if (dataType.isLookup(LkSNMetaFieldDataType.Note)) { %>
          <textarea class="form-control <%=metaFieldCodeClass%>" name="<%=inputName%>" id="<%=inputName%>" <%=sReadOnly%> rows="5"></textarea>
        <% } else if (dataType.isLookup(LkSNMetaFieldDataType.Picture)) { %>
          <div name="<%=inputName%>" class="btn-group metafield-picture <%=metaFieldCodeClass%>" <%=sReadOnly%>>
            <v:button clazz="metafield-picture-view-button" caption="@Common.View" fa="eye"/>
            <v:button clazz="metafield-picture-change-button" caption="@Common.Change" fa="folder-open"/>
            <v:button clazz="metafield-picture-clear-button" fa="times"/>
          </div>
        <%-- Other --%>
        <% } else { %>
          <input type="text" name="<%=inputName%>" id="<%=inputName%>" maxlength="<%=maxLength%>" class="form-control <%=getFormatClass(dataType, dataFormat)%> <%=metaFieldCodeClass%>" <%=sReadOnly%> <%=sMasked%>/>
        <% } %>
        <script>
          $("[name='<%=inputName%>']").attr("data-MetaFieldId", "<%=id%>").addClass("meta-field-value").data("mask-edit-item", <%=maskItem.getJSONString()%>);
        </script>
      </v:form-field>
      <% } %>
    </v:widget-block>
  </v:widget>

<% } %>

<script>//# sourceURL=maskedit_widget.jsp
  <%
  String data = null;
  if (pageBase.isNewItem())
    data = pageBase.getBL(BLBO_MetaData.class).getEncodedDefaults(maskEdit);
  else if (pageBase.isParameter("LoadData", "true")) 
    data = pageBase.getBL(BLBO_MetaData.class).encodeItems(entityType, pageBase.getId()); 
  %>
  
  <% if (data != null) { %>
    metaFields = <%=data%>;
  <% } %>
  
  Object.entries(metaFields).forEach(function([metaFieldId, metaFieldObj]) {    
    var elem = $(".meta-field-value[data-MetaFieldId='" + metaFieldId + "']");
    // Boolean
    if (elem.is("input[type='radio']"))
      elem.filter("[value='" + metaFieldObj.value + "']").setChecked(true);
    // Date
    else if (elem.is(".dateAltField")) 
      $("#MetaFieldId_" + metaFieldId + "-picker").datepicker("setDate", xmlToDate(metaFieldObj.value));
    // Time
    else if (elem.is(".timeAltField") && (metaFieldObj.value) && (metaFieldObj.value != "")) {
      var dt = xmlToDate(metaFieldObj.value);
      $("#MetaFieldId_" + metaFieldId + "-HH").val(leadZero(dt.getHours(), 2));
      $("#MetaFieldId_" + metaFieldId + "-MM").val(leadZero(dt.getMinutes(), 2));
      elem.val(metaFieldObj.value);
    }
    else if (elem.is(".multi-choice-item") && (metaFieldObj.value)) {
      var values = metaFieldObj.value.split(",");
      for (var k=0; k<values.length; k++) 
        elem.filter("[value='" + values[k] + "']").setChecked(true);
    }
    // MultuLanguage Text
    else if (elem.is(".multilanguage-text")) {
      var obj = metaFieldObj.value;
      elem.val(JSON.stringify(metaFieldObj.value));
      defInput = $("#DefaultLang_MetaFieldId_" + metaFieldId);
      if (obj)
        defInput.val(obj.Default);
    }
    // Text
    else {
      if (elem.attr("masked") == "true")
        elem.val(metaFieldObj.maskedValue);
      else
        elem.val(metaFieldObj.value);
    }
  });

  /* Creating a map to know, when a meta field gets changed, what are the meta fields for which the format should be reconsidered. */
  var mapConditionMonitor = {}; // <monitor MetaFieldId, List of conditioned MaskEditItems>
  $(".meta-field-value").each(function(index, elem) {
    var maskEditItem = $(elem).data("mask-edit-item");
    for (var i=0; i<(maskEditItem.ConditionList || []).length; i++) {
      var condition = maskEditItem.ConditionList[i];
      var list = mapConditionMonitor[condition.MonitorMetaFieldId] || [];
      if (list.indexOf(maskEditItem) < 0)
        list.push(maskEditItem);
      mapConditionMonitor[condition.MonitorMetaFieldId] = list;
    }
  });
  $(".meta-field-value").each(function(index, elem) {
    var metaFieldId = $(this).attr("data-metafieldid");
    applyConditionalFormatting(metaFieldId);
  });


  function formatField(txt) {
    var value = txt.val();
    if (txt.hasClass("fmt-uppercase"))
      txt.val(value.toUpperCase());
    else if (txt.hasClass("fmt-lowercase"))
      txt.val(value.toLowerCase());
    else if (txt.hasClass("fmt-pascalcase"))
      txt.val(value.toPascalCase());
    else if (txt.hasClass("fmt-sentencecase"))
      txt.val(value.toSentenceCase());
  }
  
  function calcFormatBean(maskEditItem) {
    var result = {
      minLength: null,
      maxLength: maskEditItem.MaxLength
    };
    
    for (var i=0; i<(maskEditItem.ConditionList || []).length; i++) {
      var condition = maskEditItem.ConditionList[i];
      var actualMonitorValue = metaFields[condition.MonitorMetaFieldId];
      if (_isConditionApplicable(condition.MonitorValue, actualMonitorValue, condition.MonitorComparatorType))
        _applyCondition(condition.MaskItemProperty, condition.PropertyValue);
    }
    return result;
    
    function _isConditionApplicable(expectedValue, actualValue, comparatorType) {
 	    if (actualValue && typeof actualValue === 'object' && actualValue.value) 
        actualValue = actualValue.value;

 	    if (comparatorType == <%=LkSNComparatorType.Equals.getCode()%>) 
        return isSameText(expectedValue, actualValue);
      else if (comparatorType == <%=LkSNComparatorType.Differs.getCode()%>) 
        return !isSameText(expectedValue, actualValue);
      else
        throw "Unhandled comparator type: " + comparatorType;
    }
    
    function _applyCondition(maskItemProperty, propertyValue) {
      if (maskItemProperty == <%=LkSNMaskItemProperty.MinLength.getCode()%>)
        result.minLength = strToIntDef(propertyValue, null);
      else if (maskItemProperty == <%=LkSNMaskItemProperty.MaxLength.getCode()%>)
        result.maxLength = strToIntDef(propertyValue, null);
      else if (maskItemProperty == <%=LkSNMaskItemProperty.Enabled.getCode()%>)
        result.enabled = strToBoolDef(propertyValue, true);
      else
        throw "Unhandled mask item property: " + maskItemProperty;
    }
  }
  
  function applyConditionalFormatting(monitorMetaFieldId) {
    var list = mapConditionMonitor[monitorMetaFieldId] || [];
    for (var i=0; i<list.length; i++) {
      var maskEditItem = list[i];
      var format = calcFormatBean(maskEditItem);
      
      var $txt = $(".meta-field-value[data-metafieldid='" + maskEditItem.MetaFieldId + "']");
      if ($txt.is(".multilanguage-text"))
        $txt = $txt.closest(".form-field-value").find(".default-multilanguage-text");
      
      if (format.maxLength == null)
        $txt.removeAttr("maxlength");
      else
        $txt.attr("maxlength", format.maxLength);
      
      if ((format.enabled == null) && (maskEditItem.CanEdit))
        $txt.removeAttr("readonly");
      else {
        $txt.attr("readonly", "readonly");
        $txt.val("");
      }
    } 
  }
  
  $(".meta-field-value").change(function() {
    var $this = $(this);
    var value = $this.val();
    var metaFieldId = $this.attr("data-metafieldid");
    if ($this.is("input[type='radio']")) 
      value = $this.filter(":checked").val();
    formatField($this);

    metaFields[metaFieldId] = value;
    $this.addClass("metadata-modified");
    applyConditionalFormatting(metaFieldId);
  });
  
  $(".default-multilanguage-text").change(function() {
    formatField($(this));
  });
  
  $(".timepicker").change(function() {
    var id = $(this).attr("id");
    if (id.indexOf("MetaFieldId_") >= 0) {
      var value = parseInt($(this).val());
      if (isNaN(value))
        value = 0;
      id = id.replace("-HH", "").replace("-MM", "");
      var storage = $("#" + id);
      var dt = xmlToDate(storage.val());
      if ($(this).is(".hourpicker"))
        dt.setHours(value);
      else if ($(this).is(".minpicker"))
        dt.setMinutes(value);
      storage.val(dateToXML(dt));
      storage.change();
    }
  });
  
  function doChangeMultiLangText(id) {
    var obj;
    if ($("#MetaFieldId_" + id).val() != "") 
      obj = JSON.parse($("#MetaFieldId_" + id).val());
    else 
      obj = {
        Default: null,
        TransList: null
       }
    if ($("#DefaultLang_MetaFieldId_" + id).val() != "")
      obj.Default = $("#DefaultLang_MetaFieldId_" + id).val();
    else
      obj.Default = null;
    $("#MetaFieldId_" + id).val(JSON.stringify(obj));
  }
  
  function doRegenerateRandomField(button) {
    var $inputGroup = $(button).closest(".input-group");
    
    var reqDO = {
      Command: "RandomRegenerate",
      RandomRegenerate: {
        MetaFieldId: $inputGroup.attr("data-metafieldid"),
        EntityType: <%=pageBase.getNullParameter("EntityType")%>
      }
    };
    
    vgsService("MetaData", reqDO, false, function(ansDO) {
      $inputGroup.find("input[type='text']").val(ansDO.Answer.RandomRegenerate.Value);
    });
  }

  function prepareMetaDataArray(container) {
    var result = [];
    var missingRequired = false;
    var $fields = $(container).find(".form-field");
    
    for (var i=0; i<$fields.length; i++) {
      var $field = $($fields[i]);
      var $metaField = $field.find(".form-field-value .meta-field-value");

      var doPush = true;
      if ($metaField.is("input[type='radio']")) {
        $metaField = $metaField.filter(":checked");
        doPush = $metaField.length > 0;
      }
      
      var readonly = $metaField.attr("readonly");
      var disabled = $metaField.attr("disabled");
      var isEnabled = (readonly != "readonly") && (disabled != "disabled");
      
      if (($metaField.length > 0) && doPush && isEnabled) {
        var fieldRequired = false;
        if ($field.attr("data-required") == "true") {
          var value = $field.children('.form-field-value');
          var sValue = value.find("input").val();
          if (sValue)
          	sValue = sValue.trim();
          if ((sValue || "") == "")
            sValue = value.find("select").val() || "";
          if (sValue == "") {
            fieldRequired = true;
            missingRequired = true;
          }
        }         
        
        var metaFieldId = $metaField.attr("data-MetaFieldId");
        if (metaFieldId) {
          var mdi = {
            MetaFieldId: metaFieldId,
            Value: $metaField.val()
          };
          
          if ($metaField.is(".multilanguage-text") && (mdi.Value != "")) {
            var obj = JSON.parse(mdi.Value);
            mdi.Value = obj.Default;
            mdi.MultiLanguageText = obj;
          }
          else if ($metaField.is(".multi-choice-item")) 
            mdi.Value = $metaField.getCheckedValues();

          var $reqinput = $metaField;
          if ($metaField.is(".multilanguage-text")) 
            $reqinput = $("#DefaultLang_MetaFieldId_" + metaFieldId);
          $reqinput.setClass("missing-required", fieldRequired);

          result.push(mdi);
        }
      }
    }

    return (missingRequired) ? false : result;
  }
  
</script>
