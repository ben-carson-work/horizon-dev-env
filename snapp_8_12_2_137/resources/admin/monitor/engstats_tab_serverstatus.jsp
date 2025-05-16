<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageEngineStats" scope="request"/>

<script src="<v:config key="site_url"/>/libraries/amcharts/amcharts.js"></script>
<script src="<v:config key="site_url"/>/libraries/amcharts/gauge.js"></script>

<style>

.server-pane-list {
  display: flex;
}

.server-pane {
  padding: 10px;
}

.property-label {
  display: flex;
  justify-content: space-between;
  font-weight: bold;
}

.progress {
  min-width: 200px;
  margin-bottom: 10px;
}

.gauge {
  width: 140px;
  height: 120px; 
}

.gauge-container .property-label {
}

.gauge-container .property-label-value {
  text-align: right;
}

</style>

<div class="tab-toolbar">
  <v:button id="btn-start" caption="@Common.Start" fa="play-circle" clazz="hidden"/>
  <v:button id="btn-stop" caption="@Common.Stop" fa="stop-circle" clazz="hidden"/>
</div>

<div class="tab-content">
  <div id="block-error" class="hidden">
    Connection error
  </div>
  
  <div id="block-result" class="hidden">
  </div>

  <div id="templates" class="hidden">
    <v:widget clazz="server-template" caption="">
      <v:widget-block>
        <div class="server-pane-list">
          <div class="server-pane">
            <div class="property-container" data-type="gauge" data-serverparamkey="<%=LkSNServerParamKey.CPU.getCode()%>"></div>
          </div>
          <div class="server-pane"> 
            <div class="property-container" data-type="bar" data-serverparamkey="<%=LkSNServerParamKey.RAM.getCode()%>"></div> 
            <div class="property-container" data-type="bar" data-serverparamkey="<%=LkSNServerParamKey.DISK.getCode()%>"></div>
            <div class="property-container" data-type="bar" data-serverparamkey="<%=LkSNServerParamKey.API.getCode()%>"></div>
          </div>
          <div class="server-pane">
            <div class="property-container-barlist" data-serverparamkey="<%=LkSNServerParamKey.DBPool.getCode()%>"></div>
          </div>
<%-- 
          <div class="server-pane">
            <div class="property-container-barlist" data-serverparamkey="<%=LkSNServerParamKey.QueueManager.getCode()%>"></div>
          </div>
--%>
        </div>
      </v:widget-block>
    </v:widget>
    
    <div class="gauge-property-content">
      <div class="property-label"><div class="property-label-title"></div><div class="property-label-value"></div></div>
      <div class="gauge"></div>
    </div>
    
    <div class="bar-property-content">
      <div class="property-label"><div class="property-label-title"></div><div class="property-label-value"></div></div>
      <div class="progress"><div class="progress-bar"></div></div>
    </div>
  </div>
</div>

<script>
var serverChart = null;
$(document).ready(function() {
  var started = true;
  
  $("#block-result").on("remove", function () {
    started = false;
  });
  
  function refresh() {
    $("#btn-start").setClass("hidden", started);
    $("#btn-stop").setClass("hidden", !started);
    if (started) {
      var reqDO = {
        Command: "ServerStatus",
        ServerStatus: {
        }
      };
      vgsService("Service", reqDO, true, function(ansDO) {
        if (started) {
          var good = (ansDO.Answer) && (ansDO.Answer.ServerStatus);
          $("#block-error").setClass("hidden", good);
          $("#block-result").setClass("hidden", !good);
          if (good) 
            render(ansDO.Answer.ServerStatus.ServerList);
          setTimeout(refresh, 1000);
        }
      });
    }
  }
  
  function render(servers) {
    var $all_servers = $("#block-result .server-template").addClass("to-be-removed");
    for (var i=0; i<servers.length; i++) {
      var server = servers[i];
      var $server = $all_servers.filter("[data-serverid='" + server.ServerId + "']");
      if ($server.length > 0)
        $server.removeClass("to-be-removed");
      else {
        $server = $("#templates .server-template").clone().appendTo("#block-result");
        $server.attr("data-serverid", server.ServerId);
        $server.find(".widget-title-caption").text(server.ServerId + " - " + server.ServerName);
        
        $server.find(".property-container[data-type='gauge']").each(function(index, elem) {
          var $gaugeContent = $("#templates .gauge-property-content").clone().appendTo(elem);
          initGauge($gaugeContent.find(".gauge")[0]);
        });
        
        $server.find(".property-container[data-type='bar']").each(function(index, elem) {
          $("#templates .bar-property-content").clone().appendTo(elem);
        });
      }
      
      $server.find(".property-container-barlist").each(function(index, elem) {
        var $elem = $(elem);
        var serverParamKey = parseInt($elem.attr("data-serverparamkey"));
        $elem.empty();
        if (server.CurrentPropertyList) {
          for (var i=0; i<server.CurrentPropertyList.length; i++) {
            var property = server.CurrentPropertyList[i];
            if (property.ServerParamKey == serverParamKey) { 
              var $container = $("<div class='property-container' data-type='bar' data-serverparamkey='" + serverParamKey + "' data-serverparamsubkey='" + property.ServerParamSubKey + "'/>").appendTo($elem); 
              $("#templates .bar-property-content").clone().appendTo($container);
            }
          }
        }
      });
      
      $server.find(".property-container").each(function(index, elem) {
        var $elem = $(elem);
        var dataType = $elem.attr("data-type");
        var serverParamKey = parseInt($elem.attr("data-serverparamkey"));
        var serverParamSubKey = $elem.attr("data-serverparamsubkey");
        var property = findProperty(server.CurrentPropertyList, serverParamKey, serverParamSubKey);
        if (property != null) {
          if (dataType == "bar")
            renderBar($elem, property);
          else if (dataType == "gauge")
            renderGauge($elem, property);
          else
            console.log("Unhandled data-type=" + dataType);
        }
      });
    } 
    $all_servers.filter(".to-be-removed").remove();
  }
  
  function initGauge(elem) {
    var gaugeChart = AmCharts.makeChart(elem, {
      "type": "gauge",
      "theme": "light",
      "axes": [ {
        "axisThickness": 1,
        "axisAlpha": 0.2,
        "tickAlpha": 0.2,
        "valueInterval": 20,
        "bands": [ {
          "color": "#4acf3f",
          "startValue": 0,
          "endValue": 50,
          "innerRadius": "80%"
        }, {
          "color": "#fcdb30",
          "startValue": 50,
          "endValue": 80,
          "innerRadius": "80%"
        }, {
          "color": "#ff0000",
          "startValue": 80,
          "endValue": 100,
          "innerRadius": "80%"
        } ],
        "endValue": 100
      } ],
      "arrows": [ {} ]
    });
    
    $(elem).data("chart", gaugeChart);
  }
  
  function findProperty(propertyList, serverParamKey, serverParamSubKey) {
    if (propertyList) {
      for (var i=0; i<propertyList.length; i++) {
        var property = propertyList[i]; 
        if (property.ServerParamKey == serverParamKey) {
          if (!(serverParamSubKey) || (serverParamSubKey == property.ServerParamSubKey))
            return property;
        }
      }
    }
    return null;
  }
  
  function renderBar($property, property) {
    var avg = property.AvgValue;
    var max = property.MaxValue;
    var perc = 100 * (avg / max);
    var $bar = $property.find(".progress-bar");
    var vertical = $property.closest(".property-container.vertical").length > 0;
    $bar.css({
      "background": "var(--base-" + ((perc <= 50) ? "green" : (perc <= 80) ? "orange" : "red") + "-color)",
      "width": vertical ? "initial" : perc + "%",
      "height": vertical ? perc + "%" : "initial"
    });
     
    var title = ($property.closest(".property-container-barlist").length == 0) ? property.ServerParamKeyName : property.ServerParamSubKey;
    $property.find(".property-label-title").text(title);
    
    var value = avg;
    if (property.ValueType == <%=LkSNServerValueType.Queue.getCode()%>) 
      value = avg + " / " + max;      
    else if (property.ValueType == <%=LkSNServerValueType.Bytes.getCode()%>) 
      value = getSmoothSize(avg) + " / " + getSmoothSize(max);      
    else if (property.ValueType == <%=LkSNServerValueType.KiloBytes.getCode()%>) 
      value = getSmoothSize(avg * 1024) + " / " + getSmoothSize(max * 1024);      
    else if (property.ValueType == <%=LkSNServerValueType.MegaBytes.getCode()%>) 
      value = getSmoothSize(avg * 1024 * 1024) + " / " + getSmoothSize(max * 1024 * 1024);      
    $property.find(".property-label-value").text(value);
  }
  
  function renderGauge($property, property) {
    var gaugeChart = $property.find(".gauge").data("chart");
    if ((gaugeChart) && (gaugeChart.arrows) && (gaugeChart.arrows[0]) && (gaugeChart.arrows[0].setValue)) {
      gaugeChart.arrows[0].setValue(property.AvgValue); 
      $property.find(".property-label-title").text(property.ServerParamKeyName);
      $property.find(".property-label-value").text(property.AvgValue + " %");
    }
  }
  
  $("#btn-start").click(function() {
    started = true;
    refresh();
  });

  $("#btn-stop").click(function() {
    started = false;
    refresh();
  });
  
  refresh();
});


</script>
