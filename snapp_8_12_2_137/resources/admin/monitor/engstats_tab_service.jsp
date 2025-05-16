<%@page import="com.vgs.web.service.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageEngineStats" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<style>
.common-status {
  display: inline-block;
  width: 20px;
  height: 20px;
  border-radius: 4px;
}

td.service-name {
  border-left: 4px solid var(--base-gray-color);
}

.service-status-hint-inner .error-message {
  font-family: monospace;
  white-space: pre;
  color: var(--base-red-color);
  margin-top: 10px;
}

.tab-content:not(.loading) .loading-spinner {
  display: none;
}

.tab-content:not(.offline) .offline-block,
.tab-content.offline #service-grid {
  display: none;
}
</style>

<div class="tab-toolbar">
</div>

<div class="tab-content">
  <div class="offline-block errorbox">Offline&nbsp;<i class="loading-spinner fa fa-circle-notch fa-spin"></i></div>

  <v:grid id="service-grid">
    <thead id="service-grid-header">
      <tr>
        <td><v:itl key="@Common.Name"/>&nbsp;<i class="loading-spinner fa fa-circle-notch fa-spin"></i></td>
      </tr>
    </thead>
    <tbody id="service-grid-data">
      <% for (SrvBOBase service : BOServiceManager.getServices()) { %>
        <% String sOptional = service.isOptional() ? "@Common.Optional" : "@Common.Mandatory"; %>
        <tr class="grid-row" data-serviceid="<%=service.getServiceId()%>" data-optional="<%=service.isOptional()%>">
          <td class="service-name">
            <div class="list-title"><span class="v-tooltip" data-content="<%=JvString.escapeHtml(service.getDescription())%>"><%=JvString.escapeHtml(service.getName())%></span></div> 
            <div class="list-subtitle"><v:itl key="<%=sOptional%>"/></div>
          </td>
        </tr>
      <% } %>
    </tbody>
  </v:grid>
</div>

<div id="service-templates" class="hidden">
  <v:grid>
    <tr>
      <td class="col-header-template v-tooltip" align="center"></td>
      <td class="col-data-template" align="center"></td>
    </tr>
  </v:grid>
  
  <div class="common-status v-tooltip">&nbsp;</div>
  
  <div class="service-status-hint">
    <div class="service-status-hint-inner">
      <div>Status: <span class="status-desc" style="font-weight:bold"></span></div>
      <div class="error-message"></div>
    </div>
  </div>
</div>


<script>
$(document).ready(function() {
  const COMMONSTATUS_DRAFT     = <%=LkCommonStatus.Draft.getCode()%>;
  const COMMONSTATUS_ACTIVE    = <%=LkCommonStatus.Active.getCode()%>;
  const COMMONSTATUS_WARN      = <%=LkCommonStatus.Warn.getCode()%>;
  const COMMONSTATUS_DELETED   = <%=LkCommonStatus.Deleted.getCode()%>;
  const COMMONSTATUS_COMPLETED = <%=LkCommonStatus.Completed.getCode()%>;
  const COMMONSTATUS_FATAL     = <%=LkCommonStatus.FatalError.getCode()%>;
  
  const COMMONSTATUS_COLORS = {};
  COMMONSTATUS_COLORS[COMMONSTATUS_DRAFT]     = "--base-gray-color";
  COMMONSTATUS_COLORS[COMMONSTATUS_ACTIVE]    = "--base-green-color";
  COMMONSTATUS_COLORS[COMMONSTATUS_WARN]      = "--base-orange-color";
  COMMONSTATUS_COLORS[COMMONSTATUS_DELETED]   = "--base-red-color";
  COMMONSTATUS_COLORS[COMMONSTATUS_COMPLETED] = "--base-blue-color";
  COMMONSTATUS_COLORS[COMMONSTATUS_FATAL]     = "--base-purple-color";
  
  _doServerStatus();
  
  function _doServerStatus() {
    var reqDO = {
      Command: "ServerStatus"
    };
    
    $(".tab-content").addClass("loading");
    vgsService("Service", reqDO, true, function(ans) {
      $(".tab-content").removeClass("loading");
      try {
        var errorMsg = getVgsServiceError(ans);
        $(".tab-content").setClass("offline", (errorMsg != null));
        
        if (errorMsg != null) 
          throw errorMsg;
        else {
          var ansDO = ((ans || {}).Answer || {}).ServerStatus || {};
          var list = ansDO.ServerList || [];
          _renderServerList(list);
        }
      }
      finally {
        setTimeout(_doServerStatus, 1000);
      }
    });
  }
  
  function _renderServerList(serverList) {
    for (var i=0; i<serverList.length; i++) {
      var server = serverList[i];
      if (server.CommonStatus != COMMONSTATUS_DRAFT) {
        var $tdHeader = $("#service-grid-header td[data-serverid='" + server.ServerId + "']");

        if ($tdHeader.length == 0) {
          $tdHeader = $("#service-templates .col-header-template").clone().appendTo("#service-grid-header tr");
          $tdHeader.attr("data-serverid", server.ServerId);
          
          var $tdData = $("#service-templates .col-data-template").clone().appendTo("#service-grid-data tr");
          $tdData.attr("data-serverid", server.ServerId);
        }

        $tdHeader.text(server.ServerId);
        $tdHeader.attr("data-content", "[" + server.ServerCode + "] " + server.ServerName);
        
        $("#service-grid-data .col-data-template[data-serverid='" + server.ServerId + "']").empty();
        var statusList = server.ServiceStatusList || [];
        for (var k=0; k<statusList.length; k++) {
          var status = statusList[k];
          var $tdData = $("#service-grid-data tr[data-serviceid='" + status.ServiceId + "'] td[data-serverid='" + server.ServerId + "']");
          
          var $hint = $("#service-templates .service-status-hint").clone();
          $hint.find(".status-desc").text(status.ServiceStatusDesc);
          if (status.ErrorMessage) {
            var sDateTime = formatDate(status.ErrorMessageDateTime) + " " + formatTime(status.ErrorMessageDateTime);
            $hint.find(".error-message").text(sDateTime + "\n----------------------------------------------------------------------\n" + status.ErrorMessage);
          }

          var $div = $("#service-templates .common-status").clone().appendTo($tdData);
          $div.attr("data-commonstatus", status.CommonStatus);
          $div.attr("data-content", $hint.html());
          $div.css("background-color", "var(" + COMMONSTATUS_COLORS[status.CommonStatus] + ")");
        }
      }
      
      $("#service-grid-data tr").each(function(index,item) {
        var $tr = $(item);
        var optional = ($tr.attr("data-optional") == "true");
        var commonStatus = COMMONSTATUS_ACTIVE;
        if ($tr.find("[data-commonstatus='" + COMMONSTATUS_ACTIVE + "']").length == 0) 
          commonStatus = COMMONSTATUS_DELETED;
        else if (!optional && ($tr.find(".common-status").not("[data-commonstatus='" + COMMONSTATUS_ACTIVE + "']").length > 0))
          commonStatus = COMMONSTATUS_WARN;
        
        $tr.find("td.service-name").css("border-left-color", "var(" + COMMONSTATUS_COLORS[commonStatus] + ")");
      });
    }
  }
});

</script>