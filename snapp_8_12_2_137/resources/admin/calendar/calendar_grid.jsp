<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Calendar.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_Calendar.class)
    .setPaging(pageBase.getQP(), QueryDef.recordPerPageDefault)
    .addFilter(Fil.CalendarType, LkSNCalendarType.SnApp.getCode())
    .addSelect(
        Sel.IconName,
        Sel.CommonStatus,
        Sel.CalendarId,
        Sel.CalendarCode,
        Sel.CalendarName);

//Filter
if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(Fil.FullText, pageBase.getNullParameter("FullText"));
if (pageBase.getNullParameter("FromDate") != null)
  qdef.addFilter(Fil.FromDate, pageBase.getNullParameter("FromDate"));
if (pageBase.getNullParameter("ToDate") != null)
  qdef.addFilter(Fil.ToDate, pageBase.getNullParameter("ToDate"));
if (pageBase.getNullParameter("Enabled") != null)
  qdef.addFilter(Fil.Enabled, JvArray.stringToArray(pageBase.getNullParameter("Enabled"), ","));
if ((pageBase.getNullParameter("CategoryId") != null) && !pageBase.isParameter("CategoryId", "all"))
  qdef.addFilter(Fil.CategoryId, pageBase.getNullParameter("CategoryId"));
// Sort
qdef.addSort(Sel.CalendarName);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid id="calendar-grid-table" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Calendar%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="100%">
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.Code"/>
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="CalendarId" dataset="ds" fieldname="CalendarId"/></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.CalendarId).getString()%>" entityType="<%=LkSNEntityType.Calendar%>" clazz="list-title"><%=ds.getField(Sel.CalendarName).getHtmlString()%></snp:entity-link><br/>
      <span class="list-subtitle"><%=ds.getField(Sel.CalendarCode).getHtmlString()%></span>
    </td>
  </v:grid-row>
</v:grid>
