<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<%
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");
String id = "widget_" + JvUtils.newSqlStrUUID();
LookupItem queueStatType = LkSN.QueueStatType.getItemByCode(request.getParameter("QueueStatType"));

String title = "Queue " + JvString.RAQUO + " " + queueStatType.getDescription(pageBase.getLang());

String groupCode = request.getParameter("GroupCode");
String groupName = request.getParameter("GroupName");
if (groupCode != null)
  title += " " + JvString.RAQUO + " "  + ((groupName == null) ? groupCode : groupName);
%>

<style>
#<%=id%> .queue-chart {
  height: 200px;
}

#<%=id%> .progress {
  margin-bottom: 10px;
}

#<%=id%> .progress-bar-busy {
  background: var(--base-red-color);
}

#<%=id%> .progress-bar-free {
  background: var(--base-green-color);
}

#<%=id%> .info-value {
  font-weight: bold;
}

</style>

<v:widget id="<%=id%>" clazz="stat-widget" caption="<%=title%>">
  <v:widget-block clazz="block-error hidden">Connection error</v:widget-block>
  <div class="block-result hidden">
  <% if (groupCode == null) { %>
    <v:widget-block>
      <div class="progress"><div class="progress-bar progress-bar-busy"></div><div class="progress-bar progress-bar-free"></div></div>
      <div><span class="info-value busy-thread-count"></span> / <span class="info-value max-queue-size"></span> running threads (<span class="info-value free-thread-count"></span> ready)</div>
      <div><span class="info-value wait-count"></span> waiting items (<span class="info-value wait-max-time"></span> max wait time)</div>
      <div><span class="info-value work-count"></span> working items (<span class="info-value work-max-time"></span> max work time)</div>
    </v:widget-block>
  <% } %>
    <v:widget-block>
      <div class="queue-chart"></div>
    </v:widget-block>
  </div>
</v:widget>

<script>

$(document).ready(function() {
  var $widget = $("#<%=id%>");
  $widget.on("remove", function() {
    $widget = null;
  });
  
  var requestCount = 0;
  refresh();
  initChart($widget.find(".queue-chart"));
  
  function refresh() {
    if ($widget != null) {
      var reqDO = {
        Command: "QueueStatStatus",
        QueueStatStatus: {
          QueueStatType: <%=queueStatType.getCode()%>,
          GroupCode: <%=JvString.jsString(groupCode)%>,
          TimeZone: getSelectedTimezoneCode()
        }
      };
      
      requestCount = (requestCount + 1) % 15;
      reqDO.QueueStatStatus.IncludeDetails = (requestCount == 1);
      
      $widget.addClass("loading");
      vgsService("Service", reqDO, true, function(ansDO) {
        var good = (ansDO.Answer) && (ansDO.Answer.QueueStatStatus);
        $widget.removeClass("loading");
        $widget.find(".block-error").setClass("hidden", good);
        $widget.find(".block-result").setClass("hidden", !good);
        if (good) 
          render(ansDO.Answer.QueueStatStatus.QueueStatStatus, reqDO.QueueStatStatus.IncludeDetails);
        else
          console.error(ansDO);

        setTimeout(refresh, ENGSTATS_REFRESH_DELAY);
      });
    } 
  }
  
  function render(stats, includeDetails) {
    $widget.find(".wait-count").text(getSmoothQuantity(stats.CurrentWaitCount));
    $widget.find(".wait-max-time").text(getSmoothTime(stats.CurrentWaitMaxMS));
    $widget.find(".work-count").text(getSmoothQuantity(stats.CurrentWorkCount));
    $widget.find(".work-max-time").text(getSmoothTime(stats.CurrentWorkMaxMS));

    $widget.find(".busy-thread-count").text(getSmoothQuantity(stats.CurrentBusyCount));
    $widget.find(".free-thread-count").text(getSmoothQuantity(stats.CurrentFreeCount));
    $widget.find(".max-queue-size").text(getSmoothQuantity(stats.CurrentMaxSize));
    
    var $barBusy = $widget.find(".progress-bar-busy");
    var percBusy = 100 * stats.CurrentBusyCount / stats.CurrentMaxSize;
    var color = (percBusy <= 50) ? "green" : (percBusy <= 80) ? "orange" : "red";
    $widget.find(".progress-bar-busy").css({
      "width": percBusy + "%",
      "background": "var(--base-" + color + "-color)"
    });
    /*
    var percFree = 100 * stats.CurrentFreeCount / stats.CurrentMaxSize;
    $widget.find(".progress-bar-busy").css("width", percBusy + "%");
    $widget.find(".progress-bar-free").css("width", percFree + "%");
    */
    
    
    if (includeDetails) {
      var list = stats.Last24hList;
      if (list)
        for (var i=0; i<list.length; i++)
          list[i].TimeSlot = xmlToDate(list[i].TimeSlot);

      var chart = $widget.find(".queue-chart").data("chart");
      chart.dataProvider = list;
      chart.validateData();
    }
  }
  
  function initChart($chart) {
    var cfg = {
      "type": "serial",
      "theme": "none",
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
            return "<b>" + getSmoothQuantity(graphDataItem.values.value) + "</b> requests"
         }
        },
        {
          "lineColor": getComputedStyle(document.body).getPropertyValue("--base-red-color"),
          "lineThickness": 1,
          "lineAlpha": 1,
          "fillAlphas": 0.1,
          "type": "smoothedLine",
          "valueField": "QueueAvgMS",
          "valueAxis": "duration-axis",
          "title": <v:itl key="@Stats.QueueAverage" encode="JS"/>,
          "balloonFunction": function(graphDataItem, graph) {
            return "Queue AVG <b>" + getSmoothTime(graphDataItem.values.value) + "</b>"
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
             return "Processing AVG <b>" + getSmoothTime(graphDataItem.values.value) + "</b>"
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
