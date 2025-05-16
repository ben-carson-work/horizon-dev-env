<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_AsyncProcessLog.class);
// Select
qdef.addSelect(
  QryBO_AsyncProcessLog.Sel.AsyncProcessLogId,
  QryBO_AsyncProcessLog.Sel.LogDateTime,
  QryBO_AsyncProcessLog.Sel.LogType,
  QryBO_AsyncProcessLog.Sel.LogRecap,
  QryBO_AsyncProcessLog.Sel.LogText,
  QryBO_AsyncProcessLog.Sel.BackgroundColor);
// Where
qdef.addFilter(QryBO_AsyncProcessLog.Fil.AsyncProcessId, pageBase.getParameter("AsyncProcessId"));
// Paging
if (!pageBase.isParameter("paging", "false")) {
  qdef.pagePos = pageBase.getQP();
  qdef.recordPerPage = QueryDef.recordPerPageDefault;
}
// Sort
qdef.addSort(QryBO_AsyncProcessLog.Sel.LogDateTime, false);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" clazz="asyncproc-log-grid-table">
  <tr class="header">
    <td width="15%" nowrap>
      <v:itl key="@Common.DateTime"/><br/>
      <v:itl key="@Common.Type"/>
    </td>
    <td width="75%">
      <v:itl key="@Common.Text"/>
    </td>
  </tr>
  <v:grid-row dataset="ds" dateGroupFieldName="<%=QryBO_AsyncProcessLog.Sel.LogDateTime.name()%>">
    <%
    LookupItem logType = LkSN.AsyncProcessLogType.getItemByCode(ds.getField(QryBO_AsyncProcessLog.Sel.LogType));
    %>
    <td style="border-left:4px <%=ds.getField(QryBO_AsyncProcessLog.Sel.BackgroundColor).getHtmlString()%> solid" nowrap>
      <% boolean logText = ds.getField(QryBO_AsyncProcessLog.Sel.LogText).getNullString() != null;%>
      <% if (logText) { %>
      <a class="list-title" href="javascript:showLogDialog('<%=ds.getField(QryBO_AsyncProcessLog.Sel.AsyncProcessLogId).getHtmlString()%>')">
      <% } %>
        <span class="list-title" title="<snp:datetime timestamp="<%=ds.getField(QryBO_AsyncProcessLog.Sel.LogDateTime)%>" format="shortdatetime" timezone="local" clazz="list-title" textOnly="true"/>:<%=JvString.leadZero(ds.getField(QryBO_AsyncProcessLog.Sel.LogDateTime).getDateTime().getSec(), 2)%> .<%=JvString.leadZero(ds.getField(QryBO_AsyncProcessLog.Sel.LogDateTime).getDateTime().getMSec(), 3)%>">
          <snp:datetime timestamp="<%=ds.getField(QryBO_AsyncProcessLog.Sel.LogDateTime)%>" format="shortdatetime" timezone="local" clazz="list-title"/>
        </span>
      <% if (logText) { %>
      </a>
      <% } %>
      <br/>
      <span class="list-subtitle">
        <%=logType.getHtmlDescription(pageBase.getLang())%>
      </span>
    </td>
    <td style="word-wrap:break-word">
      <span class="list-subtitle"><%=ds.getField(QryBO_AsyncProcessLog.Sel.LogRecap).getHtmlString()%></span>
    </td>
  </v:grid-row>
</v:grid>

<script>
function showLogDialog(AsyncProcessLogId) {
  asyncDialogEasy('task/asyncproc_log_data_dialog', 'AsyncProcessLogId=' + AsyncProcessLogId);
}
</script>
