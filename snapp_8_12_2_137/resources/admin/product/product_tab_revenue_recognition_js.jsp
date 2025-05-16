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
boolean canEdit = pageBase.getRightCRUD().canUpdate();
String[] parentIDs = EntityTree.getIDs(pageBase.getConnector(), LkSNEntityType.ProductType, pageBase.getId());
JvDataSet dsPerfTypeAll = pageBase.getBL(BLBO_PerformanceType.class).getDS(parentIDs);
JvDataSet dsSaleChannelAll = pageBase.getBL(BLBO_SaleChannel.class).getSaleChannelLookupDS((LookupItem)null);
JvDataSet dsCalendarAll = pageBase.getBL(BLBO_Calendar.class).getAllCalendarDS();
%>


<script>
  var PT_SC_IDs = []; //JsonObject array --> [{ GateCategoryId, [SaleChanellIDs], [PerformanceTypeIDs] }, {...}, ...]
  var defaultCode = "DEFAULT";
  var dsPT = <%=dsPerfTypeAll.getDocJSON()%>;
  var dsSC = <%=dsSaleChannelAll.getDocJSON()%>;
  var dsGateCatogory = <%=pageBase.getBL(BLBO_GateCategory.class).getGateCategoriesDS().getDocJSON()%>;
  var dsCalendarAll = <%=dsCalendarAll.getDocJSON()%>;
  var dlgRevenueSetup = $("#revenue-setup-dialog");
  var dlgRevenueEdit = $("#revenue-edit-dialog");
  var revenueRecognitionType_VPT = <%=LkSNRevenueRecognitionType.VPT.getCode()%>;
  var revenueRecognitionType_Amortization = <%=LkSNRevenueRecognitionType.Amortization.getCode()%>;
  var revenueRecognitionType_None = <%=LkSNRevenueRecognitionType.None.getCode()%>;
  var revenueDateList = <%=product.RevenueDateList.getJSONString()%>;
  var breakageDaysType_Never = <%=LkSNBreakageDaysType.Never.getCode()%>;
  var breakageDaysType_Sale = <%=LkSNBreakageDaysType.Sale.getCode()%>;
  var percAmountWarning = false;
  var totPerc = 0;
  
  $("#matrix-tabs").disableSelection().sortable({
    items: "li:not(.matrix-tab-plus)",
    distance: 6
  });
  
  function findClearingLimitType(value) {
	  if (value.indexOf("%") >= 0) 
		  return <%=LkSNPriceValueType.Percentage.getCode()%>; 
	  else
	    return <%=LkSNPriceValueType.Absolute.getCode()%>;
	}
  
  function doAddMatrixTab(data, newTab) {
    data = (data) ? data : {};
    data.SerialNumber = (data.SerialNumber) ? data.SerialNumber : 0;
    
    var li = $("#price-templates .matrix-tab").clone().insertBefore(".matrix-tab-plus");
    
    li.data("revenue-data", data);
    if (data.SerialNumber)
      li.find(".matrix-tab-serial").text("#" + data.SerialNumber);
    
    doActivateMatrixTab(li, newTab);
    li.click(function() {
      doActivateMatrixTab(this, false);
    });
    
    li.find(".matrix-tab-remove").click(function() {
      var msg = itl("@Common.Confirm", getDateCaption(li.attr("data-DateFrom")), getDateCaption(li.attr("data-DateTo")));
      confirmDialog(msg, function() {
		    li.remove();
		    
        var lis = $("#matrix-tabs li:not(.matrix-tab-plus)");
        if (lis.length > 0)
          doActivateMatrixTab(lis[0], false);
        else 
          doActivateMatrixTab(doAddMatrixTab(), false);
      })
    });
    
    li.find(".matrix-tab-edit").click(showEditRevenueDateDialog);
    
    return li;
  }
  
  function refreshBreakageDaysBlock(value) {
	  $('#breakage-days-block').setClass("v-hidden", !value || (value == breakageDaysType_Never));
  }
  
  function refreshDynamic() {
	    $('#dynamic-block').setClass("v-hidden", !$("#product\\.DynamicClearing").isChecked());
	  }
  
  function doActivateMatrixTab(li, newTab) {
    var activeTab = getActiveTab();
    if(activeTab.length > 0)
      flushRevenueDataTab(activeTab);
    
    var tmp = getActiveTab().data("revenue-data");
    $("input").blur();
    $("#matrix-tabs li").removeClass("matrix-tab-active");
    $(li).addClass("matrix-tab-active");
    
    var revenueDate = getActiveTab().data("revenue-data");
    
    if (newTab) {
      //deep copy
      var dateFrom = revenueDate.DateFrom;
      var dateTo = revenueDate.DateTo;
      jQuery.extend(true, revenueDate, tmp);
      revenueDate.ProductRevenueDateId = null;
      revenueDate.SerialNumber = null;
      revenueDate.DateFrom = dateFrom;
      revenueDate.DateTo = dateTo;
      revenueDate.RevenueRecognitionType = <%=LkSNRevenueRecognitionType.None.getCode()%>;
      revenueDate.GateCategoryConfigurationType = <%=LkSNGateCategoryConfigurationType.Static.getCode()%>;
    }
    
    if (newTab || !revenueDate.RevenueRecognitionType)
  	  revenueDate.RevenueRecognitionType = <%=LkSNRevenueRecognitionType.None.getCode()%>;
  	  
  	if (newTab || !revenueDate.GateCategoryConfigurationType)
        revenueDate.GateCategoryConfigurationType = <%=LkSNGateCategoryConfigurationType.Static.getCode()%>;
    
    $('#product\\.BreakageDays').val(revenueDate.BreakageDays);
    $('#product\\.BreakageDaysType').val(revenueDate.BreakageDaysType);
    $('#product\\.BreakageDaysType').change(function() {
    	refreshBreakageDaysBlock($('#product\\.BreakageDaysType').val());
    });
    
    $("#product\\.DynamicClearing").click(function() {
      refreshDynamic();
    });

    $("input[name='product.RevenueRecognitionType'][value='" + revenueDate.RevenueRecognitionType + "']").prop("checked", true);
    setDynamicClearing(revenueDate.GateCategoryConfigurationType);
    	
    $('#product\\.SerialNumber').val(revenueDate.SerialNumber);
   
    var revenueRecognitionType = $("[name='product.RevenueRecognitionType']");   
    $(revenueRecognitionType).change(function() {
    	  refreshVisibility($(this).filter(":checked").val());
    });
    
    refreshRevenueWeight(revenueDate);
    
    $('#revenue-matrix-list .gatecategory-widget').remove();
    if(revenueDate.RevenueGateCategoryList != undefined){
      if(revenueDate.RevenueGateCategoryList.length != 0) {
        for (var i=0; i<revenueDate.RevenueGateCategoryList.length; i++) {
          //matrix...
          var gateCategoryId = revenueDate.RevenueGateCategoryList[i].GateCategoryId;
          var gateCategoryName = getGateCategoryName(gateCategoryId);
          
          var VPTList = revenueDate.RevenueGateCategoryList[i].VPTList;
          if(revenueDate.RevenueGateCategoryList[i].VPTList != undefined){
            var ptIDs=[];
            var scIDs=[];
            for (var j=0; j<VPTList.length; j++) {
              if(!isInList(VPTList[j].PerformanceTypeId, ptIDs, "performanceType"))
                ptIDs.push(VPTList[j].PerformanceTypeId);
              if(!isInList(VPTList[j].SaleChannelId, scIDs, "saleChannel"))
                scIDs.push(VPTList[j].SaleChannelId);
            }
          }
          
          addGateCategorySection(gateCategoryId, gateCategoryName, ptIDs, scIDs, true, revenueDate.RevenueGateCategoryList[i].RevenueRecognitionType == revenueRecognitionType_VPT, (revenueDate.RevenueGateCategoryList[i].CalendarId!="" && revenueDate.RevenueGateCategoryList[i].CalendarId!=null));
          
          var calendar = $("#product\\.CalendarId")[i];
          var clearingLimit = $("#product\\.ClearingLimit")[i];
          var applyOnTotal = $("#product\\.ApplyOnTotal")[i];
          var extractFromGross = $("#product\\.ExtractFromGross")[i];
          var amortizationPeriods = $("#product\\.AmortizationPeriods")[i];
          var amortizationPeriodType = $("#product\\.AmortizationPeriodType")[i];
          var amortizationTrigger = $("#product\\.AmortizationTrigger")[i];
          var amortizationCalendarId = $("#product\\.AmortizationCalendarId")[i];
          var amortizationDelay = $("#product\\.AmortizationDelay")[i];
          var amortizationWithinExpiration = $("#product\\.AmortizationWithinExpiration")[i];

          $("input[name='product.RevenueRecognitionType'][value='" + revenueDate.RevenueGateCategoryList[i].RevenueRecognitionType + "']").prop("checked", true);
          setDynamicClearing(revenueDate.GateCategoryConfigurationType);
          
          $(clearingLimit).val(revenueDate.RevenueGateCategoryList[i].ClearingLimit);
          
          var clearingLimitType = revenueDate.RevenueGateCategoryList[i].ClearingLimitType;
          var clearingLimitTxt = revenueDate.RevenueGateCategoryList[i].ClearingLimit;
          if (clearingLimitTxt) {
        	  clearingLimitTxt = clearingLimitTxt + "";
        	  var n = clearingLimitTxt.indexOf("%");
        	  clearingLimitTxt = (clearingLimitType == <%=LkSNPriceValueType.Percentage.getCode()%>) && (n == -1) ? (clearingLimitTxt + "%") : clearingLimitTxt;
          }
        	$(clearingLimit).val(clearingLimitTxt);
        	
          $(applyOnTotal).setChecked(revenueDate.RevenueGateCategoryList[i].ApplyOnTotal);
          $(extractFromGross).setChecked(revenueDate.RevenueGateCategoryList[i].ExtractFromGross);
        	
          if (revenueDate.RevenueGateCategoryList[i].RevenueRecognitionType == revenueRecognitionType_VPT) 
            $(calendar).val(revenueDate.RevenueGateCategoryList[i].CalendarId);
          else if (revenueDate.RevenueGateCategoryList[i].RevenueRecognitionType == revenueRecognitionType_Amortization) {
	          $(amortizationPeriods).val(revenueDate.RevenueGateCategoryList[i].AmortizationPeriods);
	          $(amortizationPeriodType).val(revenueDate.RevenueGateCategoryList[i].AmortizationPeriodType);
	          $(amortizationTrigger).val(revenueDate.RevenueGateCategoryList[i].AmortizationTrigger);
	          $(amortizationCalendarId).val(revenueDate.RevenueGateCategoryList[i].AmortizationCalendarId);
	          $(amortizationDelay).val(revenueDate.RevenueGateCategoryList[i].AmortizationDelay);
	          $(amortizationWithinExpiration).prop("checked", revenueDate.RevenueGateCategoryList[i].AmortizationWithinExpiration);
          }
        }     
      }
    }
    
    
    refreshVisibility(revenueRecognitionType.filter(":checked").val());
    refreshBreakageDaysBlock(revenueDate.BreakageDaysType);
    refreshDynamic();
    applyDateCaptions();
  }
  
  function refreshRevenueWeight(revenueDate) {
	  $('#location-weight-grid tbody[name="location-weight-grid-body"] tr').remove();
	  
	  if (revenueDate.RevenueWeightList != undefined) {
	    if (revenueDate.RevenueWeightList.length != 0) {
	    	for (var i=0; i<revenueDate.RevenueWeightList.length; i++) {
	    		addRevenueWeight(revenueDate.RevenueWeightList[i].LocationAccountId, revenueDate.RevenueWeightList[i].Weight);
	    	}
	    }
	  }
  }
  
  function setDynamicClearing(gateCategoryConfigurationType) {
    $("input[name='product.GateCategoryConfigurationType'][value='" + gateCategoryConfigurationType + "']").setChecked(true);

    if (gateCategoryConfigurationType != <%=LkSNGateCategoryConfigurationType.Static.getCode()%>)
      $("input[name='product.DynamicClearing']").setChecked(true);
  }
  
  function flushRevenueDataTab(li){
    var revenueDate = li.data("revenue-data");
    var revenueRecognitionType_Value = $("[name='product.RevenueRecognitionType']:checked").val();
    if ($("input[name='product.DynamicClearing']").isChecked()) 
      revenueDate.GateCategoryConfigurationType = revenueRecognitionType_Value != revenueRecognitionType_None ? $("input[name='product.GateCategoryConfigurationType']:checked").val() : null;
    else
      revenueDate.GateCategoryConfigurationType = <%=LkSNGateCategoryConfigurationType.Static.getCode()%>;

    revenueDate.BreakageDaysType = $('#product\\.BreakageDaysType').val();
    revenueDate.BreakageDays = revenueDate.BreakageDaysType != breakageDaysType_Never ? $('#product\\.BreakageDays').val() : null;
    
    flushRevenueWeigth(li);
    
    var warnFixedAmount = flushRevenueGateCategory(li);
    $(li).data("revenue-data", revenueDate);
    return warnFixedAmount;
  }
  
  function flushRevenueWeigth(li){
	  let revenueDate = li.data("revenue-data");
	  revenueWeightList = [];
	  
	  const $tbody = $('[name="location-weight-grid-body"]');

	  $tbody.find('tr').each(function (rowIndex, row) {
      $tr = $(this);
      let item = {};
      
      let $tdLocation = $tr.find('select[name="product.LocationAccountId"]');
	    let $tdWeight = $tr.find('input[name="weight-value"]');

	    item.LocationAccountId = $tdLocation.val();
	    item.Weight = $tdWeight.val().replace("%", "").replace(",",".");

	    if (item.LocationAccountId && item.Weight)
  	    revenueWeightList.push(item);
	  });
	  
	  revenueDate.RevenueWeightList=revenueWeightList;  
  }
  
  function flushRevenueGateCategory(li){
    var revenueDate = li.data("revenue-data");
    var warnFixedAmount = false;
    var revenueRecognitionType_Value = $("[name='product.RevenueRecognitionType']:checked").val();
    
    totPerc = 0;
    VPTSection = getGateCategorySections();
    revGateCategoryList = [];

    for(var i=0;i<VPTSection.length-1;i++){
    	if (revenueRecognitionType_Value != revenueRecognitionType_None) {
	    	var matrix = VPTSection[i];
	      var table = $(matrix).find(".matrix-grid");
	      var cellValues = $(table).find("td.value");
	      var gateCategoryId = VPTSection[i].getAttribute("id");
	      
	      var visitPerTicketList = [];
	      var revenueGateCatObj = {};
	      var calendar = $("#product\\.CalendarId")[i];
	      var clearingLimit = $("#product\\.ClearingLimit")[i];
        var applyOnTotal = $("#product\\.ApplyOnTotal")[i];
        var extractFromGross = $("#product\\.ExtractFromGross")[i];

	      var amortizationPeriods = $("#product\\.AmortizationPeriods")[i];
	      var amortizationPeriodType = $("#product\\.AmortizationPeriodType")[i];
	      var amortizationTrigger = $("#product\\.AmortizationTrigger")[i];
	      var amortizationCalendarId = $("#product\\.AmortizationCalendarId")[i];
	      var amortizationDelay = $("#product\\.AmortizationDelay")[i];
	      var amortizationWithinExpiration = $("#product\\.AmortizationWithinExpiration")[i];
	
	      var showMatrix = $('.ShowMatrix')[i];
	      var vptText = $(".vpt-text")[i];
	      
	      revenueGateCatObj.CalendarId = $(showMatrix).isChecked() ? $(calendar).val() : null;
	      revenueGateCatObj.ClearingLimitType =  ($(clearingLimit).val() == "") ? <%=LkSNPriceValueType.Percentage.getCode()%> : findClearingLimitType($(clearingLimit).val());
	      revenueGateCatObj.ClearingLimit = ($(clearingLimit).val() == "") ? null : $(clearingLimit).val().replace("%", "");
        revenueGateCatObj.ApplyOnTotal = $(applyOnTotal).isChecked();
        revenueGateCatObj.ExtractFromGross = $(extractFromGross).isChecked();
	      
	      revenueGateCatObj.GateCategoryId = gateCategoryId;

	      revenueGateCatObj.RevenueRecognitionType = revenueRecognitionType_Value;
	      revenueGateCatObj.AmortizationPeriods = $(amortizationPeriods).val();
	      revenueGateCatObj.AmortizationPeriodType = $(amortizationPeriodType).val();
	      revenueGateCatObj.AmortizationTrigger = $(amortizationTrigger).val();
	      revenueGateCatObj.AmortizationCalendarId = $(amortizationCalendarId).val();
	      revenueGateCatObj.AmortizationDelay = $(amortizationDelay).val();
	      revenueGateCatObj.AmortizationWithinExpiration = $(amortizationWithinExpiration).isChecked();
	      
	      //ciclo sulla matrice della sezione corrente estraggo i dati delle celle per valorizzare la VPTList(ogni oggetto di tale lista rappresenta una cella della matrice)
	      if($(showMatrix).isChecked()) {
	        for(var j=0; j<cellValues.length ; j++){
	          visitPerTicketListObj = {};
	          visitPerTicketListObj.GateCategoryId = gateCategoryId;
	          visitPerTicketListObj.PerformanceTypeId = cellValues[j].getAttribute("data-performancetypeid");
	          visitPerTicketListObj.SaleChannelId = cellValues[j].getAttribute("data-salechannelid");
	          visitPerTicketListObj.ProductVPT = $(cellValues[j]).text();
	          visitPerTicketList[j] = visitPerTicketListObj;
	        }  
	       } else {
	        visitPerTicketListObj = {};
	        visitPerTicketListObj.GateCategoryId = gateCategoryId;
	        visitPerTicketListObj.PerformanceTypeId = defaultCode;
	        visitPerTicketListObj.SaleChannelId = defaultCode;
	        visitPerTicketListObj.ProductVPT = $(vptText).val();
	        visitPerTicketList[0] = visitPerTicketListObj;
	       }
	      
	      revenueGateCatObj.VPTList = visitPerTicketList;
	      revGateCategoryList.push(revenueGateCatObj);
	      
	      
	      warnFixedAmount = warnFixedAmount || revenueGateCatObj.ClearingLimitType == <%=LkSNPriceValueType.Absolute.getCode()%>;
	      
	      if (revenueGateCatObj.ClearingLimitType == <%=LkSNPriceValueType.Percentage.getCode()%>) {
	    	  var strValue = $(clearingLimit).val() == "" ? "100%" : $(clearingLimit).val();
	    	  strValue = strValue.replace("%", "");
	    	  strValue = strValue.replace(",", ".");
	        totPerc = totPerc + parseFloat(strValue);
	      }
	      
	      
      }
    }
    revenueDate.RevenueGateCategoryList=revGateCategoryList;

    return warnFixedAmount;
  }

  
  function getActiveTab() {
    return $("#matrix-tabs .matrix-tab-active");
  }
  
  function getGateCategorySections() {
    return $('.gatecategory-widget');
  }
   
  function isInList(val, list, type) {
    var found=false;
    for(var i=0; i<list.length; i++) {
      if(type == "performanceType"){
        if(list[i] == val){
          found=true;
          break;
        }
      } else if(type == "saleChannel"){
        if(list[i] == val){
          found=true;
          break;
        }
      }
    }
    return found;
  }
  
  function showRevenueDateDialog(data, callback) {
    data = (data) ? data : {};
    $("#ValidDateFrom-picker").datepicker("setDate", (data.DateFrom) ? xmlToDate(data.DateFrom) : null);
    $("#ValidDateTo-picker").datepicker("setDate", (data.DateTo) ? xmlToDate(data.DateTo) : null);
    
    $("#revenue-date-dialog").dialog({
      modal: true,
      width: 350,
      height: 250,
      buttons: {
        <v:itl key="@Common.Ok" encode="JS"/>: function() {
          var result = {
            DateFrom: $("#ValidDateFrom-picker").datepicker("getDate"),  
            DateTo: $("#ValidDateTo-picker").datepicker("getDate"),
          };
          
          result.DateFrom = (result.DateFrom) ? dateToXML(result.DateFrom) : null; 
          result.DateTo = (result.DateTo) ? dateToXML(result.DateTo) : null; 

          if (callback) 
            callback(result);
          $("#revenue-date-dialog").dialog("close");
        },
        <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
      }
    });
  }
  
  function showEditRevenueDateDialog() {
    showRevenueDateDialog(getActiveTab().data("revenue-data"), function(data) {
      var tabData = getActiveTab().data("revenue-data");
      tabData.DateFrom = data.DateFrom;
      tabData.DateTo = data.DateTo;
      getActiveTab().data("revenue-data", tabData);
      applyDateCaptions();
    });
  }
  
  function showRevenueSetupDialog(tableId) {
    <% if (canEdit) { %>
    dlgRevenueSetup.dialog({
      modal: true,
      width: 540,
      height: 500,
      resizable: false,
      buttons: {
        <v:itl key="@Common.Ok" encode="JS"/>: function() {
          $(this).dialog("close");
          var ptIDs = [defaultCode].concat(getDlgPTIDs(dlgRevenueSetup));
          var scIDs = [defaultCode].concat(getDlgSCIDs(dlgRevenueSetup));
          renderRevenueMatrix(tableId, ptIDs, scIDs);
        },
        <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
      }
    });
    <% } %>
  }
  
  $("#matrix-tabs .matrix-tab-plus").click(function() {
    showRevenueDateDialog(null, function(data) {
      doAddMatrixTab(data, true);
    });
  });
  
  function getDateCaption(value) {
    return (value == "") ? itl("@Common.Always") : value;
  }
  
  function getDateCaptionHTML(value) {
    var clazz = (value == "") ? "date-always" : "date-fixed"; 
    return "<span class='" + clazz + "'>" + getDateCaption(value) + "</span>";
  }
  
  
  function applyDateCaptions() {
    var revenueDate = getActiveTab().data("revenue-data");
    var sDateFrom = (revenueDate.DateFrom) ? formatDate(xmlToDate(revenueDate.DateFrom), <%=rights.ShortDateFormat.getInt()%>) : "";
    var sDateTo = (revenueDate.DateTo) ? formatDate(xmlToDate(revenueDate.DateTo), <%=rights.ShortDateFormat.getInt()%>) : "";
    
    var sTabCaption = getDateCaptionHTML(sDateFrom);
    if (sDateFrom != sDateTo)
      sTabCaption += "<br/>" + getDateCaptionHTML(sDateTo);

    getActiveTab().find(".matrix-tab-caption").html(sTabCaption);
    getActiveTab().find(".matrix-tab-caption").setClass("single-line", sDateFrom == sDateTo);
    getActiveTab().attr("data-DateFrom", sDateFrom);
    getActiveTab().attr("data-DateTo", sDateTo);
    
  }
  
  function refreshVisibility(revRecType) {
    var addGateCategoryButton = $('#add-gate-category-button');
  	var revenueMatrixList = $('#revenue-matrix-list');
  	var amortizationBlock = $('.gatecategory-widget').find('#amortization-block');
  	var amortizationPeriodType = $('div#revenue-matrix-list .gatecategory-widget').find('#product\\.AmortizationPeriodType');
  	var amortizationTrigger = $('div#revenue-matrix-list .gatecategory-widget').find('#product\\.AmortizationTrigger');
  	var vptBlock = $('.gatecategory-widget').find('#vpt-block');

  	$("#gatecategory-perc-description").setClass("hidden", revRecType == revenueRecognitionType_None);
    $(addGateCategoryButton).setClass("v-hidden", revRecType == revenueRecognitionType_None);
    $(revenueMatrixList).setClass("v-hidden", revRecType == revenueRecognitionType_None);
    $(amortizationBlock).setClass("v-hidden", revRecType != revenueRecognitionType_Amortization);
    
    $("#gate-category-type-block").setClass("v-hidden", revRecType == revenueRecognitionType_None);
    
    var amortizationPeriodTypeValues = $(amortizationPeriodType).map(function() {
      	return $(this).val()
    	}).get();
    
    $.each(amortizationPeriodTypeValues, function(index, value) {
    	var amortizationCalendarBlockList = $('div#revenue-matrix-list .gatecategory-widget').find('#amortization-calendar-block');
    	$(amortizationCalendarBlockList[index]).setClass("v-hidden", value != <%=LkSNAmortizationPeriodType.Calendar.getCode()%>);
    })
    
    var amortizationTriggerValues = $(amortizationTrigger).map(function() {
        return $(this).val()
      }).get();
    
    $.each(amortizationTriggerValues, function(index, value) {
      var amortizationDelayList = $('div#revenue-matrix-list .gatecategory-widget').find('#amortization-delay-block');
      $(amortizationDelayList[index]).setClass("v-hidden", value != <%=LkSNAmortizationTriggerType.StartValidity.getCode()%>);
    })
    
    $(vptBlock).setClass("v-hidden", revRecType != revenueRecognitionType_VPT);
    
    var showMatrixBoxes = $('div#revenue-matrix-list .gatecategory-widget').find('.ShowMatrix');
    var showMatrixValues = $(showMatrixBoxes).map(function() {
    	return $(this).isChecked()
    	}).get();
    
    $.each(showMatrixValues, function(index, value) {
    	var vptCalendarBlockList = $('div#revenue-matrix-list .gatecategory-widget').find('#vpt-calendar-block');
    	$(vptCalendarBlockList[index]).setClass("v-hidden", !value);
    })
    
  }
  
  function addGateCategorySection(gateCategoryId, gateCategoryName, ptIDs, scIDs, read, vpt, calendar) {
    gateCategoryName = gateCategoryName ? gateCategoryName : "None";
    
    var showMatrix = (ptIDs && (ptIDs.length > 1)) || (scIDs && (scIDs.length > 1)) || (calendar);
    
    var matrixList = $("#revenue-matrix-list");
    var widgetSection = $('#revrec-templates .gatecategory-widget').clone().attr("id",gateCategoryId).appendTo(matrixList);
    var calendarField = $(widgetSection).find("#product\\.CalendarId");    
    
    
    widgetSection.find(".widget-title-caption").text(gateCategoryName);
    widgetSection.find(".form-field").attr("data-viewtype", !showMatrix ? "simple" : "matrix");
    widgetSection.find(".widget-title").append("<a href='#'><i class='edit-icon move-handle fa fa-bars'></i></a>")
    widgetSection.find(".widget-title").append("<a href='javascript:removeGateCategorySection(\"" + gateCategoryId + "\")'><i class='edit-icon fa fa-trash'></i></a>")

    var revenueRecognitionType = $("[name='product.RevenueRecognitionType']");
    
    var amortizationBlock = widgetSection.find("#amortization-block");
    var amortizationPeriodType = amortizationBlock.find("#product\\.AmortizationPeriodType");
    var amortizationTrigger = amortizationBlock.find("#product\\.AmortizationTrigger");

    $(revenueRecognitionType).change(function (){
    	refreshVisibility($(this).filter(":checked").val());
    });
    
    $(amortizationPeriodType).change(function (){
    	refreshVisibility($(revenueRecognitionType).filter(":checked").val());
    });
    
    $(amortizationTrigger).change(function (){
      refreshVisibility($(revenueRecognitionType).filter(":checked").val());
    });
    
    if(showMatrix) 
      $(widgetSection.find(".ShowMatrix")).click();
    else {
  	  if (vpt) {
  	    $(calendarField).closest(".form-field").hide();
        $(widgetSection.find("#VisitPerTicket")).val(1);
  	  }
    }
    
    if(!read)
      flushRevenueDataTab(getActiveTab());       
    
    widgetSection.find(".ShowMatrix").click(function() {
      $(this).closest(".form-field").attr("data-viewtype", ($(this).isChecked() ? "matrix" : "simple"));
      
      if($(this).isChecked())
        $(this).closest("#vpt-block").find("#product\\.CalendarId").closest(".form-field").show();
      else {
        $(this).closest("#vpt-block").find("#product\\.CalendarId").closest(".form-field").hide();
        widgetSection.find(".vpt-text").val(findRevenueValue(gateCategoryId, ptIDs[0], scIDs[0]).ProductVPT);
      }
    });
    
    if(ptIDs && (ptIDs.length==1) && scIDs && (scIDs.length==1) && vpt)
      widgetSection.find(".vpt-text").val(findRevenueValue(gateCategoryId, ptIDs[0], scIDs[0]).ProductVPT);
    
    renderRevenueMatrix(gateCategoryId, ptIDs, scIDs);
    refreshVisibility($(revenueRecognitionType).filter(":checked").val());
  }
  
  function removeGateCategorySection(gateCategoryId){
    confirmDialog(null, function() {
      $(".gatecategory-widget#" + gateCategoryId).remove();
    })
  }
  
  function getPT_SC_IDFromList(revGateCat, typeList) {
    for(i=0; i<PT_SC_IDs.length;i++) {
      if(PT_SC_IDs[i].GateCategoryId == revGateCat){
        if(typeList=="performanceType")
          return PT_SC_IDs[i].PerformaceTypeIDs;
        else if(typeList=="saleChannel")
          return PT_SC_IDs[i].SaleChannelIDs;
      }
    }
  }
  
  function refreshDlg_PT_CS_IDs(gateCatId, ptIDs, scIDs) {
    clean_PT_CS_IDs(gateCatId);
    var ptIDs = (ptIDs && ptIDs.length>0) ? ptIDs : ["DEFAULT"];
    var scIDs = (scIDs && scIDs.length>0) ? scIDs : ["DEFAULT"];
    
    found=false;
    for(i=0; i<PT_SC_IDs.length;i++) {
      if(PT_SC_IDs[i].GateCategoryId == gateCatId){
        found=true;
        PT_SC_IDs[i].PerformaceTypeIDs=ptIDs;
        PT_SC_IDs[i].SaleChannelIDs=scIDs;
      }
    }
    if(!found){
      var obj = {
          "GateCategoryId" : gateCatId,
          "PerformaceTypeIDs": ptIDs,
          "SaleChannelIDs": scIDs
          }
      PT_SC_IDs.push(obj);
    }
  }
  
  function  clean_PT_CS_IDs(revGateCat) {
    for(i=0; i<PT_SC_IDs.length;i++) {
      if(PT_SC_IDs[i].GateCategoryId == revGateCat){
        PT_SC_IDs[i].PerformaceTypeIDs=[];
        PT_SC_IDs[i].SaleChannelIDs=[];
      }
    }
  }
  
  function renderRevenueMatrix(tableId, ptIDs, scIDs) {
  
    var revenueDate = getActiveTab().data("revenue-data");
    refreshDlg_PT_CS_IDs(tableId, ptIDs, scIDs);
    
    ptIDs = (ptIDs && ptIDs.length>0) ? ptIDs : getPT_SC_IDFromList(tableId, "performanceType");
    scIDs = (scIDs && scIDs.length>0) ? scIDs : getPT_SC_IDFromList(tableId, "saleChannel");  
    
    var gateCategoryIndex = getIndexByTableId(tableId);
    
    var html = "";
    
    // Add new elements
    for (var p=0; p<ptIDs.length; p++) {
      for (var s=0; s<scIDs.length; s++) {
        if ((p!=0 || s!=0) && findRevenueValue(tableId, ptIDs[p], scIDs[s]) == null) {
          revenueDate.RevenueGateCategoryList[gateCategoryIndex].VPTList.push({
            "PerformanceTypeId": ptIDs[p],
            "SaleChannelId": scIDs[s],
            "ProductVPT": 1
          });
        }
      }
    }
    
    if(revenueDate.RevenueGateCategoryList[gateCategoryIndex] != undefined){
      // Remove unused elements
      if(revenueDate.RevenueGateCategoryList[gateCategoryIndex].VPTList != undefined) {
	      for (var i=revenueDate.RevenueGateCategoryList[gateCategoryIndex].VPTList.length-1; i>=0; i--) {
	        var item = revenueDate.RevenueGateCategoryList[gateCategoryIndex].VPTList[i];
	        if ((ptIDs.indexOf(item.PerformanceTypeId) < 0) || (scIDs.indexOf(item.SaleChannelId) < 0))
	          revenueDate.RevenueGateCategoryList[gateCategoryIndex].VPTList.splice(i, 1);
	      }  
      }
    }
    
    // Render matrix 
    var matrixSelector = "#" + tableId + ' .matrix-grid';

    var table = $(matrixSelector).empty();
    for (var p=-1; p<ptIDs.length; p++) {
      var tr = $("<tr/>").appendTo(table);
      for (var s=-1; s<scIDs.length; s++) {
        var td = $("<td/>").appendTo(tr);
        var colHeader = (p < 0);
        var rowHeader = (s < 0);
        td.addClass((colHeader || rowHeader) ? "fixed" : "value");
        if (colHeader && rowHeader) {
          td.addClass("setup");
          td.attr("title", itl("@Product.PriceSetupHint"));
          td.click(function(){
            showRevenueSetupDialog(tableId);
            dlgRevenueSetup.find("input[name='PerformanceTypeId']").setChecked(false);
            dlgRevenueSetup.find("input[name='SaleChannelId']").setChecked(false);
            var ptIDs = ptIDs ? ptIDs : getPT_SC_IDFromList(tableId, "performanceType");
            var scIDs = scIDs ? scIDs : getPT_SC_IDFromList(tableId, "saleChannel");  
            for (var i=0; i<ptIDs.length; i++) {
              dlgRevenueSetup.find("input[name='PerformanceTypeId'][value='" + ptIDs[i] + "']").setChecked(true);
             }
            for (var j=0; j<scIDs.length; j++) {
              dlgRevenueSetup.find("input[name='SaleChannelId'][value='" + scIDs[j] + "']").setChecked(true);
             }
          });
          td.html("<i class='fa fa-cog'></i>");
        }
        else if (rowHeader)
          td.html(getPTName(ptIDs[p]));
        else if (colHeader)
          td.html(getSCName(scIDs[s]));
        else {
          var value = findRevenueValue(tableId, ptIDs[p], scIDs[s]);
          td.setClass("custom", (value != null));
          td.attr("data-PerformanceTypeId", ptIDs[p]);
          td.attr("data-SaleChannelId", scIDs[s]);
          var valueObj = findRevenueValue(tableId, ptIDs[p], scIDs[s]);
          td.html(valueObj ? valueObj.ProductVPT : 1);
          
          value = (value) ? value : {};
          td.click(function() {
            var ptId = $(this).attr("data-PerformanceTypeId");
            var scId = $(this).attr("data-SaleChannelId");
            var value = findRevenueValue(tableId, ptId, scId);
            var v = (value) ? value : {};
            var isDefault = (ptId == defaultCode) && (scId == defaultCode);
            showRevenueEditDialog(v.ProductVPT, isDefault, function(revenueValue) {
              setValue(tableId, 
              {
                PerformanceTypeId: ptId,
                SaleChannelId: scId,
                ProductVPT: revenueValue ? revenueValue : 1
              });
              var ptIDs = getPT_SC_IDFromList(tableId, "performanceType");
              var scIDs = getPT_SC_IDFromList(tableId, "saleChannel");
              renderRevenueMatrix(tableId, ptIDs, scIDs);
            });
          });
        }
      }
    }
  }
  
  function getIndexByTableId(tableId) {
    var revenueDate = getActiveTab().data("revenue-data");
    var jdx = -1;
    for (var j=0; j<revenueDate.RevenueGateCategoryList.length; j++) {
      if ((revenueDate.RevenueGateCategoryList[j].GateCategoryId == tableId)) {
        jdx = j;
        break;
      }
    }
    
    //se è la prima sezione che sto creando restituisco l'indice 0
    if(jdx<1)
      return 0;
    else
      return jdx;
  }

  function findRevenueValue(tableId, ptId, scId) {
    var gateCategoryIndex = getIndexByTableId(tableId);
    var revenueDate = getActiveTab().data("revenue-data");
    
    if(revenueDate.RevenueGateCategoryList[gateCategoryIndex] != undefined){
    	if(revenueDate.RevenueGateCategoryList[gateCategoryIndex].VPTList != undefined){
	      for (var i=0; i<revenueDate.RevenueGateCategoryList[gateCategoryIndex].VPTList.length; i++) 
	        if ((revenueDate.RevenueGateCategoryList[gateCategoryIndex].VPTList[i].PerformanceTypeId == ptId) && (revenueDate.RevenueGateCategoryList[gateCategoryIndex].VPTList[i].SaleChannelId == scId))
	          return revenueDate.RevenueGateCategoryList[gateCategoryIndex].VPTList[i]; 
    	}
    }
    return null;
  }
  
  function setValue(revenueGateCategoryId, value) {
    var revenueDate = getActiveTab().data("revenue-data");

    //ciclo per cercare l'indice del revenueGateCategory(sezione su cui è stato intercettato l'evento di click sulla matrice)
    var jdx = getIndexByTableId(revenueGateCategoryId);
    
    //ciclo sulla lista  dei VPT dele revenueGateCategory  selezionato(id calcolato sopra) per cercare l'indice della cella cliccata
    if(jdx>=0){
      var idx = -1;
      for (var i=0; i<revenueDate.RevenueGateCategoryList[jdx].VPTList.length; i++) {
        if ((revenueDate.RevenueGateCategoryList[jdx].VPTList[i].PerformanceTypeId == value.PerformanceTypeId) && (revenueDate.RevenueGateCategoryList[jdx].VPTList[i].SaleChannelId == value.SaleChannelId)) {
          idx = i;
          break;
        }
      } 
    }
    
    if (idx < 0)
      revenueDate.RevenueGateCategoryList[jdx].VPTList.push(value);
    else
      revenueDate.RevenueGateCategoryList[jdx].VPTList[idx] = value;
    
    getActiveTab().data("revenue-data", revenueDate);
  }
  
  function showRevenueEditDialog(value, isDefault, callback) {
    <% if (canEdit) { %>
    
    $("#cell-value-edit").val((value) ? value : "");
    
    dlgRevenueEdit.dialog({
      modal: true,
      width: 300,
      resizable: false,
      buttons: [
        {
          "text": itl("@Common.Ok"),
          "class": "btn-ok",
          "click": function() {
            var value = parseFloat($("#cell-value-edit").val().replace(",", "."));
            callback(isNaN(value) ? 0 : value);
            dlgRevenueEdit.dialog("close");
          }
        },
        {
          "text": itl("@Common.Cancel"),
          "click": doCloseDialog
        }
      ]
    });
    dlgRevenueEdit.find("#cell-value-edit").focus();
    <% } %>
  }
  
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
  
  function getPTName(ptId) {
    if (ptId == defaultCode)
      return itl("@Common.Default");
    else {
      var pt = findPT(ptId);
      if (pt != null) {
        var result = pt.PerformanceTypeName;
        return result;
      }
    } 
    return "";
  }
  
  function getSCName(scId) {
    if (scId == defaultCode)
      return itl("@Common.Default");
    else {
      var sc = findSC(scId);
      if (sc != null) {
        var result = sc.SaleChannelName;
        return result;
      } 
    }
    return "";
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
  
  function showGateCategoryPickupDialog() {
    showLookupDialog({
      EntityType: <%=LkSNEntityType.GateCategory.getCode()%>,
      onPickup: function(item) {
        if ($("#" + item.ItemId).length > 0) 
          showMessage(itl("@Product.GateCatAlreadyExists"));
        else
          addGateCategorySection(item.ItemId, item.ItemName, [], [], false, true, false);
      }
    });
  }
  
  function getGateCategoryName(ItemId) {
    for(var i=0;i<dsGateCatogory.length;i++){
      if(dsGateCatogory[i].GateCategoryId == ItemId)
        return dsGateCatogory[i].GateCategoryName;
    }
    return null;
  }
  
  function checkField(revDate) {
    var breakageValue = checkNotString(revDate.BreakageDays);
    if (!breakageValue){
      showMessage(itl("@Product.BreakageDaysValueNotValid"));
      return false;
    }
    
    if (!revDate.BreakageDays && (revDate.BreakageDaysType != breakageDaysType_Never)){
      showMessage(itl("@Product.BreakageDaysEmptyError"));
      return false;
    }
 
		for (var i=0; i< revDate.RevenueGateCategoryList.length; i++) {
      if (revDate.RevenueGateCategoryList[i].ClearingLimit != null) {
  	    revDate.RevenueGateCategoryList[i].ClearingLimit = revDate.RevenueGateCategoryList[i].ClearingLimit.replace(",", ".")
  	    revDate.RevenueGateCategoryList[i].ClearingLimit = revDate.RevenueGateCategoryList[i].ClearingLimit.replace("%", "")
  	    var clearingLimitValue = $.isNumeric(revDate.RevenueGateCategoryList[i].ClearingLimit);
  	    if (!clearingLimitValue){
  	      showMessage(itl("@Product.ClearingLimitValueNotValid"));
  	      return false;
  	    }
      }
        
		  if (revDate.RevenueGateCategoryList[i].RevenueRecognitionType == revenueRecognitionType_Amortization) { //Amortization
			  var amortizationPeriods = checkValue(revDate.RevenueGateCategoryList[i].AmortizationPeriods) || revDate.RevenueGateCategoryList[i].AmortizationWithinExpiration; 
			  if (!amortizationPeriods){
			    showMessage(itl("@Product.AmortizationPeriodValueNotValid"));
			    return false;
			  }
			}
    }
		return true;
  }
  
  function checkValue(value) {
    return (Math.floor(value) == value && $.isNumeric(value)); 
    }
  
  function checkNotString(value) {
    return ($.isNumeric(value) || value==null || value=='null' || value==''); 
    }
  
  function Save() {
    var reqDO = {
      Command: "SaveProduct",
      SaveProduct: {
        Product: {
          ProductId: <%=JvString.jsString(pageBase.getId())%>,
          RevenueDateList: []
        }
      }
    };
     
    var tabs = $("#matrix-tabs li:not(.matrix-tab-plus)");
    var warnFixedAmount = false;  
    percAmountWarning = false;
    
    var check = false;
    for (var i=0; i<tabs.length; i++){
    	warnFixedAmount = flushRevenueDataTab($(getActiveTab()));
    	var data = $(tabs[i]).data("revenue-data");
      check = checkField(data);
      if (check)
        reqDO.SaveProduct.Product.RevenueDateList.push(data);
      else
        break;
    }
 
    percAmountWarning = (totPerc != 100) && ($("[name='product.RevenueRecognitionType']:checked").val() != revenueRecognitionType_None); 
   
    if(check) {
    	if (warnFixedAmount)
        confirmDialog(itl("@Product.RevenueRecognitionFixedAmountWarn"), function () {
        	doSave(reqDO);
        }, null);
    	else
    		if (percAmountWarning)
    	    confirmDialog(itl("@Product.RevenueRecognitionPercentageAmountWarn"), function () {
    	      doSave(reqDO);
    	    }, null);
    	  else
    	    doSave(reqDO);
    }
  }
  
  function doSave(reqDO) {
	  showWaitGlass();
    vgsService("Product", reqDO, false, function(ansDO) {
      hideWaitGlass();
      entitySaveNotification(<%=LkSNEntityType.ProductType.getCode()%>, ansDO.Answer.SaveProduct.ProductId, "tab=revenue");
    }); 
  }
  
  dlgRevenueEdit.keypress(function(event) {
    if (event.keyCode == KEY_ENTER) 
      dlgRevenueEdit.closest(".ui-dialog").find(".btn-ok").trigger("click");
  });
   
	function addRevenueWeight(locationAccountId, weight) {
		var sDisabled = <%=canEdit%> ? "" : " disabled='disabled'";
		var tr = $("<tr class='grid-row'/>").appendTo("#location-weight-grid tbody[name='location-weight-grid-body']");
		
		var tdCB = $("<td/>").appendTo(tr);
		var tdLocation = $("<td/>").appendTo(tr);
  	var tdWeight = $("<td/>").appendTo(tr);
  	
  	tdCB.append("<input value='" + locationAccountId + "' type='checkbox' class='cblist'>");
  	tdLocation.append($("#location-account-template").clone().removeClass("hidden"));
  	tdWeight.append("<input type='text' name='weight-value' class='txt-perc form-control'>");
  	
  	tdLocation.find("select").val(locationAccountId);
  	tdWeight.find("input[name='weight-value']").val(weight + "%");
	}
  
  $(document).ready(function() {
    revenueDateList = (revenueDateList) ? revenueDateList : [];
    if (revenueDateList.length <= 0)
      doAddMatrixTab();
    else {
      for (var i=0; i<revenueDateList.length; i++)  
        doAddMatrixTab(revenueDateList[i]);
    }
    applyDateCaptions();
    
    $("#revenue-matrix-list").sortable({
      handle: ".move-handle"
    });
  });
  
  function removeRevenueWeight() {
	  $("#location-weight-grid .cblist:checked").not(".header").closest("tr").remove();
	}
  
</script>
