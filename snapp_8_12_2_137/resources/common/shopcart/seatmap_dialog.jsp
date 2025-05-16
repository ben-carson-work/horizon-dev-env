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

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<%
BOSessionBean boSession = (pageBase == null) ? null : (BOSessionBean)pageBase.getSession(); 

DOSeatMap map = pageBase.getBL(BLBO_Seat.class).loadSeatMap(pageBase.getId());
request.setAttribute("map", map);

String holdId = pageBase.getParameter("HoldId");
String activeCategoryId = pageBase.getParameter("ActiveCategoryId");

String[] itemSeatIDs = new String[0];
String sItemSeatIDs = pageBase.getEmptyParameter("SeatIDs").trim();
if (sItemSeatIDs.length() > 0)
  itemSeatIDs = JvArray.stringToArray(sItemSeatIDs, ",");

String accountId = boSession.getWorkstationType().isLookup(LkSNWorkstationType.B2B) ? boSession.getOrgAccountId() : null;
String[] perfEnvelopeIDs = pageBase.getBL(BLBO_Performance.class).getSeatEnvelopeIDs(map.PerformanceId.getString());
String[] envelopeIDs = pageBase.getBL(BLBO_Seat.class).getSessionEnvelopeIDs(accountId, perfEnvelopeIDs);

String[] cartSeatIDs = pageBase.getDB().getStrings(
    "select" + JvString.CRLF +
    "  SPL.SeatId" + JvString.CRLF +
    "from" + JvString.CRLF +
    "  tbSeatHold SH inner join" + JvString.CRLF +
    "  tbSeatPerformanceLink SPL on SPL.EntityId=SH.SeatHoldId" + JvString.CRLF +
    "where" + JvString.CRLF +
    "  SH.HoldId=" + JvString.sqlStr(holdId) + " and" + JvString.CRLF +
    "  SPL.PerformanceId=" + map.PerformanceId.getSqlString());

String[] freeSeatIDs = pageBase.getDB().getStrings(
    "select SeatId" + JvString.CRLF +
    "from tbSeatPerformance" + JvString.CRLF +
    "where" + JvString.CRLF +
    "  PerformanceId=" + map.PerformanceId.getSqlString() + " and" + JvString.CRLF +
    "  AttributeItemId=" + JvString.sqlStr(activeCategoryId) + " and" + JvString.CRLF +
    "  SeatEnvelopeId in " + JvArray.escapeSql(envelopeIDs) + " and" + JvString.CRLF +
    "  (" + JvString.CRLF +
    ((cartSeatIDs.length == 0) ? "" : "    SeatId in " + JvArray.escapeSql(cartSeatIDs) + " or" + JvString.CRLF) +
    "   QuantityFree>0" + JvString.CRLF +
    "  )");

%>

<v:dialog id="seatmap_dialog" title="@Seat.SeatMap" autofocus="false" resizable="false">

<style>
  .seat_map_dialog_class {
    position: fixed !important;
    top: 10px !important;
    bottom: 10px !important;
    left: 10px !important;
    right: 10px !important;
    width: initial !important;
  }
  
  .seat_map_dialog_class .ui-dialog-content {
    position: absolute;
    top: 40px;
    bottom: 0;
    left: 0;
    right: 0;
  }

  #seatmap_dialog {
    padding: 0;
  }

  #seatmap_dialog .v-button {
    min-width: 100px;
  }
  
  .vse-seat {
    stroke: black;
    stroke-width: 0.6;
    fill: var(--base-gray-color);
  }
  
  .vse-seat.active-envelope.active-category:not(.cart-hold):not(.item-hold) {
    fill: var(--base-red-color);
  }
  
  .vse-seat.active-envelope.active-category.seat-available:not(.cart-hold):not(.item-hold) {
    fill: var(--base-green-color);
  }
  
  .vse-seat.cart-hold {
    fill: var(--base-blue-color);
  }
  
  .vse-seat.item-hold {
    fill: var(--base-orange-color);
  }

  
  .vse-seat.vse-selected {
    stroke-dasharray: 3 2;
    stroke-width: 1.5;
  }
  
  .vse-seat.move-target-good {
    fill: var(--base-purple-color) !important;
  }
  
  .vse-seat.move-target-bad {
    fill: black !important;
  }
  
</style>

<jsp:include page="/resources/admin/seat/seat_map_widget.jsp"/>

<script>
var dlg = $("#seatmap_dialog");
dlg.on("snapp-dialog", function(event, params) {
  params.dialogClass = "seat_map_dialog_class";
});

$(".vse-seat[data-category='<%=activeCategoryId%>']").addClass("active-category");

<% for (String envelopeId : envelopeIDs) { %>
$(".vse-seat[data-envelope='<%=envelopeId%>'").addClass("active-envelope");
<% } %>

<% if (cartSeatIDs.length > 0) { %>
$("#<%=JvArray.arrayToString(cartSeatIDs, ",#")%>").addClass("cart-hold");
<% } %>

<% if (itemSeatIDs.length > 0) { %>
$("#<%=JvArray.arrayToString(itemSeatIDs, ",#")%>").addClass("item-hold");
<% } %>

<% if (freeSeatIDs.length > 0) { %>
$("#<%=JvArray.arrayToString(freeSeatIDs, ",#")%>").addClass("seat-available");
<% } %>

$(document).ready(function() {
  var svg_img = $(".vse-background-image");
  var urlo = svg_img.attr("xlink:href");
  if (urlo && (urlo != "")) {
    var img = new Image();
    img.src = urlo;
    img.onload = function() {
      svg_img.attr('height', this.height).attr('width', this.width);
    };
  }
  doRefreshSeatStatus();
});

var seatStatusLastUpdate = null;
var optimizedLastUpdate = null;
function doRefreshSeatStatus() {
  var reqDO = {
    Command: "LoadSeatStatus",
    LoadSeatStatus: {
      PerformanceId: <%=map.PerformanceId.getJsString()%>,
      LastUpdate: optimizedLastUpdate,
      IncludeCategoryRecap: true
    }
  };
  
  vgsService("Seat", reqDO, false, function(ansDO) {
    var list = ansDO.Answer.LoadSeatStatus.SeatList;
    if (list) {
      for (var i=0; i<list.length; i++) 
        $("#" + list[i].SeatId).setClass("seat-available", list[i].QuantityFree > 0);
    }
    
    /*
    if ($(".vse-map").attr("data-viewtype") == "status")
      renderCategoryStatus(ansDO.Answer.LoadSeatStatus.CategoryRecap);
    */
    
    if (ansDO.Answer.LoadSeatStatus.LastUpdate) {
      if (seatStatusLastUpdate != ansDO.Answer.LoadSeatStatus.LastUpdate) {
        seatStatusLastUpdate = ansDO.Answer.LoadSeatStatus.LastUpdate;
        optimizedLastUpdate = seatStatusLastUpdate;
      }
      else {
        var dt = xmlToDate(ansDO.Answer.LoadSeatStatus.LastUpdate);
        dt.setMilliseconds(dt.getMilliseconds() + 100);
        optimizedLastUpdate = dateToXML(dt);
      }
    }
    
    setTimeout(doRefreshSeatStatus, 1000);
  });
}


$(".vse-seat").click(function(event) {
  var seat = $(this);

  var edit = seat.is(".active-category.cart-hold") || seat.is(".active-category.item-hold");
  var selSeats = $(".vse-seat.vse-selected");
  var trgSeats = $(".vse-seat.move-target-good");
  var itemIndexes = [];
  
  if ((!edit || event.shiftKey) && (selSeats.length > 0) && (selSeats.length == trgSeats.length)) {
    var selSeatIDs = [];
    for (var i=0; i<selSeats.length; i++) {
      selSeatIDs.push($(selSeats[i]).attr("id"));
      if ($(selSeats[i]).is(".item-hold"))
        itemIndexes.push(i);
    }
    
    var trgSeatIDs = [];
    for (var i=0; i<trgSeats.length; i++)
      trgSeatIDs.push($(trgSeats[i]).attr("id"));
    
    doCmdShopCart({
      Command: "SeatManualPick",
      SeatManualPick: {
        PickList: [{
          Performance: {PerformanceId:<%=map.PerformanceId.getJsString()%>},
          SrcSeatIDs: selSeatIDs,
          DstSeatIDs: trgSeatIDs
        }]
      }
    }, function() {
      $("#" + selSeatIDs.join(",#")).removeClass("item-hold");
      $("#" + selSeatIDs.join(",#")).removeClass("cart-hold");
      $("#" + trgSeatIDs.join(",#")).addClass("cart-hold");
      
      for (var i=0; i<itemIndexes.length; i++) {
        var idx = itemIndexes[i];
        if (idx < trgSeatIDs.length)
          $("#" + trgSeatIDs[idx]).addClass("item-hold");
      }
    });
    
    $(".vse-seat.vse-selected").removeClass("vse-selected");
    clearMoveTarget();
  }
  else if (edit) {
    if (event.ctrlKey) 
      seat.toggleClass("vse-selected");
    else if (selSeats.length == 0) {
      var prevSeat = null;
      do {
        //prevSeat = $(".vse-seat.active-category.cart-hold[data-nextseatid='" + seat.attr("id") + "']");
        prevSeat = $(".vse-seat.active-category[data-nextseatid='" + seat.attr("id") + "']").filter(".cart-hold,.item-hold");
        if (prevSeat.length > 0)
          seat = prevSeat;
      } while (prevSeat.length > 0);
      
      while (seat.is(".active-category.cart-hold") || seat.is(".active-category.item-hold")) {
        seat.addClass("vse-selected");
        seat = $("#" + seat.attr("data-nextseatid"));
      }
    }
    else if (seat.is(".vse-selected")) {
      $(".vse-seat.vse-selected").removeClass("vse-selected");
      if (selSeats.length > 1)
        seat.addClass("vse-selected");
    }
    else {
      $(".vse-seat.vse-selected").removeClass("vse-selected");
      seat.addClass("vse-selected");
    }
  }  
});

function clearMoveTarget() {
  $(".vse-seat.move-target-good").removeClass("move-target-good");
  $(".vse-seat.move-target-bad").removeClass("move-target-bad");
}

var mouseIn = false;

$(".vse-seat").mouseleave(function(event) {
  mouseIn = false;
  setTimeout(function() {
    if (!mouseIn) 
      clearMoveTarget();
  }, 200);
});

$(".vse-seat").mouseenter(function(event) {
  mouseIn = true;
  var selCount = $(".vse-seat.vse-selected").length;
  if (selCount > 0) {
    clearMoveTarget();
    var seat = $(this);
    var seats = [];
    for (var i=0; i<selCount; i++) {
      seat = seat.filter(".seat-available");
      if (seat.length > 0)
        seats.push(seat[0]);
      else
        break;
      seat = $("#" + seat.attr("data-nextseatid"));
    }
    
    $(seats).addClass((seats.length == selCount) ? "move-target-good" : "move-target-bad");
  }
});
</script>

</v:dialog>