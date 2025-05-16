<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_SeatSector.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
boolean canEdit = pageBase.isParameter("readonly", "false"); 
String performanceId = pageBase.getNullParameter("PerformanceId");
DOPerformanceSeatRecap perf = pageBase.getBL(BLBO_Performance.class).getPerformanceSeatRecap(performanceId);
%>

<style>
.seat-total-row td {
  background-color: #f2f2f2;
  border-bottom: 1px #dfdfdf solid;
  font-weight: bold;
}
.seat-sector-row td {
  background-color: #f9f9f9;
}
.prgbar-container {
  width: 100px;
  height: 6px;
  background-color: var(--base-gray-color);
}
.prgbar-inner {
  float: left;
  height: 6px;
}
.hold-detail-cell {
  padding: 0 0 0 64px  !important;
}
.hold-detail-cell .listcontainer {
  border-width: 0 0 0 1px;
  border-radius: 0;
}
.hold-detail-cell thead td {
  background: #dfdfdf !important;
  text-shadow: none !important;
  
}
.hold-detail-cell tr:last-child td {
  border-bottom: none;
}
.seat-quantity-cell {
  cursor: pointer;
  font-weight: bold;
}
.seat-quantity-cell:hover {
  background-color: #f9f9f9;
}
.seat-quantity-cell.selected {
  background-color: #dfdfdf;
}
</style>

<%!
private String encodeProgressBar(List<DOPerformanceSeatRecap.DOPerfCategory> list, int total) {
  String result = "";
  for (DOPerformanceSeatRecap.DOPerfCategory cat : list) { 
    String color = cat.SeatCategoryColor.isNull() ? "var(--base-green-color)" : cat.SeatCategoryColor.getHtmlString();
    float perc = 100.0f * cat.QuantityFree.getFloat() / (float)total;
    result += "<div class='prgbar-inner' style='background-color:" + color + ";width:" + perc + "%'></div>";
  } 
  return result;
}
%>

<style>
.btn-seatprf-refresh {
  opacity: 0.4;
  cursor: pointer;
  width: 20px;
  height: 20px;
  line-height: 20px;
  text-align: center;
}
.btn-seatprf-refresh:hover {
  opacity: 1;
} 
</style>

<v:grid>
  <tr class="header">
    <td><span class="btn-seatprf-refresh fa fa-lg fa-refresh" onclick="if (functionExists('doReloadSeatPerformanceWidget')) doReloadSeatPerformanceWidget()"></span></td>
    <td width="52%"><v:itl key="@Seat.Sector"/> / <v:itl key="@Seat.Category"/></td>
    <td></td>
    <td width="8%" align="right"></td>
    <td width="8%" align="right"><v:itl key="@Seat.Counter_Total"/></td>
    <td width="8%" align="right"><v:itl key="@Seat.Counter_Avail"/></td>
    <td width="8%" align="right"><v:itl key="@Seat.Counter_Held"/></td>
    <td width="8%" align="right"><v:itl key="@Seat.Counter_Reserved"/></td>
    <td width="8%" align="right"><v:itl key="@Seat.Counter_Paid"/></td>
  </tr>
  <% if (perf.SectorList.getSize() != 1) { %>
	  <tr class="seat-total-row">
	    <td colspan="2"><v:itl key="@Common.Total" transform="uppercase"/></td>
	    <td><div class="prgbar-container"><%=encodeProgressBar(perf.CategoryList.getItems(), perf.QuantityMax.getInt())%></div></td>
	    <td align="right"><%=Math.round(100f * perf.QuantityFree.getFloat() / perf.QuantityMax.getFloat())%>%</td>
	    <td align="right"><%=perf.QuantityMax.getInt()%></td>
	    <td align="right"><%=perf.QuantityFree.getInt()%></td>
	    <td align="right"><%=perf.QuantityHeld.getInt()%></td>
	    <td align="right"><%=perf.QuantityReserved.getInt()%></td>
	    <td align="right"><%=perf.QuantityPaid.getInt()%></td>
	  </tr>
	<% } %>
  <% for (DOPerformanceSeatRecap.DOPerfSector sector : perf.SectorList) { %>
	  <tr class="seat-sector-row">
	    <td style="padding-right:0"><img src="<v:image-link name="<%=sector.IconName.getString()%>" size="20"/>" width="20" height="20" style="float:left">
	    <td width="52%">
	      <%
	        if (canEdit && sector.SeatSectorType.isLookup(LkSNSeatSectorType.Capacity)) {
	      %>
	        <%
	          String hrefCapacityDialog = "javascript:asyncDialogEasy('seat/seat_capacity_dialog', 'id=" + sector.SeatSectorId.getHtmlString() + "&PerformanceId=" + performanceId + "')";
	        %>
	        <b><a href="<%=hrefCapacityDialog%>"><%=sector.SeatSectorName.getHtmlString()%></a></b>
        <%
          } else if (canEdit && sector.SeatSectorType.isLookup(LkSNSeatSectorType.Map)) {
        %>
          <% String hrefMapDialog = "javascript:asyncDialogEasy('seat/seat_map_dialog', 'id=" + sector.SeatMapId.getHtmlString() + "&PerformanceId=" + performanceId + "')"; %>
          <b><a href="<%=hrefMapDialog%>"><%=sector.SeatSectorName.getHtmlString()%></a></b>
	      <% } else { %>
	        <%=sector.SeatSectorName.getHtmlString()%>
	      <% } %>
	    </td>
	    <td><div class="prgbar-container"><%=encodeProgressBar(sector.CategoryList.getItems(), sector.QuantityMax.getInt())%></div></td>
	    <td align="right"><%=Math.round(100f * sector.QuantityFree.getFloat() / sector.QuantityMax.getFloat())%>%</td>
	    <td align="right"><%=sector.QuantityMax.getInt()%></td>
	    <td align="right"><%=sector.QuantityFree.getInt()%></td>
	    <td align="right"><%=sector.QuantityHeld.getInt()%></td>
	    <td align="right"><%=sector.QuantityReserved.getInt()%></td>
	    <td align="right"><%=sector.QuantityPaid.getInt()%></td>
	  </tr>
	    <% for (DOPerformanceSeatRecap.DOPerfCategory cat : sector.CategoryList) { %>
        <% if (cat.QuantityMax.getInt() > 0) { %>
  	    <tr class="seat-cat-row" data-SeatSectorId="<%=sector.SeatSectorId.getHtmlString()%>" data-SeatCategoryId="<%=cat.SeatCategoryId.getHtmlString()%>">
  	      <td></td>
  	      <td><%=cat.SeatCategoryName.getHtmlString()%></td>
  	      <td>
  	        <%
  	        ArrayList<DOPerformanceSeatRecap.DOPerfCategory> list = new ArrayList<DOPerformanceSeatRecap.DOPerfCategory>();
  	        list.add(cat);
  	        %>
  	        <div class="prgbar-container"><%=encodeProgressBar(list, cat.QuantityMax.getInt())%></div>
  	      </td>
  	      <td align="right"><%=Math.round(100f * cat.QuantityFree.getFloat() / cat.QuantityMax.getFloat())%>%</td>
  	      <td align="right"><%=cat.QuantityMax.getInt()%></td>
  	      <td align="right"><%=cat.QuantityFree.getInt()%></td>
  	      <td align="right" class="seat-quantity-cell" data-HoldStatus="held">
  	          <%=cat.QuantityHeld.getInt()%>
  	      </td>
  	      <td align="right" class="seat-quantity-cell" data-HoldStatus="reserved">
  	          <%=cat.QuantityReserved.getInt()%>
  	      <td align="right" class="seat-quantity-cell" data-HoldStatus="paid">
  	          <%=cat.QuantityPaid.getInt()%>
  	      </td>
  	    </tr>
        <% } %>
      <% } %>
  <% } %>
</v:grid>

<script>
$(".seat-quantity-cell").click(function() {
  var srcTR = $(this).parents("tr.seat-cat-row");
  var seatSectorId = srcTR.attr("data-SeatSectorId"); 
  var seatCategoryId = srcTR.attr("data-SeatCategoryId");
  var status = $(this).attr("data-HoldStatus");
  
  var id = "tr_" + seatSectorId + "_" + seatCategoryId + "_" + status;
  var exists = ($("#" + id).length > 0);
  
  $(".seat-quantity-cell.selected").removeClass("selected");
  $("tr.hold-detail").remove();
  
  if (!exists) {
    $(this).addClass("selected");
    var tr = $("<tr id='" + id + "' class='hold-detail'/>").insertAfter(srcTR);
    var td = $("<td class='hold-detail-cell' colspan='100%'/>").appendTo(tr);
    var div = $("<div class='grid-detail-content'/>").appendTo(td);
    asyncLoad(div, "<v:config key="site_url"/>/admin?page=widget&jsp=seat/seat_hold_widget&SeatSectorId=" + seatSectorId + "&SeatCategoryId=" + seatCategoryId + "&status=" + status + "&PerformanceId=<%=performanceId%>");
  }
});
</script>