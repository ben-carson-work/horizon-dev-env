<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.service.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTooltip" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<style>
  
  #perf-filter-tooltip .perf-filter-label {
    margin-top: 20px;
    margin-bottom: 5px;
    text-align: center;
  }
  
  #perf-filter-min-quantity {
    margin-left: 10px;
    margin-right: 10px;
  }
  
  #cal-perf-filter .ui-datepicker {
    box-shadow: none;
    border-width: 0;
    border-right-width: 1px;
  }
  
  #perf-filter-min-quantity {
    font-weight: bold;
    min-width: 25px;
    display: inline-block;
  }
  
  #perf-filter-tooltip .toolbar-block {
    text-align: center;
  }
  
  #perf-filter-tooltip .toolbar-block .v-button {
    margin-left: 5px;
    font-size: 1em;
  }
</style>

<div id="perf-filter-tooltip">
  <table style="width:100%">
    <tr>
      <td><div id="cal-perf-filter"></div></td>
      <td align="center" style="padding:20px">
        <div class="perf-filter-label" style="margin-top:0"><v:itl key="@Common.MinimumQuantity"/></div>
        <div class="v-button icon-button" onclick="editPerfFilterQuantity(-1)"><i class="fa fa-minus"></i></div>
        <div id="perf-filter-min-quantity" data-Quantity="0">0</div>
        <div class="v-button icon-button" onclick="editPerfFilterQuantity(+1)"><i class="fa fa-plus"></i></div>
        <div>
          <div class="perf-filter-label"><v:itl key="@Common.FromTime"/></div>
          <v:input-text type="timepicker" field="PerfFilter-TimeFrom"/>
        </div>
        <div>
          <div class="perf-filter-label"><v:itl key="@Common.ToTime"/></div>
          <v:input-text type="timepicker" field="PerfFilter-TimeTo"/>
        </div>
      </td>
    </tr>
  </table>
  <div class="toolbar-block">
    <div id="btn-perf-filter-apply" class="v-button float-right hl-green"><v:itl key="@Common.Apply"/></div>
    <div id="btn-perf-filter-close" class="v-button float-right hl-red"><v:itl key="@Common.Close"/></div>
  </div>
</div>

<script>
$(document).ready(function() {
  var txt = $("#txt-perf-filter");
  var opts = {};

  var dateFrom = txt.attr("data-DateFrom");
  if ((dateFrom) && (dateFrom != ""))
    opts.defaultDate = xmlToDate(dateFrom);
  
  editPerfFilterQuantity(strToIntDef(txt.attr("data-MinQuantity"), 0));
  timeToComponent(txt.attr("data-TimeFrom"), "#PerfFilter-TimeFrom");
  timeToComponent(txt.attr("data-TimeTo"), "#PerfFilter-TimeTo");
  
  $("#cal-perf-filter").datepicker(opts);
});

function timeToComponent(time, comp) {
  if ((time) && (time.length >= 5)) {
    var arr = time.split(":");
    if (arr.length >= 2) {
      $(comp + "-HH").val(arr[0]);
      $(comp + "-MM").val(arr[1]);
    }
  }
}

function encodeTime(comp) {
  var hh = $(comp + "-HH").val();
  var mm = $(comp + "-MM").val();
  if (strToIntDef(hh, -1) < 0)
    return "";
  else {
    hh = (strToIntDef(hh, -1) < 0) ? "00" : hh; 
    mm = (strToIntDef(mm, -1) < 0) ? "00" : mm; 
    
    return hh + ":" + mm;
  }
}

function editPerfFilterQuantity(delta) {
  var $elem = $("#perf-filter-min-quantity");
  var newval = parseInt($elem.attr("data-Quantity")) + delta;
  if (newval >= 0) {
    $elem.attr("data-Quantity", newval);
    $elem.text(newval);
  }
}

$("#btn-perf-filter-close").click(function() {
  $("#btn-perf-filter").popover("hide");
});

$("#btn-perf-filter-apply").click(function() {
  var txt = $("#txt-perf-filter");
  var dateFrom = $("#cal-perf-filter").datepicker("getDate");
  
  txt.attr("data-DateFrom", dateToXML(dateFrom).substr(0,10));
  txt.attr("data-TimeFrom", encodeTime("#PerfFilter-TimeFrom"));
  txt.attr("data-TimeTo", encodeTime("#PerfFilter-TimeTo"));
  txt.attr("data-MinQuantity", $("#perf-filter-min-quantity").attr("data-Quantity"));
  
  txt.val(formatDate(dateFrom, <%=rights.ShortDateFormat.getInt()%>));
  
  doSearchPerformances(true);
  
  $("#btn-perf-filter").popover("hide");
});
</script>
