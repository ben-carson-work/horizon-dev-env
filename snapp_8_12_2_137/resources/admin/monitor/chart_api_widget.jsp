<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageEngineStats" scope="request"/>

<%
String id = "widget_" + JvUtils.newSqlStrUUID();
String service = JvString.getTrimmedNull(request.getParameter("Service"));
String command = JvString.getTrimmedNull(request.getParameter("Command"));

String title = "APIs";
if (service != null)
  title += " " + JvString.MDASH + " " + service;
if (command != null)
  title += "." + command;
%>

<style>
#<%=id%> .api-chart {
  height: 200px;
}
</style>

<v:widget id="<%=id%>" clazz="stat-widget" caption="<%=title%>">
  <v:widget-block clazz="block-error hidden">Connection error</v:widget-block>
  <div class="block-result hidden">
    <v:widget-block>
      <div class="api-chart"></div>
    </v:widget-block>
  </div>
</v:widget>

<script>

$(document).ready(function() {
  var $widget = $("#<%=id%>");
  $widget.on("remove", function() {
    $widget = null;
  });
  
  refresh();
  initChart($widget.find(".api-chart"));
  
  function refresh() {
    if ($widget != null) {
      var reqDO = {
        Command: "ApiStatus",
        ApiStatus: {
          Service: <%=JvString.jsString(service)%>,
          Command: <%=JvString.jsString(command)%>,
          TimeZone: getSelectedTimezoneCode()
        }
      };
      
      $widget.addClass("loading");
      vgsService("Service", reqDO, true, function(ansDO) {
        var good = (ansDO.Answer) && (ansDO.Answer.ApiStatus);
        $widget.removeClass("loading");
        $widget.find(".block-error").setClass("hidden", good);
        $widget.find(".block-result").setClass("hidden", !good);
        if (good) 
          render(ansDO.Answer.ApiStatus);
        setTimeout(refresh, ENGSTATS_REFRESH_DELAY);
      });
    } 
  }
  
  function render(stats) {
    var list = stats.SlotList;
    if (list)
      for (var i=0; i<list.length; i++)
        list[i].TimeSlot = xmlToDate(list[i].TimeSlot);

    var chart = $widget.find(".api-chart").data("chart");
    chart.dataProvider = list;
    chart.validateData();
  }
  
  function initChart($chart) {
    var cfg = {
      "type": "serial",
      "theme": "none",
      "marginLeft": 80,
      "categoryField": "TimeSlot",
      "valueAxes": [
        {
          "id": "duration-axis",
          "axisAlpha": 0, 
          "autoGridCount": false,
          "gridCount": 2,
          "gridAlpha": 0.1,
          "position": "left",
          "stackType": "regular",
          "title": <v:itl key="@Common.Duration" encode="JS"/>,
          "labelFunction": function(value, valueText, valueAxis) {
            return getSmoothTime(value); 
          }
        },
        {
          "id": "count-axis",
          "axisAlpha": 0, 
          "position": "right",
          "precision": 0,
          "title": <v:itl key="@Stats.Count" encode="JS"/>,
          "inside": false,
          "gridThickness": 0,
          "labelFunction": function(value, valueText, valueAxis) {
            return getSmoothQuantity(value); 
          }
        }
      ],
      "graphs": [
        {
          "lineColor": getComputedStyle(document.body).getPropertyValue("--base-gray-color"),
          "fillAlphas": 1,
          "type": "column",
          "lineThickness": 0.5,
          "valueField": "Count",
          "valueAxis": "count-axis",
          "title": <v:itl key="@Stats.Count" encode="JS"/>,
          "balloonFunction": function(graphDataItem, graph) {
            return "<b>" + getSmoothQuantity(graphDataItem.values.value) + "</b> items"
         }
        },
        {
          "lineColor": getComputedStyle(document.body).getPropertyValue("--base-blue-color"),
          "lineThickness": 1,
          "lineAlpha": 1,
          "fillAlphas": 0.1,
          "type": "smoothedLine",
          "valueField": "ProcAvgMS",
          "valueAxis": "duration-axis",
          "title": <v:itl key="@Stats.ProcessingAverage" encode="JS"/>,
          "balloonFunction": function(graphDataItem, graph) {
            return "Average <b>" + getSmoothTime(graphDataItem.values.value) + "</b>"
         }
        }
      ],
      chartCursor: {
        "cursorAlpha": 0,
        "cursorPosition": "mouse"
      },
      categoryAxis: {
        "equalSpacing": true,
        "axisColor": getComputedStyle(document.body).getPropertyValue("--border-color"),
        "gridAlpha": 0,
        "labelRotation": 45,
        "labelFunction": function(valueText, date, categoryAxis) {
          return formatTime(date.dataContext.TimeSlot, <%=LkSNTimeFormat._101.getCode()%>);
        }
      },
    }; 
    
    $chart.data("chart", AmCharts.makeChart($chart[0], cfg));
  }
});

</script>
