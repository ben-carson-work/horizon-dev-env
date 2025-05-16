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
      <td width="33.33%"><v:stat-box id="stat-analyzed-tickets" title="Analyzed products"><v:stat-box-value value="0" color="var(--base-blue-color)"/></v:stat-box></td>
      <td width="33.33%"><v:stat-box id="stat-archivable-tickets" title="Archivable products"><v:stat-box-value value="0" color="var(--base-green-color)"/></v:stat-box></td>
      <td width="33.33%"><v:stat-box id="stat-warning-tickets" title="Non archivable products"><v:stat-box-value value="0" color="var(--base-orange-color)"/></v:stat-box></td>
    </tr>
    <tr>
      <td colspan="3"><v:stat-box id="stat-archivable-sales" title="Archivable orders"><v:stat-box-value value="0" color="var(--base-green-color)"/></v:stat-box></td>
    </tr>
  </table>
</v:stat-section>

<script>
$(document).ready(function() {
  var doc = <%=jobStatsJSON%>;
  _setValue("#stat-analyzed-tickets", doc.AnalyzedTicketCount);
  _setValue("#stat-archivable-tickets", doc.ArchivableTicketCount);
  _setValue("#stat-warning-tickets", doc.WarningTicketCount);
  
  var sales = doc.ArchivableSaleCount || 0;
  var saleTickets = doc.ArchivableSaleTicketCount || 0;
  if (saleTickets > 0)
    sales += " (" + saleTickets + " " + itl("@Ticket.Tickets").toLowerCase() + ")";
  _setValue("#stat-archivable-sales", sales);
    
  
  function _setValue(id, value) {
    $("#archive-job-stats " + id + " .stat-box-value").text(value || "0");
  }
});
</script>