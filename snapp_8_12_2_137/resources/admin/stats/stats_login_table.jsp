<%@page import="com.vgs.web.library.BLBO_Stats"%>
<%@page import="com.vgs.snapp.web.bko.dataobject.DOLoginStats"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<style>
#stats-table {border-spacing:0}
#stats-table td {padding:2px 5px 2px 5px}
.wkstype-label, .pool-label {text-align:center}
.wkstype-label {font-weight: bold; min-width: 100px}
.pool-label {color: #999999}
.time-label, .min-label {text-align: center; min-width: 50px}
.time-label {font-weight: bold}
.min-label {color: #999999}
.value-cell {font-weight:bold;text-align:center}
.value-cell.soft-cell {font-weight:normal;color: #999999}
.brdtop {border-top:1px #999999 solid}
.brdright {border-right:1px #999999 solid}
.brdright-soft {border-right:1px #dfdfdf solid}
</style>

<%
  JvDateTime dateFrom = JvDateTime.createByXML(pageBase.getNullParameter("DateFrom"));
%>
<%
  JvDateTime dateTo = JvDateTime.createByXML(pageBase.getNullParameter("DateTo"));
%>

<% DOLoginStats stats = pageBase.getBL(BLBO_Stats.class).getLoginStats(dateFrom, dateTo); %>
<script>console.log(<%=stats.getJSONString()%>);</script>
<table id="stats-table">
  <% DOLoginStats.DOLSTimeSlot dummyTS = stats.TimeSlotList.getItem(0); %>
  <tr>
    <td class="brdright"></td>
    <% for (DOLoginStats.DOLSWorkstationType wksTypeDO : dummyTS.WorkstationTypeList.getItems()) { %>
      <td class="wkstype-label brdright" colspan=<%=wksTypeDO.SessionPoolList.getSize()%>><%=wksTypeDO.WorkstationType.getLkValue().getHtmlDescription(pageBase.getLang())%></td>
    <% } %>
  </tr>
  <tr>
    <td class="brdright"></td>
    <% for (DOLoginStats.DOLSWorkstationType wksTypeDO : dummyTS.WorkstationTypeList.getItems()) { %>
      <% for (int i=0; i<wksTypeDO.SessionPoolList.getSize(); i++) { %>
        <% DOLoginStats.DOLSSessionPool poolDO = wksTypeDO.SessionPoolList.getItem(i); %>
        <% String brdright = (i+1 == wksTypeDO.SessionPoolList.getSize()) ? "brdright" : "brdright-soft"; %>
        <td class="pool-label <%=brdright%>"><%=poolDO.SessionPoolName.getHtmlString()%></td>
      <% } %>
    <% } %>
  </tr>
  <% for (DOLoginStats.DOLSTimeSlot timeSlotDO : stats.TimeSlotList.getItems()) { %>
    <tr>
    <%
      int mm = timeSlotDO.DateTime.getDateTime().getMin();
    %>
    <%
      String brdtop = (mm == 0) ? "brdtop" : "";
    %>
    <%
      if (mm == 0) {
    %>
      <td class="time-label brdright <%=brdtop%>"><%=pageBase.format(timeSlotDO.DateTime.getDateTime(), pageBase.getShortTimeFormat())%></td>
    <% } else { %>
      <td class="min-label brdright <%=brdtop%>"><%=mm%></td>
    <% } %>
    <% for (DOLoginStats.DOLSWorkstationType wksTypeDO : timeSlotDO.WorkstationTypeList.getItems()) { %>
      <% for (int i=0; i<wksTypeDO.SessionPoolList.getSize(); i++) { %>
        <% DOLoginStats.DOLSSessionPool poolDO = wksTypeDO.SessionPoolList.getItem(i); %>
        <% String brdright = (i+1 == wksTypeDO.SessionPoolList.getSize()) ? "brdright" : "brdright-soft"; %>
        <% String softcell = (poolDO.Quantity.getInt() == 0) ? "soft-cell" : ""; %>
        <td class="value-cell <%=softcell%> <%=brdright%> <%=brdtop%>"><%=poolDO.Quantity.getHtmlString()%></td>
      <% } %>
    <% } %>
    </tr>
  <% } %>
</table>
