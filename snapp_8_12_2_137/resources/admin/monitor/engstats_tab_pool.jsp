<%@page import="com.vgs.vcl.fontawesome.JvFA"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="javax.swing.plaf.*"%>
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
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<style>

#pool-container {
  display: flex;
  justify-content: space-between;
}

#pool-detail {
  min-width: 400px;
}

.db-pool {
  position: relative;
  display: inline-block;
  width: 300px;
  margin-right: 6px;
  margin-bottom: 6px;
  vertical-align: top;
  cursor: pointer;
}

.db-pool:hover {
  box-shadow: 0px 0px 5px 0px rgba(0,0,0,0.4);
}

.db-pool.selected {
  border: 5px solid var(--base-blue-color);
}

.db-pool .progress {
  margin: 0;
}

.db-pool .widget-checkmark {
  display: none;
  position: absolute;
  top: 0; 
  right: 0;
  font-size: 18px;
  line-height: 20px;
  padding: 5px 6px 10px 11px;
  background: var(--base-blue-color);
  color: white;
  border-bottom-left-radius: 4px;
}

.db-pool.selected .widget-checkmark {
  display: block;
}

.status-icon {
  font-size: 2em;
}

.status-icon-used {
  color: var(--base-red-color);
}

.status-icon-free {
  color: var(--base-green-color);
}

</style>

<v:tab-content>

  <v:profile-recap>
    <jsp:include page="server_grid_widget.jsp"/>
  </v:profile-recap>

  <v:profile-main>
    <v:widget caption="@Common.General">
      <v:widget-block>
        <div><a href="javascript:asyncDialogEasy('monitor/engstats_dataset_dialog')">Active datasets</a>: <span id="active-datasets"></span></div>
        <div>InvalidateAll: <span id="invalidate-all"></span></div>
      </v:widget-block>
    </v:widget>

    <div id="pool-container">
      <div id="database-status"></div>
      <div id="pool-detail">
        <v:grid>
          <thead>
            <v:grid-title caption="Pool details"/>
          </thead>
          <tbody></tbody>
        </v:grid>
      </div>
    </div>
		
		<div id="widget-template" class="v-hidden">
		  <v:widget clazz="db-pool" caption=" " icon="<%=JvFA.PENCIL%>">
        <div class="widget-checkmark"><i class="fa fa-check"></i></div>
		    <v:widget-block>
          <div class="progress">
            <div class="pbar-busy progress-bar progress-bar-snp-error"></div>
            <div class="pbar-free progress-bar progress-bar-snp-success"></div>
          </div>
        </v:widget-block>
        <v:widget-block>
		      <div class="pool-minmax">Min / Max <span class="recap-value"></span></div>
		      <div class="wait-timeout">Wait timeout <span class="recap-value"></span></div>
		      <div class="idle-timeout">Idle timeout <span class="recap-value"></span></div>
		    </v:widget-block>
		    <v:widget-block>
          <div class="pool-busy">Busy <span class="recap-value"></span></div>
          <div class="pool-free">Free <span class="recap-value"></span></div> 
          <div class="queue-length">Queue <span class="recap-value"></span></div>
        </v:widget-block>
        <v:widget-block>
		      <div class="maxqueue-length">Max queue  <span class="recap-value"></span></div>
		      <div class="maxqueue-change">Max queue change <span class="recap-value"></span></div>
		      <div class="timeout-count">Timed out <span class="recap-value"></span></div>
		    </v:widget-block>
		  </v:widget>
		</div>
  </v:profile-main>


<script>


$(document).ready(function() {
  var started = true;
  
  function formatXmlDateTime(xmlDateTime) {
    if (xmlDateTime) {
      var dateTime = xmlToDate(xmlDateTime)
      return formatDate(dateTime) + " " + formatTime(dateTime);
    }
    return "";
  }

  function render(dbStatus) {
    var selIndex = Math.max(0, $("#database-status .db-pool.selected").index());
    
    var divCont = $("<div/>");
    for (var i=0; i<dbStatus.PoolList.length; i++) {
      var pool = dbStatus.PoolList[i];
      var divWidget = $("#widget-template .db-pool").clone().appendTo(divCont);
      divWidget.find(".widget-title-caption").html(pool.PoolName);
      divWidget.find(".pool-minmax .recap-value").html(pool.PoolMin + " / " + pool.PoolMax);
      divWidget.find(".pool-busy .recap-value").html(pool.PoolBusy);
      divWidget.find(".pool-free .recap-value").html(pool.PoolFree);
      divWidget.find(".wait-timeout .recap-value").html(pool.WaitTimeout);
      divWidget.find(".idle-timeout .recap-value").html(pool.IdleTimeout);
      divWidget.find(".queue-length .recap-value").html(pool.QueueLength);
      divWidget.find(".timeout-count .recap-value").html(pool.TimeoutCount);
      divWidget.find(".maxqueue-length .recap-value").html(pool.MaxQueueLength);
      divWidget.find(".maxqueue-change .recap-value").html("<i class='fa fa-user-circle'></i> " + formatXmlDateTime(pool.MaxQueueChange));
      
      divWidget.find(".pbar-busy").css("width", (pool.PoolBusy * 100 / pool.PoolMax) + "%");
      divWidget.find(".pbar-free").css("width", (pool.PoolFree * 100 / pool.PoolMax) + "%");

      var icon = "pencil";
      var iconTitle = "Read/Write pool"
      if (pool.ReadOnly) {
        icon = "eye";
        iconTitle = "Read-Only pool"
      }
      divWidget.find(".widget-title-icon").attr("title", iconTitle).html("<i class='fa fa-" + icon + "'></i>");
      
      if (i == selIndex) {
        divWidget.addClass("selected");
        var body = $("#pool-detail tbody").empty();
        for (var k=0; k<pool.ConnectionList.length; k++) {
          var conn = pool.ConnectionList[k];
          var tr = $("<tr class='grid-row'/>").appendTo(body);
          tr.append("<td><i class='fa fa-circle status-icon " + (conn.Used ? "status-icon-used" : "status-icon-free") + "'></i></td>");
          
          var threadName = (conn.ThreadName || "");
          if (conn.Used) 
            threadName = "<a href='javascript:showThreadStackTrace(" + conn.ThreadId + ")'>" + threadName + "</a>";
          
          var tdName = $("<td width='70%'/>").appendTo(tr);
          tdName.append(k + " - " + threadName);
          tdName.append("<br/><span class='list-subtitle'>never used</span>");
          if (conn.RequestDateTime) 
            tdName.find(".list-subtitle").addClass("tz-datetime").html("<i class='fa fa-user-circle'></i> " + formatXmlDateTime(conn.RequestDateTime));
          
          var tdTime = $("<td width='30%' align='right' nowrap/>").appendTo(tr);
          tdTime.append("<div><i class='fa fa-database list-subtitle' style='font-size:0.8em'></i> " + conn.DatabaseProcess + "</div>");
          tdTime.append("<div class='list-subtitle'>" + ((conn.ElapsedSmooth) ? conn.ElapsedSmooth : "&nbsp;") + "</div>");
        }
      }
      
      divWidget.click(function() {
        divCont.find(".db-pool.selected").removeClass("selected");
        $(this).addClass("selected");
      });
    }
    
    $("#database-status").empty();
    $("#database-status").append(divCont);
  }
  
  function calcInvalidateAllText(lastInvalidateAll, invalidateAllCount) {
    var result = "never invalidated";
    if (lastInvalidateAll) { 
      result = 
        "Last InvalidateAll " + formatDate(lastInvalidateAll) + " " + formatTime(lastInvalidateAll) + 
        " - " + invalidateAllCount + " occurrencies on the same day."; 
    }
    
    return result;
  }

  function refresh() {
    if (started) {
      var serverId = $("#server-grid tr.selected").attr("data-serverid");
      vgsService("Service", {Command:"DatabaseStatus", ForwardToServerId:serverId}, true, function(ansDO) {
        if ((ansDO.Answer) && (ansDO.Answer.DatabaseStatus)) {
          $("#pool-detail").removeClass("hidden");
          $("#active-datasets").html(ansDO.Answer.DatabaseStatus.ActiveDataSets);
          $("#invalidate-all").text(calcInvalidateAllText(ansDO.Answer.DatabaseStatus.LastInvalidateAll, ansDO.Answer.DatabaseStatus.InvalidateAllCount));
          render(ansDO.Answer.DatabaseStatus.PoolStatus);
        }
        else {
          $("#database-status").html("Connection error");
          $("#pool-detail").addClass("hidden");
        }
        
        setTimeout(refresh, 1000);
      });
    }
  }
  
  refresh();
  $("#adminbody").on("remove", function () {
    started = false;
  });

});

function showThreadStackTrace(threadId) {
  var reqDO = {
    Command: "GetThreadStackTrace",
    ForwardToServerId: $("#server-grid tr.selected").attr("data-serverid"),
    GetThreadStackTrace: {
      ThreadId: threadId
    }
  };
  
  showWaitGlass();
  vgsService("Service", reqDO, false, function(ansDO) {
    hideWaitGlass();
    
    var trace = "";
    if ((ansDO) && (ansDO.Answer) && (ansDO.Answer.GetThreadStackTrace))
      trace = ansDO.Answer.GetThreadStackTrace.StackTrace;
    
    var $dlg = $("<div/>");
    $("<pre/>").appendTo($dlg).text(trace);
    $dlg.dialog({
      title: "Stack Trace",
      width: 800,
      height: 600,
      modal: true,
      close: function() {
        dlg.remove();
      }
    });
  });
}

</script>

</v:tab-content>