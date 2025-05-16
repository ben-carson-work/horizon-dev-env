//# sourceURL=mob-ui-maskedit.js

$(document).ready(function() {
  window.UIMaskEdit = {
    "init": init,
    "setCategoryId": setCategoryId,
    "getMetaData": getMetaData
  };

  
  /**
   * params = {
   *   Container: selector | jQuery, // Mandatory
   *   MaskIDs: String[],
   *   CategoryId: String,
   *   MetaDataList: []
   * }
   */
  function init(params) {
    params = (params || {});
    var metaDataList = params.MetaDataList || []; 
    
    if (params.Container == null)
      throw "'Container' parameter is required";
    var $container = $(params.Container).empty();

    if ((params.MaskIDs == null) && (params.CategoryId == null))
      throw "'MaskIDs' and 'CategoryId' cannot be both null";

    var $spinner = UIMob.createSpinnerClone().appendTo($container);
    snpAPI("MetaData", "LoadMasks", {
      "MaskIDs": params.MaskIDs,
      "CategoryId": params.CategoryId
    }).finally(function() {
      $spinner.remove();
    }).then(function(ansDO) {
      var list = ansDO.MaskList || [];
      for (var i=0; i<list.length; i++) 
        renderMask($container, list[i], metaDataList);
      
      $container.attr("data-categoryid", params.CategoryId);
      $container.data("metadata", metaDataList);
    });
  }
  
  function renderMask($container, mask, metaDataList) {
    var $mask = $("<div class='pref-section'/>").appendTo($container);
    $mask.attr("data-maskid", mask.MaskId);
    
    var $title = $("<div class='pref-section-title'/>").appendTo($mask); 
    $title.text(mask.MaskName);
    
    var $list = $("<div class='pref-item-list'/>").appendTo($mask);
    var list = mask.MaskItemList || []; 
    for (var i=0; i<list.length; i++) {
      var item = list[i];
      var $item = $("<div class='pref-item mask-item'><div class='pref-item-caption'/><div class='pref-item-value'/><div class='pref-item-arrowicon'><i class='fa fa-chevron-right'></i></div></div>").appendTo($list);
      $item.data("item", item);
      $item.attr("data-metafieldid", item.MetaFieldId);
      $item.attr("data-type", item.FieldDataType);
      $item.setClass("required-field", item.Required === true);
      $item.find(".pref-item-caption").text(item.Caption || item.MetaFieldName);
      
      var mdi = findMetaDataValue(metaDataList, item.MetaFieldId);
      initMaskItem($item, item, mdi);
    }
  }
  
  function findMetaDataValue(metaDataList, metaFieldId) {
    for (var i=0; i<metaDataList.length; i++) {
      var mdi = metaDataList[i];
      if (mdi.MetaFieldId == metaFieldId)
        return mdi;
    }
    return null;
  }
  
  function setCategoryId(container, categoryId) {
    var $container = $(container);
    var oldId = $container.attr("data-categoryid");
    if (oldId != categoryId) {
      var list = $container.data("metadata");
      $container.find(".pref-item.mask-item").each(function(index, elem) {
        var $item = $(elem);
        var metaFieldId = $item.data("item").MetaFieldId;
        var metaDataValue = $item.data("value");
        
        var mdi = findMetaDataValue(list, metaFieldId);
        if (mdi)
          mdi.Value = metaDataValue;
        else {
          list.push({
            "MetaFieldId": metaFieldId,
            "Value": metaDataValue
          });
        }
      });
      
      init({
        "Container": container,
        "CategoryId": categoryId,
        "MetaDataList": list
      });
    }
  }
  
  function getMetaData($container) {
    var missing = false;
    var list = [];

    $container.find(".pref-item.mask-item").removeClass("missing-required").each(function(index, elem) {
      var $item = $(elem);
      var item = $item.data("item");
      var value = $item.data("value");
      
      list.push({
        "MetaFieldId": item.MetaFieldId,
        "Value": value
      });
      
      if (item.Required == true) {
        if ((value == null) || (value == "")) {
          $item.addClass("missing-required");
          missing = true;
        }
      }
    });
    
    if (missing) {
      UIMob.showError(itl("@Common.CheckRequiredFields"));
      return false;
    }
    else
      return list;
  }
  
  function findInputType(dataType) {
    switch (dataType) {
      case LkSN.MetaFieldDataType.Text.code:  return "text";
      case LkSN.MetaFieldDataType.Email.code: return "email";
    }
  
    return null;
  }
  
  function isFieldType(type, types) {
    for (var i=0; i<types.length; i++)
      if (types[i].code == type)
        return true;
    return false;
  }

  function initMaskItem($item, item, mdi) {
    var $value = $item.find(".pref-item-value").empty();
    var value = (mdi) ? mdi.Value : null;
    $item.data("value", value);
    
    var inputType = findInputType(item.FieldDataType);
    if (inputType) {
      var $txt = $("<input class='pref-value-text'/>").appendTo($value);
      $txt.attr("type", inputType);
      
      $txt.val(value);
      
      $txt.keyup(_flushTextValue);
      
      function _flushTextValue() {
        $item.data("value", $txt.val());
      }
    }
    else if (isFieldType(item.FieldDataType, [LkSN.MetaFieldDataType.DropDown, LkSN.MetaFieldDataType.SingleChoice, LkSN.MetaFieldDataType.MultipleChoice])) {
      $item.addClass("pref-item-arrow");
      $item.attr("data-itemid", value); 
      
      var selCodes = (value || "").split(",");
      var selNames = [];
      var options = [];
      var fieldItems = item.MetaFieldItemList || [];
      for (var i=0; i<fieldItems.length; i++) {
        var fieldItem = fieldItems[i];
        var code = fieldItem.MetaFieldItemCode || fieldItem.MetaFieldItemName;
        var name = fieldItem.MetaFieldItemName;
        options.push({"ItemId":code, "ItemName":name});
        
        if (selCodes.indexOf(code) >= 0)
          selNames.push(name);
      }
      $value.text(selNames.join(", "));
      
      $item.click(function() {
        UIMob.showPrefList({
          "PrefItem": $item,
          "MultipleChoice": (item.FieldDataType == LkSN.MetaFieldDataType.MultipleChoice.code),
          "OptionList": options,
          "onClose": function() {
            $item.data("value", $item.attr("data-itemid"));
          }
        });
      });
    }
//    else if (isFieldType(item.FieldDataType, [LkSN.MetaFieldDataType.Date])) {
//      $item.click(function() {
//        UIMob.showDateTimePicker();
//      });
//    }
    else
      $value.css("color", "var(--base-red-color)").text(" - " + getLookupDesc(LkSN.MetaFieldDataType, item.FieldDataType) + " - ");
  }

});
