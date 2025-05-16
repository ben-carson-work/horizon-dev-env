<%@page import="java.nio.charset.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="job" class="com.vgs.snapp.dataobject.task.DOJob" scope="request"/>

<%
byte[] docData = pageBase.getBL(BLBO_Repository.class).getData(job.JobId.getString(), "job-stats.json");
String jobStatsJSON = ((docData == null) || (docData.length == 0)) ? "{}" : new String(docData, StandardCharsets.UTF_8);
%>

<v:stat-section id="archive-job-stats" title="@Common.Archiving">
  <table class="stats-table">
    <tr> 
      <td width="25%"><v:stat-box id="stat-archived-sales" title="@Common.Sales"><v:stat-box-value value="0" color="var(--base-green-color)"/></v:stat-box></td>
      <td width="25%"><v:stat-box id="stat-archived-transactions" title="@Common.Transactions"><v:stat-box-value value="0" color="var(--base-green-color)"/></v:stat-box></td>
      <td width="25%"><v:stat-box id="stat-archived-tickets" title="@Ticket.Tickets"><v:stat-box-value value="0" color="var(--base-green-color)"/></v:stat-box></td>
      <td width="25%"><v:stat-box id="stat-archived-medias" title="@Common.Medias"><v:stat-box-value value="0" color="var(--base-green-color)"/></v:stat-box></td>
    </tr>
    <tr> 
      <td colspan="100%"><div id="stat-throughput-chart" style="width:100%; height:200px; background:white; border-radius:4px; border:1px solid var(--border-color)"></div></td>
    </tr>
  </table>
</v:stat-section>

<script>
$(document).ready(function() {
  var doc = <%=jobStatsJSON%> || {};
  
  _setValue("#stat-archived-sales", formatAmount(doc.ArchivedSaleCount, 0));
  _setValue("#stat-archived-transactions", formatAmount(doc.ArchivedTransactionCount, 0));
  _setValue("#stat-archived-tickets", formatAmount(doc.ArchivedTicketCount, 0));
  _setValue("#stat-archived-medias", formatAmount(doc.ArchivedMediaCount, 0));

  doc.ThroughputList = doc.ThroughputList || [];
  var currentThroughput = (doc.ThroughputList.length <= 0) ? null : doc.ThroughputList[doc.ThroughputList.length - 1]; 
  var sCurrentThroughput = (currentThroughput == null) ? "na" : formatAmount(currentThroughput.ThroughputHour, 0);
  _setValue("#stat-current-throughput", sCurrentThroughput);
  
  function _setValue(id, value) {
    $("#archive-job-stats " + id + " .stat-box-value").text(value || "0");
  }
  
  AmCharts.makeChart("stat-throughput-chart", createChartSerial({
    "dataProvider": doc.ThroughputList,
    "categoryField": "TimeSlot",
    "marginTop": 10,
    "titles": [{"text":"Throughput (current: " + sCurrentThroughput + "/hour)"}], 
    "valueAxes": [
      createChartValueAxisLine({
        "title": "Throughput/hour"
      })
    ],
    "graphs": [
      createChartGraphLine({
        "valueField": "ThroughputHour",
        "balloonFunction": item => _balloonFunction(item.dataContext)
      })
    ],
    "categoryAxis": createChartCategoryAxisLine({
      "parseDates": true,
      "minPeriod": "5mm", 
      "categoryFunction": (category, dataItem, categoryAxis) => convertDateTimeToSelectedTimezone(xmlToDate(dataItem.TimeSlot))
    })
  }));
  
  function _balloonFunction(item) {
    var dt = convertDateTimeToSelectedTimezone(xmlToDate(item.TimeSlot));
    var result = 
        formatDate(dt) + " " + formatTime(dt) + "<br/>" +
        "<b>" + formatAmount(item.ThroughputHour, 0) + "/hour</b>";
    return result;
  }
});
</script>