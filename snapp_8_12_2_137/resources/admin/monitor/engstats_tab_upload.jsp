<%@page import="javax.swing.plaf.IconUIResource"%>
<%@page import="com.vgs.cl.database.*"%>
<%@page import="java.util.Map.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageEngineStats" scope="request"/>


<script src="<v:config key="site_url"/>/libraries/amcharts/amcharts.js"></script>
<script src="<v:config key="site_url"/>/libraries/amcharts/serial.js"></script>

<style>

#cmd-list,
#request-list {
  width: 500px;
  float: left;
  margin-right: 10px;
}

#cmd-list tr td {
  text-align: right;
}

#cmd-list tr td:first-child {
  text-align: left;
}

#concurrent {
  background: #fafafa;
  padding: 10px;
  border: 1px #efefef solid;
}

.chart {
  margin-top: 10px;
  margin-bottom: 20px;
  height: 250px;
}

.changed {
  font-weight: bold;
  text-shadow: 0px 1px 0px white;
  color: black !important;
}

thead td.sort a {
  text-decoration: underline;
}

.graph-title {
  font-weight: bold;
  margin-top: 20px;
  margin-bottom: -10px;
  text-align: center;
}

a[href="http://www.amcharts.com/javascript-charts/"] {
  display: none !important;
}

</style>

<div class="tab-toolbar">
  <v:button id="btn-start" caption="@Common.Start" fa="play-circle"/>
  <v:button id="btn-stop" caption="@Common.Stop" fa="stop-circle"/>
</div>

<div class="tab-content" style="overflow:hidden">

<div id="concurrent">
  - Last minute processed transactions: <b><span id="last-min-reqs"></span></b><br/> 
  - Currently processing: <b><span id="working-reqs"></span></b><br/>
  - Currently in queue: <b><span id="waiting-reqs"></span></b><br/>
</div>

<div class="graph-title">Last hour transactions</div>
<div id="hour-chart" class="chart"></div>

<div class="graph-title">Last 24 hours transactions</div>
<div id="day-chart" class="chart"></div>

<script>

$(document).ready(function() {

  var started = true;

  var uploadCharts = {};
  function renderSlotChart(chartId, ansDO) {
    var data = (ansDO.UploadList) ? ansDO.UploadList : [];
    if (uploadCharts[chartId] != null) {
      uploadCharts[chartId].dataProvider = data;
      uploadCharts[chartId].validateData();
    } 
    else {
      uploadCharts[chartId] = AmCharts.makeChart(chartId, {
        type: "serial",
        theme: "none",
        marginLeft: 20,
        dataProvider: data,
        legend: {
          markerType: "square",
          position: "top",
          autoMargins: true
        },
        valueAxes: [
          {
            id: "time-axis",
            axisAlpha: 0,
            inside: false,
            autoGridCount: false,
            gridCount: 2,
            gridAlpha: 0.1,
            color: "#444444",
            position: "left",
            title: "duration",
            stackType: "regular",
            labelFunction: function(value, valueText, valueAxis) {
              return valueText + "ms";
            }
          },
          {
            id: "cnt-axis",
            axisAlpha: 0,
            inside: false,
            gridThickness: 0,
            color: "#444444",
            position: "right",
            title: "count"
          }
        ],
        graphs: [
          {
            balloonText: "<b>[[Count]] requests</b>",
            lineColor: "#c1beb9",
            fillAlphas: 1.0,
            type: "column",
            valueField: "Count",
            valueAxis: "cnt-axis",
            title: "Count"
          },
          {
            balloonText: "Queue <b>[[AvgQueueMS]]ms</b>",
            lineColor: getComputedStyle(document.body).getPropertyValue("--base-red-color"),
            lineThickness: 1,
            lineAlpha: 0.4,
            fillAlphas: 0.15,
            type: "line",
            valueField: "AvgQueueMS",
            valueAxis: "time-axis",
            title: "Queue average"
          },
          {
            balloonText: "Processing <b>[[AvgProcMS]]ms</b>",
            lineColor: getComputedStyle(document.body).getPropertyValue("--base-blue-color"),
            lineThickness: 1,
            lineAlpha: 0.6,
            fillAlphas: 0.15,
            type: "line",
            valueField: "AvgProcMS",
            valueAxis: "time-axis",
            title: "Processing average"
          }
        ],
        chartCursor: {
          cursorAlpha: 0,
          cursorPosition: "mouse"
        },
        categoryField: "TimeSlotFmt",
        categoryAxis: {
          color: "#444444",
          gridThickness: 0
        }
      });
    }
  }

  function applyCmdSort() {
    $("#cmd-list thead td").removeClass("sort");
    $("#cmd-list thead td").filter("." + cmdSortField).addClass("sort");
    
    $("#cmd-list tbody tr").sort(function(trA, trB) {
      var valA = $(trA).find("." + cmdSortField).html();
      var valB = $(trB).find("." + cmdSortField).html();
      
      if (cmdSortField == "cmd")
        return (valA > valB) ? 1 : -1;
      else 
        return (parseInt(valB) > parseInt(valA)) ? 1 : -1; 
    }).appendTo('#cmd-list tbody');
  }

  function changeCmdSortField(field) {
    cmdSortField = field;
    applyCmdSort();
  }

  function doEnableDisable() {
    $("#btn-start").setClass("v-hidden", started);
    $("#btn-stop").setClass("v-hidden", !started);
  }

  function doUploadStatus(groupType, callback) {
    var reqDO = {
      Command: "UploadStatus",
      UploadStatus: {
        GroupType: groupType,
        TimeZone: getSelectedTimezoneCode()
      }
    };
    
    vgsService("Service", reqDO, true, function(ansDO) {
      var errorMessage = getVgsServiceError(ansDO);
      if (errorMessage == null) {
        $("#last-min-reqs").html(ansDO.Answer.UploadStatus.LastMinuteCount);
        $("#waiting-reqs").html(ansDO.Answer.UploadStatus.WaitingRequestCount);
        $("#working-reqs").html(ansDO.Answer.UploadStatus.WorkingRequestCount);
      } 
      
      if (callback)
        callback(ansDO);
    });
  }

  function refreshLastHour() {
    doEnableDisable(); 
    if (started) {
      doUploadStatus("hour", function(ansDO) {
        var errorMessage = getVgsServiceError(ansDO);
        if (errorMessage == null) 
          renderSlotChart("hour-chart", ansDO.Answer.UploadStatus);
        else
          $("#database-status").html(errorMessage);
        setTimeout(refreshLastHour, 60000);
      });
    }
  }

  function refreshLastDay() {
    doEnableDisable(); 
    if (started) {
      doUploadStatus("day", function(ansDO) {
        var errorMessage = getVgsServiceError(ansDO);
        if (errorMessage == null) 
          renderSlotChart("day-chart", ansDO.Answer.UploadStatus);
        else
          $("#database-status").html(errorMessage);
        setTimeout(refreshLastDay, 5 * 60000);
      });
    }
  }

  $("#btn-start").click(function() {
    started = true;
    refreshLastHour();
    refreshLastDay();
  });

  $("#btn-stop").click(function() {
    started = false;
    doEnableDisable();
  });

  refreshLastHour();
  refreshLastDay();

  $("#adminbody").on("remove", function () {
    started = false;
  });
});

</script>

</div>