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
<script src="<v:config key="site_url"/>/libraries/amcharts/gauge.js"></script>


<style>

.mem-bar {
  height: 6px;
  background-color: #cccccc;
}

.mem-legend {
  display: inline-block;
  text-align: left;
  width: 70px;
}

.mem-bullet {
  display: inline-block;
  width: 8px;
  height: 8px;
  margin-right: 3px;
  background: yellow;
}

.mem-used {
  background-color: red;
}

.mem-free {
  background-color: limegreen;
}

.mem-max {
  background-color: #cccccc;
}

.v-progress-split {
  float: left;
  height: 100%;
}

#thread-list {
  max-height: 200px;
  overflow: auto;
}

.thread-row-template {
  overflow: hidden;
}

.thread-name {
  display: display-block;
  float: left;
  width: 500px;
}

.thread-perc {
  display: display-block;
  float: left;
  width: 50px;
  text-align: right;
  font-weight: bold;
  margin-right: 10px;
}

</style>

<div class="tab-toolbar">
  <v:button id="btn-start" caption="@Common.Start" fa="play-circle"/>
  <v:button id="btn-stop" caption="@Common.Stop" fa="stop-circle"/>
  <v:button caption="Garbage Collect" fa="trash" href="javascript:dbGarbageCollect()"/>
</div>

<div class="tab-content" style="overflow:hidden">
  <div class="profile-pic-div">
    <jsp:include page="server_grid_widget.jsp"/>
  </div>

  <div class="profile-cont-div">
    <div id="block-error">
      Connection error
    </div>
    
    <div id="block-result">
      <v:widget id="cpu-usage" caption="CPU">
        <v:widget-block>
          <div class="row">
            <div class="col-lg-3">
              <div id="cpugauge" style="width:100%;height:200px"></div>
            </div>
            <div class="col-lg-9">
              <div id="thread-list"></div>
            </div>
          </div>
        </v:widget-block>
      </v:widget>

      <div class="row">
        <div class="col-lg-6"><v:widget id="heap-usage" clazz="mem-widget" caption="Heap Usage"> </v:widget></div>
        <div class="col-lg-6"><v:widget id="heap-peak" clazz="mem-widget" caption="Heap Peak"> </v:widget></div>
      </div>
      <div class="row">
        <div class="col-lg-6"><v:widget id="nohp-usage" clazz="mem-widget" caption="Non-Heap Usage"> </v:widget></div>
        <div class="col-lg-6"><v:widget id="nohp-peak" clazz="mem-widget" caption="Non-Heap Peak"> </v:widget></div>
      </div>
    </div>
    
    <div id="templates" class="hidden">
      <div class="thread-row-template">
        <div class="thread-perc"></div>
        <div class="thread-name"></div>
      </div>
    </div>
  </div>
</div>

<script>

$(document).ready(function() {
  var started = true;
  var mb = 1024*1024;
  
  var gaugeChart = AmCharts.makeChart("cpugauge", {
    "type": "gauge",
    "theme": "light",
    "axes": [ {
      "axisThickness": 1,
      "axisAlpha": 0.2,
      "tickAlpha": 0.2,
      "valueInterval": 10,
      "bands": [ {
        "color": "#4acf3f",
        "startValue": 0,
        "endValue": 50,
        "innerRadius": "85%"
      }, {
        "color": "#fcdb30",
        "startValue": 50,
        "endValue": 80,
        "innerRadius": "85%"
      }, {
        "color": "#ff0000",
        "startValue": 80,
        "endValue": 100,
        "innerRadius": "85%"
      } ],
      "bottomText": "0 %",
      "bottomTextYOffset": -20,
      "endValue": 100
    } ],
    "arrows": [ {} ]
  } );

  
  function formatBytes(bytes) {
    return "<b>" + Math.round(bytes/mb) + "mb</b>";
  }

  function renderMemBar(cont, name, used, committed, max) {
    var div = $("<div style='margin:5px 0 5px 0'></div>").appendTo(cont);
    var leg = $("<div></div>").appendTo(div);
    var bar = $("<div class='mem-bar'></div>").appendTo(div);
    
    var perc_used = (used / max) * 100;
    var perc_free = ((committed - used) / max) * 100;
    
    $("<div class='v-progress-split mem-used' style='width:" + perc_used + "%'></div>").appendTo(bar);
    $("<div class='v-progress-split mem-free' style='width:" + perc_free + "%'></div>").appendTo(bar);
    
    leg.html(
        "<span title='Used' class='mem-legend'><span class='mem-bullet mem-used'></span>" + formatBytes(used) + "</span>&nbsp;&nbsp;&nbsp;" + 
        "<span title='Committed' class='mem-legend'><span class='mem-bullet mem-free'></span>" + formatBytes(committed) + "</span>&nbsp;&nbsp;&nbsp;" + 
        "<span title='Max' class='mem-legend'><span class='mem-bullet mem-max'></span>" + formatBytes(max) + "</span>" +
        "<span style='float:right'><b>" + name + "</b></span>");
  }

  function renderMemUsage(cont, heap, detail, mem) {
    cont = $(cont).find(".widget-content");
    $(cont).empty();
    divDetail = $("<div class='widget-block detail-block'></div>").appendTo(cont);
    divTotal = $("<div class='widget-block total-block'></div>").appendTo(cont);
    
    var totUsed = 0;
    var totCommitted = 0;
    var totMax = 0;

    for (var i=0; i<mem.MemoryPoolList.length; i++) {
      var pool = mem.MemoryPoolList[i];
      
      var usage = pool.Usage;
      if (detail == "peak")
        usage = pool.Peak;

      if ((pool.Heap == heap)) {
        renderMemBar(divDetail, pool.Name, usage.Used, usage.Committed, usage.Max);
        
        totUsed += usage.Used;
        totCommitted += usage.Committed;
        totMax += usage.Max;
      }
    }

    renderMemBar(divTotal, "Total", totUsed, totCommitted, totMax);
  }

  function renderMem(mem) {
    renderMemUsage("#heap-usage", true, "usage", mem);
    renderMemUsage("#heap-peak", true, "peak", mem);
    
    renderMemUsage("#nohp-usage", false, "usage", mem);
    renderMemUsage("#nohp-peak", false, "peak", mem);
  }
  
  function refreshMem() {
    $("#btn-start").setClass("hidden", started);
    $("#btn-stop").setClass("hidden", !started);
    if (started) {
      var serverId = $("#server-grid tr.selected").attr("data-serverid");
      vgsService("Service", {Command:"MemStatus", ForwardToServerId:serverId}, true, function(ansDO) {
        var good = (ansDO.Answer) && (ansDO.Answer.MemStatus);
        $("#block-error").setClass("hidden", good);
        $("#block-result").setClass("hidden", !good);
        if (good) 
          renderMem(ansDO.Answer.MemStatus);
        setTimeout(refreshMem, 1000);
      });
    }
  }

  function renderCpu(cpu) {
    var value = Math.round(cpu.CpuUsage);
    if ((gaugeChart) && (gaugeChart.arrows) && (gaugeChart.arrows[0]) && (gaugeChart.arrows[0].setValue)) {
      gaugeChart.arrows[0].setValue(cpu.CpuUsage);
      gaugeChart.axes[0].setBottomText(value + " %");
    }
    
    var $list = $("#thread-list");
    $list.empty();
    if (cpu.CpuThreadStatusList) {
      for (var i=0; i<cpu.CpuThreadStatusList.length; i++) {
        var thread = cpu.CpuThreadStatusList[i];
        var $row = $("#templates .thread-row-template").clone().appendTo($list);
        $row.find(".thread-name").text(thread.ThreadName);
        $row.find(".thread-perc").text(Math.round(thread.CpuUsage) + " %");
      }
    }
  }
  
  function refreshCpu() {
    $("#btn-start").setClass("hidden", started);
    $("#btn-stop").setClass("hidden", !started);
    if (started) {
      var serverId = $("#server-grid tr.selected").attr("data-serverid");
      vgsService("Service", {Command:"CpuStatus", ForwardToServerId:serverId}, true, function(ansDO) {
        var good = (ansDO.Answer) && (ansDO.Answer.CpuStatus);
        $("#block-error").setClass("hidden", good);
        $("#block-result").setClass("hidden", !good);
        if (good) 
          renderCpu(ansDO.Answer.CpuStatus);
        setTimeout(refreshCpu, 1000);
      });
    }
  }

  $("#btn-start").click(function() {
    started = true;
    refreshMem();
    refreshCpu();
  });

  $("#btn-stop").click(function() {
    started = false;
    refreshMem();
    refreshCpu();
  });

  function dbGarbageCollect() {
    showWaitGlass();
    vgsService("SERVICE", {Command: "GarbageCollect"}, false, function() {
      refreshMem();
      hideWaitGlass();
    });
  }
  
  refreshMem();
  refreshCpu();
  $("#adminbody").on("remove", function () {
    started = false;
  });

});

</script>
