<%@page import="com.vgs.snapp.api.stats.APIDef_Stats_IncomeActivity"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.bko.page.PageBO_StatsIncomeActivity" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>


<%
JvDateTime dateFrom = null;
JvDateTime dateTo = null;
String locationId = null;
LookupItem interval = null;
String compareType = null;
LookupItem grouping = null;
String[] operatingAreaIDs = null;
String[] tagIDs = null;

APIDef_Stats_IncomeActivity.DORequest reqDO = pageBase.getBL(BLBO_UserFilter.class).findUserFilter(APIDef_Stats_IncomeActivity.DORequest.class);
if (reqDO != null) {
  interval = reqDO.Interval.getLkValue();
  compareType = reqDO.CompareType.getString();
  locationId = reqDO.LocationId.getString();
  grouping = reqDO.Grouping.getLkValue();
  operatingAreaIDs = reqDO.OperatingAreaId.getArray();
  tagIDs = reqDO.TagIDs.getArray();
}

if (interval == null)
  interval = LkStatInterval.Last30d;

if (interval.isLookup(LkStatInterval.Custom)) {
  if (reqDO != null) {
    dateFrom = reqDO.DateFrom.getDateTime();
    dateTo = reqDO.DateTo.getDateTime();
  }
  if (dateFrom == null)
    dateFrom = pageBase.getFiscalDate();
  if (dateTo == null)
    dateTo = dateFrom;
}

if (grouping == null)
  grouping = LkStatGrouping.Week;

if (compareType == null)
  compareType = "auto";

 if (locationId == null && !rights.AuditLocationFilter.isLookup(LkSNAuditLocationFilter.All))
  locationId = rights.MasterLocationId.isNull(pageBase.getSession().getLocationId());
%>
<script>
$(document).ready(function() {

  payChart = null;
  amountChart = null;
  printChart = null;
  financeChart = null;
  admChart = null;
  areaChart = null;
  
   $("#StatInterval").val(<%=interval.getCode()%>);
  <% if (interval.isLookup(LkStatInterval.Custom)) { %>
    $("#DateFrom-picker").datepicker("setDate", xmlToDate(<%=JvString.jsString(dateFrom.getXMLDate())%>));
    $("#DateTo-picker").datepicker("setDate", xmlToDate(<%=JvString.jsString(dateTo.getXMLDate())%>));
  <% } else { %>
    recalcInterval();
  <% } %>
    
  $("#btnset-grouping .btn[data-value=" + <%=grouping.getCode()%> + "]").addClass("active");
  $("#btnset-match .btn[data-value=" + <%=JvString.jsString(compareType)%> + "]").addClass("active");
  
  $("#DateFrom-picker").datepicker().on("input change", doApply);
  $("#DateTo-picker").datepicker().on("input change", doApply);
  
  $(".btn-group .btn").click(function() {
    var $this = $(this);
    $this.closest(".btn-group").find(".btn").removeClass("active");
    $this.addClass("active");
    doApply();
  });

   var multiOpArea = $("#OperatingAreaId").selectize({
    dropdownParent: "body",
    closeAfterSelect: true,
    plugins: ['remove_button','drag_drop'],
    onChange: function() {
      multiOpArea.blur();
      doApply();
    }
  })[0].selectize;
 
  var firstRun = true; 
  $("#LocationId").change(function() {
    $("#OperatingAreaId").addClass("disabled");
    var reqDO = {
      EntityType: <%=LkSNEntityType.OperatingArea.getCode()%>,
      AncestorEntityType: <%=LkSNEntityType.Location.getCode()%>,
      AncestorId: $("#LocationId").val(),
      PagePos: 1,
      RecordPerPage: 10000
    };
    vgsService("FullTextLookup", reqDO, true, function(ansDO) {
      $("#OperatingAreaId").removeClass("disabled");
      multiOpArea.clearOptions();
      if ((ansDO) && (ansDO.Answer) && (ansDO.Answer.ItemList)) {
        var list = ansDO.Answer.ItemList;
        for (var i=0; i<list.length; i++)
          multiOpArea.addOption({value:list[i].ItemId, text:list[i].ItemName});
        multiOpArea.refreshOptions(false);
        if (firstRun) {
           firstRun = false;
          var values = [<%=JvArray.arrayToString(operatingAreaIDs, ",", "'")%>];
          if (values.length == 0)
            doApply();
          else
            multiOpArea.setValue(values);
        }
        else
          doApply();
      }
      else
        doApply();
    });
  });

  if ($("#TagIDs").val().length > 0)
    $("#stat-payment").addClass("v-hidden");
  
  $("#TagIDs").change(function() { 
    if ($("#TagIDs").val().length > 0)
      $("#stat-payment").addClass("v-hidden");
    else
      $("#stat-payment").removeClass("v-hidden");
  
    enableDisable();
    doApply();
  });
   
  $("#StatInterval").change(function() { 
    recalcInterval();
    doApply();
  });
  
  var locationId = <%=JvString.jsString(locationId)%>;
  if (locationId != null)
    $("#LocationId").val(locationId);
  else
    $("#LocationId").val("");
 });
 
 var updateTagIDs = true;
 function updateTagIDsView(){
   if (updateTagIDs){
     updateTagIDs = false;
     var tagValues = [<%=JvArray.arrayToString(tagIDs, ",", "'")%>];
     if (tagValues.length > 0){
      $("#TagIDs")[0].selectize.setValue(tagValues, true);
      $("#stat-payment").addClass("v-hidden");
     }
   } 
 }

function doApply() {
  updateTagIDsView();
  showWaitGlass();
  enableDisable();
  
  var reqDO = {
    DateFrom: $("#DateFrom-picker").getXMLDate(),
    DateTo: $("#DateTo-picker").getXMLDate(),
    CompareDateFrom: $("#CompareDateFrom-picker").getXMLDate(),
    CompareDateTo: $("#CompareDateTo-picker").getXMLDate(),
    LocationId: getStringParam("#LocationId"),
    OperatingAreaId: getStringParam("#OperatingAreaId"),
    Grouping: $("#btnset-grouping .btn.active").attr("data-value"),
    Interval: $("#StatInterval").val(), 
    CompareType: $("#btnset-match .btn.active").attr("data-value"),
    TagIDs: getStringParam("#TagIDs")
  };
  
  snpAPI.cmd("Stats", "IncomeActivity", reqDO).then(ansDO => {
    hideWaitGlass();
    if ((ansDO) && (ansDO.IncomeActivity))
      incomeActivity = ansDO.IncomeActivity;

    $("#stat-boxes").empty();
    $("#stat-boxes").append(createStatBox(itl("@Common.Total") + " " + itl("@Stats.Income"), incomeActivity.CurrTotalAmount, incomeActivity.PrevTotalAmount, "col-lg-6 col-md-12", true))
    $("#stat-boxes").append(createStatBox(itl("@Common.Total") + " " + itl("@Common.Quantity"), incomeActivity.CurrTotalQuantity, incomeActivity.PrevTotalQuantity, "col-lg-6 col-md-12")); 
	
		//rendering all graphic elements
    renderItemsTable($("#product-grid tbody"), incomeActivity.IncomeProductList, incomeActivity.CurrTotalAmount, incomeActivity.PrevTotalAmount, incomeActivity.NetCurrTotalAmount, incomeActivity.NetPrevTotalAmount, "CurrAmount", "PrevAmount", "IconName", "ProfilePictureId", "ProductName", "ProductCode", "ProductId", <%=LkSNEntityType.ProductType.getCode()%>, true, false);
    renderItemsTable($("#event-grid tbody"), incomeActivity.IncomeEventList, incomeActivity.CurrTotalAmount, incomeActivity.PrevTotalAmount, incomeActivity.NetCurrTotalAmount, incomeActivity.NetPrevTotalAmount, "CurrAmount", "PrevAmount", "IconName", "ProfilePictureId", "EventName", "EventCode", "EventId", <%=LkSNEntityType.Event.getCode()%>, true, false);
    renderChart(incomeActivity, "Amount", "amount-chart", itl("@Stats.Income"), true);
    renderItemsTable($("#payment-grid tbody"), incomeActivity.IncomePaymentList, incomeActivity.CurrTotalAmount, incomeActivity.PrevTotalAmount, incomeActivity.NetCurrTotalAmount, incomeActivity.NetPrevTotalAmount, "Amount", "PrevAmount", "IconName", "PayMethodPicture", "Name", "PaymentCode", "PayMethodId", <%=LkSNEntityType.PaymentMethod.getCode()%>, true, true);
    renderPieChart(incomeActivity.IncomePaymentList, payChart, "payment-chart");
    renderPieChart(incomeActivity.IncomePrintProductTagList, printChart, "pdt-print-chart");
    renderPieChart(incomeActivity.IncomeFinanceProductTagList, financeChart, "pdt-fin-chart");
    renderPieChart(incomeActivity.IncomeAdmProductTagList, admChart, "pdt-adm-chart");
    renderPieChart(incomeActivity.IncomeAreaProductTagList, areaChart, "pdt-area-chart");
  });
    
  function renderChart(dataObject, axiVal, divName, axisLabel) {
    var currField = "Curr"+axiVal;
    var prevField = "Prev"+axiVal;
    var data = (dataObject.IncomeSlotList) ? dataObject.IncomeSlotList : [];

    data.forEach(function(item, index) {
      item.Timestamp = item.TimeSlot.replace("T", " ").substring(0, 16);
    });

    var grouping = parseInt($("#btnset-grouping .btn.active").attr("data-value"));
    var minPeriod = "DD";
    if (grouping == <%=LkStatGrouping.Slot15.getCode()%>) 
      minPeriod = "15mm";
    else if (grouping == <%=LkStatGrouping.Hour.getCode()%>) 
      minPeriod = "hh";
    else if (grouping == <%=LkStatGrouping.Month.getCode()%>) 
      minPeriod = "MM";

    var balloonDateFormat = "MMM DD, YYYY";
    if ((grouping == <%=LkStatGrouping.Slot15.getCode()%>) || (grouping == <%=LkStatGrouping.Hour.getCode()%>))
      balloonDateFormat = "MMM DD, YYYY - JJ:NN";
    else if (grouping == <%=LkStatGrouping.Month.getCode()%>)
      balloonDateFormat = "MMM, YYYY";

    if(amountChart == null){
        amountChart = AmCharts.makeChart(divName, {
        "language": graphLang,
        "type": "serial",
        "theme": "light",
        "marginRight":30,
        "dataDateFormat": "YYYY-MM-DD JJ:NN",
        "dataProvider": data,
        "categoryField": "TimeSlot",
        "plotAreaBorderAlpha": 0,
        "marginTop": 10,
        "marginLeft": 0,
        "marginBottom": 0,
        "legend": {
          "equalWidths": false,
          "periodValueText": "total: [[value.sum]]",
          "position": "top",
          "valueAlign": "left",
          "valueWidth": 100
        },
        "valueAxes": [{
          "stackType": "regular",
          "gridAlpha": 0.07,
          "title": axisLabel,
          "position": "left",
   				"labelFunction": function(value, valueText, valueAxis) {
   				  return "<%=pageBase.getCurrFormatter().getSymbol()%>" + ' ' + getSmoothQuantity(value);
	          }
        }],
        "graphs": [{
          "id": "g1",
          "type": "line",
          "bullet": "round",
          "bulletBorderAlpha": 1,
          "bulletColor": "#FFFFFF",
          "bulletSize": 8,
          "hideBulletsCount": 50,
          "lineThickness": 4,
          "title": itl("@Stats.CurrentInterval"),
          "lineColor": getComputedStyle(document.body).getPropertyValue("--base-blue-color"),
          "fillAlphas": 0.1,
          "lineAlpha": 1,
          "useLineColorForBulletBorder": true,
          "valueField": currField,
          "stackable": false,
          "balloonFunction": function(item, graph) {
            var returnVal = "<span style='font-size:18px;'>";
	          returnVal += getSmoothCurrency(item.dataContext[currField]);
            returnVal += "</span>";
            return returnVal;
         	}
        },
        {
          "id": "g2",
          "type": "line",
          "bullet": "round",
          "bulletBorderAlpha": 1,
          "bulletColor": "#FFFFFF",
          "bulletSize": 8,
          "hideBulletsCount": 50,
          "lineThickness": 4,
          "title": itl("@Stats.PreviousInterval"),
          "lineColor": getComputedStyle(document.body).getPropertyValue("--base-orange-color"),
          "lineAlpha": 1,
          "useLineColorForBulletBorder": true,
          "valueField": prevField,
          "stackable": false,
          "balloonFunction": function(item, graph) {
            var returnVal = "<span style='font-size:18px;'>";
            returnVal += getSmoothCurrency(item.dataContext[prevField]);
            returnVal += "</span>";
            return returnVal;
         }
        }],
        "chartScrollbar": {},
        "chartCursor": {
          "cursorPosition": "mouse",
          "categoryBalloonColor": "#000000",
          "cursorAlpha": 0,
          "categoryBalloonDateFormat": balloonDateFormat
        },
        "categoryAxis": {
          "parseDates": true,
          "minPeriod": "15mm",
          "axisColor": "#DADADA",
          "gridAlpha": 0.07,
          "guides": [{
            "date": dataObject.CurrTimeSlotStart,
            "toDate": dataObject.CurrTimeSlotEnd,
            "lineColor": getComputedStyle(document.body).getPropertyValue("--base-gray-color"),
            "lineAlpha": 1,
            "fillColor": getComputedStyle(document.body).getPropertyValue("--base-gray-color"),
            "fillAlpha": 0.4,
            "dashLength": 2,
            "inside": true,
            "labelRotation": 90
          }]
        },
        "export": {
          "enabled": true
         }
      });
    }else{
      amountChart.dataProvider = data;
      amountChart.chartCursor.categoryBalloonDateFormat = balloonDateFormat;
      amountChart.categoryAxis.minPeriod = minPeriod;
      amountChart.validateData();
    }
  }

	function renderPieChart(dataObject, chartObj, divName) {

    if (chartObj == null){
      chartObj = AmCharts.makeChart(divName, {
        "type": "pie",
      	"startDuration": 0,
        "theme": "light",
        "autoMargins": false,
        "marginTop": 10,
        "marginBottom": 0,
        "groupPercent": 5,
        "marginLeft": 0,
        "marginRight": 0,
        "autoResize": "false",
        "labelRadius": 10,//label positioning on slices
   			"labelsEnabled": true, //disable slices's description view
   			"labelFunction": function (item){
   			  return item.title;
   			},
        "innerRadius": "30%",//center hole's dimension
          "defs": {
          "filter": [{
            "id": "shadow",
            "width": "200%",
            "height": "200%",
            "feOffset": {
              "result": "offOut",
              "in": "SourceAlpha",
              "dx": 0,
              "dy": 0
            },
            "feGaussianBlur": {//sfumatura
              "result": "blurOut",
              "in": "offOut",
              "stdDeviation": 5
            },
            "feBlend": {//mix images
              "in": "SourceGraphic",
              "in2": "blurOut",
              "mode": "normal"
            }
          }]
        },  
        "dataProvider": dataObject,
        "valueField": "Amount",
        "titleField": "Name",
        "balloonText":"[[Name]]: [[percents]]% ([[Amount]])",
				"pullOutRadius": "10%",//used to redimension pie
         "balloonFunction": function(item) {
          var lbl=item.title + ':  ';
          var t = (Math.round(item.percents*100)/100) + '';
          lbl +=t;
          if( t.substring(t.indexOf('.')+1).length < 2)
           lbl +='0';
          
          lbl += '% ('+ formatCurr(item.value) + ')';
          return lbl;
        },
        "export": {
          "enabled": true
        }
      });
 
    }else{
      chartObj.dataProvider = dataObject.IncomePaymentList;
      chartObj.validateData();
    }
  }
}
</script>