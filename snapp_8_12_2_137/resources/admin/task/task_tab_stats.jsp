<%@page import="com.vgs.web.tag.TagAttributeBuilder"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="java.text.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.task.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTask" scope="request"/>
<jsp:useBean id="task" class="com.vgs.snapp.dataobject.DOTask" scope="request"/>

<jsp:include page="/resources/common/amchart-include.jsp"><jsp:param name="amchart-graphs" value="serial,pie"/></jsp:include>

<style>
  .task-stat-table {width:100%}
  .task-stat-table td {padding:5px}
  .balloon-period, .balloon-value {font-weight:bold}
</style>

<v:tab-content>
  <% if (!task.TaskStatus.isLookup(LkSNTaskStatus.Active)) { %>
    <v:alert-box type="warning" title="@Common.Status">
      <v:itl key="@Task.CurrentStatusWarn"/>: <b><%=task.TaskStatus.getHtmlLookupDesc(pageBase.getLang())%></b> 
    </v:alert-box>
  <% } %>

  <v:profile-recap>
    <v:widget caption="@Common.DateRange">
      <v:widget-block>
        <v:itl key="@Stats.DatesInterval"/><br/>
        <v:lk-combobox field="StatInterval" lookup="<%=LkSN.StatInterval%>" allowNull="false"/>
        <table id="custom-date-table" style="width:100%;border:0;">
          <tr>
            <td width="50%">
              <v:itl key="@Common.FromDate"/><br/>
              <v:input-text type="datepicker" field="DateFrom"/>
            </td>
            <td>&nbsp;</td>
            <td width="50%">
              <v:itl key="@Common.ToDate"/><br/>
              <v:input-text type="datepicker" field="DateTo"/>
            </td>
          </tr>
        </table>        
      </v:widget-block>
      
      <v:widget-block style="text-align:center">
        <div style="margin-bottom:5px"><v:itl key="@Task.StatsAggregateType"/></div>
        <v:button-group id="btngrp-aggregate">
          <% for (LookupItem item : LkSN.TaskStatsAggregateType.getItems()) { %>
            <v:button caption="<%=item.getRawDescription()%>" attributes="<%=TagAttributeBuilder.builder().put(\"data-value\", item.getCode())%>"/>
          <% } %>
        </v:button-group>
      </v:widget-block>
    </v:widget>
  </v:profile-recap>
  
  <v:profile-main>
    <v:stat-section title="@Task.Jobs">
      <table class="task-stat-table">
        <tr>
          <td width="25%"><v:stat-box id="stat-box-status-total" title="@Common.Total"><v:stat-box-value value="0"/></v:stat-box></td>
          <td width="25%"><v:stat-box id="stat-box-status-succedeed" title="@Common.Completed"><v:stat-box-value value="0" color="var(--base-green-color)"/></v:stat-box></td>
          <td width="25%"><v:stat-box id="stat-box-status-failed" title="@Common.Aborted"><v:stat-box-value value="0" color="var(--base-red-color)"/></v:stat-box></td>
          <td width="25%" rowspan="2"><div id="task-statuspie" style="width:100%; height:190px;"></td>
        </tr>
        <tr>
          <td><v:stat-box id="stat-box-status-execmin" title="@System.ExecutionMinimumTime"><v:stat-box-value value="0"/></v:stat-box></td>
          <td><v:stat-box id="stat-box-status-execavg" title="@System.ExecutionAverageTime"><v:stat-box-value value="0"/></v:stat-box></td>
          <td><v:stat-box id="stat-box-status-execmax" title="@System.ExecutionMaximumTime"><v:stat-box-value value="0"/></v:stat-box></td>
        </tr>
      </table>

      <v:widget>
        <v:widget-block>
          <div id="task-statuscount" style="width:100%; height: 200px"></div>
          <div id="task-avg-chart" style="width:100%; height: 200px"></div>
          <div id="task-max-chart" style="width:100%; height: 200px"></div>
        </v:widget-block>
      </v:widget>
    </v:stat-section>
  
    <v:stat-section title="@Task.StatsProcessedItems">
      <table class="task-stat-table">
        <tr>
          <td width="75%" colspan="3"><v:stat-box id="stat-box-counter-total" title="@Common.Total"><v:stat-box-value value="0"/></v:stat-box></td>
          <td width="25%" rowspan="2"><div id="task-counterpie" style="width:100%; height:190px"></td>
        </tr>
        <tr>
          <td width="25%"><v:stat-box id="stat-box-counter-succedeed" title="@Task.JobSuccedeed"><v:stat-box-value value="0" color="var(--base-green-color)"/></v:stat-box></td>
          <td width="25%"><v:stat-box id="stat-box-counter-warning" title="@Task.JobWarning"><v:stat-box-value value="0" color="var(--base-orange-color)"/></v:stat-box></td>
          <td width="25%"><v:stat-box id="stat-box-counter-failed" title="@Task.JobFailed"><v:stat-box-value value="0" color="var(--base-red-color)"/></v:stat-box></td>
        </tr>
      </table>

      <v:widget>
        <v:widget-block>
        <div id="task-countercount" style="width:100%; height: 200px"></div>
        </v:widget-block>
      </v:widget>
    </v:stat-section>

  </v:profile-main>
  
  <div id="task-stats-templates" class="hidden">
    <div class="task-stats-status-balloon">
      <div class="balloon-period"></div>
      <div><v:itl key="@Task.Jobs"/>: <span class="balloon-value balloon-exec-count"></span></div> 
      <div><v:itl key="@System.ExecutionMinimumTime"/>: <span class="balloon-value balloon-exec-min"></span></div> 
      <div><v:itl key="@System.ExecutionAverageTime"/>: <span class="balloon-value balloon-exec-avg"></span></div> 
      <div><v:itl key="@System.ExecutionMaximumTime"/>: <span class="balloon-value balloon-exec-max"></span></div> 
    </div>

    <div class="task-stats-counter-balloon">
      <div class="balloon-period"></div>
      <div><v:itl key="@Task.JobSuccedeed"/>: <span class="balloon-value balloon-succeeded"></span></div> 
      <div><v:itl key="@Task.JobWarning"/>: <span class="balloon-value balloon-warning"></span></div> 
      <div><v:itl key="@Task.JobFailed"/>: <span class="balloon-value balloon-failed"></span></div> 
    </div>
  </div>
  
</v:tab-content>

<script>
$(document).ready(function() {
  const AggregateType_Job = <%=LkSNTaskStatsAggregateType.Job.getCode()%>;
  const AggregateType_Day = <%=LkSNTaskStatsAggregateType.Day.getCode()%>;
  const AggregateType_Week = <%=LkSNTaskStatsAggregateType.Week.getCode()%>;
  const AggregateType_Month = <%=LkSNTaskStatsAggregateType.Month.getCode()%>;
  
  var chartStatusPie = null;
  var chartStatusCount = null;
  var chartAvg = null;
  var chartMax = null;
  var chartCounterPie = null;
  var chartCounterCount = null;
  
  $("#StatInterval").val(<%=LkStatInterval.Last7d.getCode()%>).change(_onIntervalChange);
  $("#btngrp-aggregate .btn[data-value=" + AggregateType_Day + "]").addClass("active");
  $("#btngrp-aggregate .btn").click(_onAggregateClick);
  
  _update();
  
  function _onIntervalChange() {
    recalcInterval();
    _update();
  }
  
  function _onAggregateClick() {
    var $btn = $(this);
    $btn.siblings(".btn").removeClass("active");
    $btn.addClass("active");
    _update();
  }

  function _getAggregateType() {
    return strToIntDef($("#btngrp-aggregate .btn.active").attr("data-value"), AggregateType_Day);
  }
  
  function _enableDisable() {
    var disabled = (parseInt($("#StatInterval").val()) != <%=LkStatInterval.Custom.getCode()%>);
    $("#custom-date-table").setClass("disabled", disabled);
    $("#DateFrom-picker").datepicker(disabled ? "disable" : "enable");
    $("#DateTo-picker").datepicker(disabled ? "disable" : "enable");

    var dateFrom = $("#DateFrom-picker").datepicker("getDate");
    var dateTo = $("#DateTo-picker").datepicker("getDate");
    var msday = 1000*60*60*24;
    var days = 1 + Math.round(Math.abs(dateTo.getTime() - dateFrom.getTime()) / msday);
      
    $("#btngrp-aggregate [data-value='" + AggregateType_Job + "']").setEnabled(days <= 1);
    $("#btngrp-aggregate [data-value='" + AggregateType_Day + "']").setEnabled(days <= 31);
    $("#btngrp-aggregate [data-value='" + AggregateType_Week + "']").setEnabled(days <= 366);
    
    var $radios = $("#btngrp-aggregate .btn");
    if (!$radios.filter(".active").isEnabled()) {
      $radios.removeClass("active");
      $radios.not("[disabled]").first().addClass("active");
    }
  }
  
  function _update() {
    _enableDisable();
    
    snpAPI.cmd("Task", "GetStatistics", {
      "TaskId": <%=JvString.jsString(pageBase.getId())%>,
      "DateFrom": $("#DateFrom-picker").getXMLDate(),
      "DateTo": $("#DateTo-picker").getXMLDate(),
      "AggregateType": _getAggregateType()
    }).then(ansDO => {
      $("#stat-box-status-total .stat-box-value").text(getSmoothQuantity(ansDO.Data.StatusExecCount));
      $("#stat-box-status-succedeed .stat-box-value").text(__formatCountPerc(ansDO.Data.StatusExecCount, ansDO.Data.StatusSucceededCount, ansDO.Data.StatusSucceededPerc));
      $("#stat-box-status-failed .stat-box-value").text(__formatCountPerc(ansDO.Data.StatusExecCount, ansDO.Data.StatusFailedCount, ansDO.Data.StatusFailedPerc));
      $("#stat-box-status-execmin .stat-box-value").text(getSmoothTime(ansDO.Data.ExecMinMS));
      $("#stat-box-status-execavg .stat-box-value").text(getSmoothTime(ansDO.Data.ExecAvgMS));
      $("#stat-box-status-execmax .stat-box-value").text(getSmoothTime(ansDO.Data.ExecMaxMS));

      chartStatusPie = _renderStatusPie(chartStatusPie, "task-statuspie", ansDO.Data);
      chartStatusCount = _renderStatusCount(chartStatusCount, "task-statuscount", ansDO.Data, {"valueField":"", "title":itl("@Task.Jobs")});
      chartAvg = _renderLineChart(chartAvg, "task-avg-chart", ansDO.Data, {"valueField":"ExecAvgMS", "title":itl("@System.ExecutionAverageTime")});
      chartMax = _renderLineChart(chartMax, "task-max-chart", ansDO.Data, {"valueField":"ExecMaxMS", "title":itl("@System.ExecutionMaximumTime")});

      $("#stat-box-counter-total .stat-box-value").text(getSmoothQuantity(ansDO.Data.CounterTotalCount));
      $("#stat-box-counter-succedeed .stat-box-value").text(__formatCountPerc(ansDO.Data.CounterTotalCount, ansDO.Data.CounterSucceededCount, ansDO.Data.CounterSucceededPerc));
      $("#stat-box-counter-warning .stat-box-value").text(__formatCountPerc(ansDO.Data.CounterTotalCount, ansDO.Data.CounterWarningCount, ansDO.Data.CounterWarningPerc));
      $("#stat-box-counter-failed .stat-box-value").text(__formatCountPerc(ansDO.Data.CounterTotalCount, ansDO.Data.CounterFailedCount, ansDO.Data.CounterFailedPerc));

      chartCounterPie = _renderCounterPie(chartCounterPie, "task-counterpie", ansDO.Data);
      chartCounterCount = _renderCounterCount(chartCounterCount, "task-countercount", ansDO.Data, {"valueField":"", "title":itl("@Task.StatsProcessedItems")});
    });
    
    function __formatCountPerc(total, count, perc) {
      return getSmoothQuantity(count) + ((total == 0) ? "" : " (" + perc + "%)")
    }
  }
  
  function _labelFunction(valueText, serialDataItem, categoryAxis) {
    switch (_getAggregateType()) {
    case AggregateType_Job: return formatDate(valueText) + " " + formatTime(valueText);
    case AggregateType_Day: 
    case AggregateType_Week: return formatDate(valueText);
    case AggregateType_Month: return formatDate(valueText, 206);
    }
    return valueText;
  }
  
  function _balloonStatusFunction(item) {
    var $template = $("#task-stats-templates .task-stats-status-balloon").clone();
    $template.find(".balloon-period").text(_labelFunction(item.Period));
    $template.find(".balloon-exec-count").text(item.ExecCount);
    $template.find(".balloon-exec-min").text(getSmoothTime(item.ExecMinMS));
    $template.find(".balloon-exec-avg").text(getSmoothTime(item.ExecAvgMS));
    $template.find(".balloon-exec-max").text(getSmoothTime(item.ExecMaxMS));
    return $template.html();
  }
  
  function _balloonCounterFunction(item) {
    var $template = $("#task-stats-templates .task-stats-counter-balloon").clone();
    $template.find(".balloon-period").text(_labelFunction(item.Period));
    $template.find(".balloon-succeeded").text(item.SucceededCount);
    $template.find(".balloon-warning").text(item.WarningCount);
    $template.find(".balloon-failed").text(item.FailedCount);
    return $template.html();
  }
  
  function _updateDataProvider(chartObj, dataProvider) {
    chartObj.dataProvider = dataProvider;
    chartObj.validateData();
    return chartObj;
  }

  function _renderPie(chart, divName, dataProvider) {
    if (chart != null) 
      return _updateDataProvider(chart, dataProvider);
    else {
      return AmCharts.makeChart(divName, createChartPie({
        "dataProvider": dataProvider,
        "valueField": "value",
        "titleField": "desc",
        "colorField": "color",
        "labelsEnabled": false
      }));
    }
  }

  function _renderStatusPie(chart, divName, data) {
    return _renderPie(chart, divName, [
      {"desc":itl("@Common.Completed"), "color":"var(--base-green-color)", "value":data.StatusSucceededCount},
      {"desc":itl("@Common.Aborted"),   "color":"var(--base-red-color)",   "value":data.StatusFailedCount}
    ]);
  }

  function _renderCounterPie(chart, divName, data) {
    return _renderPie(chart, divName, [
      {"desc":itl("@Task.JobSuccedeed"), "color":"var(--base-green-color)",  "value":data.CounterSucceededCount},
      {"desc":itl("@Task.JobWarning"),   "color":"var(--base-orange-color)", "value":data.CounterWarningCount},
      {"desc":itl("@Task.JobFailed"),    "color":"var(--base-red-color)",    "value":data.CounterFailedCount}
    ]);
  }

  function _renderStatusCount(chart, divName, data) {
    var dataProvider = data.StatStatusList;
    if (chart != null) 
      return _updateDataProvider(chart, dataProvider);
    else {
      return AmCharts.makeChart(divName, createChartSerial({
        "dataProvider": dataProvider,
        "valueAxes": [
          createChartValueAxisLine({
            "title": itl("@Stats.Count")
          })
        ],
        "graphs": [
          createChartGraphBar({
            "valueField": "SucceededCount",
            "lineColor": "var(--base-green-color)",
            "title": itl("@Task.JobSuccedeed"),
            "balloonFunction": item => _balloonStatusFunction(item.dataContext)
          }),
          createChartGraphBar({
            "valueField": "FailedCount",
            "lineColor": "var(--base-red-color)",
            "title": itl("@Task.JobFailed"),
            "balloonFunction": item => _balloonStatusFunction(item.dataContext)
          })
        ],
        "categoryField": "Period",
        "categoryAxis": createChartCategoryAxisBar({
          "parseDates": true,
          "categoryFunction": (category, dataItem, categoryAxis) => xmlToDate(dataItem.Period)
        })
      }));
    }
  }
  
  function _renderCounterCount(chart, divName, data) {
    var dataProvider = data.StatCounterList;
    if (chart != null)
      return _updateDataProvider(chart, dataProvider);
    else {
      return AmCharts.makeChart(divName, createChartSerial({
        "dataProvider": dataProvider,
        "valueAxes": [
          createChartValueAxisLine({
            "title": itl("@Task.StatsProcessedItems")
          })
        ],
        "graphs": [
          createChartGraphBar({
            "valueField": "SucceededCount",
            "lineColor": "var(--base-green-color)",
            "title": itl("@Task.JobSuccedeed"),
            "balloonFunction": item => _balloonCounterFunction(item.dataContext)
          }),
          createChartGraphBar({
            "valueField": "WarningCount",
            "lineColor": "var(--base-orange-color)",
            "title": itl("@Task.JobWarning"),
            "balloonFunction": item => _balloonCounterFunction(item.dataContext)
          }),
          createChartGraphBar({
            "valueField": "FailedCount",
            "lineColor": "var(--base-red-color)",
            "title": itl("@Task.JobFailed"),
            "balloonFunction": item => _balloonCounterFunction(item.dataContext)
          })
        ],
        "categoryField": "Period",
        "categoryAxis": createChartCategoryAxisBar({
          "parseDates": true,
          "categoryFunction": (category, dataItem, categoryAxis) => xmlToDate(dataItem.Period)
        })
      }));
    }
  }
  
  function _renderLineChart(chart, divName, data, settings) {
    var dataProvider = data.StatStatusList;

    if (chart != null) 
      return _updateDataProvider(chart, dataProvider);
    else {
      return AmCharts.makeChart(divName, createChartSerial({
        "dataProvider": dataProvider,
        "categoryField": "Period",
        "marginTop": 10,
        "titles": [{"text":settings.title}],
        "valueAxes": [
          createChartValueAxisLine({
            "title": itl("@Common.Time"), 
            "labelFunction": getSmoothTime
          })
        ],
        "graphs": [
          createChartGraphLine({
            "valueField": settings.valueField,
            "balloonFunction": item => _balloonStatusFunction(item.dataContext)
          })
        ],
        "categoryAxis": createChartCategoryAxisLine({
          "parseDates": true,
          "categoryFunction": (category, dataItem, categoryAxis) => xmlToDate(dataItem.Period)
        })
      }));
    }
  }
});
</script>