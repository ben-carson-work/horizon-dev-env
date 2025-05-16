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

<v:dialog id="maskitem_dialog" tabsView="true" title="@Common.Item" width="800" height="600">
<jsp:include page="../configlang_inline_dialog.jsp"/>

  <v:tab-group name="tab" main="true">
    <%-- TAB MAIN --%>
    <v:tab-item-embedded tab="tabs-main" caption="@Common.Profile" default="true">
      <div class="tab-content">
        <v:widget caption="@Common.General">
          <v:widget-block>
            <v:form-field caption="@Common.Field" mandatory="true">
              <v:input-text field="maskitem-MetaField" enabled="false"/>
            </v:form-field>
            <v:form-field caption="@Common.Caption" mandatory="true">
              <snp:itl-edit id="maskitem-Caption" maxLength="50" langField="<%=LkSNHistoryField.MaskItem_Caption%>" entityType="<%=LkSNEntityType.MaskItem%>" entityId="none"/>
            </v:form-field>
            <v:form-field caption="@Common.Hint" mandatory="true">
              <snp:itl-edit id="maskitem-Hint" maxLength="50" langField="<%=LkSNHistoryField.MaskItem_Hint%>" entityType="<%=LkSNEntityType.MaskItem%>" entityId="none"/>
            </v:form-field>
          </v:widget-block>
          <v:widget-block>
            <v:form-field clazz="form-field-optionset">
              <div><v:db-checkbox field="maskitem-Required" value="true" caption="@Common.Required" /></div>
              <div><v:db-checkbox field="maskitem-Conditional" value="true" caption="@Common.MaskItemConditional" hint="@Common.MaskItemConditionalHint"/></div>
            </v:form-field>
          </v:widget-block>
        </v:widget>
        
        <v:widget caption="@Common.Default">
          <v:widget-block>
            <v:form-field caption="@Common.Type">
              <v:lk-combobox field="maskitem-MaskDefaultType" lookup="<%=LkSN.MaskDefaultType%>" allowNull="false"/>
            </v:form-field>
            <v:form-field caption="@Common.Value" hint="@Common.ValueHint">
              <v:input-text field="maskitem-DefaultValue" maxLength="100" />
            </v:form-field>
          </v:widget-block>
        </v:widget>
      </div>
    </v:tab-item-embedded>
  
    <%-- TAB CONDITIONS --%>
    <v:tab-item-embedded tab="tabs-conditions" caption="@Common.MaskItemConditions">
      <div class="tab-toolbar">
        <v:button id="btn-condition-add" caption="@Common.Add" fa="plus" bindGrid="maskitem-condition-grid" bindGridEmpty="true"/>
        <v:button id="btn-condition-remove" caption="@Common.Remove" fa="minus" bindGrid="maskitem-condition-grid"/>
      </div>
      <div class="tab-content">
        <div id="maskitem-condition-grid" class="grid-widget-container">
          <v:grid>
            <thead>
              <tr>
                <td><v:grid-checkbox header="true"/></td>
                <td width="30%"><v:itl key="@Common.Field"/></td>
                <td width="10%"></td>
                <td width="20%"><v:itl key="@Common.Value"/></td>
                <td></td>
                <td width="20%"><v:itl key="@Common.Property"/></td>
                <td width="20%"><v:itl key="@Common.Value"/></td>
              </tr>
            </thead>
            <tbody id="tbody-condition-empty"><tr><td align="center" colspan="100%"><i><v:itl key="@Common.Empty"/></i></td></tr></tbody>
            <tbody id="tbody-condition-list"></tbody>
          </v:grid>
        </div>
      </div>
    </v:tab-item-embedded>
  </v:tab-group>
  
  <div id="maskitem-templates" class="hidden">
    <table>
      <tr class="maskitem-condition-row-template">
        <td><v:grid-checkbox/></td>
        <td><snp:dyncombo clazz="condition-MetaFieldId" entityType="<%=LkSNEntityType.MetaField%>"/></td>
        <td><v:lk-combobox clazz="condition-ComparatorType" lookup="<%=LkSN.ComparatorType%>" limitItems="<%=LkSNComparatorType.getMaskItemComparatorTypes()%>" allowNull="false"/></td>
        <td><v:input-text clazz="condition-MonitorValue"/></td>
        <td><i class="fa fa-arrow-right"></i></td>
        <td><v:lk-combobox clazz="condition-MaskItemProperty" lookup="<%=LkSN.MaskItemProperty%>" allowNull="false"/></td>
        <td id="condition-PropertyValue-container">
          <input type="number" id="condition-PropertyValue-number" class="condition-PropertyValue form-control hidden"/>
          <div id="condition-PropertyValue-radio" class="hidden">
            <label class="checkbox-label"><input type="radio" name="condition-PropertyValue" value="enabled"> <v:itl key="@Common.Yes"/></label>&nbsp; 
            <label class="checkbox-label"><input type="radio" name="condition-PropertyValue" value="disabled"> <v:itl key="@Common.No"/></label>
         </div>
        </td>
      </tr>
    </table>
  </div>

<script>

$(document).ready(function() {
  var $dlg = $("#maskitem_dialog");
  var metaFieldId = <%=JvString.jsString(pageBase.getId())%>;
  var $tr = $("#mask-item-tbody .mask-item-row[data-metafieldid='" + metaFieldId + "']");
  var maskItem = $tr.data("maskItem") || {};
  maskItem.ConditionList = maskItem.ConditionList || [];
  
  var $txtMetaField = $dlg.find("#maskitem-MetaField");
  var $txtCaption = $dlg.find("#maskitem-Caption");
  var $txtHint = $dlg.find("#maskitem-Hint");
  var $cbRequired = $dlg.find("#maskitem-Required");
  var $cbConditional = $dlg.find("#maskitem-Conditional");
  var $lkMaskDefaultType = $dlg.find("#maskitem-MaskDefaultType");
  var $txtDefaultValue = $dlg.find("#maskitem-DefaultValue");
  
  var $tbodyConditionEmpty = $dlg.find("#tbody-condition-empty");
  var $tbodyConditionList = $dlg.find("#tbody-condition-list");
  
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {"text": itl("@Common.Ok"),       "click": _saveItem},
      {"text": itl("@Common.Cancel"),   "click": doCloseDialog}
    ];
  });

  $cbConditional.change(_refreshVisibility);
  $dlg.find("#btn-condition-add").click(_onClick_ConditionAdd);
  $dlg.find("#btn-condition-remove").click(_onClick_ConditionRemove);
  _loadItem();
  
  function _loadItem() {
    $txtMetaField.val("[" + maskItem.MetaFieldCode + "] " + maskItem.MetaFieldName);
    $txtCaption.attr("data-fieldname", "ITL_Caption").attr("placeholder", maskItem.MetaFieldName).val(maskItem.Caption);
    $txtHint.attr("data-fieldname", "ITL_Hint").val(maskItem.Hint);
    $cbRequired.setChecked(maskItem.Required === true);
    $cbConditional.setChecked(maskItem.ConditionList.length > 0);
    $lkMaskDefaultType.val(maskItem.MaskDefaultType);
    $txtDefaultValue.val(maskItem.DefaultValue);
    
    $dlg.find(".itl-control").closest(".input-group").find(".multi-lang-edit-button").removeAttr("onclick").click(_showConfigLangDialog_MaskItem);
    
    $dlg.find(".form-control").keypress(function(event) {
      if (event.keyCode == KEY_ENTER)
        _saveItem();
    });
    
    for (var i=0; i<maskItem.ConditionList.length; i++) 
      _addCondition(maskItem.ConditionList[i]);

    _refreshVisibility();
  }
  
  function _refreshVisibility() {
    $dlg.find("[data-tabcode='tabs-conditions']").closest("li").setClass("hidden", !$cbConditional.isChecked());
    $tbodyConditionEmpty.setClass("hidden", ($tbodyConditionList.find("tr").length > 0));
  }

  function _showConfigLangDialog_MaskItem() {
    var fieldName = $(this).closest(".input-group").find(".itl-control").attr("data-fieldname");
    showConfigLangDialog(maskItem[fieldName], function(list) {
      maskItem[fieldName] = list;
    });
  }
  
  function _onClick_ConditionAdd() {
    _addCondition({});
    _refreshVisibility();
  }
  
  function _onClick_ConditionRemove() {
    $tbodyConditionList.find(".cblist:checked").closest("tr").remove();
    _refreshVisibility();
    refreshGridBindings();
    _updateRadioNames();
  }
  
  function _updateRadioNames() {
    $('#tbody-condition-list tr').each(function(index, elem) {
      var $tr = $(elem);
      var uniqueName = 'condition-PropertyValue-' + index;
      $tr.find('#condition-PropertyValue-radio input[type="radio"]').attr('name', uniqueName);
    });
	}
  
  function _addCondition(condition) {
	  var $tr = $dlg.find("#maskitem-templates .maskitem-condition-row-template").clone().appendTo($tbodyConditionList);
    $tr.find(".condition-MetaFieldId").val(condition.MonitorMetaFieldId);
    $tr.find(".condition-ComparatorType").val(condition.MonitorComparatorType);
    $tr.find(".condition-MonitorValue").val(condition.MonitorValue);
    $tr.find(".condition-MaskItemProperty").val(condition.MaskItemProperty);

    var rowIndex = $tbodyConditionList.find('tr').length; 
    var $propertyValueContainer = $tr.find('#condition-PropertyValue-container');
    var dataType = $tr.find('.condition-MaskItemProperty option:selected').attr('datatype');
    
    $propertyValueContainer.find('#condition-PropertyValue-number').addClass('hidden');
    $propertyValueContainer.find('#condition-PropertyValue-radio').addClass('hidden');

    if (dataType == <%=LkSNMetaFieldDataType.Numeric.getCode()%>) 
    	$propertyValueContainer.find('#condition-PropertyValue-number').removeClass('hidden').val(condition.PropertyValue);
    else if (dataType == <%=LkSNMetaFieldDataType.Boolean.getCode()%>) {
      var isEnabled = strToBoolDef(condition.PropertyValue || 'true', true);
      $propertyValueContainer.find(`input[name="condition-PropertyValue"][value="${isEnabled ? 'enabled' : 'disabled'}"]`).prop('checked', true);
      $propertyValueContainer.find('#condition-PropertyValue-radio').removeClass('hidden');
      
      var uniqueName = 'condition-PropertyValue-' + rowIndex;
      $propertyValueContainer.find('input[type="radio"]').attr('name', uniqueName);
    }
    else 
    	throw "Metafield data type not handled: " + dataType;

    $tr.data('initialPropertyValue', condition.PropertyValue);

    return $tr;
  }

  function _handleMaskItemPropertyChange() {
    var $selectedOption = $(this).find('option:selected');
    var dataType = $selectedOption.attr('datatype');
    var $tr = $(this).closest('tr');
    var rowIndex = $tr.index()
    var $propertyValueContainer = $tr.find('#condition-PropertyValue-container');

    $propertyValueContainer.find('#condition-PropertyValue-number').addClass('hidden');
    $propertyValueContainer.find('#condition-PropertyValue-radio').addClass('hidden');
    
    if (dataType == <%=LkSNMetaFieldDataType.Numeric.getCode()%>) 
    	$propertyValueContainer.find('#condition-PropertyValue-number').removeClass('hidden').val($tr.data('initialPropertyValue'));
    else if (dataType == <%=LkSNMetaFieldDataType.Boolean.getCode()%>) {
      var uniqueName = 'condition-PropertyValue-' + rowIndex;
      $propertyValueContainer.find('#condition-PropertyValue-radio').removeClass('hidden');
      $propertyValueContainer.find('input[type="radio"]').attr('name', uniqueName);
      var isEnabled = strToBoolDef($tr.data('initialPropertyValue') || 'true', true);
      if (isEnabled)
        $propertyValueContainer.find(`[value="enabled"]`).prop('checked', true);
      else
    	  $propertyValueContainer.find(`[value="disabled"]`).prop('checked', true);
    } 
    else 
    	throw "Metafield data type not handled: " + dataType;
  }

  $('#tbody-condition-list').on('change', '.condition-MaskItemProperty', _handleMaskItemPropertyChange);
  $('#tbody-condition-list .condition-MaskItemProperty').each(_handleMaskItemPropertyChange);

  function _saveItem() {
    maskItem.Caption = getNull($txtCaption.val());
    maskItem.Hint = getNull($txtHint.val());
    maskItem.Required = $cbRequired.isChecked();
    maskItem.MaskDefaultType = $lkMaskDefaultType.val();
    maskItem.DefaultValue = getNull($txtDefaultValue.val());
    
    maskItem.ConditionList = [];
    if ($cbConditional.isChecked()) {
      $tbodyConditionList.find("tr").each(function(index, elem) {
        var $tr = $(elem);
        var metaFieldId = getNull($tr.find(".condition-MetaFieldId").val());
                
        if (metaFieldId != null) {
        	var dataType = $tr.find('.condition-MaskItemProperty option:selected').attr('datatype');
          var propertyValue;

          if (dataType == <%=LkSNMetaFieldDataType.Numeric.getCode()%>) 
            propertyValue = $tr.find("#condition-PropertyValue-number").val();
          else if (dataType == <%=LkSNMetaFieldDataType.Boolean.getCode()%>) 
            propertyValue = $tr.find('input[name^="condition-PropertyValue-"]:checked').val() === 'enabled' ? 'true' : 'false';
          else
        	  throw "Metafield data type not handled: " + dataType;
        	
          maskItem.ConditionList.push({
            MonitorMetaFieldId: metaFieldId,
            MonitorComparatorType: $tr.find(".condition-ComparatorType").val(),
            MonitorValue: $tr.find(".condition-MonitorValue").val(),
            MaskItemProperty: $tr.find(".condition-MaskItemProperty").val(),
            PropertyValue: propertyValue
          });
        }
      });
    }
    
    $tr.trigger("data-changed", maskItem);
    $dlg.dialog("close");
  }
});
</script>

</v:dialog>