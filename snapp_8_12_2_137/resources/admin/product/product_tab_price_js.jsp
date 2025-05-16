<%@page import="java.util.List"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProduct" scope="request"/>
<jsp:useBean id="product" class="com.vgs.snapp.dataobject.DOProduct" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
String[] parentIDs = EntityTree.getIDs(pageBase.getConnector(), LkSNEntityType.ProductType, pageBase.getId());
JvDataSet dsPerfTypeAll = pageBase.getBL(BLBO_PerformanceType.class).getDS(parentIDs);
List<DOSaleChannelPriceFormula> listSalChannellAll = pageBase.getBL(BLBO_SaleChannel.class).findSaleChannelsPriceFormula(product.PriceGroupTagId.getString());
JvDataSet dsRateCodeAll = pageBase.getBL(BLBO_RateCode.class).getDS();
JvDataSet dsMembershipPointAll = pageBase.getBL(BLBO_RewardPoint.class).getRewardPointDS();
boolean canEdit = pageBase.getRightCRUD().canUpdate(); 
boolean isSiaeProduct = pageBase.getBL(BLBO_Siae.class).isSiaeProduct(pageBase.getId());
%>

<script>
//# sourceURL=product_tab_price_js.jsp
  var defaultCode = "DEFAULT";
  var dsPT = <%=dsPerfTypeAll.getDocJSON()%>;
  var dsSC = <%= JvUtils.listToJSONString(listSalChannellAll)%>
  var dsRC = <%=dsRateCodeAll.getDocJSON()%>;
  var dsMP = <%=dsMembershipPointAll.getDocJSON()%>;
  var matrix = <%=product.PriceDateList.getJSONString()%>;
  var canEdit = <%=canEdit%>;
  
  var dlgPriceSetup = $("#price-setup-dialog");
  var dlgAdvanceSetup = $("#advance-setup-dialog");
  var dlgMemPTSetup = $("#mempt-setup-dialog");
  var dlgPriceEdit = $("#price-edit-dialog");
  var advType = <%=product.ProductPriceAdvanceType.getInt()%>;
  var advTypeSaleChannel = <%=LkSNProductPriceAdvanceType.SaleChannel.getCode()%>;
  var advTypePerformanceType = <%=LkSNProductPriceAdvanceType.PerformanceType.getCode()%>;
  var advTypeRateCode = <%=LkSNProductPriceAdvanceType.RateCode.getCode()%>;
  
  var isSiaePrd = <%=isSiaeProduct%>;
  
  ActionType_NotSellable = <%=LkSNPriceActionType.NotSellable.getCode()%>;
  ActionType_Inherit = <%=LkSNPriceActionType.Inherit.getCode()%>;
  ActionType_Fixed = <%=LkSNPriceActionType.Fixed.getCode()%>;
  ActionType_Add = <%=LkSNPriceActionType.Add.getCode()%>;
  ActionType_Subtract = <%=LkSNPriceActionType.Subtract.getCode()%>;

  ValueType_Abs = <%=LkSNPriceValueType.Absolute.getCode()%>;
  ValueType_Perc = <%=LkSNPriceValueType.Percentage.getCode()%>;
  
  TimeUnitType_DAY = <%=LkSNTimeUnitType.DAY.getCode()%>;
  TimeUnitType_HOUR = <%=LkSNTimeUnitType.HOUR.getCode()%>;
  
  $("#matrix-tabs").disableSelection().sortable({
    items: "li:not(.matrix-tab-plus)",
    distance: 6
  });
  
  function doAddMatrixTab(data) {
    data = (data) ? data : {};
    data.PriceList = (data.PriceList) ? data.PriceList : [];
    data.ProductPriceDateSerialNumber = (data.ProductPriceDateSerialNumber) ? data.ProductPriceDateSerialNumber : 0;
    data.ProductPriceDateStatus = <%=LkSNProductPriceDateStatus.Active.getCode()%>;
        
    var $li = $("#price-templates .matrix-tab").clone().insertBefore(".matrix-tab-plus");
    
    $li.data("price-date", data);
    if (data.ProductPriceDateSerialNumber)
      $li.find(".matrix-tab-serial").text("#" + data.ProductPriceDateSerialNumber);

    doActivateMatrixTab($li);
    $li.click(function() {
      doActivateMatrixTab(this);
    });
    
        
    $li.find(".matrix-tab-remove").click(function() {
      var msg = <v:itl key="@Product.PriceDateDeleteConfirm" encode="JS" param1="#from#" param2="#to#"/>;
      msg = msg.replace("#from#", getDateCaption($li.attr("data-DateFrom"))).replace("#to#", getDateCaption($li.attr("data-DateTo")));
      confirmDialog(msg, function() {
        $li.remove();

        var $lis = $("#matrix-tabs li:not(.matrix-tab-plus)");
        if ($lis.length > 0) 
          doActivateMatrixTab($lis[0]);
        else 
          doActivateMatrixTab(doAddMatrixTab());
      })
    });
    
    $li.find(".matrix-tab-edit").click(showEditPriceDateDialog);
    
    return $li;
  }
  
  function getActiveTab() {
    return $("#matrix-tabs .matrix-tab-active");
  }
  
  function doActivateMatrixTab(li) {
    $("input").blur();
    $("#matrix-tabs li").removeClass("matrix-tab-active");
    $(li).addClass("matrix-tab-active");

    dlgPriceSetup.find("input[name='PerformanceTypeId']").setChecked(false);
    dlgPriceSetup.find("input[name='SaleChannelId']").setChecked(false);
    dlgAdvanceSetup.find("input[name='SaleChannelId']").setChecked(false);
    dlgAdvanceSetup.find("input[name='PerformanceTypeId']").setChecked(false);
    dlgAdvanceSetup.find("input[name='RateCodeId']").setChecked(false);
    dlgMemPTSetup.find("input[name='MembershipPointId']").setChecked(false);
    
    var priceDate = getActiveTab().data("price-date");
    
    $('#priceDate\\.ProductPriceDateSerialNumber').val(priceDate.ProductPriceDateSerialNumber);
      
    var priceList = (priceDate.PriceList) ? priceDate.PriceList : [];
    for (var i=0; i<priceList.length; i++) {
      dlgPriceSetup.find("input[name='PerformanceTypeId'][value='" + priceList[i].PerformanceTypeId + "']").setChecked(true);
      dlgPriceSetup.find("input[name='SaleChannelId'][value='" + priceList[i].SaleChannelId + "']").setChecked(true);
    }

    var days = [];
    var advanceList = (priceDate.AdvanceList) ? priceDate.AdvanceList : [];
    for (var i=0; i<advanceList.length; i++) {
      dlgAdvanceSetup.find("input[name='SaleChannelId'][value='" + advanceList[i].SaleChannelId + "']").setChecked(true);
      dlgAdvanceSetup.find("input[name='PerformanceTypeId'][value='" + advanceList[i].PerformanceTypeId + "']").setChecked(true);
      dlgAdvanceSetup.find("input[name='RateCodeId'][value='" + advanceList[i].RateCodeId + "']").setChecked(true);
      var sTimeUnit = combineTimeUnitAndType(advanceList[i].TimeUnit, advanceList[i].TimeUnitType);
      if (days.indexOf(sTimeUnit) < 0)
        days.push(sTimeUnit);
    }
    days = days.sort(function(a, b){return a-b});
    dlgAdvanceSetup.find("input[name='AdvanceDays']").val(days.join(","));

    var mpList = (priceDate.MembershipPointList) ? priceDate.MembershipPointList : [];
    for (var i=0; i<mpList.length; i++) 
      dlgMemPTSetup.find("input[name='MembershipPointId'][value='" + mpList[i].MembershipPointId + "']").setChecked(true);
    
    applySetup();
  }
  
  function showPriceDateDialog(data, callback) {
    data = (data) ? data : {};
    $("#ValidDateFrom-picker").datepicker("setDate", (data.ValidDateFrom) ? xmlToDate(data.ValidDateFrom) : null);
    $("#ValidDateTo-picker").datepicker("setDate", (data.ValidDateTo) ? xmlToDate(data.ValidDateTo) : null);
    $("#ValidTimeFrom-HH").val((data.ValidTimeFrom) ? data.ValidTimeFrom.substr(0, 2) : "HH");
    $("#ValidTimeFrom-MM").val((data.ValidTimeFrom) ? data.ValidTimeFrom.substr(3, 2) : "MM");
    
    $("#price-date-dialog").dialog({
      modal: true,
      width: 350,
      height: 250,
      buttons: {
        <v:itl key="@Common.Ok" encode="JS"/>: function() {
          var result = {
            ValidDateFrom: $("#ValidDateFrom-picker").datepicker("getDate"),  
            ValidDateTo: $("#ValidDateTo-picker").datepicker("getDate"),
            ValidTimeFrom: null,
            ValidTimeTo: null
          };
          
          result.ValidDateFrom = (result.ValidDateFrom) ? dateToXML(result.ValidDateFrom) : null; 
          result.ValidDateTo = (result.ValidDateTo) ? dateToXML(result.ValidDateTo) : null; 

          if (callback) 
            callback(result);
          $("#price-date-dialog").dialog("close");
        },
        <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
      }
    });
  }
  
  function showEditPriceDateDialog() {
    showPriceDateDialog(getActiveTab().data("price-date"), function(data) {
      var tabData = getActiveTab().data("price-date");
      tabData.ValidDateFrom = data.ValidDateFrom;
      tabData.ValidDateTo = data.ValidDateTo;
      tabData.ValidTimeFrom = data.ValidTimeFrom;
      tabData.ValidTimeTo = data.ValidTimeTo;
      getActiveTab().data("price-date", tabData);
      applyDateCaptions();
    });
  }
  
  $("#matrix-tabs .matrix-tab-plus").click(function() {
    showPriceDateDialog(null, function(data) {
      doAddMatrixTab(data);
    });
  });
  
  function showPriceSetupDialog() {
    <% if (canEdit) { %>
    dlgPriceSetup.dialog({
      modal: true,
      width: 540,
      height: 500,
      resizable: false,
      buttons: {
        <v:itl key="@Common.Ok" encode="JS"/>: function() {
          $(this).dialog("close");
          applySetup();
        },
        <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
      }
    });
    <% } %>
  }

  function showAdvanceSetupDialog() {
    <% if (canEdit) { %>
    dlgAdvanceSetup.dialog({
      modal: true,
      width: 540,
      height: 500,
      resizable: false,
      buttons: {
        <v:itl key="@Common.Ok" encode="JS"/>: function() {
          try {
            getDlgTimeUnits(dlgAdvanceSetup); // Assert time units string is good before closing the dialog
            $(this).dialog("close");
            applySetup();
          } 
          catch (e) {
            showIconMessage("warning", e.message);
          }
        },
        <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
      }
    });
    <% } %>
  }

  function showMemPTSetupDialog() {
    <% if (canEdit) { %>
    dlgMemPTSetup.dialog({
      modal: true,
      width: 540,
      height: 500,
      resizable: false,
      buttons: {
        <v:itl key="@Common.Ok" encode="JS"/>: function() {
          dlgMemPTSetup.dialog("close");
          applySetup();
        },
        <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
      }
    });
    <% } %>
  }

  function showPriceEditDialog(actionType, valueType, value, isDefault, callback) {
    <% if (canEdit) { %>
    setRadioChecked("input[name='ActionType']", (actionType) ? actionType : ActionType_NotSellable);
    setRadioChecked("input[name='ValueType']", (valueType) ? valueType : ValueType_Abs);
    $("#cell-value-edit").val((value) ? value : "");
    
    setVisible("#ActionType-" + ActionType_Inherit + "-lbl", !isDefault);
    setVisible("#ActionType-" + ActionType_Add + "-lbl", !isDefault && !isSiaePrd);
    setVisible("#ActionType-" + ActionType_Subtract + "-lbl", !isDefault && !isSiaePrd);
    setVisible("#ValueType-" + ValueType_Perc + "-lbl", !isDefault && !isSiaePrd);
    
    if (isSiaePrd)
        setVisible("#ActionType-" + ActionType_Fixed + "-lbl", isDefault);

    priceEditRefreshVisibility();
    
    dlgPriceEdit.dialog({
      modal: true,
      width: 300,
      resizable: false,
      buttons: [
        {
          "text": <v:itl key="@Common.Ok" encode="JS"/>,
          "class": "btn-ok",
          "click": function() {
            var actionType = parseInt($("input[name='ActionType']:checked").val());
            var valueType = parseInt($("input[name='ValueType']:checked").val());
            var value = parseFloat($("#cell-value-edit").val().replace(",", "."));
            callback(actionType, valueType, isNaN(value) ? 0 : value);
            dlgPriceEdit.dialog("close");
          }
        },
        {
          "text": <v:itl key="@Common.Cancel" encode="JS"/>,
          "click": doCloseDialog
        }
      ]
    });
    dlgPriceEdit.find("#cell-value-edit").focus();
    <% } %>
  }
  
  function encodePercentageValue(value) {
    value = value.replace("%", "");
    value = value.replace(",", ".");
    value = parseFloat(value);
    return isNaN(value) ? null : value;
  }
  
  function decodePercentageValue(value) {
    if (value) 
      return value + "%";
    else
      return "";
  }
  
  function encodePresaleValue() {
    if (<%= product.ProductType.isLookup(LkSNProductType.Presale)%>) 
      return null
    else 
      return  encodePercentageValue($("#product\\.PresaleValue").val());
  }

  function encodePresaleValueType() {
    if (<%= product.ProductType.isLookup(LkSNProductType.Presale)%>) 
      return ValueType_Abs;
    else {
      var value = $("#product\\.PresaleValue").val();
      return (value.indexOf("%") < 0) ? ValueType_Abs : ValueType_Perc;
    }
  }

  function decodePresaleValue(value, presaleType) {
    return (presaleType === ValueType_Perc) ? value + "%" : value;
  }
  
  function checkRequired(productDO, callback) {
    var errors = [];  
    
    if ((productDO.TaxCalcType == <%=LkSNTaxCalcType.TaxIncluded.getCode()%>) || (productDO.TaxCalcType == <%=LkSNTaxCalcType.TaxExcluded.getCode()%>)) {
      if (getNull(productDO.TaxProfileId) == null)
        errors.push(itl("@Common.MandatoryFieldMissingError", itl("@Product.TaxProfile")));
    }
    
    if (errors.length == 0)
      callback();
    else
      showIconMessage("warning", errors.join("\n"));
  }
 
  function doSave() {
    var productDO = {
      ProductId: <%=JvString.jsString(pageBase.getId())%>,
      TaxCalcType: parseInt($("[name='TaxCalcType']:checked").val()),
      TaxProfileId: $("#product\\.TaxProfileId").val(),
      ApplyTaxOnFacePrice: $("#product\\.ApplyTaxOnFacePrice").isChecked(),
      VariablePrice: $("#product\\.VariablePrice").isChecked(),
      VariablePriceFreeInput: $("#product\\.VariablePriceFreeInput").isChecked(),
      FeeTransactionPercentage: $("#product\\.FeeTransactionPercentage").isChecked(),
      FeePercTagIDs: $("#product\\.FeePercTagIDs").val(),
      VariablePriceMin: strToFloatDef($("#product\\.VariablePriceMin").val(), null),
      VariablePriceMax: strToFloatDef($("#product\\.VariablePriceMax").val(), null),
      PresaleValue: encodePresaleValue(),
      PresaleValueType: encodePresaleValueType(),
      PresaleProductId: $("#product\\.PresaleProductId").val(),
      ProductPriceAdvanceType: advType,
      ChargeToWallet: $("#product\\.ChargeToWallet").isChecked(),
      ClearingLimitPerc: encodePercentageValue($("[name='ClearingLimitPerc']").val()),
      ClearingLimitIncludeBearedDisc: $("#product\\.ClearingLimitIncludeBearedDisc").isChecked(),
      ClearingLimitIncludeBearedTaxes: $("#product\\.ClearingLimitIncludeBearedTaxes").isChecked(),
      PosPricingPluginId: $("#product\\.PosPricingPluginId").val(),
      WebPricingPluginId: $("#product\\.WebPricingPluginId").val(),
      PriceGroupTagId: $("#product\\.PriceGroupTagId").val(),
      PriceDateList: [],
      PriceVariableList: [],
      TaxablePrice: encodePercentageValue($("[name='TaxablePrice']").val()),
    }
    
    var tabs = $("#matrix-tabs li:not(.matrix-tab-plus)");
    for (var i=0; i<tabs.length; i++) 
      productDO.PriceDateList.push($(tabs[i]).data("price-date"));
    
    if (productDO.VariablePrice === true) {
      $("#varprice-preset-amounts .varprice-preset-amount").each(function(index, item) {
        var $item = $(item);
        productDO.PriceVariableList.push({
          "PriceValueType": parseInt($item.attr("data-type")),
          "PriceValue": parseFloat($item.attr("data-value"))
        });
      });
    }

    checkRequired(productDO, function() {
      snpAPI.cmd("Product", "SaveProduct", {
        "Product": productDO
      }).then(ansDO => { 
        entitySaveNotification(<%=LkSNEntityType.ProductType.getCode()%>, ansDO.ProductId, "tab=price");
      });
    });
  }
  
  function priceEditRefreshVisibility() {
    setVisible(dlgPriceEdit.find("#amount-container"), [ActionType_NotSellable, ActionType_Inherit].indexOf(parseInt($("input[name='ActionType']:checked").val())) < 0);
  }
  
  $("input[name='ActionType']").change(function() {
    priceEditRefreshVisibility();
  });
  
  dlgPriceEdit.keypress(function(event) {
    if (event.keyCode == KEY_ENTER) 
      dlgPriceEdit.closest(".ui-dialog").find(".btn-ok").trigger("click");
  });
  
  function getDlgPTIDs(dlg) {
    var result = [];
    var cbs = $(dlg).find("input[name='PerformanceTypeId']:checked");
    for (var i=0; i<cbs.length; i++) 
      result.push($(cbs[i]).val());
    return result;
  }
  
  function getDlgSCIDs(dlg) {
    var result = [];
    var cbs = $(dlg).find("input[name='SaleChannelId']:checked");
    for (var i=0; i<cbs.length; i++) 
      result.push($(cbs[i]).val());
    return result;
  }
  
  function getDlgRCIDs(dlg) {
    var result = [];
    var cbs = $(dlg).find("input[name='RateCodeId']:checked");
    for (var i=0; i<cbs.length; i++) 
      result.push($(cbs[i]).val());
    return result;
  }
  
  function getDlgMPIDs(dlg) {
    var result = [];
    var cbs = $(dlg).find("input[name='MembershipPointId']:checked");
    for (var i=0; i<cbs.length; i++) 
      result.push($(cbs[i]).val());
    return result;
  }
  
  function getDlgAdvanceIDs(dlg) {
    var result = [];
    var cbs;
    if (advType == advTypePerformanceType)
      cbs = $(dlg).find("input[name='PerformanceTypeId']:checked");
    else if (advType == advTypePerformanceType)
      cbs = $(dlg).find("input[name='RateCodeId']:checked");
    else 
      cbs = $(dlg).find("input[name='SaleChannelId']:checked");
    for (var i=0; i<cbs.length; i++) 
      result.push($(cbs[i]).val());
    return result;
  }

  function getDlgTimeUnits(dlg) {
    var timeUnits = [];
    var type = "";
    var sTimeUnits = $(dlg).find("[name='AdvanceDays']").val().split(",");
    for (var i = 0; i < sTimeUnits.length; i++) {
      var sTimeUnit = sTimeUnits[i].trim();
      if (sTimeUnit != "") {
        if (sTimeUnit.endsWith("h") || sTimeUnit.endsWith("d")) {
          type = sTimeUnit.slice(-1); // Extract type
          var timeUnit = parseInt(sTimeUnit.slice(0, -1)); // Extract time unit
          if (isNaN(timeUnit)) 
            throw new Error("Invalid time unit: " + timeUnit);
          if (timeUnit < 0)
            timeUnit = timeUnit * -1;
          if (type === "h" && timeUnit >= 24) 
            throw new Error("Invalid time unit: " + sTimeUnit + " (must be less than 24h)");
          timeUnits.push({ timeUnit: timeUnit, type: type });
        } 
        else
          throw new Error("Invalid format: " + sTimeUnit);
      }
    }
    
    // Sort array based on time unit number and type
    timeUnits.sort(function(a, b) {
      if (a.type == b.type)  
        return a.timeUnit - b.timeUnit; // If types are the same, sort by time unit number
      else
        return a.type == "h" ? -1 : 1; // If types are different, sort by type ('h' before 'd') 
    });
    
    // Update the dialog with sorted values
    var sortedTimeUnits = timeUnits.map(function(d) { return d.timeUnit + d.type; });
    $(dlg).find("[name='AdvanceDays']").val(sortedTimeUnits.join(","));
    return sortedTimeUnits;
  }

  function findPT(ptId) {
    for (var i=0; i<dsPT.length; i++) {
      if (dsPT[i].PerformanceTypeId == ptId)
        return dsPT[i];
    }
    return null;
  }
  
  function findSC(scId) {
    for (var i=0; i<dsSC.length; i++) {
      if (dsSC[i].SaleChannelId == scId)
        return dsSC[i];
    }
    return null;
  }
  
  function findRC(rcId) {
    for (var i=0; i<dsRC.length; i++) {
      if (dsRC[i].RateCodeId == rcId)
        return dsRC[i];
    }
    return null;
  }
  
  function findMP(mpId) {
    for (var i=0; i<dsMP.length; i++) {
      if (dsMP[i].MembershipPointId == mpId)
        return dsMP[i];
    }
    return null;
  }
  
  function getPTName(ptId, includeFormala) {
    if (ptId == defaultCode)
      return "<v:itl key="@Common.Default"/>";
    else {
      var pt = findPT(ptId);
      if (pt != null) {
        var result = pt.PerformanceTypeName;
        if (includeFormala)
          result += "<br/>" + getLabelFormulaHTML(pt);
        return result;
      }
    } 
    return "";
  }
  
  function getSCName(scId, includeFormala) {
    if (scId == defaultCode)
      return "<v:itl key="@Common.Default"/>";
    else {
      var sc = findSC(scId);
      if (sc != null) {
        var result = sc.SaleChannelName;
        if (includeFormala)
          result += "<br/>" + getLabelFormulaHTML(sc);
        return result;
      } 
    }
    return "";
  }
  
  function getRCName(rcId, includeFormala) {
    if (rcId == defaultCode)
      return "<v:itl key="@Common.Default"/>";
    else {
      var rc = findRC(rcId);
      if (rc != null) {
        var result = rc.RateCodeName;
        if (includeFormala)
          result += "<br/>" + getLabelFormulaHTML(rc);
        return result;
      } 
    }
    return "";
  }
  
  function getMPName(mpId) {
    var mp = findMP(mpId);
    if (mp != null) 
      return mp.MembershipPointName;
    return "";
  }
  
  function getAdvanceName(id, includeFormala) {
    if (advType == advTypeSaleChannel)
      return getSCName(id, includeFormala);
    else if (advType == advTypePerformanceType)
      return getPTName(id, includeFormala);
    else if (advType == advTypeRateCode)
      return getRCName(id, includeFormala);
    else
      return getSCName(id, includeFormala);
  }
  
  function findPriceValue(ptId, scId) {
    var priceDate = getActiveTab().data("price-date");
    for (var i=0; i<priceDate.PriceList.length; i++) 
      if ((priceDate.PriceList[i].PerformanceTypeId == ptId) && (priceDate.PriceList[i].SaleChannelId == scId))
        return priceDate.PriceList[i];
    return null;
  }
 
  function findAdvanceValue(timeUnit, type, id) {
    var priceDate = getActiveTab().data("price-date");
    for (var i=0; i<priceDate.AdvanceList.length; i++) {
      var cell = priceDate.AdvanceList[i];
      var cellId = cell.SaleChannelId;
      if (advType == advTypePerformanceType)
        cellId = cell.PerformanceTypeId;
      if (advType == advTypeRateCode)
        cellId = cell.RateCodeId;
      if ((cell.TimeUnit == timeUnit && cell.TimeUnitType == type ) && (cellId == id))
        return cell;
    }
    return null;
  }
  
  function findMemPTValue(mpId) {
    var priceDate = getActiveTab().data("price-date");
    for (var i=0; i<priceDate.MembershipPointList.length; i++) 
      if (priceDate.MembershipPointList[i].MembershipPointId == mpId) 
        return priceDate.MembershipPointList[i];
    return null;
  }
  
  function getObjValue(obj, valueType) {
    if (obj != null) {
      var at = (obj.PriceActionType != null) ? obj.PriceActionType : obj.ActionType;
      var vt = (obj.PriceValueType != null) ? obj.PriceValueType : obj.ValueType;
      var v = (obj.PriceValue != null) ? obj.PriceValue : obj.Value;
      if ((vt == valueType) && (v != null)) {
        if (at == ActionType_Fixed)
          return 0;
        else {
          var value = parseFloat(v);
          if (at == ActionType_Subtract)
            value = value * -1;
          return value;
        }
      }
    }
    return 0;
  }

  function getFormulaHTML(abs, perc, inherited) {
    var result = "";

    if (abs < 0)
      result += formatCurr(abs); //abs + "$";
    else if (abs > 0)
      result += "+" + formatCurr(abs); // abs + "$";
    
    if (abs != 0 && perc != 0) 
      result += " / ";
    
    if (perc < 0)
      result += perc + "%";
    else if (perc > 0)
      result += "+" + perc + "%";
    
    if (inherited && result != "")
      result = "(" + result + ")";
    
    return "<span class='value-params'>" + result + "</span>";
  }
  
  function getLabelFormulaHTML(obj) {
    return getFormulaHTML(getObjValue(obj, ValueType_Abs).toFixed(2), getObjValue(obj, ValueType_Perc), true);
  }
  
  function calcPriceVariation(basePrice, actionType, valueType, value) {
    var amount = (valueType == ValueType_Abs) ? value : (basePrice * value / 100);
    if (actionType == ActionType_Fixed) 
      return amount;
    else if ((actionType == ActionType_Add) || (actionType == ActionType_Subtract)) {
      var sign = (actionType == ActionType_Add) ? 1 : -1;
      return basePrice + amount * sign;
    } 
    else
      return null;
  }
  
  function getValueHTML(ptId, scId) {
    var value = findPriceValue(ptId, scId);
    var base = findPriceValue(defaultCode, defaultCode);
    
    if (value != null) {
      if (value.ActionType == ActionType_Fixed) {
        var basePrice = (base == null) ? 0 : base.Value;
        var result = formatCurr(calcPriceVariation(basePrice, value.ActionType, value.ValueType, value.Value));
          
        if ((value.PerformanceTypeId == defaultCode) && (value.SaleChannelId == defaultCode))
          result = "<strong>" + result + "</strong>";
        else if (value.ValueType == ValueType_Perc) 
          result += "<br/>" + getFormulaHTML(0, value.Value - 100, false);
          
        return result;
      }
      else if ((base != null) && (value.ActionType != ActionType_NotSellable)) {
        var basePrice = strToFloatDef(base.Value, 0);
        var absDelta = 0;
        var percDelta = 0;
        if (value.ActionType == ActionType_Inherit) {
          var pt = (ptId == defaultCode) ? null : findPriceValue(ptId, defaultCode);
          if ((pt == null) || (pt.ActionType == ActionType_Inherit))
            pt = findPT(ptId);
          var sc = (scId == defaultCode) ? null : findPriceValue(defaultCode, scId);
          if ((sc == null) || (sc.ActionType == ActionType_Inherit))
            sc = findSC(scId);
          
          if ((pt) && (sc) && (pt.ActionType == ActionType_Fixed) && (sc.ActionType == ActionType_Fixed)) {
            basePrice = Math.max(pt.Value, sc.Value);
          }
          else {
            if ((pt) && (pt.ActionType == ActionType_Fixed))
              basePrice = calcPriceVariation(basePrice, pt.ActionType, pt.ValueType, pt.Value);
            else if ((sc) && (sc.ActionType == ActionType_Fixed))
              basePrice = calcPriceVariation(basePrice, sc.ActionType, sc.ValueType, sc.Value);
            
            absDelta = getObjValue(pt, ValueType_Abs) + getObjValue(sc, ValueType_Abs);
            percDelta = getObjValue(pt, ValueType_Perc) + getObjValue(sc, ValueType_Perc);
          }
        }
        else {
          if (value.ValueType == ValueType_Abs)
            absDelta = strToFloatDef(value.Value, 0);
          else
            percDelta = strToFloatDef(value.Value, 0);
          if (value.ActionType == ActionType_Subtract) {
            absDelta *= -1;
            percDelta *= -1;
          }
        }
        var finalPrice = (basePrice + absDelta) * (100 + percDelta) / 100;
        
        if (isSiaePrd) { 
            absDelta = 0;
            percDelta = 0;
            finalPrice = base.Value;
          }

        var result = formatCurr(finalPrice);
        if (absDelta != 0 || percDelta != 0) 
          result += "<br/>" + getFormulaHTML(absDelta.toFixed(2), percDelta, value.ActionType == ActionType_Inherit);
        return result;
      }
    }

    return "-";
  }
  
  function getAdvanceCellHTML(value) {
    if (value != null) {
      var priceValue = strToFloatDef(value.Value, 0);
      var sign = null;
      
      if (value.ActionType == ActionType_Inherit)
        return "=";
      if (value.ActionType == ActionType_Fixed) 
        sign = "";
      else if (value.ActionType == ActionType_Add)
        sign = "+ ";
      else if (value.ActionType == ActionType_Subtract)
        sign = "- ";
      
      if (sign != null) {
        var amount = (value.ValueType == ValueType_Abs) ? formatCurr(priceValue) : priceValue + "%";
        return sign + amount;
      }
    }
    return "-";
  }
  
  function setValue(value) {
    var priceDate = getActiveTab().data("price-date");
    var idx = -1;
    for (var i=0; i<priceDate.PriceList.length; i++) {
      if ((priceDate.PriceList[i].PerformanceTypeId == value.PerformanceTypeId) && (priceDate.PriceList[i].SaleChannelId == value.SaleChannelId)) {
        idx = i;
        break;
      }
    }
    if (idx < 0)
      priceDate.PriceList.push(value);
    else
      priceDate.PriceList[idx] = value;
    
    getActiveTab().data("price-date", priceDate);
    $("#" + value.PerformanceTypeId + "_" + value.SaleChannelId).html(getValueHTML(value.PerformanceTypeId, value.SaleChannelId));
  }
  
  function setAdvanceValue(value) {
    var priceDate = getActiveTab().data("price-date");
    var valueId = value.SaleChannelId;
    if (advType == advTypePerformanceType)
      valueId = value.PerformanceTypeId;
    if (advType == advTypeRateCode)
      valueId = value.RateCodeId;
    
    priceDate.AdvanceList = (priceDate.AdvanceList) ? priceDate.AdvanceList : [];
    for (var i=priceDate.AdvanceList.length-1; i>=0; i--) {
      var item = priceDate.AdvanceList[i];
      var itemId = item.SaleChannelId;
      if (advType == advTypePerformanceType)
        itemId = item.PerformanceTypeId;
      if (advType == advTypeRateCode)
        itemId = item.RateCodeId;
      if ((item.TimeUnit == value.TimeUnit) && (item.TimeUnitType == value.TimeUnitType) && (itemId == valueId))
        priceDate.AdvanceList.splice(i, 1); 
    }
    priceDate.AdvanceList.push(value);
    
    getActiveTab().data("price-date", priceDate);
    
    var td = $("#advance [data-AdvanceDays='" + value.TimeUnit + "'][data-SaleChannelId='" + valueId + "']");
    if (advType == advTypePerformanceType)
      td = $("#advance [data-AdvanceDays='" + value.TimeUnit + "'][data-PerformanceTypeId='" + valueId + "']");
    if (advType == advTypeRateCode)
      td = $("#advance [data-AdvanceDays='" + value.TimeUnit + "'][data-RateCodeId='" + valueId + "']");
    
    td.html(getAdvanceCellHTML(value));
  }
  
  function setMemPTValue(value) {
    var priceDate = getActiveTab().data("price-date");
    var idx = -1;
    for (var i=0; i<priceDate.MembershipPointList.length; i++) {
      if (priceDate.MembershipPointList[i].MembershipPointId == value.MembershipPointId) {
        idx = i;
        break;
      }
    }
    if (idx < 0)
      priceDate.MembershipPointList.push(value);
    else
      priceDate.MembershipPointList[idx] = value;
    
    getActiveTab().data("price-date", priceDate);
    $("#mempt td.value[data-MembershipPointId='" + value.MembershipPointId + "'] input").val(value.Value);
  }
  
  function setFeePercValue(value) {
    var priceDate = getActiveTab().data("price-date");
    priceDate.FeeTransactionPercValue = value;    
    getActiveTab().data("price-date", priceDate);
  }

  function getDateCaption(value) {
    return (value == "") ? <v:itl key="@Common.Always" encode="JS"/> : value;
  }
  
  function getDateCaptionHTML(value) {
    var clazz = (value == "") ? "date-always" : "date-fixed"; 
    return "<span class='" + clazz + "'>" + getDateCaption(value) + "</span>";
  }
  
  function applyDateCaptions() {
    var priceDate = getActiveTab().data("price-date");
    var sDateFrom = (priceDate.ValidDateFrom) ? formatDate(xmlToDate(priceDate.ValidDateFrom), <%=rights.ShortDateFormat.getInt()%>) : "";
    var sDateTo = (priceDate.ValidDateTo) ? formatDate(xmlToDate(priceDate.ValidDateTo), <%=rights.ShortDateFormat.getInt()%>) : "";
    
    var sTabCaption = getDateCaptionHTML(sDateFrom);
    if (sDateFrom != sDateTo)
      sTabCaption += "<br/>" + getDateCaptionHTML(sDateTo);
    
    getActiveTab().find(".matrix-tab-caption").html(sTabCaption);
    getActiveTab().find(".matrix-tab-caption").setClass("single-line", sDateFrom == sDateTo);
    getActiveTab().attr("data-DateFrom", sDateFrom);
    getActiveTab().attr("data-DateTo", sDateTo);
  }
  
  function applySetup() {
    var priceDate = getActiveTab().data("price-date");
    var ptIDs = [defaultCode].concat(getDlgPTIDs(dlgPriceSetup));
    var scIDs = [defaultCode].concat(getDlgSCIDs(dlgPriceSetup));
    var html = "";   
    
    $(".price-title").text(<v:itl key="@Product.PriceMatrixTitle" encode="JS"/>);
    $(".price-title-advance").text(<v:itl key="@Product.AdvanceMatrixTitle" encode="JS"/>);
    $(".price-title-membership").text(<v:itl key="@Product.MembershipMatrixTitle" encode="JS"/>);

    $('#priceDate\\.FeePercValue').val(priceDate.FeeTransactionPercValue);

    // Add new elements
    for (var p=0; p<ptIDs.length; p++) {
      for (var s=0; s<scIDs.length; s++) {
        if ((p!=0 || s!=0) && findPriceValue(ptIDs[p], scIDs[s]) == null) {
          priceDate.PriceList.push({
            "PerformanceTypeId": ptIDs[p],
            "SaleChannelId": scIDs[s],
            "ActionType": ActionType_Inherit,
            "ValueType": ValueType_Abs,
            "Value": "0"
          });
        }
      }
    } 
    // Remove unused elements
    for (var i=priceDate.PriceList.length-1; i>=0; i--) {
      var item = priceDate.PriceList[i];
      if ((ptIDs.indexOf(item.PerformanceTypeId) < 0) || (scIDs.indexOf(item.SaleChannelId) < 0))
        priceDate.PriceList.splice(i, 1);
    }
    // Render matrix 
    var table = $("#price").empty();
    for (var p=-1; p<ptIDs.length; p++) {
      var tr = $("<tr/>").appendTo(table);
      for (var s=-1; s<scIDs.length; s++) {
        var td = $("<td/>").appendTo(tr);
        var colHeader = (p < 0);
        var rowHeader = (s < 0);
        td.addClass((colHeader || rowHeader) ? "fixed" : "value");
        if (colHeader && rowHeader) {
          td.addClass("setup");
          td.attr("title", <v:itl key="@Product.PriceSetupHint" encode="JS"/>);
          td.click(showPriceSetupDialog);
          td.html("<i class='fa fa-cog'></i>");
        }
        else if (rowHeader)
          td.html(getPTName(ptIDs[p], !isSiaePrd));
        else if (colHeader)
          td.html(getSCName(scIDs[s], !isSiaePrd));
        else {
          var value = findPriceValue(ptIDs[p], scIDs[s]);
          td.setClass("custom", (value != null) && (value.ActionType != ActionType_Inherit));
          td.attr("data-PerformanceTypeId", ptIDs[p]);
          td.attr("data-SaleChannelId", scIDs[s]);
          td.attr("data-PerformanceTypeName", getPTName(ptIDs[p], false));
          td.attr("data-SaleChannelName", getSCName(scIDs[s], false));
          td.html(getValueHTML(ptIDs[p], scIDs[s]));
          
          value = (value) ? value : {};
          td.click(function() {
            var ptId = $(this).attr("data-PerformanceTypeId");
            var scId = $(this).attr("data-SaleChannelId");
            var value = findPriceValue(ptId, scId);
            var v = (value) ? value : {};
            var isDefault = (ptId == defaultCode) && (scId == defaultCode);
            
            if (v && !isDefault && isSiaePrd) {
                if (v.ActionType != ActionType_NotSellable) {
                  v.ActionType = ActionType_Inherit;
                  v.Value = 0;
                }
              }
            
            showPriceEditDialog(v.ActionType, v.ValueType, v.Value, isDefault, function(actionType, valueType, priceValue) {
              setValue({
                PerformanceTypeId: ptId,
                SaleChannelId: scId,
                ActionType: actionType,
                ValueType: valueType,
                Value: priceValue
              });
              applySetup();
            });
          });
        }
      }
    }
    
    dataToForm_Advance(priceDate);
    dataToForm_MemPT(priceDate);
    
    getActiveTab().data("price-date", priceDate);
    applyDateCaptions();
  }

  function resetPriceAdvanceSelection() {
    advType = $("#product\\.ProductPriceAdvanceType").val();
    if (advType == advTypePerformanceType) {
      dlgAdvanceSetup.find("input[name='SaleChannelId']").setChecked(false);
      dlgAdvanceSetup.find("input[name='RateCodeId']").setChecked(false);
    } else if (advType == advTypeRateCode) {
      dlgAdvanceSetup.find("input[name='SaleChannelId']").setChecked(false);
      dlgAdvanceSetup.find("input[name='PerformanceTypeId']").setChecked(false);
    } else {
      dlgAdvanceSetup.find("input[name='PerformanceTypeId']").setChecked(false);
      dlgAdvanceSetup.find("input[name='RateCodeId']").setChecked(false);
    }
  }
  
  function addNewAdvElements(list, timeUnit, timeUnitType, ids) {
    for (var s=0; s<ids.length; s++) {
    if ((s != 0) && findAdvanceValue(timeUnit, timeUnitType, ids[s]) == null) {
      if (advType == advTypeSaleChannel) { 
        list.push({
          "TimeUnitType": timeUnitType,  
          "TimeUnit": timeUnit,
          "SaleChannelId": ids[s],
          "PerformanceTypeId": "DEFAULT",
          "RateCodeId": "DEFAULT",
          "ActionType": ActionType_Inherit,
          "ValueType": ValueType_Abs,
          "Value": "0"
        });
      } else if (advType == advTypePerformanceType) {
        list.push({
          "TimeUnitType": timeUnitType,
          "TimeUnit": timeUnit,
          "SaleChannelId": "DEFAULT",
          "PerformanceTypeId": ids[s],
          "RateCodeId": "DEFAULT",
          "ActionType": ActionType_Inherit,
          "ValueType": ValueType_Abs,
          "Value": "0"
        });
      } else if (advType == advTypeRateCode) {
        list.push({
          "TimeUnitType": timeUnitType,
          "TimeUnit": timeUnit,
          "SaleChannelId": "DEFAULT",
          "PerformanceTypeId": "DEFAULT",
          "RateCodeId": ids[s],
          "ActionType": ActionType_Inherit,
          "ValueType": ValueType_Abs,
          "Value": "0"
        });
      }
    }
   }
  }
 
  function getTimeUnitType(timeUnitType) {
    type = timeUnitType == "h" ? TimeUnitType_HOUR :
           timeUnitType == "d" ? TimeUnitType_DAY :
           null;
    return type;
  }

  function extractTimeUnitAndType(advTimeUnit) {
    if (typeof advTimeUnit == "string") {
      var match = advTimeUnit.match(/(\d+)([a-zA-Z])/);
      if (match) {
        return {
            timeUnit: parseInt(match[1], 10), // Extracted time unit
            timeUnitType: getTimeUnitType(match[2]) // Extracted type
        };
      }
     }
    return null;
  }
  
  function combineTimeUnitAndType(timeUnit, timeUnitType) {
     var type = timeUnitType == TimeUnitType_HOUR ? "h" :
                timeUnitType == TimeUnitType_DAY ? "d" :
                null;
                  
     if (typeof timeUnit == "number")
       return timeUnit + type;
     return null;
  }
  
  function dataToForm_Advance(priceDate) {
    resetPriceAdvanceSelection();
    var scIDs = [defaultCode].concat(getDlgSCIDs(dlgAdvanceSetup));
    var ptIDs = [defaultCode].concat(getDlgPTIDs(dlgAdvanceSetup));
    var rcIDs = [defaultCode].concat(getDlgRCIDs(dlgAdvanceSetup));

    priceDate.AdvanceList = (priceDate.AdvanceList) ? priceDate.AdvanceList : [];

    var ids = scIDs;
    if (advType == advTypePerformanceType)
      ids = ptIDs;
    if (advType == advTypeRateCode)
      ids = rcIDs;
    
    // Add new elements
    var days = getDlgTimeUnits(dlgAdvanceSetup);
    for (var d=0; d<days.length; d++) {
      var extractedData = extractTimeUnitAndType(days[d]);
      addNewAdvElements(priceDate.AdvanceList, extractedData.timeUnit, extractedData.timeUnitType, ids);
    } 
    
    // Remove unused elements
    for (var i=priceDate.AdvanceList.length-1; i>=0; i--) {
      var item = priceDate.AdvanceList[i];
      var itemId = item.SaleChannelId;
      var itemTimeUnit = combineTimeUnitAndType(item.TimeUnit, item.TimeUnitType);
      if ((days.indexOf(itemTimeUnit) < 0) || (ids.indexOf(itemId) < 0)) 
        priceDate.AdvanceList.splice(i, 1);
    }
    
    // Render matrix 
    var table = $("#advance").empty();
    for (var d=-1; d<days.length; d++) {
      var tuData = extractTimeUnitAndType(days[d]);
      var tr = $("<tr/>").appendTo(table);
      for (var s=-1; s<ids.length; s++) {
        var td = $("<td/>").appendTo(tr);
        var colHeader = (d < 0);
        var rowHeader = (s < 0);
        td.addClass((colHeader || rowHeader) ? "fixed" : "value");
        if (colHeader && rowHeader) {
          td.addClass("setup");
          td.attr("title", "Configure advance days matrix");
          td.click(showAdvanceSetupDialog);
          td.html("<i class='fa fa-cog'></i>");
        }
        else if (rowHeader)
          td.text(days[d]);
        else if (colHeader) 
          td.html(getAdvanceName(ids[s], false));
        else {
          var value = findAdvanceValue(tuData.timeUnit, tuData.timeUnitType, ids[s]);
          td.setClass("custom", (value != null) && (value.ActionType != ActionType_Inherit));
          td.attr("data-AdvanceDays", days[d]);
          if (advType == advTypeSaleChannel)
            td.attr("data-SaleChannelId", ids[s]);
          else if (advType == advTypePerformanceType)
            td.attr("data-PerformanceTypeId", ids[s]);
          else if (advType == advTypeRateCode)
            td.attr("data-RateCodeId", ids[s]);
          
          td.html(getAdvanceCellHTML(value));
          
          value = (value) ? value : {};
          td.click(function() {
            var tuData = extractTimeUnitAndType($(this).attr("data-AdvanceDays"));
            var id;
            if (advType == advTypeSaleChannel)
              id = $(this).attr("data-SaleChannelId");
            else if (advType == advTypePerformanceType)
              id = $(this).attr("data-PerformanceTypeId");
            else if (advType == advTypeRateCode)
              id = $(this).attr("data-RateCodeId");
            var value = findAdvanceValue(tuData.timeUnit, tuData.timeUnitType, id);
            var v = (value) ? value : {};
            showPriceEditDialog(v.ActionType, v.ValueType, v.Value, false, function(actionType, valueType, priceValue) {
              if (advType == advTypeSaleChannel) {
                setAdvanceValue({
                  TimeUnitType: tuData.timeUnitType,
                  TimeUnit: tuData.timeUnit,
                  SaleChannelId: id,
                  PerformanceTypeId: "DEFAULT",
                  RateCodeId: "DEFAULT",
                  ActionType: actionType,
                  ValueType: valueType,
                  Value: priceValue
                });
              } else if (advType == advTypePerformanceType) {
                  setAdvanceValue({
                    TimeUnitType: tuData.timeUnitType,
                    TimeUnit: tuData.timeUnit,
                    SaleChannelId: "DEFAULT",
                    PerformanceTypeId: id,
                    RateCodeId: "DEFAULT",
                    ActionType: actionType,
                    ValueType: valueType,
                    Value: priceValue
                  });
              } else if (advType == advTypeRateCode) {
                  setAdvanceValue({
                    TimeUnitType: tuData.timeUnitType,
                    TimeUnit: tuData.timeUnit,
                    SaleChannelId: "DEFAULT",
                    PerformanceTypeId: "DEFAULT",
                    RateCodeId: id,
                    ActionType: actionType,
                    ValueType: valueType,
                    Value: priceValue
                  });
              }
              
              applySetup();
            });
          });
        }
      }
    }
  }
  
  function addNewMemPTElements(list, ids) {
    for (var i=0; i<ids.length; i++) {
      if (findMemPTValue(ids[i]) == null) {
        list.push({
          "MembershipPointId": ids[i], 
          "Value": 0
        });
      }
    }
  }

  function dataToForm_MemPT(priceDate) {
    priceDate.MembershipPointList = (priceDate.MembershipPointList) ? priceDate.MembershipPointList : [];
    var mpIDs = getDlgMPIDs(dlgMemPTSetup);

    // Add new elements
    addNewMemPTElements(priceDate.MembershipPointList, mpIDs);
    
    // Remove unused elements
    for (var i=priceDate.MembershipPointList.length-1; i>=0; i--) {
      var item = priceDate.MembershipPointList[i];
      if (mpIDs.indexOf(item.MembershipPointId) < 0) 
        priceDate.MembershipPointList.splice(i, 1);
    }
    
    // Render matrix
    var $tbody = $("#mempt-tbody").empty();
    for (var i=0; i<priceDate.MembershipPointList.length; i++) {
      var cell = priceDate.MembershipPointList[i];
      var $tr = $("<tr><td class='fixed'/><td class='value custom'><input type='text'/></td></tr>").appendTo($tbody);
      var $txt = $tr.find(".value input");
      $tr.find(".fixed").html(getMPName(cell.MembershipPointId));
      $tr.find(".value").attr("data-MembershipPointId", cell.MembershipPointId);
      $txt.val(cell.Value);
      $txt.focus(function() {
        $(this).select();
      }).blur(function(e) {
        var $this = $(this);
        var value = parseFloat($this.val());
        setMemPTValue({
          MembershipPointId: $this.closest("td").attr("data-MembershipPointId"),
          Value: isNaN(value) ? 0 : value
        });
      });
    }
  }

  function refreshVisibility() {
    var isFee = <%= product.ProductType.isLookup(LkSNProductType.Fee)%>;
    var varprice = $("#product\\.VariablePrice").isChecked();
    var feeTransactionPerc = $("#product\\.FeeTransactionPercentage").isChecked();
    var taxedSystemProduct = <%= product.ProductType.isLookup(LkSNProductType.System) && pageBase.getBLDef().isProductTaxable(product) %>;
    var pricingPlugin = $("#product\\.PosPricingPluginId").val() || $("#product\\.WebPricingPluginId").val();

    $("#matrix-container").setClass("hidden", varprice || taxedSystemProduct || pricingPlugin);
    $("#varprice-container").setClass("hidden", !varprice);
    $("#price-options-widget").setClass("v-hidden", taxedSystemProduct);
    $(".tax-list").setClass("v-hidden", $("[name='TaxCalcType']:checked").val() == "<%=LkSNTaxCalcType.TaxExempt.getCode()%>");
    $("#product\\.VariablePrice").prop('disabled', pricingPlugin || feeTransactionPerc);
    $("#product\\.FeeTransactionPercentage").prop('disabled', pricingPlugin || varprice);
    $("#product\\.FeePercTagIDs").prop('disabled', pricingPlugin || varprice);
    $("#product\\.PosPricingPluginId").prop('disabled', varprice || feeTransactionPerc);
    $("#product\\.WebPricingPluginId").prop('disabled', varprice || feeTransactionPerc);
    $("#price-matrix-container").setClass("v-hidden", feeTransactionPerc);
    $("#advance-matrix-container").setClass("v-hidden", feeTransactionPerc || isSiaePrd);
    $("#membership-matrix-container").setClass("v-hidden", feeTransactionPerc || isSiaePrd);
    $("#fee-perc-value-container").setClass("v-hidden", !feeTransactionPerc); 
    $("#fee-perc-block").setClass("v-hidden", !isFee);   
  }
  
  function refreshAdvanceType() {
    advType = $("#product\\.ProductPriceAdvanceType").val();
    $("#ProductPriceAdvanceSaleChannel").setClass("v-hidden", advType != advTypeSaleChannel);
    $("#ProductPriceAdvancePerformanceType").setClass("v-hidden", advType != advTypePerformanceType);
    $("#ProductPriceAdvanceRateCode").setClass("v-hidden", advType != advTypeRateCode);
  }
  
  $("#product\\.ProductPriceAdvanceType").change(function() {
    refreshAdvanceType();
  });
  
  $("#product\\.VariablePrice").click(function() {
    if ($(this).isChecked())
      $("#product\\.VariablePriceFreeInput").setChecked(true);
    refreshVisibility();
  });
  
  $("#product\\.FeeTransactionPercentage").click(refreshVisibility);
  $("[name='TaxCalcType']").click(refreshVisibility);
  
  $("#product\\.PosPricingPluginId").click(refreshVisibility);
  $("#product\\.WebPricingPluginId").click(refreshVisibility);

  $("#priceDate\\.FeePercValue").change(function() {
    setFeePercValue($("#priceDate\\.FeePercValue").val());
  });
  
  $(document).ready(function() {
    refreshVisibility();
    
    matrix = (matrix) ? matrix : [];
    if (matrix.length <= 0) {
      doAddMatrixTab();
    }
    else {
      for (var i=0; i<matrix.length; i++) 
        doAddMatrixTab(matrix[i]);
      doActivateMatrixTab($("#matrix-tabs li").first());
    }
    
    <% for (DOProduct.DOProductPriceVariable price : product.PriceVariableList) { %>
      addVarPricePresetValue(<%=price.PriceValueType.getInt()%>, parseFloat(<%=price.PriceValue.getXMLValue()%>));
    <% } %>
    
    $("[name='TaxablePrice']").val(decodePercentageValue(<%=product.TaxablePrice.getJsString()%>));
    $("[name='ClearingLimitPerc']").val(decodePercentageValue(<%=product.ClearingLimitPerc.getJsString()%>));
    
    if (<%= !product.ProductType.isLookup(LkSNProductType.Presale)%>) 
      $("#product\\.PresaleValue").val(decodePresaleValue(<%=product.PresaleValue.getJsString()%>, <%=product.PresaleValueType.getInt()%>));
    
    applySetup();
    refreshAdvanceType();
  });
  
  var $varpriceContainer = $("#varprice-preset-amounts").sortable(); 
  $("#btn-varprice-preset-add").click(function() {
    inputDialog2({
      "title": itl("@Common.Amount"), 
      "message": itl("@Product.VarpriceNewPresetAmountHint"),
      "onConfirm": function(text) {
        if (text) {
          text = text.replace(",", ".");
          
          var type = ValueType_Abs;          
          if (text.endsWith("%")) {
            text = text.replace("%", "");
            type = ValueType_Perc;
          }
          
          var value = parseFloat(text);
          if (isNaN(value))
            throw itl("@Common.InvalidAmount") + " \"" + text + "\"";
          
          if ($varpriceContainer.find(".varprice-preset-amount[data-value='" + value + "'][data-type='" + type + "']").length > 0)
            throw itl("@Common.DuplicatedItem");
          
          addVarPricePresetValue(type, value);
        }
      }
    });
  });
  
  function addVarPricePresetValue(type, value) {
    var text = (type == ValueType_Perc) ? (formatAmount(value, 2) + " %") : formatCurr(value);
    var $div = $("#price-templates .varprice-preset-amount").clone().appendTo($varpriceContainer);
    $div.setClass("disabled", !canEdit);
    $div.attr("data-value", value);
    $div.attr("data-type", type);
    $div.find(".varprice-preset-amount-value").text(text);
    $div.find(".varprice-preset-amount-del").mousedown(() => event.stopPropagation()).click(() => $div.remove());
  }
  
</script>