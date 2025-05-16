<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageEngineStats" scope="request"/>

<%
JvDateTime dateFrom = null;
JvDateTime dateTo = null;
String serverId = null;
LookupItem interval = null;
String compareType = null;
LookupItem grouping = null;
String service = null;
String[] commandList = null;

DOCmd_Service.DORequest.DOCmdConsAPIRequest reqDO = pageBase.getBL(BLBO_UserFilter.class).findUserFilter(DOCmd_Service.DORequest.DOCmdConsAPIRequest.class);
if (reqDO != null) {
  interval = reqDO.Interval.getLkValue();
  compareType = reqDO.CompareType.getString();
  serverId = reqDO.ServerId.getString();
  grouping = reqDO.Grouping.getLkValue();
  service = reqDO.Service.getString();
  commandList = reqDO.Command.getArray();
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

%>
<script>
var charts = [];
$(document).ready( function() {
  countChart = null;
  avgChart = null;
  maxChart = null;
  dateFormat = null;
  
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
  
  var multiOpArea = $("#Command").selectize({
    dropdownParent: "body",
    closeAfterSelect: true,
    plugins: ['remove_button','drag_drop'],
    onChange: function() {
      multiOpArea.blur();
     doApply();
    }
  })[0].selectize;
   
  $("#StatInterval").change(function() { 
    recalcInterval();
   doApply();
  });
  
  var serverId = <%=JvString.jsString(serverId)%>;
  var service = <%=JvString.jsString(service)%>;

   if (serverId)
    $("#ServerId").val(serverId);
  
  if (service)
    $("#Service").val(service);
  
  var firstRun = true; 
   $("#Service").change(function() {
    $("#Command").addClass("disabled");
    if (!$("#Service").val()){
      multiOpArea.clearOptions();
    }else {
      var reqDO = {
        EntityType: <%=LkSNEntityType.ApiRequestCommand.getCode()%>,
        AncestorEntityType: <%=LkSNEntityType.ApiRequestCode.getCode()%>,
        AncestorId: $("#Service").val(),
        PagePos: 1,
        RecordPerPage: 10000
      };
      vgsService("FullTextLookup", reqDO, true, function(ansDO) {
        $("#Command").removeClass("disabled");
        multiOpArea.clearOptions();
        if ((ansDO) && (ansDO.Answer) && (ansDO.Answer.ItemList)) {
          var list = ansDO.Answer.ItemList;
          for (var i=0; i<list.length; i++)
            multiOpArea.addOption({value:list[i].ItemId, text:list[i].ItemName});
          multiOpArea.refreshOptions(false);
          if (firstRun) {
            firstRun = false;
            var values = [<%=JvArray.arrayToString(commandList, ",", "'")%>];
            if (values.length == 0)
              doApply();
            else
              multiOpArea.setValue(values);
          }
          else
            doApply();
        }
         else
          doApply();//to manage drop down empty value
      });
    }
    }); 
  $("#ServerId").on("change", doApply);
  $("#Service").on("change", doApply);

  doApply();
});

function doApply() {
  showWaitGlass();
  enableDisable();
   
  var reqDO = {
    Command: "ConsAPI",
    ConsAPI: {
      DateFrom:        $("#DateFrom-picker").getXMLDate(),
      DateTo:          $("#DateTo-picker").getXMLDate(),
      CompareDateFrom: $("#CompareDateFrom-picker").getXMLDate(),
      CompareDateTo:   $("#CompareDateTo-picker").getXMLDate(),
      ServerId:        getStringParam("#ServerId"), 
      Service:         getStringParam("#Service"),
      Command:         getStringParam("#Command"),
      Grouping:        $("#btnset-grouping .btn.active").attr("data-value"),
      Interval:        $("#StatInterval").val(), 
      CompareType:     $("#btnset-match .btn.active").attr("data-value"),
      TimeZone:        getSelectedTimezoneCode()
    }
  };
  vgsService("Service", reqDO, false, function(ansDO) {
    hideWaitGlass();
    if ((ansDO) && (ansDO.Answer) && (ansDO.Answer.ConsAPIAnswer))
      consAPIAnswer = ansDO.Answer.ConsAPIAnswer;
   
    renderChart(consAPIAnswer.ConsAPI, countChart, "Count", "count-chart", itl("@Stats.Count"), itl("@Stats.Count"), false, true);
    renderChart(consAPIAnswer.ConsAPI, avgChart, "Avg", "avg-chart", itl("@System.ExecutionAverageTime"), itl("@Common.Time"));
    renderChart(consAPIAnswer.ConsAPI, maxChart, "Max", "max-chart", itl("@System.ExecutionMaximumTime"), itl("@Common.Time"), true);
    renderTable($("#count-grid tbody"), consAPIAnswer.ConsAPI.ConsApiCountDetailList, consAPIAnswer.ConsAPI.CurrentCountTotal, consAPIAnswer.ConsAPI.PreviousCountTotal, "CurrentCount", "PreviousCount", "Service", "Command", true, true);
    renderTable($("#average-grid tbody"), consAPIAnswer.ConsAPI.ConsApiAverageDetailList, null, null,  "CurrentAvg", "PreviousAvg", "Service", "Command");
    renderTable($("#max-grid tbody"), consAPIAnswer.ConsAPI.ConsApiMaxDetailList, null, null,  "CurrentMax", "PreviousMax", "Service", "Command");
    renderTable($("#min-grid tbody"), consAPIAnswer.ConsAPI.ConsApiMinDetailList, null, null,  "CurrentMin", "PreviousMin", "Service", "Command");
   }); 
}

  function renderChart(dataObject, chartObj, fieldName, divName, title, axisLabel, zoomBar, legend) {
    var currField = "Current"+fieldName;
    var prevField = "Previous"+fieldName;
    var data = (dataObject.ConsApiSlotList) ? dataObject.ConsApiSlotList : [];

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

    dateFormat = <%=LkSNDateFormat._205.getCode()%>;
    if ((grouping == <%=LkStatGrouping.Slot15.getCode()%>) || (grouping == <%=LkStatGrouping.Hour.getCode()%>))
      dateFormat = dateFormat + 1000;
    else if (grouping == <%=LkStatGrouping.Month.getCode()%>)
      dateFormat = <%=LkSNDateFormat._206.getCode()%>;
      
    if(chartObj == null){
      var chartConfig = {
          "language": graphLang,
          "type": "serial",
          "theme": "light",
          "marginRight":30,
          "marginLeft":30,
///          "dataDateFormat": "YYYY-MM-DD JJ:NN",
          "dataProvider": data,
          "categoryField": "TimeSlot",
          "plotAreaBorderAlpha": 0,
          "marginTop": 10,
          "marginLeft": 0,
          "marginBottom": 0,
          "titles": [{
            "text": title
          }],
          "valueAxes": [{
            "id": "cnt-axis",
            "stackType": "regular",
            "gridAlpha": 0.07,
            "position": "left",
            "title": axisLabel,
            "inside": true,
            "labelFunction":  function(value, valueText, valueAxis) {
              return formatLabel(valueText, legend);//legend used to identify count graph and format value as number and not as time
            } 
          }], 
          graphs: [{
            "bullet": "round",
            "bulletBorderAlpha": 1,
            "bulletColor": "#FFFFFF",
            "bulletSize": 8,
            "hideBulletsCount": 50,
            "lineThickness": 4,
            "fillAlphas": 0.1,
            "lineAlpha": 1,
            "useLineColorForBulletBorder": true,
            "valueField": currField,
            "stackable": false,
            "balloonFunction" : function(graphDataItem, graph){
              return "<b>" + formatLabel(graphDataItem.dataContext[currField], legend) + "</b>";//legend used to identify count graph and format value as number and not as time
            },
            "lineColor": getComputedStyle(document.body).getPropertyValue("--base-blue-color"),
            "type": "line",
            "title": "Current"
          },
          {
            "bullet": "round",
            "bulletBorderAlpha": 1,
            "bulletColor": "#FFFFFF",
            "bulletSize": 8,
            "hideBulletsCount": 50,
            "lineThickness": 4,
            "lineAlpha": 1,
            "fillAlphas": 0.1,
            "useLineColorForBulletBorder": true,
            "stackable": false,
            "type": "line",
            "balloonFunction" : function(graphDataItem, graph){
              return "<b>" + formatLabel(graphDataItem.dataContext[prevField], legend) + "<b>";//legend used to identify count graph and format value as number and not as time
            },
            "lineColor": getComputedStyle(document.body).getPropertyValue("--base-orange-color"),
            "valueField": prevField,
            "title": "Previous"
            }],
          "listeners": [{
            "event": "zoomed",
            "method": syncZoom
          }],
          "chartCursor": {
            "categoryBalloonEnabled": false,
            "listeners": [{
                "event": "moved",
                "method": handleMoved
              }, {
                "event": "onHideCursor",
                "method": handleHide
            }]
         },
         "categoryAxis": {
           "parseDates": true,
           "minPeriod": minPeriod,
           "axisColor": "#DADADA",
           "gridAlpha": 0.07,
           "equalSpacing": true,
           "gridCount": 0
         }
      };
      
      if (zoomBar){
        chartConfig.chartScrollbar = {
          "oppositeAxis": false,
          "offset": 30
          };
        chartConfig.chartCursor.categoryBalloonEnabled= true;
        chartConfig.chartCursor.categoryBalloonFunction = balloonFunction; 
      }
      if (legend){
        chartConfig.legend = {
          "equalWidths": false,
          "position": "top",
          "valueAlign": "left",
          "valueWidth": 100,
          "valueFunction": function(graphDataItem, valueText) {
            return "";
          },
          "listeners": [{
            "event": "hideItem",
            "method": function(item) {
              toggleAllGraphs(item, 'hide');
            }
          }, {
            "event": "showItem",
            "method": function(item) {
              toggleAllGraphs(item, 'show');
            }
          }]
        };
      }
      chartObj = AmCharts.makeChart(divName, chartConfig);
      charts.push(chartObj);
    }else{
      chartObj.dataProvider = data;
      chartObj.categoryAxis.minPeriod = minPeriod;
      chartObj.validateData();
    }
  }

  function handleMoved(e){
    syncCursors(e);
  }

  function handleHide(e){
    hideCursors(e);
  }
  
  function balloonFunction(item){
    if (dateFormat > 1000){
      return formatDate(item, (dateFormat - 1000)) + " - " + formatTime(item, 101);
    }
    else
      return formatDate(item, dateFormat);
  }
  
  function syncCursors(e) {
    for(var i = 0; i < charts.length; i++) {
      if(charts[i] !== e.chart)
        charts[i].chartCursor.syncWithCursor(e.chart.chartCursor);
    }
  }

  function hideCursors(e) {
     for(var i = 0; i < charts.length; i++) {
      if(charts[i] !== e.chart) {
        charts[i].chartCursor.hideCursor();
        charts[i].chartCursor.clearSelection();
      }
    }
  }
  
  function toggleAllGraphs(item, action) {
    for(var i = 0; i < charts.length; i++) {
      var chart = charts[i];
      if (chart == item.chart)
        continue;
      if (action == 'hide')
        chart.hideGraph(chart.graphs[item.dataItem.index]);
      else
        chart.showGraph(chart.graphs[item.dataItem.index]);
    }
  }
  
  function syncZoom(e) {
    if (e.chart.ignoreZoom) {
      e.chart.ignoreZoom = false;
      return;
    }
    for(var i = 0; i < charts.length; i++) {
      if(charts[i] !== e.chart) {
        charts[i].ignoreZoom = true;
        charts[i].zoomToDates(e.startDate, e.endDate);
      }
    }
  }
  
  function formatValue(valueText, isQuantityField) {
    if (isQuantityField)
      return getSmoothQuantity(valueText);
    else
      return getSmoothTime(valueText);
  }
  
  function formatLabel(valueText, isNumeric) {
    var result = "" + valueText;
    result = result.replace(/,/g, "");
    result = result.replace(/\./g, "");
    result = formatValue(result, isNumeric);
    return result;
  }
  
  function getMaxValue(objList, fieldName) {
    var result = 0;
    for (var i=0; i<objList.length; i++) {
      var itemValue = strToIntDef(objList[i][fieldName], 0);
      result = (itemValue > result) ? itemValue : result;
    }    
    return result;
  }

  function renderTable(tbodySelector, objList, currPercentTotal, prevPercentTotal, currField, prevField, nameField, codeField, isQuantityField) {
    var tbody = $(tbodySelector).empty();
    var list = (objList) ? objList : [];
    
    if (!objList)
      return;
    
    if (!currPercentTotal)
      currPercentTotal = getMaxValue(objList, currField);
    
    if (!prevPercentTotal)
      prevPercentTotal = currPercentTotal;//getMaxValue(objList, prevField);
      
    for (var i=0; i<list.length; i++) {
      var item = list[i];
      var curramt = strToIntDef(item[currField], 0);
      var prevamt = strToIntDef(item[prevField], 0);
      
      var tr = $("<tr class='grid-row'/>").appendTo(tbody);
      var tdPrd = $("<td width='100%' align='left' nowrap><span class='list-title'/><br/><span class='event-code list-subtitle'/></td>").appendTo(tr);
      var tdCur = $("<td class='td-qty-curr' align='center' nowrap><div class='pb-qty'/><div class='pb-outer'><div class='pb-inner'/></div></td>").appendTo(tr);
      var tdPrv = $("<td class='td-qty-prev' align='center' nowrap><div class='pb-qty'/><div class='pb-outer'><div class='pb-inner'/></div></td>").appendTo(tr);
      var tdVar = $("<td class='td-var' align='center' nowrap/>").appendTo(tr);

       tdPrd.find(".list-title").text(item[nameField]);//service
      if (item[codeField])
        tdPrd.find(".event-code").text(item[codeField]);//command
      else
        tdPrd.find(".event-code").html(" &macr; ");

      var currprc = (100 * curramt) / parseInt(currPercentTotal);
      var prevprc = 100 * prevamt / parseInt(prevPercentTotal);
      
      if (prevamt < 0)
        prevprc = 0;

      if (curramt < 0)
        currprc = 0;
      
      tdCur.find(".pb-inner").css("width", ((currprc < 100 ) ? currprc : 100) + "%");
      tdCur.find(".pb-qty").html(formatValue(curramt, isQuantityField) + "&nbsp;&nbsp;&nbsp;(" + formatAmount(currprc, 0) + "%)");
      tdPrv.find(".pb-inner").css("width", ((prevprc < 100 ) ? prevprc : 100) + "%");
      tdPrv.find(".pb-qty").html(formatValue(prevamt, isQuantityField) + "&nbsp;&nbsp;&nbsp;(" + formatAmount(prevprc, 0) + "%)");
 
      tdVar.html(formatVariationPerc(curramt, prevamt));
      addVarianceClass(tdVar, curramt, prevamt);
    }
  }
</script>