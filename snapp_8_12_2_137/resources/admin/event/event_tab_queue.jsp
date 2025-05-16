<%@page import="com.vgs.snapp.library.SnappUtils"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageEvent" scope="request"/>
<jsp:useBean id="event" class="com.vgs.snapp.dataobject.DOEvent" scope="request"/>

<div class="tab-content">

<%
  JvDateTime dtNext = null;
%>

<h1><%=JvString.escapeHtml(pageBase.getFiscalDate().format(pageBase.getShortDateFormat()))%></h1>
<v:grid style="width:300px; float:left">
  <thead>
    <tr>
      <td>Slot</td>
      <td align="right">Sold</td>
      <td align="right">Used</td>
    </tr>
  </thead>
  <tbody>
  <%
    JvDateTime dtStart = event.ActiveTimeFrom.isNull() ? JvDateTime.encodeTime(8, 0, 0, 0) : event.ActiveTimeFrom.getDateTime().getTimePart();
      JvDateTime dtEnd = event.ActiveTimeTo.isNull() ? JvDateTime.encodeTime(20, 0, 0, 0) : event.ActiveTimeTo.getDateTime().getTimePart();
      JvDateTime dtLoop = dtStart.clone();
      dtNext = dtStart.clone();
      int step = (event.QueueSlotFrequency.getInt() == 0) ? 15 : event.QueueSlotFrequency.getInt();
      while (dtLoop.isBefore(dtEnd)) {
  %>
    <tr class="grid-row">
      <td><%=JvString.escapeHtml(dtLoop.format(pageBase.getShortTimeFormat()))%></td>
      <td align="right">0</td>
      <td align="right">0</td>
    </tr>
  </tbody>
  <%
    JvDateTime dtNow = JvDateTime.now().getTimePart();
      if (dtLoop.isBeforeOrEquals(dtNow) && dtLoop.addMins(step).isAfterOrEquals(dtNow))
    dtNext = dtLoop.clone();
      dtLoop = dtLoop.addMins(step); 
    }
  %>
</v:grid>

<v:widget caption="Total" style="margin-left:310px; width:300px; font-size:16px">
  <v:widget-block>
    <table class="form-table">
      <tr>
        <th>Sold:</th>
        <td align="right"><b>0</b></td>
      </tr>
      <tr>
        <th>Used:</th>
        <td align="right"><b>0</b></td>
      </tr>
      <tr>
        <th>Next Slot:</th>
        <td align="right"><b><%=JvString.escapeHtml(dtNext.format(pageBase.getShortTimeFormat()))%></b></td>
      </tr>
    </table>
  </v:widget-block>
</v:widget>

</div>