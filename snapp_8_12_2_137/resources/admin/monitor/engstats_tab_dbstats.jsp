<%@page import="com.vgs.snapp.dataobject.*"%>
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

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageEngineStats" scope="request"/>

<script src="<v:config key="site_url"/>/libraries/amcharts/amcharts.js"></script>
<script src="<v:config key="site_url"/>/libraries/amcharts/serial.js"></script>
<script src="<v:config key="site_url"/>/libraries/amcharts/plugins/export/export.min.js"></script>
<link rel="stylesheet" href="<v:config key="site_url"/>/libraries/amcharts/plugins/export/export.css" type="text/css" media="all" />
<script src="<v:config key="site_url"/>/libraries/amcharts/themes/light.js"></script>

<div class="tab-toolbar">
  <v:button caption="Most used queries" fa="info-circle" onclick="asyncDialogEasy('monitor/engstats_dialog_query', 'type=cnt')"/>
  <v:button caption="Highest average" fa="arrow-alt-circle-up" onclick="asyncDialogEasy('monitor/engstats_dialog_query', 'type=avg')"/>
  <v:button caption="Highest peaks" fa="arrow-alt-circle-up" onclick="asyncDialogEasy('monitor/engstats_dialog_query', 'type=max')"/>
</div>

<%
String compabilityMode = pageBase.getDB().getString(
    "select" + JvString.CRLF +
    "  (case compatibility_level" + JvString.CRLF +  
    "  when 100 then '100 (2008)'" + JvString.CRLF +
    "  when 110 then '110 (2012)'" + JvString.CRLF +
    "  when 120 then '120 (2014)'" + JvString.CRLF +
    "  else Cast(compatibility_level as varchar(max))" + JvString.CRLF +
    "  end)" + JvString.CRLF +
    "from sys.databases WHERE name=DB_NAME()");

DecimalFormat fmt = new DecimalFormat("#,##0");
int totTable = 0;
long maxRecord = 0;
long dbSize = 0;
String sqlTables =
    "select" + JvString.CRLF +
    "  t.OBJECT_ID as ObjectId," + JvString.CRLF +  
    "  t.NAME as TableName," + JvString.CRLF +
    "  Max(p.rows) as RowCounts," + JvString.CRLF +
    "  Sum(a.total_pages) * 8*1024 AS TotalSpace," + JvString.CRLF +
    "  Sum(a.used_pages) * 8*1024 AS UsedSpace," + JvString.CRLF +
    "  (case Max(p.rows) when 0 then 0 else Round((Sum(a.used_pages) * 8*1024) / Max(p.rows), 0) end) AS SpacePerRec," + JvString.CRLF +
    "  (Sum(a.total_pages) - Sum(a.used_pages)) * 8*1024 as UnusedSpace" + JvString.CRLF +
    "from" + JvString.CRLF +
    "  sys.tables t inner join" + JvString.CRLF +
    "  sys.indexes i on t.OBJECT_ID=i.object_id inner join" + JvString.CRLF +
    "  sys.partitions p on i.object_id=p.OBJECT_ID and i.index_id=p.index_id inner join" + JvString.CRLF +
    "  sys.allocation_units a on p.partition_id = a.container_id" + JvString.CRLF +
    "group by" + JvString.CRLF +
    "  t.OBJECT_ID, t.Name" + JvString.CRLF +
    "order by" + JvString.CRLF +
    "  Sum(a.total_pages) desc";


try (JvDataSet ds = pageBase.getDB().executeQuery(sqlTables)) {
  while (!ds.isEof()) {
    totTable++;
    dbSize += ds.getField("UsedSpace").getLong();
    maxRecord = Math.max(maxRecord, ds.getField("RowCounts").getLong());
    
    ds.next();
  }
}

%>

<jsp:include page="../stats/stats_all_css.jsp" />
<style>

.table-total {
  font-weight: bold; 
  background-color: #cecece;
}

</style>

<div class="tab-content">

<v:last-error/>

<v:widget caption="Recap">
  <v:widget-block>
    <%=JvString.escapeHtml(pageBase.getDB().getString("select @@VERSION"))%>
  </v:widget-block>
  <v:widget-block>
    Compability Mode: <%=JvString.escapeHtml(compabilityMode)%>
  </v:widget-block>
</v:widget>

<div class="container-fluid">
  <div class="row">
    <div class="col-lg-3 col-md-3">
      <v:stat-box title="Version"><v:stat-box-value value="<%=DODB.getVersion()%>"/></v:stat-box>
    </div>
    <div class="col-lg-3 col-md-3">
      <v:stat-box title="Size"><v:stat-box-value value="<%=JvString.getSmoothSize(dbSize)%>"/></v:stat-box>
    </div>
    <div class="col-lg-3 col-md-3">
      <v:stat-box title="Tables"><v:stat-box-value value="<%=String.valueOf(totTable)%>"/></v:stat-box>
    </div>
    <div class="col-lg-3 col-md-3">
      <v:stat-box title="Max records per table"><v:stat-box-value value="<%=fmt.format(maxRecord)%>"/></v:stat-box>
    </div>
  </div>
</div>

<jsp:include page="chart_database_widget.jsp">
  <jsp:param name="chart-height" value="200px"/>
</jsp:include>

</div>