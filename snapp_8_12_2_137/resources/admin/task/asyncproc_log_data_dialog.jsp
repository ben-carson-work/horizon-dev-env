<%@page import="com.vgs.cl.database.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Log.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
  QueryDef qdef = new QueryDef(QryBO_AsyncProcessLog.class);
// Select
qdef.addSelect(
  QryBO_AsyncProcessLog.Sel.AsyncProcessName,
  QryBO_AsyncProcessLog.Sel.LogDateTime,
  QryBO_AsyncProcessLog.Sel.LogText);
// Where
qdef.addFilter(QryBO_AsyncProcessLog.Fil.AsyncProcessLogId, pageBase.getParameter("AsyncProcessLogId"));
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

String title = ds.getField(QryBO_AsyncProcessLog.Sel.AsyncProcessName).getHtmlString() + " - " + pageBase.format(ds.getField(QryBO_AsyncProcessLog.Sel.LogDateTime).getDateTime(), pageBase.getShortDateTimeFormat(), true);
%>

<v:dialog id="async-log-data-dialog" title="<%=title%>" icon="<%=LkSNEntityType.Log.getIconName()%>" width="1024" height="768" autofocus="false">

<div>
  <v:widget icon="xml.png" caption="Text">
    <v:widget-block>
      <%=ds.getField(QryBO_AsyncProcessLog.Sel.LogText).getHtmlString()%>
    </v:widget-block>
  </v:widget>
</div>

</v:dialog>