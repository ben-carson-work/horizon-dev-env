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
String chartHeight = request.getParameter("chart-height");
%>

<style>
#<%=id%> .db-chart {
  height: <%=(chartHeight != null) ? chartHeight : "150px"%>;
}

#<%=id%> .block-result .block-data {
  display: flex;
  justify-content: space-between;
}

#<%=id%> .cpu-chart-container {
  flex-grow: 1;
}

#<%=id%> .info-container {
  width: 500px;
}

#<%=id%> .info{
  margin-bottom: 20px;
}

#<%=id%> .block-rights {
  font-style: italic;
}

</style>

<v:widget id="<%=id%>" clazz="stat-widget" caption="Database">
  <v:widget-block clazz="block-error hidden">Connection error</v:widget-block>
  <div class="block-result hidden">
    <v:widget-block clazz="hidden block-warns">
    </v:widget-block>
    <v:widget-block clazz="hidden block-rights">
      Unable to retrieve disk usage information.<br/>
      Please be sure that DB user has these privileges granted: <b>"View Any Definition"</b> and <b>"View Server State"</b>
    </v:widget-block>
    <v:widget-block clazz="hidden block-data">
      <div class="cpu-chart-container"><div class="db-chart"></div></div>
      <div class="info-container">
        <div class="info">
          Cores: <strong><span class="info-cpu-count"/></strong>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          Memory: <strong><span class="info-memory"/></strong>
        </div>
        <div class="drives-container"></div>
      </div>
    </v:widget-block>
  </div>

  <div class="templates hidden">
    <div class="drive-template">
      Drive: <strong><span class="drive-drive"/> (<span class="drive-logicalname"/>)</strong>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      Available: <strong><span class="drive-freespace"/></strong>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      Total: <strong><span class="drive-totalspace"/></strong>
      <div class="progress" style="margin-top:4px; margin-bottom:0"><div class="progress-bar"></div></div>
    </div>
    
    <v:alert-box type="warning" clazz="warn-template"></v:alert-box>
  </div>
</v:widget>

<script>

$(document).ready(function() {
  var $widget = $("#<%=id%>");
  $widget.on("remove", function() {
    $widget = null;
  });
  
  refresh();
  initChart($widget.find(".db-chart"));
  
  function refresh() {
    if ($widget != null) {
      var reqDO = {
        Command: "DatabaseServerStatus",
        DatabaseServerStatus: {
          TimeZone: getSelectedTimezoneCode()
        }
      };

      $widget.addClass("loading");
      vgsService("Service", reqDO, true, function(ansDO) {
        var good = (ansDO.Answer) && (ansDO.Answer.DatabaseServerStatus);
        $widget.removeClass("loading");
        $widget.find(".block-error").setClass("hidden", good);
        $widget.find(".block-result").setClass("hidden", !good);
        if (good) 
          render(ansDO.Answer.DatabaseServerStatus.DatabaseStats);
        setTimeout(refresh, ENGSTATS_REFRESH_DELAY);
      });
    } 
  }
  
  function render(stats) {
    if (stats.CpuSlotList)
      for (var i=0; i<stats.CpuSlotList.length; i++)
        stats.CpuSlotList[i].DateTime = xmlToDate(stats.CpuSlotList[i].DateTime);
    
    var hasWarns = (stats.Warnings) && (stats.Warnings.length > 0);
    var $warns = $widget.find(".block-warns").empty().setClass("hidden", !hasWarns);
    if (hasWarns) {
      var reader = new commonmark.Parser();
      var writer = new commonmark.HtmlRenderer();
      for (var i=0; i<stats.Warnings.length; i++) { 
        var warn = writer.render(reader.parse(stats.Warnings[i])); 
        var $box = $(".templates .warn-template").clone().appendTo($warns);
        $box.find(".alert-body").html(warn);
      }
    }
    
    stats.PermissionDenied = (stats.PermissionDenied) ? stats.PermissionDenied : false;
    $widget.find(".block-rights").setClass("hidden", !stats.PermissionDenied);
    $widget.find(".block-data").setClass("hidden", stats.PermissionDenied);
    
    var chart = $widget.find(".db-chart").data("chart");
    chart.dataProvider = stats.CpuSlotList;
    chart.validateData();
    
    $widget.find(".info-cpu-count").text(stats.CpuCount);
    $widget.find(".info-memory").text(getSmoothSize(stats.PhisicalMemory));
    
    var $drives = $widget.find(".drives-container"); 
    $drives.empty();

    if (stats.DriveList) {
      for (var i=0; i<stats.DriveList.length; i++) {
        var drive = stats.DriveList[i];
        var used = drive.TotalSpace - drive.FreeSpace;
        var perc = 100 * used / drive.TotalSpace;
        var freeGB = drive.FreeSpace / (1024 * 1024 * 1024);
        var color = (freeGB < 5) ? "var(--base-red-color)" : (freeGB < 50) ? "var(--base-orange-color)" : "var(--base-green-color)";

        $drive = $widget.find(".drive-template").clone().appendTo($drives);
        $drive.find(".drive-drive").text(drive.Drive);
        $drive.find(".drive-logicalname").text(drive.LogicalName);
        $drive.find(".drive-freespace").text(getSmoothSize(drive.FreeSpace));
        $drive.find(".drive-totalspace").text(getSmoothSize(drive.TotalSpace));
        $drive.find(".progress-bar").css({
          "width": perc + "%",
          "background": color
        });
      }
    }
  }
  
  function initChart($chart) {
    var cfg = {
      "type": "serial",
      "theme": "light",
      "marginRight":30,
      "legend": {
        "equalWidths": false,
        "position": "left",
        "valueAlign": "left",
        "valueWidth": 100
      },
      "valueAxes": [{
        "stackType": "regular",
        "gridAlpha": 0.07,
        "position": "left",
        "maximum": 100
      }],
      "graphs": [{
        "balloonText": "SQL Server process: <b>[[value]]%</b></span>",
        "fillAlphas": 0.4,
        "lineAlpha": 1,
        "type": "smoothedLine",
        "title": "SQL Server",
        "valueField": "SqlUsage",
        "lineColor": getComputedStyle(document.body).getPropertyValue("--base-orange-color"),
        "fillColors": getComputedStyle(document.body).getPropertyValue("--base-orange-color")
      },
      {
        "balloonText": "Other processes: <b>[[value]]%</b></span>",
        "fillAlphas": 0.4,
        "lineAlpha": 1,
        "type": "smoothedLine",
        "title": "Other processes",
        "valueField": "OtherUsage",
        "lineColor": getComputedStyle(document.body).getPropertyValue("--base-blue-color"),
        "fillColors": getComputedStyle(document.body).getPropertyValue("--base-blue-color")
      }],
      "plotAreaBorderAlpha": 0,
      "marginTop": 10,
      "marginLeft": 0,
      "marginBottom": 0,
      "chartCursor": {
          "cursorAlpha": 0
      },
      "categoryField": "DateTime",
      "categoryAxis": {
        "startOnAxis": true,
        "axisColor": "#DADADA",
        "gridAlpha": 0.07,
        "labelRotation": 45,
        "labelFunction": function(valueText, date, categoryAxis) {
          return formatTime(date.dataContext.DateTime, <%=LkSNTimeFormat._101.getCode()%>);
        }
      }
    };
    
    $chart.data("chart", AmCharts.makeChart($chart[0], cfg));
  }
});

</script>
