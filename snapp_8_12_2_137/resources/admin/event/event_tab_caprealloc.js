//# sourceURL=event_tab_caprealloc.js

/*
"config" structure: {
  "SeatCategoryList": [
    {
      "SeatCategoryId": "",
      "SeatCategoryName": ""
    }
  ],
  "SeatEnvelopeList": [
    {
      "SeatEnvelopeId": "",
      "SeatEnvelopeName": ""
    }
  ]
}

"data" structure is matches DOEvent.CapacityThresholdList 
*/

$(document).ready(function() {
  const VT_ABS  = 1; // LkSNPriceValueType.Absolute
  const VT_PERC = 2; // LkSNPriceValueType.Percentage
  const EntityType_Event = 5; // LkSNEntityType.Event
  
  let $matrix = $("#caprealloc-matrix");
  $(document).von($matrix, "caprealloc-config", _onConfigChange);
  $("#btn-event-caprealloc-save").click(_save);
  $("#btn-event-caprealloc-config").click(_showConfigDialog);
  $("#btn-event-caprealloc-threshold-add").click(_addThreshold);
  $("#btn-event-caprealloc-threshold-del").click(_delThreshold);
  
  _initGrid();
  
  function _initGrid() {
    let data = JSON.parse($matrix.attr("data-caprealloc")) || [];
    $matrix.removeAttr("data-caprealloc");
    
    let config = {
      "SeatCategoryList": [],
      "SeatEnvelopeList": []
    };

    for (const threshold of data) {
      for (const detail of threshold.DetailList || []) {
        if (config.SeatCategoryList.findIndex(it => it.SeatCategoryId==detail.SeatCategoryId) < 0)
          config.SeatCategoryList.push({"SeatCategoryId":detail.SeatCategoryId, "SeatCategoryName":detail.SeatCategoryName});      

        if (config.SeatEnvelopeList.findIndex(it => it.SeatEnvelopeId==detail.SeatEnvelopeId) < 0)
          config.SeatEnvelopeList.push({"SeatEnvelopeId":detail.SeatEnvelopeId, "SeatEnvelopeName":detail.SeatEnvelopeName});      
      }
    }
    
    _updateGrid(config, data);
  }
  
  function _onConfigChange(event, config) {
    _updateGrid(config, _gridToData());
  }

  function _updateGrid(config, data) {
    config = config || {};
    data = data || [];
    
    config.SeatEnvelopeList = config.SeatEnvelopeList || [];
    config.SeatCategoryList = config.SeatCategoryList || [];
    
    $matrix.data("caprealloc-config", config);

    $matrix.empty();
    let $thead = $("<thead/>").appendTo($matrix);
    let $tbody = $("<tbody/>").appendTo($matrix);
    let $trHeaderEnv = $("<tr/>").appendTo($thead);
    let $trHeaderCat = $("<tr/>").appendTo($thead);
    
    // Print Header
    let $tdConfig = $("<td rowspan='2'/>").appendTo($trHeaderEnv);
    $tdConfig.attr("colspan", 2);
    $tdConfig.text(itl("@Common.Threshold"));
    
    for (const env of config.SeatEnvelopeList) {
      let $tdEnv = $("<td/>").appendTo($trHeaderEnv);
      $tdEnv.attr("colspan", config.SeatCategoryList.length);
      $tdEnv.attr("data-seatenvelopeid", env.SeatEnvelopeId);
      $tdEnv.text(env.SeatEnvelopeName);
    
      for (const cat of config.SeatCategoryList) {
        let $tdCat = $("<td/>").appendTo($trHeaderCat);
        $tdCat.attr("data-seatcategoryid", cat.SeatCategoryId);
        $tdCat.text(cat.SeatCategoryName);
      }
    }
    
    // Print Body
    for (const threashold of data) 
      _addDataRow(config, threashold);
  }
  
  function _addDataRow(config, threashold) {
    let $tbody = $matrix.find("tbody");
    let $tr = $("<tr/>").appendTo($tbody);
    $tr.append("<td class='row-del'><input type='checkbox' class='cblist'/></td>"); 
    
    let $tdThreshold = _createDataCell("caprealloc-threshold").appendTo($tr);
    
    threashold = threashold || {};
    _setCellValue($tdThreshold, threashold.ThresholdValue, threashold.ThresholdValueType);
    
    for (const env of config.SeatEnvelopeList) {
      for (const cat of config.SeatCategoryList) {
        let $td = _createDataCell("caprealloc-detail").appendTo($tr);
        $td.attr("data-seatcategoryid", cat.SeatCategoryId);
        $td.attr("data-seatenvelopeid", env.SeatEnvelopeId);
        
        let cellValue = _findCellValue(threashold, cat.SeatCategoryId, env.SeatEnvelopeId);
        if (cellValue)
          _setCellValue($td, cellValue.Value, cellValue.ValueType);
      }
    }
    
    return $tr;
  }
  
  function _createDataCell(clazz) {
    let $td = $("<td class='" + clazz + "'><input type='text' class='cell-value'/></td>");
    let $input = $td.find("input");
    $input.on("focusout", _validateDataCell);
    return $td;
  }  
  
  function _findCellValue(threasholdItem, seatCategoryId, seatEnvelopeId) {
    for (const detail of threasholdItem.DetailList || [])
      if ((detail.SeatCategoryId == seatCategoryId) && (detail.SeatEnvelopeId == seatEnvelopeId))
        return {"Value":detail.Value, "ValueType":detail.ValueType};
    
    return null;
  }
  
  function _setCellValue($td, value, valueType) {
      let validValue = !isNaN(value) && (value !== 0) && (getNull(value) != null);    
    
      let display = "";
      if (validValue) {
        if (valueType == VT_PERC) 
          display = value + "%";
        else
          display = value;
      }
    
      if (!validValue) {
        $td.removeAttr("data-value");
        $td.removeAttr("data-valuetype");
      }
      else {
        $td.attr("data-value", value);
        $td.attr("data-valuetype", valueType);
      }

      $td.find("input").val(display);
  }
  
  function _validateDataCell() {
    let $input = $(this);
    let $td = $input.closest("td");
    let value = 0;
    let valueType = VT_ABS;
    let val = $input.val().trim();
    
    if (val.length > 0) {
      valueType = val.endsWith("%") ? VT_PERC : VT_ABS;
      val = val.replaceAll("%", "");
      val = val.replaceAll(",", ".");
      value = parseFloat(val);
    }
    
    if (val === "")
      _setCellValue($td, null, null);
    else if (isNaN(val))
      showIconMessage("warning", itl("@Common.InvalidValueError", $input.val()), function() {$input.focus()});
    else 
      _setCellValue($td, value, valueType);
  }
  
  function _showConfigDialog() {
    let config = $matrix.data("caprealloc-config");
    let seatCategoryIDs = config.SeatCategoryList.map(it => it.SeatCategoryId).join(",");
    let seatEnvelopeIDs = config.SeatEnvelopeList.map(it => it.SeatEnvelopeId).join(",");
    asyncDialogEasy("event/event_caprealloc_config_dialog", "SeatCategoryIDs=" + seatCategoryIDs + "&SeatEnvelopeIDs=" + seatEnvelopeIDs);
  }
  
  function _addThreshold() {
    let config = $matrix.data("caprealloc-config");
    _addDataRow(config, {});
  }
  
  function _delThreshold() {
    $matrix.find(".cblist:checked").closest("tr").remove();
  }
  
  function _gridToData() {
    let data = [];
    
    $matrix.find("tbody tr").each(function(index, elem) {
      let $tr = $(elem);
      let $threshold = $tr.find(".caprealloc-threshold");
      let threshold = {
        "ThresholdValue": __decodeValue($threshold.attr("data-value")),
        "ThresholdValueType": __decodeType($threshold.attr("data-valuetype")),
        "DetailList": []
      };
      
      $tr.find(".caprealloc-detail").each(function(index, elem) {
        let $td = $(this);
        threshold.DetailList.push({
          "SeatCategoryId": $td.attr("data-seatcategoryid"),
          "SeatEnvelopeId": $td.attr("data-seatenvelopeid"),
          "Value": __decodeValue($td.attr("data-value")),
          "ValueType": __decodeType($td.attr("data-valuetype"))
        });
      });
      
      data.push(threshold);
    });
    
    function __decodeValue(value) {
      let result = parseFloat(value);
      return isNaN(result) ? 0 : result;
    }
    
    function __decodeType(value) {
      let result = parseInt(value);
      return isNaN(result) ? VT_ABS : result;
    }
   
    return data;
  }
  
  function _save() {
    snpAPI.cmd("Event", "SaveEvent", {
      "Event": {
        "EventId": $matrix.attr("data-eventid"),
        "CapacityReallocationByTask": $("#event\\.CapacityReallocationByTask").isChecked(),
        "CapacityThresholdList": _gridToData()
      }
    }).then(ansDO => entitySaveNotification(EntityType_Event, ansDO.EventId, "tab=caprealloc"));
  }
  
});