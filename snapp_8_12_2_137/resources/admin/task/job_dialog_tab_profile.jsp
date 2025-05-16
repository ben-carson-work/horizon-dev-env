<%@page import="com.vgs.snapp.dataobject.transaction.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.web.servlet.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.snapp.dataobject.task.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.servlet.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="job" class="com.vgs.snapp.dataobject.task.DOJob" scope="request"/>

<jsp:include page="/resources/common/amchart-include.jsp"><jsp:param name="amchart-graphs" value="serial,pie"/></jsp:include>

<v:tab-content attributes="<%=TagAttributeBuilder.builder().put(\"data-jobstatus\", job.JobStatus.getInt())%>">
  <v:alert-box type="warning" id="job-warning-failed" include="<%=!job.Checked.getBoolean()%>">
    <div style="margin-bottom:10px"><v:itl key="@Task.JobFailedCheckLogs"/></div>
    <v:button id="btn-job-checked" caption="@Task.MarkAsChecked" fa="check"/>
  </v:alert-box>
  
  <v:alert-box type="warning" include="<%=!job.JobWarnings.isEmpty()%>">
    <% if (JvArray.size(job.JobWarnings.getArray()) == 1) { %>
      <%=JvString.htmlEncode(job.JobWarnings.getArray()[0])%>
    <% } else { %>
      <ul>
      <% for (String warning : job.JobWarnings.getArray()) { %>
        <li><%=JvString.htmlEncode(warning)%></li>
      <% } %>
      </ul>
    <% } %>
  </v:alert-box>
  
  <v:widget>  
    <v:widget-block>
      <v:recap-item caption="@Common.DateTime"><snp:datetime timestamp="<%=job.StartDateTime%>" format="shortdatetime" timezone="local"/></v:recap-item>
      <v:recap-item caption="@Common.Server"><v:label field="<%=job.ServerName%>"/></v:recap-item>
      <v:recap-item caption="@Task.DatabaseProcess"><v:label field="<%=job.DatabaseProcess%>"/></v:recap-item>
    </v:widget-block>

    <v:widget-block include="<%=!job.TransactionList.isEmpty()%>">
      <v:recap-item caption="@Common.Transaction">
        <% for (DOTransactionSmallRef trn : job.TransactionList) { %>
          <div><snp:entity-link entityId="<%=trn.TransactionId%>" entityType="<%=LkSNEntityType.Transaction%>"><v:label field="<%=trn.TransactionCode%>"/></snp:entity-link></div>
        <% } %>
      </v:recap-item>
    </v:widget-block>
  </v:widget>

  <v:stat-section title="@Common.Statistics">
    <table class="stats-table">
      <tr>
        <td width="25%">
          <v:stat-box title="@Common.Status">
            <v:stat-box-value value="<%=job.JobStatus.getHtmlLookupDesc(pageBase.getLang())%>" color="<%=LkCommonStatus.findColorHex(job.CommonStatus.getLkValue())%>"/>
          </v:stat-box>
        </td>
        <td width="25%">
          <v:stat-box title="@Common.Duration">
            <v:stat-box-value value="<%=job.SmoothDuration.getHtmlString()%>" color="var(--base-blue-color)"/>
          </v:stat-box>
        </td>
        <td width="25%">
          <v:stat-box title="@Common.Items">
            <v:stat-box-value value="<%=job.ItemCount.getString()%>" color="var(--base-blue-color)"/>
          </v:stat-box>
        </td>
        <td width="25%" rowspan="2"><div id="job-statuspie" style="width:100%; height:190px;"></td>
      </tr>
      <tr>
        <td><v:stat-box title="@Task.JobSuccedeed"><v:stat-box-value value="<%=job.SucceededCount.getString()%>" color="var(--base-green-color)"/></v:stat-box></td>
        <td><v:stat-box title="@Task.JobWarning"><v:stat-box-value value="<%=job.WarningCount.getString()%>" color="var(--base-orange-color)"/></v:stat-box></td>
        <td><v:stat-box title="@Task.JobFailed"><v:stat-box-value value="<%=job.FailedCount.getString()%>" color="var(--base-red-color)"/></v:stat-box></td>
      </tr>
    </table>
  </v:stat-section>
  
  <% if (!job.JobJSP.isNull()) { %>
    <jsp:include page="<%=job.JobJSP.getString()%>"></jsp:include>
  <% } %>

</v:tab-content>


<script>
$(document).ready(function() {
  var $dlg = $("#job_dialog"); 
  var $tabContent = $dlg.find(".tab-content");

  _init();
  
  if ($tabContent.attr("data-jobstatus") == <%=LkSNJobStatus.InProgress.getCode()%>)
    setTimeout(_refresh, 5000);
  
  function _init() {
    var $btnChecked = $dlg.find("#btn-job-checked");
    var $warnBox = $dlg.find("#job-warning-failed");
    $btnChecked.click(function() {
      snpAPI.cmd("Task", "MarkJobChecked", {"JobIDs":<%=job.JobId.getJsString()%>}).then(() => $warnBox.remove());
    });
    
    AmCharts.makeChart("job-statuspie", createChartPie({
      "valueField": "value",
      "titleField": "desc",
      "colorField": "color",
      "labelsEnabled": false,
      "startDuration": 0,
      "dataProvider": [
        {desc: itl("@Task.JobSuccedeed"), color: 'var(--base-green-color)',  value: <%=job.SucceededCount.getInt()%>},
        {desc: itl("@Task.JobWarning"),   color: 'var(--base-orange-color)', value: <%=job.WarningCount.getInt()%>},
        {desc: itl("@Task.JobFailed"),    color: 'var(--base-red-color)',    value: <%=job.FailedCount.getInt()%>}
      ]
    }));
  }
  
  function _refresh() {
    var $selector = $("<div/>");
    var jobId = <%=job.JobId.getJsString()%>;
    var urlo = "admin?page=widget&jsp=task/job_dialog&id=" + jobId;
    asyncLoad($selector, urlo, function() {
      $tabContent.html($selector.find(".tab-content").html());
      _init();
      if ($tabContent.attr("data-jobstatus") == <%=LkSNJobStatus.InProgress.getCode()%>)
        setTimeout(_refresh, 5000);
    });
  }
});
</script>
