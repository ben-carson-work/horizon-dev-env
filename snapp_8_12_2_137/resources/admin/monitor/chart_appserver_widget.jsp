<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageEngineStats" scope="request"/>

<%
String id = "widget_" + JvUtils.newSqlStrUUID();
%>

<style>
#<%=id%> .queue-chart {
  height: 200px;
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

#<%=id%> .col-pane-list {
  display: flex;
  justify-content: space-between;
  margin: -5px;
  flex-wrap: wrap;
} 

#<%=id%> .col-pane {
  flex-basis: 0;
  flex-grow: 1;
  margin: 5px; 
} 

#<%=id%> .col-pane.cpu-pane {
  flex-grow: 2;
}

#<%=id%> .col-pane.memory-pane {
  flex-grow: 3;
}

#<%=id%> .col-pane-title {
  text-align: center;
  font-weight: bold;
  border-bottom: 1px solid var(--border-color);
  padding-bottom: 5px; 
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden; 
} 

#<%=id%> .col-pane-avg,
#<%=id%> .col-pane-max {
  padding: 5px;
} 

#<%=id%> .col-pane .progress {
  margin: 0;
}

#<%=id%> .col-pane .bar-header {
  margin: 0;
  font-weight: bold;
  display: flex;
  justify-content: space-between;
}

#<%=id%> .col-pane .bar-header-left {
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
}

#<%=id%> .col-pane .bar-header-right {
  text-align: right;
}

</style>

<v:widget id="<%=id%>" clazz="stat-widget" caption="Application Servers">
  <v:widget-block clazz="block-error hidden">Connection error</v:widget-block>
  <v:widget-block clazz="block-result"> 
    <div class="col-pane-list">
    </div>

    <div id="templates" class="hidden">
      <div class="col-pane col-pane-template">
        <div class="col-pane-title"></div>
        <div class="col-pane-avg">
          <div class="bar-header"><div class="bar-header-left"></div><div class="bar-header-right"></div></div>
          <div class="progress"><div class="progress-bar"></div></div>
        </div>
        <div class="col-pane-max">
          <div class="bar-header"><div class="bar-header-left"></div><div class="bar-header-right"></div></div>
          <div class="progress"><div class="progress-bar"></div></div>
        </div>
      </div>
    </div>
  </v:widget-block>
</v:widget>

<script>

$(document).ready(function() {
  var $widget = $("#<%=id%>");
  $widget.on("remove", function() {
    $widget = null;
  });
  
  refresh();
  
  function refresh() {
    if ($widget != null) {
      var reqDO = {
        Command: "AppServerStatus",
        AppServerStatus: {
        }
      };
      
      $widget.addClass("loading");
      vgsService("Service", reqDO, true, function(ansDO) {
        var good = (ansDO.Answer) && (ansDO.Answer.AppServerStatus);
        $widget.removeClass("loading");
        $widget.find(".block-error").setClass("hidden", good);
        $widget.find(".block-result").setClass("hidden", !good);
        if (good) 
          render(ansDO.Answer.AppServerStatus);
        else
          console.error(ansDO);
        setTimeout(refresh, ENGSTATS_REFRESH_DELAY);
      });
    } 
  }

  function createPane(resource) {
    var caption = resource.ServerParamKeyDesc;
    if (resource.ServerParamKey == <%=LkSNServerParamKey.DBPool.getCode()%>)
      caption = "DB : " + resource.ServerParamSubKey; 
    
    var $pane = $widget.find("#templates .col-pane-template").clone().appendTo($widget.find(".col-pane-list"));
    $pane.find(".col-pane-title").text(caption);
    $pane.attr("data-serverparamkey", resource.ServerParamKey);
    $pane.attr("data-serverparamsubkey", resource.ServerParamSubKey);

    if (resource.ValueType == <%=LkSNServerValueType.MegaBytes.getCode()%>)
      $pane.css("min-width", "350px");
    
    return $pane;
  }

  function render(stats) {
    var $panes = $widget.find(".col-pane-list .col-pane");
    $panes.addClass("to-be-removed");
    if (stats.ResourceList) {
      for (var i=0; i<stats.ResourceList.length; i++) { 
        var resource = stats.ResourceList[i];
        var $pane = $panes.filter("[data-serverparamkey='" + resource.ServerParamKey + "'][data-serverparamsubkey='" + resource.ServerParamSubKey + "']");
        if ($pane.length != 0) 
          $pane.removeClass("to-be-removed");
        else 
          $pane = createPane(resource);
        
        renderBar($pane.find(".col-pane-avg"), resource.AvgValue, resource.AvgTotal, resource.ValueType, "Overall");
        renderBar($pane.find(".col-pane-max"), resource.MaxValue, resource.MaxTotal, resource.ValueType, resource.MaxServerName);
      }
    }
    $panes.filter(".to-be-removed").remove();
  }
  
  function renderBar($block, value, total, type, leftText) {
    var $bar = $block.find(".progress");
    var perc = 100 * value / total;
    var color = "var(--base-green-color)";
    if (perc > 50)
      color = "var(--base-orange-color)";
    else if (perc > 80)
      color = "var(--base-red-color)";
    
    $bar.find(".progress-bar").css({
      "width": perc + "%",
      "background": color
    });
    
    var text = "";
    if (type == <%=LkSNServerValueType.Percentage.getCode()%>)
      text = Math.round(perc) + "%";
    else if (type == <%=LkSNServerValueType.Queue.getCode()%>) 
      text = value + "/" + total;
    else if (type == <%=LkSNServerValueType.MegaBytes.getCode()%>) {
      var mb = 1024 * 1024;
      value = value * mb; 
      total = total * mb; 
      text = "Used: " + getSmoothSize(value) + /*" — Free: " + getSmoothSize(total - value) +*/ " — Total: " + getSmoothSize(total);
    }
    $block.find(".bar-header-right").text(text);
    $block.find(".bar-header-left").text(leftText);
  }

});
</script>
