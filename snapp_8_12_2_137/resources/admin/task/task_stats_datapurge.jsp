<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.nio.charset.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="job" class="com.vgs.snapp.dataobject.task.DOJob" scope="request"/>

<%
byte[] docData = pageBase.getBL(BLBO_Repository.class).getData(job.JobId.getString(), "job-stats.json");
String jobStatsJSON = ((docData == null) || (docData.length == 0)) ? "{}" : new String(docData, StandardCharsets.UTF_8);
%>

<v:grid id="datapurge-stats-grid">
  <thead>
    <tr>
      <td>Worker</td>
      <td>Processed item count</td>
      <td align="right">Duration</td>
    </tr>
  </thead>
  <tbody>
  </tbody>
</v:grid>

<div id="datapurge-stats-templates" class="hidden">
  <table>
    <tr class="grid-row worker-row">
      <td class="worker-name"></td>
      <td class="worker-count"></td>
      <td class="worker-duration" align="right"></td>
    </tr>
  </table>
</div>

<script>
$(document).ready(function() {
  var data = <%=jobStatsJSON%>;
  for (const item of (data.WorkerList || [])) {
    var $tr = $("#datapurge-stats-templates .worker-row").clone().appendTo("#datapurge-stats-grid tbody");
    $tr.attr("data-status", _calcRowStatus(item.CommonStatus));
    $tr.find(".worker-name").text(item.WorkerName);
    $tr.find(".worker-count").text(item.ItemCount);
    $tr.find(".worker-duration").text(getSmoothTime(item.DurationMS));
  }
  
  function _calcRowStatus(status) {
    if (status == 10)
      return "draft";
    
    if (status == 20)
      return "active";
    
    if (status == 30)
      return "warning";
    
    if (status == 40)
      return "error";
    
    if (status == 50)
      return "completed";
    
    if (status == 60)
      return "fatal";
    
    return "";
  }
});
</script>