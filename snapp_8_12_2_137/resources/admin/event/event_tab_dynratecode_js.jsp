<%@page import="com.vgs.snapp.dataobject.DOEvent.DODynRateCode"%>
<%@page import="com.vgs.snapp.dataobject.DOEvent.DODynPerformanceType"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageEvent" scope="request"/>
<jsp:useBean id="event" class="com.vgs.snapp.dataobject.DOEvent" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
boolean canEdit = pageBase.getRightCRUD().canUpdate();
%>

<script>

$(document).ready(function() {
  $("#btn-dynratecode-save").click(_saveDynRateCode);
  $("#menu-add-default").click(_addDefaultPerformanceType);
  $("#menu-add-ptype").click(_showPerformanceTypePickupDialog);
  
  <% for (DODynPerformanceType perfType : event.DynPerformanceTypeList) { %>
    _addPerformanceType(<%=perfType.getJSONString()%>);
  <% } %>
  
  
  function _showPerformanceTypePickupDialog() {
    showLookupDialog({
      EntityType: <%=LkSNEntityType.PerformanceType.getCode()%>,
      ShowCheckbox: true,
      isItemChecked: function(item) {
        return (_findPerfTypeWidget(item.ItemId).length > 0);
      },
      onPickup: function(item, add) {
        var $perfType = _findPerfTypeWidget(item.ItemId);
        if (add !== true) 
          $perfType.remove();
        else {
          if ($perfType.length == 0) {
            _addPerformanceType({
              PerformanceTypeId: item.ItemId,
              PerformanceTypeCode: item.ItemCode,
              PerformanceTypeName: item.ItemName
            });
          }
        }
      }
    });
  }
  
  function _findPerfTypeWidget(performanceTypeId) {
    return $("#dynratecode-tab-content .dynratecode-perftype[data-performancetypeid='" + performanceTypeId + "']");
  }
  
  function _addDefaultPerformanceType() {
    var $ptypes = $("#dynratecode-tab-content .dynratecode-perftype");
    var found = false;
    for (var i=0; i<$ptypes.length; i++) {
      var $ptype = $($ptypes[i]);
      if (!$ptype.hasAttr("data-performancetypeid")) {
        found = true;
        break;
      }
    }
      
    if (!found)
      _addPerformanceType({});
  }

  function _addPerformanceType(perfType) {
    var $perfType = $("#dynratecode-templates .dynratecode-perftype").clone().appendTo("#dynratecode-tab-content");
    if (perfType.PerformanceTypeId != null) {
      $perfType.attr("data-performancetypeid", perfType.PerformanceTypeId);
      $perfType.find(".widget-title-caption").text(perfType.PerformanceTypeName);
    }
    $perfType.find(".widget-title a[href='#remove']").click(_removePerfType);
    $perfType.find(".btn-add-slot").click(_addSlot);
    $perfType.find(".btn-remove-slot").click(_removeSlots);

    if (perfType.RateCodeList) {
      for (let i=0; i < perfType.RateCodeList.length; i++) {
      	var $slot = $("#dynratecode-templates .dynratecode-slotrow").clone().appendTo($perfType.find("tbody"));
        var rateCode = perfType.RateCodeList[i];
        $slot.find("[name='Threashold']").val(rateCode.Value);
        $slot.find("[name='SeatCategoryId']").val(rateCode.SeatCategoryId);
        $slot.find("[name='RateCodeId']").val(rateCode.RateCodeId);
      }
    }
  }
  
  function _removePerfType() {
    event.preventDefault();
    event.stopPropagation();
    $(this).closest(".dynratecode-perftype").remove();
  }
  
  function _addSlot() {
    var $perfType = $(this).closest(".dynratecode-perftype");
    var $slot = $("#dynratecode-templates .dynratecode-slotrow").clone().appendTo($perfType.find("tbody"));
  }
  
  function _removeSlots() {
    $(this).closest(".dynratecode-perftype").find(".cblist:checked").not(".header").closest(".dynratecode-slotrow").remove();
  }
  
  function _saveDynRateCode() {
    var reqDO = {
      Command: "SaveEvent",
      SaveEvent: {
        Event: {
          EventId: <%=JvString.jsString(pageBase.getId())%>,
          DynRateCodeType: $("[name='event\.DynRateCodeType']:checked").val(),
          DynRateCodeValueType: $("[name='event\.DynRateCodeValueType']:checked").val(),
          DynSaleChannelIDs: $("#event\\.DynSaleChannelIDs").val(),
          DynPerformanceTypeList: []
        }
      }
    };
    
    try {
      var $widgets = $(".dynratecode-perftype");
      for (var i=0; i<$widgets.length; i++) {
        var $widget = $($widgets[i]);
        var ptype = {
          PerformanceTypeId: $widget.attr("data-performancetypeid"),
          RateCodeList: []
        }
        
        var $rows = $widget.find(".dynratecode-slotrow"); 
        for (var k=0; k<$rows.length; k++) {
          var $row = $($rows[k]);
          var $value = $row.find("[name='Threashold']");
          var value = parseInt($value.val());
          if (isNaN(value)) {
            $value.focus();
            throw itl("@Common.InvalidValueError", $value.val());
          }
          
          ptype.RateCodeList.push({
            RateCodeId: $row.find("[name='RateCodeId']").val(),
            SeatCategoryId: $row.find("[name='SeatCategoryId']").val(),
            Value: value
          });
        }
        
        reqDO.SaveEvent.Event.DynPerformanceTypeList.push(ptype);
      }
    }
    catch (error) {
      showMessage(error);
    }
    
    console.log(reqDO);
    
    showWaitGlass();
    vgsService("Event", reqDO, false, function(ansDO) {
      hideWaitGlass();
      entitySaveNotification(<%=LkSNEntityType.Event.getCode()%>, reqDO.SaveEvent.Event.EventId, "tab=dynratecode");
    });
  }
});

</script>
