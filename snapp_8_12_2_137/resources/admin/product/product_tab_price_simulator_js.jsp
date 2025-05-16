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

<script>
$(document).ready(function() {
  createMonthlyOptions();
  $("#search-btn").click(search);
  var date = new Date();
  $("#RangeYear").val(date.getFullYear());
  $("#RangeMonth").val(date.getMonth());
  $("#SellDate-picker").datepicker("setDate", date);
  search();
  
  function createMonthlyOptions(){
    var $select = $("#RangeMonth");
    for (var i=0; i < fmtDateMonths.length; ++i){
     	$("<option>").val(i).text(fmtDateMonths[i]).appendTo($select);
    }
  }
  
  function initCalendar(ansDO) {
    var month = $("#RangeMonth").val(); // Current selected month
    var year = $("#RangeYear").val(); // Current selected year
    var daysOfWeek = getWeekDays(); 

    var $div = $("#pricesim-calendar");
    $div.empty();
    
    var $table = $("<table id='pricesim-calendar'/>").appendTo($div);
    var $thead = $("<thead/>").appendTo($table);
    var $tbody = $("<tbody/>").appendTo($table);
    
    var $tr = $("<tr/>").appendTo($thead);
    var days = fmtDateWeekDays;
    for (var i=0; i<7; i++) {
      var $td = $("<td/>").appendTo($tr);
      $td.text(fmtDateWeekDays[daysOfWeek[i]]);
    } 
    
    var date = new Date(year, month, 1);
    while (month == date.getMonth()) {
      var $tr = $("<tr/>").appendTo($tbody);
      for (var i=0; i<7; i++) {
        var diffMonth = 
          (date.getMonth() != month) ||
          ((date.getDate() == 1) && (date.getDay() != daysOfWeek[i]));
        
        if (diffMonth) 
          $("#pricesim-templates .cal-price-cell-blank").clone().appendTo($tr);
        else { 
          $tr.append(renderDate(ansDO.Answer.GetDatedPrices.DatedProductPriceList[0].DatedPriceList, date));
          date.setDate(date.getDate() + 1);
        }
      }
    }
  }
  
  function renderDate(datedPriceList, date) {
    var price = findProductPrice(datedPriceList, date);
    var templateName = (price != null) ? "cal-price-cell-price" : "cal-price-cell-noprice";
    var $td = $("#pricesim-templates ." + templateName).clone();
    $td.find(".cal-price-cell-valued-num").text(date.getDate());
    
    if (price != null) {
      var perf = price.PerformanceRef;
      $td.find(".cal-price-cell-valued-price").text(formatCurr(price.Price, mainCurrencyFormat, "", ""));
      $td.setClass("seat-allocation", perf.SeatAllocation === true);
      
      var percFree = Math.round((perf.QuantityFree * 100.0) / perf.QuantityMax);
      var clsext = (perf.QuantityFree > 0) ? "prgbar-ext-gray" : "prgbar-ext-red";
      var clsint = (percFree < perf.SoldOutWarnLimit) ? "prgbar-int-orange" : "prgbar-int-green";
      var $div = $td.find(".cal-price-cell-valued-availability");
      var text = (perf.QuantityFree == 0) ? itl("@Seat.SoldOut").toUpperCase() : perf.QuantityFree + " (" + percFree+"%)";
      $div.find(".prgbar-lbl").text(text);
      $div.find(".prgbar-ext").addClass(clsext);
      $div.find(".prgbar-int").addClass(clsint).css("width", percFree + "%");
      var title = "";
      
      if (getNull(perf.RateCodeIconAlias) != null){
        $td.find("#performance-icon").addClass("fa fa-" + perf.RateCodeIconAlias);
        title += itl("@Common.RateCode") + ": " + perf.RateCodeCode +"\n";
      }
      
      if (getNull(perf.PerformanceTypeColor) != null){
        $td.find(".cal-price-cell-valued-performance-container").attr("style", "background-color: #" + perf.PerformanceTypeColor + " !important");
        title += itl("@Performance.PerformanceType") + ": " + perf.PerformanceTypeCode;
      }
      
			$td.find(".cal-price-cell-valued-performance").attr("title", title); 
    }
    
    return $td;
  }
  
  function search() {
    var month = $("#RangeMonth").val();
    var year = $("#RangeYear").val();
    var dateFrom = new Date(year, month, 1);
    var dateTo = new Date(year, Number(month)+1, 0);
    var reqDO = {
      Command: "GetDatedPrices",
      GetDatedPrices: {
        ProductList: [{
          ProductId: "<%=product.ProductId.getString()%>"
        }],
        SaleChannel:{
          SaleChannelId: $("#SalechannelId").val(),
        },
        DateFrom: dateToXML(dateFrom),
        DateTo: dateToXML(dateTo),
        SaleDate: $("#SellDate").val(),
        EventId:$("#EventId").val()
      }
    };

    showWaitGlass();
    vgsService("Product", reqDO, false, function(ansDO) {
      initCalendar(ansDO);
      hideWaitGlass();
    });
  }
  
  function findProductPrice(datedPriceList, date) {
    if (datedPriceList) {
      for (var datedPrice of datedPriceList) {
        var dateFrom = xmlToDate(datedPrice.DateFrom);
        if (dateFrom.getDate() == date.getDate())
          return datedPrice;
      }
    }
    return null;
  }
  
});
</script>